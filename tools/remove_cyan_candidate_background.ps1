param(
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][string]$OutputPath
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Source image not found: $SourcePath"
}
if (Test-Path -LiteralPath $OutputPath) {
    throw "Refusing to overwrite existing output: $OutputPath"
}

if (-not ("Nottgard.Animation.CyanCandidateBackground" -as [type])) {
    Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

namespace Nottgard.Animation {
    public static class CyanCandidateBackground {
        private static bool IsCyan(byte r, byte g, byte b) {
            return r <= 120 && g >= 100 && b >= 100 &&
                   g - r >= 28 && b - r >= 28;
        }

        public static int Remove(string sourcePath, string outputPath) {
            using (var input = new Bitmap(sourcePath))
            using (var bitmap = new Bitmap(input.Width, input.Height, PixelFormat.Format32bppArgb)) {
                using (var graphics = Graphics.FromImage(bitmap)) {
                    graphics.CompositingMode = System.Drawing.Drawing2D.CompositingMode.SourceCopy;
                    graphics.DrawImageUnscaled(input, 0, 0);
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
                    if (visited[index]) return;
                    int offset = y * stride + x * 4;
                    if (IsCyan(pixels[offset + 2], pixels[offset + 1], pixels[offset])) {
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

                int[] dx = { -1, 1, 0, 0, -1, 1, -1, 1 };
                int[] dy = { 0, 0, -1, 1, -1, -1, 1, 1 };
                while (head < tail) {
                    int index = queue[head++];
                    int x = index % bitmap.Width;
                    int y = index / bitmap.Width;
                    for (int direction = 0; direction < 8; direction++) {
                        int nx = x + dx[direction], ny = y + dy[direction];
                        if (nx < 0 || ny < 0 || nx >= bitmap.Width || ny >= bitmap.Height) continue;
                        int nextIndex = ny * bitmap.Width + nx;
                        if (visited[nextIndex]) continue;
                        int offset = ny * stride + nx * 4;
                        if (!IsCyan(pixels[offset + 2], pixels[offset + 1], pixels[offset])) continue;
                        visited[nextIndex] = true;
                        queue[tail++] = nextIndex;
                    }
                }

                int removed = 0;
                for (int y = 0; y < bitmap.Height; y++) {
                    for (int x = 0; x < bitmap.Width; x++) {
                        int offset = y * stride + x * 4;
                        if (IsCyan(pixels[offset + 2], pixels[offset + 1], pixels[offset])) {
                            pixels[offset + 3] = 0;
                            removed++;
                        }
                    }
                }
                Marshal.Copy(pixels, 0, data.Scan0, pixels.Length);
                bitmap.UnlockBits(data);
                bitmap.Save(outputPath, ImageFormat.Png);
                return removed;
            }
        }
    }
}
"@
}

$resolvedSource = (Resolve-Path -LiteralPath $SourcePath).Path
$resolvedOutput = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
    [System.IO.Path]::GetFullPath($OutputPath)
} else {
    Join-Path (Get-Location) $OutputPath
}
$directory = Split-Path -Parent $resolvedOutput
if ($directory) { New-Item -ItemType Directory -Force -Path $directory | Out-Null }
$removed = [Nottgard.Animation.CyanCandidateBackground]::Remove($resolvedSource, $resolvedOutput)
[PSCustomObject]@{ source = $SourcePath; output = $OutputPath; removed_pixels = $removed }
