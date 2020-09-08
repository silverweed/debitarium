class_name RemovableControl
extends Control

var button: Button

func _ready():
	button = get_node("Button")
	button.connect("pressed", self, "_on_Button_pressed")
	assert(button != null)
	call_deferred("setup")
	

func setup():
	button.rect_min_size.x = rect_min_size.y


func disconnect_signals():
	button.disconnect("pressed", self, "_on_Button_pressed")
	

func _on_Button_pressed():
	queue_free()
