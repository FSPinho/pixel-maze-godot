extends StaticBody2D

var Spike = preload("res://scenes/world/Spike.tscn")

##
# Properties
var active = true
var bounds = Rect2(0, 0, 0, 0)
var active_color = "#607D8B"
var active_color2 = "#90A4AE"
var active_color3 = "#B0BEC5"
var inactive_color = "#000"

var spikes = []
var fails = []

func _draw():
	draw_rect(bounds, active_color if active else inactive_color, true, 0, true)
	draw_rect(Rect2(bounds.position * 0.95, bounds.size * 0.95), active_color2 if active else inactive_color, true, 0, true)
	draw_rect(Rect2(bounds.position * 0.8, bounds.size * 0.8), active_color3 if active else inactive_color, true, 0, true)

	if active:
		for f in fails:
			draw_rect(f.rect, f.color, true, true)

func initialize(w, h, enable_spikes = false):
	bounds = Rect2(w / -2, h / -2, w, h)
	$Collision.shape.extents = Vector2(w / 2, h / 2)
	
	if enable_spikes:
		for pos in [
			Vector2(w / -2, h / -2), 
			Vector2(w / 2, h / -2), 
			Vector2(w / -2, h / 2), 
			Vector2(w / 2, h / 2)
		]:
			var spike = Spike.instance()
			spike.position = pos
			add_child(spike)
			spikes.append(spike)
	
	for i in range(randi() % 3):
		fails.append({
			"rect": Rect2(
				Vector2(bounds.position.x * randf() * 0.8, bounds.position.y * randf() * 0.8), 
				bounds.size * (randf() * 0.3 + 0.1)
			),
			"color": [active_color, active_color2][randi() % 2]
		})

func set_inactive():
	$Collision.queue_free()
	for s in spikes:
		s.queue_free()
	bounds = Rect2(bounds.size.x / -1.5, bounds.size.y / -1.5, bounds.size.x, bounds.size.y)
	active = false
