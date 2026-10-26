class_name MnEconomySystem
extends RefCounted
## Dinheiro, banco (1%/dia), aluguel, fiança.

var events: MnEvents
var cash: int = 0
var bank: int = 0
var rent_per_week: int = 300
var mansion_rent: int = 2000
var rent_paid_this_week: bool = false
var bail_base: int = 200
var bail_min: int = 40
var bail_max: int = 500
var bail_half_after: int = 120
var _days_in_jail: int = 0


func setup(ev: MnEvents, stats_json: Dictionary = {}) -> void:
	events = ev
	var bail: Dictionary = stats_json.get("bail", {})
	bail_base = int(bail.get("base", 200))
	bail_min = int(bail.get("min", 40))
	bail_max = int(bail.get("max", 500))
	bail_half_after = int(bail.get("halfAfterMinutes", 120))


func add_cash(n: int) -> void:
	cash = maxi(0, cash + n)
	_emit()


func add_bank(n: int) -> void:
	bank = maxi(0, bank + n)
	_emit()


func can_afford(n: int) -> bool:
	return cash >= n


func pay(n: int) -> bool:
	if cash < n:
		return false
	cash -= n
	_emit()
	return true


func deposit(n: int) -> bool:
	if n <= 0 or cash < n:
		return false
	cash -= n
	bank += n
	_emit()
	return true


func withdraw(n: int) -> bool:
	if n <= 0 or bank < n:
		return false
	bank -= n
	cash += n
	_emit()
	return true


func on_day_tick() -> void:
	# juros ~1%/dia sobre saldo bancário
	if bank > 0:
		bank += maxi(1, int(round(bank * 0.01)))
		_emit()


func current_bail(minutes_jailed: int) -> int:
	var b := bail_base
	if minutes_jailed >= bail_half_after:
		b = maxi(bail_min, b / 2)
	return clampi(b, bail_min, bail_max)


func _emit() -> void:
	if events:
		events.money_changed.emit(cash, bank)


func to_dict() -> Dictionary:
	return {
		"cash": cash, "bank": bank,
		"rent_paid_this_week": rent_paid_this_week,
		"rent_per_week": rent_per_week,
	}


func from_dict(d: Dictionary) -> void:
	cash = int(d.get("cash", 0))
	bank = int(d.get("bank", 0))
	rent_paid_this_week = bool(d.get("rent_paid_this_week", false))
	rent_per_week = int(d.get("rent_per_week", 300))
	_emit()
