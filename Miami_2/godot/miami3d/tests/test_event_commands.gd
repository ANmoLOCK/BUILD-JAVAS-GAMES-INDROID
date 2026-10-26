extends SceneTree
## Contrato de eventos: comandos corpo → cérebro.
## godot4 --path . --headless -s res://tests/test_event_commands.gd

func _init() -> void:
	MnTestHelpers.reset()
	var g := MnGame.new()
	MnTestHelpers.assert_eq(g.boot("res://content", "user://saves_test_ev"), OK, "boot")
	g.rng.seed_value(42)
	g.new_game("Eve", "f")

	# tick_real acumula minuto
	var m0 := g.time.minute_of_day
	g.time.seconds_per_minute = 0.5
	g.tick_real(0.5)
	MnTestHelpers.assert_eq(g.time.minute_of_day, m0 + 1, "tick_real minute")

	# enter / leave
	g.enter_location("first_street", "from_apartment")
	MnTestHelpers.assert_eq(g.world.location_id, "first_street", "enter_location")
	var left: Dictionary = g.leave_location()
	MnTestHelpers.assert_true(bool(left.get("ok", false)), "leave_location ok")
	MnTestHelpers.assert_eq(g.world.location_id, "", "left clears location")
	g.enter_location("player_apartment", "")

	# buy / inventory
	g.economy.cash = 500
	var item_id := "bed_standard"
	if not g.content.items.has(item_id):
		# pega qualquer item com preço
		for k in g.content.items.keys():
			if int(g.content.items[k].get("price", 0)) > 0:
				item_id = str(k)
				break
	var price := int(g.content.get_item(item_id).get("price", 10))
	var before := g.economy.cash
	var bought: Dictionary = g.buy(item_id)
	MnTestHelpers.assert_true(bool(bought.get("ok", false)), "buy ok")
	MnTestHelpers.assert_eq(g.economy.cash, before - price, "buy paid")
	MnTestHelpers.assert_true(g.inventory.has(item_id), "buy inventory")

	# place_furniture
	var placed: Dictionary = g.place_furniture("slot_bed", item_id)
	MnTestHelpers.assert_true(bool(placed.get("ok", false)), "place_furniture")
	MnTestHelpers.assert_eq(str(g.home.slots.get("slot_bed", "")), item_id, "furniture slot")

	# equip cycle
	var eq: Dictionary = g.equip("", {"cycle": true, "slot": "top", "max": 6})
	MnTestHelpers.assert_true(bool(eq.get("ok", false)), "equip cycle")

	# phone rent / deposit
	g.economy.cash = 1000
	g.economy.bank = 0
	g.economy.rent_paid_this_week = false
	var dep: Dictionary = g.use_phone("deposit", {"amount": 100})
	MnTestHelpers.assert_true(bool(dep.get("ok", false)), "phone deposit")
	MnTestHelpers.assert_eq(g.economy.bank, 100, "bank after deposit")
	var rent: Dictionary = g.use_phone("pay_rent")
	MnTestHelpers.assert_true(bool(rent.get("ok", false)), "phone pay_rent")

	# minigame result
	var cash0 := g.economy.cash
	var mg: Dictionary = g.start_minigame_result("dance", true, 40)
	MnTestHelpers.assert_true(bool(mg.get("ok", false)), "minigame win")
	MnTestHelpers.assert_gt(g.economy.cash, cash0, "minigame reward")

	# advance time + save_hint observed
	var hinted := {"v": false}
	g.events.save_hint.connect(func(): hinted["v"] = true)
	var adv: Dictionary = g.advance_time_request(30)
	MnTestHelpers.assert_true(bool(adv.get("ok", false)), "advance_time")
	MnTestHelpers.assert_true(bool(hinted["v"]), "save_hint after advance")

	# BrainFacade mirrors commands
	var facade := BrainFacade.new()
	MnTestHelpers.assert_eq(facade.boot("res://content", "user://saves_test_ev2"), OK, "facade boot")
	facade.new_game("Fac", "m")
	if not facade.is_native:
		facade.economy.cash = 500
		var fb: Dictionary = facade.buy(item_id)
		MnTestHelpers.assert_true(typeof(fb) == TYPE_DICTIONARY, "facade buy dict")
		var fl: Dictionary = facade.leave_location()
		MnTestHelpers.assert_true(typeof(fl) == TYPE_DICTIONARY, "facade leave")
		facade.enter_location("player_apartment", "")
		var fp: Dictionary = facade.use_phone("stats")
		MnTestHelpers.assert_true(bool(fp.get("ok", false)), "facade phone stats")

	var code := MnTestHelpers.summary("test_event_commands")
	print("TEST_EVENT_COMMANDS_", "OK" if code == 0 else "FAIL")
	quit(code)
