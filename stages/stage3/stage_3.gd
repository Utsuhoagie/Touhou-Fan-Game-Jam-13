extends Node2D

@onready var transition = $Transition


func _ready() -> void:
	transition.fade_from_black()
