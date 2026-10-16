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
using System.Security.Cryptography;
public static class InteractionInspect {
 static Graphics G(Bitmap b){var g=Graphics.FromImage(b);g.InterpolationMode=InterpolationMode.NearestNeighbor;g.PixelOffsetMode=PixelOffsetMode.Half;return g;}
 static void Checker(Graphics g,int x0,int y0,int w,int h){for(int y=0;y<h;y+=16)for(int x=0;x<w;x+=16)using(var br=new SolidBrush((x/16+y/16)%2==0?Color.FromArgb(65,65,65):Color.FromArgb(105,105,105)))g.FillRectangle(br,x0+x,y0+y,Math.Min(16,w-x),Math.Min(16,h-y));}
 public static int[][] Run(string source,string dir,int cols,int rows,int count,string code){
  string frames=Path.Combine(dir,"frames",code);Directory.CreateDirectory(frames);
  using(var src=new Bitmap(source))using(var contact=new Bitmap(cols*256,rows*280))using(var font=new Font(FontFamily.GenericSansSerif,13)){
   int[][] result=new int[cols*rows][];
   using(var cg=G(contact)){
    cg.Clear(Color.FromArgb(24,28,32));
    for(int i=0;i<cols*rows;i++){
     int col=i%cols,row=i/cols;
     Rectangle cell=Rectangle.FromLTRB(col*src.Width/cols,row*src.Height/rows,(col+1)*src.Width/cols,(row+1)*src.Height/rows);
     using(var b=src.Clone(cell,PixelFormat.Format32bppArgb)){
      int minX=b.Width,minY=b.Height,maxX=-1,maxY=-1,visible=0,core=0,low=0,opaque=0,edge=0;
      int[] hist=new int[256];
      int coreMinX=b.Width,coreMinY=b.Height,coreMaxX=-1,coreMaxY=-1;
      for(int y=0;y<b.Height;y++)for(int x=0;x<b.Width;x++){
       int a=b.GetPixel(x,y).A;
       if(a==255)opaque++;
       if(a>0&&a<16)low++;
       if(a>=16){visible++;minX=Math.Min(minX,x);minY=Math.Min(minY,y);maxX=Math.Max(maxX,x);maxY=Math.Max(maxY,y);if(x<4||y<4||x>=b.Width-4||y>=b.Height-4)edge++;}
       if(a>=128){core++;hist[a]++;coreMinX=Math.Min(coreMinX,x);coreMinY=Math.Min(coreMinY,y);coreMaxX=Math.Max(coreMaxX,x);coreMaxY=Math.Max(coreMaxY,y);}
      }
      int mode=0;for(int a=128;a<256;a++)if(hist[a]>hist[mode])mode=a;
      result[i]=new int[]{src.Width,src.Height,cell.X,cell.Y,b.Width,b.Height,visible,core,low,opaque,edge,minX,minY,maxX,maxY,coreMinX,coreMinY,coreMaxX,coreMaxY,mode};
      if(i<count)b.Save(Path.Combine(frames,i.ToString("00")+".png"),ImageFormat.Png);
      Checker(cg,col*256,row*280,256,256);cg.DrawImage(b,new Rectangle(col*256,row*280,256,256));
      cg.DrawString(i<count?(i+1).ToString():"vazia esperada",font,Brushes.White,col*256+8,row*280+257);
     }
    }
   }
   contact.Save(Path.Combine(dir,code+"-contact.png"),ImageFormat.Png);
   return result;
  }
 }
 public static void Board(string dir){
  string[] codes={"QB01","QB02","QB03","QB04","QB05","QB06"};
  string[] titles={"Candelabro · 5 quadros","Caixote · 5 quadros","Arbusto fúngico · 5 quadros","Saco de esporos · 5 quadros","Casulo viscoso · 5 quadros","Urna funerária · 5 quadros"};
  using(var b=new Bitmap(1536,820))using(var f=new Font(FontFamily.GenericSansSerif,17)){
   using(var g=G(b)){
    g.Clear(Color.FromArgb(24,28,32));
    for(int i=0;i<codes.Length;i++){
     int x=(i%3)*512,y=(i/3)*410;g.DrawString(codes[i]+" — DRAFT",f,Brushes.White,x+14,y+10);g.DrawString(titles[i],f,Brushes.LightGray,x+14,y+42);
     using(var p=new Bitmap(Path.Combine(dir,codes[i]+"-contact.png"))){double s=Math.Min(496.0/p.Width,300.0/p.Height);int w=(int)Math.Round(p.Width*s),h=(int)Math.Round(p.Height*s);g.DrawImage(p,new Rectangle(x+(512-w)/2,y+85,w,h));}
    }
   }b.Save(Path.Combine(dir,"review-board.png"),ImageFormat.Png);
  }
 }
}
'@
$taskSpecs=@(
 @{code='QB01';columns=3;rows=2;count=5;loop=$false;name='Candelabro'},
 @{code='QB02';columns=3;rows=2;count=5;loop=$false;name='Caixote'},
 @{code='QB03';columns=3;rows=2;count=5;loop=$false;name='Arbusto fúngico'},
 @{code='QB04';columns=3;rows=2;count=5;loop=$false;name='Saco de esporos'},
 @{code='QB05';columns=3;rows=2;count=5;loop=$false;name='Casulo viscoso'},
 @{code='QB06';columns=3;rows=2;count=5;loop=$false;name='Urna funerária'}
)
$taskResults=@()
foreach($taskSpec in $taskSpecs){
 $taskRevision=if($taskSpec.code -eq 'QB02'){'v03'}elseif($taskSpec.code -in @('QB03','QB05','QB06')){'v02'}else{'v01'}
 $taskSource='.atena/generated/animation-candidates/asset-lot04/'+$taskSpec.code+'_'+$taskRevision+'.png'
 $taskStats=[InteractionInspect]::Run((Join-Path $taskRoot $taskSource),$PSScriptRoot,$taskSpec.columns,$taskSpec.rows,$taskSpec.count,$taskSpec.code)
 $taskFrames=@()
 for($taskI=0;$taskI -lt $taskStats.Length;$taskI++){
  $taskF=$taskStats[$taskI]
  $taskFramePath=Join-Path $PSScriptRoot ('frames/'+$taskSpec.code+'/'+$taskI.ToString('00')+'.png')
  $taskFrames += [ordered]@{index=$taskI;expected_empty=($taskI -ge $taskSpec.count);cell_xywh=@($taskF[2..5]);alpha_ge16_pixels=$taskF[6];alpha_ge128_pixels=$taskF[7];alpha_1to15_pixels=$taskF[8];alpha255_pixels=$taskF[9];edge_band4_alpha_ge16_pixels=$taskF[10];visible_bbox_xyxy=@($taskF[11..14]);core_bbox_xyxy=@($taskF[15..18]);core_alpha_mode=$taskF[19];qa_frame=if($taskI -lt $taskSpec.count){'frames/'+$taskSpec.code+'/'+$taskI.ToString('00')+'.png'}else{$null};qa_sha256=if(Test-Path -LiteralPath $taskFramePath){(Get-FileHash -LiteralPath $taskFramePath -Algorithm SHA256).Hash}else{$null}}
 }
 $taskCoreBases=@($taskFrames|Where-Object {-not $_.expected_empty -and $_.alpha_ge128_pixels -gt 0}|ForEach-Object {$_.core_bbox_xyxy[3]})
 $taskRange=($taskCoreBases|Measure-Object -Maximum -Minimum)
 $taskHashes=@($taskFrames|Where-Object {-not $_.expected_empty}|ForEach-Object {$_.qa_sha256})
 $taskResults += [ordered]@{code=$taskSpec.code;name=$taskSpec.name;revision=$taskRevision;source=$taskSource;source_sha256=(Get-FileHash -LiteralPath (Join-Path $taskRoot $taskSource) -Algorithm SHA256).Hash;width=$taskStats[0][0];height=$taskStats[0][1];columns=$taskSpec.columns;rows=$taskSpec.rows;frame_count=$taskSpec.count;loop=$taskSpec.loop;core_base_spread_px=($taskRange.Maximum-$taskRange.Minimum);unique_qa_pixel_file_hashes=@($taskHashes|Select-Object -Unique).Count;frames=$taskFrames;human_visual_acceptance='PENDING';runtime_admission=$false}
}
foreach($taskRef in(Get-Content (Join-Path $PSScriptRoot 'references.json') -Raw|ConvertFrom-Json)){if((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskRef.path) -Algorithm SHA256).Hash -ne $taskRef.sha256){throw 'Referência alterada'}}
[InteractionInspect]::Board($PSScriptRoot)
$taskJson=$taskResults|ConvertTo-Json -Depth 9
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'inspection.json'),$taskJson,[System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'sequences.js'),('window.SEQUENCES = '+$taskJson+';'),[System.Text.UTF8Encoding]::new($false))
$taskResults|ForEach-Object{[ordered]@{code=$_.code;width=$_.width;height=$_.height;frames=$_.frame_count;base_spread=$_.core_base_spread_px;unique=$_.unique_qa_pixel_file_hashes;edge_pixels=(@($_.frames|ForEach-Object{$_.edge_band4_alpha_ge16_pixels})|Measure-Object -Sum).Sum;empty_cell_core=(@($_.frames|Where-Object expected_empty|ForEach-Object{$_.alpha_ge128_pixels})|Measure-Object -Sum).Sum}}|ConvertTo-Json
