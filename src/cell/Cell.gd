tool
class_name Cell
extends TextureRect
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
enum Type {
	EMPTY,
	SOCKET_2,
	SOCKET_3,
	SOCKET_2T,
	SOCKET_3T,
	PLUG_2,
	PLUG_3
}
enum Direction {
	UP,
	LEFT,
	DOWN,
	RIGHT
}

export(Type) var cell_type = Type.EMPTY setget set_cell_type
export(Direction) var direction setget set_direction
export(int) var link_row = -1 setget set_link_row
export(int) var link_col = -1 setget set_link_col
export(bool) var is_out = true
export(bool) var refresh setget set_refresh
export(bool) var turned = false

var s2: Resource = load('res://assets/sprites/editor/cell_s2.png')
var s2t: Resource = load('res://assets/sprites/editor/cell_s2t.png')
var s3: Resource = load('res://assets/sprites/editor/cell_s3.png')
var s3t: Resource = load('res://assets/sprites/editor/cell_s3t.png')
var p2: Resource = load('res://assets/sprites/editor/cell_p2.png')
var p3: Resource = load('res://assets/sprites/editor/cell_p3.png')

var _center: Vector2 = Vector2.ONE * (rect_size / 2)
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	$Line2D.set_point_position(0, _center)
	$Line2D.set_point_position(1, _center)
	
	_update_id()


func get_world_position() -> Vector2:
	return rect_global_position + rect_size


func set_cell_type(new_type: int) -> void:
	cell_type = new_type
	
	match cell_type:
		Type.SOCKET_2:
			$TypePreview.texture = s2
		Type.SOCKET_2T:
			$TypePreview.texture = s2t
		Type.SOCKET_3:
			$TypePreview.texture = s3
		Type.SOCKET_3T:
			$TypePreview.texture = s3t
		Type.PLUG_2:
			$TypePreview.texture = p2
		Type.PLUG_3:
			$TypePreview.texture = p3
		_:
			$TypePreview.texture = null
			self.link_row = -1
			self.link_col = -1
	
	_update_id()


func set_direction(val: int) -> void:
	direction = val
	
	_update_line()


func set_link_row(val: int) -> void:
	link_row = val

	_update_line()


func set_link_col(val: int) -> void:
	link_col = val

	_update_line()


func set_refresh(val: bool) -> void:
	refresh = val

	_update_line()


func _update_line() -> void:
	if not get_parent() or not get_parent().name: return

	var target: Vector2 = _center
	
	if cell_type == Type.SOCKET_2 \
		or cell_type == Type.SOCKET_2T \
		or cell_type == Type.SOCKET_3 \
		or cell_type == Type.SOCKET_3T:
			match direction:
				Direction.UP:
					target.y -= rect_size.x / 2
				Direction.DOWN:
					target.y += rect_size.x / 2
				Direction.LEFT:
					target.x -= rect_size.x / 2
				Direction.RIGHT:
					target.x += rect_size.x / 2
	
			$Line2D.set_point_position(1, target)
			$Line2D.default_color = Color.aqua
			return

	$Line2D.default_color = Color.crimson

	if link_row >= 0:
		if direction == Direction.UP:
			target.y -= rect_size.x * (int(get_parent().name) - link_row)
		elif direction == Direction.DOWN:
			target.y += rect_size.x * (link_row - int(get_parent().name))
		$Line2D.set_point_position(1, target)

	if link_col >= 0:
		if direction == Direction.LEFT:
			target.x -= rect_size.x * (int(name) - link_col)
		elif direction == Direction.RIGHT:
			target.x += rect_size.x * (link_col - int(name))
		$Line2D.set_point_position(1, target)
	else:
		$Line2D.set_point_position(1, _center)


func _update_id() -> void:
	if not get_parent() or not get_parent().name: return
	
	$Id.text = 'r%d,c%d' % [ int(get_parent().name), int(name) ]
