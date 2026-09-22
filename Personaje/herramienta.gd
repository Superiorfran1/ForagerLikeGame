extends Node2D

@onready var hacha: Sprite2D = $hacha
@onready var pico: Sprite2D = $pico
@onready var hacha_anim: AnimationPlayer = $hacha/AnimationPlayer
@onready var pico_anim: AnimationPlayer = $pico/AnimationPlayer
@onready var animacion_personaje: AnimatedSprite2D = $"../AnimatedSprite2D"

func _ready() -> void:
	# Opacidad 0 al inicio
	hacha.modulate.a = 0
	pico.modulate.a = 0
	
	# Conectamos la señal de fin de animación para ocultar la herramienta al terminar
	hacha_anim.animation_finished.connect(_ocultar_hacha)
	pico_anim.animation_finished.connect(_ocultar_pico)

func usar_hacha() -> void:
	_sincronizar_flip(hacha)
	hacha.modulate.a = 1
	hacha_anim.stop()
	hacha_anim.play("uso")  # nombre de tu animación

func usar_pico() -> void:
	_sincronizar_flip(pico)
	pico.modulate.a = 1
	pico_anim.stop()
	pico_anim.play("uso")  # nombre de tu animación

func _sincronizar_flip(herramienta: Sprite2D) -> void:
	herramienta.flip_h = animacion_personaje.flip_h

func _ocultar_hacha(_anim_name: StringName) -> void:
	hacha.modulate.a = 0

func _ocultar_pico(_anim_name: StringName) -> void:
	pico.modulate.a = 0
