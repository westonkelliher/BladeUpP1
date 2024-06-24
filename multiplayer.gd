extends Node

const IPv4 = "127.0.0.1"
const PORT = 13558

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

func _on_host_pressed():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	$Field/EnemySpawn.start()


func _on_join_pressed():
	peer.create_client(IPv4, PORT)
	multiplayer.multiplayer_peer = peer


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	$Field.players.append(player)


func choose_enemy_position() -> Vector2:
	var on_side = randf() < 0.35
	var second_side = randf() < 0.5
	var x = 0.0
	var y = 0.0
	if on_side:
		x = 1920*int(second_side)
		y = randf()*1080
	else:
		x = randf()*1920
		y = 1080*int(second_side)
	return Vector2(x,y)

func _on_field_enemy_spawned():
	var enemy = enemy_scene.instantiate()
	enemy.position = choose_enemy_position()
	add_child(enemy, true)
	if $Field.players.size() > 0:
		enemy.set_target($Field.players[0])

