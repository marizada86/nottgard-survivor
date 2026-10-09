from pathlib import Path
from PIL import Image,ImageDraw
import json,hashlib,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
for rel in ['ui/enemy_view.gd','tests/test_animation_assets.gd']:
 p=root/rel;p.write_text(p.read_text(encoding='utf-8-sig').rstrip()+'\n',encoding='utf-8')
base=root/'.atena/generated/art-candidates/enemies-shendilavri/sucubo'
sheet=Image.new('RGB',(1536,940),'#25252e');draw=ImageDraw.Draw(sheet)
for row,(state,count) in enumerate({'idle':4,'move':6,'attack':4,'death':6}.items()):
 strip=Image.open(base/'strips'/f'{state}.png').convert('RGBA')
 frames=[]
 for i in range(count):
  frame=strip.crop((i*256,154,(i+1)*256,384))
  bg=Image.new('RGBA',(256,230),'#25252e');bg.alpha_composite(frame)
  frames.append(bg.convert('RGB'));sheet.paste(bg,(i*256,row*235+5))
  draw.text((i*256+8,row*235+5),f'{state}_{i:02d}',fill='white')
 frames[0].save(out/f'sucubo_{state}_review.gif',save_all=True,append_images=frames[1:],duration=180,loop=0)
sheet.save(out/'sucubo_compact_review.png')
strips=[]
for state,count in {'idle':4,'move':6,'attack':4,'death':6}.items():
 p=base/'strips'/f'{state}.png';im=Image.open(p).convert('RGBA')
 assert im.size==(count*256,384)
 a=im.getchannel('A');h=a.histogram();b=a.point(lambda x:255 if x>=11 else 0).getbbox()
 assert b[0]>0 and b[1]>0 and b[2]<im.width and b[3]<im.height
 assert sum(h[230:])/sum(h[11:])>=.9
 strips.append(dict(state=state,path=p.relative_to(root).as_posix(),size=im.size,sha256=hashlib.sha256(p.read_bytes()).hexdigest(),solidity=sum(h[230:])/sum(h[11:])))
receipt=dict(date='2026-10-07',plan='PLAN-053',spec='SPEC-121',actor='sucubo',status='PREVIEW_READY_AWAITING_WALK_DECISION',selected_frames=20,new_selected_frames=19,preserved_pngs=len(list(base.glob('*.png'))),generated_attempts=len(list(out.glob('result-sucubo-*.json'))),source_audit='.atena/generated/shendilavri-resume/v01/sucubo-selected-source-audit.json',strips=strips,installed=False,owner_decision='.atena/generated/shendilavri-resume/v01/sucubo-walk-decision.json',review='.atena/generated/shendilavri-resume/v01/sucubo_compact_review.png',death_note='death04 v03 keeps blade in far hand. death05 v03 existing fabric settles over fallen body; plate armor v02 rejected. Technical anchors -66/-70 keep body stable when blade points below body. No alpha cleanup or redraw.',runtime_checks='Not run: official admission waits for owner walk exception.')
(out/'sucubo-preview-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8-sig').replace('S-006/SHENDILAVRI/SUCUBO-CYCLES','S-006/SHENDILAVRI/SUCUBO-WALK-DECISION').replace('status: EXECUTING_CYCLES','status: AWAITING_OWNER_DECISION').replace('Escravo integrado (20 quadros, quatro tiras), excecao de marcha aceita; checks zero falhas. Gerar Sucubo.','Escravo integrado e validado; Sucubo 20 quadros e quatro tiras candidatas revisados, aguardando decisao sobre contato oposto curto.').replace('Concluir, auditar e integrar um ator por vez; depois Sucubo, Guarda, Master e Malcanthet.','Resolver decisao Sucubo antes de admissao; depois Guarda, Master e Malcanthet.')
p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';t=p.read_text(encoding='utf-8-sig');t=re.sub(r"  current: 'S-006:.*", "  current: 'S-006: Escravo integrado e validado. Sucubo 20 quadros/4 tiras candidatas; auditadas sem cortes/solidez >=0.90. Aguardando decisao caminhada de contato oposto curto; nenhuma admissao Sucubo. Retorno PLAN-071 preservado.'",t)
t=t.replace('status: EXECUTING_CYCLES','status: AWAITING_OWNER_DECISION').replace('Gerar 82 quadros restantes','Resolver decisao Sucubo, integrar se autorizado; gerar 63 quadros restantes').replace('cycles_generated: 19','cycles_generated: 38')
t=t.replace("review: '.atena/generated/shendilavri-resume/v01/shendilavri_identities_v01_complete.png'","review: '.atena/generated/shendilavri-resume/v01/sucubo_compact_review.png'").replace("evidence: '.atena/evidence/shendilavri-identities-resume-2026-10-07.md'","evidence: '.atena/evidence/shendilavri-sucubo-preview-2026-10-07.md'")
p.write_text(t.rstrip()+'\n',encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-017-mobs-shendilavri.md';t=p.read_text(encoding='utf-8');a=t.index('### `sucubo`');b=t.index('### `guarda_do_castelo`');t=t[:a]+t[a:b].replace('- [ ]','- [x]')+t[b:];t+='\n2026-10-07 — Sucubo: 20 quadros prontos como candidatas (19 novos), quatro tiras tecnicas, sem admissao. move02 v02 e move03 v03 alternam pernas; move04 v01 antecipa retorno, decisao humana pendente apos tres versoes. death04 v03 preserva arma na mao, death05 v03 tecido existente cobre corpo; v02 armadura nova rejeitada. Fontes nativas e prompts preservados, 20 sem cortes/solidez >=0.90; recibo sucubo-preview-receipt.json, prancha sucubo_compact_review.png. 63 quadros novos restantes (Guarda, Master, Malcanthet).\n';p.write_text(t,encoding='utf-8')
p=root/'.atena/evidence/shendilavri-sucubo-preview-2026-10-07.md';p.write_text('# Shendilavri — Sucubo, previa\n\nPLAN-053 / SPEC-121, IN_PLAN. 20 quadros selecionados para previa, 19 novos. Quatro tiras tecnicas prontas. Nenhuma admissao oficial Sucubo, runtime e build ainda nao validados para este ator.\n\n[Recibo e hashes das tiras](../generated/shendilavri-resume/v01/sucubo-preview-receipt.json). [Auditoria das 20 fontes](../generated/shendilavri-resume/v01/sucubo-selected-source-audit.json). [Prancha compacta](../generated/shendilavri-resume/v01/sucubo_compact_review.png). [Decisao pendente](../generated/shendilavri-resume/v01/sucubo-walk-decision.json).\n\nAlfa nativo, solidez >=0.90 e nenhum corte visivel. A caminhada conseguiu passagem e contato oposto, mas retorna cedo no move04; limite de tres versoes atingido. Opcao apresentada ao dono: aceitar contato curto como excecao ou adiar caminhada. Aprovação do Escravo nao vale para Sucubo. Installer impede admissao enquanto esse quadro tem approval_status PENDING_OWNER_DECISION.\n\nAttack01 v02 corrige corte da lamina. Death04 v03 corrige corte sem troca de mao. Death05 v01 nao produziu imagem por moderation_blocked (saida sexual, request4967eb2c-4dcc-45dc-95ea-b9b23b29601d). Alternativa segura com cobertura opaca foi gerada; v02 inventava armadura de placas e foi rejeitada. v03 usa tecido preto/vermelho assentado sobre o corpo, mantendo identidade e arma. Ancoras finais -66/-70 preservam contato corporal apesar da ponta da espada abaixo do corpo, sem alteracao RGB/alfa.\n\nFontes/rejeicoes preservadas. Retorno PLAN-071 mantido. Sem commit, push ou publicacao.\n',encoding='utf-8')
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md']:
 p=root/rel;t=p.read_text(encoding='utf-8');t+='\n2026-10-07 — Shendilavri: identidades aprovadas. Escravo20 quadros/4 tiras integrado; marcha arrastada aceita explicitamente; queue/runtime/suite/smoke nove fases sem falhas, manifesto163 hashes. Evidencia shendilavri-escravo-cycles-2026-10-07.md. Sucubo20 quadros/4 tiras candidatas auditados, aguardando decisao do dono sobre contato oposto curto; nenhuma integracao desse ator. Evidencia shendilavri-sucubo-preview-2026-10-07.md. Pendentes63 novosquadros e admissao Sucubo.\n';p.write_text(t,encoding='utf-8')
print(json.dumps({'preview_sources':20,'preserved_pngs':receipt['preserved_pngs'],'strips_checked':4,'owner_decision':'pending','official_manifest':163,'remaining_new_frames':63}))
