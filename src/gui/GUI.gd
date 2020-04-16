extends CanvasLayer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
onready var arrow = load('res://assets/sprites/gui/cursor-arrow.png')
onready var turn = load('res://assets/sprites/gui/cursor-turn.png')
onready var good = load('res://assets/sprites/gui/cursor-good.png')
onready var bad = load('res://assets/sprites/gui/cursor-bad.png')
onready var _level_msg: Label = $Control/LevelMsg
onready var _restart: TextureButton = $Control/Restart
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Enchular cursor
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(turn, Input.CURSOR_MOVE)
	Input.set_custom_mouse_cursor(good, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(bad, Input.CURSOR_CROSS)
	
	# Escuchar eventos de hijos
	_restart.connect('pressed', self, '_restart_level')
	
	# Conectarse a eventos
	Events.connect('level_won', self, '_show_win')
	Events.connect('level_lost', self, '_show_lose')
	Events.connect('last_move_alerted', self, '_show_alert')
	Events.connect('level_started', self, '_set_defaults')


func _restart_level() -> void:
	if _level_msg.text == '': return
	Events.emit_signal('level_restarted')


func _show_win() -> void:
	yield(get_tree().create_timer(1), 'timeout')
	_level_msg.text = 'all in'
	
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Events.emit_signal('play_requested', 'Sfx', 'AllIn')
	
	yield(get_tree().create_timer(1.2), 'timeout')
	
	_level_msg.text += ' \nall happy'
	
	Events.emit_signal('play_requested', 'Sfx', 'AllHappy')
	_finish_level()


func _show_lose() -> void:
	_level_msg.text = 'no more moves!'
	
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	
	yield(get_tree().create_timer(1), 'timeout')
	
	_level_msg.text += '\nclick to restart'
	$Control/Restart.show()


func _show_alert() -> void:
	_level_msg.text = 'one pose left'


func _set_defaults(lvl_num: int = 0) -> void:
	_level_msg.text = ''
	$Control/Restart.hide()
	
	if lvl_num == 1:
		_restart.show()
		_restart.mouse_default_cursor_shape = Input.CURSOR_ARROW
		# Mostrar el Get In
		yield(get_tree().create_timer(1.0), 'timeout')
		Events.emit_signal('play_requested', 'Sfx', 'GetIn')
		$Control/GetIn.show()
		
		$Control/GetIn.text = 'Get'
		yield(get_tree().create_timer(0.8), 'timeout')
		$Control/GetIn.text += ' in'
		_restart.hide()
		_restart.mouse_default_cursor_shape = Input.CURSOR_CROSS
	else:
		$Control/GetIn.hide()


func game_finished() -> void:
	pass


func _finish_level() -> void:
	yield(get_tree().create_timer(1.5), 'timeout')
	Events.emit_signal('level_finished')
	_level_msg.text = ''
