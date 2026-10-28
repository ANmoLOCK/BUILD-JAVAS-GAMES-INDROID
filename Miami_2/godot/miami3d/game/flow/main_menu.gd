extends Control
## Menu Miami Life: marca hero + Novo / Continuar / Sair + fase A–G.

signal new_game
signal continue_game
signal quit_game

@onready var bg: TextureRect = $HeroBg
@onready var logo: TextureRect = $BrandBlock/Logo
@onready var brand: Label = $BrandBlock/Title
@onready var tagline: Label = $BrandBlock/Tagline
@onready var studio_line: Label = $StudioLine
@onready var status: Label = $Panel/VBox/Status
@onready var continue_btn: Button = $Panel/VBox/Continue

var _phase_pick: OptionButton


func _ready() -> void:
	_apply_brand()
	$Panel/VBox/New.pressed.connect(func(): new_game.emit())
	continue_btn.pressed.connect(func(): continue_game.emit())
	$Panel/VBox/Quit.pressed.connect(func(): quit_game.emit())
	_build_phase_picker()
	refresh()
	modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.55)
	# leve respiração no logo
	if logo:
		var pulse := create_tween().set_loops()
		pulse.tween_property(logo, "scale", Vector2(1.03, 1.03), 1.4).set_trans(Tween.TRANS_SINE)
		pulse.tween_property(logo, "scale", Vector2(1.0, 1.0), 1.4).set_trans(Tween.TRANS_SINE)


func _apply_brand() -> void:
	var hero := MnBrand.load_texture("hero_bg")
	if hero and bg:
		bg.texture = hero
	var glogo := MnBrand.load_texture("game_logo")
	if glogo and logo:
		logo.texture = glogo
	if brand:
		brand.text = MnBrand.title_short()
	if tagline:
		tagline.text = MnBrand.tagline()
	if studio_line:
		studio_line.text = MnBrand.studio_legal()


func _build_phase_picker() -> void:
	if _phase_pick:
		return
	var wrap := HBoxContainer.new()
	wrap.name = "PhaseRow"
	var lbl := Label.new()
	lbl.text = "Fase"
	_phase_pick = OptionButton.new()
	_phase_pick.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var g: BrainFacade = Bootstrap.game
	var order: Array = ["a", "b", "c", "d", "e", "f", "g"]
	if g and g.phases and g.phases.has_method("order"):
		order = g.phases.order()
	var current := g.get_phase() if g and g.has_method("get_phase") else "a"
	var idx := 0
	for i in order.size():
		var pid := str(order[i])
		var title := pid.to_upper()
		if g and g.has_method("resolve_text"):
			title = g.resolve_text("@phase.%s" % pid)
		_phase_pick.add_item(title, i)
		_phase_pick.set_item_metadata(i, pid)
		if pid == current:
			idx = i
	_phase_pick.select(idx)
	_phase_pick.item_selected.connect(_on_phase_picked)
	wrap.add_child(lbl)
	wrap.add_child(_phase_pick)
	var vbox: VBoxContainer = $Panel/VBox
	vbox.add_child(wrap)
	vbox.move_child(wrap, status.get_index() + 1)


func _on_phase_picked(i: int) -> void:
	var pid := str(_phase_pick.get_item_metadata(i))
	var g: BrainFacade = Bootstrap.game
	if g and g.has_method("set_phase"):
		g.set_phase(pid, false)
		if ProjectSettings.has_setting("miami/phase"):
			ProjectSettings.set_setting("miami/phase", pid)
		refresh()


func refresh() -> void:
	var g: BrainFacade = Bootstrap.game
	var mode := "C++" if g and g.is_native else "GDScript"
	var has_save := false
	var phase := "?"
	var ready_when := ""
	if g and g.ready:
		var path := "user://saves/slot_0.json"
		has_save = FileAccess.file_exists(path)
		if g.has_method("get_phase"):
			phase = g.get_phase()
		if g.phases:
			ready_when = str(g.phases.phase_def(phase).get("ready_when", ""))
	continue_btn.disabled = not has_save
	var line := "%s  ·  fase %s  ·  save: %s" % [mode, phase.to_upper(), "ok" if has_save else "nenhum"]
	if ready_when != "":
		line += "\n" + ready_when
	status.text = line
