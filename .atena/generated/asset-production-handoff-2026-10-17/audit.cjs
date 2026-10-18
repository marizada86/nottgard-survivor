'use strict';
// Local handoff inventory. Does not implement assets or certify runtime acceptance.
const fs=require('fs'),path=require('path'),crypto=require('crypto'),root=process.cwd(),dir=__dirname;
const read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'')),hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase(),assert=(v,m)=>{if(!v)throw Error(m)};
const definitions=[
 ['LOT02','asset-lot02-2026-10-15','HUD, catálogo e pilar','Preparar UI e pivô do pilar; respeitar barra atual4px.'],
 ['LOT03','asset-lot03-2026-10-16','Baús, loja, ferreiro, curandeiro e barril','Alfa, base e escala; seis sequências.'],
 ['LOT04','asset-lot04-2026-10-16','Seis quebráveis','Alfa, registro e continuidade de ruptura.'],
 ['LOT05','asset-lot05-2026-10-16','Seis quebráveis adicionais','Alfa, margens, base e escala.'],
 ['LOT06','asset-lot06-2026-10-16','Lança-chamas e seis idles de eventos','FC02v03 retida por origem; MEC-004 depende de implementação.'],
 ['LOT07','asset-lot07-2026-10-16','Nove idles de NPCs','NE06v03 retida por espada; demais exigem preparação.'],
 ['LOT08','asset-lot08-2026-10-16','Props, Graz’zt e jato em quadros individuais','Revisar substituições de FC02/NE06; não liberar retenções antigas automaticamente.'],
 ['LOT09','asset-lot09-2026-10-16','Sete pontos de acontecimento','Alfa, margens e registro.'],
 ['LOT10','asset-lot10-2026-10-16','Eventos e segredos','Alfa, base, escala e pareamento selada/aberta.'],
 ['LOT11','asset-lot11-2026-10-16','Oito ruínas','RU05/RU07 deriva; RU08 contato/deriva retidos.'],
 ['LOT12','asset-lot12-2026-10-16','Reparo das ruínas Durão/Shendilavri/Goranthis','Conferir relação com RU05/07/08; sem liberação implícita.'],
 ['LOT13','asset-lot13-2026-10-16','Manifestação de Juiblex','Alfa, registro, escala e margens JD04/05.'],
 ['LOT14','asset-lot14-2026-10-17','Mímico e Turíbulo','TD retida por crescimento de base; demais alfa/registro.'],
 ['LOT15','asset-lot15-2026-10-17','Costas de Zynara, Leoric e Nyrelia','Nyrelia N/NE retida por registro/cadência; BUG-027 aberto.'],
 ['LOT16','asset-lot16-2026-10-17','Durvall cinco direcoes restantes','P9retida por mao/direcao; alfa/registro/cadencia eP8celulasnaoquadradas.'],
 ['LOT17','asset-lot17-2026-10-17','Durvall SW em seis fontes individuais','Registro/escala/cadencia ealfa pendentes; SW04apos3tentativas. P9historica preservada.'],
 ['FILA029','fila029-production-2026-10-15','Botão JOGAR B01v03','Preparar nove fatias320×64 e validar com texto dinâmico.'],
 ['FILA030','fila030-preparation-2026-10-15/v01','Névoa NB01/NB02 preparada','Derivadas aceitas; implementação e aceite no jogo pendentes.'],
 ['FILA032','fila032-production-2026-10-16','Logotipo LN01v01','Preparação/aceite in-game; não aplicar renomeação por este recibo.']
];
const packages=definitions.map(([id,folder,title,holds])=>{
 const base=path.join(root,'.atena/generated',folder),receipt=read(path.join(base,'visual-acceptance.json')),m=read(path.join(base,'manifest.json'));
 assert(receipt.status.startsWith('APPROVED_'),'not accepted '+id);
 const files={};for(const file of ['index.html','manifest.json','visual-acceptance.json','ENTREGA-PARA-IMPLEMENTACAO.md']){
 const p=path.join(base,file);assert(fs.existsSync(p),'missing '+id+'/'+file);files[file]={path:path.relative(root,p).replaceAll('\\','/'),sha256:hash(p)};}
 return {id,title,folder,holds,content_state:m.content_state??receipt.content_state,visual_acceptance:receipt.status,implementation_owner:'Claude',files};
});
assert(packages.length===19&&packages.every(p=>p.content_state==='DRAFT'),'19 DRAFT packages');
const queue=fs.readdirSync(path.join(root,'.atena/generated')).filter(f=>/^CHATGPT-FILA-\d+.*\.md$/.test(f)).sort().map(f=>{
 const p=path.join(root,'.atena/generated',f),s=fs.readFileSync(p,'utf8'),status=s.match(/^status:\s*(.*)$/m)?.[1]??'UNSPECIFIED';
 return {path:'.atena/generated/'+f,sha256:hash(p),historical_header_status:status};
});
assert(queue.length===31,'local queue catalog changed');
const findings=[
 {scope:'FILA001/009/010/011, cenários e HQs002',result:'Registros locais de produção/admissão anteriores; HQs14/56 em data/hqs.json e56PNGs locais. Não produzir novamente pelo cabeçalho antigo de002.',evidence:'.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md'},
 {scope:'FILA003 e L02 daFILA026',result:'Opcionais/deferidos, não são nova produção obrigatória autorizada.',evidence:'.atena/generated/CHATGPT-FILA-003-hqs-trilha-c.md'},
 {scope:'FILA004..008 e013..019',result:'Evidências posteriores registram conclusão dos ciclos; cabeçalhos de017/018/019 são antigos. Arquivos semidle próprios incluem reuso e lotes recentes já gerados.',evidence:'.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md'},
 {scope:'FILA012',result:'U01..04 emLOT02; U05/06 emLOT06 e reparoLOT08; U07..09 já produzidas. MEC-004 e integração não são falta de geração.',evidence:'.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot02-production-v01.md'},
 {scope:'FILA020..023',result:'Gerações registradas; admissão posterior de VFX. Recuperação integral de originais históricos não foi certificada neste índice.',evidence:'.atena/evidence/vfx-projectiles-hero-abilities-admission-2026-10-13.md'},
 {scope:'FILA024/027 e ART033',result:'Erik/Arlindo18atlas101poses admitidos; não regerar AO09/AO10/ER03/ER06 por pendência histórica. Costas ART033 agora produzidas/aceitas emLOT15, ainda sem implementação.',evidence:'.atena/evidence/hero-admission-2026-10-13.md'},
 {scope:'FILA025/026/028',result:'Produção e preparação anteriores documentadas;028tem34preparaçõesCANON, condição preservada. Não confundir esses registros com os novos lotesDRAFT.',evidence:'.atena/generated/CHATGPT-FILA-028-eventos-arcanista-icones-segredos-e-altar.md'},
 {scope:'FILA029/030/032 e LOT02..17',result:'19entregasDRAFT visualmente aceitas agrupadas; preparação, implementação e playtests continuam pendentes conforme cada manifesto.',evidence:'.atena/generated/asset-lot15-2026-10-17/visual-acceptance.json'},
 {scope:'FILA031/M1 reservado',result:'A consulta anterior so aos31arquivos de fila deixou de fora o escopo reservado no estadoM1/D22: cinco direcoes restantes deDurvall. LOT16 agora produzido em5fontes/30poses, direcao visual aceita comoDRAFT; P9retida por mao/direcao. Agora incluido nos19pacotes aceitos.',evidence:'.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot16-durvall-directions-v01.md'},
 {scope:'Portal, ritual e fonte',result:'Manter fontes existentes conforme plano; não há defeito novo documentado que autorize regeneração.',evidence:'.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot03-interactions-v01.md'}
];
for(const f of findings)if(f.evidence)assert(fs.existsSync(path.join(root,f.evidence)),'evidence '+f.evidence);
const inventory={id:'ASSET-PRODUCTION-HANDOFF',revision:'v01',date:'2026-10-17',origin:'operational-reconciliation',request_classification:'IN_PLAN',owner_request:'aprovado, proximo',production_result:'RESERVED_M1_SCOPE_PRODUCED_LOT16_AWAITING_VISUAL_REVIEW',packages,queue_header_snapshots:queue,findings,scope_limit:'Local catalog reconciliation and handoff links; not complete historical raw-source recovery or runtime verification',runtime_implementation_performed:false,message_sent_to_claude:false,commit_push:false,new_generation_authorized:false,implementation_owner:'Claude'};
fs.writeFileSync(path.join(dir,'inventory.json'),JSON.stringify(inventory,null,2)+'\n');
const rel=p=>path.relative(dir,path.join(root,p)).replaceAll('\\','/');
const rows=packages.map(p=>'<tr><td>'+p.id+'</td><td>'+p.title+'</td><td>'+p.holds+'</td><td><a href="'+rel(p.files['index.html'].path)+'">Galeria</a> · <a href="'+rel(p.files['ENTREGA-PARA-IMPLEMENTACAO.md'].path)+'">Entrega</a> · <a href="'+rel(p.files['manifest.json'].path)+'">Manifesto</a> · <a href="'+rel(p.files['visual-acceptance.json'].path)+'">Aceite</a></td></tr>').join('\n');
const findingRows=findings.map(f=>'<li><strong>'+f.scope+'</strong>: '+f.result+(f.evidence?' <a href="'+rel(f.evidence)+'">Registro</a>':'')+'</li>').join('\n');
const html='<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Entrega de arte para Claude</title><style>body{background:#171d22;color:#eee;font:16px system-ui;max-width:1400px;margin:35px auto;padding:0 24px}p,li{line-height:1.6}a{color:#8bd5de}table{border-collapse:collapse;width:100%}td,th{padding:14px;text-align:left;border:1px solid #48515a}th{background:#2e3841}.warn{color:#edc48c}</style><h1>Fila de arte · entrega consolidada v01</h1><p>19pacotesDRAFT com direção visual aceita. LOT15 incluído:36revisões e seis primeiros quadros aprovados em2026-10-17. As retenções técnicas continuam válidas. Preparação e implementação com Claude.</p><p>A revisão ampliada identificou o escopo reservado daFILA031/M1 que faltava no índice anterior. <a href="../asset-lot16-2026-10-17/index.html">LOT16: cinco direções deDurvall,30poses</a>, agora visualmente aceito comoDRAFT e incluido nos19pacotes. P9retida por mão/direção. Preparação, integração e testes continuam pendentes.</p><p><a href="../asset-lot17-2026-10-17/index.html">LOT17 produzido: seis fontes individuais para SW deDurvall</a>, agora visualmente aceito e incluido nos19pacotes. P9historica retida; registro/escala/cadencia e alfa pendentes.</p><h2>Próxima ordem recomendada para Claude</h2><ol><li>LOT15: costas dos heróis/BUG-027, resolvendo registro e cadência de Nyrelia antes da importação.</li><li>BotãoFILA029, HUD/catálogo/pilarLOT02 e névoaFILA030: elementos de alta visibilidade, respeitando contratos atuais.</li><li>Baús, eventos, NPCs e quebráveisLOT03..12; revisar relações de substituiçãoLOT08/12 sem liberar retenções antigas por inferência.</li><li>JuiblexLOT13 e Mímico/TuríbuloLOT14; verificar crescimento da base deTD antes de integrar. LogotipoFILA032 conforme decisão de nome já existente.</li></ol><p class="warn">Aceite visual das fontes não é validação de alfa, pivô, packing, consumidor ou fluidez. BUG-025/027/028/029 permanecem abertos. O playtest humano exige build e roteiro próprios antes de ocorrer.</p><p><a href="ENTREGA-PARA-CLAUDE.md">Entrega única</a> · <a href="inventory.json">Inventário e hashes dos documentos</a> · <a href="handoff-check.json">Verificação dos links</a> · <a href="source-files-check.json">Integridade de193PNGs de fontes/entregas e392quadrosQA</a></p><table><thead><tr><th>Pacote</th><th>Conteúdo</th><th>Preparação/retenções</th><th>Arquivos</th></tr></thead><tbody>'+rows+'</tbody></table><h2>Reconciliação do catálogo local</h2><ul>'+findingRows+'</ul><p>As34preparaçõesCANON daFILA028 preservam sua autoridade anterior. Os19pacotes acima sãoDRAFT. Nenhuma implementação, mensagem para outro chat, commit ou push realizado nesta continuação.</p></html>';
fs.writeFileSync(path.join(dir,'index.html'),html);
fs.writeFileSync(path.join(dir,'handoff-check.json'),'{}');
let links=0;for(const file of ['index.html','ENTREGA-PARA-CLAUDE.md']){
 const s=fs.readFileSync(path.join(dir,file),'utf8'),matches=file.endsWith('.html')?[...s.matchAll(/(?:src|href)=["']([^"']+)["']/g)]:[...s.matchAll(/\]\(([^)]+)\)/g)];
 for(const m of matches){assert(fs.existsSync(path.resolve(dir,m[1])),'broken link '+m[1]);links++;}
}
const report={status:'PASS_LOCAL_HANDOFF_LINKS_AND_DOCUMENT_SNAPSHOTS',packages:packages.length,package_document_hashes:76,local_queue_headers:31,local_links:links,new_images_generated:0,implementation_performed:false,raw_historical_sources_fully_verified:false,browser_render_verified:false};
fs.writeFileSync(path.join(dir,'handoff-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
