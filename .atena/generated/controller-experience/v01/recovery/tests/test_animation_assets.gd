extends RefCounted

const ASSETS := {
	"res://assets/animations/enemies/lu_yueh/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/lu_yueh/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/lu_yueh/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/lu_yueh/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/lu_yueh/special.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/discipulo_pestilento/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/discipulo_pestilento/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/discipulo_pestilento/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/discipulo_pestilento/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_ghaunadaur/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_ghaunadaur/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_ghaunadaur/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_ghaunadaur/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/estatua_do_templo/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/estatua_do_templo/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/estatua_do_templo/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/estatua_do_templo/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_de_feng_tu/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_de_feng_tu/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_de_feng_tu/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_de_feng_tu/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/larva_de_lu_yueh/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/larva_de_lu_yueh/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/larva_de_lu_yueh/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/larva_de_lu_yueh/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/molydeus_chefe/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/molydeus_chefe/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/molydeus_chefe/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/molydeus_chefe/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/molydeus_chefe/special.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/ezro/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/ezro/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/ezro/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/ezro/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/aberracao_shu/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/aberracao_shu/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/aberracao_shu/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/aberracao_shu/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/carcereiro_de_pedra/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/carcereiro_de_pedra/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/carcereiro_de_pedra/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/carcereiro_de_pedra/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/demonio_de_gehenna/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/demonio_de_gehenna/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/demonio_de_gehenna/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/demonio_de_gehenna/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/alma_penada/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/alma_penada/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/alma_penada/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/alma_penada/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/zuggtmoy/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/zuggtmoy/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/zuggtmoy/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/zuggtmoy/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/zuggtmoy/special.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/receptaculo_de_juiblex/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/receptaculo_de_juiblex/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/receptaculo_de_juiblex/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/receptaculo_de_juiblex/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/gargula/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/gargula/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/gargula/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/gargula/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/pudim_negro/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/pudim_negro/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/pudim_negro/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/pudim_negro/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/slime_de_juiblex/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/slime_de_juiblex/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/slime_de_juiblex/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/slime_de_juiblex/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/esporo_voador/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/esporo_voador/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/esporo_voador/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/esporo_voador/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cogumelo_fungico/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cogumelo_fungico/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cogumelo_fungico/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cogumelo_fungico/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/servo_de_zuggtmoy/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/servo_de_zuggtmoy/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/servo_de_zuggtmoy/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/servo_de_zuggtmoy/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/blogbog/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/blogbog/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/blogbog/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/blogbog/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/blogbog/special.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_thullgrime/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_thullgrime/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_thullgrime/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_thullgrime/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/bolha_de_slime/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/bolha_de_slime/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/bolha_de_slime/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/bolha_de_slime/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/brook/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/brook/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/nyrelia/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/nyrelia/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/bromnor/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/bromnor/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/zynara/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/zynara/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/leoric/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/leoric/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/kayron/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/kayron/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/maelor/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/maelor/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/sylas/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/sylas/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/durvall/move.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/durvall/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/zumbi/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/zumbi/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/zumbi/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/zumbi/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_adaga/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_adaga/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/cultista_adaga/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/cultista_adaga/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/sacerdote_mente_derretida/idle.png": Vector2i(1920, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/move.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/attack.png": Vector2i(1920, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/special_a.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/special_b.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/phase.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/death.png": Vector2i(3200, 480),
	"res://assets/animations/interactions/chest_open.png": Vector2i(1152, 192),
	"res://assets/animations/interactions/fountain_active.png": Vector2i(1152, 192),
	"res://assets/animations/interactions/altar_active.png": Vector2i(1152, 192),
	"res://assets/animations/interactions/ritual.png": Vector2i(1536, 192),
	"res://assets/animations/interactions/portal.png": Vector2i(1536, 192),
}

const MINIMUM_VISIBLE_COVERAGE := {
	"res://assets/animations/heroes/brook/move_n.png": 0.01,
	"res://assets/animations/heroes/brook/move_ne.png": 0.01,
	"res://assets/animations/heroes/brook/move_e.png": 0.01,
	"res://assets/animations/heroes/brook/move_se.png": 0.01,
	"res://assets/animations/heroes/maelor/move_n.png": 0.01,
	"res://assets/animations/enemies/cultista_adaga/idle.png": 0.01,
	"res://assets/animations/enemies/cultista_adaga/move.png": 0.01,
	"res://assets/animations/enemies/cultista_adaga/attack.png": 0.01,
	"res://assets/animations/enemies/cultista_adaga/death.png": 0.01,
}

const WAVE_ONE_ENEMY_ANIMATIONS := {
	"lu_yueh": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6, &"special": 6}},
	"discipulo_pestilento": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"cultista_ghaunadaur": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"estatua_do_templo": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"cultista_de_feng_tu": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"larva_de_lu_yueh": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"molydeus_menor": {"source_id": "molydeus_chefe", "cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6, &"special": 6}},
	"molydeus_chefe": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6, &"special": 6}},
	"ezro": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"aberracao_shu": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"carcereiro_de_pedra": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"demonio_de_gehenna": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"alma_penada": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"zuggtmoy": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6, &"special": 6}},
	"receptaculo_de_juiblex": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"gargula": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"pudim_negro": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"slime_de_juiblex": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"esporo_voador": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"cogumelo_fungico": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"servo_de_zuggtmoy": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"blogbog": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6, &"special": 6}},
	"cultista_thullgrime": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"bolha_de_slime": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"slime_corrosivo": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"cultista_arqueiro": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"cultista_cajado": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"notivago": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"criatura_corrompida": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"arch_hag": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}},
	"tentaculo_kraken": {"cell": Vector2i(256, 384), "states": {&"idle": 4, &"attack": 4, &"death": 6}},
	"guardiao_verdadeiro": {"cell": Vector2i(320, 480), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"special": 6, &"death": 6}},
	"guardiao_copia": {"cell": Vector2i(320, 480), "states": {&"idle": 4, &"move": 6, &"attack": 4, &"special": 6, &"death": 6}},
}

const ANIMATED_ENEMY_IDS := ["zumbi", "cultista_adaga", "sacerdote_mente_derretida", "slime_corrosivo", "cultista_arqueiro", "cultista_cajado", "notivago", "criatura_corrompida", "arch_hag", "tentaculo_kraken", "guardiao_verdadeiro", "guardiao_copia"]

func run() -> Array[String]:
	var failures: Array[String] = []
	for path in ASSETS:
		if not FileAccess.file_exists(path):
			failures.append("asset ausente: %s" % path)
			continue
		if not ResourceLoader.exists(path):
			failures.append("asset não importado: %s" % path)
			continue
		var image := Image.new()
		if image.load(ProjectSettings.globalize_path(path)) != OK:
			failures.append("PNG inválido: %s" % path)
		elif image.get_size() != ASSETS[path]:
			failures.append("dimensão %s em %s; esperada %s" % [image.get_size(), path, ASSETS[path]])
		elif image.detect_alpha() == Image.ALPHA_NONE:
			failures.append("sem canal alfa: %s" % path)
		elif path in MINIMUM_VISIBLE_COVERAGE and _visible_coverage(image) < MINIMUM_VISIBLE_COVERAGE[path]:
			failures.append("conteúdo visível insuficiente: %s" % path)
	for scene_path in ["res://ui/hero_view.tscn", "res://ui/enemy_view.tscn"]:
		var packed: PackedScene = load(scene_path)
		if packed == null:
			failures.append("cena inválida: %s" % scene_path)
			continue
		var instance := packed.instantiate()
		if instance.get_node_or_null("AnimatedSprite2D") == null:
			failures.append("AnimatedSprite2D ausente: %s" % scene_path)
		instance.free()
	var hero_script: Script = load("res://ui/hero_view.gd")
	var directions := {
		Vector2.UP: &"move_n", Vector2(1, -1): &"move_ne", Vector2.RIGHT: &"move_e", Vector2(1, 1): &"move_se",
		Vector2.DOWN: &"move_s", Vector2(-1, 1): &"move_sw", Vector2.LEFT: &"move_w", Vector2(-1, -1): &"move_nw",
	}
	for direction in directions:
		if hero_script.directional_walk_animation(direction) != directions[direction]:
			failures.append("direção incorreta para %s" % direction)
	var southwest_input: Vector2 = Hero.movement_input(true, false, false, true)
	var mirrors := {
		Vector2.LEFT: &"move_e", Vector2(-1, -1): &"move_ne", Vector2(-1, 1): &"move_se",
	}
	for direction in mirrors:
		if hero_script.walk_animation_for_direction(direction) != mirrors[direction]:
			failures.append("espelhamento incorreto para %s" % direction)
		if not hero_script.walk_flips_horizontally(direction):
			failures.append("espelhamento horizontal ausente para %s" % direction)
	if hero_script.walk_flips_horizontally(Vector2.RIGHT):
		failures.append("move_e nao deveria ser espelhado")
	if southwest_input != Vector2(-1, 1):
		failures.append("A+S não resolve para baixo e esquerda: %s" % southwest_input)
	var hero := Hero.new()
	for index in 8:
		var direction := Vector2.RIGHT.rotated(index * PI / 4.0)
		if hero_script.uses_procedural_walk_for_direction("korrak", direction):
			failures.append("Korrak deve andar com as tiras validadas nas oito direções (sem deslizar com o idle)")
	hero.map_size = Vector2(100, 100)
	hero.pos = Vector2(50, 50)
	var before := Iso.to_screen(hero.pos)
	hero.step(southwest_input, 1.0 / 60.0)
	var southwest_delta := Iso.to_screen(hero.pos) - before
	if hero_script.directional_walk_animation(southwest_delta) != &"move_sw":
		failures.append("A+S não seleciona move_sw após o deslocamento: %s" % southwest_delta)
	failures.append_array(_validate_static_enemy_assets())
	failures.append_array(_validate_cultista_adaga_runtime())
	failures.append_array(_validate_wave_one_enemy_assets())
	failures.append_array(_validate_wave_one_enemy_runtime())
	failures.append_array(_validate_bromnor_runtime())
	failures.append_array(_validate_zynara_runtime())
	failures.append_array(_validate_nyrelia_runtime())
	failures.append_array(_validate_nyrelia_frame_baselines())
	failures.append_array(_validate_hero_walk_stability())
	failures.append_array(_validate_hero_display_scale())
	return failures

## Dívida conhecida de caminhada (EVID-146 / BUG-025 / ART-PROMPTS-055): massa fora de ±30% do idle
## ou quadro colado na borda. Só pode encolher: ao regerar a tira, remova a entrada.
const WALK_KNOWN_MASS := []
const WALK_KNOWN_EDGE := []

func _validate_hero_walk_stability() -> Array[String]:
	var failures: Array[String] = []
	for hero_id in Data.table("heroes"):
		var idle := _walk_metrics("res://assets/animations/heroes/%s/idle.png" % hero_id)
		if idle.is_empty():
			continue
		for direction in ["n", "ne", "e", "se", "s"]:
			var key := "%s/move_%s" % [hero_id, direction]
			var strip := _walk_metrics("res://assets/animations/heroes/%s/move_%s.png" % [hero_id, direction])
			if strip.is_empty():
				failures.append("caminhada ausente ou ilegível: %s" % key)
				continue
			var mass_bad := false
			var edge_bad := false
			for frame in strip.frames:
				if absf(float(frame.height) / float(idle.height) - 1.0) > 0.16:
					failures.append("altura de %s muda ao andar: %d px contra %d do idle" % [key, frame.height, idle.height])
					break
			for frame in strip.frames:
				if absi(frame.bottom - idle.bottom) > 6:
					failures.append("pés de %s fora da linha de base do idle: %d contra %d" % [key, frame.bottom, idle.bottom])
					break
			for frame in strip.frames:
				var mass_ratio := float(frame.mass) / float(idle.mass)
				mass_bad = mass_bad or mass_ratio < 0.70 or mass_ratio > 1.30
				edge_bad = edge_bad or frame.edge
			if mass_bad and not WALK_KNOWN_MASS.has(key):
				failures.append("massa de %s fora de ±30%% do idle (corpo engorda/afina ao andar)" % key)
			if edge_bad and not WALK_KNOWN_EDGE.has(key):
				failures.append("conteúdo de %s toca a borda da célula (arma/capa cortada)" % key)
	return failures

func _walk_metrics(path: String) -> Dictionary:
	var image := Image.new()
	if image.load(ProjectSettings.globalize_path(path)) != OK:
		return {}
	image.convert(Image.FORMAT_RGBA8)
	var frames: Array = []
	var heights: Array[int] = []
	var bottoms: Array[int] = []
	var masses: Array[int] = []
	for index in image.get_width() / 256:
		var left := 256
		var top := 384
		var right := -1
		var bottom := -1
		var mass := 0
		for y in 384:
			for x in 256:
				if image.get_pixel(index * 256 + x, y).a < 0.10:
					continue
				mass += 1
				left = mini(left, x)
				top = mini(top, y)
				right = maxi(right, x)
				bottom = maxi(bottom, y)
		if right < left:
			continue
		frames.append({"height": bottom - top + 1, "bottom": bottom + 1, "mass": mass, "edge": left <= 1 or top <= 1 or right >= 254 or bottom >= 382})
		heights.append(bottom - top + 1)
		bottoms.append(bottom + 1)
		masses.append(mass)
	if frames.is_empty():
		return {}
	heights.sort()
	bottoms.sort()
	masses.sort()
	return {"frames": frames, "height": heights[heights.size() / 2], "bottom": bottoms[bottoms.size() / 2], "mass": masses[masses.size() / 2]}

func _validate_cultista_adaga_runtime() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual do cultista de adaga"]
	var enemy_view: Node2D = packed.instantiate()
	tree.root.add_child(enemy_view)
	enemy_view.setup(Enemy.make("cultista_adaga", Vector2.ZERO))
	var sprite := enemy_view.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null or sprite.sprite_frames == null:
		failures.append("cultista de adaga não recebeu AnimatedSprite2D")
	else:
		var expected := {&"idle": 4, &"move": 6, &"attack": 4, &"death": 6}
		for animation in expected:
			if not sprite.sprite_frames.has_animation(animation):
				failures.append("animação do cultista ausente: %s" % animation)
			elif sprite.sprite_frames.get_frame_count(animation) != expected[animation]:
				failures.append("contagem incorreta em cultista/%s" % animation)
		var start := enemy_view.position
		enemy_view.sync_visual(start + Vector2(-1, 0))
		if sprite.animation != &"move" or not sprite.flip_h:
			failures.append("movimento do cultista para a esquerda não foi espelhado")
		enemy_view.play_action(&"attack")
		if sprite.animation != &"attack" or sprite.flip_h:
			failures.append("ataque do cultista manteve espelhamento de movimento")
		enemy_view.play_death()
		if sprite.animation != &"death" or sprite.flip_h:
			failures.append("morte do cultista não iniciou na orientação-base")
	enemy_view.queue_free()
	return failures

func _validate_wave_one_enemy_assets() -> Array[String]:
	var failures: Array[String] = []
	for enemy_id in WAVE_ONE_ENEMY_ANIMATIONS:
		var spec: Dictionary = WAVE_ONE_ENEMY_ANIMATIONS[enemy_id]
		var source_id := String(spec.get("source_id", enemy_id))
		var cell: Vector2i = spec.cell
		for state in spec.states:
			var count: int = int(spec.states[state])
			var path := "res://assets/animations/enemies/%s/%s.png" % [source_id, state]
			if not FileAccess.file_exists(path):
				failures.append("asset da Onda 1 ausente: %s" % path)
				continue
			if not ResourceLoader.exists(path):
				failures.append("asset da Onda 1 não importado: %s" % path)
				continue
			var image := Image.new()
			if image.load(ProjectSettings.globalize_path(path)) != OK:
				failures.append("PNG inválido da Onda 1: %s" % path)
			elif image.get_size() != Vector2i(cell.x * count, cell.y):
				failures.append("dimensão incorreta da Onda 1: %s" % path)
			elif image.detect_alpha() == Image.ALPHA_NONE:
				failures.append("asset da Onda 1 sem canal alfa: %s" % path)
	return failures

func _validate_wave_one_enemy_runtime() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar os visuais da Onda 1"]
	for enemy_id in WAVE_ONE_ENEMY_ANIMATIONS:
		var spec: Dictionary = WAVE_ONE_ENEMY_ANIMATIONS[enemy_id]
		var enemy_view: Node2D = packed.instantiate()
		tree.root.add_child(enemy_view)
		enemy_view.setup(Enemy.make(enemy_id, Vector2.ZERO))
		var sprite := enemy_view.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
		if sprite == null or sprite.sprite_frames == null:
			failures.append("%s não recebeu AnimatedSprite2D" % enemy_id)
		else:
			for animation in spec.states:
				if not sprite.sprite_frames.has_animation(animation):
					failures.append("animação ausente em %s/%s" % [enemy_id, animation])
				elif sprite.sprite_frames.get_frame_count(animation) != int(spec.states[animation]):
					failures.append("contagem incorreta em %s/%s" % [enemy_id, animation])
			if spec.states.has(&"move"):
				enemy_view.sync_visual(enemy_view.position + Vector2.LEFT)
				if sprite.animation != &"move" or not sprite.flip_h:
					failures.append("movimento à esquerda não foi espelhado: %s" % enemy_id)
			enemy_view.play_action(&"attack")
			if sprite.animation != &"attack" or sprite.flip_h:
				failures.append("ataque não usa orientação-base: %s" % enemy_id)
			if spec.states.has(&"special"):
				enemy_view.play_action(&"special")
				if sprite.animation != &"special":
					failures.append("special não é reproduzível: %s" % enemy_id)
			enemy_view.play_death()
			if sprite.animation != &"death" or sprite.flip_h:
				failures.append("morte não usa orientação-base: %s" % enemy_id)
		enemy_view.queue_free()
	return failures

func _validate_static_enemy_assets() -> Array[String]:
	var failures: Array[String] = []
	var enemies: Dictionary = Data.table("enemies")
	for value in enemies:
		var enemy_id := String(value)
		var path := "res://assets/enemies/%s.png" % enemy_id
		if not FileAccess.file_exists(path):
			failures.append("imagem estática ausente: %s" % path)
			continue
		if not ResourceLoader.exists(path):
			failures.append("imagem estática não importada: %s" % path)
			continue
		var image := Image.new()
		if image.load(ProjectSettings.globalize_path(path)) != OK:
			failures.append("PNG estático inválido: %s" % path)
		elif image.detect_alpha() == Image.ALPHA_NONE:
			failures.append("imagem estática sem canal alfa: %s" % path)
		elif _visible_coverage(image) < 0.01:
			failures.append("imagem estática sem conteúdo visível: %s" % path)
		if enemy_id not in ANIMATED_ENEMY_IDS:
			failures.append_array(_validate_static_enemy_cache(enemy_id))
	return failures

func _validate_static_enemy_cache(enemy_id: String) -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de inimigo"]
	var first = packed.instantiate()
	var second = packed.instantiate()
	tree.root.add_child(first)
	tree.root.add_child(second)
	first._tex_cache.clear()
	first.setup(Enemy.make(enemy_id, Vector2.ZERO))
	second.setup(Enemy.make(enemy_id, Vector2.ONE))
	if first.tex == null:
		failures.append("primeira instância sem textura: %s" % enemy_id)
	if second.tex == null:
		failures.append("acerto de cache sem textura: %s" % enemy_id)
	elif second.tex != first.tex:
		failures.append("acerto de cache não reutilizou textura: %s" % enemy_id)
	first.free()
	second.free()
	return failures

func _validate_bromnor_runtime() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de Bromnor"]
	var hero_view: Node2D = packed.instantiate()
	tree.root.add_child(hero_view)
	hero_view.apply_hero("bromnor")
	var sprite := hero_view.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null or sprite.sprite_frames == null:
		failures.append("Bromnor não recebeu AnimatedSprite2D")
	else:
		var expected := {
			&"idle": 4, &"move_n": 6, &"move_ne": 6, &"move_e": 6, &"move_se": 6, &"move_s": 6,
			&"attack": 4, &"active": 6, &"death": 6,
		}
		for animation in expected:
			if not sprite.sprite_frames.has_animation(animation):
				failures.append("animação de Bromnor ausente em jogo: %s" % animation)
			elif sprite.sprite_frames.get_frame_count(animation) != expected[animation]:
				failures.append("quadros incorretos em Bromnor/%s" % animation)
		hero_view.play_action(&"attack")
		if sprite.animation != &"attack":
			failures.append("ataque de Bromnor não foi acionado")
		hero_view.play_action(&"active")
		if sprite.animation != &"active":
			failures.append("ativa de Bromnor não foi acionada")
		hero_view.sync_visual(Vector2(10, 10), true, false)
		if sprite.animation != &"death":
			failures.append("morte de Bromnor não foi acionada")
	hero_view.queue_free()
	return failures

func _validate_zynara_runtime() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de Zynara"]
	var hero_view: Node2D = packed.instantiate()
	tree.root.add_child(hero_view)
	hero_view.apply_hero("zynara")
	var sprite := hero_view.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null or sprite.sprite_frames == null:
		failures.append("Zynara não recebeu AnimatedSprite2D")
	else:
		var expected := {
			&"idle": 4, &"move_n": 6, &"move_ne": 6, &"move_e": 6, &"move_se": 6, &"move_s": 6,
			&"attack": 4, &"active": 6, &"death": 6,
		}
		for animation in expected:
			if not sprite.sprite_frames.has_animation(animation):
				failures.append("animação de Zynara ausente em jogo: %s" % animation)
			elif sprite.sprite_frames.get_frame_count(animation) != expected[animation]:
				failures.append("quadros incorretos em Zynara/%s" % animation)
		hero_view.play_action(&"attack")
		if sprite.animation != &"attack":
			failures.append("ataque de Zynara não foi acionado")
		hero_view.play_action(&"active")
		if sprite.animation != &"active":
			failures.append("ativa de Zynara não foi acionada")
		hero_view.sync_visual(Vector2(10, 10), true, false)
		if sprite.animation != &"death":
			failures.append("morte de Zynara não foi acionada")
	hero_view.queue_free()
	return failures

func _validate_nyrelia_runtime() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de Nyrelia"]
	var hero_view: Node2D = packed.instantiate()
	tree.root.add_child(hero_view)
	hero_view.apply_hero("nyrelia")
	var sprite := hero_view.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null or sprite.sprite_frames == null:
		failures.append("Nyrelia não recebeu AnimatedSprite2D")
	else:
		var expected := {
			&"idle": 4, &"move_n": 6, &"move_ne": 6, &"move_e": 6, &"move_se": 6, &"move_s": 6,
			&"attack": 4, &"active": 6, &"death": 6,
		}
		for animation in expected:
			if not sprite.sprite_frames.has_animation(animation):
				failures.append("animação de Nyrelia ausente em jogo: %s" % animation)
			elif sprite.sprite_frames.get_frame_count(animation) != expected[animation]:
				failures.append("quadros incorretos em Nyrelia/%s" % animation)
		if not is_equal_approx(sprite.offset.y, -176.0):
			failures.append("âncora de Nyrelia não coincide com sua linha de base normalizada")
		hero_view.play_action(&"attack")
		if sprite.animation != &"attack":
			failures.append("ataque de Nyrelia não foi acionado")
		hero_view.play_action(&"active")
		if sprite.animation != &"active":
			failures.append("ativa de Nyrelia não foi acionada")
		hero_view.sync_visual(Vector2(10, 10), true, false)
		if sprite.animation != &"death":
			failures.append("morte de Nyrelia não foi acionada")
	hero_view.queue_free()
	return failures

func _validate_nyrelia_frame_baselines() -> Array[String]:
	var failures: Array[String] = []
	var expected := {
		"idle": 4, "move_n": 6, "move_ne": 6, "move_e": 6, "move_se": 6, "move_s": 6,
		"attack": 4, "active": 6, "death": 6,
	}
	for sequence in expected:
		var path := "res://assets/animations/heroes/nyrelia/%s.png" % sequence
		var image := Image.new()
		if image.load(ProjectSettings.globalize_path(path)) != OK:
			failures.append("não foi possível medir a base de Nyrelia/%s" % sequence)
			continue
		for frame in expected[sequence]:
			var bottom := -1
			var left := 256
			var right := -1
			for y in 384:
				for x in range(frame * 256, (frame + 1) * 256):
					if image.get_pixel(x, y).a < 0.10:
						continue
					bottom = max(bottom, y)
					left = min(left, x - frame * 256)
					right = max(right, x - frame * 256)
			if bottom != 367:
				failures.append("linha de base inválida em Nyrelia/%s[%d]: %d" % [sequence, frame, bottom + 1])
			if left < 6 or right > 249:
				failures.append("conteúdo de Nyrelia/%s[%d] toca a borda da célula" % [sequence, frame])
	return failures


func _validate_hero_display_scale() -> Array[String]:
	var failures: Array[String] = []
	var script: Script = load("res://ui/hero_view.gd")
	var heights: Dictionary = script.HERO_DISPLAY_HEIGHT
	var art: Dictionary = script.HERO_IDLE_ART_HEIGHT
	for hero_id in Data.table("heroes"):
		if not heights.has(StringName(hero_id)) or not art.has(StringName(hero_id)):
			failures.append("herói sem altura de exibição: %s" % hero_id)
			continue
		var image := Image.new()
		if image.load(ProjectSettings.globalize_path("res://assets/animations/heroes/%s/idle.png" % hero_id)) != OK:
			failures.append("idle ilegível: %s" % hero_id)
			continue
		var measured: Array[int] = []
		for frame in image.get_width() / 256:
			var top := 384
			var bottom := -1
			for y in 384:
				for x in 256:
					if image.get_pixel(frame * 256 + x, y).a >= 0.10:
						top = mini(top, y)
						bottom = maxi(bottom, y)
			measured.append(bottom - top + 1)
		measured.sort()
		if absi(measured[measured.size() / 2] - int(art[StringName(hero_id)])) > 3:
			failures.append("HERO_IDLE_ART_HEIGHT de %s desatualizada: tabela %d, arte %d" % [hero_id, int(art[StringName(hero_id)]), measured[measured.size() / 2]])
	# Ordem por raça (vault + D&D): Korrak maior; Brook <= Leoric < Bromnor < humanos.
	var order := [&"brook", &"leoric", &"bromnor", &"durvall", &"nyrelia", &"sylas", &"kayron", &"korrak"]
	for index in range(1, order.size()):
		if float(heights[order[index - 1]]) > float(heights[order[index]]):
			failures.append("altura de %s maior que a de %s" % [order[index - 1], order[index]])
	for hero_id in heights:
		if hero_id != &"korrak" and float(heights[hero_id]) >= float(heights[&"korrak"]):
			failures.append("%s não pode ser tão alto quanto Korrak" % hero_id)
		if absf(script.display_scale(String(hero_id)) * float(art[hero_id]) - float(heights[hero_id])) > 0.5:
			failures.append("escala de %s não entrega a altura-alvo" % hero_id)
	return failures

func _visible_coverage(image: Image) -> float:
	var visible := 0
	var sampled := 0
	for y in range(0, image.get_height(), 8):
		for x in range(0, image.get_width(), 8):
			sampled += 1
			if image.get_pixel(x, y).a > 0.04:
				visible += 1
	return float(visible) / float(sampled) if sampled > 0 else 0.0
