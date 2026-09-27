---
id: "ART-PROMPTS-017"
type: "prompts-de-arte"
title: "Docas: terreno, introdução de chefe e Maré de Névoa"
status: "generated; dagruve-ground-v04-integrated"
created: "2026-09-26"
relations: ["[[SPEC-034-docas-prompts-introducao-chefes-e-mare-de-nevoa]]", "[[PLAN-009-docas-prompts-e-experiencia-pos-chefe-2026-09-26]]"]
sources: ["D:\\dev\\nottgard\\vault\\04_Locais\\Docas.md", "D:\\dev\\nottgard\\vault\\03_NPCs\\Willie.md", "data/stages.json"]
---

# Docas: prompts finais para revisão

## Direção comum obrigatória

```text
Use case: stylized-concept. Pixel art original para jogo 2D isométrico, câmera fixa em três quartos com grade 2:1, pixels nítidos, paleta noturna fria de azul-petróleo, pedra cinza molhada e madeira escura. Fantasia gótica portuária: estruturas comerciais gastas, sal, ferrugem, umidade e horror sobrenatural localizado. Luz de lua difusa superior esquerda; fontes quentes pontuais de vela ou braseiro. Contraste funcional: o cenário não pode competir com herói, inimigos, projéteis, recompensas ou telegráfos. Violência física verossímil, sem excesso; energia sobrenatural pode brilhar violeta somente em eventos de alto impacto. Sem texto legível, alfabeto, logotipo, marca-d'água, HUD, moldura, personagens incidentais, perspectiva frontal, blur ou estilo 3D renderizado.
```

## Terreno e limites

| ID | Formato | Prompt específico |
|---|---|---|
| `docas_ground_atlas` | Atlas opaco 128×64: quatro losangos 64×32 | Quatro variações compatíveis de calçamento e tábuas de cais úmidas; juntas profundas, sal, pequenas poças escuras, fibras de madeira e ferrugem discreta. Cada losango repete perfeitamente; sem bordas, objetos altos, sangue focal ou sombra direcional. |
| `docas_water_edge` | PNG RGBA 256×256, módulo de borda | Margem modular de cais partido: estacas encharcadas, corda úmida, degraus de pedra e água marítima quase preta com reflexo de lua. Água abaixo da borda; base limpa para encaixar ao chão. |
| `docas_pier_structure` | PNG RGBA 256×256 | Segmento de doca de madeira antiga, duas pilastras grossas, argola de ferro e corrente curta oxidada; sem barco, personagem nem bandeira; silhueta legível em 96 px. |

## Props de atividade e decadência

| ID | Formato | Prompt específico |
|---|---|---|
| `docas_cargo_cluster` | PNG RGBA 256×256 | Conjunto baixo de três caixotes de frete, barril com aro de ferro e saco de lona molhado; etiquetas sem escrita; um caixote rachado e sal acumulado. |
| `docas_nets_and_buoys` | PNG RGBA 256×256 | Rede de pesca pesada enrolada sobre boias apagadas, anzóis opacos e corda embebida em água salgada; composição baixa e não bloqueante. |
| `docas_brazier` | PNG RGBA 256×256 | Braseiro portuário de ferro gasto sobre tripé baixo, carvão vermelho-âmbar e fumaça curta; chama pequena, sem iluminar excessivamente o mapa. |
| `docas_abandoned_store` | PNG RGBA 256×256 | Fachada compacta de armazém portuário abandonado: porta entreaberta, tábuas pregadas, ferrugem, lona rasgada e caixa de suprimentos; nenhum nome ou escrita. |

## Vestígios rituais e atmosfera

| ID | Formato | Prompt específico |
|---|---|---|
| `docas_ritual_crate` | PNG RGBA 256×256 | Caixa de pedra vazia alimentada por uma fissura superior, bandeja de sangue seco, livros e mantimentos revolvidos; marcas abissais abstratas e não legíveis; brilho violeta mínimo, sem símbolo reconhecível. |
| `docas_corroded_metal` | PNG RGBA 192×192 | Viga, corrente e ferramenta portuária parcialmente corroídas por limo; metal inchado, gotas ácidas discretas, mancha verde controlada; objeto baixo. |
| `docas_fog_layer` | VFX RGBA em faixa larga, sem cenário | Névoa marítima azul-esverdeada e cinza, baixa, irregular e sem opacidade central; bordas transparentes, poucos reflexos violeta, adequada para deslocamento lento em camadas. |

## Introdução de chefe — Sacerdote da Mente Derretida

```text
Use case: stylized-concept. Asset type: splash art opaca de introdução de chefe em 16:9, 640×360, pixel art original e cinematográfica para um jogo isométrico de fantasia gótica. Um sacerdote corrompido, alto e magro, veste mantos roxo-enegrecidos, segura um turíbulo de cera quente e tem a mente visivelmente deformada sob um capuz; postura ritualística ameaçadora. Está no fim de uma doca abandonada diante de galpões e água negra. Névoa fria baixa, luz de lua superior esquerda e reflexo violeta contido no turíbulo. Composição: chefe no terço direito, área escura e limpa no terço esquerdo para UI sobreposta, câmera três quartos isométrica. Sem nome, texto, HUD, personagem jogável, logo, moldura, watermark, gore exagerado ou fase alternativa.
```

Aceite: o título e subtítulo são aplicados pela UI; a imagem precisa anunciar o chefe em até dois segundos sem esconder o primeiro telegráfo de combate.

## Maré de Névoa pós-chefe

```text
Use case: stylized-concept. Asset type: camada VFX RGBA para jogo 2D isométrico, sem cenário. Névoa de colapso portuário avança lateralmente: azul-esverdeada salobra, cinza escura, filamentos de espuma e reflexos violeta raros. Transparência alta no miolo, densidade controlada nas bordas, nenhuma forma de rosto, criatura, texto, símbolo, projétil ou luz pulsante que prejudique visibilidade. Deve comunicar perigo ambiental gradual, não uma parede opaca; adequada para cobrir bordas e preservar o centro e o portal legíveis.
```

Aceite: o jogador vê claramente a direção de avanço, a rota de extração e o portal em 1280×720.

## Registro de execução — terreno Dagruve v04

Fonte gerada em 2026-09-27 com o prompt de terreno refinado: calçamento portuário molhado, sem objetos de cena, sem painel/atlas de apresentação e com distribuição regular até as bordas. A fonte foi normalizada por nearest-neighbor para o contrato atual do consumidor (`128×64`, opaca, `Cover`) e registrada como `tiles/dagruve_ground` v04.

- candidata: `.atena/generated/art-candidates/tiles/dagruve_ground_v04.png`;
- asset de jogo: `assets/tiles/dagruve_ground.png`;
- SHA-256: `bf4f86c5580a7a7a9539a1f9042a192eb70c43b4168c5d0330d5b9c949395d62`.

## Portão de geração

Gerar candidatos somente após aprovação explícita destes prompts. Cada candidato deve passar por inspeção de escala real, alfa, legibilidade e integração na cena antes de substituir asset final.
