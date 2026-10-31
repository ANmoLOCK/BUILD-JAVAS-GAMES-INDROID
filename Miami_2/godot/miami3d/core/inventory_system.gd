class_name MnInventorySystem
extends RefCounted
## Itens, stacks, quest items.

var events: MnEvents
var items: Dictionary = {} # id -> count


func setup(ev: MnEvents) -> void:
	events = ev


func count(item_id: String) -> int:
	return int(items.get(item_id, 0))


func has(item_id: String) -> bool:
	return count(item_id) > 0


func give(item_id: String, n: int = 1) -> void:
	items[item_id] = count(item_id) + n
	if events:
		events.inventory_changed.emit()


func take(item_id: String, n: int = 1) -> bool:
	if count(item_id) < n:
		return false
	var left := count(item_id) - n
	if left <= 0:
		items.erase(item_id)
	else:
		items[item_id] = left
	if events:
		events.inventory_changed.emit()
	return true


func to_dict() -> Dictionary:
	return items.duplicate()


func from_dict(d: Dictionary) -> void:
	items = d.duplicate()
