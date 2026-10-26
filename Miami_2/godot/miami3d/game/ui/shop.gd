class_name MnShop
extends Control
## Loja genérica: lista itens com preço do content.

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
		btn.pressed.connect(_buy.bind(id, price))
		list.add_child(btn)
	var close_btn := Button.new()
	close_btn.text = "Fechar"
	close_btn.pressed.connect(func(): visible = false; closed.emit())
	list.add_child(close_btn)


func _buy(item_id: String, price: int) -> void:
	var g: BrainFacade = Bootstrap.game
	if g.get_cash() < price:
		return
	if g.is_native:
		g.backend.add_cash(-price)
		# inventário via interact give — simplificado
	else:
		g.economy.pay(price)
		g.inventory.give(item_id)
