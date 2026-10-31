class_name MnRng
extends RefCounted
## RNG seedável para testes de paridade.

var _rng := RandomNumberGenerator.new()


func seed_value(s: int) -> void:
	_rng.seed = s


func randf() -> float:
	return _rng.randf()


func randi_range(a: int, b: int) -> int:
	return _rng.randi_range(a, b)


func chance(p: float) -> bool:
	return _rng.randf() < p


func pick(arr: Array):
	if arr.is_empty():
		return null
	return arr[_rng.randi_range(0, arr.size() - 1)]
