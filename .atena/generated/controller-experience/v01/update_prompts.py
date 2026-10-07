from pathlib import Path
import re
root = Path(__file__).resolve().parents[4]
p = root / 'ui/hud.gd'
s = p.read_text(encoding='utf-8')
s = re.sub(r'\treroll_btn.text = "Rerrolar \(R/LB\).+?% b.rerolls', '\treroll_btn.text = "Rerrolar (%s) — %d restantes" % [Game.controls.prompt("run_reroll", "R"), b.rerolls]', s)
s = re.sub(r'\t\taim_btn.text = "Mira:.+?Game.aim_mode\(\).+\n', '\t\taim_btn.text = "Mira: %s (%s)" % ["AUTO" if Game.aim_mode() == Battle.Aim.AUTO else "MANUAL", Game.controls.prompt("run_toggle_aim", "Tab")]\n', s)
p.write_text(s, encoding='utf-8')
p = root / 'core/playtest.gd'
s = p.read_text(encoding='utf-8')
s = s.replace('RB usa habilidade; oeste interage; norte alterna mira ou extrai; LB rerrola; Start pausa; Back abre itens. Leste confirma e sul volta nas telas.', 'RB/R1 usa habilidade; X/□ interage; Y/△ alterna mira; LB/L1 rerrola; Menu/Options pausa; View/Share/Create abre a ficha. A/× confirma e B/○ volta no preset Padrão; Legado inverte. Extrair e velocidade ficam na pausa; detalhes com RS/R3; abas L1/LB anterior e R1/RB próxima.')
s = s.replace('RB usa habilidade; oeste interage; norte alterna mira ou extrai; Start pausa; Back abre itens. Nas telas, direcional navega, leste confirma e sul volta.', 'RB/R1 usa habilidade; X/□ interage; Y/△ alterna mira; Menu/Options pausa; View/Share/Create abre a ficha. Direcional navega; A/× confirma e B/○ volta no Padrão (Legado inverte). Extrair e velocidade ficam na pausa. Nos detalhes, L1/LB anterior e R1/RB próxima.')
s = s.replace('R ou LB rerrola', 'R ou LB/L1 rerrola')
p.write_text(s, encoding='utf-8')
