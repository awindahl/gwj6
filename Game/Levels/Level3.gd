extends Spatial

onready var water = get_node("waterBody")
onready var player = get_node("Player")
var number = 0
var time = 0
var score = 0
var temp = 0
var gameOver = false
var gameClear = false
var raise = true

func _process(delta):
	_raiseWater()
	if player.levelComplete:
		if !gameClear:
			raise = false
			gameClear = true
			$Environment/win.play(0)
		$LevelEndScreen/Layer1.visible = true

		if number <= 3.0:
			number += 0.1

		if number <= 8:
			$LevelEndScreen/Layer1/Layer2.modulate.a = number

		$LevelEndScreen/Layer1/Layer2/TimeBonus.text = var2str(round(time/60)) + " : " + var2str(stepify(time, 1))

		if player.health == 2:
			$LevelEndScreen/Layer1/Layer2/Health1.visible = true
			$LevelEndScreen/Layer1/Layer2/Health2.visible = true
			score = 100
		elif player.health == 1:
			$LevelEndScreen/Layer1/Layer2/Health1.visible = true
			$LevelEndScreen/Layer1/Layer2/Health2.visible = false
			score = 50

		if temp == 0:
			temp = 1
			score /= round(time/10)

			print(score)
			if score >= 20:
				$LevelEndScreen/Layer1/Layer2/Rank.text = "S"
			elif score < 20 and score >= 15:
				$LevelEndScreen/Layer1/Layer2/Rank.text = "A"
			elif score < 15 and score >= 13:
				$LevelEndScreen/Layer1/Layer2/Rank.text = "B"
			elif score < 13 and score >= 10:
				$LevelEndScreen/Layer1/Layer2/Rank.text = "C"
			else:
				$LevelEndScreen/Layer1/Layer2/Rank.text = "D"

	else:
		time += delta
		if player.health < 1 && !gameOver:
			raise = false
			gameOver = true
			$Environment/lose.play(0)

		if water.translation.y > player.translation.y+5 && !gameOver:
			raise = false
			gameOver = true
			$Environment/lose.play(0)
			$Player._die()

func _raiseWater():
	if raise:
		water.translate(Vector3(0,0.0005,0))

func _on_ambient_finished():
	$Environment/ambient.play(0)

func _on_badmusic_finished():
	$Environment/badmusic.play(0)