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
      int rootMinY=b.Height,rootMaxY=-1; int left=0,right=0,top=0,bottom=0; int[] hist=new int[256];
      int coreMinX=b.Width,coreMinY=b.Height,coreMaxX=-1,coreMaxY=-1;
      for(int y=0;y<b.Height;y++)for(int x=0;x<b.Width;x++){
       int a=b.GetPixel(x,y).A;
       if(a==255)opaque++;
       if(a>0&&a<16)low++;
       if(a>=16){if(x<4)left++;if(x>=b.Width-4)right++;if(y<4)top++;if(y>=b.Height-4)bottom++;visible++;minX=Math.Min(minX,x);minY=Math.Min(minY,y);maxX=Math.Max(maxX,x);maxY=Math.Max(maxY,y);if(x<4||y<4||x>=b.Width-4||y>=b.Height-4)edge++;}
       if(a>=128){if(x<4){rootMinY=Math.Min(rootMinY,y);rootMaxY=Math.Max(rootMaxY,y);}core++;hist[a]++;coreMinX=Math.Min(coreMinX,x);coreMinY=Math.Min(coreMinY,y);coreMaxX=Math.Max(coreMaxX,x);coreMaxY=Math.Max(coreMaxY,y);}
      }
      int mode=0;for(int a=128;a<256;a++)if(hist[a]>hist[mode])mode=a;
      result[i]=new int[]{src.Width,src.Height,cell.X,cell.Y,b.Width,b.Height,visible,core,low,opaque,edge,minX,minY,maxX,maxY,coreMinX,coreMinY,coreMaxX,coreMaxY,mode,left,right,top,bottom,rootMinY,rootMaxY};
      if(i<count)b.Save(Path.Combine(frames,i.ToString("00")+".png"),ImageFormat.Png);if(i==0)Reading(Path.Combine(frames,"00.png"),dir,code,minX,minY,maxX-minX+1,maxY-minY+1);
      Checker(cg,col*256,row*280,256,256);double fit=Math.Min(256.0/b.Width,256.0/b.Height);int fw=(int)Math.Round(b.Width*fit),fh=(int)Math.Round(b.Height*fit);cg.DrawImage(b,new Rectangle(col*256+(256-fw)/2,row*280+(256-fh)/2,fw,fh));
      cg.DrawString(i<count?(i+1).ToString():"vazia esperada",font,Brushes.White,col*256+8,row*280+257);
     }
    }
   }
   contact.Save(Path.Combine(dir,code+"-contact.png"),ImageFormat.Png);
   return result;
  }
 }
 public static void IconSizes(string source,string dir){using(var src=new Bitmap(source))using(var board=new Bitmap(320,120))using(var font=new Font(FontFamily.GenericSansSerif,12)){using(var g=G(board)){g.Clear(Color.FromArgb(24,28,32));int x=16;foreach(int size in new int[]{32,48,64}){using(var b=new Bitmap(size,size))using(var bg=G(b)){bg.DrawImage(src,new Rectangle(0,0,size,size));b.Save(Path.Combine(dir,"FC01-"+size+".png"),ImageFormat.Png);Checker(g,x,10,size,size);g.DrawImage(b,new Rectangle(x,10,size,size));g.DrawString(size+" px",font,Brushes.White,x,82);}x+=size+32;}}board.Save(Path.Combine(dir,"FC01-size-preview.png"),ImageFormat.Png);}}
 public static void Reading(string path,string dir,string code,int x,int y,int w,int h){using(var src=new Bitmap(path))using(var crop=src.Clone(new Rectangle(x,y,w,h),PixelFormat.Format32bppArgb)){foreach(int height in new int[]{48,80,128}){int width=Math.Max(1,(int)Math.Round(w*height/(double)h));using(var b=new Bitmap(width,height))using(var g=G(b)){g.DrawImage(crop,new Rectangle(0,0,width,height));b.Save(Path.Combine(dir,code+"-reading-"+height+".png"),ImageFormat.Png);}}}}
 public static void Contact(string dir,string group,string[] codes){using(var b=new Bitmap(codes.Length*256,280))using(var font=new Font(FontFamily.GenericSansSerif,13)){using(var g=G(b)){g.Clear(Color.FromArgb(24,28,32));for(int i=0;i<codes.Length;i++)using(var src=new Bitmap(Path.Combine(dir,"frames",codes[i],"00.png"))){Checker(g,i*256,0,256,256);double fit=Math.Min(256.0/src.Width,256.0/src.Height);int w=(int)Math.Round(src.Width*fit),h=(int)Math.Round(src.Height*fit);g.DrawImage(src,new Rectangle(i*256+(256-w)/2,(256-h)/2,w,h));g.DrawString(codes[i],font,Brushes.White,i*256+8,258);}}b.Save(Path.Combine(dir,group+"-contact.png"),ImageFormat.Png);}}
 public static double[] Region(string path,int x,int y,int w,int h){using(var b=new Bitmap(path)){int zero=0,low=0,core=0;for(int yy=y;yy<y+h;yy++)for(int xx=x;xx<x+w;xx++){int a=b.GetPixel(xx,yy).A;if(a==0)zero++;else if(a<16)low++;if(a>=128)core++;}return new double[]{zero,low,core,w*h};}}
 public static double[] RootProxy(string path,int x){using(var b=new Bitmap(path)){int minY=b.Height,maxY=-1,count=0;double sumX=0,sumY=0;for(int yy=0;yy<b.Height;yy++)for(int xx=x;xx<Math.Min(b.Width,x+20);xx++){var c=b.GetPixel(xx,yy);if(c.A>=128){count++;sumX+=xx;sumY+=yy;minY=Math.Min(minY,yy);maxY=Math.Max(maxY,yy);}}return new double[]{x,minY,Math.Min(b.Width-1,x+19),maxY,count>0?sumX/count:-1,count>0?sumY/count:-1,count};}}
 public static void Board(string dir){
  string[] codes={"JI","JM","JA","JD","JS"};
  string[] titles={"Repouso · 4 fontes","Movimento · 6 fontes","Ataque · 4 fontes","Morte · 6 fontes","Especial · 6 fontes"};
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
$taskCodes=@('JI00','JI01','JI02','JI03','JM00','JM01','JM02','JM03','JM04','JM05','JA00','JA01','JA02','JA03','JD00','JD01','JD02','JD03','JD04','JD05','JS00','JS01','JS02','JS03','JS04','JS05')
$taskAssets=@()
foreach($taskCode in $taskCodes){
 $taskRev=if($taskCode -eq 'JI00'){'v02'}else{'v01'}
 $taskSource='.atena/generated/art-candidates/asset-lot13/'+$taskCode+'_'+$taskRev+'.png'
 $taskPath=Join-Path $taskRoot $taskSource
 $taskF=[InteractionInspect]::Run($taskPath,$PSScriptRoot,1,1,1,$taskCode)[0]
 $taskQa='frames/'+$taskCode+'/00.png'
 $taskMargin=@($taskF[11],$taskF[12],($taskF[4]-1-$taskF[13]),($taskF[5]-1-$taskF[14]))|Measure-Object -Minimum
 $taskAssets += [ordered]@{code=$taskCode;revision=$taskRev;source=$taskSource;source_link=('../art-candidates/asset-lot13/'+$taskCode+'_'+$taskRev+'.png');source_sha256=(Get-FileHash -LiteralPath $taskPath).Hash;width=$taskF[0];height=$taskF[1];qa_frame=$taskQa;qa_sha256=(Get-FileHash -LiteralPath (Join-Path $PSScriptRoot $taskQa)).Hash;alpha_ge16_pixels=$taskF[6];alpha_ge128_pixels=$taskF[7];alpha_1to15_pixels=$taskF[8];alpha255_pixels=$taskF[9];edge_band4_alpha_ge16_pixels=$taskF[10];visible_bbox_xyxy=@($taskF[11..14]);core_bbox_xyxy=@($taskF[15..18]);core_alpha_mode=$taskF[19];margin_min_px=$taskMargin.Minimum;human_visual_acceptance='PENDING';runtime_admission=$false}
}
$taskGroups=@()
foreach($taskGroup in @('JI','JM','JA','JD','JS')){
 $taskItems=@($taskAssets|Where-Object {$_.code.StartsWith($taskGroup)})
 $taskFrames=@();$taskI=0
 foreach($taskItem in $taskItems){$taskFrames += [ordered]@{index=$taskI;code=$taskItem.code;revision=$taskItem.revision;source=$taskItem.source;source_link=$taskItem.source_link;source_sha256=$taskItem.source_sha256;qa_frame=$taskItem.qa_frame;qa_sha256=$taskItem.qa_sha256;visible_bbox_xyxy=$taskItem.visible_bbox_xyxy;core_bbox_xyxy=$taskItem.core_bbox_xyxy};$taskI++}
 $taskBases=@($taskItems|ForEach-Object {$_.core_bbox_xyxy[3]})|Measure-Object -Maximum -Minimum
 $taskCenters=@($taskItems|ForEach-Object {($_.core_bbox_xyxy[0]+$_.core_bbox_xyxy[2])/2})|Measure-Object -Maximum -Minimum
 $taskWidths=@($taskItems|ForEach-Object {$_.core_bbox_xyxy[2]-$_.core_bbox_xyxy[0]+1})|Measure-Object -Maximum -Minimum
 $taskGroups += [ordered]@{code=$taskGroup;name=switch($taskGroup){'JI'{'Repouso'}'JM'{'Movimento'}'JA'{'Ataque'}'JD'{'Morte'}'JS'{'Especial'}};revision='v01';width=$taskItems[0].width;height=$taskItems[0].height;frame_count=$taskItems.Count;loop=($taskGroup -in @('JI','JM'));core_base_spread_px=($taskBases.Maximum-$taskBases.Minimum);core_bbox_center_x_spread_px=($taskCenters.Maximum-$taskCenters.Minimum);core_width_spread_px=($taskWidths.Maximum-$taskWidths.Minimum);frames=$taskFrames;human_visual_acceptance='PENDING';runtime_admission=$false}
 [InteractionInspect]::Contact($PSScriptRoot,$taskGroup,[string[]]@($taskItems|ForEach-Object {$_.code}))
}
foreach($taskR in(Get-Content (Join-Path $PSScriptRoot 'references.json') -Raw|ConvertFrom-Json)){if((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskR.path)).Hash -ne $taskR.sha256){throw 'Reference changed'}}
[InteractionInspect]::Board($PSScriptRoot)
$taskInspection=[ordered]@{assets=$taskAssets;sequences=$taskGroups}
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'inspection.json'),($taskInspection|ConvertTo-Json -Depth 10),[Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'sequences.js'),('window.SEQUENCES = '+($taskGroups|ConvertTo-Json -Depth 9)+';'),[Text.UTF8Encoding]::new($false))
$taskAssets|ForEach-Object {[pscustomobject]$_}|Select-Object code,width,height,margin_min_px,edge_band4_alpha_ge16_pixels,core_alpha_mode|ConvertTo-Json
$taskGroups|ForEach-Object {[pscustomobject]$_}|Select-Object code,core_base_spread_px,core_bbox_center_x_spread_px,core_width_spread_px|ConvertTo-Json
