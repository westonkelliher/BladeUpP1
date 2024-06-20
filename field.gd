extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
	if Input.is_action_just_pressed("down"):
		var rock = preload("res://lil_item.tscn").instantiate()
		$Player._hand_item = rock
