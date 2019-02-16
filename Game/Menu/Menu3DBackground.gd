extends Spatial

#warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("menu_rotate")
	$cactus/AnimationPlayer.play("idle_anim")
	$Timer.start()

func _on_Timer_timeout():
	play_cact_random()

func play_cact_random():
	match randi()%3+1:
		1:
			$cactus/AnimationPlayer.play("climb_anim")
		2:
			$cactus/AnimationPlayer.play("walk_anim")
		3:
			$cactus/AnimationPlayer.play("idle_anim")
