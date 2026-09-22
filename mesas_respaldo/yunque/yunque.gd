extends Node2D

# ─────────────────────────────────────────────
#  Yunque de Crafteo
# ─────────────────────────────────────────────

@onready var area: Area2D          = $Sprite2D/Area2D
@onready var label_progreso: Label = $LabelProgreso

# ── Receta única ───────────────────────────────────────────────────────────────
const RECETA: Dictionary = {
	"resultado":         "brujula",
	"textura_resultado": "res://sprites/brujula.png",
	"ingredientes": {
		"hueso":       2,
		"engranaje": 1
	}
}

# ── Estado ─────────────────────────────────────────────────────────────────────
var materiales_entregados: Dictionary = {}
var jugador_dentro: bool = false
var jugador_ref          = null
var ya_crafteado: bool   = false

const DROP_SCENE = preload("res://Objetos/item_pickup.tscn")

# ── _ready ─────────────────────────────────────────────────────────────────────
func _ready() -> void:
	add_to_group("yunque")
	area.body_entered.connect(_al_entrar)
	area.body_exited.connect(_al_salir)
	label_progreso.visible = false
	_reiniciar_progreso()
	print("[Yunque] Listo. Receta: ", RECETA["resultado"])

# ── Entrada / salida del jugador ───────────────────────────────────────────────
func _al_entrar(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return
	jugador_dentro = true
	jugador_ref    = body
	jugador_ref.mesa_cercana = self
	print("[Yunque] Jugador entró. ya_crafteado=", ya_crafteado)
	_mostrar_ui()

func _al_salir(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return
	jugador_dentro = false
	if jugador_ref != null:
		jugador_ref.mesa_cercana = null
	jugador_ref            = null
	label_progreso.visible = false
	print("[Yunque] Jugador salió.")

# ── intentar_craftear ─────────────────────────────────────────────────────────
func intentar_craftear() -> void:
	print("[Yunque] intentar_craftear() llamado.")

	if ya_crafteado:
		print("[Yunque] Ya crafteado, bloqueado.")
		return

	if jugador_ref == null:
		print("[Yunque] Error: jugador_ref es null.")
		return

	if jugador_ref.item_en_mano.is_empty():
		print("[Yunque] El jugador no tiene item en mano.")
		_flash_label("Coge un ingrediente primero")
		return

	var nombre: String = jugador_ref.item_en_mano["nombre"]
	print("[Yunque] Jugador intenta dar: ", nombre)

	if not RECETA["ingredientes"].has(nombre):
		_flash_label("¡" + nombre + " no se necesita!")
		print("[Yunque] ", nombre, " no es ingrediente.")
		return

	var necesario: int = RECETA["ingredientes"][nombre]
	var ya_dado: int   = materiales_entregados.get(nombre, 0)

	if ya_dado >= necesario:
		_flash_label("Ya tienes " + nombre + " suficiente")
		print("[Yunque] Ya se completó ese ingrediente.")
		return

	var nueva_cantidad: int = min(ya_dado + jugador_ref.item_en_mano["cantidad"], necesario)
	materiales_entregados[nombre] = nueva_cantidad
	print("[Yunque] Absorbido: ", nombre, " → ", nueva_cantidad, "/", necesario)

	jugador_ref.limpiar_mano()
	_mostrar_ui()

	if _receta_completa():
		print("[Yunque] ¡Receta completa! Crafteando...")
		_craftear()

# ── Comprobar receta completa ──────────────────────────────────────────────────
func _receta_completa() -> bool:
	for ingrediente in RECETA["ingredientes"]:
		if materiales_entregados.get(ingrediente, 0) < RECETA["ingredientes"][ingrediente]:
			return false
	return true

# ── Craftear ──────────────────────────────────────────────────────────────────
func _craftear() -> void:
	ya_crafteado = true

	var drop = DROP_SCENE.instantiate()
	drop.global_position = global_position + Vector2(0, -24)
	drop.item_nombre     = RECETA["resultado"]
	drop.item_cantidad   = 1
	drop.item_textura    = load(RECETA["textura_resultado"])
	get_parent().add_child(drop)
	print("[Yunque] Drop creado: ", RECETA["resultado"])

	label_progreso.text    = "✓ ¡" + RECETA["resultado"] + " crafteado!"
	label_progreso.visible = true

	await get_tree().create_timer(2.0).timeout

	if jugador_dentro:
		label_progreso.text = "Ya fue crafteado."
	else:
		label_progreso.visible = false

# ── UI ─────────────────────────────────────────────────────────────────────────
func _mostrar_ui() -> void:
	if ya_crafteado:
		label_progreso.text    = "Ya fue crafteado."
		label_progreso.visible = true
		return

	var lineas: Array = ["Receta: " + RECETA["resultado"]]
	for ingrediente in RECETA["ingredientes"]:
		var necesario: int = RECETA["ingredientes"][ingrediente]
		var dado: int      = materiales_entregados.get(ingrediente, 0)
		var check: String  = " ✓" if dado >= necesario else " (" + str(dado) + "/" + str(necesario) + ")"
		lineas.append(ingrediente + check)

	label_progreso.text    = "\n".join(lineas)
	label_progreso.visible = true

func _flash_label(msg: String) -> void:
	var previo: String = label_progreso.text
	label_progreso.text    = msg
	label_progreso.visible = true
	await get_tree().create_timer(1.5).timeout
	if not ya_crafteado and jugador_dentro:
		label_progreso.text = previo

func _reiniciar_progreso() -> void:
	materiales_entregados = {}
	for ingrediente in RECETA["ingredientes"]:
		materiales_entregados[ingrediente] = 0
