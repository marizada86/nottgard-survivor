extends Node

func _ready() -> void:
	print("Nottgard Survivors v%s" % Version.VERSION)
	add_child(load("res://ui/world.gd").new())
