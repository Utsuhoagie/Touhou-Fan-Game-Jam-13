extends StaticBody2D
class_name Block

@export var hp := 1

@onready var break_timer: Timer = $BreakTimer
@onready var break_sfx: AudioStreamPlayer = $BreakSFX
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var stage = get_tree().current_scene

var score_label_preload = preload("res://entities/common/score_label.tscn")


func _on_area_2d_body_entered(_body: Node2D):
	hp -= 1
	if hp == 0:
		stage.combo += 1
		var score: int = 200 * stage.combo
		stage.score += score

		var score_label: ScoreLabel = score_label_preload.instantiate()
		score_label.text = str(score)
		score_label.global_position = global_position
		stage.add_child(score_label)

		sprite.play("break")
		break_sfx.play()
		break_timer.start()
		await break_timer.timeout

		stage.decrease_blocks(1)
		queue_free()

