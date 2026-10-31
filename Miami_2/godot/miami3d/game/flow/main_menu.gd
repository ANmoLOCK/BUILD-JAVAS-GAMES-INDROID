extends Control
## Menu principal Sugestão B: marca à esquerda + trilho direito (pack00).

signal new_game
signal continue_game
signal quit_game

const SETTINGS_PATH := "user://miami_settings.cfg"
const SAVE_SLOT := 0

@onready var bg: TextureRect = $HeroBg
@onready var logo: TextureRect = $BrandColumn/BrandBlock/Logo
@onready var brand: Label = $BrandColumn/BrandBlock/Title
@onready var tagline: Label = $BrandColumn/BrandBlock/Tagline
@onready var studio_line: Label = $StudioLine
@onready var list: VBoxContainer = $Rail/VBox/Scroll/List
@onready var status: Label = $Rail/VBox/Status
@onready var overlay: Control = $Overlay
@onready var dialog_title: Label = $Overlay/Dialog/Margin/VBox/Title
@onready var dialog_body: VBoxContainer = $Overlay/Dialog/Margin/VBox/BodyScroll/Body
@onready var dialog_cancel: Button = $Overlay/Dialog/Margin/VBox/Actions/Cancel
@onready var dialog_confirm: Button = $Overlay/Dialog/Margin/VBox/Actions/Confirm

var _continue_btn: Button
var _reset_btn: Button
var _style_normal: StyleBoxFlat
var _style_hover: StyleBoxFlat
var _style_focus: StyleBoxFlat
var _style_disabled: StyleBoxFlat
var _style_dialog: StyleBoxFlat
var _settings: ConfigFile = ConfigFile.new()
var _dialog_mode: String = ""
var _confirm_cb: Callable = Callable()


func _ready() -> void:
	_load_settings()
	_apply_audio_from_settings()
	_build_styles()
	_apply_brand()
	_style_dialog_panel()
	_build_menu_buttons()
	_wire_overlay()
	_fit_studio_footer()
	get_viewport().size_changed.connect(_fit_studio_footer)
	refresh()
	modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.5)
	if logo:
		var pulse := create_tween().set_loops()
		pulse.tween_property(logo, "scale", Vector2(1.03, 1.03), 1.4).set_trans(Tween.TRANS_SINE)
		pulse.tween_property(logo, "scale", Vector2(1.0, 1.0), 1.4).set_trans(Tween.TRANS_SINE)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_fit_studio_footer()


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


func _fit_studio_footer() -> void:
	## HueHueGames colado no canto inferior esquerdo (fora do trilho).
	if studio_line == null:
		return
	var vp := get_viewport_rect().size
	if vp.x < 1.0:
		return
	var left_limit := vp.x * 0.58
	studio_line.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	studio_line.anchor_left = 0.0
	studio_line.anchor_top = 1.0
	studio_line.anchor_right = 0.0
	studio_line.anchor_bottom = 1.0
	studio_line.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	studio_line.grow_vertical = Control.GROW_DIRECTION_BEGIN
	studio_line.offset_left = 24.0
	studio_line.offset_top = -36.0
	studio_line.offset_right = mini(left_limit - 20.0, 380.0)
	studio_line.offset_bottom = -10.0
	studio_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	studio_line.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	studio_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	studio_line.z_index = 4
	_fit_brand_block(vp)


func _fit_brand_block(vp: Vector2) -> void:
	var block: VBoxContainer = $BrandColumn/BrandBlock
	if block == null:
		return
	var half_w := mini(280.0, vp.x * 0.26)
	var half_h := mini(170.0, vp.y * 0.28)
	block.offset_left = -half_w
	block.offset_right = half_w
	block.offset_top = -half_h
	block.offset_bottom = half_h
	if logo:
		var side := clampf(vp.y * 0.2, 96.0, 148.0)
		logo.custom_minimum_size = Vector2(side, side)
		logo.pivot_offset = Vector2(side * 0.5, side * 0.5)


func _build_styles() -> void:
	_style_normal = _make_style(Color(0.06, 0.1, 0.16, 0.78), Color(1, 1, 1, 0.1), 1)
	_style_hover = _make_style(Color(0.1, 0.16, 0.24, 0.9), Color(1, 0.62, 0.5, 0.45), 1)
	_style_focus = _make_style(Color(0.78, 0.32, 0.3, 0.92), Color(0.35, 0.9, 0.92, 0.95), 2)
	_style_focus.bg_color = Color(0.72, 0.28, 0.28, 0.55)
	# fill coral→cyan approx: warm left via border accent
	_style_focus.border_width_left = 5
	_style_focus.border_color = Color(1.0, 0.42, 0.38, 1.0)
	_style_disabled = _make_style(Color(0.05, 0.07, 0.1, 0.45), Color(1, 1, 1, 0.05), 1)
	_style_dialog = _make_style(Color(0.05, 0.08, 0.12, 0.96), Color(1, 0.55, 0.45, 0.35), 1)


func _make_style(bg: Color, border: Color, width: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(width)
	s.set_corner_radius_all(6)
	s.content_margin_left = 16
	s.content_margin_right = 16
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	return s


func _style_dialog_panel() -> void:
	var panel: PanelContainer = $Overlay/Dialog
	panel.add_theme_stylebox_override("panel", _style_dialog)
	_apply_btn_style(dialog_cancel)
	_apply_btn_style(dialog_confirm)
	dialog_confirm.add_theme_stylebox_override("normal", _style_focus)


func _build_menu_buttons() -> void:
	for c in list.get_children():
		c.queue_free()
	# Ordem da sugestão B (Nova partida em destaque)
	_add_btn("Nova partida", _on_new_game, true)
	_continue_btn = _add_btn("Continuar", _on_continue)
	_add_btn("Opções", _open_options)
	_add_btn("Ajuda", _open_help)
	_add_btn("Créditos", _open_credits)
	_reset_btn = _add_btn("Resetar jogo", _open_reset)
	_add_btn("Sair", func(): quit_game.emit())


func _add_btn(label: String, cb: Callable, primary: bool = false) -> Button:
	var b := Button.new()
	b.text = label
	b.custom_minimum_size = Vector2(0, 46)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.focus_mode = Control.FOCUS_ALL
	_apply_btn_style(b)
	if primary:
		b.add_theme_stylebox_override("normal", _style_focus)
		b.add_theme_stylebox_override("hover", _style_focus)
	b.pressed.connect(cb)
	list.add_child(b)
	return b


func _apply_btn_style(b: Button) -> void:
	b.add_theme_stylebox_override("normal", _style_normal)
	b.add_theme_stylebox_override("hover", _style_hover)
	b.add_theme_stylebox_override("pressed", _style_focus)
	b.add_theme_stylebox_override("focus", _style_focus)
	b.add_theme_stylebox_override("disabled", _style_disabled)
	b.add_theme_color_override("font_color", Color(0.96, 0.96, 0.97, 1))
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1, 1))
	b.add_theme_color_override("font_pressed_color", Color(1, 1, 1, 1))
	b.add_theme_color_override("font_disabled_color", Color(0.55, 0.6, 0.65, 0.7))
	b.add_theme_font_size_override("font_size", 17)


func _on_new_game() -> void:
	if _has_save():
		_clear_dialog_body()
		_open_dialog("Nova partida", "new_overwrite", true, "Começar")
		_confirm_cb = func():
			_close_dialog()
			new_game.emit()
		var l := Label.new()
		l.text = "Já existe um save. Começar de novo não apaga o arquivo — use Resetar jogo para limpar.\nDeseja iniciar mesmo assim?"
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.add_theme_font_size_override("font_size", 14)
		dialog_body.add_child(l)
		return
	new_game.emit()


func _on_continue() -> void:
	if _has_save():
		continue_game.emit()
	else:
		_toast_status("Nenhum save para continuar.")


func _wire_overlay() -> void:
	overlay.visible = false
	$Overlay/Dim.gui_input.connect(_on_dim_input)
	dialog_cancel.pressed.connect(_close_dialog)
	dialog_confirm.pressed.connect(_on_dialog_confirm)


func _on_dim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _dialog_mode != "reset":
			_close_dialog()


func _clear_dialog_body() -> void:
	for c in dialog_body.get_children():
		c.queue_free()


func _open_dialog(title: String, mode: String, show_confirm: bool = true, confirm_text: String = "OK") -> void:
	_dialog_mode = mode
	_confirm_cb = Callable()
	dialog_title.text = title
	dialog_confirm.visible = show_confirm
	dialog_confirm.text = confirm_text
	dialog_cancel.text = "Voltar"
	overlay.visible = true


func _close_dialog() -> void:
	overlay.visible = false
	_dialog_mode = ""
	_confirm_cb = Callable()
	_clear_dialog_body()


func _on_dialog_confirm() -> void:
	if _confirm_cb.is_valid():
		_confirm_cb.call()
	elif _dialog_mode == "reset":
		_do_reset()
	else:
		_close_dialog()


func _open_options() -> void:
	_clear_dialog_body()
	_open_dialog("Opções", "options", true, "Salvar")
	_confirm_cb = _save_options_from_dialog

	var sound := _check("Som", bool(_settings.get_value("audio", "sound_on", true)))
	sound.name = "Sound"
	dialog_body.add_child(sound)

	var tips := _check("Dicas na tela", bool(_settings.get_value("ui", "tips", true)))
	tips.name = "Tips"
	dialog_body.add_child(tips)

	var autosave := _check("Autosalvar", bool(_settings.get_value("game", "autosave", true)))
	autosave.name = "Autosave"
	dialog_body.add_child(autosave)

	var phase_row := HBoxContainer.new()
	var pl := Label.new()
	pl.text = "Fase"
	pl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var pick := OptionButton.new()
	pick.name = "Phase"
	pick.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_fill_phase_picker(pick)
	phase_row.add_child(pl)
	phase_row.add_child(pick)
	dialog_body.add_child(phase_row)

	var hint := Label.new()
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.add_theme_font_size_override("font_size", 12)
	hint.add_theme_color_override("font_color", Color(0.7, 0.8, 0.86, 1))
	hint.text = "Som liga/desliga o áudio mestre. Autosalvar e dicas ficam gravados neste aparelho."
	dialog_body.add_child(hint)


func _fill_phase_picker(pick: OptionButton) -> void:
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
		pick.add_item(title, i)
		pick.set_item_metadata(i, pid)
		if pid == current:
			idx = i
	pick.select(idx)


func _save_options_from_dialog() -> void:
	var sound: CheckButton = dialog_body.get_node_or_null("Sound")
	var tips: CheckButton = dialog_body.get_node_or_null("Tips")
	var autosave: CheckButton = dialog_body.get_node_or_null("Autosave")
	var pick: OptionButton = dialog_body.find_child("Phase", true, false) as OptionButton
	if sound:
		_settings.set_value("audio", "sound_on", sound.button_pressed)
	if tips:
		_settings.set_value("ui", "tips", tips.button_pressed)
	if autosave:
		_settings.set_value("game", "autosave", autosave.button_pressed)
	_settings.save(SETTINGS_PATH)
	_apply_audio_from_settings()
	if pick and pick.item_count > 0:
		var pid := str(pick.get_item_metadata(pick.selected))
		var g: BrainFacade = Bootstrap.game
		if g and g.has_method("set_phase"):
			g.set_phase(pid, false)
		ProjectSettings.set_setting("miami/phase", pid)
	_close_dialog()
	refresh()
	_toast_status("Opções salvas.")


func _open_help() -> void:
	_clear_dialog_body()
	_open_dialog("Ajuda", "help", false)
	var lines := [
		"Toque no chão para se mover.",
		"Toque em objetos ou pessoas para abrir o menu de ações.",
		"Abra o telefone pelo HUD para agenda, missões e salvar.",
		"Pausa: Continuar · Mapa · Opções · Salvar · Menu principal.",
		"O mapa libera locais conforme sua fase.",
	]
	for tip in MnBrand.boot().get("tips_pt", []):
		lines.append(str(tip))
	for t in lines:
		var l := Label.new()
		l.text = "• " + t
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.add_theme_font_size_override("font_size", 14)
		dialog_body.add_child(l)


func _open_credits() -> void:
	_clear_dialog_body()
	_open_dialog("Créditos", "credits", false)
	var ver := str(ProjectSettings.get_setting("application/config/version", "?"))
	var blocks := [
		"%s\nVersão %s" % [MnBrand.title(), ver],
		"Estúdio\n%s" % MnBrand.studio(),
		"Remake 3D do life-sim Miami Nights 2 (referência Java ME).",
		"AVISO:\nQualquer bronzeado que você tenha pego durante o jogo não aumenta o seu verdadeiro sex-appeal.\nObrigado por jogar.",
	]
	for b in blocks:
		var l := Label.new()
		l.text = b
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.add_theme_font_size_override("font_size", 14)
		dialog_body.add_child(l)


func _open_reset() -> void:
	_clear_dialog_body()
	_open_dialog("Redefinir jogo?", "reset", true, "Redefinir")
	_confirm_cb = _do_reset
	var l := Label.new()
	l.text = "Isso apaga o progresso salvo neste aparelho (slot 0).\nNão tem volta."
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size", 15)
	dialog_body.add_child(l)


func _do_reset() -> void:
	var err := _delete_save()
	_close_dialog()
	refresh()
	if err == OK or err == ERR_FILE_NOT_FOUND:
		_toast_status("Progresso redefinido.")
	else:
		_toast_status("Falha ao redefinir (%s)." % error_string(err))


func _check(label: String, on: bool) -> CheckButton:
	var c := CheckButton.new()
	c.text = label
	c.button_pressed = on
	return c


func _load_settings() -> void:
	_settings = ConfigFile.new()
	_settings.load(SETTINGS_PATH)


func _apply_audio_from_settings() -> void:
	var on := bool(_settings.get_value("audio", "sound_on", true))
	var idx := AudioServer.get_bus_index("Master")
	if idx >= 0:
		AudioServer.set_bus_mute(idx, not on)


func _has_save() -> bool:
	var g: BrainFacade = Bootstrap.game
	if g and g.ready and g.has_method("has_save"):
		return g.has_save(SAVE_SLOT)
	var path := str(ProjectSettings.get_setting("miami/save_dir", "user://saves")).path_join(
		"slot_%d.json" % SAVE_SLOT
	)
	return FileAccess.file_exists(path)


func _delete_save() -> Error:
	var g: BrainFacade = Bootstrap.game
	if g and g.has_method("delete_save"):
		return g.delete_save(SAVE_SLOT)
	var path := str(ProjectSettings.get_setting("miami/save_dir", "user://saves")).path_join(
		"slot_%d.json" % SAVE_SLOT
	)
	if not FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	var d := DirAccess.open(path.get_base_dir())
	if d == null:
		return ERR_CANT_OPEN
	return d.remove(path.get_file())


func _toast_status(msg: String) -> void:
	status.text = msg


func refresh() -> void:
	var g: BrainFacade = Bootstrap.game
	var mode := "C++" if g and g.is_native else "GDScript"
	var has_save := _has_save()
	var phase := "?"
	if g and g.ready and g.has_method("get_phase"):
		phase = g.get_phase()
	if _continue_btn:
		_continue_btn.disabled = not has_save
	if _reset_btn:
		_reset_btn.disabled = not has_save
	status.text = "fase %s  ·  save %s  ·  %s" % [
		phase.to_upper(),
		"ok" if has_save else "nenhum",
		mode,
	]
