extends Camera2D
onready var player = get_parent()

func _process(_delta):
	position = player.position
