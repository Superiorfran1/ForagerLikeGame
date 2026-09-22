extends Area2D

@export var item_nombre: String = "item"
@export var item_cantidad: int = 1
@export var item_textura: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var label_prompt: Label = $LabelPrompt

func _ready() -> void:
	if item_textura:
		sprite.texture = item_textura
	label_prompt.visible = false
	body_entered.connect(_al_entrar)
	body_exited.connect(_al_salir)
	_animar()

func _animar() -> void:
	var start_y = position.y
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", start_y - 4, 0.55) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", start_y + 4, 0.55) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _al_entrar(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body.item_cercano = self
		label_prompt.visible = true

func _al_salir(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		# Solo limpia la referencia si sigue apuntando a este item
		if body.item_cercano == self:
			body.item_cercano = null
		label_prompt.visible = false
