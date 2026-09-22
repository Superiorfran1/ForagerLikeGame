extends Node2D
 
# ─────────────────────────────────────────────
#  Mesa de Crafteo
#  Flujo:
#  1. Jugador se acerca → se muestra la receta requerida
#  2. Jugador pulsa E con un item en la mano → la mesa lo absorbe si es un ingrediente
#  3. Al completar todos los ingredientes → dropea el item crafteado
# ─────────────────────────────────────────────
 
@onready var area: Area2D = $Sprite2D/Area2D
@onready var label_receta: Label  = $LabelReceta
@onready var label_progreso: Label = $LabelProgreso
 
# ── Recetas disponibles ────────────────────────────────────────────────────────
# Añade aquí tantas recetas como quieras.
const RECETAS: Array = [
	{
		"resultado": "engranaje",
		"textura_resultado": "res://sprites/engranaje.png",
		"ingredientes": {
			"pieda_negra": 5,
			"lingote_hierro": 2
		}
	}
	# Para añadir otro que no se olvide la coma , que se pone tonto
]
 
# ── Estado ─────────────────────────────────────────────────────────────────────
var receta_activa: int = 0
var materiales_entregados: Dictionary = {}
var jugador_dentro: bool = false
var jugador_ref = null
 
const DROP_SCENE = preload("res://Objetos/item_pickup.tscn")
 
# ── _ready ─────────────────────────────────────────────────────────────────────
func _ready() -> void:
	add_to_group("mesa_crafteo")
	area.body_entered.connect(_al_entrar)
	area.body_exited.connect(_al_salir)
	label_receta.visible   = false
	label_progreso.visible = false
	_reiniciar_progreso()
 
# ── Entrada / salida del jugador ───────────────────────────────────────────────
func _al_entrar(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_dentro = true
		jugador_ref    = body
		_mostrar_ui()
 
func _al_salir(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_dentro        = false
		jugador_ref           = null
		label_receta.visible  = false
		label_progreso.visible = false
 
# ── Process: el jugador suelta item con E ─────────────────────────────────────
func _physics_process(_delta: float) -> void:
	if not jugador_dentro or jugador_ref == null:
		return
	if Input.is_action_just_pressed("toggleInventory"):
		_intentar_absorber_item()
 
# ── Absorber item ──────────────────────────────────────────────────────────────
func _intentar_absorber_item() -> void:
	if jugador_ref.item_en_mano.is_empty():
		return
 
	var nombre: String    = jugador_ref.item_en_mano["nombre"]
	var receta: Dictionary = RECETAS[receta_activa]
 
	if not receta["ingredientes"].has(nombre):
		_flash_label(label_receta, "¡" + nombre + " no se necesita!")
		return
 
	var necesario: int = receta["ingredientes"][nombre]
	var ya_dado: int   = materiales_entregados.get(nombre, 0)
 
	if ya_dado >= necesario:
		_flash_label(label_receta, "Ya tienes " + nombre + " suficiente")
		return
 
	# Absorber — añadimos la cantidad del item
	var nueva_cantidad: int = min(ya_dado + jugador_ref.item_en_mano["cantidad"], necesario)
	materiales_entregados[nombre] = nueva_cantidad
 
	# Vaciar mano del jugador
	jugador_ref.item_en_mano       = {}
	if "sprite_item" in jugador_ref and jugador_ref.sprite_item != null:
		jugador_ref.sprite_item.texture = null
		jugador_ref.sprite_item.visible = false
 
	_mostrar_ui()
 
	# ¡Comprobación directa sin await intermedio!
	if _receta_completa():
		_craftear()
 
# ── Comprobar receta completa ──────────────────────────────────────────────────
func _receta_completa() -> bool:
	var receta: Dictionary = RECETAS[receta_activa]
	for ingrediente in receta["ingredientes"]:
		if materiales_entregados.get(ingrediente, 0) < receta["ingredientes"][ingrediente]:
			return false
	return true
 
# ── Craftear y dropear resultado ──────────────────────────────────────────────
func _craftear() -> void:
	var receta: Dictionary = RECETAS[receta_activa]
	var drop = DROP_SCENE.instantiate()
	drop.global_position  = global_position + Vector2(0, -24)
	drop.item_nombre      = receta["resultado"]
	drop.item_cantidad    = 1
	drop.item_textura     = load(receta["textura_resultado"])
	get_parent().add_child(drop)
 
	_reiniciar_progreso()
	label_progreso.text    = "✓ ¡" + receta["resultado"] + " listo!"
	label_progreso.visible = false
	label_receta.visible   = false
	await get_tree().create_timer(2.0).timeout
	if jugador_dentro:
		_mostrar_ui()
 
# ── Helpers UI ─────────────────────────────────────────────────────────────────
func _mostrar_ui() -> void:
	var receta: Dictionary = RECETAS[receta_activa]
	var lineas_receta: Array  = ["Receta: " + receta["resultado"]]
	var lineas_progreso: Array = []
 
	for ingrediente in receta["ingredientes"]:
		var necesario: int = receta["ingredientes"][ingrediente]
		var dado: int      = materiales_entregados.get(ingrediente, 0)
		lineas_receta.append("  " + ingrediente + " x" + str(necesario))
		var check: String = " ✓" if dado >= necesario else " (" + str(dado) + "/" + str(necesario) + ")"
		lineas_progreso.append(ingrediente + check)
 
	label_receta.text      = "\n".join(lineas_receta)
	label_receta.visible   = true
	label_progreso.text    = "\n".join(lineas_progreso)
	label_progreso.visible = false
 
func _flash_label(lbl: Label, msg: String) -> void:
	var previo: String = lbl.text
	lbl.text    = msg
	lbl.visible = true
	await get_tree().create_timer(1.5).timeout
	lbl.text = previo
 
func _reiniciar_progreso() -> void:
	materiales_entregados = {}
	for ingrediente in RECETAS[receta_activa]["ingredientes"]:
		materiales_entregados[ingrediente] = 0
