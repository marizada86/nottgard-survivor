param([string]$Revision = 'v01')
$ErrorActionPreference = 'Stop'
if ($Revision -notmatch '^v[0-9]{2}$') { throw 'Revisão inválida' }
Add-Type -AssemblyName System.Drawing
$taskRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskReceipt = Get-Content (Join-Path $taskRoot '.atena/generated/fila030-review-2026-10-15/visual-acceptance.json') -Raw | ConvertFrom-Json
foreach ($taskSource in $taskReceipt.sources) {
    if ((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskSource.path) -Algorithm SHA256).Hash -ne $taskSource.sha256) { throw 'Hash de fonte divergente' }
}
$taskOut = Join-Path $PSScriptRoot $Revision
if (Test-Path -LiteralPath $taskOut) {
    if (@(Get-ChildItem -LiteralPath $taskOut -Force).Count -gt 0) { throw 'Destino já contém arquivos; use nova revisão' }
} else { New-Item -ItemType Directory -Path $taskOut | Out-Null }
$taskAssemblies = @([System.Drawing.Bitmap].Assembly.Location, [System.Drawing.Color].Assembly.Location, 'System.Runtime', 'System.ComponentModel.Primitives')
$taskAssemblies += @(Get-ChildItem -LiteralPath (Split-Path ([System.Drawing.Bitmap].Assembly.Location)) -Filter 'System.Private.Windows*.dll' | ForEach-Object { $_.FullName })
Add-Type -ReferencedAssemblies $taskAssemblies -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;
public static class FogPreparation {
 static double L(Color c) { return .2126*c.R + .7152*c.G + .0722*c.B; }
 static int A(Color c) { double l=L(c); return l<=2?0:(int)Math.Round(l); }
 static Bitmap Canvas(int w,int h) { return new Bitmap(w,h,PixelFormat.Format32bppArgb); }
 static void Save(Bitmap b,string dir,string name) { b.Save(Path.Combine(dir,name),ImageFormat.Png); }
 static Graphics G(Bitmap b) { var g=Graphics.FromImage(b); g.InterpolationMode=InterpolationMode.NearestNeighbor; g.PixelOffsetMode=PixelOffsetMode.Half; return g; }
 static void Draw(Graphics g,Bitmap b,int x,int y,int w,int h) { g.DrawImage(b,new Rectangle(x,y,w,h)); }
 public static string[] Run(string src1,string src2,string dir) {
 using(var s1=new Bitmap(src1)) using(var s2=new Bitmap(src2))
 using(var n1=Canvas(1536,384)) using(var n2=Canvas(1280,360)) {
  for(int y=0;y<384;y++) for(int x=0;x<1536;x++) {
   int sx=Math.Min(s1.Width-1,(int)((x+.5)*s1.Width/1536));
   int sy=Math.Min(s1.Height-1,(int)((y+.5)*s1.Height/384));
   n1.SetPixel(x,y,Color.FromArgb(y<128?0:A(s1.GetPixel(sx,sy)),224,232,240));
  }
  for(int y=0;y<384;y++) for(int d=0;d<64;d++) {
   int left=n1.GetPixel(d,y).A,right=n1.GetPixel(1535-d,y).A;
   double w=(63-d)/126.0;
   n1.SetPixel(d,y,Color.FromArgb((int)Math.Round(left*(1-w)+right*w),224,232,240));
   n1.SetPixel(1535-d,y,Color.FromArgb((int)Math.Round(right*(1-w)+left*w),224,232,240));
  }
  int minX=s2.Width,minY=s2.Height,maxX=-1,maxY=-1;
  for(int y=0;y<s2.Height;y++) for(int x=0;x<s2.Width;x++) if(L(s2.GetPixel(x,y))>2) {
   minX=Math.Min(minX,x); maxX=Math.Max(maxX,x); minY=Math.Min(minY,y); maxY=Math.Max(maxY,y);
  }
  if(maxY<minY) throw new Exception("NB02 sem conteúdo");
  // Preserve full source width, map entire non-background vertical extent below y=90.
  for(int y=0;y<360;y++) for(int x=0;x<1280;x++) {
   int alpha=0;
   if(y>=90) {
    int sx=Math.Min(s2.Width-1,(int)((x+.5)*s2.Width/1280));
    int sy=Math.Min(maxY,minY+(int)((y-90+.5)*(maxY-minY+1)/270));
    double side=Math.Min(1,Math.Min(x,1279-x)/(1280*.08));
    alpha=(int)Math.Round(A(s2.GetPixel(sx,sy))*side);
   }
   n2.SetPixel(x,y,Color.FromArgb(alpha,224,232,240));
  }
  Save(n1,dir,"nevoa_mundo_borda_01.png"); Save(n2,dir,"nevoa_mundo_frente_01.png");
  using(var p=Canvas(1536,128)) { using(var g=G(p)) { g.Clear(Color.FromArgb(24,28,32)); for(int t=0;t<3;t++) Draw(g,n1,t*512,0,512,128); } Save(p,dir,"NB01-repeat-3x1.png"); }
  using(var p=Canvas(1536,384)) { using(var g=G(p)) { g.Clear(Color.FromArgb(24,28,32)); for(int y=0;y<3;y++) for(int x=0;x<3;x++) Draw(g,n1,x*512,y*128,512,128); } Save(p,dir,"NB01-repeat-3x3.png"); }
  foreach(int depth in new int[]{80,360}) using(var p=Canvas(1280,depth)) { using(var g=G(p)) { g.Clear(Color.FromArgb(24,28,32)); Draw(g,n2,0,0,1280,depth); } Save(p,dir,"NB02-depth-"+depth+".png"); }
  using(var p=Canvas(1536,810)) using(var font=new Font(FontFamily.GenericSansSerif,17)) {
   using(var g=G(p)) {
    for(int row=0;row<3;row++) {
     Color bg=row==0?Color.FromArgb(24,28,32):Color.FromArgb(232,232,232);
     using(var brush=new SolidBrush(bg)) g.FillRectangle(brush,0,row*270,1536,270);
     if(row==2) for(int yy=540;yy<810;yy+=16) for(int xx=0;xx<1536;xx+=16) {
      using(var brush=new SolidBrush(((xx/16+yy/16)%2)==0?Color.FromArgb(110,110,110):Color.FromArgb(180,180,180))) g.FillRectangle(brush,xx,yy,16,16);
     }
     g.DrawString("NB01 - "+(row==0?"escuro":row==1?"claro":"quadriculado"),font,row==0?Brushes.White:Brushes.Black,12,row*270+8);
     g.DrawString("NB02",font,row==0?Brushes.White:Brushes.Black,780,row*270+8);
     Draw(g,n1,0,row*270+48,768,192); Draw(g,n2,768,row*270+48,768,216);
    }
   } Save(p,dir,"alpha-surfaces.png");
  }
  using(var p=Canvas(1536,560)) using(var font=new Font(FontFamily.GenericSansSerif,18)) {
   using(var g=G(p)) {
    g.Clear(Color.FromArgb(24,28,32));
    g.DrawString("NB01 fonte v01",font,Brushes.White,10,8); g.DrawString("NB01 preparada",font,Brushes.White,780,8);
    Draw(g,s1,0,45,768,192); Draw(g,n1,768,45,768,192);
    g.DrawString("NB02 fonte v01",font,Brushes.White,10,288); g.DrawString("NB02 preparada",font,Brushes.White,780,288);
    Draw(g,s2,0,332,768,216); Draw(g,n2,768,332,768,216);
   } Save(p,dir,"source-comparison.png");
  }
  return new string[]{minX.ToString(),minY.ToString(),maxX.ToString(),maxY.ToString()};
 }
 }
 public static int[] Inspect(string path,int topRows,bool seam) {
  using(var b=new Bitmap(path)) {
   int topMax=0,edgeMax=0,badRgb=0;
   for(int y=0;y<b.Height;y++) for(int x=0;x<b.Width;x++) {
    Color c=b.GetPixel(x,y); if(y<topRows) topMax=Math.Max(topMax,c.A);
    if(c.R!=224||c.G!=232||c.B!=240) badRgb++;
   }
   for(int y=0;y<b.Height;y++) edgeMax=Math.Max(edgeMax,seam?Math.Abs(b.GetPixel(0,y).A-b.GetPixel(b.Width-1,y).A):Math.Max(b.GetPixel(0,y).A,b.GetPixel(b.Width-1,y).A));
   return new int[]{b.Width,b.Height,topMax,edgeMax,badRgb,(int)b.PixelFormat};
  }
 }
}
'@
$taskBBox = [FogPreparation]::Run((Join-Path $taskRoot $taskReceipt.sources[0].path),(Join-Path $taskRoot $taskReceipt.sources[1].path),$taskOut)
$taskOutputs = @()
foreach ($taskCode in @('NB01','NB02')) {
    $taskName = if ($taskCode -eq 'NB01') {'nevoa_mundo_borda_01.png'} else {'nevoa_mundo_frente_01.png'}
    $taskPath = Join-Path $taskOut $taskName
    $taskTop = if ($taskCode -eq 'NB01') {128} else {90}
    $taskMetrics = [FogPreparation]::Inspect($taskPath,$taskTop,($taskCode -eq 'NB01'))
    $taskWidth = if ($taskCode -eq 'NB01') {1536} else {1280}
    $taskHeight = if ($taskCode -eq 'NB01') {384} else {360}
    if ($taskMetrics[0] -ne $taskWidth -or $taskMetrics[1] -ne $taskHeight -or $taskMetrics[2] -ne 0 -or $taskMetrics[3] -ne 0 -or $taskMetrics[4] -ne 0 -or $taskMetrics[5] -ne [int][System.Drawing.Imaging.PixelFormat]::Format32bppArgb) { throw "Falha na derivada $taskCode" }
    $taskOutputs += [ordered]@{code=$taskCode; file=$taskName; width=$taskMetrics[0]; height=$taskMetrics[1]; top_alpha_max=$taskMetrics[2]; edge_delta_or_alpha_max=$taskMetrics[3]; nonconstant_rgb_pixels=$taskMetrics[4]; format='RGBA8'; sha256=(Get-FileHash -LiteralPath $taskPath -Algorithm SHA256).Hash; checks='PASS'}
}
foreach ($taskSource in $taskReceipt.sources) {
    if ((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskSource.path) -Algorithm SHA256).Hash -ne $taskSource.sha256) { throw 'Fonte alterada durante preparação' }
}
[ordered]@{plan='FILA030-PREPARATION'; revision=$Revision; content_state='DRAFT'; runtime_admission=$false; human_visual_acceptance='PENDING'; sources=$taskReceipt.sources; original_hashes_preserved=$true; rgb=@(224,232,240); luminance=@(.2126,.7152,.0722); background_threshold_255=2; nb01=[ordered]@{resize='nearest-neighbor'; top_transparent_rows=128; horizontal_blend_band=64; vertical_seam_processing=$false}; nb02=[ordered]@{content_bbox_inclusive=@($taskBBox|ForEach-Object{[int]$_}); x_mapping='full source width to 1280'; y_mapping='content minY..maxY to output y=90..359, nearest-neighbor'; top_transparent_rows=90; side_fade_width=102.4}; outputs=$taskOutputs} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $taskOut 'manifest.json') -Encoding UTF8
$taskOutputs | ConvertTo-Json -Depth 4
