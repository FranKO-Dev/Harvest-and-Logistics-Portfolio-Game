extends Control

## Button used to animate.
@export var close_button: BaseButton
@export var animation_player: AnimationPlayer

# Animation string names.
const click_animation = &"ClickCloseButton"
const show_animation = &"ShowCloseButton"

signal close_button_pressed()

# Called when the node is "ready".
func _ready() -> void:
	close_button_pressed.connect(_on_button_pressed)
	close_button.pressed.connect(close_button_pressed.emit)
	
	close_button.disabled = true
	animation_player.play(show_animation)
	close_button.hide()
	

# Called when the button_pressed signal in sent.
func _on_button_pressed():
	animation_player.play(click_animation)
	

## Plays show animation and enables the button.
func show_button():
	close_button.show()
	close_button.disabled = false
	

## Plays hide animation and disables the button from being clicked.
func hide_button():
	close_button.hide()
	close_button.disabled = true
	
