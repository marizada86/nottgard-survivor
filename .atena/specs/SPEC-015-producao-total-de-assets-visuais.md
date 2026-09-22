# SPEC-015 — Produção total dos assets visuais

Status: **concluída e reconciliada em 2026-09-22**

## Intenção aprovada

Executar integralmente `PLAN-003-geracao-total-assets-2026-09-21.md`, sem um segundo gate de aprovação: completar prompts e manifesto, gerar todas as imagens, processar, integrar, validar e reconciliar.

## Escopo

- 236 PNGs finais e 1 ícone vetorial, conforme `ASSET-MATRIX-002`.
- Harmonização dos 5 retratos e 10 inimigos legados, sem apagá-los antes da substituição validada.
- Uso do vault como fonte canônica e de 13 referências selecionadas de `C:\Users\gui-m\Desktop\nottgard` como identidade/composição.
- ImageGen embutido, uma chamada por imagem distinta; candidatos adicionais somente para corrigir falhas objetivas.
- VFX, telegráfos, partículas e UI estrutural implementados de forma procedural e fora da contagem de PNGs gerados.

## Não objetivos

- áudio, trilha, marketing, página de loja ou publicação;
- expandir o elenco com NPCs sem consumer/ID atual;
- alterar lore, regras ou arquitetura canônica;
- gerar texto dentro de imagens;
- animação quadro a quadro nesta entrega.

## Fontes e precedência

1. `D:\dev\nottgard\vault` e `PLAN-001`;
2. `data/*.json`, cenas e scripts do jogo;
3. referências locais catalogadas em `RESEARCH-002`;
4. `RESEARCH-001` para apoio abissal;
5. decisões derivadas documentadas nos prompts.

Conflitos que mudem espécie, identidade, símbolo, spoiler ou função mecânica interrompem somente o asset afetado; o restante da produção continua.

## Plano de voo aprovado

1. Completar `ART-PROMPTS-001..013` e `ART-SPEC-001`.
2. Gerar e validar o manifesto completo.
3. Produzir o piloto de dez imagens.
4. Produzir heróis e Dagruve.
5. Produzir as demais camadas em ordem.
6. Produzir ícones, pickups, thumbnails e fundos.
7. Criar aliases, integrar consumers e construir galeria/auditoria.
8. Executar validações técnicas, visuais e de jogo.
9. Registrar evidências e reconciliar o estado final.

## Limites e recuperação

- Sem dependências novas, rede adicional, publicação, commit ou push.
- Candidatas ficam em `.atena/generated/art-candidates/`, ignoradas pelo Git.
- Finais entram em `assets/` somente depois da inspeção.
- Máximo de três candidatas por asset, com motivo de correção registrado.
- Arquivos finais existentes recebem backup versionado local antes da substituição; recuperação por restauração seletiva.
- Alterações concorrentes fora desta spec são preservadas.

## Validação

- auditoria de IDs, caminhos, dimensões, alfa, nomes e cobertura;
- inspeção visual de toda candidata final;
- galeria em escala real e screenshots em 1280×720;
- teste dos oito biomas e importação Godot sem erro;
- revisão de lore, watermark, texto acidental, halos e inconsistência de câmera/luz;
- contagem final reconciliada com o manifesto.

## Critérios de aceite

1. Todos os 236 PNGs previstos existem ou possuem decisão de reuso registrada.
2. Todo consumer visual resolve para arquivo, alias ou implementação procedural.
3. Não restam placeholders não aprovados nas cenas de jogo.
4. Todos os assets passam na auditoria técnica e visual.
5. As oito camadas permanecem jogáveis e legíveis.
6. Nenhuma referência contradiz o vault ou expõe conteúdo não permitido.
7. Evidências e manifesto registram origem, prompt, versão e resultado.

## Reconciliação final

- O manifesto encerrou com **236/236 PNGs verificados**: 228 imagens distintas e 8 aliases determinísticos entre arma e item.
- O ícone vetorial do aplicativo foi redesenhado e validado separadamente.
- Todos os consumers visuais previstos foram ligados aos caminhos finais em `assets/`; VFX, telegráfos e estrutura de UI permaneceram procedurais conforme a decisão aprovada.
- A auditoria automática terminou sem warnings e sem errors; dimensões, alfa, aliases, nomes e SVG passaram.
- A suíte de testes terminou com `0 falha(s)` e o smoke test abriu as oito camadas em estado `running` com inimigos carregados.
- A inspeção visual cobriu a galeria completa, as oito camadas, o Quartel e a tela de level-up em 1280×720.
- Os avisos finais do Godot dizem respeito ao diretório `user://`, certificado do sistema e objetos ainda vivos ao encerrar cenas de teste; não indicam falha de importação nem de asset.
- Evidência consolidada: `../evidence/EVID-011-producao-total-assets.md`.
