extends RigidBody2D
class_name Table

#TODO: multiple items := []



func can_add_item() -> bool:
	return $HeldItem.is_none()

func add_item(type: LilItem.Type):
	$HeldItem._type = type
	print(type)

func take_item() -> LilItem.Type:
	var temp = $HeldItem._type
	$HeldItem._type = LilItem.Type.NONE
	return temp


func held_item() -> LilItem.Type:
	return $HeldItem._type
