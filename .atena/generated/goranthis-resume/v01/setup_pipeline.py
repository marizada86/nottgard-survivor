from pathlib import Path
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
source=root/'.atena/generated/shendilavri-resume/v01'
for name in ['prepare_enemy_cycles.gd','review_actor.py','check_actor.ps1']:
 p=out/name;assert not p.exists()
 t=(source/name).read_text(encoding='utf-8-sig')
 if name=='prepare_enemy_cycles.gd':t=t.replace('"lu_yueh", "malcanthet"]','"lu_yueh", "malcanthet", "socothbenoth"]')
 if name=='review_actor.py':t=t.replace('enemies-shendilavri','enemies-goranthis')
 if name=='check_actor.ps1':t=t.replace("$Biome='shendilavri'","$Biome='goranthis'").replace('shendilavri-resume/v01','goranthis-resume/v01')
 p.write_text(t,encoding='utf-8')
p=root/'tools/install_shedaklah_animations.ps1';t=p.read_text(encoding='utf-8-sig')
t=t.replace("'master_of_cruelties','malcanthet')][string]$EnemyId","'master_of_cruelties','malcanthet','guardiao_de_goranthis','cultista_de_socothbenoth','death_tyrant','socothbenoth')][string]$EnemyId")
t=t.replace("'feng-tu','shendilavri')][string]$Biome","'feng-tu','shendilavri','goranthis')][string]$Biome")
t=t.replace("'lu_yueh','malcanthet'","'lu_yueh','malcanthet','socothbenoth'")
p.write_text(t,encoding='utf-8')
print('Goranthis packing/review/check helpers saved; installer IDs/biome/special extended, no assets installed.')
