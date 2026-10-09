from pathlib import Path
import json,re,hashlib,subprocess
from datetime import datetime,timezone
root=Path.cwd();out=Path(__file__).parent;vfx=root/'.atena/generated/s007-reconciliation/v01'
read=lambda p:p.read_text(encoding='utf-8-sig')
save=lambda p,d:p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
stamp=datetime.now(timezone.utc).isoformat();reply='aprovado, commit e pus'
git=lambda *args:subprocess.check_output(['git',*args]).decode('utf-8')
base=git('rev-parse','HEAD').strip();branch=git('branch','--show-current').strip();assert base=='a39b6f0be50633c35327584314d52093c29c743d' and branch=='codex/fila-imagens-2026-10-09'
assert git('remote','get-url','origin').strip()=='https://github.com/marizada86/nottgard-survivor.git'
gp=vfx/'n03-owner-gate-2026-10-09.json';g=json.loads(read(gp));assert g['status']=='PENDING_OWNER_APPROVAL' and g['version']=='v01'
assert sha(root/g['candidate'])==g['sha256']
approval=dict(status='APPROVED',owner_reply=reply,recorded_at=stamp,frame='N03',version='v01',candidate=g['candidate'],sha256=g['sha256'],scope='Approve radiant pulse PEAK and generate N01,N02,N04,N05,N06; then M03 PEAK gate only. Commit/push current reviewed checkpoint first, same branch and repository; no runtime admission.',previous_question='Aprova N03 v01, o pico do pulso radiante apresentado, para gerar os outros cinco quadros? A FILA-022 exige aprovar o quadro GATE antes dos demais; depois preparo somente o pico M03 para avaliação.')
save(vfx/'n03-owner-approval-2026-10-09.json',approval)
g.update(status='APPROVED',owner_reply=reply,approval_receipt='.atena/generated/s007-reconciliation/v01/n03-owner-approval-2026-10-09.json');save(gp,g)
canon=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-030-vfx-pulso-radiante-2026-10-09.md';assert not canon.exists();canon.write_text('# ASSET-APPROVAL-REGISTER-030 — Pico do pulso radiante\n\nO dono respondeu “'+reply+'” à pergunta de aprovação N03 v01 e geração dos cinco demais quadros. [Recibo](../../generated/s007-reconciliation/v01/n03-owner-approval-2026-10-09.json), [fonte nativa](../../generated/art-candidates/vfx/pulso_radiante/pulso_radiante_peak_v01.png), SHA256 '+g['sha256']+'.\n\nPLAN-053/SPEC-121, per-plan preservado. Commit/push do checkpoint atual na branch codex/fila-imagens-2026-10-09 antes da continuação local N01,N02,N04,N05,N06; depois somente pico M03 para gate humano. Nenhum aceite individual de quadros futuros ou admissão runtime de VFX.\n',encoding='utf-8')
for name in ['CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md','ART-PROMPTS-053-vfx-projeteis-e-explosoes.md']:
 p=root/'.atena/generated'/name;t=read(p).replace('N03 v01 pico candidato, gate pendente; demais11 quadros pendentes','N03 v01 pico aprovado; commit/push solicitado antes dos cinco demais N; M03 pendente')
 if name.startswith('CHATGPT'):
  m=re.search(r'(#### N03[^\n]+\n\n)([^\n]+)',t);assert m;b=m[2].replace('[ ] aprovada','[a] aprovada').replace('pico gerado/revisado, gate humano pendente.','pico aprovado pelo dono; continuação após commit/push solicitado.');t=t[:m.start(2)]+b+t[m.end(2):]
 p.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p);save(out/(p.stem+'-before.json'),dict(snapshot=read(p),source=rel,timestamp=stamp))
 active=re.search(r'\nactive_plan:\n(.*?)(?=\n\S|\Z)',t,re.S);assert active;b=active[1].replace('status: AWAITING_OWNER_APPROVAL','status: SUSPENDED_FOR_GIT_PUBLICATION').replace('checkpoint: S-007/VFX/FILA-022/N03-APPROVAL','checkpoint: DEV-006/S-002');b=b.replace('request_classification: IN_PLAN','request_classification: PLAN_DEVIATION');t=t[:active.start(1)]+b+t[active.end(1):]
 t=t.replace('S-007 onda cortante oito candidatas revisadas; N03 v01 pico gerado, gate humano pendente. Dois commits publicados e verificados.','DEV-006/S-002 commit/push solicitado; onda cortante oito candidatas revisadas e N03 v01 aprovada.')
 t=t.replace('Aguardar N03 antes dos cinco demais N e gate M03; 71 fontes VFX restantes. Retorno PLAN-071 preservado.','Apos push verificado retornar a N01,N02,N04,N05,N06; depois somente gate M03. Retorno PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  m=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m and 'frame: N03' in m[1];b=m[1].replace('status: PENDING_OWNER_APPROVAL','status: APPROVED');b+='  owner_reply: "'+reply+'"\n  approval_receipt: .atena/generated/s007-reconciliation/v01/n03-owner-approval-2026-10-09.json\n';t=t[:m.start(1)]+b+t[m.end(1):]
 t+='\nimage_git_n03_publication:\n  id: DEV-006\n  status: VALIDATED_READY_TO_COMMIT\n  mode: per-plan\n  checkpoint: DEV-006/S-002\n  authorization: "'+reply+'"\n  route: publish-now-then-return\n  receipt: .atena/generated/n03-publication-2026-10-09/plan.json\n  return_checkpoint: S-007/VFX/FILA-022/N-REMAINING\n';p.write_text(t,encoding='utf-8')
manifest=root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json';manifest_data=json.loads(read(manifest));assert manifest_data['count']==len(manifest_data['assets'])==202 and sha(manifest)==g['manifest_file_sha256']
sequence=json.loads(read(vfx/'onda-cortante-sequence-audit-2026-10-09.json'));assert sequence['status']=='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED'
sources=sequence['sources']+[dict(path=g['candidate'],sha256=g['sha256'])]
for s in sources:assert sha(root/s['path'])==s['sha256']
save(out/'validation.json',dict(status='PASSED',source_hashes_verified=9,manifest_assets=202,manifest_sha256=sha(manifest),runtime_changes=False,checks='Metadata and previews only; prior import/suite/smoke at a39b6f0 remain applicable, no new runtime or dependency changes.',prior_checks='.atena/generated/image-queue-publication-2026-10-09/checks.json'))
save(out/'plan.json',dict(status='VALIDATED_READY_TO_COMMIT',request_classification='PLAN_DEVIATION',authorization=reply,route='publish-now-then-return',approval_mode='per-plan',checkpoint='DEV-006/S-002',base=base,branch=branch,remote_url='https://github.com/marizada86/nottgard-survivor.git',native_sources='Ignored candidates remain local; no force-add.',scope='Current R sequence previews, native audit/prompts, N03 approval and publication reconciliation. No main merge.',return_checkpoint='S-007/VFX/FILA-022/N-REMAINING'))
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/publication-n03-checkpoint-2026-10-09.md';spec.write_text('# DEV-006/S-002 — Publicação da sequência R e aprovação N03\n\nDono: “'+reply+'”. Rota explícita: commit/push agora, depois retornar à continuação N aprovada. Per-plan preservado; sem alteração material de arquitetura, runtime, dependências ou main. Escopo: evidências e prévias da onda cortante, aprovação N03 e reconciliação da publicação anterior. Originais nativos ignorados ficam locais. Conferir nove hashes de fontes, manifesto202 inalterado, links, payload Git e ref remota. Excluir perfis locais e arquivos Godot incidentais.\n',encoding='utf-8')
ev=root/'.atena/evidence/n03-approval-publication-2026-10-09.md';ev.write_text('# Aprovação N03 e preparação da publicação\n\nO dono respondeu “'+reply+'” ao gate do pico. [Aprovação](../generated/s007-reconciliation/v01/n03-owner-approval-2026-10-09.json), [registro canônico](../vault/canon/ASSET-APPROVAL-REGISTER-030-vfx-pulso-radiante-2026-10-09.md).\n\nDEV-006/S-002, rota solicitada publicar agora e retornar. Commit/push em preparação, sem alegar publicação antecipada. [Plano](../generated/n03-publication-2026-10-09/plan.json), [validação](../generated/n03-publication-2026-10-09/validation.json). Nove fontes e manifesto202 conferidos; conteúdo documental e prévias, sem runtime novo. Quatro P1 abertos, dez correções aguardam playtest e oito verificações manuais; nenhum fechamento inferido.\n',encoding='utf-8')
links=[]
for p in [canon,ev]:
 for link in re.findall(r'\]\(([^)]+)\)',read(p)):assert (p.parent/link).resolve().is_file(),(p,link);links.append(link)
tracked=[p for p in git('diff','--name-only','-z').split('\0') if p];assert all(p.startswith('.atena/') for p in tracked)
untracked=[p for p in git('ls-files','--others','--exclude-standard','-z').split('\0') if p]
def include(p):
 if p.startswith('.atena/generated/s007-reconciliation/v01/'):return True
 if p.startswith('.atena/generated/n03-publication-2026-10-09/'):return True
 if p.startswith('.atena/generated/image-queue-publication-2026-10-09/') and len(Path(p).parts)==4:return True
 return p in [canon.relative_to(root).as_posix(),ev.relative_to(root).as_posix(),spec.relative_to(root).as_posix(),'.atena/evidence/s007-onda-cortante-completa-n03-gate-2026-10-09.md']
selected=sorted(set(tracked+[p for p in untracked if include(p)]));selected+=[(out/'scope.json').relative_to(root).as_posix(),(out/'pathspec.nul').relative_to(root).as_posix()];selected=sorted(set(selected))
report=dict(status='VALIDATED_SCOPE',files=len(selected),selected=selected,excluded=[p for p in untracked if p not in selected],links_checked=len(links),bytes_before_scope=sum((root/p).stat().st_size for p in selected if (root/p).exists()),native_policy='Ignored originals stay local; previews and source receipts published.')
save(out/'scope.json',report);(out/'pathspec.nul').write_bytes(('\0'.join(selected)+'\0').encode('utf-8'));print(json.dumps({k:report[k] for k in ['files','bytes_before_scope','excluded','links_checked']},ensure_ascii=False))
