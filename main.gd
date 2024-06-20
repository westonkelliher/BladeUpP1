extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_multiplayer_authority(get_multiplayer_authority())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
