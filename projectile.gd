extends RigidBody2D
class_name Projectile

enum Type {NONE = 0, ROCK, BLADE}

var graphics := {
	Type.NONE : preload("res://images/sumo_spin.png"),
	Type.ROCK : preload("res://images/rock.png"),
	Type.BLADE : preload("res://images/rock_blade.png"),
}

var _type := Type.NONE:
	set(value):
		_type = value
		$Sprite.texture = graphics[_type]
	get:
		return _type
