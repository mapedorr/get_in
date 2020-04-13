class_name Level
extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(PackedScene) var next_level

var _socket: PackedScene = load('res://src/socket/Socket.tscn')
var _plug: PackedScene = load('res://src/plug/Plug.tscn')
var _plugs_excited: int = 0
var _plugs_to_move: Array = []
var _rotated_sockets: int = 0
var _last_move: bool = false
var _level_won: bool = false

onready var _grid: VBoxContainer = $GridContainer/CenterContainer/Grid
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	$GridContainer.hide()
	
	# Recorrer la cuadrícula para saber dónde ponar las vueltas
	var row: HBoxContainer;
	for row in _grid.get_children():
		var row_i: int = int(row.name)
		for cell in row.get_children():
			var c: Cell = cell as Cell
			var col_i: int = int(c.name)
			
			(c.get_node('TypePreview') as TextureRect).texture = null

			match c.cell_type:
				c.Type.SOCKET_2, \
				c.Type.SOCKET_2T, \
				c.Type.SOCKET_3, \
				c.Type.SOCKET_3T:
					var s: Socket = _socket.instance() as Socket
					s.set_initial({
						pos = c.rect_global_position + c.rect_size,
						typ = c.cell_type,
						row = row_i,
						col = col_i,
						dir = c.direction,
					})
					$Sockets.add_child(s)
				c.Type.PLUG_2, c.Type.PLUG_3:
					var p: Plug = _plug.instance() as Plug
					p.set_initial({
						pos = c.rect_global_position + c.rect_size,
						typ = c.cell_type,
						out = c.is_out,
						link = Vector2(c.link_col, c.link_row),
						dir = c.direction,
						row = row_i,
						col = col_i,
						level = self
					})
					$Plugs.add_child(p)

	Events.connect('socket_rotated', self, '_move_plug')
	Events.connect('plug_moved', self, '_plug_moved')
	Events.connect('plug_excited', self, '_plug_excited')


func get_cell(row: int, col: int) -> Cell:
	return _grid.get_node('Row%d/Cell%d' % [row, col]) as Cell


func get_cell_pos(row: int, col: int) -> Vector2:
	var cell: Cell = get_cell(row, col)
	return cell.get_world_position()


func _move_plug(socket: Socket) -> void:
	_rotated_sockets += 1

	var row: int = socket.get_row()
	var col: int = socket.get_col()
	
	var plug: Plug
	for plug in $Plugs.get_children():
		if plug.link == Vector2(col, row):
			_plugs_to_move.append(plug)
#			plug.move()
	
	if socket.get_touch():
		# Si el tomacorriente toquetea, entonces hay que girar los tomacorrientes
		# afectados
		match socket.get_dir():
			Cell.Direction.UP:
				row -= 1
			Cell.Direction.LEFT:
				col -= 1
			Cell.Direction.DOWN:
				row += 1
			Cell.Direction.RIGHT:
				col += 1
		
		var socket_name: String = 'Socket%d%d' % [ row, col ]
		if $Sockets.has_node(socket_name):
			var touched_socket: Socket = $Sockets.get_node(socket_name)
			if not touched_socket.linked:
				touched_socket.touched_by = socket
				touched_socket.dir = 1
			else:
				socket.dir = -1
				_rotated_sockets = 0
				_plugs_to_move.clear()
				Events.emit_signal('play_requested', 'Sfx', 'Error')
			return

	if _plugs_to_move.size() == _rotated_sockets:
		for plug in _plugs_to_move:
			plug.move()
	_rotated_sockets = 0


func _plug_moved(row: int, col: int) -> void:
	_plugs_to_move.pop_front()
	
	if _last_move:
		_disable_sockets()
		yield(get_tree().create_timer(0.6), 'timeout')

		if not _level_won:
			Events.emit_signal('level_lost')
			return
	
	if _plugs_to_move.size() == 0:
		Constants.moving_piece = false


func _plug_excited(link: Vector2) -> void:
	_plugs_excited += 1

	($Sockets.get_node('Socket%d%d' % [ link.y, link.x ]) as Socket).link_done()
	if _plugs_excited == $Plugs.get_child_count():
		_level_won = true

		_disable_sockets()
		yield(get_tree().create_timer(0.5), 'timeout')
		Events.emit_signal('level_won')
	else:
		_last_move = true
		Events.emit_signal('last_move_alerted')


func _disable_sockets() -> void:
	for socket in $Sockets.get_children():
		(socket as Socket).disable()
