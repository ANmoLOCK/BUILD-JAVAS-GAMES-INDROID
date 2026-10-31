extends SceneTree
## Testes de economia / aluguel / banco.
## godot4 --path . --headless -s res://tests/test_economy.gd

func _init() -> void:
	MnTestHelpers.reset()
	var g := MnGame.new()
	MnTestHelpers.assert_eq(g.boot("res://content", "user://saves_test_eco"), OK, "boot")
	g.new_game("Eco", "f")

	MnTestHelpers.assert_eq(g.economy.rent_per_week, 300, "rent from rent.json")
	MnTestHelpers.assert_eq(g.economy.mansion_rent, 2000, "mansion rent")

	g.economy.add_cash(100)
	MnTestHelpers.assert_eq(g.economy.cash, 100, "cash")
	MnTestHelpers.assert_true(g.economy.pay(40), "pay")
	MnTestHelpers.assert_eq(g.economy.cash, 60, "after pay")
	MnTestHelpers.assert_true(g.economy.deposit(50), "deposit")
	MnTestHelpers.assert_eq(g.economy.cash, 10, "cash after deposit")
	MnTestHelpers.assert_eq(g.economy.bank, 50, "bank")
	MnTestHelpers.assert_true(g.economy.withdraw(20), "withdraw")
	MnTestHelpers.assert_eq(g.economy.cash, 30, "cash after withdraw")

	var bail: int = g.economy.current_bail(0)
	MnTestHelpers.assert_ge(bail, 40, "bail")

	var code := MnTestHelpers.summary("test_economy")
	print("TEST_ECONOMY_", "OK" if code == 0 else "FAIL")
	quit(code)
