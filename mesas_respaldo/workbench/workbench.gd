extends Node2D

# ─────────────────────────────────────────────
#  Mesa de Crafteo — versión corregida
#  Cambios respecto a la versión anterior:
#  1. Una sola receta, no se puede repetir
#  2. El jugador cede el control de E a la mesa
#  3. Se eliminó el _physics_process de la mesa
#  4. El await ya no puede causar bugs de estado
# ─────────────────────────────────────────────

@onready var area: Area2D       = $Sprite2D/Area2D
#@onready var label_receta: Label   = $LabelReceta
@onready var label_progreso: Label = $LabelProgreso

# ── Receta única ───────────────────────────────────────────────────────────────
# Solo una receta. Cuando se craftee, la mesa queda bloqueada para siempre.
const RECETA: Dictionary = {
	"resultado":         "engranaje",
	"textura_resultado": "res://sprites/engranaje.png",
	"ingredientes": {
		"piedra":       2,
		"lingote_hierro": 1
	}
}

# ── Estado ─────────────────────────────────────────────────────────────────────
var materiales_entregados: Dictionary = {}
var jugador_dentro: bool  = false
var jugador_ref           = null
var ya_crafteado: bool    = false  # ← bloqueo permanente tras craftear

const DROP_SCENE = preload("res://Objetos/item_pickup.tscn")

# ── _ready ─────────────────────────────────────────────────────────────────────
func _ready() -> void:
	add_to_group("mesa_crafteo")
	area.body_entered.connect(_al_entrar)
	area.body_exited.connect(_al_salir)
	#label_receta.visible   = false
	label_progreso.visible = false
	_reiniciar_progreso()

	# Debug: confirmamos que la mesa arrancó bien
	print("[Mesa] Lista. Receta: ", RECETA["resultado"])

# ── Entrada / salida del jugador ───────────────────────────────────────────────
func _al_entrar(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return

	jugador_dentro = true
	jugador_ref    = body

	# ← Le decimos al jugador que hay una mesa activa
	jugador_ref.mesa_cercana = self

	print("[Mesa] Jugador entró. ya_crafteado=", ya_crafteado)

	if ya_crafteado:
		label_progreso.text    = "Ya fue crafteado."
		label_progreso.visible = true
	else:
		_mostrar_ui()

func _al_salir(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return

	jugador_dentro = false

	# ← Limpiamos la referencia en el jugador
	if jugador_ref != null:
		jugador_ref.mesa_cercana = null

	jugador_ref            = null
	#label_receta.visible   = false
	label_progreso.visible = false

	print("[Mesa] Jugador salió.")

# ── intentar_craftear: llamado por el jugador al pulsar E ─────────────────────
# Esta función es pública (sin guion bajo) para que el jugador la llame.
func intentar_craftear() -> void:
	print("[Mesa] intentar_craftear() llamado.")

	# Bloqueo: si ya se crafteó, no hacemos nada
	if ya_crafteado:
		print("[Mesa] Ya crafteado, bloqueada.")
		return

	# Seguridad: si no hay jugador, salimos
	if jugador_ref == null:
		print("[Mesa] Error: jugador_ref es null.")
		return

	# Si el jugador no tiene nada en la mano, avisamos
	if jugador_ref.item_en_mano.is_empty():
		print("[Mesa] El jugador no tiene item en mano.")
		#_flash_label(label_receta, "Coge un ingrediente primero")
		return

	var nombre: String = jugador_ref.item_en_mano["nombre"]
	print("[Mesa] Jugador intenta dar: ", nombre)

	# ¿Es un ingrediente de la receta?
	if not RECETA["ingredientes"].has(nombre):
		#_flash_label(label_receta, "¡" + nombre + " no se necesita!")
		print("[Mesa] ", nombre, " no es ingrediente.")
		return

	var necesario: int = RECETA["ingredientes"][nombre]
	var ya_dado: int   = materiales_entregados.get(nombre, 0)

	# ¿Ya tenemos suficiente de ese ingrediente?
	if ya_dado >= necesario:
		#_flash_label(label_receta, "Ya tienes " + nombre + " suficiente")
		print("[Mesa] Ya se completó ese ingrediente.")
		return

	# ── Absorber el item ───────────────────────────────────────────────────────
	# Tomamos lo necesario (puede que el jugador lleve más de lo necesario)
	var nueva_cantidad: int = min(ya_dado + jugador_ref.item_en_mano["cantidad"], necesario)
	materiales_entregados[nombre] = nueva_cantidad

	print("[Mesa] Absorbido: ", nombre, " → ", nueva_cantidad, "/", necesario)

	# Limpiamos la mano del jugador usando la función pública
	jugador_ref.limpiar_mano()

	# Actualizamos la UI
	_mostrar_ui()

	# ¿Receta completa?
	if _receta_completa():
		print("[Mesa] ¡Receta completa! Crafteando...")
		_craftear()

# ── Comprobar receta completa ──────────────────────────────────────────────────
func _receta_completa() -> bool:
	for ingrediente in RECETA["ingredientes"]:
		var necesario: int = RECETA["ingredientes"][ingrediente]
		var dado: int      = materiales_entregados.get(ingrediente, 0)
		if dado < necesario:
			return false
	return true

# ── Craftear ──────────────────────────────────────────────────────────────────
func _craftear() -> void:
	# Bloqueamos la mesa ANTES del await para evitar dobles ejecuciones
	ya_crafteado = true

	# Spawneamos el resultado
	var drop = DROP_SCENE.instantiate()
	drop.global_position = global_position + Vector2(0, -24)
	drop.item_nombre     = RECETA["resultado"]
	drop.item_cantidad   = 1
	drop.item_textura    = load(RECETA["textura_resultado"])
	get_parent().add_child(drop)

	print("[Mesa] Drop creado: ", RECETA["resultado"])

	# Mostramos mensaje de éxito
	label_progreso.text    = "✓ ¡" + RECETA["resultado"] + " crafteado!"
	label_progreso.visible = true
	#label_receta.visible   = false

	# Esperamos y luego mostramos mensaje permanente de bloqueada
	await get_tree().create_timer(2.0).timeout

	label_progreso.visible = false
	if jugador_dentro:
		label_progreso.text    = "Ya fue crafteado."
		label_progreso.visible = true

# ── UI ─────────────────────────────────────────────────────────────────────────
func _mostrar_ui() -> void:
	var lineas_receta: Array   = ["Receta: " + RECETA["resultado"]]
	var lineas_progreso: Array = []

	for ingrediente in RECETA["ingredientes"]:
		var necesario: int = RECETA["ingredientes"][ingrediente]
		var dado: int      = materiales_entregados.get(ingrediente, 0)
		lineas_receta.append("  " + ingrediente + " x" + str(necesario))
		var check: String = " ✓" if dado >= necesario else " (" + str(dado) + "/" + str(necesario) + ")"
		lineas_progreso.append(ingrediente + check)

	#label_receta.text      = "\n".join(lineas_receta)
	#label_receta.visible   = true
	label_progreso.text    = "\n".join(lineas_progreso)
	label_progreso.visible = true

func _flash_label(lbl: Label, msg: String) -> void:
	var previo: String = lbl.text
	lbl.text    = msg
	lbl.visible = true
	await get_tree().create_timer(1.5).timeout
	# Solo restauramos si la mesa sigue activa y no se crafteó mientras esperábamos
	if not ya_crafteado and jugador_dentro:
		lbl.text = previo

func _reiniciar_progreso() -> void:
	materiales_entregados = {}
	for ingrediente in RECETA["ingredientes"]:
		materiales_entregados[ingrediente] = 0
 
