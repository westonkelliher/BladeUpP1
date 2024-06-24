extends Node2D
class_name LilItem

enum Type {NONE = 0, ROCK, BLADE}

var _type := Type.NONE:
	set(value):
		_type = value
		if value == Type.NONE:
			visible = false
		elif value == Type.ROCK:
			visible = true
			$Sprite.frame = 0
		elif value == Type.BLADE:
			visible = true
			$Sprite.frame = 1
		else:
			visible = true
			$Sprite.frame = 2


func is_none() -> bool:
	return _type == Type.NONE
