extends Node2D

signal complete()


#### Constants ####
const START_WIDTH = 10.0
const END_WIDTH = 100.0


#### Members ####
var _progress := 0.0
var _shown_progress := 0.0

#### Builtins ####
func _process(delta):
	var move_amt = 0.01 + abs(_progress - _shown_progress)*20.0*delta
	_shown_progress = move_toward(_shown_progress, _progress, move_amt)
	if _progress == 0.0:
		_shown_progress = 0.0
	$Progress.size.x = lerp(START_WIDTH, END_WIDTH, _shown_progress)

func set_progress(p: float):
	_progress = clamp(p, 0.0, 1.0)
	if p >= 1.0:
		complete.emit()
