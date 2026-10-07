from pathlib import Path
import re
p = Path(__file__).resolve().parents[4] / 'tools/controller_check.gd'
s = p.read_text(encoding='utf-8')
s = s.replace('extends SceneTree', 'extends Node\n@onready var root: Window = get_tree().root')
s = s.replace('var Game: Node\nvar Playtest: Node\nvar Data: Node\n', '')
s = s.replace('func _init()', 'func _ready()')
s = s.replace('\tGame = root.get_node("Game")\n\tPlaytest = root.get_node("Playtest")\n\tData = root.get_node("Data")\n', '\tget_tree().current_scene = null\n')
s = s.replace('await process_frame', 'await get_tree().process_frame')
s = s.replace('await create_timer(', 'await get_tree().create_timer(')
s = re.sub(r'(?<!\.)\bcurrent_scene\b', 'get_tree().current_scene', s)
s = re.sub(r'\bpaused\b', 'get_tree().paused', s)
s = s.replace('\tquit(', '\tget_tree().quit(')
p.write_text(s, encoding='utf-8')
