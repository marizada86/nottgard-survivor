# Remove sobras do chroma key magenta (#FF00FF) de PNGs com transparencia.
# Buracos internos (vaos de janelas, arcos) nao sao alcancados pelo flood fill da borda e ficam magenta.
# Uso: powershell -ExecutionPolicy Bypass -File tools/remove_chroma_residue.ps1 <arquivo.png> [...]
# Apaga pixels proximos do magenta puro e 2 px de franja magenta ao redor deles (sem tocar em magenta isolado da arte).
param([Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)][string[]]$Files)
Add-Type -ReferencedAssemblies System.Drawing @"
using System; using System.Drawing; using System.Drawing.Imaging;
public static class ChromaResidue {
 static bool Key(byte r,byte g,byte b){ return r>200 && b>200 && g<100 && r-g>120 && b-g>120; }
 static bool Fringe(byte r,byte g,byte b){ return r-g>45 && b-g>45 && r>120 && b>120; }
 public static int Clean(string path){
  Bitmap src=new Bitmap(path); int w=src.Width,h=src.Height;
  var bm=new Bitmap(w,h,PixelFormat.Format32bppArgb); using(var g=Graphics.FromImage(bm)){ g.DrawImage(src,0,0,w,h);} src.Dispose();
  var d=bm.LockBits(new Rectangle(0,0,w,h),ImageLockMode.ReadWrite,PixelFormat.Format32bppArgb);
  var buf=new byte[d.Stride*h]; System.Runtime.InteropServices.Marshal.Copy(d.Scan0,buf,0,buf.Length);
  int s=d.Stride; var kill=new bool[w*h]; int n=0;
  for(int y=0;y<h;y++)for(int x=0;x<w;x++){int i=y*s+x*4; if(buf[i+3]>0&&Key(buf[i+2],buf[i+1],buf[i])) kill[y*w+x]=true;}
  for(int pass=0;pass<2;pass++){ var add=new System.Collections.Generic.List<int>();
   for(int y=0;y<h;y++)for(int x=0;x<w;x++){ if(kill[y*w+x])continue; int i=y*s+x*4; if(buf[i+3]==0||!Fringe(buf[i+2],buf[i+1],buf[i]))continue;
    bool near=false; for(int dy=-1;dy<=1&&!near;dy++)for(int dx=-1;dx<=1;dx++){int nx=x+dx,ny=y+dy; if(nx>=0&&ny>=0&&nx<w&&ny<h&&kill[ny*w+nx]){near=true;break;}}
    if(near)add.Add(y*w+x);}
   foreach(var k in add)kill[k]=true; }
  for(int y=0;y<h;y++)for(int x=0;x<w;x++){ if(!kill[y*w+x])continue; int i=y*s+x*4; if(buf[i+3]!=0){n++;} buf[i]=0;buf[i+1]=0;buf[i+2]=0;buf[i+3]=0; }
  System.Runtime.InteropServices.Marshal.Copy(buf,0,d.Scan0,buf.Length); bm.UnlockBits(d);
  string tmp=path+".tmp.png"; bm.Save(tmp,ImageFormat.Png); bm.Dispose(); System.IO.File.Delete(path); System.IO.File.Move(tmp,path);
  return n; }
}
"@
foreach($f in $Files){ $p=(Resolve-Path $f).Path; $n=[ChromaResidue]::Clean($p); "{0}: {1} px removidos" -f $f,$n }
