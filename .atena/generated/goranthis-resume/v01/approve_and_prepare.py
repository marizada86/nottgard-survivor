from pathlib import Path
import json,hashlib,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
receipt=json.loads((out/'identity-gate-receipt.json').read_text(encoding='utf-8'))
for row in receipt['selected']:
 assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256']
reg='.atena/vault/canon/ASSET-APPROVAL-REGISTER-023-goranthis-identidades-2026-10-07.md'
p=root/reg;assert not p.exists()
lines=['# ASSET-APPROVAL-REGISTER-023 — Identidades de Goranthis','','Em 2026-10-07, após apresentação da prancha I01–I04 e pergunta explícita sobre iniciar os 82 quadros restantes, o dono respondeu “atena continue”. Aprovação dessas quatro identidades registrada como IN_PLAN no PLAN-053/SPEC-121, per-plan já aprovado. Nenhuma aprovação de ciclos ainda não produzidos ou autorização Git/publicação inferida.','','| Alvo | Versão | SHA256 |','|---|---|---|']
for row in receipt['selected']:lines.append(f'| {row["id"]} | v{row["version"]:02} | {row["sha256"]} |')
lines+=['','[Prancha aprovada](../../generated/priority-review/goranthis_identities_v01.png). [Recibo e fontes](../../generated/goranthis-resume/v01/identity-gate-receipt.json).','I02 v01 rejeitada por direção do rosto, preservada; I02 v02 aprovada. Reuso de Ilusão sem novos PNGs segue o ator fonte real do runtime. Lore/fontes externas continuam somente leitura.']
p.write_text('\n'.join(lines)+'\n',encoding='utf-8')
receipt.update(status='APPROVED',approved_at='2026-10-07',approval_evidence='Dono respondeu atena continue após pergunta explícita sobre aprovar I01-I04 e iniciar 82 quadros.',register=reg)
(out/'identity-gate-receipt.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8').replace('S-006/GORANTHIS/GATE-IDENTITIES-V01','S-006/GORANTHIS/GUARDIAO-DE-GORANTHIS-CYCLES').replace('  status: AWAITING_IDENTITY_APPROVAL','  status: EXECUTING_CYCLES',1)
t=re.sub(r"  current: 'PLAN-053 / SPEC-121:.*","  current: 'PLAN-053 / SPEC-121: Goranthis I01-I04 aprovados; gerar Guardiao do Paraiso. Shendilavri completo local, retorno PLAN-071 preservado.'",t,count=1)
t=re.sub(r"  next: '[^\n]*","  next: 'Gerar e validar 82 quadros restantes de Goranthis, um ator por vez; iniciar guardiao_de_goranthis.'",t,count=1);p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';t=p.read_text(encoding='utf-8').replace('  status: AWAITING_IDENTITY_APPROVAL','  status: EXECUTING_CYCLES',1).replace('  status: PENDING_OWNER_APPROVAL','  status: APPROVED',1)
t=t.replace('  generated: 4','  approved_at: 2026-10-07\n  approval_evidence: Dono respondeu atena continue apos gate I01-I04.\n  register: '+reg+'\n  generated: 4',1)
t=re.sub(r"  current: 'S-006:.*","  current: 'S-006: Goranthis I01-I04 aprovados; Guardiao do Paraiso em geracao. Shendilavri completo local, retorno PLAN-071 preservado.'",t,count=1)
t=re.sub(r"  next: '[^\n]*","  next: 'Gerar e validar 82 quadros restantes de Goranthis, um ator por vez.'",t,count=1);p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-018-mobs-goranthis.md';t=p.read_text(encoding='utf-8').replace('[x] gerada · [ ] aprovada','[x] gerada · [a] aprovada');t=re.sub(r'^status:.*','status: "I01-I04 aprovados; ciclos em execução"',t,count=1,flags=re.M);t+='\n2026-10-07 — Dono respondeu atena continue ao gate I01-I04; aprovação no registro canônico023. Início de 82 quadros restantes, um ator por vez.\n';p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-049-mobs-goranthis.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "quatro identidades aprovadas; ciclos em execução"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
print('Goranthis identity approval recorded; 82 new frames authorized, Guardiao first.')
