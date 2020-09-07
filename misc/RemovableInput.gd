class_name RemovableInput
extends HBoxContainer

onready var edit = $LineEdit
onready var button = $Button


func _on_Button_pressed():
	queue_free()
