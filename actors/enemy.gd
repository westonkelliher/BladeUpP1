extends CharacterBody2D

const SPEED := 520.0
const ACC := 80.0
const SPRING := 1.5
const DEC := 600.0
const ROT := 2.8
const KNOCK_FORCE := 700.0
const DMG := 2

var _target: Node = null

func _process(delta):
	pass
	#KNOCK_FORCE = 700.0

func set_target(target: Node):
	_target = target
	target.died.connect(on_target_died)

func _physics_process(delta):
	change_velocity(delta)
	change_angle(delta)
	#
	#position += velocity*delta
	#var temp_vel = velocity
	#var temp_pos = position
	move_and_slide()
	#position -= velocity
	#velocity = temp_vel
	#position = temp_pos

func change_angle(delta):
	if _target == null or !is_instance_id_valid(_target.get_instance_id()):
		return
	var target_angle = (_target.position - position).angle()
	var diff = abs(rotation-target_angle)
	var weight = min(1, ROT*delta/diff)
	rotation = lerp_angle(rotation, target_angle, weight)

func change_velocity(delta):
	if _target == null or !is_instance_valid(_target):
		velocity = velocity.move_toward(Vector2.ZERO, DEC*delta)
		return
	# damp
	var target_vel = (_target.position - position).normalized()*SPEED 
	var angle_multiplier = max(0, cos(rotation - target_vel.angle()))
	target_vel *= angle_multiplier
	var acc_factor = ACC + (target_vel - velocity).length()*SPRING
	velocity *= 1.0 - (1-angle_multiplier)*delta
	velocity = velocity.move_toward(target_vel, acc_factor*delta)

func _on_area_2d_body_entered(body):
	print("area")
	if body.has_method("take_damage"):
		# Only apply damage to a player if this instance of the game is the
		# owner of that player. Same thing for non-players but the
		# server-instance of the game (the host player's game) is always the
		# authority
		if body.is_multiplayer_authority():
			body.take_damage(DMG)
	#TODO: impulse calculation copied from sumos
	var knock = (position - body.position).normalized()*KNOCK_FORCE
	velocity *= 0.3
	velocity += knock
	body.velocity *= 0.5
	body.velocity -= knock

func on_target_died(target):
	_target = null
