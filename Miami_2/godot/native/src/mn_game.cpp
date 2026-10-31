#include "mn_game.hpp"
#include "mn_json.hpp"
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/dir_access.hpp>
#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>

using namespace godot;
using miami::clampi;
using miami::cmp_int;

void MnBrain::_bind_methods() {
	ClassDB::bind_method(D_METHOD("boot", "content_dir", "save_dir"), &MnBrain::boot, DEFVAL("res://content"), DEFVAL("user://saves"));
	ClassDB::bind_method(D_METHOD("new_game", "player_name", "gender"), &MnBrain::new_game, DEFVAL("Você"), DEFVAL("m"));
	ClassDB::bind_method(D_METHOD("tick_real", "delta_s"), &MnBrain::tick_real);
	ClassDB::bind_method(D_METHOD("is_ready"), &MnBrain::is_ready);

	ClassDB::bind_method(D_METHOD("enter_location", "location_id", "spawn_id"), &MnBrain::enter_location, DEFVAL(""));
	ClassDB::bind_method(D_METHOD("interact", "object_id", "action_id"), &MnBrain::interact);
	ClassDB::bind_method(D_METHOD("talk", "npc_id", "action_id", "payload"), &MnBrain::talk, DEFVAL(Dictionary()));

	ClassDB::bind_method(D_METHOD("resolve_text", "key", "ctx"), &MnBrain::resolve_text, DEFVAL(Dictionary()));
	ClassDB::bind_method(D_METHOD("get_stat", "stat_id"), &MnBrain::get_stat);
	ClassDB::bind_method(D_METHOD("apply_stat_delta", "stat_id", "delta"), &MnBrain::apply_stat_delta);
	ClassDB::bind_method(D_METHOD("get_cash"), &MnBrain::get_cash);
	ClassDB::bind_method(D_METHOD("get_bank"), &MnBrain::get_bank);
	ClassDB::bind_method(D_METHOD("add_cash", "n"), &MnBrain::add_cash);
	ClassDB::bind_method(D_METHOD("get_location"), &MnBrain::get_location);
	ClassDB::bind_method(D_METHOD("get_cell"), &MnBrain::get_cell);
	ClassDB::bind_method(D_METHOD("get_day"), &MnBrain::get_day);
	ClassDB::bind_method(D_METHOD("get_minute_of_day"), &MnBrain::get_minute_of_day);
	ClassDB::bind_method(D_METHOD("get_hour"), &MnBrain::get_hour);
	ClassDB::bind_method(D_METHOD("has_flag", "flag"), &MnBrain::has_flag);
	ClassDB::bind_method(D_METHOD("set_flag", "flag", "value"), &MnBrain::set_flag, DEFVAL(true));
	ClassDB::bind_method(D_METHOD("get_quest_stage", "quest_id"), &MnBrain::get_quest_stage);
	ClassDB::bind_method(D_METHOD("is_quest_active", "quest_id"), &MnBrain::is_quest_active);
	ClassDB::bind_method(D_METHOD("snapshot"), &MnBrain::snapshot);

	ClassDB::bind_method(D_METHOD("save_game", "slot"), &MnBrain::save_game, DEFVAL(0));
	ClassDB::bind_method(D_METHOD("load_game", "slot"), &MnBrain::load_game, DEFVAL(0));
	ClassDB::bind_method(D_METHOD("set_paused", "p"), &MnBrain::set_paused);
	ClassDB::bind_method(D_METHOD("get_paused"), &MnBrain::get_paused);
	ClassDB::bind_method(D_METHOD("advance_minutes", "n"), &MnBrain::advance_minutes);

	ADD_SIGNAL(MethodInfo("minute_tick", PropertyInfo(Variant::INT, "minute_of_day"), PropertyInfo(Variant::INT, "day")));
	ADD_SIGNAL(MethodInfo("hour_tick", PropertyInfo(Variant::INT, "hour"), PropertyInfo(Variant::INT, "day")));
	ADD_SIGNAL(MethodInfo("day_tick", PropertyInfo(Variant::INT, "day")));
	ADD_SIGNAL(MethodInfo("stat_changed", PropertyInfo(Variant::STRING, "stat_id"), PropertyInfo(Variant::INT, "value"), PropertyInfo(Variant::INT, "level")));
	ADD_SIGNAL(MethodInfo("warning", PropertyInfo(Variant::STRING, "stat_id"), PropertyInfo(Variant::STRING, "text_key")));
	ADD_SIGNAL(MethodInfo("collapse", PropertyInfo(Variant::STRING, "stat_id"), PropertyInfo(Variant::STRING, "text_key")));
	ADD_SIGNAL(MethodInfo("notify", PropertyInfo(Variant::STRING, "text_key")));
	ADD_SIGNAL(MethodInfo("dialogue_requested", PropertyInfo(Variant::DICTIONARY, "payload")));
	ADD_SIGNAL(MethodInfo("quest_stage_entered", PropertyInfo(Variant::STRING, "quest_id"), PropertyInfo(Variant::STRING, "stage_id")));
	ADD_SIGNAL(MethodInfo("quest_completed", PropertyInfo(Variant::STRING, "quest_id")));
	ADD_SIGNAL(MethodInfo("teleport", PropertyInfo(Variant::STRING, "location_id"), PropertyInfo(Variant::STRING, "spawn_id")));
	ADD_SIGNAL(MethodInfo("location_changed", PropertyInfo(Variant::STRING, "location_id")));
	ADD_SIGNAL(MethodInfo("money_changed", PropertyInfo(Variant::INT, "cash"), PropertyInfo(Variant::INT, "bank")));
}

MnBrain::MnBrain() {
	appearance["name"] = "Você";
	appearance["gender"] = "m";
	Array vec;
	for (int i = 0; i < 10; i++) vec.push_back(0);
	appearance["appearance"] = vec;
}

Error MnBrain::boot(const String &p_content_dir, const String &p_save_dir) {
	content_dir = p_content_dir;
	save_dir = p_save_dir;
	DirAccess::make_dir_recursive_absolute(save_dir);

	pack = _read_dict(content_dir.path_join("pack.json"));
	stats_cfg = _read_dict(content_dir.path_join("stats.json"));
	String locale = pack.get("locale", "pt-BR");
	strings = _read_dict(content_dir.path_join(String("strings/") + locale + ".json"));
	_load_folder("locations", locations);
	_load_folder("npcs", npcs);
	_load_folder("items", items);
	_load_folder("interactions", interactions);
	_load_folder("quests", quests_def);
	_load_folder("jobs", jobs_def);

	seconds_per_minute = (double)stats_cfg.get("timeScaleSecondsPerMinute", 1.0);
	arrest_at = (int)stats_cfg.get("arrestAtCrime", 80);

	values.clear();
	Array defs = stats_cfg.get("stats", Array());
	for (int i = 0; i < defs.size(); i++) {
		Dictionary d = defs[i];
		values[String(d.get("id", ""))] = (int)d.get("initial", 0);
	}
	_recompute_derived();

	UtilityFunctions::print(String("[MnBrain/C++] pack=") + String(pack.get("id", "?")) +
			" locs=" + String::num_int64(locations.size()) +
			" acts=" + String::num_int64(interactions.size()) +
			" quests=" + String::num_int64(quests_def.size()));
	ready = true;
	return OK;
}

void MnBrain::new_game(const String &p_name, const String &gender) {
	player_name = p_name;
	player_gender = gender;
	appearance["name"] = p_name;
	appearance["gender"] = gender;
	cash = 0;
	bank = 0;
	day = 0;
	minute_of_day = 8 * 60;
	flags.clear();
	quests_active.clear();
	inventory.clear();
	Array defs = stats_cfg.get("stats", Array());
	values.clear();
	for (int i = 0; i < defs.size(); i++) {
		Dictionary d = defs[i];
		values[String(d.get("id", ""))] = (int)d.get("initial", 0);
	}
	_recompute_derived();
	if (locations.has("player_apartment")) {
		enter_location("player_apartment", "from_street");
	} else if (locations.has("first_street")) {
		enter_location("first_street", "");
	}
}

void MnBrain::tick_real(double delta_s) {
	if (!ready || paused || seconds_per_minute <= 0.0) return;
	accum += delta_s;
	while (accum >= seconds_per_minute) {
		accum -= seconds_per_minute;
		advance_minutes(1);
	}
}

void MnBrain::advance_minutes(int n) {
	if (n <= 0) return;
	for (int i = 0; i < n; i++) {
		minute_of_day++;
		if (minute_of_day >= 1440) {
			minute_of_day = 0;
			day++;
			_on_day();
			emit_signal("day_tick", day);
		}
		_emit_minute();
		emit_signal("minute_tick", minute_of_day, day);
		if (minute_of_day % 60 == 0) {
			_on_hour();
			emit_signal("hour_tick", get_hour(), day);
		}
	}
}

void MnBrain::_emit_minute() {
	if (in_jail) {
		jail_minutes++;
		if (jail_minutes % 60 == 0) apply_stat_delta("crime", -1);
	}
	// triggers periódicos
	if (!locations.has(location_id)) return;
	Dictionary loc = locations[location_id];
	Array triggers = loc.get("triggers", Array());
	for (int i = 0; i < triggers.size(); i++) {
		Dictionary t = triggers[i];
		if (String(t.get("on", "")) != "periodic") continue;
		int every = (int)t.get("everyMinutes", 5);
		if (every > 0 && (minute_of_day % every) == 0) {
			Dictionary ctx;
			ctx["location"] = location_id;
			if (_eval(t.get("when", Dictionary()), ctx)) {
				_run(t.get("do", Array()), ctx);
			}
		}
	}
}

void MnBrain::_on_hour() {
	Array defs = stats_cfg.get("stats", Array());
	for (int i = 0; i < defs.size(); i++) {
		Dictionary d = defs[i];
		if (String(d.get("kind", "")) == "derived") continue;
		double per = (double)d.get("perHour", 0.0);
		if (per == 0.0) continue;
		String id = d.get("id", "");
		int nv = get_stat(id) + (int)std::round(per);
		if (d.has("floor")) nv = (int)std::max((double)nv, (double)d["floor"]);
		apply_stat_delta(id, nv - get_stat(id));
	}
	_recompute_derived();
	// NPC mood decay
	Array keys = npc_states.keys();
	for (int i = 0; i < keys.size(); i++) {
		Dictionary s = npc_states[keys[i]];
		int mood = (int)s.get("mood", 50);
		if (mood > 50) mood = std::max(50, mood - 2);
		else if (mood < 50) mood = std::min(50, mood + 1);
		s["mood"] = mood;
		int romance = (int)s.get("romance", 0);
		if (romance > 0) s["romance"] = romance - 1;
		npc_states[keys[i]] = s;
	}
}

void MnBrain::_on_day() {
	if (bank > 0) {
		bank += std::max(1, (int)std::round(bank * 0.01));
		emit_signal("money_changed", cash, bank);
	}
	if (day > 0 && (day % 7) == 0) rent_paid = false;
	Array keys = npc_states.keys();
	for (int i = 0; i < keys.size(); i++) {
		Dictionary s = npc_states[keys[i]];
		s["interactions_today"] = 0;
		s["gifts_today"] = 0;
		npc_states[keys[i]] = s;
	}
}

void MnBrain::enter_location(const String &loc_id, const String &p_spawn) {
	if (!locations.has(loc_id)) {
		UtilityFunctions::push_warning("local desconhecido: " + loc_id);
		return;
	}
	Dictionary loc = locations[loc_id];
	Array oh = loc.get("openHours", Array());
	if (oh.size() >= 2) {
		double a = oh[0], b = oh[1];
		double h = (double)get_hour() + (minute_of_day % 60) / 60.0;
		bool open = (a == 0.0 && b == 24.0) || (a <= b ? (h >= a && h < b) : (h >= a || h < b));
		if (!open) {
			emit_signal("notify", "@msg.closed");
			return;
		}
	}
	if (loc.has("lockedUntil") && !has_flag(loc["lockedUntil"])) {
		emit_signal("notify", loc.get("closedMessage", "@msg.locked"));
		return;
	}
	location_id = loc_id;
	spawn_id = p_spawn;
	if (p_spawn.is_empty() && loc.has("spawn")) {
		Dictionary sp = loc["spawn"];
		Array c = sp.get("cell", Array());
		if (c.size() >= 2) cell = Vector2i((int)c[0], (int)c[1]);
		facing = sp.get("facing", "S");
	} else if (!p_spawn.is_empty() && loc.has("spawns")) {
		Dictionary sps = loc["spawns"];
		if (sps.has(p_spawn)) {
			Dictionary sp = sps[p_spawn];
			Array c = sp.get("cell", Array());
			if (c.size() >= 2) cell = Vector2i((int)c[0], (int)c[1]);
			facing = sp.get("facing", "S");
		}
	}
	emit_signal("location_changed", location_id);
	_fire_triggers("enter");
	Dictionary ev;
	ev["event"] = "entered";
	ev["location"] = loc_id;
	_quest_notify(ev);
}

Dictionary MnBrain::interact(const String &object_id, const String &action_id) {
	Dictionary out;
	out["ok"] = false;
	if (!interactions.has(action_id)) {
		out["reason"] = "unknown_action";
		return out;
	}
	Dictionary action = interactions[action_id];
	Dictionary ctx;
	ctx["object"] = object_id;
	ctx["action"] = action_id;
	if (!_eval(action.get("requires", Dictionary()), ctx)) {
		String fail = Dictionary(action.get("reactions", Dictionary())).get("fail", "");
		if (!fail.is_empty()) emit_signal("notify", fail);
		out["reason"] = "requires";
		return out;
	}
	int price = (int)action.get("price", 0);
	if (price > 0) {
		if (cash < price) {
			emit_signal("notify", "@msg.no_money");
			out["reason"] = "money";
			return out;
		}
		cash -= price;
		emit_signal("money_changed", cash, bank);
	}
	if (action.has("requiresItem")) {
		String iid = action["requiresItem"];
		int n = (int)inventory.get(iid, 0);
		if (n <= 0) {
			out["reason"] = "item";
			return out;
		}
		if ((bool)action.get("consumesItem", false)) {
			if (n <= 1) inventory.erase(iid);
			else inventory[iid] = n - 1;
		}
	}
	Array effects = action.get("effects", Array());
	for (int i = 0; i < effects.size(); i++) {
		Dictionary e = effects[i];
		apply_stat_delta(e.get("stat", ""), (int)std::round((double)e.get("delta", 0)));
	}
	_recompute_derived();
	if ((bool)action.get("advancesTime", false)) {
		int dur = (int)action.get("durationMinutes", 0);
		if (dur > 0) advance_minutes(dur);
	}
	if (action.has("crime")) {
		apply_stat_delta("crime", (int)action["crime"]);
		if (get_stat("crime") >= arrest_at) {
			in_jail = true;
			jail_minutes = 0;
			emit_signal("notify", "@warn.arrest");
			emit_signal("teleport", "police_station", "cell");
		}
	}
	if (action.has("then")) _run(action["then"], ctx);
	String ev_name = action.get("event", "used_object");
	Dictionary ev;
	ev["event"] = ev_name;
	ev["object"] = object_id;
	ev["action"] = action_id;
	_quest_notify(ev);
	_fire_triggers("use", object_id);
	out["ok"] = true;
	out["action"] = action_id;
	return out;
}

Dictionary MnBrain::talk(const String &npc_id, const String &action_id, const Dictionary &payload) {
	_ensure_npc(npc_id);
	Dictionary out;
	if (action_id == "topic" && payload.has("interest")) {
		Dictionary s = npc_states[npc_id];
		String interest = payload["interest"];
		Array likes = s.get("likes", Array());
		Array dislikes = s.get("dislikes", Array());
		int fri = 2, mood = 0;
		String polar = "neutral";
		if (likes.has(interest)) { fri = 8; mood = 10; polar = "like"; }
		else if (dislikes.has(interest)) { fri = -10; mood = -15; polar = "dislike"; }
		s["friendship"] = clampi((int)s.get("friendship", 0) + fri, -100, 100);
		s["mood"] = clampi((int)s.get("mood", 50) + mood, 0, 100);
		s["interactions_today"] = (int)s.get("interactions_today", 0) + 1;
		npc_states[npc_id] = s;
		Dictionary dlg;
		dlg["npc"] = npc_id;
		dlg["polarity"] = polar;
		emit_signal("dialogue_requested", dlg);
		Dictionary ev;
		ev["event"] = "talked_to";
		ev["npc"] = npc_id;
		_quest_notify(ev);
		_fire_triggers("talk", "", npc_id);
		out["ok"] = true;
		out["polarity"] = polar;
		return out;
	}
	if (!interactions.has(action_id)) {
		out["ok"] = false;
		return out;
	}
	Dictionary action = interactions[action_id];
	Dictionary ctx;
	ctx["npc"] = npc_id;
	if (!_eval(action.get("requires", Dictionary()), ctx)) {
		out["ok"] = false;
		out["reason"] = "requires";
		return out;
	}
	Dictionary rel = action.get("relationship", Dictionary());
	Dictionary s = npc_states[npc_id];
	int after = (int)action.get("diminishingAfter", 99);
	int fri = (int)rel.get("friendship", 0);
	int rom = (int)rel.get("romance", 0);
	int mood = (int)rel.get("mood", 0);
	if ((int)s.get("interactions_today", 0) >= after) {
		fri = std::min(fri, 1);
		rom = std::min(rom, 0);
	}
	s["friendship"] = clampi((int)s.get("friendship", 0) + fri, -100, 100);
	s["romance"] = clampi((int)s.get("romance", 0) + rom, 0, 100);
	s["mood"] = clampi((int)s.get("mood", 50) + mood, 0, 100);
	s["interactions_today"] = (int)s.get("interactions_today", 0) + 1;
	npc_states[npc_id] = s;
	Array effects = action.get("effects", Array());
	for (int i = 0; i < effects.size(); i++) {
		Dictionary e = effects[i];
		apply_stat_delta(e.get("stat", ""), (int)std::round((double)e.get("delta", 0)));
	}
	if (action.has("then")) _run(action["then"], ctx);
	Dictionary ev;
	ev["event"] = "talked_to";
	ev["npc"] = npc_id;
	_quest_notify(ev);
	_fire_triggers("talk", "", npc_id);
	out["ok"] = true;
	return out;
}

// ---- stats / economy helpers ----

int MnBrain::get_stat(const String &stat_id) const { return (int)values.get(stat_id, 0); }

void MnBrain::apply_stat_delta(const String &stat_id, int delta) {
	if (stat_id.is_empty()) return;
	int v = clampi(get_stat(stat_id) + delta, 0, 100);
	if (v == get_stat(stat_id)) return;
	values[stat_id] = v;
	emit_signal("stat_changed", stat_id, v, _stat_level(stat_id));
	_check_warnings(stat_id);
	_check_collapse(stat_id);
}

void MnBrain::_recompute_derived() {
	int mood = (int)std::round(((100 - get_stat("hunger")) + (100 - get_stat("sleep")) + get_stat("hygiene") + (100 - get_stat("bladder"))) / 4.0);
	values["mood"] = clampi(mood, 0, 100);
	int friends = 0;
	Array keys = npc_states.keys();
	for (int i = 0; i < keys.size(); i++) {
		Dictionary s = npc_states[keys[i]];
		int f = clampi((int)s.get("friendship", 0), 0, 100);
		if ((f / 20) >= 2) friends++;
	}
	values["social"] = clampi(friends * 10, 0, 100);
}

Dictionary MnBrain::_stat_def(const String &stat_id) const {
	Array defs = stats_cfg.get("stats", Array());
	for (int i = 0; i < defs.size(); i++) {
		Dictionary d = defs[i];
		if (String(d.get("id", "")) == stat_id) return d;
	}
	return Dictionary();
}

int MnBrain::_stat_level(const String &stat_id) const {
	Dictionary d = _stat_def(stat_id);
	Array th = d.get("thresholds", Array());
	if (th.is_empty()) return 0;
	int v = get_stat(stat_id);
	bool worse = (bool)d.get("higherIsWorse", false);
	for (int i = 0; i < th.size(); i++) {
		if (worse) { if (v <= (int)th[i]) return i; }
		else { if (v < (int)th[i]) return i; }
	}
	return std::min(4, (int)th.size() - 1);
}

void MnBrain::_check_warnings(const String &stat_id) {
	Dictionary d = _stat_def(stat_id);
	int v = get_stat(stat_id);
	bool worse = (bool)d.get("higherIsWorse", false);
	Array warnings = d.get("warnings", Array());
	for (int i = 0; i < warnings.size(); i++) {
		Dictionary w = warnings[i];
		int at = (int)w.get("at", -1);
		bool hit = worse ? (v >= at) : (v <= at);
		String key = String("warn_") + stat_id + "_" + String::num_int64(at);
		if (hit && !has_flag(key)) {
			set_flag(key, true);
			emit_signal("warning", stat_id, w.get("text", ""));
		}
	}
}

void MnBrain::_check_collapse(const String &stat_id) {
	Dictionary d = _stat_def(stat_id);
	if (!d.has("collapse")) return;
	Dictionary c = d["collapse"];
	int at = (int)c.get("at", 100);
	int v = get_stat(stat_id);
	bool worse = (bool)d.get("higherIsWorse", false);
	bool hit = worse ? (v >= at) : (v <= at);
	String key = String("collapse_") + stat_id;
	if (hit && !has_flag(key)) {
		set_flag(key, true);
		emit_signal("collapse", stat_id, c.get("text", ""));
		_run(c.get("do", Array()), Dictionary());
	} else if (!hit && has_flag(key)) {
		set_flag(key, false);
	}
}

int MnBrain::get_cash() const { return cash; }
int MnBrain::get_bank() const { return bank; }
void MnBrain::add_cash(int n) {
	cash = std::max(0, cash + n);
	emit_signal("money_changed", cash, bank);
}
String MnBrain::get_location() const { return location_id; }
Vector2i MnBrain::get_cell() const { return cell; }
int MnBrain::get_day() const { return day; }
int MnBrain::get_minute_of_day() const { return minute_of_day; }
int MnBrain::get_hour() const { return minute_of_day / 60; }
bool MnBrain::has_flag(const String &flag) const { return (bool)flags.get(flag, false); }
void MnBrain::set_flag(const String &flag, bool value) { flags[flag] = value; }
String MnBrain::get_quest_stage(const String &quest_id) const {
	if (!quests_active.has(quest_id)) return "";
	return Dictionary(quests_active[quest_id]).get("stage", "");
}
bool MnBrain::is_quest_active(const String &quest_id) const { return quests_active.has(quest_id); }

void MnBrain::set_paused(bool p) { paused = p; }
bool MnBrain::get_paused() const { return paused; }

Dictionary MnBrain::snapshot() const {
	Dictionary s;
	s["day"] = day;
	s["minute"] = minute_of_day;
	s["hour"] = get_hour();
	s["location"] = location_id;
	s["cash"] = cash;
	s["bank"] = bank;
	s["stats"] = values.duplicate();
	s["flags"] = flags.duplicate();
	s["quests"] = quests_active.duplicate(true);
	return s;
}

String MnBrain::resolve_text(const String &key_or_text, const Dictionary &ctx) const {
	String text = key_or_text;
	if (text.begins_with("@")) {
		String k = _strip_key(text);
		text = strings.get(k, text);
	}
	String pname = ctx.get("player", player_name);
	String nname = ctx.get("npc", "");
	String place = ctx.get("place", "");
	String gender = ctx.get("gender", player_gender);
	text = text.replace("{player}", pname).replace("{x}", pname);
	text = text.replace("{npc}", nname).replace("{d}", nname);
	text = text.replace("{place}", place).replace("{o}", place);
	// {m:a|f:b} simples
	while (true) {
		int a = text.find("{m:");
		if (a < 0) break;
		int bar = text.find("|f:", a);
		int b = text.find("}", bar);
		if (bar < 0 || b < 0) break;
		String masc = text.substr(a + 3, bar - (a + 3));
		String fem = text.substr(bar + 3, b - (bar + 3));
		text = text.substr(0, a) + (gender == "m" ? masc : fem) + text.substr(b + 1);
	}
	return text;
}

String MnBrain::_strip_key(const String &key) const {
	return key.begins_with("@") ? key.substr(1) : key;
}

// ---- rules ----

bool MnBrain::_eval(const Variant &cond, const Dictionary &ctx) const {
	if (cond.get_type() == Variant::NIL) return true;
	if (cond.get_type() != Variant::DICTIONARY) return false;
	Dictionary d = cond;
	if (d.is_empty()) return true;
	if (d.has("not")) return !_eval(d["not"], ctx);
	if (d.has("anyOf")) {
		Array arr = d["anyOf"];
		for (int i = 0; i < arr.size(); i++) if (_eval(arr[i], ctx)) return true;
		return false;
	}
	Array keys = d.keys();
	for (int i = 0; i < keys.size(); i++) {
		String k = keys[i];
		if (k == "not" || k == "anyOf") continue;
		if (!_eval_key(k, d[k], ctx)) return false;
	}
	return true;
}

bool MnBrain::_eval_key(const String &key, const Variant &val, const Dictionary &ctx) const {
	if (key == "event") return String(ctx.get("event", "")) == String(val);
	if (key == "npc") return String(ctx.get("npc", "")) == String(val);
	if (key == "object") return String(ctx.get("object", "")) == String(val);
	if (key == "action") return String(ctx.get("action", "")) == String(val);
	if (key == "location") return location_id == String(val) || String(ctx.get("location", "")) == String(val);
	if (key == "quest") {
		Dictionary q = val;
		String qid = q.get("id", "");
		if (q.has("completed")) return has_flag(String("quest_done_") + qid) == (bool)q["completed"];
		if (!quests_active.has(qid)) return false;
		if (q.has("stage")) return get_quest_stage(qid) == String(q["stage"]);
		return true;
	}
	if (key == "stat") {
		Dictionary m = val;
		Array ks = m.keys();
		for (int i = 0; i < ks.size(); i++) {
			if (!cmp_int(get_stat(ks[i]), m[ks[i]])) return false;
		}
		return true;
	}
	if (key == "friendshipLevel") {
		String nid = ctx.get("npc", "");
		if (!npc_states.has(nid)) return false;
		int f = clampi((int)Dictionary(npc_states[nid]).get("friendship", 0), 0, 100);
		return cmp_int(f / 20, val);
	}
	if (key == "friendship" || key == "romance" || key == "npcMood") {
		String nid = ctx.get("npc", "");
		if (!npc_states.has(nid)) return false;
		Dictionary s = npc_states[nid];
		String field = key == "npcMood" ? "mood" : key;
		return cmp_int((int)s.get(field, 0), val);
	}
	if (key == "money") return cmp_int(cash, val);
	if (key == "hasItem") return (int)inventory.get(String(val), 0) > 0;
	if (key == "hasNotItem") return (int)inventory.get(String(val), 0) <= 0;
	if (key == "time") {
		Dictionary t = val;
		if (t.has("hour") && !cmp_int(get_hour(), t["hour"])) return false;
		if (t.has("minute") && !cmp_int(minute_of_day, t["minute"])) return false;
		if (t.has("day") && !cmp_int(day, t["day"])) return false;
		if (t.has("dayOfWeek") && (day % 7) != (int)t["dayOfWeek"]) return false;
		return true;
	}
	if (key == "flag") return has_flag(val);
	if (key == "notFlag") return !has_flag(val);
	if (key == "random") return UtilityFunctions::randf() < (double)val;
	if (key == "appearance") {
		Dictionary a = val;
		if (a.has("gender")) return player_gender == String(a["gender"]);
		return true;
	}
	return true;
}

void MnBrain::_run(const Array &actions, const Dictionary &ctx) {
	for (int i = 0; i < actions.size(); i++) {
		if (actions[i].get_type() == Variant::DICTIONARY) _run_one(actions[i], ctx);
	}
}

void MnBrain::_run_one(const Dictionary &a, const Dictionary &ctx) {
	if (a.has("dialogue")) {
		Dictionary payload;
		if (a["dialogue"].get_type() == Variant::STRING) payload["key"] = a["dialogue"];
		else payload = a["dialogue"];
		emit_signal("dialogue_requested", payload);
	} else if (a.has("money")) {
		add_cash((int)a["money"]);
	} else if (a.has("bank")) {
		bank = std::max(0, bank + (int)a["bank"]);
		emit_signal("money_changed", cash, bank);
	} else if (a.has("stat")) {
		Dictionary m = a["stat"];
		Array ks = m.keys();
		for (int i = 0; i < ks.size(); i++) apply_stat_delta(ks[i], (int)m[ks[i]]);
		_recompute_derived();
	} else if (a.has("relationship")) {
		Dictionary r = a["relationship"];
		String nid = r.get("npc", "");
		_ensure_npc(nid);
		Dictionary s = npc_states[nid];
		s["friendship"] = clampi((int)s.get("friendship", 0) + (int)r.get("friendship", 0), -100, 100);
		s["romance"] = clampi((int)s.get("romance", 0) + (int)r.get("romance", 0), 0, 100);
		s["mood"] = clampi((int)s.get("mood", 50) + (int)r.get("mood", 0), 0, 100);
		npc_states[nid] = s;
	} else if (a.has("giveItem")) {
		String iid = a["giveItem"];
		inventory[iid] = (int)inventory.get(iid, 0) + 1;
		Dictionary ev; ev["event"] = "item_gained"; ev["item"] = iid;
		_quest_notify(ev);
	} else if (a.has("takeItem")) {
		String iid = a["takeItem"];
		int n = (int)inventory.get(iid, 0) - 1;
		if (n <= 0) inventory.erase(iid); else inventory[iid] = n;
	} else if (a.has("startQuest")) {
		String qid = a["startQuest"];
		if (quests_def.has(qid) && !quests_active.has(qid)) {
			Dictionary q = quests_def[qid];
			String st = q.get("start", "");
			Dictionary act; act["stage"] = st; act["vars"] = Dictionary();
			quests_active[qid] = act;
			_quest_enter(qid, st);
		}
	} else if (a.has("setStage")) {
		Dictionary ss = a["setStage"];
		String qid = ss.get("quest", "");
		String st = ss.get("stage", "");
		if (!quests_active.has(qid) && quests_def.has(qid)) {
			Dictionary act; act["stage"] = st; act["vars"] = Dictionary();
			quests_active[qid] = act;
		}
		if (quests_active.has(qid)) {
			Dictionary act = quests_active[qid];
			act["stage"] = st;
			quests_active[qid] = act;
			_quest_enter(qid, st);
		}
	} else if (a.has("completeQuest")) {
		String qid = a["completeQuest"];
		set_flag(String("quest_done_") + qid, true);
		quests_active.erase(qid);
		emit_signal("quest_completed", qid);
	} else if (a.has("teleport")) {
		Dictionary tp = a["teleport"];
		emit_signal("teleport", tp.get("location", ""), tp.get("spawn", ""));
		enter_location(tp.get("location", ""), tp.get("spawn", ""));
	} else if (a.has("advanceTime")) {
		advance_minutes((int)a["advanceTime"]);
	} else if (a.has("unlockLocation")) {
		unlocked[String(a["unlockLocation"])] = true;
	} else if (a.has("lockLocation")) {
		unlocked.erase(a["lockLocation"]);
	} else if (a.has("markMap")) {
		unlocked[String(a["markMap"])] = true;
	} else if (a.has("setFlag")) {
		set_flag(a["setFlag"], true);
	} else if (a.has("clearFlag")) {
		set_flag(a["clearFlag"], false);
	} else if (a.has("notify")) {
		emit_signal("notify", a["notify"]);
	} else if (a.has("achievement")) {
		achievements[String(a["achievement"])] = true;
	} else if (a.has("if")) {
		Dictionary iff = a["if"];
		if (_eval(iff.get("when", Dictionary()), ctx)) _run(iff.get("then", Array()), ctx);
		else _run(iff.get("else", Array()), ctx);
	}
}

void MnBrain::_fire_triggers(const String &on, const String &object_id, const String &npc_id) {
	if (!locations.has(location_id)) return;
	Dictionary loc = locations[location_id];
	Array triggers = loc.get("triggers", Array());
	for (int i = 0; i < triggers.size(); i++) {
		Dictionary t = triggers[i];
		if (String(t.get("on", "")) != on) continue;
		if (t.has("object") && String(t["object"]) != object_id) continue;
		if (t.has("npc") && String(t["npc"]) != npc_id) continue;
		if ((bool)t.get("once", false)) {
			String fk = String("trig_") + location_id + "_" + on + "_" + object_id + npc_id;
			if (has_flag(fk)) continue;
			set_flag(fk, true);
		}
		Dictionary ctx;
		ctx["object"] = object_id;
		ctx["npc"] = npc_id;
		ctx["location"] = location_id;
		if (_eval(t.get("when", Dictionary()), ctx)) _run(t.get("do", Array()), ctx);
	}
}

void MnBrain::_quest_notify(const Dictionary &ev) {
	Array qids = quests_active.keys();
	for (int i = 0; i < qids.size(); i++) {
		String qid = qids[i];
		Dictionary act = quests_active[qid];
		String st = act.get("stage", "");
		Dictionary qdef = quests_def.get(qid, Dictionary());
		Dictionary stages = qdef.get("stages", Dictionary());
		Dictionary stage = stages.get(st, Dictionary());
		Array transitions = stage.get("transitions", Array());
		for (int j = 0; j < transitions.size(); j++) {
			Dictionary tr = transitions[j];
			Dictionary ctx = ev.duplicate();
			ctx["quest_id"] = qid;
			if (_eval(tr.get("when", Dictionary()), ctx)) {
				if (tr.has("do")) _run(tr["do"], ctx);
				String to = tr.get("to", st);
				act["stage"] = to;
				quests_active[qid] = act;
				_quest_enter(qid, to);
				break;
			}
		}
	}
}

void MnBrain::_quest_enter(const String &qid, const String &stage_id) {
	emit_signal("quest_stage_entered", qid, stage_id);
	Dictionary qdef = quests_def.get(qid, Dictionary());
	Dictionary stages = qdef.get("stages", Dictionary());
	Dictionary stage = stages.get(stage_id, Dictionary());
	if ((bool)stage.get("final", false)) {
		emit_signal("quest_completed", qid);
		Dictionary rewards = qdef.get("rewards", Dictionary());
		if (rewards.has("money")) add_cash((int)rewards["money"]);
		if (rewards.has("achievement")) achievements[String(rewards["achievement"])] = true;
		set_flag(String("quest_done_") + qid, true);
	}
	if (stage.has("onEnter")) {
		Dictionary ctx;
		ctx["quest"] = qid;
		ctx["stage"] = stage_id;
		_run(stage["onEnter"], ctx);
	}
}

void MnBrain::_ensure_npc(const String &npc_id) {
	if (npc_states.has(npc_id)) return;
	Dictionary s;
	s["friendship"] = 0;
	s["romance"] = 0;
	s["mood"] = 50;
	s["interactions_today"] = 0;
	s["gifts_today"] = 0;
	s["likes"] = Array();
	s["dislikes"] = Array();
	if (npcs.has(npc_id)) {
		Dictionary def = npcs[npc_id];
		Dictionary init = def.get("initial", Dictionary());
		s["friendship"] = init.get("friendship", 0);
		s["romance"] = init.get("romance", 0);
		s["mood"] = init.get("mood", 50);
		s["likes"] = def.get("likes", Array());
		s["dislikes"] = def.get("dislikes", Array());
	}
	npc_states[npc_id] = s;
}

// ---- content load / save ----

void MnBrain::_load_folder(const String &folder, Dictionary &into) {
	String path = content_dir.path_join(folder);
	Ref<DirAccess> dir = DirAccess::open(path);
	if (dir.is_null()) return;
	dir->list_dir_begin();
	String fn = dir->get_next();
	while (!fn.is_empty()) {
		if (!dir->current_is_dir() && fn.ends_with(".json")) {
			Variant data = _read_any(path.path_join(fn));
			if (data.get_type() == Variant::DICTIONARY) {
				Dictionary d = data;
				if (d.has("id")) into[String(d["id"])] = d;
			} else if (data.get_type() == Variant::ARRAY) {
				Array arr = data;
				for (int i = 0; i < arr.size(); i++) {
					Dictionary d = arr[i];
					if (d.has("id")) into[String(d["id"])] = d;
				}
			}
		}
		fn = dir->get_next();
	}
	dir->list_dir_end();
}

Dictionary MnBrain::_read_dict(const String &path) const {
	Variant v = _read_any(path);
	return v.get_type() == Variant::DICTIONARY ? Dictionary(v) : Dictionary();
}

Variant MnBrain::_read_any(const String &path) const {
	return miami::read_json_any(path);
}

String MnBrain::_save_path(int slot) const {
	return save_dir.path_join(String("slot_") + String::num_int64(slot) + ".json");
}

Error MnBrain::save_game(int slot) {
	Dictionary data;
	data["version"] = 1;
	Dictionary time_d;
	time_d["day"] = day;
	time_d["minute"] = minute_of_day;
	data["time"] = time_d;
	data["player"] = appearance;
	data["stats"] = values;
	Dictionary eco;
	eco["cash"] = cash;
	eco["bank"] = bank;
	eco["rent_paid_this_week"] = rent_paid;
	data["economy"] = eco;
	data["inventory"] = inventory;
	data["npcs"] = npc_states;
	data["quests"] = quests_active;
	Dictionary world;
	world["location"] = location_id;
	world["spawn"] = spawn_id;
	Array c;
	c.push_back(cell.x);
	c.push_back(cell.y);
	world["cell"] = c;
	world["facing"] = facing;
	world["flags"] = flags;
	data["world"] = world;
	Dictionary crime;
	crime["in_jail"] = in_jail;
	crime["jail_minutes"] = jail_minutes;
	data["crime"] = crime;

	Ref<FileAccess> f = FileAccess::open(_save_path(slot), FileAccess::WRITE);
	if (f.is_null()) return ERR_CANT_CREATE;
	f->store_string(JSON::stringify(data, "\t"));
	return OK;
}

Error MnBrain::load_game(int slot) {
	String path = _save_path(slot);
	if (!FileAccess::file_exists(path)) return ERR_FILE_NOT_FOUND;
	Dictionary data = _read_dict(path);
	if (data.is_empty()) return ERR_INVALID_DATA;
	Dictionary time_d = data.get("time", Dictionary());
	day = (int)time_d.get("day", 0);
	minute_of_day = (int)time_d.get("minute", 480);
	appearance = data.get("player", appearance);
	player_name = appearance.get("name", player_name);
	player_gender = appearance.get("gender", player_gender);
	values = data.get("stats", values);
	Dictionary eco = data.get("economy", Dictionary());
	cash = (int)eco.get("cash", 0);
	bank = (int)eco.get("bank", 0);
	rent_paid = (bool)eco.get("rent_paid_this_week", false);
	inventory = data.get("inventory", Dictionary());
	npc_states = data.get("npcs", Dictionary());
	quests_active = data.get("quests", Dictionary());
	Dictionary world = data.get("world", Dictionary());
	location_id = world.get("location", "");
	spawn_id = world.get("spawn", "");
	Array c = world.get("cell", Array());
	if (c.size() >= 2) cell = Vector2i((int)c[0], (int)c[1]);
	facing = world.get("facing", "S");
	flags = world.get("flags", Dictionary());
	Dictionary crime = data.get("crime", Dictionary());
	in_jail = (bool)crime.get("in_jail", false);
	jail_minutes = (int)crime.get("jail_minutes", 0);
	emit_signal("money_changed", cash, bank);
	emit_signal("location_changed", location_id);
	return OK;
}
