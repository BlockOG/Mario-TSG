extends Area2D


signal body_entered_coin(body, coin)


func _on_Coin_body_entered(body):
	emit_signal("body_entered_coin", body, self)
