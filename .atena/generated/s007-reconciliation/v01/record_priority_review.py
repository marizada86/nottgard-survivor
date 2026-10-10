from pathlib import Path
import json, hashlib, shutil
root=Path.cwd()
base=root/'.atena/generated/s007-reconciliation/v01'
gate=base/'h403-owner-gate-2026-10-09.json'
data=json.loads(gate.read_text(encoding='utf-8'))
assert hashlib.sha256((root/data['candidate']).read_bytes()).hexdigest()==data['sha256']
data.update(status='APPROVED_BY_OWNER', owner_reply='atena, aprovado cheque se há atualizações na prioridade da fila e continue', approved_revision='H403 v02', content_state='CANON', approval_scope='Only H403 v02 visual candidate; no runtime admission')
gate.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'h403-owner-approval-2026-10-09.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
canon=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-035-vfx-sylas-2026-10-09.md'
canon.write_text('# ASSET-APPROVAL-REGISTER-035 — Passo pelas Sombras\n\nH403 v02 aprovada explicitamente pelo dono: “atena, aprovado cheque se há atualizações na prioridade da fila e continue”. CANON limitado a este quadro e sua identidade visual. SHA256 '+data['sha256']+'. [Recibo](../../generated/s007-reconciliation/v01/h403-owner-approval-2026-10-09.json). Sem admissão runtime. Retorno preparado: H401, H402, H404, H405 e H406; produção aguarda escolha de rota da nova prioridade ART-045.\n',encoding='utf-8')
dest=root/'.atena/generated/art045-priority-review/v01'
dest.mkdir(parents=True,exist_ok=True)
sources=[Path('F:/dev/nottgard-survivor/.atena/generated/ART-PROMPTS-060-erik-e-arlindo-jogaveis.md'),Path('F:/dev/nottgard-survivor/.atena/generated/CHATGPT-FILA-027-erik-e-arlindo.md'),Path('F:/dev/nottcard/assets/portraits/erik.png'),Path('F:/dev/nottcard/assets/portraits/arlindo.png')]
records=[]
for src in sources:
    target=dest/src.name
    shutil.copyfile(src,target)
    digest=hashlib.sha256(src.read_bytes()).hexdigest()
    assert hashlib.sha256(target.read_bytes()).hexdigest()==digest
    records.append(dict(source=str(src),snapshot=str(target.relative_to(root)).replace('\\','/'),sha256=digest,authority='Read-only source; visual production remains DRAFT'))
receipt=dict(id='DEV-024',classification='PLAN_DEVIATION',status='AWAITING_OWNER_ROUTE',priority='ART-045/FILA-027 before VFX',remote_update=False,main_local_revision='240f629',sources=records,return_checkpoint='S-007/VFX/FILA-023/H-REMAINING',remaining_vfx=41,proposed_scope=['ER01 portrait','ER02 idle','AO01 portrait','AO02 idle'],approval_mode_proposed='per-plan',visual_gates='Owner approval of each portrait before idle; idle before further strips',runtime_admission=False)
(dest/'review.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(dest/'proposal.md').write_text('# ART-045 — proposta DRAFT v01\n\nPrioridade máxima encontrada na main local 240f629: FILA-027 antecede VFX. Fontes e hashes em review.json. Sem substituir o plano ativo ou integrar alterações da outra sessão.\n\nLote proposto por plano: S-001 preparar identidade e referências; S-002 gerar ER01 e aguardar aceite visual; S-003 gerar ER02 com retrato aprovado e auditar tira; S-004 gerar AO01 e aguardar aceite; S-005 gerar AO02 e auditar tira. Após o lote, retornar aos cinco quadros Sylas. As outras 16 peças de FILA-027 ficam fora deste lote.\n\nIdentidades: retratos Nottcard somente leitura; Erik conserva cicatriz, cabelo/barba, cachecol, pele, espada e amuleto; Arlindo conserva rosto, chapéu, casaco, cachecol e luvas. Contexto retratos: floresta fria para Erik; rua de pedra molhada com luz âmbar para Arlindo. Idle: entidade isolada, câmera isométrica, alpha real, quatro células, sem cenário. ART-PROMPTS-060 define medidas e auditoria. Não promover hipóteses narrativas a canon.\n\nSaída: candidatos nativos preservados e revisões/auditoria, sem admissão runtime. Checagens: identidade, composição, contagem de células, bordas, alpha, altura/pivô; diferenças do gerador ficam documentadas e impedem admissão até corrigidas. Gate BLOCKING: escolha da rota pelo dono; gates visuais seguintes permanecem independentes. Recuperação: manter estados atuais e retorno PLAN-053/S-007; suspender somente após escolha fazer agora.\n',encoding='utf-8')
for state in [root/'.atena/state/plan.yaml',root/'.atena/state/plan-053-imagens.yaml']:
    text=state.read_text(encoding='utf-8')
    text=text.replace('H403_v02_PENDING_OWNER_APPROVAL','H403_v02_APPROVED')
    if 'image_priority_review_2026_10_09:' not in text:
        text+='\nimage_priority_review_2026_10_09:\n  deviation: DEV-024\n  status: AWAITING_OWNER_ROUTE\n  proposal: .atena/generated/art045-priority-review/v01/proposal.md\n  receipt: .atena/generated/art045-priority-review/v01/review.json\n  h403_v02: APPROVED_BY_OWNER\n  return_checkpoint: S-007/VFX/FILA-023/H-REMAINING\n  remaining_native_vfx_frames: 41\n'
    state.write_text(text,encoding='utf-8')
print('H403 v02 approval recorded; 4 hashed snapshots; bounded DRAFT proposal; route pending.')
