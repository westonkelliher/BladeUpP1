extends CharacterBody2D


#### Constants ####
const SPEED = 300.0
const ACC = 5000.0
const PROGRESS_SPEED = 1.0


#### Members ####
var _hand_item: Node = null:
	set(value):
		_hand_item = value
		for child in $Hands.get_children():
			$Hands.remove_child(child)
		if _hand_item != null:
			$Hands.add_child(value)
	get:
		return _hand_item
#
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


#### Builtins ####
func _process(delta):
	$D/ProgressBar.position = position + Vector2(0, -85)

func _physics_process(delta):
	handle_movement(delta)
	if $Caster.get_collider() != _faced_object:
		_faced_object = $Caster.get_collider()
		_progress = 0.0
	if Input.is_action_pressed("operate"):
		operate(delta)
	elif Input.is_action_just_released("operate"):
		_progress = 0.0
	elif Input.is_action_just_pressed("interact"):
		_hand_item.queue_free()
		_hand_item = null
	#if Input.is_action_just_pressed("process"):
		#_hand_item = null


#### Process Helpers ####
func handle_movement(delta):
	var move_vec = Vector2.ZERO
	if Input.is_action_pressed("right"):
		move_vec += Vector2.RIGHT
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
func operate(delta):
	if !operate_():
		print("false")
		return
	_progress += PROGRESS_SPEED*delta
	print(_progress)
	if _progress == 1.0:
		print("done")
		complete()
	
# returns true if there's something to be processed
func operate_():
	if _faced_object is Boulder:
		print("a")
		return operate_boulder()
	return false

func operate_boulder():
	print(_hand_item == null)
	return _hand_item == null

func complete():
	_progress = 0
	if _faced_object is Boulder:
		complete_boulder()

func complete_boulder():
	print("ok")
	var rock = preload("res://lil_item.tscn").instantiate()
	_hand_item = rock

