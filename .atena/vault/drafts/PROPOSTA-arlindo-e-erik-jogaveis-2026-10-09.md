---
id: PROPOSTA-arlindo-erik
title: Arlindo Orlando e Erik Blackthorn jogáveis — fichas, números, textos (portão de conteúdo do PLAN-086)
status: DRAFT aguardando decisão do dono; nada codificado
created: 2026-10-09
relations: ["[[SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis]]", "[[PLAN-086-arlindo-orlando-jogavel-2026-10-09]]"]
---

# Fichas propostas (DRAFT)

Fontes lidas em 2026-10-09: Vault `03_NPCs/Arlindo Orlando.md` e `Erik Blackthorn.md` (só os blocos de consolidação aprovada e as seções de sessão), ficha do Erik no Nottcard, `data/heroes.json`, `weapons.json`, `abilities.json` e as tabelas de arte de `ui/hero_view.gd`. **Fora de uso, de propósito:** Adam e o colar (Arlindo repete boatos sobre Adam, não entra), o Massacre Celestial além do nome, a Síntese, qualquer cânone do mestre. O grupo se chama **Grimholders**.

## Arlindo Orlando (suporte e controle)

| Campo | Proposta | Nota |
|---|---|---|
| Título | Humano · Líder dos Grimholders | Vault S8-10, S9-37 |
| Atributos | FOR 10, INT 13, CON 14, CAR 15 | referência: Nyrelia (INT 14, CAR 16, PV 30) |
| PV base · prof · armadura | 34 · 2 · CA 2, CAM 0 | entre Brook (34) e Sylas (32) |
| Passiva **Olhos de Andarilho** | Ecos e câmaras brilham a **9 tiles** em vez de 6 (×1,5) e **cada Eco dá 20% da barra de XP do nível atual**; desc. no jogo: "Ecos e câmaras brilham de mais longe; cada Eco rende XP." | só o Arlindo; valores a medir (BAL) |
| Arma inicial **Memória Alterada** | magia de projétil, mágico, carisma, 1d6, recarga 2,2 s, alcance 8,5, `slow` 0,35; níveis: 1d8 · lentidão +0,1 · recarga −0,3 · +1 projétil e dano +2 | usa o `slow` que já existe nas armas; nenhum código de arma novo |
| Ativa **Modify Memory** (nome da lore) | nova `kind: forget_nova`: inimigos comuns num raio de 4 tiles **perdem os ataques por 2 s** (chefes só 0,6 s), recarga 18 s; sem dano | reaproveita `stun_t` dos inimigos; diferente da Suspensão de Zynara (essa quase para o tempo) e da Dominação de Nyrelia (essa converte) |
| Desbloqueio | conquista **Ecos de Dagruve** (já existe) | decisão do dono |
| Conquista de bio | `bio_arlindo`: vença uma fase com ele | padrão dos outros |

**Bio (proposta):** "Humano andarilho e líder dos Grimholders, antigos donos das terras onde hoje fica Dagruve. Avisa sobre a névoa que mexe com a mente e usa magia de memória para mostrar o que já aconteceu."

**Falas (proposta):** entrada: "A névoa mexe com a cabeça. Respire fundo." · "Muito antes de Dagruve, aqui era nosso." | chefe: "Eu só aviso: não precisa ser assim." · "Cuidado com o orgulho. É ele que explode tudo." | vida: "Memória é coisa frágil. A minha também." · "Já vi gente pior se levantar."

## Erik Blackthorn (guerreiro de fogo)

| Campo | Proposta | Nota |
|---|---|---|
| Título | Humano · Batedor dos Grimholders | Vault S11; Nottcard: Guerreiro, humano |
| Atributos | FOR 16, INT 12, CON 13, CAR 10 | exatamente a ficha do Nottcard |
| PV base · prof · armadura | 38 · 2 · CA 4, CAM −1 | entre Durvall (36) e Korrak (40) |
| Passiva **Incendiário Procurado** | dano de **fogo e de área +15%** (mods novos `fire_pct` e `area_dmg_pct`); desc.: "Fogo e golpes em área causam 15% a mais." | adaptação do Nottcard (+1d6 contra Roxo/Universal, que não existe aqui) |
| Arma inicial **Tocha do Incendiário** | corpo a corpo, fogo, força, 1d8, recarga 1,5 s, alcance 1,8, cone 70, `burn` 2; níveis: 1d10 · cone +10 · dano +2 · 2d6 e alcance +0,3 | usa `burn` que já existe; ícone provisório (`icon_like`: Espada Sombria ou Machado) |
| Ativa **Navios em Chamas** (gancho do EVID-147) | nova `kind: fire_zone`: faixa de fogo à frente do herói (raio 3) que fere os inimigos por 8 s (2d6 por segundo de tique), recarga 16 s | só zona de chão; sem "navio" no jogo |
| Desbloqueio | proposta: conquista **Ecos de Docas** (já existe) | ele incendiou navios nas Docas; o dono aprova ou troca |
| Conquista de bio | `bio_erik`: vença uma fase com ele | padrão dos outros |

**Bio (proposta):** "Humano batedor dos Grimholders, encontrado além da Tarn, na Vila das Sombras. É imune à névoa por causa do Amuleto da Luz. Guia o grupo e é procurado desde que incendiou navios nas Docas."

**Falas (proposta):** entrada: "A névoa não me pega. O amuleto cuida disso." · "Raspei a barba pra ninguém me reconhecer." | chefe: "Já queimei navio inteiro. Você não é nada." · "Fogo resolve." | vida: "Só preciso de mais um pouco de tempo." · "Ainda de pé. Por enquanto."

## Arte e som provisórios

- **Arte:** `art_like` em `heroes.json`: Arlindo usa a animação de **Sylas** (humanoide de conjurador, sem armadura pesada); Erik usa a de **Durvall** (corpo e golpe de espada). Marca "arte provisória" na seleção. Retratos: o do herói emprestado. Troca por sprites próprios quando o dono entregar.
- **Som:** `hero.arlindo.active` e `hero.erik.active` como alias dos eventos de Sylas e Korrak até haver som próprio.

## Decisões pedidas (portão de conteúdo)

1. Os números e nomes acima de **Arlindo** e **Erik**: aprovados, ou o que muda.
2. **Desbloqueio do Erik**: Ecos de Docas, ou outro.
3. **Bios e falas** dos dois, como estão ou ajustadas.
4. **Quem empresta a arte**: Sylas para o Arlindo e Durvall para o Erik, ou outra escolha.
