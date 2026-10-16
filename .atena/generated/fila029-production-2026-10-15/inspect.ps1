$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$taskRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskAssemblies = @([System.Drawing.Bitmap].Assembly.Location,[System.Drawing.Color].Assembly.Location,'System.Runtime','System.ComponentModel.Primitives')
$taskAssemblies += @(Get-ChildItem -LiteralPath (Split-Path ([System.Drawing.Bitmap].Assembly.Location)) -Filter 'System.Private.Windows*.dll' | ForEach-Object {$_.FullName})
Add-Type -ReferencedAssemblies $taskAssemblies -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;
public static class ButtonInspect {
 static bool Bg(Color c) { return c.R>180 && c.B>180 && c.G<100; }
 static double L(Color c) { return .2126*c.R+.7152*c.G+.0722*c.B; }
 public static double[] Run(string file,string output,bool preview,string version) {
  using(var b=new Bitmap(file)) {
   int minX=b.Width,minY=b.Height,maxX=-1,maxY=-1,edge=0;
   for(int y=0;y<b.Height;y++) for(int x=0;x<b.Width;x++) if(!Bg(b.GetPixel(x,y))) {
    minX=Math.Min(minX,x); minY=Math.Min(minY,y); maxX=Math.Max(maxX,x); maxY=Math.Max(maxY,y);
    if(x==0||y==0||x==b.Width-1||y==b.Height-1) edge++;
   }
   int w=maxX-minX+1,h=maxY-minY+1;
   double low=255,high=0,sum=0; int count=0;
   for(int y=minY+(int)(h*.3);y<minY+(int)(h*.7);y++) for(int x=minX+(int)(w*.2);x<minX+(int)(w*.8);x++) {
    double l=L(b.GetPixel(x,y)); low=Math.Min(low,l); high=Math.Max(high,l); sum+=l; count++;
   }
   if(preview) {
    foreach(bool target in new bool[]{false,true}) {
     int height=target?64:(int)Math.Round(h*320.0/w);
     using(var p=new Bitmap(320,height,PixelFormat.Format32bppArgb)) {
      using(var g=Graphics.FromImage(p)) {
       g.Clear(Color.Magenta); g.InterpolationMode=InterpolationMode.NearestNeighbor; g.PixelOffsetMode=PixelOffsetMode.Half;
       g.DrawImage(b,new Rectangle(0,0,320,height),new Rectangle(minX,minY,w,h),GraphicsUnit.Pixel);
      }
      p.Save(Path.Combine(output,"B01-"+version+(target?"-target-320x64-preview.png":"-proportion-preview.png")),ImageFormat.Png);
     }
    }
   }
   return new double[]{b.Width,b.Height,minX,minY,maxX,maxY,w,h,(double)w/h,edge,low,high,high-low,sum/count};
  }
 }
}
'@
$taskResults=@()
foreach($taskVersion in @('v01','v02','v03')) {
    $taskSource=Join-Path $taskRoot ('.atena/generated/art-candidates/botao-acao/B01_'+$taskVersion+'.png')
    $taskValues=[ButtonInspect]::Run($taskSource,$PSScriptRoot,($taskVersion -ne 'v01'),$taskVersion)
    $taskResults += [ordered]@{revision=$taskVersion; width=$taskValues[0]; height=$taskValues[1]; foreground_bbox_inclusive=@($taskValues[2..5]); foreground_width=$taskValues[6]; foreground_height=$taskValues[7]; foreground_aspect=$taskValues[8]; nonmagenta_edge_pixels=$taskValues[9]; center_roi='x20..80%, y30..70% of foreground bbox'; center_luminance_min=$taskValues[10]; center_luminance_max=$taskValues[11]; center_luminance_range_255=$taskValues[12]; center_luminance_mean=$taskValues[13]; sha256=(Get-FileHash -LiteralPath $taskSource -Algorithm SHA256).Hash}
}
foreach($taskReference in (Get-Content (Join-Path $PSScriptRoot 'references.json') -Raw | ConvertFrom-Json)) {
    if((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskReference.path) -Algorithm SHA256).Hash -ne $taskReference.sha256) { throw 'Referência alterada' }
}
$taskResults | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $PSScriptRoot 'inspection.json') -Encoding UTF8
$taskResults | ConvertTo-Json -Depth 5
