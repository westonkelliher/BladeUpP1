extends CharacterBody2D
class_name Player

signal test_signal()
signal died(player: Player)
signal item_thrown(player: Player)

#### Constants ####
const SPEED = 400.0
const ACC = 5000.0
const PROGRESS_SPEED = 0.8



#### Identifiers ####
#func health() -> HealthComponent:
#	return $D/Health


#### Members ####
var _faced_object: Node = null
#
var _progress := 0.0 :
	set(value):
		_progress = clamp(value, 0.0, 1.0)
		$D/ProgressBar.set_progress(value)
		if value == 0.0:
			$D/ProgressBar.visible = false
		else:
			$D/ProgressBar.visible = true
	get:
		return _progress
#
var _multiplayer_id: int = -1

#### Builtins ####
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	position = Vector2.ONE*300

func _process(delta):
	$D/ProgressBar.position = position + Vector2(0, -85)
	$D/Health/HealthBar.position = position + Vector2(0, 85)

func _physics_process(delta):
	if !is_multiplayer_authority():
		#move_and_slide()
		return
	handle_movement(delta)
	if $Caster.get_collider() != _faced_object:
		_faced_object = $Caster.get_collider()
		_progress = 0.0
	#
	if Input.is_action_pressed("operate"):
		operate(delta)
	elif Input.is_action_just_released("operate"):
		_progress = 0.0
	elif Input.is_action_just_pressed("interact"):
		interact()
	elif Input.is_action_just_pressed("throw"):
		throw()
	#if Input.is_action_just_pressed("process"):
		#_hand_item = null


#### Process Helpers ####
func handle_movement(delta):
	var move_vec = Vector2.ZERO
	if Input.is_action_pressed("right"):
		move_vec += Vector2.RIGHT
		test_signal.emit()
	if Input.is_action_pressed("left"):
		move_vec += Vector2.LEFT
	if Input.is_action_pressed("up"):
		move_vec += Vector2.UP
	if Input.is_action_pressed("down"):
		move_vec += Vector2.DOWN
	if move_vec != Vector2.ZERO:
		var target = move_vec.normalized()*SPEED
		velocity = velocity.move_toward(target, ACC*delta)
		rotation = move_vec.angle()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACC*delta)
	move_and_slide()


#### Interaction and Operation ####
func interact():
	if _faced_object is Table:
		interact_table()
	pass

func interact_table():
	var table = _faced_object
	if $HeldItem.is_none():
		set_held_item(table.take_item())
	elif table.can_add_item():
		table.add_item($HeldItem._type)
		set_held_item(LilItem.Type.NONE)

# TODO: Combine boulder and table into one class with an overridable operate() 
#       function (or do the equivalent of that that's appropriate in godot).
#       Then you can have an initialization function that supplies the graphic 
#       and function (and whatever else) when it's built. Also interact() and
#       complete().
func operate(delta):
	if !operate_():
		return
	if _progress == 0.0:
		start_operate()
	_progress += PROGRESS_SPEED*delta
	if _progress == 1.0:
		complete()

func start_operate():
	rpc("sync_start_operate", PROGRESS_SPEED)

# returns true if there's something to be processed
func operate_():
	if _faced_object is Boulder:
		return operate_boulder()
	if _faced_object is Table:
		return operate_table()
	return false

func operate_boulder():
	if $HeldItem.is_none():
		return true
	return false

func operate_table():
	var table = _faced_object
	if $HeldItem.is_none():
		return table.held_item() == LilItem.Type.ROCK
	return false

# TODO: Combine boulder and table into one class with an overridable complete() 
#       function (or do the equivalent of that that's appropriate in godot).
#       Then you can have an initialization function that supplies the graphic 
#       and function (and whatever else) when it's built. Also operate() and
#       interact().
func complete():
	_progress = 0
	if _faced_object is Boulder:
		complete_boulder()
	if _faced_object is Table:
		complete_table()

func complete_boulder():
	var rock = preload("res://items/lil_item.tscn").instantiate()
	set_held_item(LilItem.Type.ROCK)

func complete_table():
	var table = _faced_object
	table.add_item(LilItem.Type.BLADE)

func set_held_item(type: LilItem.Type):
	rpc("sync_held_item", type)



#### Action ####
func take_damage(dmg: int):
	$D/Health.take_damage(dmg)
	rpc("sync_health", $D/Health.health)

func throw():
	if $HeldItem._type == LilItem.Type.BLADE:
		var projectile = preload("res://projectile.tscn").instantiate()
		projectile._type = Projectile.Type.BLADE
		item_thrown.emit(self, projectile)
		

#### RPC and Syncapation ####
@rpc("call_remote")
func sync_start_operate(speed: float):
	$D/ProgressBar.set_visual_rate(speed)

@rpc("call_local")
func sync_held_item(type: LilItem.Type):
	print(name+str(type))
	$HeldItem._type = type

@rpc("call_remote")
func sync_health(health: int):
	$D/Health.health = health


func _on_health_death():
	died.emit(self)
