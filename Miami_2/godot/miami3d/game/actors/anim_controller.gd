class_name MnAnimController
extends Node
## Animações procedurais alinhadas a MnAnimationMap (enquanto anims_human.glb é placeholder).

signal clip_changed(clip: String)

var target: Node3D
var current_clip: String = "idle"
var _t: float = 0.0
var _base_pos: Vector3 = Vector3.ZERO
var _base_rot: Vector3 = Vector3.ZERO
var _base_scale: Vector3 = Vector3.ONE
var _gender: String = "m"
var _on_face: Callable = Callable()


func bind(doll: Node3D, gender: String = "m") -> void:
	target = doll
	_gender = gender
	if target:
		_base_pos = target.position
		_base_rot = target.rotation
		_base_scale = target.scale


func set_face_callback(cb: Callable) -> void:
	_on_face = cb


func play(logic_or_clip: String) -> void:
	var clip := MnAnimationMap.clip_for(logic_or_clip)
	if clip == current_clip:
		return
	current_clip = clip
	_t = 0.0
	clip_changed.emit(clip)
	if _on_face.is_valid():
		_on_face.call(MnNeonStyle.face_for_anim(clip))


func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return
	_t += delta
	var bob := 0.0
	var sway := 0.0
	var lean := 0.0
	var spin := 0.0
	var squash := 1.0
	var tip := 0.0
	match current_clip:
		"idle":
			bob = sin(_t * 2.2) * 0.015
			sway = sin(_t * 1.1) * 0.03
		"walk":
			bob = absf(sin(_t * 8.0)) * 0.05
			sway = sin(_t * 8.0) * 0.08
			lean = 0.05
		"run":
			bob = absf(sin(_t * 12.0)) * 0.08
			sway = sin(_t * 12.0) * 0.12
			lean = 0.12
		"dance_techno":
			bob = absf(sin(_t * 10.0)) * 0.1
			sway = sin(_t * 14.0) * 0.2
			spin = sin(_t * 3.0) * 0.25
		"dance_salsa":
			bob = sin(_t * 6.0) * 0.06
			sway = sin(_t * 6.0) * 0.28
			spin = sin(_t * 2.0) * 0.35
		"dance_pop":
			bob = absf(sin(_t * 7.0)) * 0.07
			sway = cos(_t * 7.0) * 0.18
		"dance_metal":
			bob = absf(sin(_t * 11.0)) * 0.12
			sway = sin(_t * 16.0) * 0.22
			lean = sin(_t * 8.0) * 0.15
		"sit", "sunbathe", "relax":
			bob = -0.35
			squash = 0.85
		"sleep", "nap":
			bob = -0.55
			tip = 1.2
			squash = 0.7
		"fight":
			sway = sin(_t * 20.0) * 0.15
			lean = sin(_t * 10.0) * 0.2
		"faint":
			tip = 1.45
			bob = -0.2
		"swim":
			bob = sin(_t * 4.0) * 0.08
			sway = sin(_t * 3.0) * 0.1
		"kiss":
			lean = 0.2
			bob = sin(_t * 3.0) * 0.02
		"talk", "laugh", "angry", "wave":
			bob = sin(_t * 3.5) * 0.02
			sway = sin(_t * 5.0) * 0.05
		"lift", "sweep", "cook", "work_bar", "work_poster", "work_delivery", "work_extra", "use", "give", "piano":
			bob = absf(sin(_t * 5.0)) * 0.04
			sway = sin(_t * 5.0) * 0.06
		"eat", "drink", "shower", "pee":
			bob = sin(_t * 2.5) * 0.02
		_:
			bob = sin(_t * 2.0) * 0.01
	target.position = _base_pos + Vector3(0, bob, 0)
	target.rotation = Vector3(
		_base_rot.x + lean,
		_base_rot.y + sway * 0.35 + spin,
		_base_rot.z + tip * 0.15 + sway * 0.05
	)
	target.scale = Vector3(_base_scale.x, _base_scale.y * squash, _base_scale.z)
	# balanço de braços 3D
	var arm_l := target.get_node_or_null("ArmL") as Node3D
	var arm_r := target.get_node_or_null("ArmR") as Node3D
	var swing := 0.0
	if current_clip in ["walk", "run"]:
		swing = sin(_t * (10.0 if current_clip == "run" else 7.0)) * (0.55 if current_clip == "run" else 0.35)
	elif current_clip.begins_with("dance"):
		swing = sin(_t * 9.0) * 0.7
	if arm_l:
		arm_l.rotation.x = swing
	if arm_r:
		arm_r.rotation.x = -swing
