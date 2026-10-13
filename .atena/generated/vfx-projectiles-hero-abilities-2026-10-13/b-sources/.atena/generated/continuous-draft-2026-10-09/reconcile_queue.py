from pathlib import Path
import subprocess,json,re
r=Path.cwd();b=r/'.atena/generated/continuous-draft-2026-10-09';audit=json.loads((b/'completion-audit.json').read_text(encoding='utf-8'));records={j['code']:j for j in audit['records']};q=subprocess.run(['git','show','HEAD:.atena/generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md'],check=True,capture_output=True).stdout.decode('utf-8')
approved={'H103','H201','H301','H403'}
def update(m):
 code=m.group(1);j=records[code];section=m.group(0);line='- [x] gerada · '+('[a] aprovada' if code in approved else '[ ] aprovada')+' · candidata: `'+j['destination'].replace('\\','/')+'`'+(' — aceite visual registrado.' if code in approved else ' — DRAFT; revisão humana pendente.')
 section=re.sub(r'^- \[[ x]\].*$',line,section,count=1,flags=re.M)
 if line not in section:section=section.replace('```text',line+'\n\n```text',1)
 return section
q=re.sub(r'#### (H\d+) - `([^`]+)`[^\n]*\n(.*?)(?=\n#### |\n## H|\Z)',update,q,flags=re.S)
q=re.sub(r'status: "[^"]*"','status: "60/60 nativas geradas; revisao e normalizacao pendentes; sem runtime"',q,count=1)
q=q.replace('2. Para cada efeito, gere **primeiro o quadro marcado GATE**, pare e devolva ao dono. Aprovado, gere os demais do mesmo efeito, um efeito por vez, anexando o GATE aprovado.','2. Ordem histórica: GATE primeiro, demais após aceite. Em2026-10-09 o dono autorizou produção contínua por plano como DRAFT e revisão ao retornar; novos gates experimentais não são CANON. Autoridade operacional: `.atena/generated/art045-priority-review/v01/continuous-draft-authorization-v02.json`.')
assert len(re.findall(r'^#### H\d+',q,re.M))==60
paths=re.findall(r'candidata: `([^`]+)`',q);assert len(paths)==60;assert all((r/p).exists() for p in paths)
(r/'.atena/generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md').write_text(q,encoding='utf-8')
p=r/'.atena/generated/ART-PROMPTS-054-vfx-habilidades-dos-herois.md';t=p.read_text(encoding='utf-8');t=re.sub(r'status: "[^"]*"','status: "60/60 nativas geradas; revisao visual e normalizacao pendentes; sem runtime"',t,count=1);p.write_text(t,encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml']:
 t=p.read_text(encoding='utf-8');t=t.replace('status: EXECUTING_WITH_RETURN','status: NATIVE_GENERATION_COMPLETE_REVIEW_PENDING');p.write_text(t,encoding='utf-8')
print('Queue reconciled:60 unique headings and60 existing candidate links.')
