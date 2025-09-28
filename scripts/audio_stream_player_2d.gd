extends AudioStreamPlayer2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _ready():
	finished.connect(_on_finished)

func _on_finished():
	play()
