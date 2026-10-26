class_name MnBankAtm
extends Control
## Caixa automático: depósito / saque / aluguel via use_phone.

signal closed

@onready var info: Label = $Panel/VBox/Info
@onready var amount: SpinBox = $Panel/VBox/Amount


func _ready() -> void:
	visible = false
	$Panel/VBox/Deposit.pressed.connect(_deposit)
	$Panel/VBox/Withdraw.pressed.connect(_withdraw)
	$Panel/VBox/Rent.pressed.connect(_rent)
	$Panel/VBox/Close.pressed.connect(func(): visible = false; closed.emit())


func open() -> void:
	visible = true
	_refresh()


func _refresh() -> void:
	var g: BrainFacade = Bootstrap.game
	var snap: Dictionary = g.use_phone("stats")
	info.text = "Carteira $%d  |  Banco $%d" % [int(snap.get("cash", g.get_cash())), int(snap.get("bank", 0))]


func _deposit() -> void:
	Bootstrap.game.use_phone("deposit", {"amount": int(amount.value)})
	_refresh()


func _withdraw() -> void:
	Bootstrap.game.use_phone("withdraw", {"amount": int(amount.value)})
	_refresh()


func _rent() -> void:
	Bootstrap.game.use_phone("pay_rent")
	_refresh()
