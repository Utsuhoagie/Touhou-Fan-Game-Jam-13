extends Node2D
class_name Stage3

const MAX_LIVES := 3
var lives := MAX_LIVES
var bombs := 3
var grazes := 0

@onready var transition = $Transition
@onready var player3: Player3 = $Player3
@onready var komachi_node: Node2D = $Komachi
@onready var komachi: Komachi = $"Komachi/Path/Path Follow/Komachi CharacterBody"

@onready var grazes_label = $"HUD/GrazesLabel"
@onready var lives_label = $"HUD/LivesLabel"
@onready var bombs_label = $"HUD/BombsLabel"
@onready var arrow = $HUD/Arrow


func _ready() -> void:
	transition.fade_from_black()
	grazes_label.text = str(grazes)
	lives_label.text = str(lives)
	bombs_label.text = str(bombs)


func _process(delta: float) -> void:
	arrow.global_position.x = komachi.global_position.x



func increase_grazes() -> void:
	grazes += 1
	grazes_label.text = str(grazes)


func decrease_bombs() -> void:
	bombs -= 1
	bombs_label.text = str(bombs)


func decrease_lives() -> void:
	lives -= 1
	lives_label.text = str(lives)

	if lives == 0:
		print("lose!")
