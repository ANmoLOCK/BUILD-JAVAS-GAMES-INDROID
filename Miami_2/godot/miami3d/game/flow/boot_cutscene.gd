extends Control
## Cutscene de abertura:
## tela preta → logo HueHueGames → Miami Life (nome+logo) → barra de carregamento → finished.

signal finished

enum Phase { BLACK, STUDIO, TITLE, LOADING, DONE }

@onready var black: ColorRect = $Black
@onready var studio_wrap: Control = $Studio
@onready var studio_logo: TextureRect = $Studio/Logo
@onready var studio_label: Label = $Studio/Name
@onready var title_wrap: Control = $Title
@onready var game_logo: TextureRect = $Title/Logo
@onready var game_title: Label = $Title/Name
@onready var tip: Label = $Title/Tip
@onready var bar: ProgressBar = $Title/Bar
@onready var status: Label = $Title/Status

var phase: Phase = Phase.BLACK
var _progress: float = 0.0
var _done_boot: bool = false
var _load_elapsed: float = 0.0
var _min_load: float = 2.2
var _tips: Array = []
var _tip_i: int = 0
var _skip_armed: bool = false


func _ready() -> void:
	_apply_brand()
	studio_wrap.modulate.a = 0.0
	title_wrap.modulate.a = 0.0
	title_wrap.visible = false
	studio_wrap.visible = true
	bar.value = 0.0
	_min_load = float(MnBrand.boot().get("loading_min_s", 2.2))
	_tips = MnBrand.boot().get("tips_pt", [])
	_play_cutscene()


func _apply_brand() -> void:
	var stex := MnBrand.load_texture("studio_logo")
	if stex and studio_logo:
		studio_logo.texture = stex
	if studio_label:
		studio_label.text = MnBrand.studio()
	var gtex := MnBrand.load_texture("game_logo")
	if gtex and game_logo:
		game_logo.texture = gtex
	if game_title:
		game_title.text = MnBrand.title_short()
	if tip:
		tip.text = MnBrand.tagline()
	if status:
		status.text = ""


func _play_cutscene() -> void:
	phase = Phase.BLACK
	var b := MnBrand.boot()
	var black_hold := float(b.get("black_hold_s", 0.55))
	var sin_t := float(b.get("studio_fade_in_s", 0.7))
	var shold := float(b.get("studio_hold_s", 1.8))
	var sout := float(b.get("studio_fade_out_s", 0.5))
	var tin := float(b.get("title_fade_in_s", 0.75))
	var thold := float(b.get("title_hold_s", 0.6))

	# 1) tela preta
	await get_tree().create_timer(black_hold).timeout
	_skip_armed = true

	# 2) HueHueGames
	phase = Phase.STUDIO
	var tw := create_tween()
	tw.tween_property(studio_wrap, "modulate:a", 1.0, sin_t)
	await tw.finished
	await get_tree().create_timer(shold).timeout
	var tw2 := create_tween()
	tw2.tween_property(studio_wrap, "modulate:a", 0.0, sout)
	await tw2.finished
	studio_wrap.visible = false

	# 3) Miami Life nome + logo
	phase = Phase.TITLE
	title_wrap.visible = true
	title_wrap.modulate.a = 0.0
	var tw3 := create_tween()
	tw3.tween_property(title_wrap, "modulate:a", 1.0, tin)
	await tw3.finished
	await get_tree().create_timer(thold).timeout

	# 4) barra de carregamento (mesmo quadro)
	phase = Phase.LOADING
	_rotate_tip()
	_run_boot()
	set_process(true)


func _process(delta: float) -> void:
	if phase != Phase.LOADING:
		return
	_load_elapsed += delta
	var target := 1.0 if _done_boot and _load_elapsed >= _min_load else 0.9
	_progress = move_toward(_progress, target, delta * (0.32 if not _done_boot else 1.1))
	if bar:
		bar.value = _progress * 100.0
	if _done_boot and _load_elapsed >= _min_load and _progress >= 0.995:
		set_process(false)
		phase = Phase.DONE
		var tw := create_tween()
		tw.tween_property(self, "modulate:a", 0.0, 0.4)
		tw.tween_callback(func(): finished.emit())


func _run_boot() -> void:
	if status:
		status.text = "Preparando Miami…"
	await get_tree().process_frame
	if Bootstrap.game and Bootstrap.game.ready:
		if status:
			status.text = "Cérebro pronto"
		await get_tree().create_timer(0.3).timeout
		if status:
			status.text = "Carregando cidade…"
		await get_tree().create_timer(0.35).timeout
		if status:
			status.text = "Quase lá"
	else:
		if status:
			status.text = "Aguardando bootstrap…"
		await get_tree().create_timer(0.55).timeout
	_done_boot = true


func _rotate_tip() -> void:
	if tip == null:
		return
	if _tips.is_empty():
		tip.text = MnBrand.tagline()
		return
	tip.text = str(_tips[_tip_i % _tips.size()])
	_tip_i += 1
	if phase == Phase.LOADING:
		var t := get_tree().create_timer(2.0)
		t.timeout.connect(_rotate_tip, CONNECT_ONE_SHOT)


func _gui_input(event: InputEvent) -> void:
	# skip só no estúdio (não pula loading)
	if not _skip_armed or phase != Phase.STUDIO:
		return
	var tap := false
	if event is InputEventMouseButton and event.pressed:
		tap = true
	elif event is InputEventScreenTouch and event.pressed:
		tap = true
	if tap:
		# força fade-out rápido do estúdio na próxima frame via modulate
		studio_wrap.modulate.a = 0.0
