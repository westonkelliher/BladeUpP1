extends Node2D
class_name HealthComponent

signal death

@export var MAX_HEALTH := 10
var health: float

func _ready():
	health = MAX_HEALTH

func take_damage(dmg: int):
	health -= dmg
	var bar = $HealthBar
	if bar is HealthBar:
		bar.set_progress(health/MAX_HEALTH)
		bar.visible = true
	#
	if health <= 0:
		death.emit()
