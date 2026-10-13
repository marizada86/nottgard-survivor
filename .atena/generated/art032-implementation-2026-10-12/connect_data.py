"""Add only art metadata to stage event definitions; verify mechanics are unchanged."""
from pathlib import Path
import json
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
path=ROOT/'data/stage_events.json'
before=path.read_text(encoding='utf-8')
old=json.loads(before)
data=json.loads(before)
def event(stage,id):return next(e for e in data[stage] if e['id']==id)
event('feng_tu','escolta_do_peregrino')['npc']['asset']='npc_joao_barbosa'
event('durao','desertores')['asset']='npc_desertor_durao'
event('shendilavri','vitimas_drenadas')['asset']='npc_vitima_enfeiticada'
event('shendilavri','vitimas_drenadas')['reward']['allies']['assets']=['npc_nyxara','npc_vaelis']
event('goranthis','o_nome_tres_vezes')['asset']='npc_grazzt_aliado'
event('goranthis','o_nome_tres_vezes')['choices'][0]['effect']['allies']['asset']='npc_grazzt_aliado'
event('shedaklah','barqueiro_do_estige')['asset']='npc_reaper_barqueiro'
event('durao','vhaerith_na_jaula')['asset']='npc_vhaerith_aetherion'
event('shendilavri','mercador_de_rivenheart')['asset']='npc_mercador_rivenheart'
event('feng_tu','peregrinacao_da_estrela')['asset']='estrela_do_norte'
event('shedaklah','pedido_de_zuggtmoy')['target']['asset']='trono_zuggtmoy'
event('shedaklah','pedido_de_zuggtmoy')['items'][0]['asset']='coracao_limo'
event('shedaklah','portal_sem_vao')['target']['asset']='arco_pedra'
event('shedaklah','portal_sem_vao')['items'][0]['asset']='esporo_zuggtmoy'
event('shedaklah','portal_sem_vao')['items'][1]['asset']='limo_juiblex'
event('molor','ritual_de_estagnacao')['asset']='massa_thullgrime'
def mechanics(value):
    if isinstance(value,dict):return {k:mechanics(v) for k,v in value.items() if k not in ['asset','assets']}
    if isinstance(value,list):return [mechanics(v) for v in value]
    return value
assert mechanics(data)==mechanics(old)
updated={e['id']:e for entries in data.values() if isinstance(entries,list) for e in entries}
lines=[]
for line in before.splitlines():
    if line.lstrip().startswith('{"id":'):
        has_comma=line.endswith(',')
        original=json.loads(line.strip().rstrip(','))
        replacement=updated[original['id']]
        if original!=replacement:line='    '+json.dumps(replacement,ensure_ascii=False,separators=(',',':'))+(',' if has_comma else '')
    lines.append(line)
path.write_text('\n'.join(lines)+'\n',encoding='utf-8')
assert json.loads(path.read_text(encoding='utf-8'))==data
(OUT/'data-audit.json').write_text(json.dumps({'status':'PASS','art_metadata_only':True,'mechanical_definitions_unchanged':True,'new_metadata_keys':['asset','assets'],'event_count':sum(len(v) for v in data.values() if isinstance(v,list))},indent=2)+'\n',encoding='utf-8')
print('Art metadata connected; all non-art event fields unchanged.')
