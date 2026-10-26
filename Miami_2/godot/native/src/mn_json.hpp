#pragma once
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/dir_access.hpp>
#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

namespace miami {

inline godot::Dictionary read_json_dict(const godot::String &path) {
	if (!godot::FileAccess::file_exists(path)) {
		return godot::Dictionary();
	}
	godot::Ref<godot::FileAccess> f = godot::FileAccess::open(path, godot::FileAccess::READ);
	if (f.is_null()) {
		return godot::Dictionary();
	}
	godot::Ref<godot::JSON> json;
	json.instantiate();
	godot::Error err = json->parse(f->get_as_text());
	if (err != godot::OK) {
		return godot::Dictionary();
	}
	godot::Variant v = json->get_data();
	if (v.get_type() == godot::Variant::DICTIONARY) {
		return v;
	}
	return godot::Dictionary();
}

inline godot::Variant read_json_any(const godot::String &path) {
	if (!godot::FileAccess::file_exists(path)) {
		return godot::Variant();
	}
	godot::Ref<godot::FileAccess> f = godot::FileAccess::open(path, godot::FileAccess::READ);
	if (f.is_null()) {
		return godot::Variant();
	}
	godot::Ref<godot::JSON> json;
	json.instantiate();
	if (json->parse(f->get_as_text()) != godot::OK) {
		return godot::Variant();
	}
	return json->get_data();
}

inline int clampi(int v, int a, int b) {
	return v < a ? a : (v > b ? b : v);
}

inline bool cmp_int(int value, const godot::Variant &cond) {
	if (cond.get_type() == godot::Variant::INT || cond.get_type() == godot::Variant::FLOAT) {
		return value == (int)cond;
	}
	if (cond.get_type() != godot::Variant::DICTIONARY) {
		return false;
	}
	godot::Dictionary d = cond;
	if (d.has(">=") && !(value >= (int)d[">="])) return false;
	if (d.has("<=") && !(value <= (int)d["<="])) return false;
	if (d.has(">") && !(value > (int)d[">"])) return false;
	if (d.has("<") && !(value < (int)d["<"])) return false;
	if (d.has("==") && !(value == (int)d["=="])) return false;
	if (d.has("!=") && !(value != (int)d["!="])) return false;
	return true;
}

} // namespace miami
