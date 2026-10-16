$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskAssemblies=@([System.Drawing.Bitmap].Assembly.Location,[System.Drawing.Color].Assembly.Location,'System.Runtime','System.ComponentModel.Primitives')
$taskAssemblies+=@(Get-ChildItem -LiteralPath (Split-Path ([System.Drawing.Bitmap].Assembly.Location)) -Filter 'System.Private.Windows*.dll'|ForEach-Object {$_.FullName})
Add-Type -ReferencedAssemblies $taskAssemblies -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;
public static class LogoInspect {
 static bool Bg(Color c){return c.G>180&&c.B>180&&c.R<100;}
 static Graphics G(Bitmap b){var g=Graphics.FromImage(b);g.InterpolationMode=InterpolationMode.NearestNeighbor;g.PixelOffsetMode=PixelOffsetMode.Half;return g;}
 public static double[] Run(string file,string dir) {
  using(var b=new Bitmap(file)) {
   int minX=b.Width,minY=b.Height,maxX=-1,maxY=-1,edge=0;
   for(int y=0;y<b.Height;y++)for(int x=0;x<b.Width;x++)if(!Bg(b.GetPixel(x,y))){minX=Math.Min(minX,x);minY=Math.Min(minY,y);maxX=Math.Max(maxX,x);maxY=Math.Max(maxY,y);if(x==0||y==0||x==b.Width-1||y==b.Height-1)edge++;}
   Rectangle crop=Rectangle.FromLTRB(minX,minY,maxX+1,maxY+1);
   double scale=Math.Min(1100.0/crop.Width,176.0/crop.Height);
   int w=(int)Math.Round(crop.Width*scale),h=(int)Math.Round(crop.Height*scale);
   using(var p=new Bitmap(w,h)) {using(var g=G(p)){g.Clear(Color.Cyan);g.DrawImage(b,new Rectangle(0,0,w,h),crop,GraphicsUnit.Pixel);}p.Save(Path.Combine(dir,"LN01-fit-1100x176-preview.png"),ImageFormat.Png);}
   using(var p=new Bitmap(640,176)) {using(var g=G(p)){g.Clear(Color.FromArgb(24,28,32));double s=Math.Min(640.0/crop.Width,176.0/crop.Height);int pw=(int)Math.Round(crop.Width*s),ph=(int)Math.Round(crop.Height*s);g.DrawImage(b,new Rectangle((640-pw)/2,(176-ph)/2,pw,ph),crop,GraphicsUnit.Pixel);}p.Save(Path.Combine(dir,"LN01-small-preview.png"),ImageFormat.Png);}
   // Zoom lower text for human spelling review; QA crop only, not an asset.
   Rectangle line=new Rectangle(300,570,950,65);
   using(var p=new Bitmap(line.Width,line.Height)){using(var g=G(p)){g.DrawImage(b,new Rectangle(0,0,line.Width,line.Height),line,GraphicsUnit.Pixel);}p.Save(Path.Combine(dir,"LN01-subtitle-proof.png"),ImageFormat.Png);}
   return new double[]{b.Width,b.Height,minX,minY,crop.Width,crop.Height,(double)crop.Width/crop.Height,edge,w,h,scale};
  }
 }
}
'@
$taskSource=Join-Path $taskRoot '.atena/generated/art-candidates/lettering/LN01_v01.png'
$taskValues=[LogoInspect]::Run($taskSource,$PSScriptRoot)
foreach($taskRef in (Get-Content (Join-Path $PSScriptRoot 'references.json') -Raw|ConvertFrom-Json)){if((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskRef.snapshot) -Algorithm SHA256).Hash -ne $taskRef.sha256){throw 'Snapshot de referência alterado'}}
[ordered]@{revision='v01';width=$taskValues[0];height=$taskValues[1];bbox_xywh=@($taskValues[2..5]);bbox_method='non-cyan broad threshold';foreground_aspect=$taskValues[6];noncyan_edge_pixels=$taskValues[7];fit_width=$taskValues[8];fit_height=$taskValues[9];fit_scale=$taskValues[10];source_sha256=(Get-FileHash -LiteralPath $taskSource -Algorithm SHA256).Hash;proof_crop_xywh=@(300,570,950,65);subtitle_glyph_y_observed=@(583,626);subtitle_height_source_approx=44;subtitle_height_at_fit_approx=(44*$taskValues[10]);subtitle_measurement_basis='Manual visual glyph bounds, not automated OCR or runtime'} | ConvertTo-Json -Depth 4 | Set-Content (Join-Path $PSScriptRoot 'inspection.json') -Encoding UTF8
Get-Content (Join-Path $PSScriptRoot 'inspection.json') -Raw
