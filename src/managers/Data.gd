extends Node
# Clase que copia la idea y parte de la funcionalidad del DataManager de Phaser
# para tener un lugar centralizado en el que cualquier nodo pueda acceder y
# guardar datos de uso transversal en el juego
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var _list: Dictionary = {}
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func data_get(key: String):
	return _list[key] if _list.has(key) else null


func data_set(key: String, data) -> void:
	_list[key] = data


# Suma un valor entero al dato identificado con 'key' en la lista de datos.
func data_sumi(key: String, value: int) -> void:
	if _list.has(key) and _list[key] is int:
		_list[key] += value
	else:
		_error_no_key_no_type(key, 'int')


# Suma un valor flotante al dato identificado con 'key' en la lista de datos.
func data_sumf(key: String, value: float) -> void:
	if _list.has(key) and _list[key] is int:
		_list[key] += value
	else:
		_error_no_key_no_type(key, 'float')


func _error_no_key_no_type(key: String, type: String) -> void:
	print('ERROR: %s no existe o no es %s' % [key, type])
