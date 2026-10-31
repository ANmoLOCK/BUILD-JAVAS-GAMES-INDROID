extends SceneTree
## Operação das fases A–G: bootstrap, checklist, mods.
## godot4 --path . --headless -s res://tests/test_phase_ops.gd

func _init() -> void:
	MnTestHelpers.reset()
	var g := MnGame.new()
	MnTestHelpers.assert_eq(g.boot("res://content", "user://saves_test_ops"), OK, "boot")

	# --- A ---
	var a: Dictionary = g.start_phase("a")
	MnTestHelpers.assert_true(bool(a.get("ok", false)), "boot A")
	MnTestHelpers.assert_eq(g.world.location_id, "player_apartment", "A start apt")
	MnTestHelpers.assert_true(g.world.has_flag("phase_a"), "flag A")
	var audit_a: Dictionary = g.audit_phase("a")
	MnTestHelpers.assert_true(bool(audit_a.get("ok", false)), "audit A ok: %s" % str(audit_a.get("failed", [])))

	# --- B senhorio ---
	var b: Dictionary = g.start_phase("b")
	MnTestHelpers.assert_true(bool(b.get("ok", false)), "boot B")
	MnTestHelpers.assert_true(g.quests.is_active("q_landlord"), "q_landlord active")
	MnTestHelpers.assert_ge(g.economy.cash, 40, "B starter cash")
	var audit_b: Dictionary = g.audit_phase("b")
	MnTestHelpers.assert_true(bool(audit_b.get("ok", false)), "audit B: %s" % str(audit_b.get("failed", [])))

	# --- C prólogo praia ---
	var c: Dictionary = g.start_phase("c")
	MnTestHelpers.assert_true(bool(c.get("ok", false)), "boot C")
	MnTestHelpers.assert_eq(g.world.location_id, "south_beach", "C beach")
	MnTestHelpers.assert_true(g.quests.is_active("q001_encontre_scott"), "prologue q001")
	MnTestHelpers.assert_true(g.world.has_flag("prologue_active"), "prologue flag")

	# --- D empregos ---
	var d: Dictionary = g.start_phase("d")
	MnTestHelpers.assert_true(bool(d.get("ok", false)), "boot D")
	MnTestHelpers.assert_true(g.world.is_unlocked("stadium"), "D stadium")
	MnTestHelpers.assert_true(g.phases.system_unlocked("jobs"), "D jobs sys")
	var shift: Dictionary = g.work_shift("bartender")
	MnTestHelpers.assert_true(typeof(shift) == TYPE_DICTIONARY, "shift dict")

	# --- E vida ---
	var e: Dictionary = g.start_phase("e")
	MnTestHelpers.assert_true(bool(e.get("ok", false)), "boot E")
	MnTestHelpers.assert_true(g.quests.is_active("q_gnomes") or g.quests.defs.has("q_gnomes"), "gnomes quest")
	var pet: Dictionary = g.adopt_pet("rex", "dog", "lab")
	MnTestHelpers.assert_true(bool(pet.get("ok", false)), "pet E")

	# --- F ---
	var f: Dictionary = g.start_phase("f")
	MnTestHelpers.assert_true(bool(f.get("ok", false)), "boot F")
	MnTestHelpers.assert_true(g.world.is_unlocked("mansion"), "F mansion")
	MnTestHelpers.assert_ge(g.home.tier, 1, "F home tier")

	# --- G mods ---
	var gg: Dictionary = g.start_phase("g")
	MnTestHelpers.assert_true(bool(gg.get("ok", false)), "boot G")
	# example pack em res://mods
	var mods: Dictionary = g.load_mods()
	MnTestHelpers.assert_true(typeof(mods) == TYPE_DICTIONARY, "mods dict")
	MnTestHelpers.assert_true(g.content.locations.has("mod_pier") or int(mods.get("loaded", 0)) >= 0, "mod pier or empty ok")
	# força apply do exemplo
	var err := g.content.merge_pack("res://mods/example_pack")
	MnTestHelpers.assert_eq(err, OK, "merge example_pack")
	MnTestHelpers.assert_true(g.content.locations.has("mod_pier"), "mod_pier merged")
	MnTestHelpers.assert_true(g.content.npcs.has("mod_fisher"), "mod_fisher merged")
	MnTestHelpers.assert_true(g.content.quests.has("q_mod_fish"), "q_mod_fish merged")

	var audit_g: Dictionary = g.audit_phase("g")
	MnTestHelpers.assert_true(bool(audit_g.get("ok", false)), "audit G: %s" % str(audit_g.get("failed", [])))

	var all: Dictionary = g.audit_all_phases()
	MnTestHelpers.assert_true(typeof(all.get("phases", {})) == TYPE_DICTIONARY, "audit_all")
	print("AUDIT_ALL ok=", all.get("ok"), " phases=", (all.get("phases", {}) as Dictionary).keys())

	var code := MnTestHelpers.summary("test_phase_ops")
	print("TEST_PHASE_OPS_", "OK" if code == 0 else "FAIL")
	quit(code)
