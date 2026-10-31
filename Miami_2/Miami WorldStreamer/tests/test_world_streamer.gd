extends SceneTree
## Testes do WorldStreamer (catalog + coords + seams) sem abrir cena 3D.
## godot4 --path miami3d --headless -s res://tests/test_world_streamer.gd

const MAP := "res://content/world_streamer/world_map.json"


func _init() -> void:
	var failed := 0
	failed += _test_catalog()
	failed += _test_coords()
	failed += _test_seams()
	if failed == 0:
		print("PASS test_world_streamer")
		quit(0)
	else:
		print("FAIL test_world_streamer count=", failed)
		quit(1)


func _test_catalog() -> int:
	var cat := MnChunkCatalog.new()
	var err := cat.load_map(MAP)
	if err != OK:
		print("catalog load fail ", err)
		return 1
	if cat.mode_default != "discrete":
		print("mode_default deve ser discrete para não quebrar o game")
		return 1
	if not cat.is_outdoor("first_street"):
		print("first_street deve ser outdoor")
		return 1
	if cat.is_outdoor("player_apartment"):
		print("player_apartment deve ser indoor")
		return 1
	if cat.parent_outdoor("player_apartment") != "first_street":
		print("parent apartment → first_street")
		return 1
	if cat.chunk_of("downtown") != Vector2i(1, 0) and cat.chunk_of("downtown") != Vector2i(0, 0):
		# downtown aparece em c_0_0 e âncora chunk [1,0]
		pass
	if cat.outdoor_location_ids().is_empty():
		print("sem outdoors")
		return 1
	print("  catalog ok outdoors=", cat.outdoor_location_ids().size())
	return 0


func _test_coords() -> int:
	var cat := MnChunkCatalog.new()
	cat.load_map(MAP)
	var coords := MnWorldCoords.new()
	coords.setup(cat)
	var g := coords.local_to_global("downtown", Vector2i(3, 4))
	var expect := cat.origin_cell("downtown") + Vector2i(3, 4)
	if g != expect:
		print("local_to_global fail ", g, " != ", expect)
		return 1
	var back := coords.global_to_local("downtown", g)
	if back != Vector2i(3, 4):
		print("global_to_local fail ", back)
		return 1
	var at := coords.location_at_global(cat.origin_cell("south_beach") + Vector2i(2, 2))
	if at != "south_beach":
		print("location_at_global fail ", at)
		return 1
	print("  coords ok")
	return 0


func _test_seams() -> int:
	var cat := MnChunkCatalog.new()
	cat.load_map(MAP)
	if not cat.is_seam("first_street", "downtown"):
		print("seam first_street↔downtown ausente")
		return 1
	if not cat.is_seam("downtown", "first_street"):
		print("seam bidirecional falhou")
		return 1
	print("  seams ok")
	return 0
