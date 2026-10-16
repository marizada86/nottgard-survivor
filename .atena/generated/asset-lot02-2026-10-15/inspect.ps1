$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskAssemblies=@([System.Drawing.Bitmap].Assembly.Location,[System.Drawing.Color].Assembly.Location,'System.Runtime','System.ComponentModel.Primitives')
$taskAssemblies+=@(Get-ChildItem -LiteralPath (Split-Path ([System.Drawing.Bitmap].Assembly.Location)) -Filter 'System.Private.Windows*.dll' | ForEach-Object {$_.FullName})
Add-Type -ReferencedAssemblies $taskAssemblies -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;
public static class LotInspect {
 static bool Fore(Color c,bool alpha) { return alpha?c.A>=16:!(c.R>180&&c.B>180&&c.G<100); }
 static Rectangle Box(Bitmap b,bool alpha,Rectangle roi) {
  int minX=roi.Right,minY=roi.Bottom,maxX=-1,maxY=-1;
  for(int y=roi.Top;y<roi.Bottom;y++) for(int x=roi.Left;x<roi.Right;x++) if(Fore(b.GetPixel(x,y),alpha)) {
   minX=Math.Min(minX,x);minY=Math.Min(minY,y);maxX=Math.Max(maxX,x);maxY=Math.Max(maxY,y);
  }
  if(maxX<0) throw new Exception("Conteúdo ausente");
  return Rectangle.FromLTRB(minX,minY,maxX+1,maxY+1);
 }
 static Graphics G(Bitmap b) {var g=Graphics.FromImage(b);g.InterpolationMode=InterpolationMode.NearestNeighbor;g.PixelOffsetMode=PixelOffsetMode.Half;return g;}
 static void Fit(Graphics g,Bitmap src,Rectangle crop,Rectangle area) {
  double scale=Math.Min((double)area.Width/crop.Width,(double)area.Height/crop.Height);
  int w=(int)Math.Round(crop.Width*scale),h=(int)Math.Round(crop.Height*scale);
  g.DrawImage(src,new Rectangle(area.X+(area.Width-w)/2,area.Y+(area.Height-h)/2,w,h),crop,GraphicsUnit.Pixel);
 }
 public static int[] Inspect(string path,bool alpha,int half,string outDir,string code) {
  using(var b=new Bitmap(path)) {
   Rectangle roi=half<0?new Rectangle(0,0,b.Width,b.Height):new Rectangle(half*(b.Width/2),0,b.Width/2,b.Height);
   Rectangle box=Box(b,alpha,roi); int edge=0,zero=0,partial=0,opaque=0;
   for(int y=0;y<b.Height;y++) for(int x=0;x<b.Width;x++) {
    Color p=b.GetPixel(x,y); if(p.A==0)zero++;else if(p.A==255)opaque++;else partial++;
    if((x==0||y==0||x==b.Width-1||y==b.Height-1)&&Fore(p,alpha))edge++;
   }
   using(var p=new Bitmap(256,256,PixelFormat.Format32bppArgb)) {
    using(var g=G(p)) {
     if(alpha) {for(int y=0;y<256;y+=16)for(int x=0;x<256;x+=16)using(var br=new SolidBrush((x/16+y/16)%2==0?Color.FromArgb(75,75,75):Color.FromArgb(125,125,125)))g.FillRectangle(br,x,y,16,16);}
     else g.Clear(Color.Magenta);
     Fit(g,b,box,new Rectangle(12,12,232,232));
    } p.Save(Path.Combine(outDir,code+"-review-256.png"),ImageFormat.Png);
   }
   int small=code=="UI01"?180:code=="PR01"?256:(code=="UI02-A"||code=="UI02-B")?32:64;
   int height=code=="UI01"?Math.Max(1,(int)Math.Round(box.Height*180.0/box.Width)):small;
   using(var p=new Bitmap(small,height,PixelFormat.Format32bppArgb)) {
    using(var g=G(p)){g.Clear(Color.FromArgb(24,28,32));Fit(g,b,box,new Rectangle(0,0,small,height));}
    p.Save(Path.Combine(outDir,code+"-small.png"),ImageFormat.Png);
   }
   int sampleMin=255,sampleMax=0,sampleSum=0,sampleCount=0;
   for(int y=box.Y+box.Height/5;y<box.Y+box.Height*3/4;y+=16)for(int x=box.X+box.Width*45/100;x<box.X+box.Width*55/100;x+=8){int a=b.GetPixel(x,y).A;sampleMin=Math.Min(sampleMin,a);sampleMax=Math.Max(sampleMax,a);sampleSum+=a;sampleCount++;}
   return new int[]{b.Width,b.Height,box.X,box.Y,box.Width,box.Height,edge,zero,partial,opaque,sampleMin,sampleMax,sampleCount==0?0:sampleSum/sampleCount};
  }
 }
 public static void Board(string dir) {
  string[] codes={"UI01","UI02-A","UI02-B","UI03","UI04","PR01"};
  string[] names={"Moldura de progresso","Marcador do jogador","Marcador do chefe","Catálogo bloqueado","Catálogo desbloqueado","Pilar completo"};
  using(var b=new Bitmap(1536,900)) using(var font=new Font(FontFamily.GenericSansSerif,19)) using(var small=new Font(FontFamily.GenericSansSerif,12)) {
   using(var g=G(b)) {
    g.Clear(Color.FromArgb(24,28,32));
    for(int i=0;i<codes.Length;i++) {
     int x=(i%3)*512,y=(i/3)*450;
     g.DrawString(codes[i]+" v01 - DRAFT",font,Brushes.White,x+20,y+12);
     g.DrawString(names[i],small,Brushes.LightGray,x+20,y+46);
     using(var p=new Bitmap(Path.Combine(dir,codes[i]+"-review-256.png")))g.DrawImageUnscaled(p,x+128,y+78);
     g.DrawString("Prévia reduzida (QA)",small,Brushes.LightGray,x+20,y+347);
     using(var p=new Bitmap(Path.Combine(dir,codes[i]+"-small.png"))) {
      if(codes[i]!="PR01")g.DrawImageUnscaled(p,x+20,y+375);
     }
    }
   } b.Save(Path.Combine(dir,"review-board.png"),ImageFormat.Png);
  }
 }
}
'@
$taskItems=@(
 @{code='UI01';source='UI01';half=-1;alpha=$false},
 @{code='UI02-A';source='UI02';half=0;alpha=$false},
 @{code='UI02-B';source='UI02';half=1;alpha=$false},
 @{code='UI03';source='UI03';half=-1;alpha=$false},
 @{code='UI04';source='UI04';half=-1;alpha=$false},
 @{code='PR01';source='PR01';half=-1;alpha=$true}
)
$taskResults=@()
foreach($taskItem in $taskItems){
 $taskSource='.atena/generated/art-candidates/asset-lot02/'+$taskItem.source+'_v01.png'
 $taskValues=[LotInspect]::Inspect((Join-Path $taskRoot $taskSource),$taskItem.alpha,$taskItem.half,$PSScriptRoot,$taskItem.code)
 $taskResults += [ordered]@{code=$taskItem.code;revision='v01';source=$taskSource;width=$taskValues[0];height=$taskValues[1];bbox_xywh=@($taskValues[2..5]);bbox_method=if($taskItem.alpha){'alpha >= 16, QA crop only'}else{'non-magenta broad threshold'};source_edge_foreground_pixels=$taskValues[6];source_alpha_zero_pixels=$taskValues[7];source_alpha_partial_pixels=$taskValues[8];source_alpha_opaque_pixels=$taskValues[9];center_alpha_sample_min=$taskValues[10];center_alpha_sample_max=$taskValues[11];center_alpha_sample_mean_floor=$taskValues[12];half=$taskItem.half;sha256=(Get-FileHash -LiteralPath (Join-Path $taskRoot $taskSource) -Algorithm SHA256).Hash}
}
foreach($taskRef in (Get-Content (Join-Path $PSScriptRoot 'references.json') -Raw | ConvertFrom-Json)) {
 if((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskRef.path) -Algorithm SHA256).Hash -ne $taskRef.sha256){throw 'Referência alterada'}
}
[LotInspect]::Board($PSScriptRoot)
$taskResults|ConvertTo-Json -Depth 5|Set-Content (Join-Path $PSScriptRoot 'inspection.json') -Encoding UTF8
$taskResults|ConvertTo-Json -Depth 5
