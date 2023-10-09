# main.gd
extends Node2D

@onready var hud = $UILayer/HUD

func _ready():
	hud.roundNumber = 0


func _unhandled_input(_event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

