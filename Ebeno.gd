extends Area2D


func _ready():
	pass


func _on_Ebeno_body_enter( korpo ):
	clear_shapes()
	var Partoj_ = T.Radiko.Partoj.get_children()
	for Parto_ in Partoj_:
		Parto_.queue_free()
	T.Radiko.Tero.set_global_pos(Vector2(300,get_global_pos().y-880))
	queue_free()
