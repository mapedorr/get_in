extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(PackedScene) var level

var _current_level: Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Crear datos de uso transversal
	Data.data_set('moves', 0)
	
	load_level(level)

	Events.connect('level_finished', self, '_load_next')


func load_level(scene: PackedScene) -> void:
	if _current_level:
		$World.remove_child(_current_level)
		_current_level.queue_free()
	
	_current_level = scene.instance()
	
	$World.add_child(_current_level)
	# Poner el contador de movimientos a 0 para el nuevo nivel
	Data.data_set('moves', 0)
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _load_next() -> void:
	var next_level: PackedScene = (_current_level as Level).next_level
	if next_level:
		load_level(next_level)
	else:
		$GUI.game_finished()
