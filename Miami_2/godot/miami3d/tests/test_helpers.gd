class_name MnTestHelpers
extends RefCounted
## Helpers mínimos estilo GUT para scripts SceneTree headless.

static var failed: int = 0
static var passed: int = 0


static func reset() -> void:
	failed = 0
	passed = 0


static func assert_true(cond: bool, msg: String = "") -> void:
	if cond:
		passed += 1
	else:
		failed += 1
		push_error("ASSERT FAIL: " + msg)
		print("ASSERT FAIL: ", msg)


static func assert_eq(a, b, msg: String = "") -> void:
	assert_true(a == b, "%s (got %s expected %s)" % [msg, str(a), str(b)])


static func assert_gt(a, b, msg: String = "") -> void:
	assert_true(a > b, "%s (got %s > %s?)" % [msg, str(a), str(b)])


static func assert_ge(a, b, msg: String = "") -> void:
	assert_true(a >= b, "%s (got %s >= %s?)" % [msg, str(a), str(b)])


static func summary(suite: String) -> int:
	print("%s: %d passed, %d failed" % [suite, passed, failed])
	return failed
