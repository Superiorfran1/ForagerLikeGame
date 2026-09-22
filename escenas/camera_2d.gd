extends Camera2D

## Velocidad del seguimiento. Más bajo = más retraso.
## Recomendado: 3.0 (suave) → 10.0 (rápido)
@export var follow_speed: float = 5.0

## Desplazamiento opcional del punto de mira
@export var target_offset: Vector2 = Vector2.ZERO

var _target: Node2D
var _prev_pos: Vector2


func _ready() -> void:
	_target = get_parent()

	# Desacopla la cámara del movimiento directo del padre
	top_level = true

	# Empieza exactamente encima del personaje (sin salto inicial)
	global_position = _target.global_position + target_offset
	_prev_pos = global_position

	# Asegura que esta cámara es la activa
	make_current()


func _physics_process(delta: float) -> void:
	var desired: Vector2 = _target.global_position + target_offset
	global_position = global_position.lerp(desired, follow_speed * delta)
