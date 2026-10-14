from pathlib import Path
import shutil
root=Path(__file__).resolve().parents[3]
out=Path(__file__).resolve().parent
old=root/'.atena/generated/orbe-arcano-admission-2026-10-13'
p=root/'core/arcane_orb_vfx.gd'
s=p.read_text(encoding='utf-8').replace('ArcaneOrbVfx','CuttingWaveVfx').replace('Accepted arcane family','Accepted cutting-wave family').replace('orbe_arcano','onda_cortante').replace('Vector2(135, 128)','Vector2(137.5, 127)').replace('Vector2(128.5, 124)','Vector2(128, 128)').replace('5.0 / 21.5','18.0 / 112.0').replace('12.0 / 41.0','12.0 / 40.0').replace('["raio_enfraquecedor", "dominar_pessoa", "cajado_dos_desejos"]','["lamina_trovejante", "tempestade"]')
(root/'core/cutting_wave_vfx.gd').write_text(s,encoding='utf-8')
p=root/'ui/radiant_orb_layer.gd';s=p.read_text(encoding='utf-8')
s=s.replace('if ArcaneOrbVfx.supports_projectile(projectile, Game.reduced_impact()): return ArcaneOrbVfx','if ArcaneOrbVfx.supports_projectile(projectile, Game.reduced_impact()): return ArcaneOrbVfx\n\tif CuttingWaveVfx.supports_projectile(projectile, Game.reduced_impact()): return CuttingWaveVfx')
s=s.replace('if ArcaneOrbVfx.supports_hit(event, Game.reduced_impact()): return ArcaneOrbVfx','if ArcaneOrbVfx.supports_hit(event, Game.reduced_impact()): return ArcaneOrbVfx\n\tif CuttingWaveVfx.supports_hit(event, Game.reduced_impact()): return CuttingWaveVfx')
s=s.replace('ArcaneOrbVfx.FLIGHT_PIVOT if family == ArcaneOrbVfx','family.FLIGHT_PIVOT if family != RadiantOrbVfx').replace('ArcaneOrbVfx.IMPACT_PIVOT if family == ArcaneOrbVfx','family.IMPACT_PIVOT if family != RadiantOrbVfx')
p.write_text(s,encoding='utf-8')
for n in ['voo','impacto']:shutil.copyfile(out/('onda_cortante_'+n+'.png'),root/'assets/vfx'/('onda_cortante_'+n+'.png'))
s=(root/'tests/test_arcane_orb_vfx.gd').read_text(encoding='utf-8').replace('ArcaneOrbVfx','CuttingWaveVfx').replace('raio_enfraquecedor','lamina_trovejante')
s='\n'.join(line for line in s.split('\n') if not any(x in line for x in ['var ca :=','enemy.ca !=','enemy.stun_t']))
s=s.replace('["memoria_alterada","dominio_da_vontade","lamina_trovejante","tempestade","raio_de_luz"]','["memoria_alterada","dominio_da_vontade","lamina_de_sombra","raio_enfraquecedor","raio_de_luz"]')
s=s.replace('var event: Dictionary = arc if i%2==0 else radiant','var third := arc.duplicate()\n\t\tthird.weapon = "raio_enfraquecedor"\n\t\tvar event: Dictionary = [arc,radiant,third][i%3]')
s=s.replace('(CuttingWaveVfx if i%2==0 else RadiantOrbVfx)','[CuttingWaveVfx,RadiantOrbVfx,ArcaneOrbVfx][i%3]')
(root/'tests/test_cutting_wave_vfx.gd').write_text(s,encoding='utf-8')
for name in ['focused.gd','playtest.gd','playtest.tscn','capture.gd','capture.tscn']:
 s=(old/name).read_text(encoding='utf-8').replace('orbe-arcano-admission-2026-10-13','onda-cortante-admission-2026-10-13').replace('ArcaneOrbVfx','CuttingWaveVfx').replace('test_arcane_orb_vfx','test_cutting_wave_vfx').replace('arcane focused','cutting focused').replace('QA arcane launcher','QA cutting launcher').replace('raio_enfraquecedor','lamina_trovejante').replace('Orbe Arcano QA','Onda Cortante QA')
 if name=='capture.gd':
  s=s.replace('["lamina_trovejante","raio_de_luz"]','["lamina_trovejante","raio_enfraquecedor","raio_de_luz"]').replace('Vector2.RIGHT if wid=="lamina_trovejante" else Vector2.LEFT','Vector2.from_angle(["lamina_trovejante","raio_enfraquecedor","raio_de_luz"].find(wid)*TAU/3)')
  s=s.replace('assert(layer.impacts.size()==2)','assert(layer.impacts.size()==3)').replace('layer.impacts[1].family == RadiantOrbVfx','layer.impacts[1].family == ArcaneOrbVfx and layer.impacts[2].family == RadiantOrbVfx').replace('mixed-arcane-radiant','mixed-three-families').replace('"mixed_arcane_radiant":true','"mixed_three_families":true')
 if name=='playtest.gd':s=s.replace('if "--mixed" in args: run.battle.hero.weapons.append(Weapon.make("raio_de_luz"))','if "--mixed" in args:\n\t\trun.battle.hero.weapons.append(Weapon.make("raio_de_luz"))\n\t\trun.battle.hero.weapons.append(Weapon.make("raio_enfraquecedor"))')
 (out/name).write_text(s,encoding='utf-8')
for prefix,src in [('arcane-regression',old/'capture.gd'),('radiant-regression',old/'radiant-regression.gd')]:
 (out/prefix).mkdir(exist_ok=True)
 s=src.read_text(encoding='utf-8')
 import re
 s=re.sub(r'const OUT := "[^"]+"','const OUT := "res://.atena/generated/onda-cortante-admission-2026-10-13/'+prefix+'/"',s)
 (out/(prefix+'.gd')).write_text(s,encoding='utf-8')
 (out/(prefix+'.tscn')).write_text('[gd_scene load_steps=2 format=3]\n[ext_resource type="Script" path="res://.atena/generated/onda-cortante-admission-2026-10-13/'+prefix+'.gd" id="1"]\n[node name="Capture" type="Node"]\nscript = ExtResource("1")\n',encoding='utf-8')
p=root/'.atena/state/onda-cortante-admission.yaml';s=p.read_text(encoding='utf-8').replace('S-001/DERIVATIVES','S-002/INTEGRATION').replace('current_step_position: 1','current_step_position: 2').replace('completed_steps: 0','completed_steps: 1').replace('remaining_steps_after_current: 3','remaining_steps_after_current: 2').replace('next_objective: Escolher modo e aprovar escopo antes de executar S-001.','next_objective: Integrar duas armas e validar terceira familia na camada compartilhada.');p.write_text(s,encoding='utf-8')
print('Integrated candidates, helper, third dispatch, test and isolated QA harnesses.')
