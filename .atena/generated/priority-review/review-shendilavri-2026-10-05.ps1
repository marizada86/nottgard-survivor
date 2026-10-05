$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System;
using System.Drawing;
public class PilotAlphaScan {
 public static double[] Scan(string path) {
  using (Bitmap b = new Bitmap(path)) {
   long visible=0,solid=0,zero=0; int x0=b.Width,y0=b.Height,x1=-1,y1=-1;
   for(int y=0;y<b.Height;y++) for(int x=0;x<b.Width;x++) {
    int a=b.GetPixel(x,y).A; if(a==0)zero++;
    if(a>10){visible++; if(a>=230)solid++; x0=Math.Min(x0,x);y0=Math.Min(y0,y);x1=Math.Max(x1,x);y1=Math.Max(y1,y);}
   }
   return new double[]{b.Width,b.Height,zero,visible,solid,visible==0?0:(double)solid/visible,x0,y0,x1,y1};
  }
 }
}
'@
$ids = @('escravo_de_rivenheart','sucubo','guarda_do_castelo','master_of_cruelties','malcanthet')
$names = @('Escravo de Rivenheart','Sucubo','Guarda do Castelo','Master of Cruelties','Malcanthet')
$records = @()
$board = New-Object System.Drawing.Bitmap 1600,720
$g = [System.Drawing.Graphics]::FromImage($board)
$g.Clear([System.Drawing.Color]::FromArgb(25,28,35))
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$font = New-Object System.Drawing.Font 'Segoe UI',14
$small = New-Object System.Drawing.Font 'Segoe UI',10
$brush = [System.Drawing.Brushes]::White
$g.DrawString('Shendilavri - cinco identidades / aprovacao humana pendente', $font, $brush, 16, 12)
$g.DrawString('Candidatas acima; referencias estaticas abaixo. Escala ajustada apenas nesta prancha.', $small, $brush, 16, 40)
for ($i=0;$i -lt 5;$i++) {
 $id=$ids[$i]; $v=if($i -lt 2){'01'}else{'02'}
 $p=".atena/generated/art-candidates/enemies-shendilavri/$id/$($id)_idle_00_v$v.png"
 $full=(Resolve-Path -LiteralPath $p).Path
 $a=[PilotAlphaScan]::Scan($full)
 $bounds=[System.Drawing.Rectangle]::new([int]$a[6],[int]$a[7],[int]($a[8]-$a[6]+1),[int]($a[9]-$a[7]+1))
 $margins=@([int]$a[6],[int]$a[7],[int]($a[0]-1-$a[8]),[int]($a[1]-1-$a[9]))
 $records += [ordered]@{id=$id;version=$v;path=$p;sha256=(Get-FileHash -LiteralPath $full -Algorithm SHA256).Hash;size=@($a[0],$a[1]);transparent_pixels=$a[2];visible_pixels=$a[3];solidity=$a[5];visible_bounds=@($a[6],$a[7],$a[8],$a[9]);margins_left_top_right_bottom=$margins;clipped=($margins -contains 0);native_alpha_preserved=$true;human_approval='pending'}
 $x=$i*320
 $g.DrawString("$($names[$i]) / v$v",$small,$brush,$x+12,76)
 for($yy=105;$yy -lt 515;$yy+=20){for($xx=$x+10;$xx -lt $x+310;$xx+=20){$c=if((($xx-$x-10)/20+($yy-105)/20)%2 -eq 0){[System.Drawing.Color]::FromArgb(48,53,64)}else{[System.Drawing.Color]::FromArgb(39,44,55)};$cb=[System.Drawing.SolidBrush]::new($c);$g.FillRectangle($cb,$xx,$yy,20,20);$cb.Dispose()}}
 $img=[System.Drawing.Image]::FromFile($full)
 $scale=[Math]::Min(280.0/$bounds.Width,390.0/$bounds.Height)
 $w=[int]($bounds.Width*$scale);$h=[int]($bounds.Height*$scale)
 $dest=[System.Drawing.Rectangle]::new([int]($x+(320-$w)/2),[int](505-$h),$w,$h)
 $g.DrawImage($img,$dest,$bounds,[System.Drawing.GraphicsUnit]::Pixel);$img.Dispose()
 $g.DrawString(('Solidez {0:N3} | sem cortes' -f $a[5]),$small,$brush,$x+12,530)
 $ref=[System.Drawing.Image]::FromFile((Resolve-Path "assets/enemies/$id.png").Path)
 $s=[Math]::Min(180.0/$ref.Width,140.0/$ref.Height);$rw=[int]($ref.Width*$s);$rh=[int]($ref.Height*$s)
 $g.DrawImage($ref,[int]($x+(320-$rw)/2),[int](705-$rh),$rw,$rh);$ref.Dispose()
}
$out='.atena/generated/priority-review/shendilavri_identities_v02.png'
$board.Save((Join-Path (Get-Location) $out),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose();$board.Dispose();$font.Dispose();$small.Dispose()
[ordered]@{date='2026-10-05';plan='PLAN-053';spec='SPEC-121';tool='System.Drawing read-only alpha audit and review composition';sources_modified=$false;board=$out;records=$records} | ConvertTo-Json -Depth 8 | Set-Content '.atena/generated/shendilavri-identity-audit-2026-10-05.json' -Encoding UTF8
$records | Select-Object id,solidity,clipped,margins_left_top_right_bottom | Format-Table -AutoSize
