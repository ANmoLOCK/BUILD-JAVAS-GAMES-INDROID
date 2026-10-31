#!/usr/bin/env python3
"""Gera o pack de conteúdo completo do Miami 3D a partir dos packs de strings
extraídos (Miami_2/05-strings) + inventário 04. Não sobrescreve arquivos
detalhados já curados (lista PRESERVE)."""

from __future__ import annotations

import json
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]  # Miami_2/
STRINGS = ROOT / "05-strings"
CONTENT = ROOT / "godot" / "miami3d" / "content"

PRESERVE = {
    # locais detalhados
    "locations/player_apartment.json",
    "locations/first_street.json",
    "locations/apartment_garden.json",
    # elenco / missões / ações já afinadas
    "npcs/landlord.json",
    "quests/q_landlord.json",
    "quests/q_gnomes.json",
    "interactions/sleep.json",
    "interactions/talk_compliment.json",
    "interactions/apartment_basics.json",
    "interactions/street.json",
    "items/bed_standard.json",
    "items/sofa_basic.json",
    "items/shower.json",
    "items/toilet.json",
    "items/sink.json",
    "items/fridge.json",
    "items/kitchen.json",
    "items/closet.json",
    "items/phone.json",
    "items/plant.json",
    "items/mailbox.json",
    "items/bench.json",
    "items/trash_can.json",
    "items/gnome.json",
    "items/gnome_pedestal.json",
    "items/flowers.json",
    "stats.json",
}


def parse_pack(name: str) -> dict[int, str]:
    path = STRINGS / name
    out: dict[int, str] = {}
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        m = re.match(r"^\[(\d+)\]\s*(.*)$", line)
        if m:
            out[int(m.group(1))] = m.group(2)
    return out


def slug(text: str, fallback: str = "x") -> str:
    t = text
    t = re.sub(r"\\[mMfFpPxXvV]\d*", "", t)
    t = re.sub(r"\\[mMfF][^\\]*\\[mMfF]", "", t)
    t = re.sub(r"\{[^}]*\}", "", t)
    t = re.sub(r"<[^>]*>", "", t)
    t = unicodedata.normalize("NFKD", t)
    t = "".join(c for c in t if not unicodedata.combining(c))
    t = t.lower()
    t = re.sub(r"[^a-z0-9]+", "_", t).strip("_")
    return t or fallback


def write_json(rel: str, data, *, force: bool = False) -> None:
    path = CONTENT / rel
    if not force and rel in PRESERVE and path.exists():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def strip_mf(s: str) -> str:
    """Remove tags \\m..\\m\\f..\\f mantendo forma masculina como default legível."""
    s = re.sub(r"\\m([^\\]*)\\m\\f[^\\]*\\f", r"\1", s)
    s = re.sub(r"\\[pPxXvV]\d*", "", s)
    s = re.sub(r"\\[a-zA-Z0-9]", "", s)
    return s.strip()


# --- IDs canônicos ---

LOCATION_IDS = [
    "first_street",
    "police_station",
    "glight_club",
    "newspaper_office",
    "stadium",
    "beauty_clinic",
    "heather_dean_apartment",
    "grand_avenue",
    "lounge",
    "south_beach",
    "cuban_cafe",
    "little_havana",
    "yuca_restaurant",
    "ocean_drive",
    "player_apartment",
    "pelican_port",
    "yacht",
    "everglades",
    "mansion",
    "downtown",
    "coconut_grove",
    "npc_apartment",
    "miami_beach",
    "pelican_island",
    "key_biscayne",
]

LOCATION_META = {
    "first_street": ("downtown", False, 80, 70),
    "police_station": ("downtown", True, 20, 16),
    "glight_club": ("downtown", True, 24, 20),
    "newspaper_office": ("downtown", True, 18, 14),
    "stadium": ("downtown", False, 40, 36),
    "beauty_clinic": ("downtown", True, 16, 14),
    "heather_dean_apartment": ("downtown", True, 14, 16),
    "grand_avenue": ("coconut_grove", False, 60, 50),
    "lounge": ("coconut_grove", True, 18, 14),
    "south_beach": ("south_beach", False, 48, 40),
    "cuban_cafe": ("little_havana", True, 16, 12),
    "little_havana": ("little_havana", False, 50, 40),
    "yuca_restaurant": ("little_havana", True, 18, 14),
    "ocean_drive": ("ocean_drive", False, 55, 40),
    "player_apartment": ("downtown", True, 14, 19),
    "pelican_port": ("pelican_island", False, 30, 24),
    "yacht": ("pelican_island", True, 20, 12),
    "everglades": ("everglades", False, 40, 40),
    "mansion": ("key_biscayne", True, 28, 22),
    "downtown": ("downtown", False, 50, 40),
    "coconut_grove": ("coconut_grove", False, 50, 40),
    "npc_apartment": ("downtown", True, 14, 16),
    "miami_beach": ("miami_beach", False, 40, 30),
    "pelican_island": ("pelican_island", False, 36, 28),
    "key_biscayne": ("key_biscayne", False, 36, 28),
}

# hub portals linking the city (logical travel)
PORTALS = {
    "first_street": [
        {"id": "to_apartment", "cell": [22, 29], "to": "player_apartment", "spawn": "from_street"},
        {"id": "to_police", "cell": [35, 20], "to": "police_station", "spawn": "default"},
        {"id": "to_downtown", "cell": [60, 35], "to": "downtown", "spawn": "default"},
        {"id": "to_club", "cell": [50, 25], "to": "glight_club", "spawn": "default"},
        {"id": "to_news", "cell": [45, 30], "to": "newspaper_office", "spawn": "default"},
    ],
    "downtown": [
        {"id": "to_first", "cell": [25, 25], "to": "first_street", "spawn": "from_apartment"},
        {"id": "to_stadium", "cell": [40, 20], "to": "stadium", "spawn": "default"},
        {"id": "to_clinic", "cell": [30, 30], "to": "beauty_clinic", "spawn": "default"},
    ],
    "south_beach": [
        {"id": "to_ocean", "cell": [5, 20], "to": "ocean_drive", "spawn": "default"},
        {"id": "to_miami_beach", "cell": [40, 5], "to": "miami_beach", "spawn": "default"},
    ],
    "ocean_drive": [
        {"id": "to_south", "cell": [50, 20], "to": "south_beach", "spawn": "default"},
        {"id": "to_yuca", "cell": [20, 15], "to": "yuca_restaurant", "spawn": "default"},
        {"id": "to_little", "cell": [10, 20], "to": "little_havana", "spawn": "default"},
    ],
    "little_havana": [
        {"id": "to_ocean", "cell": [45, 20], "to": "ocean_drive", "spawn": "default"},
        {"id": "to_cafe", "cell": [20, 15], "to": "cuban_cafe", "spawn": "default"},
        {"id": "to_yuca", "cell": [30, 25], "to": "yuca_restaurant", "spawn": "default"},
    ],
    "coconut_grove": [
        {"id": "to_grand", "cell": [25, 25], "to": "grand_avenue", "spawn": "default"},
        {"id": "to_lounge", "cell": [35, 20], "to": "lounge", "spawn": "default"},
    ],
    "grand_avenue": [
        {"id": "to_grove", "cell": [30, 25], "to": "coconut_grove", "spawn": "default"},
        {"id": "to_lounge", "cell": [40, 20], "to": "lounge", "spawn": "default"},
    ],
    "pelican_island": [
        {"id": "to_port", "cell": [18, 12], "to": "pelican_port", "spawn": "default"},
        {"id": "to_yacht", "cell": [20, 20], "to": "yacht", "spawn": "default"},
    ],
    "pelican_port": [
        {"id": "to_island", "cell": [15, 12], "to": "pelican_island", "spawn": "default"},
        {"id": "to_yacht", "cell": [20, 10], "to": "yacht", "spawn": "default"},
    ],
    "key_biscayne": [
        {"id": "to_mansion", "cell": [18, 11], "to": "mansion", "spawn": "default"},
        {"id": "to_everglades", "cell": [30, 20], "to": "everglades", "spawn": "default"},
    ],
    "police_station": [{"id": "exit", "cell": [10, 14], "to": "first_street", "spawn": "from_apartment"}],
    "glight_club": [{"id": "exit", "cell": [12, 18], "to": "first_street", "spawn": "from_apartment"}],
    "newspaper_office": [{"id": "exit", "cell": [9, 12], "to": "first_street", "spawn": "from_apartment"}],
    "beauty_clinic": [{"id": "exit", "cell": [8, 12], "to": "downtown", "spawn": "default"}],
    "stadium": [{"id": "exit", "cell": [20, 34], "to": "downtown", "spawn": "default"}],
    "yuca_restaurant": [{"id": "exit", "cell": [9, 12], "to": "ocean_drive", "spawn": "default"}],
    "cuban_cafe": [{"id": "exit", "cell": [8, 10], "to": "little_havana", "spawn": "default"}],
    "lounge": [{"id": "exit", "cell": [9, 12], "to": "grand_avenue", "spawn": "default"}],
    "yacht": [{"id": "exit", "cell": [10, 10], "to": "pelican_port", "spawn": "default"}],
    "mansion": [{"id": "exit", "cell": [14, 20], "to": "key_biscayne", "spawn": "default"}],
    "heather_dean_apartment": [{"id": "exit", "cell": [7, 14], "to": "first_street", "spawn": "from_apartment"}],
    "npc_apartment": [{"id": "exit", "cell": [7, 14], "to": "first_street", "spawn": "from_apartment"}],
    "miami_beach": [{"id": "to_south", "cell": [20, 25], "to": "south_beach", "spawn": "default"}],
    "everglades": [{"id": "exit", "cell": [20, 38], "to": "key_biscayne", "spawn": "default"}],
}

STORY_NPCS = [
    # id, slot, gender, home, dateable, likes, essential
    ("landlord", 0, "m", "player_apartment", False, ["money", "garden_gnomes", "football"], True),
    ("goldsax", 1, "f", "pelican_island", False, ["business", "fashion", "money"], True),
    ("sanchez", 2, "m", "little_havana", False, ["crime", "cigars", "money"], True),
    ("dean", 3, "m", "heather_dean_apartment", True, ["sports", "movies", "food"], True),
    ("heather", 4, "f", "heather_dean_apartment", True, ["fashion", "romance", "music"], True),
    ("scott", 5, "m", "npc_apartment", False, ["parties", "dogs", "jokes"], True),
    ("callie", 6, "f", "npc_apartment", False, ["parties", "dogs", "jokes"], True),
    ("danny", 7, "m", "glight_club", True, ["music", "parties", "dance"], False),
    ("amy", 8, "f", "south_beach", True, ["beach", "fashion", "gossip"], False),
    ("beatrice", 9, "f", "ocean_drive", False, ["dogs", "kindness", "family"], True),
    ("inspector", 10, "m", "police_station", False, ["crime", "law", "coffee"], True),
    ("hal_pachinko", 11, "m", "yuca_restaurant", False, ["food", "business", "money"], True),
    ("dj", 12, "m", "glight_club", False, ["music", "dance", "parties"], True),
    ("spillbeard", 13, "m", "stadium", False, ["acting", "sports", "money"], True),
    ("opal", 14, "f", "south_beach", False, ["media", "dogs", "fashion"], True),
    ("charm", 15, "f", "glight_club", False, ["nightlife", "dance", "drinks"], True),
    ("guard", 16, "m", "police_station", False, ["law", "sleep", "coffee"], True),
    ("captain", 17, "m", "pelican_port", False, ["sea", "treasure", "stories"], True),
    ("nip", 18, "m", "beauty_clinic", False, ["fashion", "hair", "gossip"], True),
    ("took", 19, "f", "beauty_clinic", False, ["fashion", "hair", "gossip"], True),
    ("mortadella", 20, "m", "newspaper_office", False, ["fashion", "models", "money"], True),
    ("doctor", 21, "m", "beauty_clinic", False, ["health", "surgery", "science"], True),
    ("security", 22, "m", "stadium", False, ["security", "sports", "order"], True),
    ("huggy", 84, "m", "south_beach", False, ["crime", "cigars", "money"], True),
    ("john_plumber", 85, "m", "player_apartment", False, ["plumbing", "work", "coffee"], True),
    ("coco", 86, "f", "ocean_drive", False, ["vitamins", "health", "sales"], True),
    ("butcher", 87, "m", "little_havana", False, ["food", "meat", "money"], False),
    ("boss", 88, "m", "little_havana", False, ["crime", "power", "money"], True),
    ("pet_shop_boy", 89, "m", "coconut_grove", False, ["pets", "dogs", "sales"], True),
    ("xavier", 90, "m", "mansion", True, ["luxury", "art", "parties"], True),
    ("elizabeth", 91, "f", "mansion", True, ["luxury", "romance", "art"], True),
    ("shaman", 92, "m", "everglades", False, ["nature", "spirits", "herbs"], True),
    ("mia", 93, "f", "miami_beach", True, ["beach", "dance", "music"], False),
]

INTEREST_CATS = [
    "sports", "politics", "fashion", "cinema", "environment", "music", "weather",
    "videogames", "pets", "technology", "children", "marriage", "family", "art",
    "bars", "philosophy", "business", "subway", "television", "theater", "transport",
    "tourism", "nature", "traffic", "shopping", "money", "health", "food", "cars",
    "security", "crime", "culture", "office", "romance", "clubs", "loitering",
    "people", "celebrities",
]


def gen_pack_meta() -> None:
    write_json(
        "pack.json",
        {
            "id": "base",
            "version": "0.3.0",
            "name": "Miami 3D — pacote base",
            "description": "Conteúdo alinhado ao inventário 04 (locais, NPCs, ações, missões, empregos).",
            "dependencies": [],
            "priority": 0,
            "locale": "pt-BR",
        },
        force=True,
    )


def gen_regions() -> None:
    write_json(
        "regions.json",
        {
            "id": "city_map",
            "regions": [
                {"id": "downtown", "name": "@region.downtown", "locations": ["first_street", "downtown", "police_station", "glight_club", "newspaper_office", "stadium", "beauty_clinic", "player_apartment", "heather_dean_apartment", "npc_apartment", "apartment_garden"]},
                {"id": "south_beach", "name": "@region.south_beach", "locations": ["south_beach"]},
                {"id": "little_havana", "name": "@region.little_havana", "locations": ["little_havana", "cuban_cafe", "yuca_restaurant"]},
                {"id": "ocean_drive", "name": "@region.ocean_drive", "locations": ["ocean_drive"]},
                {"id": "coconut_grove", "name": "@region.coconut_grove", "locations": ["coconut_grove", "grand_avenue", "lounge"]},
                {"id": "miami_beach", "name": "@region.miami_beach", "locations": ["miami_beach"]},
                {"id": "pelican_island", "name": "@region.pelican_island", "locations": ["pelican_island", "pelican_port", "yacht"]},
                {"id": "key_biscayne", "name": "@region.key_biscayne", "locations": ["key_biscayne", "mansion"]},
                {"id": "everglades", "name": "@region.everglades", "locations": ["everglades"]},
            ],
        },
        force=True,
    )


def gen_rent() -> None:
    write_json(
        "rent.json",
        {
            "apartment": {"amount": 300, "periodDays": 7, "location": "player_apartment"},
            "mansion": {"amount": 2000, "periodDays": 7, "location": "mansion"},
            "graceDays": 2,
            "lateFee": 50,
            "evictionAfterDays": 14,
            "reminders": [
                {"dayOfWeek": 0, "hour": 8, "text": "@msg.rent_reminder"},
                {"dayOfWeek": 0, "hour": 18, "text": "@msg.rent_reminder"},
            ],
            "payAt": ["atm", "bank"],
        },
        force=True,
    )


def gen_gifts() -> None:
    gifts = [
        {"id": "gift_special_drink", "name": "@gift.special_drink", "price": 5, "romance": 4, "friendship": 2},
        {"id": "gift_flowers", "name": "@gift.flowers", "price": 10, "romance": 8, "friendship": 3},
        {"id": "gift_cash", "name": "@gift.cash", "price": 20, "romance": 2, "friendship": 6},
        {"id": "gift_sexy", "name": "@gift.sexy", "price": 50, "romance": 15, "friendship": 1},
        {"id": "gift_polo", "name": "@gift.polo", "price": 15, "romance": 5, "friendship": 4},
        {"id": "gift_ticket", "name": "@gift.ticket", "price": 20, "romance": 6, "friendship": 5},
        {"id": "gift_lingerie", "name": "@gift.lingerie", "price": 25, "romance": 12, "friendship": 2},
        {"id": "gift_vitamin", "name": "@gift.vitamin", "price": 8, "romance": 1, "friendship": 3, "stat": {"health": 5}},
    ]
    write_json("gifts.json", {"id": "gifts", "items": gifts}, force=True)


def gen_surgery() -> None:
    write_json(
        "surgery.json",
        {
            "id": "surgery",
            "clinic": "beauty_clinic",
            "procedures": [
                {"id": "lipo", "name": "@surgery.lipo", "price": 400, "durationMinutes": 180, "effects": [{"stat": "sex_appeal", "delta": 8}, {"stat": "health", "delta": -5}]},
                {"id": "rhinoplasty", "name": "@surgery.rhino", "price": 600, "durationMinutes": 240, "effects": [{"stat": "sex_appeal", "delta": 10}, {"stat": "self_esteem", "delta": 5}]},
                {"id": "lifting", "name": "@surgery.lifting", "price": 800, "durationMinutes": 300, "effects": [{"stat": "sex_appeal", "delta": 12}, {"stat": "self_esteem", "delta": 8}]},
                {"id": "implants", "name": "@surgery.implants", "price": 700, "durationMinutes": 240, "effects": [{"stat": "sex_appeal", "delta": 15}, {"stat": "health", "delta": -8}]},
            ],
        },
        force=True,
    )


def gen_achievements() -> None:
    p9 = parse_pack("pack09_conquistas_titulos.txt")
    ids = [
        "bronze_medallion", "silver_medallion", "gold_medallion",
        "extra", "bartender", "ad_assistant",
        "gnome_lover", "gnome_beach", "gnome_gourmet", "gnome_police",
        "gnome_fashion", "gnome_degubas", "gnome_security",
        "black_skull", "delivery", "model_agent", "dj", "private_eye", "mafia_boss",
    ]
    items = []
    for i, aid in enumerate(ids):
        items.append({
            "id": aid,
            "name": f"@ach.{aid}",
            "title": strip_mf(p9.get(i, aid)),
            "order": i,
        })
    write_json("achievements.json", {"id": "achievements", "items": items}, force=True)


def gen_locations() -> None:
    for lid in LOCATION_IDS:
        rel = f"locations/{lid}.json"
        if rel in PRESERVE and (CONTENT / rel).exists():
            # still ensure scene path points to locations/
            path = CONTENT / rel
            data = json.loads(path.read_text(encoding="utf-8"))
            data["scene"] = f"res://game/world/locations/{lid}.tscn"
            path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
            continue
        region, indoor, w, h = LOCATION_META[lid]
        cx, cy = max(1, w // 2), max(1, h // 2)
        data = {
            "id": lid,
            "name": f"@loc.{lid}",
            "region": region,
            "scene": f"res://game/world/locations/{lid}.tscn",
            "indoor": indoor,
            "openHours": [0, 24],
            "music": "apartment_calm" if indoor else "downtown_day",
            "grid": {"width": w, "height": h},
            "spawn": {"cell": [cx, cy], "facing": "S"},
            "spawns": {"default": {"cell": [cx, cy], "facing": "S"}},
            "blocked": [[0, 0, w, 1], [0, 0, 1, h], [w - 1, 0, 1, h], [0, h - 1, w, 1]],
            "portals": PORTALS.get(lid, []),
            "zones": [{"id": "main", "rect": [2, 2, max(1, w - 4), max(1, h - 4)], "tag": "indoor" if indoor else "custom"}],
            "objects": [],
            "npcs": [],
            "triggers": [],
        }
        if lid == "south_beach":
            data["zones"] = [{"id": "sand", "rect": [5, 5, 35, 25], "tag": "beach"}]
            data["npcs"] = [{"npc": "huggy", "schedule": "huggy_beach"}, {"generic": True, "count": 8}]
            data["objects"] = [
                {"id": "lounger_1", "template": "sun_lounger", "cell": [12, 14]},
                {"id": "sand_1", "template": "beach_sand", "cell": [20, 18]},
            ]
        if lid == "glight_club":
            data["zones"] = [{"id": "floor", "rect": [4, 4, 16, 12], "tag": "dancefloor"}]
            data["npcs"] = [{"npc": "dj", "schedule": "dj_club"}, {"npc": "charm", "schedule": "charm_club"}, {"generic": True, "count": 10}]
            data["objects"] = [
                {"id": "bar_1", "template": "bar", "cell": [3, 8]},
                {"id": "dj_desk", "template": "dj_desk", "cell": [18, 6]},
            ]
        if lid == "police_station":
            data["npcs"] = [{"npc": "inspector", "schedule": "inspector_station"}, {"npc": "guard", "schedule": "guard_station"}]
            data["objects"] = [
                {"id": "cell_door", "template": "cell_door", "cell": [4, 4]},
                {"id": "keys_1", "template": "keys", "cell": [8, 3]},
            ]
        if lid == "yuca_restaurant":
            data["npcs"] = [{"npc": "hal_pachinko", "schedule": "hal_restaurant"}]
            data["objects"] = [
                {"id": "pizza_counter", "template": "pizza", "cell": [6, 6]},
                {"id": "food_1", "template": "food", "cell": [8, 6]},
            ]
        write_json(rel, data, force=True)

    # garden stays preserved but ensure portals ok
    garden = CONTENT / "locations/apartment_garden.json"
    if garden.exists():
        d = json.loads(garden.read_text(encoding="utf-8"))
        d["scene"] = "res://game/world/locations/apartment_garden.tscn"
        garden.write_text(json.dumps(d, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def gen_npcs() -> None:
    p11 = parse_pack("pack11_nomes_de_npc.txt")
    # story
    for nid, slot, gender, home, dateable, likes, essential in STORY_NPCS:
        if nid == "landlord":
            continue
        name = strip_mf(p11.get(slot, nid))
        write_json(
            f"npcs/{nid}.json",
            {
                "id": nid,
                "slot": slot,
                "name": f"@npc.{nid}",
                "displayName": name,
                "gender": gender,
                "appearance": [0 if gender == "m" else 1, slot % 5, slot % 6, slot % 4, (slot * 2) % 8, slot % 6, (slot * 3) % 8, slot % 6, slot % 5, slot % 4],
                "likes": likes[:3],
                "dislikes": ["politics"] if "politics" not in likes else ["pets"],
                "initial": {"friendship": 0, "romance": 0, "mood": 55},
                "schedule": f"{nid}_default",
                "greetings": "@greet.default",
                "dateable": dateable,
                "roommateable": nid in ("heather", "dean", "elizabeth", "xavier"),
                "essential": essential,
                "home": home,
                "phoneUnlock": {"friendshipLevel": {">=": 2}},
            },
            force=True,
        )

    # generics 23..83
    generics = []
    for slot in range(23, 84):
        raw = strip_mf(p11.get(slot, f"npc_{slot}"))
        gender = "m" if slot < 52 else "f"
        nid = f"generic_{slot}_{slug(raw, str(slot))}"
        generics.append({
            "id": nid,
            "slot": slot,
            "name": f"@npc.{nid}",
            "displayName": raw,
            "gender": gender,
            "appearance": [0 if gender == "m" else 1, slot % 5, slot % 6, slot % 4, (slot * 2) % 8, slot % 6, (slot * 3) % 8, slot % 6, slot % 5, slot % 4],
            "likes": [INTEREST_CATS[slot % len(INTEREST_CATS)], INTEREST_CATS[(slot + 7) % len(INTEREST_CATS)], INTEREST_CATS[(slot + 13) % len(INTEREST_CATS)]],
            "dislikes": [INTEREST_CATS[(slot + 19) % len(INTEREST_CATS)]],
            "initial": {"friendship": 0, "romance": 0, "mood": 50},
            "schedule": "generic_wander",
            "greetings": "@greet.default",
            "dateable": True,
            "roommateable": False,
            "essential": False,
            "generic": True,
        })
    write_json("npcs/generics.json", generics, force=True)


def act_id_from_name(idx: int, name: str) -> str:
    s = slug(strip_mf(name), f"act_{idx}")
    # avoid collisions with existing curated ids
    mapping = {
        36: "sleep",
        37: "nap",
        6: "compliment",  # social from pack10 handled separately
    }
    if idx in mapping:
        return mapping[idx]
    return s


def gen_interactions() -> None:
    p13 = parse_pack("pack13_locais_e_acoes_de_objeto.txt")
    # object actions 28..166
    by_cat: dict[str, list] = {
        "needs": [], "food": [], "cook": [], "crime": [], "kindness": [],
        "leisure": [], "fitness": [], "dance": [], "beauty": [], "work": [],
        "animals": [], "phone": [], "environment": [], "other": [],
    }
    cat_of = {}
    for i in range(28, 48):
        cat_of[i] = "needs"
    for i in [42, 43, 44, 45, 47] + list(range(66, 69)) + list(range(82, 88)) + list(range(124, 132)):
        cat_of[i] = "food"
    for i in [62] + list(range(157, 162)):
        cat_of[i] = "cook"
    for i in [31, 33, 34, 40, 46, 57, 58, 59, 104, 140]:
        cat_of[i] = "crime"
    for i in [30, 35, 63, 142, 143, 145]:
        cat_of[i] = "kindness"
    for i in list(range(70, 74)):
        cat_of[i] = "dance"
    for i in [100, 162, 163]:
        cat_of[i] = "fitness"
    for i in [53, 54, 55, 113, 116, 118, 119, 120, 121]:
        cat_of[i] = "beauty"
    for i in [102, 103, 105, 106, 107, 109, 110, 114, 115, 141]:
        cat_of[i] = "work"
    for i in [146, 147, 148, 149, 150, 151, 153]:
        cat_of[i] = "animals"
    for i in [29, 134, 135, 136, 137, 166]:
        cat_of[i] = "phone"
    for i in [111, 112, 122, 123, 138, 144, 152, 156]:
        cat_of[i] = "environment"

    # curated sleep kept; skip writing duplicate sleep
    skip_ids = {"sleep"}

    for idx in range(28, 167):
        raw = p13.get(idx, f"ACT_{idx}")
        aid = act_id_from_name(idx, raw)
        if aid in skip_ids:
            continue
        cat = cat_of.get(idx, "other")
        if cat == "needs" and idx in (42, 43, 44, 45, 47):
            cat = "food"
        effects = []
        duration = 5
        if cat == "needs":
            if "dorm" in aid or aid == "sleep":
                continue  # preserved
            if "cochilar" in aid or "nap" in aid:
                effects = [{"stat": "sleep", "delta": -30}]
                duration = 60
            elif "banho" in aid or "lavar" in aid or "shower" in aid:
                effects = [{"stat": "hygiene", "delta": 40}]
                duration = 20
            elif "banheiro" in aid or "urinar" in aid:
                effects = [{"stat": "bladder", "delta": -80}]
                duration = 5
            elif "lanchar" in aid or "comer" in aid:
                effects = [{"stat": "hunger", "delta": -25}]
                duration = 15
            else:
                effects = [{"stat": "mood", "delta": 2}]
        elif cat == "food":
            effects = [{"stat": "hunger", "delta": -20}, {"stat": "bladder", "delta": 5}]
            duration = 15
        elif cat == "cook":
            effects = [{"stat": "hunger", "delta": -30}, {"stat": "culture", "delta": 3}]
            duration = 30
        elif cat == "crime":
            effects = [{"stat": "crime", "delta": 8}, {"stat": "mood", "delta": 3}]
            duration = 10
        elif cat == "kindness":
            effects = [{"stat": "kindness", "delta": 5}, {"stat": "mood", "delta": 2}]
        elif cat == "dance":
            effects = [{"stat": "dance", "delta": 5}, {"stat": "fitness", "delta": 2}]
            duration = 30
        elif cat == "fitness":
            effects = [{"stat": "fitness", "delta": 6}, {"stat": "hygiene", "delta": -5}]
            duration = 20
        elif cat == "beauty":
            effects = [{"stat": "sex_appeal", "delta": 3}, {"stat": "self_esteem", "delta": 2}]
            duration = 15
        elif cat == "work":
            effects = [{"stat": "mood", "delta": -2}]
            duration = 60
        elif cat == "animals":
            effects = [{"stat": "kindness", "delta": 3}, {"stat": "mood", "delta": 4}]
        elif cat == "phone":
            effects = [{"stat": "social", "delta": 1}]
            duration = 3
        else:
            effects = [{"stat": "mood", "delta": 1}]
            duration = 10

        entry = {
            "id": aid,
            "legacyId": idx,
            "name": f"@act.{aid}",
            "target": "object",
            "animation": aid.split("_")[0],
            "durationMinutes": duration,
            "advancesTime": duration >= 15,
            "effects": effects,
            "event": "used_object",
        }
        by_cat[cat].append(entry)

    for cat, arr in by_cat.items():
        if arr:
            write_json(f"interactions/{cat}.json", arr, force=True)

    # social actions from pack10
    social = [
        {"id": "talk_topic", "name": "@act.talk_topic", "target": "npc", "menu": "talk", "animation": "talk", "durationMinutes": 3, "relationship": {"friendship": 2, "mood": 2}, "event": "talked_to"},
        {"id": "talk_joke", "name": "@act.talk_joke", "target": "npc", "menu": "talk", "animation": "talk", "durationMinutes": 2, "relationship": {"friendship": 3, "mood": 5}, "event": "talked_to"},
        {"id": "talk_talent", "name": "@act.talk_talent", "target": "npc", "menu": "talk", "animation": "talk", "durationMinutes": 3, "relationship": {"friendship": 2, "mood": 3}, "event": "talked_to"},
        {"id": "offer_gift", "name": "@act.offer_gift", "target": "npc", "menu": "offer", "animation": "give", "durationMinutes": 2, "relationship": {"friendship": 5, "romance": 2}, "event": "gift_given"},
        {"id": "offer_trade", "name": "@act.offer_trade", "target": "npc", "menu": "offer", "animation": "give", "durationMinutes": 3, "event": "traded"},
        {"id": "flirt_cheek", "name": "@act.flirt_cheek", "target": "npc", "menu": "flirt", "animation": "kiss", "durationMinutes": 2, "requires": {"friendshipLevel": {">=": 1}}, "relationship": {"romance": 6, "mood": 4}, "event": "flirted"},
        {"id": "flirt_kiss_lips", "name": "@act.flirt_kiss_lips", "target": "npc", "menu": "flirt", "animation": "kiss", "durationMinutes": 3, "requires": {"friendshipLevel": {">=": 2}}, "relationship": {"romance": 12, "mood": 6}, "event": "flirted"},
        {"id": "flirt_makeout", "name": "@act.flirt_makeout", "target": "npc", "menu": "flirt", "animation": "kiss", "durationMinutes": 10, "requires": {"romance": {">=": 40}}, "relationship": {"romance": 18}, "event": "flirted"},
        {"id": "flirt_date", "name": "@act.flirt_date", "target": "npc", "menu": "flirt", "animation": "talk", "durationMinutes": 5, "requires": {"romance": {">=": 25}}, "event": "date_asked"},
        {"id": "offend_insult", "name": "@act.offend_insult", "target": "npc", "menu": "offend", "animation": "talk", "durationMinutes": 2, "relationship": {"friendship": -8, "mood": -10}, "event": "offended"},
        {"id": "offend_fight", "name": "@act.offend_fight", "target": "npc", "menu": "offend", "animation": "fight", "durationMinutes": 5, "relationship": {"friendship": -20, "mood": -15}, "effects": [{"stat": "crime", "delta": 5}], "event": "fought"},
        {"id": "offend_prank", "name": "@act.offend_prank", "target": "npc", "menu": "offend", "animation": "talk", "durationMinutes": 3, "relationship": {"friendship": -4, "mood": -5}, "effects": [{"stat": "craziness", "delta": 5}], "event": "offended"},
        {"id": "offend_lie", "name": "@act.offend_lie", "target": "npc", "menu": "offend", "animation": "talk", "durationMinutes": 2, "relationship": {"friendship": -6}, "event": "offended"},
    ]
    # keep talk_compliment preserved separately
    write_json("interactions/social.json", social, force=True)


def gen_items() -> None:
    p12 = parse_pack("pack12_objetos_interativos.txt")
    # map legacy object → item template + default actions
    templates = []
    action_hints = {
        "cama": ["sleep", "nap", "jump_on_bed", "make_bed"],
        "chuveiro": ["take_shower"],
        "banheiro": ["use_toilet"],
        "pia": ["wash_up"],
        "geladeira": ["snack", "drink_milk"],
        "cozinha": ["cook_burger", "cook_salad", "wash_dishes"],
        "closet": ["change_clothes"],
        "telefone": ["call_mom", "send_message"],
        "planta": ["water_plant"],
        "caixa_de_correio": ["steal_mail", "read_news"],
        "lixeira": ["throw_trash", "eat_trash"],
        "banco": ["watch_people", "relax"],
        "espreguicadeira": ["sunbathe", "relax"],
        "areia_da_praia": ["dig", "sunbathe"],
        "sofa": ["relax", "nap", "watch_tv"],
        "tv": ["watch_tv", "play_videogame"],
        "computador": ["check_email", "watch_funny_videos"],
        "bar": ["special_drink", "serve_drinks"],
        "mesa_do_dj": ["mix_music"],
        "cartazes": ["post_posters", "trash_posters"],
        "caixa_automatico": ["atm"],
        "anão": ["pick_up_gnome", "place_gnome"],
        "cao": ["feed_animal", "play", "train_sit"],
        "gato": ["feed_animal", "play"],
        "piano": ["play_piano"],
        "piscina": ["swim"],
        "banco_supino": ["lift_weights"],
        "sala_de_cirurgia": ["lipo", "rhinoplasty", "lifting", "implants"],
    }

    for idx, raw in sorted(p12.items()):
        name = strip_mf(raw)
        iid = slug(name, f"obj_{idx}")
        # skip ones already curated with different ids
        curated_aliases = {
            "cama": "bed_standard", "chuveiro": "shower", "banheiro": "toilet",
            "geladeira": "fridge", "cozinha": "kitchen", "closet": "closet",
            "telefone": "phone", "planta": "plant", "caixa_de_correio": "mailbox",
            "banco": "bench", "lixeira": "trash_can", "anão": "gnome", "flores": "flowers",
        }
        if iid in curated_aliases:
            continue
        acts = []
        for key, alist in action_hints.items():
            if key in iid:
                acts = alist
                break
        if not acts:
            acts = ["use"]
        kind = "prop"
        if any(k in iid for k in ("cama", "sofa", "tv", "computador", "cadeira", "comoda")):
            kind = "furniture"
        elif any(k in iid for k in ("hamburguer", "pizza", "comida", "cafe", "vitamina", "sorvete")):
            kind = "food"
        templates.append({
            "id": iid,
            "legacyId": idx,
            "name": f"@item.{iid}",
            "kind": kind,
            "footprint": [1, 1],
            "actions": acts,
            "price": 0,
        })

    # sun lounger alias used in south_beach
    templates.append({
        "id": "sun_lounger", "name": "@item.sun_lounger", "kind": "prop",
        "footprint": [1, 2], "actions": ["sunbathe", "relax"], "price": 0,
    })
    templates.append({
        "id": "beach_sand", "name": "@item.beach_sand", "kind": "prop",
        "footprint": [2, 2], "actions": ["dig", "sunbathe"], "price": 0,
    })
    templates.append({
        "id": "bar", "name": "@item.bar", "kind": "prop",
        "footprint": [2, 1], "actions": ["special_drink", "serve_drinks"], "price": 0,
    })
    templates.append({
        "id": "dj_desk", "name": "@item.dj_desk", "kind": "prop",
        "footprint": [2, 1], "actions": ["mix_music"], "price": 0,
    })
    templates.append({
        "id": "cell_door", "name": "@item.cell_door", "kind": "prop",
        "footprint": [1, 1], "actions": ["visit_room", "steal_keys"], "price": 0,
    })
    templates.append({
        "id": "keys", "name": "@item.keys", "kind": "quest",
        "footprint": [1, 1], "actions": ["steal_keys"], "price": 0,
    })
    templates.append({
        "id": "pizza", "name": "@item.pizza", "kind": "food",
        "footprint": [1, 1], "actions": ["eat", "deliver_pizza"], "price": 12,
    })
    templates.append({
        "id": "food", "name": "@item.food", "kind": "food",
        "footprint": [1, 1], "actions": ["eat"], "price": 8,
    })

    # furniture set (60 conceptually — compact catalog)
    furniture = []
    for cat, base_price, count in [
        ("sofa", 200, 3), ("bed", 150, 3), ("dresser", 120, 4),
        ("tv", 180, 2), ("cushion", 40, 4), ("computer", 250, 2), ("chair", 80, 2),
    ]:
        for i in range(count):
            furniture.append({
                "id": f"{cat}_{i+1}",
                "name": f"@item.{cat}_{i+1}",
                "kind": "furniture",
                "category": cat if cat != "dresser" else "dresser",
                "footprint": [2, 2] if cat in ("sofa", "bed") else [1, 1],
                "price": base_price + i * 50,
                "sellPrice": (base_price + i * 50) // 3,
                "shop": "furniture_store",
                "colors": ["green", "blue", "red", "yellow", "orange", "white"],
                "actions": ["relax"] if cat in ("sofa", "chair", "cushion") else (
                    ["sleep", "nap"] if cat == "bed" else (
                        ["watch_tv"] if cat == "tv" else (
                            ["check_email"] if cat == "computer" else ["use"]
                        )
                    )
                ),
            })

    # clothes compact
    clothes = []
    for kind, n in [("hair", 30), ("top", 31), ("bottom", 30), ("shoes", 13)]:
        for i in range(n):
            clothes.append({
                "id": f"cloth_{kind}_{i}",
                "name": f"@item.cloth_{kind}_{i}",
                "kind": "clothing",
                "slot": kind,
                "variant": i,
                "price": 20 + i * 2,
                "shop": "boutique",
                "colors": 6,
            })

    # quest items
    quest_items = [
        {"id": "quest_keys", "name": "@item.quest_keys", "kind": "quest"},
        {"id": "quest_cigars", "name": "@item.quest_cigars", "kind": "quest"},
        {"id": "quest_posters", "name": "@item.quest_posters", "kind": "quest"},
        {"id": "quest_box", "name": "@item.quest_box", "kind": "quest"},
        {"id": "quest_id", "name": "@item.quest_id", "kind": "quest"},
        {"id": "quest_treasure_map", "name": "@item.quest_treasure_map", "kind": "quest"},
        {"id": "quest_ticket", "name": "@item.quest_ticket", "kind": "quest"},
    ]
    for i in range(1, 8):
        quest_items.append({"id": f"gnome_{i}", "name": f"@item.gnome_{i}", "kind": "quest", "actions": ["pick_up_gnome", "place_gnome"]})

    # pets
    pets = [
        {"id": "dog_scottish", "name": "@item.dog_scottish", "kind": "pet", "species": "dog", "price": 200},
        {"id": "dog_bulldog", "name": "@item.dog_bulldog", "kind": "pet", "species": "dog", "price": 250},
        {"id": "dog_beagle", "name": "@item.dog_beagle", "kind": "pet", "species": "dog", "price": 180},
        {"id": "cat_house", "name": "@item.cat_house", "kind": "pet", "species": "cat", "price": 100},
    ]

    write_json("items/world_props.json", templates, force=True)
    write_json("items/furniture_catalog.json", furniture, force=True)
    write_json("items/clothing_catalog.json", clothes, force=True)
    write_json("items/quest_items.json", quest_items, force=True)
    write_json("items/pets.json", pets, force=True)
    # gifts also as items
    gift_items = [
        {"id": "gift_special_drink", "name": "@gift.special_drink", "kind": "gift", "price": 5},
        {"id": "gift_flowers", "name": "@gift.flowers", "kind": "gift", "price": 10},
        {"id": "gift_cash", "name": "@gift.cash", "kind": "gift", "price": 20},
        {"id": "gift_sexy", "name": "@gift.sexy", "kind": "gift", "price": 50},
        {"id": "gift_polo", "name": "@gift.polo", "kind": "gift", "price": 15},
        {"id": "gift_ticket", "name": "@gift.ticket", "kind": "gift", "price": 20},
        {"id": "gift_lingerie", "name": "@gift.lingerie", "kind": "gift", "price": 25},
        {"id": "gift_vitamin", "name": "@gift.vitamin", "kind": "gift", "price": 8},
    ]
    write_json("items/gifts.json", gift_items, force=True)


def gen_quests() -> None:
    p18 = parse_pack("pack18_missoes.txt")
    # triples: sender, title, text — 99 missions × 3 = 297 entries (0..296)
    quests = []
    for q in range(99):
        base = q * 3
        sender = strip_mf(p18.get(base, "MN2"))
        title = strip_mf(p18.get(base + 1, f"Missão {q}"))
        text = strip_mf(p18.get(base + 2, ""))
        qid = f"q{q:03d}_{slug(title, str(q))}"
        # preserve landlord/gnomes curated
        if q in (13, 17, 28, 97):  # friendship landlord, know apt, gnomes, gnome reward — keep aliases
            pass
        quests.append({
            "id": qid,
            "legacyId": q,
            "sender": sender,
            "title": f"@q{q:03d}.title",
            "text": f"@q{q:03d}.text",
            "chapter": "main" if q < 50 else "late",
            "start": "start",
            "stages": {
                "start": {
                    "objective": f"@q{q:03d}.obj",
                    "transitions": [
                        {"when": {"event": "quest_advance", "quest": qid}, "to": "done"}
                    ],
                },
                "done": {"final": True},
            },
        })
        # string keys collected later
    # write as batches of 20
    for i in range(0, 99, 20):
        chunk = quests[i : i + 20]
        write_json(f"quests/batch_{i:03d}.json", chunk, force=True)

    # alias stubs pointing story beats to curated quests (optional refs)
    write_json(
        "quests/aliases.json",
        {
            "id": "quest_aliases",
            "map": {
                "q013_landlord_friend": "q_landlord",
                "q017_know_apartment": "q_landlord",
                "q028_gnomes": "q_gnomes",
                "q097_gnome_reward": "q_gnomes",
            },
        },
        force=True,
    )


def gen_dialogue() -> None:
    p20 = parse_pack("pack20_interesses.txt")
    p21 = parse_pack("pack21_falas_de_topico.txt")
    p22 = parse_pack("pack22_reacoes_ofendidas.txt")
    p23 = parse_pack("pack23_reacoes_de_tedio.txt")
    p24 = parse_pack("pack24_categorias_de_assunto.txt")
    p27 = parse_pack("pack27_saudacoes.txt")

    # 38 categories; interests distributed
    interests = [{"id": f"interest_{i}", "name": strip_mf(t), "key": f"@interest.{i}"} for i, t in sorted(p20.items())]
    # assign interests to categories round-robin
    cats = []
    for i, t in sorted(p24.items()):
        cid = INTEREST_CATS[i] if i < len(INTEREST_CATS) else slug(t, f"cat_{i}")
        owned = [interests[j]["id"] for j in range(len(interests)) if j % 38 == i]
        lines = []
        # sample topic lines from pack21 — take every 38th starting at i
        for j in range(i, min(len(p21), 845), 38):
            if j in p21:
                lines.append(strip_mf(p21[j]))
            if len(lines) >= 8:
                break
        if not lines:
            lines = ["Interessante…", "Pois é.", "Concordo.", "Discordo um pouco."]
        cats.append({
            "id": cid,
            "name": f"@topic.{cid}",
            "label": strip_mf(t),
            "interests": owned,
            "lines": lines,
        })

    write_json(
        "dialogue/topics.json",
        {
            "id": "topics",
            "categories": cats,
            "interestCount": len(interests),
            "interests": interests,
        },
        force=True,
    )

    write_json(
        "dialogue/reactions.json",
        {
            "id": "reactions",
            "offended": [strip_mf(p22[i]) for i in sorted(p22)],
            "bored": [strip_mf(p23[i]) for i in sorted(p23)],
            "greetings": {
                "default": [strip_mf(p27[i]) for i in range(0, min(10, len(p27)))],
                "grumpy": [strip_mf(p27[i]) for i in range(10, min(15, len(p27)))],
                "dirty": [strip_mf(p27[i]) for i in range(15, min(20, len(p27)))],
            },
        },
        force=True,
    )


def gen_jobs() -> None:
    jobs = [
        {
            "id": "extra",
            "name": "@job.extra",
            "location": "stadium",
            "pay": 40,
            "durationMinutes": 120,
            "requires": {"charisma": 1},
            "effects": [{"stat": "mood", "delta": -5}, {"stat": "fitness", "delta": 2}],
            "minigame": None,
            "unlockQuest": "q024_figurante",
        },
        {
            "id": "ad_assistant",
            "name": "@job.ad_assistant",
            "location": "newspaper_office",
            "pay": 55,
            "durationMinutes": 90,
            "requires": {"culture": 1},
            "effects": [{"stat": "culture", "delta": 2}],
            "minigame": "posters",
            "unlockQuest": "q025_publicidade",
        },
        {
            "id": "bartender",
            "name": "@job.bartender",
            "location": "glight_club",
            "pay": 50,
            "durationMinutes": 120,
            "requires": {"charisma": 2},
            "effects": [{"stat": "social", "delta": 3}],
            "minigame": None,
            "unlockQuest": "q026_bartender",
        },
        {
            "id": "pizza_delivery",
            "name": "@job.pizza_delivery",
            "location": "yuca_restaurant",
            "pay": 45,
            "durationMinutes": 60,
            "requires": {"fitness": 1},
            "effects": [{"stat": "fitness", "delta": 3}, {"stat": "hygiene", "delta": -5}],
            "minigame": None,
            "unlockQuest": "q027_entregador",
        },
    ]
    for j in jobs:
        write_json(f"jobs/{j['id']}.json", j, force=True)


def gen_schedules() -> None:
    schedules = [
        {
            "id": "landlord_visit",
            "entries": [
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 8, "endHour": 12, "location": "player_apartment", "activity": "idle"},
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 12, "endHour": 18, "location": "first_street", "activity": "wander"},
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 18, "endHour": 22, "location": "player_apartment", "activity": "idle"},
            ],
        },
        {
            "id": "generic_wander",
            "entries": [
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 9, "endHour": 21, "location": "*", "activity": "wander"},
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 21, "endHour": 9, "location": "home", "activity": "sleep"},
            ],
        },
        {
            "id": "huggy_beach",
            "entries": [
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 10, "endHour": 20, "location": "south_beach", "activity": "loiter"},
            ],
        },
        {
            "id": "dj_club",
            "entries": [
                {"days": [4, 5, 6], "startHour": 21, "endHour": 4, "location": "glight_club", "activity": "dj"},
                {"days": [0, 1, 2, 3], "startHour": 14, "endHour": 18, "location": "glight_club", "activity": "idle"},
            ],
        },
        {
            "id": "charm_club",
            "entries": [
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 18, "endHour": 4, "location": "glight_club", "activity": "manage"},
            ],
        },
        {
            "id": "inspector_station",
            "entries": [
                {"days": [0, 1, 2, 3, 4], "startHour": 8, "endHour": 18, "location": "police_station", "activity": "work"},
            ],
        },
        {
            "id": "guard_station",
            "entries": [
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 0, "endHour": 24, "location": "police_station", "activity": "guard"},
            ],
        },
        {
            "id": "hal_restaurant",
            "entries": [
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 10, "endHour": 22, "location": "yuca_restaurant", "activity": "work"},
            ],
        },
    ]
    existing_ids = {s["id"] for s in schedules}
    for nid, _slot, _gender, home, *_rest in STORY_NPCS:
        sid = f"{nid}_default"
        if sid in existing_ids:
            continue
        schedules.append({
            "id": sid,
            "entries": [
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 9, "endHour": 18, "location": home, "activity": "idle"},
                {"days": [0, 1, 2, 3, 4, 5, 6], "startHour": 18, "endHour": 23, "location": home, "activity": "social"},
            ],
        })
        existing_ids.add(sid)

    for s in schedules:
        write_json(f"schedules/{s['id']}.json", s, force=True)


def gen_strings() -> None:
    path = CONTENT / "strings/pt-BR.json"
    data = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}

    # locations
    p13 = parse_pack("pack13_locais_e_acoes_de_objeto.txt")
    loc_names_from_pack = {
        "first_street": p13.get(2, "First Street"),
        "police_station": p13.get(3, "Delegacia"),
        "glight_club": p13.get(4, "Glight Club"),
        "newspaper_office": p13.get(5, "Escritório do Jornal"),
        "stadium": p13.get(6, "Estádio"),
        "beauty_clinic": p13.get(7, "Clínica de Beleza"),
        "heather_dean_apartment": strip_mf(p13.get(8, "Apartamento")),
        "grand_avenue": p13.get(9, "Grand Avenue"),
        "lounge": p13.get(10, "Lounge"),
        "south_beach": p13.get(11, "South Beach"),
        "cuban_cafe": p13.get(12, "Cuban Cafe"),
        "little_havana": p13.get(13, "Little Havana"),
        "yuca_restaurant": p13.get(14, "Restaurante"),
        "ocean_drive": p13.get(15, "Ocean Drive"),
        "player_apartment": p13.get(16, "Apartamento"),
        "pelican_port": p13.get(18, "Pelican Port"),
        "yacht": p13.get(19, "Iate"),
        "everglades": p13.get(20, "Everglades"),
        "mansion": p13.get(21, "Mansão"),
        "downtown": p13.get(22, "Downtown"),
        "coconut_grove": p13.get(23, "Coconut Grove"),
        "miami_beach": p13.get(24, "Miami Beach"),
        "pelican_island": p13.get(26, "Pelican Island"),
        "key_biscayne": p13.get(27, "Key Biscayne"),
        "npc_apartment": "Apartamento de amigo",
        "apartment_garden": "Jardim do prédio",
    }
    for lid, name in loc_names_from_pack.items():
        data[f"loc.{lid}"] = strip_mf(name)

    for rid, label in [
        ("downtown", "Downtown"), ("south_beach", "South Beach"), ("little_havana", "Little Havana"),
        ("ocean_drive", "Ocean Drive"), ("coconut_grove", "Coconut Grove"), ("miami_beach", "Miami Beach / Light House"),
        ("pelican_island", "Pelican Island"), ("key_biscayne", "Key Biscayne"), ("everglades", "Everglades"),
    ]:
        data[f"region.{rid}"] = label

    # NPCs
    p11 = parse_pack("pack11_nomes_de_npc.txt")
    for nid, slot, *_ in STORY_NPCS:
        data[f"npc.{nid}"] = strip_mf(p11.get(slot, nid))
    for slot in range(23, 84):
        raw = strip_mf(p11.get(slot, f"NPC {slot}"))
        nid = f"generic_{slot}_{slug(raw, str(slot))}"
        data[f"npc.{nid}"] = raw

    # actions from interactions folder will be filled by slug of pack13
    for idx in range(28, 167):
        raw = strip_mf(p13.get(idx, f"Ação {idx}"))
        aid = act_id_from_name(idx, raw)
        data[f"act.{aid}"] = raw.title() if raw == raw.upper() else raw

    # social
    for k, v in {
        "talk_topic": "Assunto", "talk_joke": "Piada", "talk_talent": "Talento",
        "offer_gift": "Presente", "offer_trade": "Trocar",
        "flirt_cheek": "Beijo no rosto", "flirt_kiss_lips": "Beijo na boca",
        "flirt_makeout": "Amasso", "flirt_date": "Sair junto",
        "offend_insult": "Insulto", "offend_fight": "Brigar",
        "offend_prank": "Brincadeira", "offend_lie": "Enganar",
        "sunbathe": "Bronzear-se", "use": "Usar", "watch_tv": "Ver TV",
        "play_videogame": "Jogar videogame", "check_email": "Checar email",
        "watch_funny_videos": "Vídeos engraçados", "special_drink": "Bebida especial",
        "serve_drinks": "Servir bebidas", "mix_music": "Mixar música",
        "post_posters": "Colar cartazes", "trash_posters": "Jogar cartazes fora",
        "atm": "Caixa automático", "visit_room": "Sala de visitas",
        "steal_keys": "Roubar chaves", "eat": "Comer", "deliver_pizza": "Entregar pizza",
        "dig": "Cavar", "play_piano": "Tocar piano", "swim": "Nadar",
        "lift_weights": "Levantar pesos", "feed_animal": "Alimentar",
        "play": "Brincar", "train_sit": "Treinar: sentar",
        "read_news": "Ler notícias", "send_message": "Enviar mensagem",
        "lipo": "Lipoaspiração", "rhinoplasty": "Rinoplastia",
        "lifting": "Lifting", "implants": "Implantes",
    }.items():
        data[f"act.{k}"] = v

    # gifts / surgery / jobs / achievements
    for k, v in {
        "gift.special_drink": "Bebida Especial", "gift.flowers": "Flores",
        "gift.cash": "Dinheiro", "gift.sexy": "Presente Sexy",
        "gift.polo": "Camisa Pólo", "gift.ticket": "Ingresso",
        "gift.lingerie": "Lingerie", "gift.vitamin": "Vitamina",
        "surgery.lipo": "Lipoaspiração", "surgery.rhino": "Rinoplastia",
        "surgery.lifting": "Lifting", "surgery.implants": "Implantes de gelatina",
        "job.extra": "Figurante", "job.ad_assistant": "Assistente de Publicidade",
        "job.bartender": "Bartender", "job.pizza_delivery": "Entrega de Pizza",
        "item.sun_lounger": "Espreguiçadeira", "item.beach_sand": "Areia da praia",
        "item.bar": "Bar", "item.dj_desk": "Mesa do DJ", "item.cell_door": "Porta da cela",
        "item.keys": "Chaves", "item.pizza": "Pizza", "item.food": "Comida",
    }.items():
        data[k] = v

    p9 = parse_pack("pack09_conquistas_titulos.txt")
    ach_ids = [
        "bronze_medallion", "silver_medallion", "gold_medallion", "extra", "bartender",
        "ad_assistant", "gnome_lover", "gnome_beach", "gnome_gourmet", "gnome_police",
        "gnome_fashion", "gnome_degubas", "gnome_security", "black_skull", "delivery",
        "model_agent", "dj", "private_eye", "mafia_boss",
    ]
    for i, aid in enumerate(ach_ids):
        data[f"ach.{aid}"] = strip_mf(p9.get(i, aid))

    # quests strings
    p18 = parse_pack("pack18_missoes.txt")
    for q in range(99):
        base = q * 3
        data[f"q{q:03d}.title"] = strip_mf(p18.get(base + 1, f"Missão {q}"))
        data[f"q{q:03d}.text"] = strip_mf(p18.get(base + 2, ""))
        data[f"q{q:03d}.obj"] = strip_mf(p18.get(base + 1, f"Missão {q}"))

    # topic categories
    p24 = parse_pack("pack24_categorias_de_assunto.txt")
    for i, t in sorted(p24.items()):
        cid = INTEREST_CATS[i] if i < len(INTEREST_CATS) else slug(t, f"cat_{i}")
        data[f"topic.{cid}"] = strip_mf(t)

    p20 = parse_pack("pack20_interesses.txt")
    for i, t in sorted(p20.items()):
        data[f"interest.{i}"] = strip_mf(t)

    # item names from props
    p12 = parse_pack("pack12_objetos_interativos.txt")
    for idx, raw in sorted(p12.items()):
        iid = slug(strip_mf(raw), f"obj_{idx}")
        data[f"item.{iid}"] = strip_mf(raw).title() if strip_mf(raw) == strip_mf(raw).upper() else strip_mf(raw)

    data.setdefault("msg.rent_reminder", "Lembre-se de pagar o aluguel desta semana em um caixa automático.")
    data.setdefault("msg.rent_rules", "O aluguel é cobrado toda semana. Atrasos têm consequências.")
    data.setdefault("npc.generic", "Morador")

    write_json("strings/pt-BR.json", data, force=True)
    # stub en
    en = {k: f"[en] {v}" if not k.startswith("stat.") else v for k, v in data.items()}
    write_json("strings/en.json", en, force=True)


def main() -> None:
    assert STRINGS.exists(), STRINGS
    CONTENT.mkdir(parents=True, exist_ok=True)
    gen_pack_meta()
    gen_regions()
    gen_rent()
    gen_gifts()
    gen_surgery()
    gen_achievements()
    gen_locations()
    gen_npcs()
    gen_interactions()
    gen_items()
    gen_quests()
    gen_dialogue()
    gen_jobs()
    gen_schedules()
    gen_strings()
    print("OK content pack gerado em", CONTENT)


if __name__ == "__main__":
    main()
