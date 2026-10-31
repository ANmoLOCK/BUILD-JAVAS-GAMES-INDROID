extends Control
## Tela de carregamento Miami Life — progresso fake + tips + boot real do pack.

signal finished

@onready var bg: TextureRect = $Bg
@onready var logo: TextureRect = $Safe/Logo
@onready var title: Label = $Safe/Title
@onready var tip: Label = $Safe/Tip
@onready var bar: ProgressBar = $Safe/Bar
@onready var status: Label = $Safe/Status

var _tips: Array = []
var _tip_i: int = 0
var _progress: float = 0.0
var _done_boot: bool = false
var _min_time: float = 1.8
var _elapsed: float = 0.0


func _ready() -> void:
	var hero := MnBrand.load_texture("hero_bg")
	if hero and bg:
		bg.texture = hero
	var glogo := MnBrand.load_texture("game_logo")
	if glogo and logo:
		logo.texture = glogo
	if title:
		title.text = MnBrand.title_short()
	_tips = MnBrand.boot().get("tips_pt", [])
	_min_time = float(MnBrand.boot().get("loading_min_s", 1.8))
	_rotate_tip()
	_run_boot()


func _process(delta: float) -> void:
	_elapsed += delta
	# sobe suave até 0.92 enquanto boot; completa ao liberar
	var target := 1.0 if _done_boot and _elapsed >= _min_time else 0.92
	_progress = move_toward(_progress, target, delta * (0.35 if not _done_boot else 1.2))
	if bar:
		bar.value = _progress * 100.0
	if _done_boot and _elapsed >= _min_time and _progress >= 0.995:
		set_process(false)
		var tw := create_tween()
		tw.tween_property(self, "modulate:a", 0.0, 0.35)
		tw.tween_callback(func(): finished.emit())


func _run_boot() -> void:
	status.text = "Preparando Miami…"
	await get_tree().process_frame
	# revalida fachada já bootada pelo Bootstrap
	if Bootstrap.game and Bootstrap.game.ready:
		status.text = "Cérebro pronto"
		await get_tree().create_timer(0.25).timeout
		status.text = "Carregando cidade…"
		await get_tree().create_timer(0.3).timeout
		status.text = "Quase lá"
	else:
		status.text = "Aguardando bootstrap…"
		await get_tree().create_timer(0.5).timeout
	_done_boot = true


func _rotate_tip() -> void:
	if tip == null:
		return
	if _tips.is_empty():
		tip.text = MnBrand.tagline()
		return
	tip.text = str(_tips[_tip_i % _tips.size()])
	_tip_i += 1
	var t := get_tree().create_timer(2.2)
	t.timeout.connect(_rotate_tip, CONNECT_ONE_SHOT)


func _gui_input(event: InputEvent) -> void:
	# não pula loading — evita menu sem boot visual
	pass
