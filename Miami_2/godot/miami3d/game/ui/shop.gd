class_name MnShop
extends Control
## Loja genérica: compra via BrainFacade.buy (contrato corpo→cérebro).

signal closed

var shop_id: String = "furniture_store"
@onready var list: VBoxContainer = $Panel/VBox/List


func _ready() -> void:
	visible = false


func open(p_shop_id: String = "furniture_store") -> void:
	shop_id = p_shop_id
	visible = true
	for c in list.get_children():
		c.queue_free()
	var title := Label.new()
	title.text = "Loja: " + shop_id
	list.add_child(title)
	Bootstrap.game._ensure_content()
	var items: Dictionary = Bootstrap.game.content.items
	for id in items.keys():
		var it: Dictionary = items[id]
		if str(it.get("shop", "")) != shop_id:
			continue
		var price := int(it.get("price", 0))
		var btn := Button.new()
		btn.text = "%s — $%d" % [Bootstrap.game.resolve_text(str(it.get("name", id))), price]
		btn.pressed.connect(_buy.bind(id))
		list.add_child(btn)
	var close_btn := Button.new()
	close_btn.text = "Fechar"
	close_btn.pressed.connect(func(): visible = false; closed.emit())
	list.add_child(close_btn)


func _buy(item_id: String) -> void:
	var r: Dictionary = Bootstrap.game.buy(item_id)
	if not bool(r.get("ok", false)):
		return
