extends CharacterBody2D

@export var animacion: AnimatedSprite2D
@export var area: Area2D

# Exportamos los dos Labels por separado
@export var mensaje_1: Label
@export var mensaje_2: Label

# Variable para controlar si el jugador se mantiene en el área
var jugador_esta_cerca: bool = false

func _ready() -> void:
	# Conectamos las señales del Area2D
	area.body_entered.connect(_al_entrar)
	area.body_exited.connect(_al_salir)
	
	# Ambos mensajes empiezan completamente ocultos
	mensaje_1.visible = false
	mensaje_2.visible = false
	
	if animacion:
		animacion.play("herrero")

func _al_entrar(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_esta_cerca = true
		
		# 1. Mostramos el primer Label
		mensaje_1.visible = true
		mensaje_2.visible = false # Nos aseguramos de que el segundo esté oculto
		
		# 2. Esperamos los 5 segundos de manera asíncrona
		await get_tree().create_timer(5.0).timeout
		
		# 3. Si pasaron los 5 segundos y el jugador NO se ha ido:
		if jugador_esta_cerca:
			mensaje_1.visible = false # Ocultamos el primero
			mensaje_2.visible = true  # Mostramos el segundo

func _al_salir(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_esta_cerca = false
		
		# Si el jugador se va del área, ocultamos ambos inmediatamente
		mensaje_1.visible = false
		mensaje_2.visible = false
