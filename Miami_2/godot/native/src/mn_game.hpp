#pragma once
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/packed_string_array.hpp>
#include <godot_cpp/variant/vector2i.hpp>

namespace godot {

/// Cérebro operacional Miami 3D (C++ / GDExtension).
/// Espelha miami3d/core/*.gd — use a partir de GDScript: MnBrain.new()
class MnBrain : public RefCounted {
	GDCLASS(MnBrain, RefCounted);

protected:
	static void _bind_methods();

public:
	MnBrain();
	~MnBrain() override = default;

	// --- boot / tick ---
	Error boot(const String &content_dir = "res://content", const String &save_dir = "user://saves");
	void new_game(const String &player_name = "Você", const String &gender = "m");
	void tick_real(double delta_s);
	bool is_ready() const { return ready; }

	// --- mundo / ações ---
	void enter_location(const String &location_id, const String &spawn_id = "");
	Dictionary interact(const String &object_id, const String &action_id);
	Dictionary talk(const String &npc_id, const String &action_id, const Dictionary &payload = Dictionary());

	// --- consulta ---
	String resolve_text(const String &key, const Dictionary &ctx = Dictionary()) const;
	int get_stat(const String &stat_id) const;
	void apply_stat_delta(const String &stat_id, int delta);
	int get_cash() const;
	int get_bank() const;
	void add_cash(int n);
	String get_location() const;
	Vector2i get_cell() const;
	int get_day() const;
	int get_minute_of_day() const;
	int get_hour() const;
	bool has_flag(const String &flag) const;
	void set_flag(const String &flag, bool value = true);
	String get_quest_stage(const String &quest_id) const;
	bool is_quest_active(const String &quest_id) const;
	Dictionary snapshot() const; // debug / HUD

	// --- save ---
	Error save_game(int slot = 0);
	Error load_game(int slot = 0);

	// --- tempo ---
	void set_paused(bool p);
	bool get_paused() const;
	void advance_minutes(int n);

private:
	bool ready = false;
	bool paused = false;
	double seconds_per_minute = 1.0;
	double accum = 0.0;
	int day = 0;
	int minute_of_day = 8 * 60;

	String content_dir;
	String save_dir;
	String player_name = "Você";
	String player_gender = "m";
	String location_id;
	String spawn_id;
	Vector2i cell;
	String facing = "S";

	Dictionary pack;
	Dictionary stats_cfg;
	Dictionary strings;
	Dictionary locations;
	Dictionary npcs;
	Dictionary items;
	Dictionary interactions;
	Dictionary quests_def;
	Dictionary jobs_def;

	Dictionary values; // stats
	Dictionary inventory;
	Dictionary flags;
	Dictionary unlocked;
	Dictionary achievements;
	Dictionary npc_states; // id -> {friendship,romance,mood,...}
	Dictionary quests_active; // id -> {stage, vars}
	Dictionary home_slots;
	Dictionary pets;

	int cash = 0;
	int bank = 0;
	bool rent_paid = false;
	bool in_jail = false;
	int jail_minutes = 0;
	int arrest_at = 80;

	Dictionary appearance; // name, gender, vector

	void _load_folder(const String &folder, Dictionary &into);
	Dictionary _read_dict(const String &path) const;
	Variant _read_any(const String &path) const;

	void _emit_minute();
	void _on_hour();
	void _on_day();
	void _recompute_derived();
	void _check_warnings(const String &stat_id);
	void _check_collapse(const String &stat_id);
	int _stat_level(const String &stat_id) const;
	Dictionary _stat_def(const String &stat_id) const;

	bool _eval(const Variant &cond, const Dictionary &ctx) const;
	bool _eval_key(const String &key, const Variant &val, const Dictionary &ctx) const;
	void _run(const Array &actions, const Dictionary &ctx);
	void _run_one(const Dictionary &a, const Dictionary &ctx);

	void _fire_triggers(const String &on, const String &object_id = "", const String &npc_id = "");
	void _quest_notify(const Dictionary &ev);
	void _quest_enter(const String &qid, const String &stage);
	void _ensure_npc(const String &npc_id);

	String _strip_key(const String &key) const;
	String _save_path(int slot) const;
};

} // namespace godot
