extends CharacterBody2D

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var hacha: Sprite2D = $herramienta/hacha
@onready var pico: Sprite2D = $herramienta/pico
@onready var hacha_anim: AnimationPlayer = $herramienta/hacha/AnimationPlayer
@onready var pico_anim: AnimationPlayer = $herramienta/pico/AnimationPlayer

var _velocidad: int = 200

# --- Sistema de carga de items ---
var item_en_mano: Dictionary = {}   # {nombre, cantidad, textura}
var item_cercano = null             # Referencia al ItemPickup más cercano
var sprite_item: Sprite2D           # Sprite que aparece sobre la cabeza
var mesa_cercana = null
const DROP_SCENE = preload("res://Objetos/item_pickup.tscn")

func _ready() -> void:
	add_to_group("jugador")
	hacha.modulate.a = 0
	pico.modulate.a = 0

	# Crear el sprite que flota sobre la cabeza del jugador
	sprite_item = Sprite2D.new()
	sprite_item.position = Vector2(0, -26)
	sprite_item.scale = Vector2(0.7, 0.7)
	sprite_item.visible = false
	add_child(sprite_item)

func _physics_process(_delta: float) -> void:
	var direccion: Vector2 = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	velocity = direccion * _velocidad

	if direccion.x < 0:
		animacion.flip_h = true
	elif direccion.x > 0:
		animacion.flip_h = false

	if velocity != Vector2.ZERO:
		animacion.play("walk")
	else:
		animacion.play("idle")
	move_and_slide()
	# Gestión de la E
	if Input.is_action_just_pressed("toggleInventory"):
		if mesa_cercana != null and is_instance_valid(mesa_cercana) and mesa_cercana.jugador_dentro and not mesa_cercana.ya_crafteado:
			mesa_cercana.intentar_craftear()
		elif not item_en_mano.is_empty():
			_soltar_item()
		elif item_cercano != null:
			_recoger_item()

func _input(event: InputEvent) -> void:
	# --- Usar brújula con clic izquierdo ---
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if item_en_mano.get("nombre", "") == "brujula":
				get_tree().quit()

func _recoger_item() -> void:
	item_en_mano = {
		"nombre":   item_cercano.item_nombre,
		"cantidad": item_cercano.item_cantidad,
		"textura":  item_cercano.item_textura
	}
	sprite_item.texture = item_en_mano["textura"]
	sprite_item.visible = true
	item_cercano.queue_free()
	item_cercano = null

func _soltar_item() -> void:
	var drop = DROP_SCENE.instantiate()
	drop.global_position = global_position + Vector2(0, -8)
	drop.item_nombre    = item_en_mano["nombre"]
	drop.item_cantidad  = item_en_mano["cantidad"]
	drop.item_textura   = item_en_mano["textura"]
	get_parent().add_child(drop)

	item_en_mano = {}
	sprite_item.texture = null
	sprite_item.visible = false

func limpiar_mano() -> void:
	item_en_mano = {}
	sprite_item.texture = null
	sprite_item.visible = false

func usar_hacha() -> void:
	hacha.modulate.a = 1
	hacha_anim.stop()
	var anim = "usoIzq" if animacion.flip_h else "usoDer"
	hacha_anim.play(anim)
	await hacha_anim.animation_finished
	hacha.modulate.a = 0

func usar_pico() -> void:
	pico.modulate.a = 1
	pico_anim.stop()
	var anim = "usoIzq" if animacion.flip_h else "usoDer"
	pico_anim.play(anim)
	await pico_anim.animation_finished
	pico.modulate.a = 0
