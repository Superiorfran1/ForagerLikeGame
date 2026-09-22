extends Node2D
 
# brujula.gd
# Nodo hijo del CharacterBody2D.
# La brújula se recoge como cualquier ItemPickup (tecla E).
# Cuando está en mano y el jugador hace clic izquierdo, cierra la aplicación.
 
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var jugador: CharacterBody2D = get_parent()
			if jugador.item_en_mano.get("nombre", "") == "brujula":
				get_tree().quit()
 
