class_name MnToast
extends Control
## Toast ATENÇÃO / DICA / MISSÃO — reação a `notify` e missões.

enum Kind { ATTENTION, TIP, QUEST, DEFAULT }

@onready var panel: PanelContainer = $Panel
@onready var kind_l: Label = $Panel/Margin/HBox/Kind
@onready var body_l: Label = $Panel/Margin/HBox/Body

var _queue: Array[Dictionary] = []
var _busy: bool = false
var _tween: Tween


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if panel:
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE


func push(text: String, kind: Kind = Kind.DEFAULT) -> void:
	_queue.append({"text": text, "kind": kind})
	if not _busy:
		_next()


func push_key(key: String, kind: Kind = Kind.DEFAULT) -> void:
	var t := Bootstrap.game.resolve_text(key) if Bootstrap.game else key
	push(t, kind)


func classify_key(key: String) -> Kind:
	var k := key.to_lower()
	if "quest" in k or "missão" in k or "missao" in k:
		return Kind.QUEST
	if "tip" in k or "dica" in k or "hint" in k:
		return Kind.TIP
	if "warn" in k or "attention" in k or "aten" in k or "collapse" in k or "arrest" in k:
		return Kind.ATTENTION
	return Kind.DEFAULT


func _next() -> void:
	if _queue.is_empty():
		_busy = false
		visible = false
		return
	_busy = true
	var item: Dictionary = _queue.pop_front()
	var kind: Kind = item.get("kind", Kind.DEFAULT)
	match kind:
		Kind.ATTENTION:
			kind_l.text = "ATENÇÃO"
			_set_tint(Color(0.92, 0.35, 0.28))
		Kind.TIP:
			kind_l.text = "DICA"
			_set_tint(Color(0.25, 0.65, 0.85))
		Kind.QUEST:
			kind_l.text = "MISSÃO"
			_set_tint(Color(0.95, 0.72, 0.2))
		_:
			kind_l.text = ""
			_set_tint(Color(0.18, 0.18, 0.22))
	body_l.text = str(item.get("text", ""))
	visible = true
	modulate.a = 0.0
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 1.0, 0.18)
	_tween.tween_interval(2.4)
	_tween.tween_property(self, "modulate:a", 0.0, 0.35)
	_tween.tween_callback(_next)


func _set_tint(c: Color) -> void:
	if panel == null:
		return
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(c.r, c.g, c.b, 0.92)
	sb.corner_radius_top_left = 6
	sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_left = 6
	sb.corner_radius_bottom_right = 6
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", sb)
