extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(PackedScene) var level

var _current_level: Node
var _current_scene: PackedScene
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Crear datos de uso transversal
	Data.data_set('moves', 0)
	
	load_level(level)

	Events.connect('level_finished', self, '_load_next')
	Events.connect('level_restarted', self, '_restart')


func load_level(scene: PackedScene) -> void:
	if _current_level:
		_current_scene = null

		$World.remove_child(_current_level)
		_current_level.queue_free()
	
	_current_scene = scene
	_current_level = scene.instance()
	
	$World.add_child(_current_level)
	# Poner el contador de movimientos a 0 para el nuevo nivel
	Data.data_set('moves', 0)
	Events.emit_signal('level_started', int(_current_level.name))

	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _load_next() -> void:
	var next_level: PackedScene = (_current_level as Level).next_level
	if next_level:
		load_level(next_level)
	else:
		$GUI.game_finished()


func _restart() -> void:
	load_level(_current_scene)
