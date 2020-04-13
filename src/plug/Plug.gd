class_name Plug
extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(Texture) var plug_2
export(Texture) var plug_3

var link: Vector2

var _init_pos: Vector2
var _type: int
var _out: bool
var _dir: int
var _first_move: bool = true
var _row: int
var _col: int
var _level: Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	name = 'Plug%d%d' % [ _row, _col ]
	global_position = _init_pos - (Vector2.ONE * 33)

	match _type:
		Cell.Type.PLUG_2:
			$Sprite.texture = plug_2
		Cell.Type.PLUG_3:
			$Sprite.texture = plug_3

	if _out:
		match _dir:
			Cell.Direction.UP:
				position.y += 54
			Cell.Direction.LEFT:
				position.x += 54
			Cell.Direction.RIGHT:
				position.x -= 54
			Cell.Direction.DOWN:
				position.y -= 54

	$Tween.connect('tween_started', self, '_play_move')
	$Tween.connect('tween_completed', self, '_moved')

func set_initial(cfg: Dictionary) -> void:
	_init_pos = cfg.pos
	_type = cfg.typ
	_out = cfg.out
	_dir = cfg.dir
	_row = cfg.row
	_col = cfg.col
	_level = cfg.level
	link = cfg.link
	
	match _dir:
		Cell.Direction.LEFT:
			rotation_degrees = -90
		Cell.Direction.DOWN:
			rotation_degrees = -180
		Cell.Direction.RIGHT:
			rotation_degrees = -270


func move() -> void:
	# Mover el enchufe si la tomacorriente que se giró es su vínculo
	var offset: Vector2 = Vector2(33, 39)
	var distance: int = 1
	
	if _out and _first_move:
		_first_move = false
		distance = 0

	match _dir:
		Cell.Direction.UP:
			_row = max(0, _row - distance)
		Cell.Direction.LEFT:
			_col = max(0, _col - distance)
			offset = Vector2(39, 33)
		Cell.Direction.RIGHT:
			_col += distance # Mejorar para que sepa límite del nivel
			offset = Vector2(26, 33)
		Cell.Direction.DOWN:
			_row += distance # Mejorar para que sepa límite del nivel

	var target: Vector2 = _level.get_cell_pos(_row, _col) as Vector2

	$Tween.interpolate_property(
		self,
		'position',
		position,
		target - offset,
		0.3,
		Tween.TRANS_QUINT,
		Tween.EASE_IN,
		Constants.rotation_time
	)
	$Tween.start()


func _play_move(obj: Node2D, key: NodePath) -> void:
	Events.emit_signal('play_requested', 'Sfx', 'Move')


func _moved(obj: Node2D, key: NodePath) -> void:
	Events.emit_signal('plug_moved', _row, _col)

	# Ver si el tomacorriente vínculo ya está al lado
	var r:int = 0
	var c:int = 0

	match _dir:
			Cell.Direction.UP:
				r = -1
			Cell.Direction.LEFT:
				c = -1
			Cell.Direction.RIGHT:
				c = 1
			Cell.Direction.DOWN:
				r = 1

	if Vector2(_col + c, _row + r) == link:
		Events.emit_signal('play_requested', 'Sfx', 'Moan')
		Events.emit_signal('plug_excited', link)
