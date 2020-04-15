extends CanvasLayer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
onready var arrow = load('res://assets/sprites/gui/cursor-arrow.png')
onready var turn = load('res://assets/sprites/gui/cursor-turn.png')
onready var good = load('res://assets/sprites/gui/cursor-good.png')
onready var bad = load('res://assets/sprites/gui/cursor-bad.png')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Enchular cursor
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(turn, Input.CURSOR_MOVE)
	Input.set_custom_mouse_cursor(good, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(bad, Input.CURSOR_CROSS)
	
	# Escuchar eventos de hijos
	$Control/Restart.connect('pressed', self, '_restart_level')
	
	# Conectarse a eventos
	Events.connect('level_won', self, '_show_win')
	Events.connect('level_lost', self, '_show_lose')
	Events.connect('last_move_alerted', self, '_show_alert')
	Events.connect('level_started', self, '_set_defaults')


func _restart_level() -> void:
	Events.emit_signal('level_restarted')


func _show_win() -> void:
	$Control/Label.text = 'all connected'
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Events.emit_signal('play_requested', 'Sfx', 'Win')
	
	yield(get_tree().create_timer(1), 'timeout')
	
	$Control/Label.text += ' \nall happy'
	
	Events.emit_signal('play_requested', 'Sfx', 'Win')
	_finish_level()


func _show_lose() -> void:
	$Control/Label.text = 'no more moves!'
	
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	
	yield(get_tree().create_timer(1), 'timeout')
	
	$Control/Label.text += '\nclick to restart'
	$Control/Restart.show()


func _show_alert() -> void:
	$Control/Label.text = 'one pose left'


func _set_defaults() -> void:
	$Control/Label.text = ''
	$Control/Restart.hide()


func game_finished() -> void:
	pass


func _finish_level() -> void:
	yield(get_tree().create_timer(1.5), 'timeout')
	Events.emit_signal('level_finished')
	$Control/Label.text = ''
