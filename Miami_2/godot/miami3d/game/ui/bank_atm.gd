class_name MnBankAtm
extends Control
## Caixa automático: depósito / saque / pagar aluguel.

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
	var bank := 0
	if g.is_native:
		bank = g.backend.get_bank()
	else:
		bank = g.economy.bank
	info.text = "Carteira $%d  |  Banco $%d" % [g.get_cash(), bank]


func _deposit() -> void:
	var n := int(amount.value)
	var g: BrainFacade = Bootstrap.game
	if g.is_native:
		if g.get_cash() >= n:
			g.backend.add_cash(-n)
			# bank via snapshot hack — use add through economy if gdscript
	else:
		g.economy.deposit(n)
	_refresh()


func _withdraw() -> void:
	var n := int(amount.value)
	var g: BrainFacade = Bootstrap.game
	if not g.is_native:
		g.economy.withdraw(n)
	_refresh()


func _rent() -> void:
	var g: BrainFacade = Bootstrap.game
	var rent := 300
	if g.is_native:
		if g.get_cash() >= rent:
			g.backend.add_cash(-rent)
			g.backend.set_flag("rent_paid_this_week", true)
	else:
		if g.economy.pay(rent):
			g.economy.rent_paid_this_week = true
			g.world.set_flag("rent_paid_this_week", true)
	_refresh()
