extends Control

onready var items: Container = $Container/Items
onready var confirmation_container: Container = $Container/ConfirmationContainer

func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_visibility()

func _on_visibility_changed():
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	get_tree().paused = visible

func _on_ResumeButton_pressed() -> void:
	hide()

func _on_MainMenuButton_pressed() -> void:
	show_confirmation()

func _on_YesButton_pressed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.MAIN_MENU_SCENE)

func _on_NoButton_pressed() -> void:
	hide_confirmation()

func show_confirmation() -> void:
	items.hide()
	confirmation_container.show()

func hide_confirmation() -> void:
	items.show()
	confirmation_container.hide()

func toggle_visibility() -> void:
	if visible:
		hide()
	else:
		show()
