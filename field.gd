extends Node2D

signal enemy_spawned()


var players: Array = []
var enemies: Array = []


#### Setting and Getting ####
func add_player(player: Player):
	players.append(player)
	player.died.connect(_handle_player_death)
	player.item_thrown.connect(_on_item_thrown)

func add_enemy(enemy: Enemy):
	enemies.append(enemy)
	enemy.position = choose_enemy_position()
	if players.size() > 0 and players[0] is Node:
		enemy.set_target(players[0])
	#enemy.died.connect(handle_enemy_death)


#### Helpers ####
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


#### Signal Handlers ####
func _handle_player_death(player: Player):
	players.erase(player)
	player.queue_free()


func _on_item_thrown(player: Player, item: Projectile):
	item.rotation = player.rotation
	item.position = player.position + Vector2.RIGHT.rotated(player.rotation)*60
	item.linear_velocity = (item.position - player.position).normalized()*600
	add_child(item)
	print("B")
	

func _on_enemy_spawn_timeout():
	enemy_spawned.emit()
