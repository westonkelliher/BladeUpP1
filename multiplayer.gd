extends Node

const IPv4 = "127.0.0.1"
const PORT = 13558

# TODO: Move these packed scenes and player/enemy spawning logic and the 
#       MultiplayerSpawner to Field.
@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

var peer = ENetMultiplayerPeer.new()

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
	var player: Player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	$Field.add_player(player)


func _on_field_enemy_spawned():
	var enemy: Enemy = enemy_scene.instantiate()
	$Field.add_enemy(enemy)
	add_child(enemy)

