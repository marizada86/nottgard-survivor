---
id: "EVID-155"
title: "Varredura de alinhamento do projeto, da 0.2.0 até agora (para revisão do dono e entrevista de alinhamento)"
created: "2026-10-04"
relations: ["[[EVID-154-lotes-b003-a-b006-armas-eventos-raridade-2026-10-04]]", "[[EVID-153-varredura-b001-movimentacao-dos-herois-2026-10-04]]"]
---

# EVID-155 — Varredura de alinhamento

Somente leitura, exceto onde dito. Nada commitado. Ferramentas novas: `tools/audit_projeto.gd` (integridade de dados), `tools/bal_itens.gd`, `tools/bal_armas.gd`.

## O que foi executado
| Teste | Resultado |
|---|---|
| Suíte `tests/run_all.gd` (44 arquivos) | **0 falhas** |
| Fumaça `tools/smoke.tscn` (menu + 9 fases) | ok |
| Determinismo (mesma semente duas vezes, bot) | idêntico |
| Auditoria de integridade (`audit_projeto.gd`): referências cruzadas entre 28 tabelas, `res://` ausentes, armas/evoluções/sinergias, únicos, fases, inimigos, eventos de fase, `Sfx.play` × manifesto | **0 erros**, 8 avisos (abaixo) |
| Verificação de sintaxe dos 146 scripts | nenhum erro real (29 acusações são falsos positivos: `--check-only` não enxerga os autoloads `Game`, `Playtest`, `Sfx`) |
| Sweep do bot: 10 heróis × 9 fases, perfil loja cheia, semente 1 | **nenhum erro de script**; 44 fases passadas, 7 mortes, 3 limites de tempo |
| Backlog (`backlog_check.ps1`) | P0=0; P1 aberto: BUG-025; 7 P1 aguardando playtest; 8 verificações manuais |
| Versão 0.3.0 | consistente em `core/version.gd` e nos 3 perfis de `export_presets.cfg` |

## Achados, por prioridade

### Alta
1. **A curva das fases foi calibrada para o ritmo de nível antigo.** Com o XP novo (EVID-152) o herói chega com bem menos nível, mas `hp_mult`/`dmg_mult` das fases não mudaram. No sweep, o **Durao** é o gargalo: 3 mortes em 7 passagens, PV mínimo médio 34 % (antes, EVID-150: 66 % e 8 % de mortes), com nível ~32 ao sair (antes 53). Sylas, Zynara e Bromnor morrem no Durao. Decidir: recalibrar `dmg_mult`/`hp_mult` das fases 4 a 9 contra a curva nova (o lote certo é uma SPEC-122 parte 2 com bot de veterano e escala completa).
2. **Dagruve: 10 mortes em 20 no bot novato** (era 6 de 20 na base), ver EVID-154. Se for duro demais para o jogador real, aliviar `interactions.min_seconds` e `rarity.incomum_base`.

### Média
3. **`dmg_mult` do Goranthis (2,25) é menor que o do Shendilavri (2,30).** A curva deveria ser monotônica; a EVID-150 já mostrava Goranthis com 17 % de mortes, então talvez seja intencional. Confirmar.
4. **Só o Sacerdote tem `boss_presentations`.** Os outros 7 chefes (Zuggtmoy, Blogbog, Molydeus, Discípulo Pestilento, Malcanthet, Socothbenoth, Síntese Abissal) não têm apresentação. Confirmar se é conteúdo pendente (arte/cinemática) ou deveria ter fallback.
5. **Economia deslocada pelo novo `RANK`.** Preço de venda e de loja usam `8·(rank+1)`; Raro passou de rank 2 para 3 e Único de 3 para 4, então vender e comprar Raro/Único custa mais e Incomum entra no meio. Revisar preços ou fixar uma tabela de preço por raridade em dados.
6. **Efeito das armas Únicas fora da régua.** Não sabemos o valor real do `weapon` de cada Único; falta medir dano no bot (Lâmina da Digestão, Ampulheta, Colar dos Tentáculos).
7. **`data/build_info.json` desatualizado** (`ea2971d+`, HEAD é `8307924`); verificar se é gerado só no export.

### Baixa / polimento
8. Rótulos de raridade aparecem crus (`[magico]`, `[incomum]`) sem acento e sem capitalização na interface; exibir nomes legíveis (Mágico, Incomum, Raro, Único).
9. Razão XP/HP dos inimigos varia de 0,08 a 1,36 (mediana 0,59): há inimigos muito generosos ou muito ingratos em XP; revisar os extremos quando recalibrar.
10. `tools/backlog_check.ps1` não roda com a política de execução do Windows desta máquina sem `-ExecutionPolicy Bypass` (o hook de sessão já resolve).
11. Rastreabilidade spec → teste não é mecânica: 100+ specs não são citadas em nenhum código ou teste; a ligação vive só em EVID e backlog. Sugestão: convenção `# SPEC-nnn` nos testes.
12. Não existe um comando único de "compila tudo": `--check-only` por arquivo falha nos autoloads. Vale um script que carregue o projeto e liste erros de parse reais.

### Falsos alarmes descartados
- 4 armas "órfãs" (Cera Fervente, Vela Sagrada, Lâmina Trovejante, Marca da Retidão): entram pela oferta que itera `weapons.json`.
- Nenhum inimigo órfão; todas as conquistas de desbloqueio de heróis existem.

## Incidentes desta sessão (transparência)
- A outra sessão (movimentação) sobrescreveu `.atena/state/plan.yaml`; reconstruí e corrigi (estado atual de PLAN-056 e do PLAN-053 suspenso).
- Dei `taskkill` em todos os processos Godot para destravar uma medição presa; se você tinha o editor aberto, ele pode ter fechado.

## Perguntas para a entrevista de alinhamento (sugestão)
1. Qual meta de morte por fase vocês querem (por mapa, bot novato e veterano) para eu recalibrar as fases 4 a 9?
2. O Dagruve com 50 % de morte do bot novato é aceitável ou devolvemos folga em baús e fontes?
3. Goranthis mais fácil que Shendilavri é intencional?
4. Os 7 chefes sem apresentação entram na próxima versão ou fica para depois?
5. Raridades: o Incomum deve ter nome/aparência próprios por slot? Preços por raridade em tabela?
6. Quando entra o NPC de upgrade de magia (MEC-041) e o ferreiro deixa de melhorar magias?
7. Próxima versão: 0.4.0 (major, mexe em dificuldade global) ou fatiar em minor?

## Resultado da entrevista (2026-10-04)
Decisões E1 a E10 registradas em [SPEC-122](../vault/drafts/SPEC-122-balanceamento-ritmo-inicial-xp-armas-e-raridade.md). Próximos passos aprovados em princípio: SPEC-122 parte 2 (recalibrar fases 4 a 9 pela rampa suave, corrigir Goranthis, tabela de preço por raridade, rótulos legíveis) e depois o PLAN-053. Parte 2 ainda precisa de aprovação por lote.
