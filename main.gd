extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_multiplayer_authority(get_multiplayer_authority())
	$Enemy.set_target($Player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_test_signal():
	pass


func _on_field_enemy_spawned(enemy):
	enemy.set_target($Player)
