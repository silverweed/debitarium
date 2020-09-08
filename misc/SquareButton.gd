extends Button

func _ready():
	call_deferred("setup")
	

func setup():
	rect_min_size.y = get_parent().rect_min_size.y
	rect_min_size.x = rect_min_size.y
	rect_size.y = get_parent().rect_size.y
	rect_size.x = rect_size.y
