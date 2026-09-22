extends CharacterBody2D

@export var animacion: AnimatedSprite2D
@export var area: Area2D
@export var mensaje: Label

func _ready() -> void:
	# Conectamos las señales correctamente
	area.body_entered.connect(_al_entrar)
	area.body_exited.connect(_al_salir)
	
	# El mensaje empieza oculto
	mensaje.visible = false
	
	# La animación se reproduce en bucle desde el principio (evitamos saturar el _physics_process)
	if animacion:
		animacion.play("minero")

func _al_entrar(body: Node2D) -> void:
	# Asegúrate de que el nodo del jugador tenga el grupo "jugador" asignado en el editor
	if body.is_in_group("jugador"):
		mensaje.visible = true

func _al_salir(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		mensaje.visible = false
