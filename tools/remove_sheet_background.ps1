param(
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][string]$OutputPath,
    [int]$Threshold = 14
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Source sheet not found: $SourcePath"
}

if (-not ("Nottgard.Animation.BackgroundStripper" -as [type])) {
    Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

namespace Nottgard.Animation {
    public static class BackgroundStripper {
        public static void Remove(string sourcePath, string outputPath, int threshold) {
            using (var input = new Bitmap(sourcePath))
            using (var bitmap = new Bitmap(input.Width, input.Height, PixelFormat.Format32bppArgb)) {
                using (var g = Graphics.FromImage(bitmap)) {
                    g.CompositingMode = System.Drawing.Drawing2D.CompositingMode.SourceCopy;
                    g.DrawImageUnscaled(input, 0, 0);
                }

                var rect = new Rectangle(0, 0, bitmap.Width, bitmap.Height);
                var data = bitmap.LockBits(rect, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
                int stride = Math.Abs(data.Stride);
                byte[] pixels = new byte[stride * bitmap.Height];
                Marshal.Copy(data.Scan0, pixels, 0, pixels.Length);

                int count = bitmap.Width * bitmap.Height;
                bool[] visited = new bool[count];
                int[] queue = new int[count];
                int head = 0, tail = 0;

                Action<int, int> seed = (x, y) => {
                    int index = y * bitmap.Width + x;
                    if (!visited[index]) {
                        visited[index] = true;
                        queue[tail++] = index;
                    }
                };
                for (int x = 0; x < bitmap.Width; x++) {
                    seed(x, 0);
                    seed(x, bitmap.Height - 1);
                }
                for (int y = 1; y < bitmap.Height - 1; y++) {
                    seed(0, y);
                    seed(bitmap.Width - 1, y);
                }

                int thresholdSquared = threshold * threshold * 3;
                int[] dx = { -1, 1, 0, 0, -1, 1, -1, 1 };
                int[] dy = { 0, 0, -1, 1, -1, -1, 1, 1 };
                while (head < tail) {
                    int index = queue[head++];
                    int x = index % bitmap.Width;
                    int y = index / bitmap.Width;
                    int offset = y * stride + x * 4;
                    int b = pixels[offset];
                    int g = pixels[offset + 1];
                    int r = pixels[offset + 2];

                    for (int direction = 0; direction < 8; direction++) {
                        int nx = x + dx[direction];
                        int ny = y + dy[direction];
                        if (nx < 0 || ny < 0 || nx >= bitmap.Width || ny >= bitmap.Height) continue;
                        int nextIndex = ny * bitmap.Width + nx;
                        if (visited[nextIndex]) continue;
                        int nextOffset = ny * stride + nx * 4;
                        int db = pixels[nextOffset] - b;
                        int dg = pixels[nextOffset + 1] - g;
                        int dr = pixels[nextOffset + 2] - r;
                        int distance = db * db + dg * dg + dr * dr;
                        if (distance <= thresholdSquared) {
                            visited[nextIndex] = true;
                            queue[tail++] = nextIndex;
                        }
                    }
                }

                int removed = 0;
                for (int y = 0; y < bitmap.Height; y++) {
                    for (int x = 0; x < bitmap.Width; x++) {
                        int index = y * bitmap.Width + x;
                        if (!visited[index]) continue;
                        pixels[y * stride + x * 4 + 3] = 0;
                        removed++;
                    }
                }
                Marshal.Copy(pixels, 0, data.Scan0, pixels.Length);
                bitmap.UnlockBits(data);
                bitmap.Save(outputPath, ImageFormat.Png);
                Console.WriteLine("removed_pixels=" + removed);
            }
        }
    }
}
"@
}

$directory = Split-Path -Parent $OutputPath
if ($directory) { New-Item -ItemType Directory -Force -Path $directory | Out-Null }
$resolvedSource = (Resolve-Path -LiteralPath $SourcePath).Path
$resolvedOutput = Join-Path (Get-Location) $OutputPath
[Nottgard.Animation.BackgroundStripper]::Remove($resolvedSource, $resolvedOutput, $Threshold)

[PSCustomObject]@{
    source = $SourcePath
    output = $OutputPath
    threshold = $Threshold
}
