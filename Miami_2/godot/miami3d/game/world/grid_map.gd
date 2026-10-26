class_name MnGridMap
extends RefCounted
## Grade lógica do local: flags por célula, A* 8 direções, célula↔mundo.
## 1 célula = 1 unidade de mundo (metros). gx→x, gy→z.

const FLAG_BLOCKED := 1
const FLAG_NPC_ONLY := 32
const FLAG_DOOR := 4
const FLAG_INDOOR := 16
const FLAG_SHADE := 8
const FLAG_BEACH := 64
const FLAG_WATER := 128

var width: int = 0
var height: int = 0
var flags: PackedInt32Array = PackedInt32Array() # w*h
var cell_size: float = 1.0


func setup(w: int, h: int, p_cell_size: float = 1.0) -> void:
	width = w
	height = h
	cell_size = p_cell_size
	flags.resize(w * h)
	flags.fill(0)


func idx(c: Vector2i) -> int:
	return c.y * width + c.x


func in_bounds(c: Vector2i) -> bool:
	return c.x >= 0 and c.y >= 0 and c.x < width and c.y < height


func get_flags(c: Vector2i) -> int:
	return 0 if not in_bounds(c) else flags[idx(c)]


func set_flags(c: Vector2i, f: int) -> void:
	if in_bounds(c):
		flags[idx(c)] = f


func add_flags(c: Vector2i, f: int) -> void:
	if in_bounds(c):
		flags[idx(c)] = flags[idx(c)] | f


func add_rect(rect: Array, f: int) -> void:
	# rect = [x, y, w, h]
	if rect.size() < 4:
		return
	var x0 := int(rect[0])
	var y0 := int(rect[1])
	var rw := int(rect[2])
	var rh := int(rect[3])
	for y in range(y0, y0 + rh):
		for x in range(x0, x0 + rw):
			add_flags(Vector2i(x, y), f)


func is_walkable(c: Vector2i, for_npc: bool = false) -> bool:
	if not in_bounds(c):
		return false
	var f := get_flags(c)
	if f & FLAG_BLOCKED:
		return false
	if for_npc and (f & FLAG_NPC_ONLY):
		return false
	if f & FLAG_WATER:
		return false
	return true


func cell_to_world(c: Vector2i) -> Vector3:
	return Vector3((c.x + 0.5) * cell_size, 0.0, (c.y + 0.5) * cell_size)


func world_to_cell(pos: Vector3) -> Vector2i:
	return Vector2i(int(floor(pos.x / cell_size)), int(floor(pos.z / cell_size)))


## A* 8 direções; custo reto 10, diagonal 14. Bloqueia diagonal em quina.
func find_path(from: Vector2i, to: Vector2i, for_npc: bool = false) -> Array[Vector2i]:
	var empty: Array[Vector2i] = []
	if not in_bounds(from) or not in_bounds(to):
		return empty
	if not is_walkable(to, for_npc):
		to = _nearest_walkable(to, for_npc)
		if to.x < 0:
			return empty
	var open: Array = []
	var came := {}
	var gscore := {}
	var fscore := {}
	var key := func(c: Vector2i) -> String: return "%d,%d" % [c.x, c.y]
	open.append(from)
	gscore[key.call(from)] = 0
	fscore[key.call(from)] = _h(from, to)
	var dirs := [
		Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1),
	]
	var costs := [10, 10, 10, 10, 14, 14, 14, 14]
	while not open.is_empty():
		var best_i := 0
		var best_f: int = fscore.get(key.call(open[0]), 1 << 30)
		for i in range(1, open.size()):
			var fk: int = fscore.get(key.call(open[i]), 1 << 30)
			if fk < best_f:
				best_f = fk
				best_i = i
		var cur: Vector2i = open[best_i]
		open.remove_at(best_i)
		if cur == to:
			return _reconstruct(came, cur, key)
		for di in range(dirs.size()):
			var n: Vector2i = cur + dirs[di]
			if not is_walkable(n, for_npc):
				continue
			# evita atravessar quina
			if abs(dirs[di].x) + abs(dirs[di].y) == 2:
				if not is_walkable(Vector2i(cur.x + dirs[di].x, cur.y), for_npc):
					continue
				if not is_walkable(Vector2i(cur.x, cur.y + dirs[di].y), for_npc):
					continue
			var nk: String = key.call(n)
			var tg: int = int(gscore.get(key.call(cur), 0)) + costs[di]
			if tg < int(gscore.get(nk, 1 << 30)):
				came[nk] = cur
				gscore[nk] = tg
				fscore[nk] = tg + _h(n, to)
				if n not in open:
					open.append(n)
	return empty


func _h(a: Vector2i, b: Vector2i) -> int:
	return (abs(a.x - b.x) + abs(a.y - b.y)) * 10


func _reconstruct(came: Dictionary, cur: Vector2i, key: Callable) -> Array[Vector2i]:
	var path: Array[Vector2i] = [cur]
	var k: String = key.call(cur)
	while came.has(k):
		cur = came[k]
		path.push_front(cur)
		k = key.call(cur)
	return path


func _nearest_walkable(c: Vector2i, for_npc: bool) -> Vector2i:
	if is_walkable(c, for_npc):
		return c
	for r in range(1, 8):
		for dy in range(-r, r + 1):
			for dx in range(-r, r + 1):
				var n := Vector2i(c.x + dx, c.y + dy)
				if is_walkable(n, for_npc):
					return n
	return Vector2i(-1, -1)
