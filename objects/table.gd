extends RigidBody2D
class_name Table

#TODO: multiple items := []



func can_add_item() -> bool:
	return $HeldItem.is_none()

func add_item(type: LilItem.Type):
	rpc("sync_held_item", type)
	print(type)

func take_item() -> LilItem.Type:
	var temp = $HeldItem._type
	rpc("sync_held_item", LilItem.Type.NONE)
	return temp


func held_item() -> LilItem.Type:
	return $HeldItem._type


#### RPC and Syncapation ####

# WARNING: This function probably has a bug where if two players pick up an item
#          at the same time, it duplicates.
@rpc("any_peer", "call_local")
func sync_held_item(type: LilItem.Type):
	$HeldItem._type = type
