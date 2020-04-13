class_name Socket
extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(Texture) var socket_2
export(Texture) var socket_2t
export(Texture) var socket_3
export(Texture) var socket_3t

var dir: int = 0 setget set_dir, get_dir
var linked: bool = false
var touched_by: Area2D

var _type: int
var _row: int setget ,get_row
var _col: int setget ,get_col
var _touch: bool = false setget ,get_touch
var _animate: bool = false
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	_animate = true

	match _type:
		Cell.Type.SOCKET_2:
			$Sprite.texture = socket_2
		Cell.Type.SOCKET_2T:
			$Sprite.texture = socket_2t
			$Sprite.position.y -= 3
			_touch = true
		Cell.Type.SOCKET_3:
			$Sprite.texture = socket_3
		Cell.Type.SOCKET_3T:
			$Sprite.texture = socket_3t
			$Sprite.position.y -= 3
			_touch = true
	
	connect('mouse_entered', self, '_change_mouse', [ true ])
	connect('mouse_exited', self, '_change_mouse')
	connect('input_event', self, '_handle_input')


func set_initial(cfg: Dictionary) -> void:
	global_position = cfg.pos - (Vector2.ONE * 33)
	_type = cfg.typ
	_row = cfg.row
	_col = cfg.col
	name = 'Socket%d%d' % [ _row, _col ]
	self.dir = cfg.dir


func get_row() -> int:
	return _row


func get_col() -> int:
	return _col


func get_touch() -> bool:
	return _touch


func set_dir(new_val: int) -> void:
	dir = wrapi(dir + new_val, 0, 4)
	print('%s viendo hacia %d' % [name, dir])

	if not _animate:
		match dir:
			Cell.Direction.LEFT:
				rotation_degrees = -90
			Cell.Direction.DOWN:
				rotation_degrees = -180
			Cell.Direction.RIGHT:
				rotation_degrees = -270
	else:
		if new_val >= 0:
			_rotate(rotation_degrees - 90)
		else:
			_rotate(rotation_degrees + 90, true)


func get_dir() -> int:
	return dir


func link_done() -> void:
	linked = true
	disable()


func disable() -> void:
	$CollisionShape2D.disabled = true


func _change_mouse(turn: bool = false) -> void:
	# Cambiar el cursor por el de la mano apretando:
	if turn:
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _handle_input(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if not Constants.moving_piece and event.is_pressed():
			Constants.moving_piece = true
			self.dir = 1


func _rotate(target: int, backwards: bool = false) -> void:
	$Tween.interpolate_property(
		self,
		'rotation_degrees',
		rotation_degrees,
		target,
		Constants.rotation_time if not backwards else Constants.rotation_time / 2,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$Tween.start()
	
	if not backwards:
		Events.emit_signal('play_requested', 'Sfx', 'Rotate')

	yield($Tween, 'tween_completed')

	if not backwards:
		Events.emit_signal('socket_rotated', self)
	elif touched_by:
		touched_by.dir = -1
		touched_by = null
	else:
		Constants.moving_piece = false
