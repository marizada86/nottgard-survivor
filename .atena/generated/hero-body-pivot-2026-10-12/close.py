"""Persist the audited partial delivery at its existing owner review gate."""
from pathlib import Path
import json
import re
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
a=json.loads((OUT/'audit.json').read_text(encoding='utf-8'))
assert len(a['technical_candidates'])==8 and a['held_candidates']==['AO04','AO07','AO08']
assert a['status']=='STRUCTURAL_QA_PASS_CRITERIA_RECORDED'
m=json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
m.update({'status':'PREPARED_PARTIAL_OWNER_REVIEW_PENDING','completed_steps':3,'current_step_position':4,'remaining_steps_after_current':0,'checkpoint':'S-007/BODY-PIVOT/OWNER-REVIEW-8','technical_candidates':a['technical_candidates'],'held_candidates':a['held_candidates'],'native_visual_inspection':'ALL_ELEVEN_FINAL_V02_STRIPS_INSPECTED','gallery':'index.html','audit':'audit.json','human_visual_acceptance':'PENDING'})
(OUT/'manifest.json').write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for path in [ROOT/'.atena/state/plan.yaml',ROOT/'.atena/state/hero-body-pivot.yaml']:
    state=path.read_text(encoding='utf-8')
    if path.name=='plan.yaml':prefix,tail=state.split('art032_publication_2026_10_12:',1)
    else:prefix,tail=state,''
    prefix=prefix.replace('status: IN_PROGRESS','status: PREPARED_PARTIAL_OWNER_REVIEW_PENDING').replace('checkpoint: S-007/BODY-PIVOT/PREPARE','checkpoint: S-007/BODY-PIVOT/OWNER-REVIEW-8').replace('current_step_position: 2','current_step_position: 4').replace('completed_steps: 1','completed_steps: 3').replace('remaining_steps_after_current: 2','remaining_steps_after_current: 0')
    prefix=re.sub(r"  next_objective:.*", "  next_objective: 'Revisão visual das oito candidatas v02; decidir próximos tratamentos das retidas em escopo próprio'",prefix)
    prefix+='  technical_candidates: [AO02, AO03, AO05, AO06, ER02, ER04, ER05, ER07]\n  held_current: [AO04, AO07, AO08]\n  held_source_separation_or_count: [ER03, ER06, AO09, AO10, ER08, ER09, ER10]\n  gallery: .atena/generated/hero-body-pivot-2026-10-12/index.html\n  audit: .atena/generated/hero-body-pivot-2026-10-12/audit.json\n  evidence: .atena/evidence/hero-body-pivot-2026-10-12.md\n  human_visual_acceptance: PENDING\n  next_execution_authorized: false\n'
    path.write_text(prefix+('art032_publication_2026_10_12:'+tail if path.name=='plan.yaml' else ''),encoding='utf-8')
table='\n'.join(f'| {r["code"]} | {r["body_median"]} | {r["body_spread"]} | {"REVISÃO VISUAL" if not r["reasons"] else "RETIDA: "+", ".join(r["reasons"])} |' for r in a['records'])
(ROOT/'.atena/evidence/hero-body-pivot-2026-10-12.md').write_text('''# Erik e Arlindo — corpo/pivô, 2026-10-12

PLAN-053/SPEC-121 S-007 (posição 7/7 do plano maior), DEV-024/v03/body-pivot-v01. Continuação IN_PLAN **“atena, continuar a fila de assets”**, na rota de preparação já aprovada por plano. [Contrato anterior à transformação](../specs/SPEC-121-retomada-fila-imagens/hero-body-pivot-v01.md). Preparação SOURCES_LANDMARKS/PREPARE/AUDIT concluída (3/4); GALLERY_GATE atual (4/4), aceite humano pendente. Nada disso fecha todo o S-007 da fila.

Onze tiras candidatas v02, sessenta células 256×384, fontes e extrações originais preservadas. Godot 4.7.2 realizou limpeza de traços <=8/255 apenas no derivado, recorte, Lanczos proporcional, escala única por tira e encaixe baseado em cintura/sola. Python somente lê matrizes e grava JSON/HTML. O topo corporal de Erik foi refinado por regiões de cabelo que excluem chama/pomo, após inspeção das extrações; ensaio inicial e suas marcações preservados separadamente. Arlindo usa topo do chapéu. Marcadores anatômicos aproximados e revisão modelada não provam identidade/qualidade artística aceita por humanos.

Referência de altura: 290 px Arlindo, 300 px Erik conforme ART-PROMPTS-060; o 290 genérico para Erik no préflight histórico não foi aplicado. Corpo mediano aferido em raster com faixa anatômica; limite de variação 12 px. Base raster 367/368, ancoragem geométrica y=368; interpolação pode limpar o último pixel de contorno. Margens significativas >=10 px, sem alfa residual 1–8/255 no derivado. Atlas recompõe exatamente as sessenta células; fontes/RGB não foram repintados, não houve zoom por quadro, nem correção da passada cancelada.

| Tira | Corpo mediano px | Variação px | Resultado |
|---|---:|---:|---|
''' + table + '''

Oito candidatas satisfazem os critérios técnicos medidos; aparência, massa, mão da tocha, continuidade de figurino/passada e leitura a 85 px permanecem critérios humanos. AO04 e AO07 excedem a variação corporal; não houve aceite automático de 14/13 px. AO08 não cabe com efeito/corpo na mesma célula mantendo o alvo: candidata diagnóstica mede 176,5 px versus 290. Continua retida; não cortar o efeito, esticar personagem, admitir redução ou ampliar célula silenciosamente. Recomendar decisão futura entre separar o efeito e redefinir canvas/contrato, com novo escopo antes de executar. Nenhuma nova geração ou tentativa de recuperar pixels ausentes.

ER03/ER06 e AO09/AO10/ER08/ER09/ER10 seguem retidas pelas decisões anteriores de contagem/corte/separação. Retratos não foram alterados. Corpo/pivô resolveu apenas a preparação das onze tiras extraíveis. A fila VFX antiga N03 foi verificada como histórica e superada: FILA-022 36/36, FILA-023 60/60 e FILA-027 20/20 no inventário local cf17d7c; não gerar supostas faltantes daquele cursor.

[Galeria com prévias animadas e células](../generated/hero-body-pivot-2026-10-12/index.html), [prancha v02](../generated/hero-body-pivot-2026-10-12/v02/body-pivot-board.png), [auditoria](../generated/hero-body-pivot-2026-10-12/audit.json), [manifesto/marcações](../generated/hero-body-pivot-2026-10-12/manifest.json), [registro Godot](../generated/hero-body-pivot-2026-10-12/v02/preparation.json). Todas as onze tiras finais v02 inspecionadas nativamente; links locais conferidos. Galeria HTML criada, sem afirmar execução/teste dos controles no navegador file:// bloqueado por política. Aviso preexistente de certificados do Godot não impediu a geração; não houve novo erro de script.

Auditoria estrutural passou: vinte fontes e sessenta extrações por hash, runtime/ativos anteriores por snapshot, HEAD e índice vazio preservados; cauda anterior de plan.yaml e retorno PLAN-071 preservados. Nenhuma edição de assets/, ui/, core/ ou data/, nenhuma integração/CANON/commit/push/export. Não repetir suíte do jogo: só candidatos locais e registros mudaram. Conteúdo DRAFT e aceite visual PENDING. Próximo objetivo: revisão concreta das oito candidatas; tratar conflitos/tiras restantes em checkpoint próprio.
''',encoding='utf-8')
path=ROOT/'.atena/backlog/ARTE.md';lines=path.read_text(encoding='utf-8').splitlines()
for i,line in enumerate(lines):
    if line.startswith('| ART-045 |'):
        assert 'body-pivot' not in line
        lines[i]=line[:-1]+' **Preparação local 2026-10-12:** onze candidatas v02/sessenta células; oito com critérios técnicos medidos satisfeitos, AO04/AO07/AO08 retidas; outras sete tiras mantêm impedimentos anteriores. Aceite visual e admissão pendentes, DRAFT. [Evidência](../evidence/hero-body-pivot-2026-10-12.md). |'
        break
path.write_text('\n'.join(lines)+'\n',encoding='utf-8')
print('3/4 preparation steps completed; current 4/4 owner review pending for eight candidates. Three current + seven prior holds preserved.')
