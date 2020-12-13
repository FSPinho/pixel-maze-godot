extends Node2D

signal die

var alive = true
var target_scale = 1

func _process(delta):
	if alive:
		target_scale = min(target_scale + delta * 4, 1)
	else:
		target_scale = max(target_scale - delta * 4, 0)
		
func die():
	$Particles.emitting = true
	alive = false
	
	emit_signal("die")
