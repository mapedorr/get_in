extends CanvasLayer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
onready var arrow = load('res://assets/sprites/gui/cursor-arrow.png')
onready var pointer = load('res://assets/sprites/gui/cursor-pointing_hand.png')
onready var turn = load('res://assets/sprites/gui/cursor-turn.png')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Enchular cursor
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(pointer, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(turn, Input.CURSOR_MOVE)
	
	# Conectarse a eventos
	Events.connect('level_won', self, 'show_win')
	Events.connect('level_lost', self, 'show_lose')
	Events.connect('last_move_alerted', self, 'show_alert')


func show_win() -> void:
	$Control/Label.text = 'all connected'
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Events.emit_signal('play_requested', 'Sfx', 'Win')
	yield(get_tree().create_timer(1), 'timeout')
	$Control/Label.text += ',\nall happy'
	Events.emit_signal('play_requested', 'Sfx', 'Win')
	_finish_level()


func show_lose() -> void:
	$Control/Label.text = 'no more moves!'


func show_alert() -> void:
	$Control/Label.text = 'one pose left'


func game_finished() -> void:
	pass


func _finish_level() -> void:
	yield(get_tree().create_timer(1.5), 'timeout')
	Events.emit_signal('level_finished')
	$Control/Label.text = ''
