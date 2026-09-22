extends Node2D

@export var area: Area2D
var vida: int = 300
var jugador_dentro: bool = false
var puede_golpear: bool = true
var jugador_ref = null

const DROP_SCENE   = preload("res://Objetos/item_pickup.tscn")
const DROP_TEXTURA = preload("res://sprites/fotonita.png")

func _ready() -> void:
	area.body_entered.connect(_al_entrar)
	area.body_exited.connect(_al_salir)

func _physics_process(_delta: float) -> void:
	_golpearPiedra()

func _golpearPiedra() -> void:
	if jugador_dentro && jugador_ref != null && Input.is_action_pressed("golpear") && puede_golpear:
		puede_golpear = false
		jugador_ref.usar_pico()
		vida -= 25
		if vida <= 0:
			_dropear_items()
			queue_free()
		else:
			await get_tree().create_timer(1.0).timeout
			puede_golpear = true

func _dropear_items() -> void:
	var cantidad = randi_range(2, 4)
	for i in range(cantidad):
		var drop = DROP_SCENE.instantiate()
		drop.global_position = global_position + Vector2(randf_range(-14, 14), randf_range(-14, 14))
		drop.item_nombre   = "fotorita"
		drop.item_cantidad = 1
		drop.item_textura  = DROP_TEXTURA
		get_parent().add_child(drop)

func _al_entrar(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_dentro = true
		jugador_ref = body

func _al_salir(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_dentro = false
		jugador_ref = null
