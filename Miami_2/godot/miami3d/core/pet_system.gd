class_name MnPetSystem
extends RefCounted
## Cão (3 raças) + gato: fome, carinho, treino.

var pets: Dictionary = {} # id -> {kind, breed, hunger, trained_sit}


func add_pet(pet_id: String, kind: String, breed: String = "") -> void:
	pets[pet_id] = {"kind": kind, "breed": breed, "hunger": 20, "trained_sit": false, "bond": 0}


func feed(pet_id: String) -> void:
	if not pets.has(pet_id):
		return
	pets[pet_id]["hunger"] = maxi(0, int(pets[pet_id]["hunger"]) - 40)
	pets[pet_id]["bond"] = int(pets[pet_id]["bond"]) + 2


func play(pet_id: String) -> void:
	if not pets.has(pet_id):
		return
	pets[pet_id]["bond"] = int(pets[pet_id]["bond"]) + 3
	pets[pet_id]["hunger"] = mini(100, int(pets[pet_id]["hunger"]) + 5)


func train_sit(pet_id: String) -> void:
	if not pets.has(pet_id):
		return
	pets[pet_id]["trained_sit"] = true
	pets[pet_id]["bond"] = int(pets[pet_id]["bond"]) + 5


func on_hour_tick() -> void:
	for id in pets.keys():
		pets[id]["hunger"] = mini(100, int(pets[id]["hunger"]) + 2)


func to_dict() -> Dictionary:
	return pets.duplicate(true)


func from_dict(d: Dictionary) -> void:
	pets = d.duplicate(true)
