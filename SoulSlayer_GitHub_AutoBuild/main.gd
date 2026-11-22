extends Node2D
const SKILLS = ["Рассечение","Двойной удар","Огненный шар","Пламенный вихрь","Ледяной клинок","Морозная буря","Гнев небес","Теневая волна","Небесный приговор","Солнечный взрыв","Пожиратель душ","Разлом мира"]
const SK_POWER = [2.5,3.0,4.0,5.0,6.5,8.0,10.0,13.0,20.0,28.0,50.0,65.0]
const SK_CD = [3.0,4.0,5.0,6.0,7.0,8.0,10.0,12.0,15.0,18.0,25.0,30.0]
const SK_MP = [10,12,18,22,25,30,35,40,45,55,65,80]
var skill_level: Array[int] = [1,0,0,0,0,0,0,0,0,0,0,0]
var copies: Array[int] = [0,0,0,0,0,0,0,0,0,0,0,0]
var slots: Array[int] = [0,-1,-1,-1]
var cooldown: Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var mana: float = 100.0
var mana_rank: int = 0
var regen_rank: int = 0
var auto_skill: bool = true
var shake_enabled: bool = true
var skill_selected: int = 0
var skill_list: ItemList
var skill_detail: Label
var slot_buttons: Array[Button] = []
var cast_buttons: Array[Button] = []
var mana_bar: ProgressBar
var mana_label: Label
var auto_button: Button
var skill_fx: float = 0.0
var fx_id: int = 0
var fx_damage: int = 0
var skill_notice: String = ""
const SAVE_PATH = "user://soul_slayer_save.json"
const BACKUP_PATH = "user://soul_slayer_save_backup.json"
const TEMP_PATH = "user://soul_slayer_save.tmp"
const OFFLINE_LIMIT = 43200
const SOUL_NAMES = ["Сила души", "Богатство души", "Мудрость души", "Мастерство критов", "Офлайн-добыча"]
var souls: int = 0
var rebirths: int = 0
var best_stage_ever: int = 1
var soul_ranks: Array[int] = [0,0,0,0,0]
var total_offline_seconds: int = 0
var last_saved_unix: int = 0
var offline_report: String = ""
var offline_gold_last: int = 0
var offline_xp_last: int = 0

const BG = preload("res://assets/forest.png")
const HERO = preload("res://assets/knight.png")
const FOES = [preload("res://assets/slime.png"), preload("res://assets/goblin.png"), preload("res://assets/skeleton.png"), preload("res://assets/boss.png")]
const ZONE_TEXTURES = [BG, preload("res://assets/zone1.png"), preload("res://assets/zone2.png"), preload("res://assets/zone3.png"), preload("res://assets/zone4.png")]
const REGIONAL_TEXTURES = [FOES, [preload("res://assets/foe1_0.png"), preload("res://assets/foe1_1.png"), preload("res://assets/foe1_2.png"), preload("res://assets/foe1_3.png")], [preload("res://assets/foe2_0.png"), preload("res://assets/foe2_1.png"), preload("res://assets/foe2_2.png"), preload("res://assets/foe2_3.png")], [preload("res://assets/foe3_0.png"), preload("res://assets/foe3_1.png"), preload("res://assets/foe3_2.png"), preload("res://assets/foe3_3.png")], [preload("res://assets/foe4_0.png"), preload("res://assets/foe4_1.png"), preload("res://assets/foe4_2.png"), preload("res://assets/foe4_3.png")]]
const KEEPER = preload("res://assets/keeper.png")
const NAMES = ["Слизень", "Гоблин", "Скелет", "Король слизней"]
const TITLES = ["Урон", "Скорость атаки", "Шанс крита", "Крит. урон", "Бонус золота"]
const RARITY = ["Обычное", "Необычное", "Редкое", "Эпическое", "Легендарное", "Мифическое"]
const COLORS = ["#aab4c0","#58d68d","#62aaff","#c084fc","#f7cf64","#ff6767"]
const WEAPONS = ["Ржавый клинок","Учебный меч","Короткий меч","Железный меч","Меч стража","Лесной клинок","Меч охотника","Стальной меч","Клинок ветра","Меч рыцаря","Лунный меч","Ледяной клинок","Громовой меч","Клинок духов","Меч рассвета","Теневой клинок","Меч пламени","Клинок бездны","Меч феникса","Звёздный меч","Золотой клинок","Меч короля","Солнечный меч","Клинок дракона","Меч вечности","Пожиратель душ","Клинок хаоса","Меч пустоты","Сердце титана","Soul Slayer"]
const POWER = [1.1,1.15,1.2,1.25,1.3,1.4,1.5,1.6,1.7,1.8,2.0,2.25,2.5,2.75,3.0,3.5,3.8,4.2,4.6,5.0,6.0,7.0,8.0,9.0,10.0,12.0,14.0,16.0,18.0,20.0]
var owned: Array[int] = []
var equipped: int = -1
var summons: int = 0
var selected: int = 0
var inventory_list: ItemList
var detail: Label
var equip_button: Button
var merge_button: Button
var summon_info: Label
var summon_one: Button
var summon_ten: Button
var summon_result: Label
var recent_rolls: String = ""
var gold: int = 0
var stage: int = 1
var damage: int = 10
var cost: int = 20
var crystals: int = 0
var hero_level: int = 1
var xp: int = 0
var ranks: Array[int] = [0,0,0,0]
var hp: int = 50
var max_hp: int = 50
var elapsed: float = 0.0
var hit: float = 0.0
var last_damage: int = 0
var clock: float = 0.0
var critical: bool = false
var stats: Label
var enemy: Label
var bar: ProgressBar
var xp_bar: ProgressBar
var message: Label
var hp_text: Label
var hero_text: Label
var content: Control
var buttons: Array[Button] = []
var tabs: Array[Button] = []
var active_tab: int = 0
var bulk: int = 1
var bulk_buttons: Array[Button] = []
var dps_label: Label
var log_lines: Array[String] = []
var journal: Label
var battle_nodes: Array[CanvasItem] = []
var auto_global: Button
var rarity_filter: int = -1
var weapon_ids: Array[int] = []
var summon_mode: int = 0
var last_notice: String = ""
var log_clock: float = 0.0
# 0.9 UI and audio. The existing tab indices and save keys remain unchanged.
const GROUP_NAMES = ["⚔ Битва", "🛡 Герой", "🎁 Награды", "🌍 Мир", "⚙ Прочее"]
const GROUP_TABS = [[0], [1,2,3,4,12,14], [9,10,13], [7,8,11], [5,6]]
const ALL_TAB_NAMES = ["Битва","Герой","Оружие","Призыв оружия","Навыки","Настройки","Журнал","Локации","Подземелья","Задания","Достижения","Сюжет","Титулы","Вход","Перерождение"]
var group_buttons: Array[Button] = []
var nav_list: VBoxContainer
var nav_scroll: ScrollContainer
var expanded_group: int = -1
var nav_sub_buttons: Array[Button] = []
var audio_music: AudioStreamPlayer
var audio_fx: AudioStreamPlayer
var music_enabled: bool = true
var sounds_enabled: bool = true
var music_volume: float = 0.35
var effects_volume: float = 0.55
var music_tracks: Array[AudioStream] = []
var fx_tracks: Array[AudioStream] = []
var current_music_zone: int = -1
var sound_cooldown: float = 0.0



const ZONES = ["Лес теней","Кристальные пещеры","Забытые пески","Ледяные земли","Огненная бездна"]
const REGIONAL_NAMES = [["Слизень","Гоблин","Скелет","Король слизней"],["Голем","Кристальный страж","Пещерный дух","Кристальный титан"],["Мумия","Скорпион","Песчаный дух","Проклятый фараон"],["Ледяной волк","Снежный великан","Морозный дух","Ледяной дракон"],["Демон","Элементаль","Страж бездны","Владыка бездны"]]
var frontier: int = 1
var farming: bool = false
var boss_time: float = 30.0
var boss_failed: bool = false
var dungeon: int = -1
var dungeon_left: int = 0
var dungeon_runs: int = 0
var world_label: Label
var boss_label: Label
# Soul Slayer 0.7: persistent quest and reward state.
const DAILY_NAMES = ["Уничтожить 100 монстров", "Победить 5 боссов", "Призвать 10 мечей", "Применить 50 навыков", "Завершить 3 подземелья"]
const DAILY_TARGETS = [100,5,10,50,3]
const DAILY_GOLD = [5000,0,0,3000,0]
const DAILY_CRYSTALS = [0,50,30,0,75]
const ACH_NAMES = ["Начинающий охотник", "Истребитель", "Коллекционер", "Повелитель магии", "Легендарный воин", "Покоритель подземелий", "Мастер призыва", "Герой сотого этапа"]
const ACH_REWARDS = [20,100,150,200,500,100,75,100]
const STORY_NAMES = ["Пробуждение: достигни этапа 10", "Лес теней: достигни этапа 50", "Тайна кристаллов: достигни этапа 100", "Песчаное проклятие: достигни этапа 150", "Врата бездны: достигни этапа 250"]
const STORY_STAGES = [10,50,100,150,250]
const STORY_REWARDS = [15,40,75,120,200]
const TITLE_NAMES = ["Без титула", "Охотник", "Убийца монстров", "Мастер клинка", "Повелитель душ", "Легенда"]
var daily_date: String = ""
var daily_progress: Array[int] = [0,0,0,0,0]
var daily_claimed: Array[bool] = [false,false,false,false,false]
var daily_chest_claimed: bool = false
var total_kills: int = 0
var total_bosses: int = 0
var total_skill_casts: int = 0
var total_weapon_rolls: int = 0
var achievements_claimed: Array[bool] = [false,false,false,false,false,false,false,false]
var story_claimed: Array[bool] = [false,false,false,false,false]
var title_selected: int = 0
var login_last_date: String = ""
var login_streak: int = 0
var login_claimed: bool = false
var login_reward_day: int = 1
func open_group(group_id: int) -> void:
	if group_id == 0:
		expanded_group = -1
		show_tab(0)
	else:
		expanded_group = -1 if expanded_group == group_id else group_id
		rebuild_navigation()

func rebuild_navigation() -> void:
	if nav_list == null:
		return
	for node in nav_list.get_children():
		nav_list.remove_child(node)
		node.queue_free()
	group_buttons.clear()
	nav_sub_buttons.clear()
	for g in range(GROUP_NAMES.size()):
		var header := make_button(GROUP_NAMES[g] + ("  ▾" if expanded_group == g else "  ▸"), Vector2.ZERO, Vector2(172,49), nav_list)
		header.custom_minimum_size = Vector2(172,49)
		header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header.add_theme_font_size_override("font_size",16)
		header.alignment = HORIZONTAL_ALIGNMENT_LEFT
		header.add_theme_color_override("font_color", Color("#f0d49b") if active_tab in GROUP_TABS[g] else Color("#e4eaf4"))
		if active_tab in GROUP_TABS[g]:
			header.add_theme_stylebox_override("normal", nav_style(Color("#51442f"),Color("#dfb76d")))
		header.pressed.connect(open_group.bind(g))
		group_buttons.append(header)
		if expanded_group == g and g != 0:
			for tab_id in GROUP_TABS[g]:
				var sub := make_button("   " + ALL_TAB_NAMES[tab_id],Vector2.ZERO,Vector2(172,47),nav_list)
				sub.custom_minimum_size = Vector2(172,47)
				sub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				sub.alignment = HORIZONTAL_ALIGNMENT_LEFT
				sub.add_theme_font_size_override("font_size",15)
				sub.add_theme_stylebox_override("normal",nav_style(Color("#25374d"),Color("#60748b")))
				sub.add_theme_stylebox_override("hover",nav_style(Color("#445c77"),Color("#edc47e")))
				if tab_id == active_tab:
					sub.add_theme_stylebox_override("normal",nav_style(Color("#655034"),Color("#edc47e")))
					sub.add_theme_color_override("font_color",Color("#ffe3aa"))
				sub.pressed.connect(show_tab.bind(tab_id))
				nav_sub_buttons.append(sub)

func nav_style(bg: Color, outline: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = outline
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 9.0
	return style

func setup_audio() -> void:
	audio_music = AudioStreamPlayer.new()
	audio_music.bus = "Master"
	add_child(audio_music)
	audio_music.finished.connect(refresh_music)
	audio_fx = AudioStreamPlayer.new()
	add_child(audio_fx)
	for i in range(5):
		music_tracks.append(load("res://assets/audio/zone%d.wav" % i))
	for name in ["hit", "critical", "boss", "reward", "magic", "summon"]:
		fx_tracks.append(load("res://assets/audio/%s.wav" % name))
	refresh_music()

func refresh_music() -> void:
	if audio_music == null:
		return
	if not music_enabled:
		audio_music.stop()
		return
	var target := clampi(zone(),0,4)
	if audio_music.stream != music_tracks[target]:
		audio_music.stream = music_tracks[target]
		audio_music.play()
	elif not audio_music.playing:
		audio_music.play()
	audio_music.volume_linear = music_volume

func play_effect(id: int) -> void:
	if not sounds_enabled or audio_fx == null or sound_cooldown > 0.0:
		return
	if id < 0 or id >= fx_tracks.size():
		return
	audio_fx.stream = fx_tracks[id]
	audio_fx.volume_linear = effects_volume
	audio_fx.play()
	sound_cooldown = 0.11

func toggle_music() -> void:
	music_enabled = not music_enabled
	refresh_music()
	save_game()
	show_tab(5)

func toggle_sounds() -> void:
	sounds_enabled = not sounds_enabled
	save_game()
	show_tab(5)

func change_music_volume(value: float) -> void:
	music_volume = value
	if audio_music != null:
		audio_music.volume_linear = music_volume
	save_game()

func change_effects_volume(value: float) -> void:
	effects_volume = value
	save_game()

func zone() -> int:
	return mini(4, floori((stage-1)/50.0))
func foe_name() -> String:
	if stage == 50 and dungeon < 0:
		return "Древний хранитель"
	return REGIONAL_NAMES[zone()][kind()]
func kind() -> int:
	return 3 if stage % 10 == 0 or (dungeon >= 0 and dungeon_left == 1) else (stage - 1) % 3

func interval() -> float:
	return maxf(0.2, 0.8 * pow(0.96, ranks[0]))

func chance() -> float:
	return minf(0.75, 0.05 + ranks[1] * 0.01 + soul_ranks[3]*0.005)

func multiplier() -> float:
	return (1.5 + ranks[2] * 0.1) * (1.15 if title_selected == 3 else 1.0)

func price(i: int) -> int:
	if i == 0:
		return cost
	return int(ceil([150,300,200,180][i-1] * pow(1.35, ranks[i-1])))

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	owned.resize(30)
	load_game()
	frontier = maxi(frontier,stage)
	best_stage_ever = maxi(best_stage_ever,frontier)
	calculate_offline_rewards()
	refresh_calendar()
	spawn_enemy()
	var t := make_label("SOUL SLAYER  /  0.9.2", Vector2(24,12), 27)
	t.modulate = Color("#edcb87")
	stats = make_label("", Vector2(390,18), 20)
	xp_bar = ProgressBar.new()
	xp_bar.position = Vector2(24,79)
	xp_bar.size = Vector2(1230,12)
	xp_bar.show_percentage = false
	xp_bar.add_theme_stylebox_override("fill",bar_style(Color("#b79a60")))
	xp_bar.add_theme_stylebox_override("background",bar_style(Color("#29374a")))
	add_child(xp_bar)
	hero_text = make_label("",Vector2(24,49),16)
	dps_label = make_label("",Vector2(820,49),16)
	enemy = make_label("",Vector2(570,116),19)
	bar = ProgressBar.new()
	bar.position = Vector2(570,145)
	bar.size = Vector2(320,16)
	bar.show_percentage = false
	bar.add_theme_stylebox_override("fill",bar_style(Color("#d45b68")))
	add_child(bar)
	hp_text = make_label("",Vector2(570,165),16)
	world_label = make_label("",Vector2(220,120),16)
	boss_label = make_label("",Vector2(220,150),16)
	battle_nodes.assign([enemy,bar,hp_text,world_label,boss_label])
	message = make_label("Автобой активен",Vector2(208,635),16)
	message.modulate = Color("#edcb87")
	content = Control.new()
	content.position = Vector2(208,110)
	content.size = Vector2(1040,510)
	add_child(content)
	var names := ["Битва","Герой","Оружие","Призыв","Навыки","Настройки","Журнал","Локации","Подземелья","Задания","Достижения","Сюжет","Титулы","Вход","Перерождение"]
	for i in range(names.size()):
		var b := make_button(names[i],Vector2(-500,-500),Vector2(174,40),self)
		b.visible = false
		tabs.append(b)
	nav_scroll = ScrollContainer.new()
	nav_scroll.position = Vector2(12,120)
	nav_scroll.size = Vector2(187,510)
	nav_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(nav_scroll)
	nav_list = VBoxContainer.new()
	nav_list.add_theme_constant_override("separation",7)
	nav_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav_scroll.add_child(nav_list)
	rebuild_navigation()
	make_label("F1–F5: разделы • 1–4: навыки",Vector2(14,638),12)
	setup_audio()
	mana_label = make_label("",Vector2(208,669),16)
	mana_bar = ProgressBar.new()
	mana_bar.position = Vector2(208,696)
	mana_bar.size = Vector2(780,10)
	mana_bar.show_percentage = false
	mana_bar.add_theme_stylebox_override("fill",bar_style(Color("#377ed5")))
	add_child(mana_bar)
	auto_global = make_button("Авто",Vector2(1000,665),Vector2(248,42),self)
	auto_global.pressed.connect(toggle_auto)
	for i in range(4):
		var cast := make_button("",Vector2(208+i*260,719),Vector2(250,60),self)
		cast.pressed.connect(cast_slot.bind(i))
		cast_buttons.append(cast)
	show_tab(0)
	if offline_report != "":
		call_deferred("show_offline_popup")

func bar_style(color: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_corner_radius_all(3)
	return s

func panel_style(color: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.set_corner_radius_all(6)
	s.set_border_width_all(1)
	s.border_color = Color("#796746")
	return s

func make_label(value: String, pos: Vector2, font_size: int, parent: Node = null) -> Label:
	var l := Label.new()
	l.text = value
	l.position = pos
	l.add_theme_font_size_override("font_size",font_size)
	if parent == null:
		add_child(l)
	else:
		parent.add_child(l)
	return l

func make_button(value: String, pos: Vector2, dimensions: Vector2, parent: Node) -> Button:
	var b := Button.new()
	b.text = value
	b.position = pos
	b.size = dimensions
	b.add_theme_font_size_override("font_size",16)
	b.add_theme_stylebox_override("normal",panel_style(Color("#344454")))
	b.add_theme_stylebox_override("hover",panel_style(Color("#655637")))
	b.add_theme_stylebox_override("pressed",panel_style(Color("#4c432e")))
	b.add_theme_stylebox_override("disabled",panel_style(Color("#222e3d")))
	parent.add_child(b)
	return b

func show_tab(index: int) -> void:
	active_tab = index
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()
	buttons.clear()
	bulk_buttons.clear()
	for node in battle_nodes:
		node.visible = index == 0
	for i in range(tabs.size()):
		tabs[i].disabled = i == index
	rebuild_navigation()
	match index:
		0,1:
			var x := 720 if index == 0 else 0
			var w := 320 if index == 0 else 1040
			make_label("БЫСТРЫЕ УЛУЧШЕНИЯ" if index == 0 else "ХАРАКТЕРИСТИКИ ГЕРОЯ",Vector2(x,0),20,content)
			for j in range(4):
				var b := make_button(["×1","×10","×100","MAX"][j],Vector2(x+j*w/4.0,38),Vector2(w/4.0-5,35),content)
				b.pressed.connect(set_bulk.bind([1,10,100,1000][j]))
				bulk_buttons.append(b)
			for i in range(5):
				var b := make_button("",Vector2(x,83+i*79),Vector2(w,70),content)
				b.pressed.connect(buy.bind(i))
				b.tooltip_text = ["Базовый урон +5","Интервал атаки уменьшается на 4%","Шанс критического удара +1%","Критический множитель +10%","Золото за победу +5%"][i]
				buttons.append(b)
		2: build_inventory()
		3: build_summon()
		4: build_skills()
		5:
			var full := make_button("Полноэкранный режим / окно (F11)",Vector2.ZERO,Vector2(500,55),content)
			full.pressed.connect(toggle_fullscreen)
			var reset := make_button("Сбросить прогресс",Vector2(530,0),Vector2(500,55),content)
			reset.pressed.connect(confirm_reset)
			var shake := make_button("Тряска: " + ("ВКЛ" if shake_enabled else "ВЫКЛ"),Vector2(0,75),Vector2(500,55),content)
			shake.pressed.connect(toggle_shake)
			var music_toggle := make_button("Музыка: " + ("ВКЛ" if music_enabled else "ВЫКЛ"),Vector2(530,75),Vector2(245,55),content)
			music_toggle.pressed.connect(toggle_music)
			var fx_toggle := make_button("Звуки: " + ("ВКЛ" if sounds_enabled else "ВЫКЛ"),Vector2(790,75),Vector2(245,55),content)
			fx_toggle.pressed.connect(toggle_sounds)
			make_label("Громкость музыки",Vector2(0,143),17,content)
			var mv := HSlider.new()
			mv.position = Vector2(0,175)
			mv.size = Vector2(440,24)
			mv.max_value = 1.0
			mv.step = 0.05
			mv.value = music_volume
			mv.value_changed.connect(change_music_volume)
			content.add_child(mv)
			make_label("Громкость эффектов",Vector2(530,143),17,content)
			var fv := HSlider.new()
			fv.position = Vector2(530,175)
			fv.size = Vector2(440,24)
			fv.max_value = 1.0
			fv.step = 0.05
			fv.value = effects_volume
			fv.value_changed.connect(change_effects_volume)
			content.add_child(fv)
			make_label("КАК ИГРАТЬ\nГерой атакует автоматически. Улучшай урон за золото.\nБоссы дают кристаллы для призыва оружия и навыков.\nВыбирай меч в разделе Оружие, а навыки назначай в слоты.\nКлавиши 1–4: навыки. F11: полный экран. F1–F5: разделы.\nПрогресс сохраняется автоматически.",Vector2(0,230),18,content)
		6:
			make_label("ЖУРНАЛ СОБЫТИЙ • текущий сеанс",Vector2.ZERO,23,content)
			journal = make_label("",Vector2(0,45),18,content)
		7: build_world()
		8: build_dungeons()
		9: build_daily()
		10: build_achievements()
		11: build_story()
		12: build_titles()
		13: build_login_reward()
		14: build_rebirth()
	update_ui()

func set_bulk(n: int) -> void:
	bulk = n
	update_ui()

func short_num(n: float) -> String:
	for j in range(3,-1,-1):
		var unit := pow(1000.0,j+1)
		if n >= unit:
			return "%.2f%s" % [n/unit,["K","M","B","T"][j]]
	return str(int(n))

func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11:
			toggle_fullscreen()
		elif event.keycode >= KEY_F1 and event.keycode <= KEY_F5:
			open_group(event.keycode - KEY_F1)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_4:
			cast_slot(event.keycode - KEY_1)

func confirm_reset() -> void:
	var dialog := ConfirmationDialog.new()
	dialog.title = "Сброс прогресса"
	dialog.dialog_text = "Удалить весь прогресс? Это действие необратимо."
	dialog.confirmed.connect(reset_game)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.canceled.connect(dialog.queue_free)
	add_child(dialog)
	dialog.popup_centered()

func reset_game() -> void:
	gold = 0
	stage = 1
	frontier = 1
	farming = false
	dungeon = -1
	dungeon_runs = 0
	damage = 10
	cost = 20
	crystals = 0
	hero_level = 1
	xp = 0
	ranks = [0,0,0,0]
	owned.fill(0)
	equipped = -1
	summons = 0
	recent_rolls = ""
	skill_level = [1,0,0,0,0,0,0,0,0,0,0,0]
	copies.fill(0)
	slots = [0,-1,-1,-1]
	cooldown.fill(0.0)
	mana_rank = 0
	regen_rank = 0
	mana = 100.0
	auto_skill = true
	daily_date = ""
	daily_progress = [0,0,0,0,0]
	daily_claimed = [false,false,false,false,false]
	daily_chest_claimed = false
	total_kills = 0
	total_bosses = 0
	total_skill_casts = 0
	total_weapon_rolls = 0
	achievements_claimed = [false,false,false,false,false,false,false,false]
	story_claimed = [false,false,false,false,false]
	title_selected = 0
	login_last_date = ""
	login_streak = 0
	login_claimed = false
	souls = 0
	rebirths = 0
	best_stage_ever = 1
	soul_ranks = [0,0,0,0,0]
	total_offline_seconds = 0
	last_saved_unix = 0
	refresh_calendar()
	elapsed = 0
	hit = 0
	spawn_enemy()
	message.text = "Прогресс сброшен"
	save_game()
	show_tab(active_tab)

func _process(delta: float) -> void:
	if int(clock) % 30 == 0 and clock - floorf(clock) < delta:
		refresh_calendar()
	clock += delta
	sound_cooldown = maxf(0.0, sound_cooldown-delta)
	if current_music_zone != zone():
		current_music_zone = zone()
		refresh_music()
	hit = maxf(0.0,hit-delta)
	if kind() == 3 and not farming and not boss_failed:
		boss_time = maxf(0.0,boss_time-delta)
		if boss_time <= 0:
			boss_failed = true
			message.text = "Время вышло! Повтори бой во вкладке Локации."
		boss_label.text = "Время босса: %.1f с" % boss_time
	elapsed += delta
	if not boss_failed and elapsed >= interval():
		elapsed -= interval()
		critical = randf() < chance()
		last_damage = int(round(effective_damage() * multiplier())) if critical else effective_damage()
		hp -= last_damage
		hit = 0.38
		play_effect(1 if critical else 0)
		check_victory()
		update_ui()
	mana = minf(max_mana(),mana+delta*(8.0+regen_rank*2.0))
	for i in range(12):
		cooldown[i] = maxf(0.0,cooldown[i]-delta)
	skill_fx = maxf(0.0,skill_fx-delta)
	if auto_skill:
		for i in range(4):
			cast_slot(i)
	refresh_cast()
	queue_redraw()

func check_victory() -> void:
	if hp <= 0:
		var boss := kind() == 3
		var reward := int(round((10+stage*5)*(3 if boss else 1)*(1.0+ranks[3]*0.05)*(1.0+soul_ranks[1]*0.10)))
		gold += reward
		play_effect(2 if boss else 3)
		total_kills += 1
		daily_progress[0] += 1
		if boss:
			total_bosses += 1
			daily_progress[1] += 1
		xp += int(round((10 + stage * 2) * (1.0 + soul_ranks[2]*0.10)))
		if boss:
			crystals += 15
			xp += 50
		while xp >= hero_level * 50:
			xp -= hero_level * 50
			hero_level += 1
		if dungeon >= 0:
			dungeon_left -= 1
			if dungeon_left == 0:
				if dungeon == 0: gold += 500 + stage*50
				elif dungeon == 1: crystals += 30
				else: xp += 500 + stage*10
				dungeon_runs += 1
				daily_progress[4] += 1
				dungeon = -1
				stage = frontier
		elif not farming:
			stage += 1
			frontier = maxi(frontier,stage)
		best_stage_ever = maxi(best_stage_ever,frontier)
		message.text = "Победа! +%d золота%s" % [reward,"  •  +15 кристаллов" if boss else ""]
		if randf() < (0.50 if boss else 0.03):
			var drop := roll_weapon()
			owned[drop] += 1
			message.text += " • Выпало: " + WEAPONS[drop]
			if active_tab == 2:
				refresh_inventory()
		spawn_enemy()
		save_game()

func _draw() -> void:
	draw_rect(Rect2(0,0,1280,800),Color("#101927"))
	draw_rect(Rect2(0,100,200,700),Color("#182536"))
	draw_rect(Rect2(200,625,1080,175),Color("#182536"))
	draw_rect(Rect2(0,99,1280,1),Color("#a68b58"))
	if active_tab != 0:
		return
	draw_set_transform(Vector2(208,110),0,Vector2(0.70,1.0))
	draw_rect(Rect2(0,80,1000,430), Color("#263041"))
	draw_texture_rect(ZONE_TEXTURES[zone()], Rect2(0,80,1000,430), false)
	for i in range(22):
		var x := fmod(float(i * 137) + clock * 8.0, 1000.0)
		var y := 140.0 + fmod(float(i * 73), 250.0)
		draw_circle(Vector2(x,y), 2.0, Color(0.8,0.9,0.5,0.25))
	draw_rect(Rect2(0,0,1000,80), Color("#111c2b"))
	draw_rect(Rect2(0,80,1000,2), Color("#927c51"))
	draw_rect(Rect2(0,510,1000,5), Color("#111c2b"))
	draw_rect(Rect2(0,510,1000,2), Color("#927c51"))
	var swing := maxf(0.0, hit / 0.38)
	var hx := 260.0 + 90.0 * swing
	var ex := 700.0 + 22.0 * swing + (sin(clock*90.0)*8.0*skill_fx if shake_enabled else 0.0)
	var bob := sin(clock * 4.0) * 3.0
	draw_ellipse_shadow(Vector2(hx,475), 65.0)
	draw_ellipse_shadow(Vector2(ex,475), 70.0)
	draw_texture_rect(HERO, Rect2(hx-100,275+bob,200,200), false)
	var size_px := 260.0 if kind() == 3 else 210.0
	var tint := Color(1.0,0.82,0.82) if hit > 0.26 else Color.WHITE
	draw_texture_rect(KEEPER if stage == 50 and dungeon < 0 else REGIONAL_TEXTURES[zone()][kind()], Rect2(ex-size_px/2,475-size_px+bob,size_px,size_px), false,tint)
	var hand := Vector2(hx+59,403+bob)
	var tip := hand + Vector2(100*swing+14,-105+145*swing)
	draw_line(hand,tip,Color("#33475b"),16)
	draw_line(hand,tip,weapon_color(equipped),9)
	if equipped >= 0:
		draw_line(hand,tip,weapon_color(equipped).lightened(0.35),3)
	draw_line(hand+Vector2(-12,0),hand+Vector2(12,0),Color("#d7ab62"),8)
	if hit > 0.12:
		var alpha := swing
		draw_arc(Vector2(530,360),85, -1.25,0.95,18,Color(0.65,0.93,1.0,alpha),8,true)
		for i in range(6):
			var a := float(i)*TAU/6.0
			var at := Vector2(ex,350)+Vector2(cos(a),sin(a))*(15+65*(1-swing))
			draw_rect(Rect2(at,Vector2(5,5)),Color(1,0.8,0.4,alpha))
	if hit > 0.0:
		draw_string(ThemeDB.fallback_font, Vector2(ex-50,280-45*(1-swing)),str(last_damage) + (" КРИТ!" if critical else ""),HORIZONTAL_ALIGNMENT_LEFT,-1,30,Color(1,0.83,0.42,minf(1.0,swing*2)))

	if equipped >= 15:
		draw_line(hand,tip,Color(weapon_color(equipped),0.22),22,true)
	if skill_fx > 0.0:
		var c := Color(COLORS[floori(fx_id/2.0)])
		c.a = minf(1.0,skill_fx*2.0)
		var center := Vector2(ex,330)
		var radius := 20.0+130.0*(1.0-skill_fx/0.7)
		draw_arc(center,radius,0,TAU,40,c,5,true)
		if fx_id in [0,1,4,5]:
			draw_arc(center,radius+20,-1.8,1.4,24,c,12,true)
		elif fx_id in [2,3,9]:
			for j in range(8):
				draw_circle(center+Vector2.from_angle(j*TAU/8.0)*radius,12,c)
		else:
			for j in range(5):
				var x := ex-60+j*30
				draw_polyline(PackedVector2Array([Vector2(x,185),Vector2(x+15,245),Vector2(x-10,280),center]),c,3,true)
		draw_string(ThemeDB.fallback_font,Vector2(ex-110,250),SKILLS[fx_id]+"  "+str(fx_damage),HORIZONTAL_ALIGNMENT_LEFT,-1,21,c)

	draw_set_transform(Vector2.ZERO)

func draw_ellipse_shadow(pos: Vector2, radius: float) -> void:
	var points := PackedVector2Array()
	for i in range(24):
		var a := TAU*float(i)/24.0
		points.append(pos+Vector2(cos(a)*radius,sin(a)*12))
	draw_colored_polygon(points,Color(0.03,0.07,0.09,0.5))

func spawn_enemy() -> void:
	boss_time = 30.0
	boss_failed = false
	elapsed = 0.0
	max_hp = int((40+stage*10)*(3 if kind() == 3 else 1)*pow(1.6,zone())*(2.0 if dungeon >= 0 else 1.0))
	hp = max_hp

func capped(i: int) -> bool:
	return (i == 1 and interval() <= 0.2) or (i == 2 and chance() >= 0.75)

func buy(i: int) -> void:
	for j in range(bulk):
		if capped(i) or gold < price(i) or price(i) <= 0:
			break
		gold -= price(i)
		if i == 0:
			damage += 5
			cost = int(ceil(cost*1.5))
		else:
			ranks[i-1] += 1
	message.text = "Улучшено: " + TITLES[i]
	save_game()
	update_ui()

func update_ui() -> void:
	stats.text = "Золото: %s   |   Кристаллы: %s   |   Этап: %d" % [short_num(gold),short_num(crystals),stage]
	dps_label.text = "Урон: %s  •  DPS: %s" % [short_num(effective_damage()),short_num(effective_damage()/interval()*(1+chance()*(multiplier()-1)))]
	dps_label.tooltip_text = "Средний DPS обычных атак с учётом критов, без навыков"
	for j in range(bulk_buttons.size()):
		bulk_buttons[j].disabled = bulk == [1,10,100,1000][j]
	if message.text != last_notice:
		last_notice = message.text
		log_lines.push_front(last_notice)
		if log_lines.size()>15:
			log_lines.pop_back()
	if active_tab == 6 and is_instance_valid(journal):
		journal.text = "\n".join(log_lines)
	xp_bar.max_value = hero_level*50
	xp_bar.value = xp
	hero_text.text = "Герой: ур. %d   •   Опыт: %d / %d" % [hero_level,xp,hero_level*50]
	enemy.text = "%s  •  ур. %d" % [foe_name(),stage]
	world_label.text = ZONES[zone()] if dungeon < 0 else "Подземелье • осталось: %d" % dungeon_left
	boss_label.text = ("Время босса: %.1f с" % boss_time if kind() == 3 and not farming else "Фарм" if farming else "Автобой")
	bar.max_value = max_hp
	bar.value = hp
	hp_text.text = "%d / %d HP" % [hp,max_hp]
	var values := ["%d → %d" % [damage,damage+5],"%.2f → %.2f сек" % [interval(),maxf(0.2,interval()*0.96)],"%.0f → %.0f%%" % [chance()*100,minf(75,chance()*100+1)],"%.0f → %.0f%%" % [multiplier()*100,multiplier()*100+10],"+%d → +%d%%" % [ranks[3]*5,ranks[3]*5+5]]
	for i in range(buttons.size()):
		buttons[i].text = "%s\n%s  |  %s" % [TITLES[i],values[i],"МАКС" if capped(i) else short_num(price(i))+" G / 1"]
		buttons[i].disabled = capped(i) or gold < price(i)

	if active_tab == 2:
		refresh_detail()
	if active_tab == 3:
		refresh_summon()

func save_game() -> void:
	# Write to a temporary file, validate it, then replace the main save.
	var payload := JSON.stringify({"frontier":frontier,"dungeon_runs":dungeon_runs,"gold":gold,"stage":frontier,"damage":damage,"cost":cost,"crystals":crystals,"hero_level":hero_level,"xp":xp,"ranks":ranks,"owned":owned,"equipped":equipped,"summons":summons,"skill_level":skill_level,"copies":copies,"slots":slots,"mana_rank":mana_rank,"regen_rank":regen_rank,"mana":mana,"auto_skill":auto_skill,"shake_enabled":shake_enabled,"cooldown":cooldown,"daily_date":daily_date,"daily_progress":daily_progress,"daily_claimed":daily_claimed,"daily_chest_claimed":daily_chest_claimed,"total_kills":total_kills,"total_bosses":total_bosses,"total_skill_casts":total_skill_casts,"total_weapon_rolls":total_weapon_rolls,"achievements_claimed":achievements_claimed,"story_claimed":story_claimed,"title_selected":title_selected,"login_last_date":login_last_date,"login_streak":login_streak,"login_claimed":login_claimed,"souls":souls,"rebirths":rebirths,"best_stage_ever":best_stage_ever,"soul_ranks":soul_ranks,"total_offline_seconds":total_offline_seconds,"music_enabled":music_enabled,"sounds_enabled":sounds_enabled,"music_volume":music_volume,"effects_volume":effects_volume,"last_saved_unix":int(Time.get_unix_time_from_system())})
	var tmp := FileAccess.open(TEMP_PATH,FileAccess.WRITE)
	if tmp == null:
		return
	tmp.store_string(payload)
	tmp.close()
	if not JSON.parse_string(FileAccess.get_file_as_string(TEMP_PATH)) is Dictionary:
		return
	var absolute_main := ProjectSettings.globalize_path(SAVE_PATH)
	var absolute_backup := ProjectSettings.globalize_path(BACKUP_PATH)
	var absolute_temp := ProjectSettings.globalize_path(TEMP_PATH)
	if FileAccess.file_exists(SAVE_PATH):
		# Do not overwrite the backup with a corrupt save.
		if JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH)) is Dictionary:
			DirAccess.copy_absolute(absolute_main,absolute_backup)
	var err := DirAccess.rename_absolute(absolute_temp,absolute_main)
	if err != OK:
		DirAccess.copy_absolute(absolute_temp,absolute_main)


func load_game() -> void:
	var data: Variant = null
	if FileAccess.file_exists(SAVE_PATH):
		data = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if not data is Dictionary and FileAccess.file_exists(BACKUP_PATH):
		data = JSON.parse_string(FileAccess.get_file_as_string(BACKUP_PATH))
	if data is Dictionary:
		gold = maxi(0,int(data.get("gold",0)))
		stage = maxi(1,int(data.get("stage",data.get("level",1))))
		frontier = maxi(stage,int(data.get("frontier",stage)))
		dungeon_runs = maxi(0,int(data.get("dungeon_runs",0)))
		damage = maxi(10,int(data.get("damage",10)))
		cost = maxi(20,int(data.get("cost",data.get("upgrade_cost",20))))
		crystals = maxi(0,int(data.get("crystals",0)))
		hero_level = maxi(1,int(data.get("hero_level",1)))
		xp = maxi(0,int(data.get("xp",0)))
		var saved = data.get("ranks",[])
		if saved is Array and saved.size() == 4:
			for i in range(4):
				ranks[i] = clampi(int(saved[i]),0,100)

		var inventory = data.get("owned", [])
		if inventory is Array:
			for i in range(mini(30,inventory.size())):
				owned[i] = maxi(0,int(inventory[i]))
		equipped = clampi(int(data.get("equipped",-1)),-1,29)
		if equipped >= 0 and owned[equipped] == 0:
			equipped = -1
		summons = maxi(0,int(data.get("summons",0)))
		for i in range(12):
			var levels = data.get("skill_level",[])
			var dupes = data.get("copies",[])
			var cd = data.get("cooldown",[])
			if i < levels.size():
				skill_level[i] = clampi(int(levels[i]),0,100)
			if i < dupes.size():
				copies[i] = maxi(0,int(dupes[i]))
			if i < cd.size():
				cooldown[i] = clampf(float(cd[i]),0.0,SK_CD[i])
		var saved_slots = data.get("slots",[])
		for i in range(mini(4,saved_slots.size())):
			slots[i] = clampi(int(saved_slots[i]),-1,11)
		mana_rank = clampi(int(data.get("mana_rank",0)),0,100)
		regen_rank = clampi(int(data.get("regen_rank",0)),0,100)
		mana = clampf(float(data.get("mana",100)),0,max_mana())
		auto_skill = bool(data.get("auto_skill",true))
		shake_enabled = bool(data.get("shake_enabled",true))
		music_enabled = bool(data.get("music_enabled",true))
		sounds_enabled = bool(data.get("sounds_enabled",true))
		music_volume = clampf(float(data.get("music_volume",0.35)),0.0,1.0)
		effects_volume = clampf(float(data.get("effects_volume",0.55)),0.0,1.0)
		daily_date = str(data.get("daily_date",""))
		load_int_array(data.get("daily_progress",[]),daily_progress)
		load_bool_array(data.get("daily_claimed",[]),daily_claimed)
		daily_chest_claimed = bool(data.get("daily_chest_claimed",false))
		total_kills = maxi(0,int(data.get("total_kills",0)))
		total_bosses = maxi(0,int(data.get("total_bosses",0)))
		total_skill_casts = maxi(0,int(data.get("total_skill_casts",0)))
		total_weapon_rolls = maxi(0,int(data.get("total_weapon_rolls",summons)))
		load_bool_array(data.get("achievements_claimed",[]),achievements_claimed)
		load_bool_array(data.get("story_claimed",[]),story_claimed)
		title_selected = clampi(int(data.get("title_selected",0)),0,5)
		login_last_date = str(data.get("login_last_date",""))
		login_streak = clampi(int(data.get("login_streak",0)),0,7)
		login_claimed = bool(data.get("login_claimed",false))
		souls = maxi(0,int(data.get("souls",0)))
		rebirths = maxi(0,int(data.get("rebirths",0)))
		best_stage_ever = maxi(frontier,int(data.get("best_stage_ever",frontier)))
		load_int_array(data.get("soul_ranks",[]),soul_ranks)
		total_offline_seconds = maxi(0,int(data.get("total_offline_seconds",0)))
		last_saved_unix = maxi(0,int(data.get("last_saved_unix",0)))

func effective_damage() -> int:
	var base := int(round(damage * float(POWER[equipped]))) if equipped >= 0 else damage
	var bonus := 1.0
	if title_selected == 1: bonus = 1.05
	elif title_selected == 2: bonus = 1.10
	elif title_selected == 5: bonus = 1.25
	return int(round(base * bonus * (1.0 + soul_ranks[0]*0.10)))

func weapon_color(id: int) -> Color:
	return Color(COLORS[floori(id / 5.0)]) if id >= 0 else Color("#d9e8ed")

func roll_weapon() -> int:
	var r := randf()*100.0
	var bounds := [50.0,80.0,95.0,99.0,99.9,100.0]
	for i in range(6):
		if r < bounds[i]:
			return i*5+randi_range(0,4)
	return 29

func build_inventory() -> void:
	inventory_list = ItemList.new()
	inventory_list.position = Vector2.ZERO
	inventory_list.size = Vector2(510,470)
	inventory_list.max_columns = 2
	inventory_list.add_theme_font_size_override("font_size",16)
	content.add_child(inventory_list)
	inventory_list.item_selected.connect(select_weapon)
	detail = make_label("",Vector2(530,0),16,content)
	equip_button = make_button("Экипировать",Vector2(530,85),Vector2(225,42),content)
	equip_button.pressed.connect(equip_selected)
	var best := make_button("Лучший меч",Vector2(767,85),Vector2(225,42),content)
	best.pressed.connect(equip_best)
	merge_button = make_button("Объединить 5 → 1 следующий",Vector2(530,135),Vector2(462,42),content)
	merge_button.pressed.connect(merge_selected)
	var all := make_button("Объединить все доступные",Vector2(530,190),Vector2(462,44),content)
	all.pressed.connect(merge_all)
	var filter := OptionButton.new()
	filter.position = Vector2(530,250)
	filter.size = Vector2(462,42)
	filter.add_item("Все редкости")
	for r in RARITY:
		filter.add_item(r)
	filter.select(rarity_filter+1)
	content.add_child(filter)
	filter.item_selected.connect(filter_weapons)
	var summon_link := make_button("✦ ПРИЗВАТЬ ОРУЖИЕ",Vector2(530,317),Vector2(462,55),content)
	summon_link.add_theme_stylebox_override("normal",panel_style(Color("#655034")))
	summon_link.pressed.connect(show_tab.bind(3))
	make_label("Призыв ×1 / ×10 за кристаллы",Vector2(575,388),15,content)
	refresh_inventory()

func filter_weapons(i: int) -> void:
	rarity_filter = i-1
	refresh_inventory()

func merge_all() -> void:
	for i in range(29):
		var n := floori(owned[i]/5.0)
		owned[i] -= n*5
		owned[i+1] += n
		if equipped == i and owned[i]==0:
			equipped = i+1
	save_game()
	refresh_inventory()
	update_ui()

func refresh_inventory() -> void:
	inventory_list.clear()
	weapon_ids.clear()
	for i in range(30):
		if rarity_filter >= 0 and floori(i/5.0) != rarity_filter:
			continue
		weapon_ids.append(i)
		inventory_list.add_item("%s  ×%d%s" % [WEAPONS[i],owned[i],"  [E]" if equipped == i else ""])
		inventory_list.set_item_custom_fg_color(weapon_ids.size()-1,weapon_color(i) if owned[i]>0 else Color("#68788a"))
	if selected not in weapon_ids:
		selected = weapon_ids[0]
	inventory_list.select(weapon_ids.find(selected))
	inventory_list.ensure_current_is_visible()
	refresh_detail()

func select_weapon(i: int) -> void:
	selected = weapon_ids[i]
	refresh_detail()

func refresh_detail() -> void:
	detail.text = "%s • %s\nУрон ×%.2f  |  В наличии: %d\nНадето: %s" % [WEAPONS[selected],RARITY[floori(selected / 5.0)],POWER[selected],owned[selected],WEAPONS[equipped] if equipped>=0 else "Начальный меч"]
	detail.modulate = weapon_color(selected)
	equip_button.disabled = owned[selected] == 0 or equipped == selected
	merge_button.disabled = selected == 29 or owned[selected] < 5

func equip_selected() -> void:
	if owned[selected] <= 0:
		return
	equipped = selected
	message.text = "Экипировано: " + WEAPONS[equipped]
	save_game()
	refresh_inventory()
	update_ui()

func equip_best() -> void:
	for i in range(29,-1,-1):
		if owned[i] > 0:
			selected = i
			equip_selected()
			return

func merge_selected() -> void:
	if selected >= 29 or owned[selected] < 5:
		return
	owned[selected] -= 5
	owned[selected+1] += 1
	if equipped == selected and owned[selected] == 0:
		equipped = selected+1
	selected += 1
	message.text = "Создан меч: " + WEAPONS[selected]
	save_game()
	refresh_inventory()
	update_ui()

func build_summon() -> void:
	summon_info = make_label("",Vector2.ZERO,17,content)
	summon_one = make_button("Призыв ×1  •  10 кристаллов",Vector2(0,53),Vector2(462,40),content)
	summon_one.pressed.connect(do_summon.bind(1))
	summon_ten = make_button("Призыв ×10  •  90 кристаллов",Vector2(480,53),Vector2(462,40),content)
	summon_ten.pressed.connect(do_summon.bind(10))
	summon_result = make_label("",Vector2(0,102),14,content)
	summon_result.size = Vector2(942,200)
	summon_result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	make_label("Оружие и навыки: одинаковые шансы редкости",Vector2(0,390),18,content)
	refresh_summon()

func refresh_summon() -> void:
	summon_info.text = "Уровень призыва: %d  |  Всего: %d  |  До награды: %d\nШансы: 50 / 30 / 15 / 4 / 0.9 / 0.1%% • Каждые 10 призывов: +20 кристаллов" % [1+floori(summons/10.0),summons,10-summons%10]
	summon_one.disabled = crystals < 10
	summon_ten.disabled = crystals < 90
	summon_result.text = recent_rolls

func do_summon(n: int) -> void:
	var fee := 10 if n == 1 else 90
	if crystals < fee:
		return
	crystals -= fee
	var previous := floori(summons/10.0)
	var results := PackedStringArray()
	for i in range(n):
		var id := roll_weapon()
		owned[id] += 1
		results.append(WEAPONS[id])
	summons += n
	total_weapon_rolls += n
	daily_progress[2] += n
	var bonus := (floori(summons/10.0)-previous)*20
	crystals += bonus
	recent_rolls = "Получено: " + ", ".join(results)
	if bonus > 0:
		recent_rolls += " • Награда: +%d кристаллов" % bonus
	save_game()
	update_ui()


func max_mana() -> float:
	return 100.0 + mana_rank*10.0

func refresh_cast() -> void:
	auto_global.text = "Авто: " + ("ВКЛ" if auto_skill else "ВЫКЛ")
	mana_bar.max_value = max_mana()
	mana_bar.value = mana
	mana_label.text = "Мана: %d / %d  •  +%d/сек  •  Авто: %s" % [int(mana),int(max_mana()),8+regen_rank*2,"ВКЛ" if auto_skill else "ВЫКЛ"]
	for i in range(cast_buttons.size()):
		var id := slots[i]
		var b := cast_buttons[i]
		if id < 0:
			b.text = "%d • Пусто" % (i+1)
			b.disabled = true
		else:
			b.text = "%d • %s %s" % [i+1,SKILLS[id],"%.1fс" % cooldown[id] if cooldown[id]>0 else ""]
			b.disabled = cooldown[id]>0 or mana<SK_MP[id] or skill_level[id]==0
			b.add_theme_color_override("font_color",Color(COLORS[floori(id/2.0)]))

func cast_slot(i: int) -> void:
	if boss_failed:
		return
	var id := slots[i]
	if id < 0 or skill_level[id]==0 or cooldown[id]>0 or mana<SK_MP[id]:
		return
	mana -= SK_MP[id]
	total_skill_casts += 1
	daily_progress[3] += 1
	cooldown[id] = SK_CD[id]
	fx_id = id
	fx_damage = int(round(effective_damage()*SK_POWER[id]*(1.0+0.15*(skill_level[id]-1))*(1.20 if title_selected == 4 else 1.0)))
	skill_fx = 0.7
	hp -= fx_damage
	check_victory()
	update_ui()

func build_skills() -> void:
	slot_buttons.clear()
	skill_list = ItemList.new()
	skill_list.size = Vector2(310,480)
	content.add_child(skill_list)
	skill_list.item_selected.connect(select_skill)
	skill_detail = make_label("",Vector2(320,0),15,content)
	for i in range(4):
		var b := make_button("",Vector2(320+i*87,58),Vector2(83,34),content)
		b.pressed.connect(assign_skill.bind(i))
		slot_buttons.append(b)
	var upgrade := make_button("Улучшить за золото",Vector2(320,120),Vector2(344,34),content)
	upgrade.pressed.connect(upgrade_skill)
	var merge := make_button("Объединить 5 копий",Vector2(320,170),Vector2(344,34),content)
	merge.pressed.connect(merge_skill)
	var summon := make_button("Призыв • 15 💎",Vector2(700,0),Vector2(270,32),content)
	summon.pressed.connect(summon_skill)
	auto_button = make_button("",Vector2(700,36),Vector2(270,32),content)
	auto_button.pressed.connect(toggle_auto)
	var mp := make_button("Мана +10 • 200G × ур.",Vector2(700,72),Vector2(270,32),content)
	mp.pressed.connect(buy_mana.bind(false))
	var regen := make_button("Реген +2 • 250G × ур.",Vector2(700,108),Vector2(270,32),content)
	regen.pressed.connect(buy_mana.bind(true))
	var clear := make_button("Снять выбранный навык",Vector2(700,144),Vector2(270,32),content)
	clear.pressed.connect(clear_skill)
	refresh_skills()

func refresh_skills() -> void:
	if active_tab != 4:
		return
	skill_list.clear()
	for i in range(12):
		skill_list.add_item("%s • ур.%d • копий %d" % [SKILLS[i],skill_level[i],copies[i]])
		skill_list.set_item_custom_fg_color(i,Color(COLORS[floori(i/2.0)]) if skill_level[i]>0 else Color.GRAY)
	skill_list.select(skill_selected)
	skill_list.ensure_current_is_visible()
	var id := skill_selected
	skill_detail.text = "%s • %d%% • %d MP • %.0fс\nУр.%d | Цена улучшения: %d G" % [SKILLS[id],int(SK_POWER[id]*100*(1+0.15*maxi(0,skill_level[id]-1))),SK_MP[id],SK_CD[id],skill_level[id],skill_price(id)]
	for i in range(4):
		slot_buttons[i].text = "Слот %d%s" % [i+1," ✓" if slots[i]==id else ""]
	auto_button.text = "Авто: " + ("ВКЛ" if auto_skill else "ВЫКЛ")

func select_skill(i: int) -> void:
	skill_selected = i
	refresh_skills()

func assign_skill(i: int) -> void:
	if skill_level[skill_selected]==0:
		message.text = "Сначала открой навык"
		return
	for j in range(4):
		if slots[j]==skill_selected:
			slots[j]=-1
	slots[i]=skill_selected
	save_game()
	refresh_skills()

func clear_skill() -> void:
	for i in range(4):
		if slots[i]==skill_selected:
			slots[i]=-1
	save_game()
	refresh_skills()

func skill_price(id: int) -> int:
	return 100*(id+1)*maxi(1,skill_level[id])

func upgrade_skill() -> void:
	var id := skill_selected
	if skill_level[id]==0 or skill_level[id]>=100 or gold<skill_price(id):
		message.text = "Навык закрыт, максимум или мало золота"
		return
	gold-=skill_price(id)
	skill_level[id]+=1
	save_game()
	refresh_skills()
	update_ui()

func merge_skill() -> void:
	var id := skill_selected
	if copies[id]<5 or skill_level[id]>=100:
		message.text = "Нужно 5 копий навыка"
		return
	copies[id]-=5
	skill_level[id]+=1
	save_game()
	refresh_skills()

func summon_skill() -> void:
	if crystals<15:
		message.text = "Нужно 15 кристаллов"
		return
	crystals-=15
	var id := floori(roll_weapon()/5.0)*2+randi_range(0,1)
	if skill_level[id]==0:
		skill_level[id]=1
	else:
		copies[id]+=1
	skill_selected=id
	message.text = "Получен навык: "+SKILLS[id]
	recent_rolls = message.text
	save_game()
	refresh_skills()
	update_ui()

func toggle_auto() -> void:
	auto_skill = not auto_skill
	save_game()
	refresh_skills()

func buy_mana(regen: bool) -> void:
	var fee := 250*(regen_rank+1) if regen else 200*(mana_rank+1)
	if gold<fee or (regen_rank if regen else mana_rank)>=100:
		message.text = "Мало золота или достигнут максимум"
		return
	gold-=fee
	if regen:
		regen_rank+=1
	else:
		mana_rank+=1
		mana+=10
	save_game()
	update_ui()

func toggle_shake() -> void:
	shake_enabled = not shake_enabled
	save_game()
	show_tab(5)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()

func build_world() -> void:
	make_label("КАРТА МИРА • открытый этап: %d" % frontier,Vector2.ZERO,24,content)
	for i in range(5):
		var b := make_button(ZONES[i]+"  •  этап %d" % (i*50+1),Vector2(0,45+i*65),Vector2(600,55),content)
		b.disabled = frontier < i*50+1
		b.pressed.connect(start_farm.bind(i*50+1))
	var back := make_button("Фарм предыдущего этапа",Vector2(620,45),Vector2(410,55),content)
	back.pressed.connect(start_farm.bind(maxi(1,frontier-1)))
	var retry := make_button("Продолжить / повторить босса",Vector2(620,115),Vector2(410,55),content)
	retry.pressed.connect(resume_world)
	make_label("Фарм повторяет выбранный этап.
Продолжить — вернуться к прогрессу.",Vector2(620,190),17,content)
func start_farm(target: int) -> void:
	dungeon = -1
	stage = clampi(target,1,frontier)
	farming = true
	spawn_enemy()
	show_tab(0)
func resume_world() -> void:
	dungeon = -1
	farming = false
	stage = frontier
	spawn_enemy()
	show_tab(0)
func build_dungeons() -> void:
	make_label("ПОДЗЕМЕЛЬЯ • завершено: %d" % dungeon_runs,Vector2.ZERO,24,content)
	for i in range(3):
		var b := make_button(["Золотая шахта • золото","Кристальное святилище • 30 кристаллов","Зал опыта • опыт"][i],Vector2(0,65+i*100),Vector2(750,80),content)
		b.disabled = frontier < 10
		b.pressed.connect(start_dungeon.bind(i))
	make_label("Открываются на этапе 10. Победи пять усиленных врагов.",Vector2(0,390),19,content)
func start_dungeon(id: int) -> void:
	if frontier < 10: return
	dungeon = id
	dungeon_left = 5
	farming = false
	stage = maxi(1,frontier- frontier%10 + 1)
	spawn_enemy()
	show_tab(0)


func load_int_array(source: Variant, target: Array[int]) -> void:
	if source is Array:
		for i in range(mini(source.size(),target.size())):
			target[i] = maxi(0,int(source[i]))

func load_bool_array(source: Variant, target: Array[bool]) -> void:
	if source is Array:
		for i in range(mini(source.size(),target.size())):
			target[i] = bool(source[i])

func today_key() -> String:
	return Time.get_date_string_from_system()

func refresh_calendar() -> void:
	var today := today_key()
	if daily_date != today:
		daily_date = today
		daily_progress = [0,0,0,0,0]
		daily_claimed = [false,false,false,false,false]
		daily_chest_claimed = false
	if login_last_date != today:
		login_claimed = false
		var previous: int = Time.get_unix_time_from_datetime_string(login_last_date + "T00:00:00") if login_last_date.length() == 10 else 0
		var current := Time.get_unix_time_from_datetime_string(today + "T00:00:00")
		if previous > 0 and current - previous == 86400:
			login_streak = mini(login_streak+1,7)
		else:
			login_streak = 1
		login_last_date = today
		save_game()

func build_daily() -> void:
	refresh_calendar()
	make_label("ЕЖЕДНЕВНЫЕ ЗАДАНИЯ • " + daily_date,Vector2(0,0),24,content)
	for i in range(5):
		var progress := mini(daily_progress[i],DAILY_TARGETS[i])
		var reward := ("%d G" % DAILY_GOLD[i]) if DAILY_GOLD[i] > 0 else ("%d кристаллов" % DAILY_CRYSTALS[i])
		var label := "%s   %d/%d   •   %s" % [DAILY_NAMES[i],progress,DAILY_TARGETS[i],reward]
		var b := make_button(label + ("  ✓" if daily_claimed[i] else "  [ЗАБРАТЬ]"),Vector2(0,48+i*68),Vector2(1010,57),content)
		b.disabled = daily_claimed[i] or progress < DAILY_TARGETS[i]
		b.pressed.connect(claim_daily.bind(i))
	var chest := make_button("Бонус за все задания: 100 кристаллов" + (" ✓" if daily_chest_claimed else "  [ЗАБРАТЬ]"),Vector2(0,404),Vector2(1010,60),content)
	chest.disabled = daily_chest_claimed or daily_claimed.has(false)
	chest.pressed.connect(claim_daily_chest)

func claim_daily(i: int) -> void:
	refresh_calendar()
	if daily_claimed[i] or daily_progress[i] < DAILY_TARGETS[i]: return
	daily_claimed[i] = true
	gold += DAILY_GOLD[i]
	crystals += DAILY_CRYSTALS[i]
	message.text = "Ежедневное задание выполнено!"
	save_game()
	call_deferred("show_tab",9)

func claim_daily_chest() -> void:
	refresh_calendar()
	if daily_chest_claimed or daily_claimed.has(false): return
	daily_chest_claimed = true
	crystals += 100
	message.text = "Сундук заданий: +100 кристаллов"
	save_game()
	call_deferred("show_tab",9)

func achievement_value(i: int) -> int:
	match i:
		0,1: return total_kills
		2:
			var unique := 0
			for count in owned:
				if count > 0: unique += 1
			return unique
		3:
			var unique := 0
			for rank in skill_level:
				if rank > 0: unique += 1
			return unique
		4,7: return frontier
		5: return dungeon_runs
		6: return total_weapon_rolls
	return 0

func achievement_target(i: int) -> int:
	return [100,1000,20,12,500,10,100,100][i]

func build_achievements() -> void:
	make_label("ДОСТИЖЕНИЯ • постоянные награды",Vector2.ZERO,24,content)
	for i in range(8):
		var b := make_button("%s  •  %d/%d  •  +%d 💎%s" % [ACH_NAMES[i],mini(achievement_value(i),achievement_target(i)),achievement_target(i),ACH_REWARDS[i],"  ✓" if achievements_claimed[i] else "  [ЗАБРАТЬ]"],Vector2(0,40+i*55),Vector2(1010,49),content)
		b.disabled = achievements_claimed[i] or achievement_value(i) < achievement_target(i)
		b.pressed.connect(claim_achievement.bind(i))

func claim_achievement(i: int) -> void:
	if achievements_claimed[i] or achievement_value(i) < achievement_target(i): return
	achievements_claimed[i] = true
	crystals += ACH_REWARDS[i]
	message.text = "Достижение: " + ACH_NAMES[i]
	save_game()
	call_deferred("show_tab",10)

func build_story() -> void:
	make_label("ПУТЬ ЛЕГЕНДЫ • сюжетные главы",Vector2.ZERO,24,content)
	make_label("Пробудившийся рыцарь исследует земли, поражённые тьмой.",Vector2(0,42),18,content)
	for i in range(5):
		var b := make_button("Глава %d: %s  •  +%d 💎%s" % [i+1,STORY_NAMES[i],STORY_REWARDS[i],"  ✓" if story_claimed[i] else "  [ЗАБРАТЬ]"],Vector2(0,90+i*72),Vector2(1010,61),content)
		b.disabled = story_claimed[i] or frontier < STORY_STAGES[i]
		b.pressed.connect(claim_story.bind(i))

func claim_story(i: int) -> void:
	if story_claimed[i] or frontier < STORY_STAGES[i]: return
	story_claimed[i] = true
	crystals += STORY_REWARDS[i]
	message.text = "Глава завершена: " + STORY_NAMES[i]
	save_game()
	call_deferred("show_tab",11)

func title_unlocked(i: int) -> bool:
	match i:
		0: return true
		1: return total_kills >= 100
		2: return total_kills >= 1000
		3: return total_weapon_rolls >= 100
		4: return total_skill_casts >= 500
		5: return frontier >= 500
	return false

func build_titles() -> void:
	make_label("ТИТУЛЫ • активен: " + TITLE_NAMES[title_selected],Vector2.ZERO,24,content)
	var descriptions := ["Без бонусов","+5% к базовому урону","+10% к базовому урону","+15% к критическому урону","+20% к урону навыков","+25% к базовому урону"]
	for i in range(6):
		var b := make_button("%s  •  %s%s" % [TITLE_NAMES[i],descriptions[i],"  [ВЫБРАН]" if title_selected == i else "  [НАДЕТЬ]"],Vector2(0,47+i*66),Vector2(1010,58),content)
		b.disabled = not title_unlocked(i) or title_selected == i
		b.pressed.connect(select_title.bind(i))
	make_label("Открытие: 100 / 1000 убийств, 100 призывов, 500 навыков, этап 500.",Vector2(0,457),17,content)

func select_title(i: int) -> void:
	if not title_unlocked(i): return
	title_selected = i
	message.text = "Титул: " + TITLE_NAMES[i]
	save_game()
	call_deferred("show_tab",12)

func build_login_reward() -> void:
	refresh_calendar()
	var day := clampi(login_streak,1,7)
	login_reward_day = day
	var reward := ""
	if day == 7: reward = "Особый сундук: 200 кристаллов и редкий меч"
	elif day % 2 == 0: reward = "%d кристаллов" % (day*15)
	else: reward = "%d золота" % (day*1000)
	make_label("ЕЖЕДНЕВНЫЙ ВХОД • день %d/7" % day,Vector2(0,0),24,content)
	make_label("Награда: " + reward,Vector2(0,55),21,content)
	var b := make_button("НАГРАДА ПОЛУЧЕНА" if login_claimed else "ЗАБРАТЬ НАГРАДУ",Vector2(0,110),Vector2(550,65),content)
	b.disabled = login_claimed
	b.pressed.connect(claim_login)
	make_label("Награда доступна один раз за календарный день.
7-й день: особый сундук. При пропуске дня серия начинается заново.",Vector2(0,210),18,content)

func claim_login() -> void:
	refresh_calendar()
	if login_claimed: return
	login_claimed = true
	var day := clampi(login_streak,1,7)
	if day == 7:
		crystals += 200
		var id := randi_range(10,14)
		owned[id] += 1
		message.text = "Сундук 7-го дня: 200 кристаллов и " + WEAPONS[id]
	elif day % 2 == 0:
		crystals += day*15
		message.text = "Ежедневный вход: кристаллы"
	else:
		gold += day*1000
		message.text = "Ежедневный вход: золото"
	save_game()
	call_deferred("show_tab",13)


# Soul Slayer 0.8: idle rewards and prestige progression.
func calculate_offline_rewards() -> void:
	if last_saved_unix <= 0:
		return
	var now := int(Time.get_unix_time_from_system())
	var seconds := clampi(now - last_saved_unix,0,OFFLINE_LIMIT)
	if seconds < 60:
		return
	var bonus := 1.0 + soul_ranks[4] * 0.20
	var minutes := float(seconds) / 60.0
	var reward_gold := int(round(minutes * (15.0 + float(frontier) * 1.5) * bonus * (1.0+soul_ranks[1]*0.10)))
	var reward_xp := int(round(minutes * (5.0 + float(frontier) * 0.35) * bonus * (1.0+soul_ranks[2]*0.10)))
	gold += reward_gold
	xp += reward_xp
	while xp >= hero_level * 50:
		xp -= hero_level * 50
		hero_level += 1
	total_offline_seconds += seconds
	offline_gold_last = reward_gold
	offline_xp_last = reward_xp
	offline_report = "Отсутствие: %d ч %d мин\nЗолото: +%s\nОпыт: +%s\nМаксимум: 12 часов." % [int(seconds / 3600),int((seconds % 3600) / 60),short_num(reward_gold),short_num(reward_xp)]
	last_saved_unix = now
	save_game()

func show_offline_popup() -> void:
	# Styled modal, not Godot's default AcceptDialog.
	var shade := ColorRect.new()
	shade.color = Color(0.035,0.06,0.11,0.82)
	shade.position = Vector2.ZERO
	shade.size = Vector2(1280,800)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	shade.z_index = 80
	add_child(shade)
	var panel := PanelContainer.new()
	panel.position = Vector2(370,165)
	panel.size = Vector2(540,470)
	panel.add_theme_stylebox_override("panel",panel_style(Color("#152339")))
	shade.add_child(panel)
	var body := Control.new()
	body.custom_minimum_size = Vector2(540,470)
	panel.add_child(body)
	var heading := make_label("✦ НАГРАДА ЗА ОТСУТСТВИЕ",Vector2(28,22),24,body)
	heading.modulate = Color("#f0c77d")
	var subtitle := make_label("Герой продолжал добывать ресурсы!",Vector2(28,75),17,body)
	subtitle.modulate = Color("#aebfd7")
	# The report is kept for compatibility; use its recorded absence line.
	var lines := offline_report.split("\n")
	var duration := lines[0] if lines.size() > 0 else "Отсутствие"
	make_label(duration,Vector2(28,118),21,body)
	var gold_card := Panel.new()
	gold_card.position = Vector2(25,174)
	gold_card.size = Vector2(233,125)
	gold_card.add_theme_stylebox_override("panel",panel_style(Color("#29394d")))
	body.add_child(gold_card)
	var xp_card := Panel.new()
	xp_card.position = Vector2(278,174)
	xp_card.size = Vector2(233,125)
	xp_card.add_theme_stylebox_override("panel",panel_style(Color("#29394d")))
	body.add_child(xp_card)
	var g := make_label("ЗОЛОТО\n+" + short_num(offline_gold_last),Vector2(20,22),21,gold_card)
	g.modulate = Color("#f0c77d")
	var x := make_label("ОПЫТ\n+" + short_num(offline_xp_last),Vector2(20,22),21,xp_card)
	x.modulate = Color("#82baff")
	var note := make_label("Максимум накопления: 12 часов",Vector2(28,328),16,body)
	note.modulate = Color("#aebfd7")
	var collect := make_button("ЗАБРАТЬ НАГРАДУ",Vector2(25,376),Vector2(486,58),body)
	collect.add_theme_stylebox_override("normal",panel_style(Color("#84663a")))
	collect.add_theme_font_size_override("font_size",19)
	collect.pressed.connect(shade.queue_free)
	offline_report = ""

func soul_price(id: int) -> int:
	return int(5 * pow(2.0,soul_ranks[id]))

func souls_on_rebirth() -> int:
	return maxi(0,int(floor(float(frontier - 1) / 25.0)))

func build_rebirth() -> void:
	make_label("ПЕРЕРОЖДЕНИЕ • ДРЕВО ДУШ",Vector2(0,0),24,content)
	make_label("Души: %d   •   Перерождений: %d   •   Рекорд этапа: %d" % [souls,rebirths,best_stage_ever],Vector2(0,43),19,content)
	make_label("При перерождении: +%d душ (доступно с этапа 100)" % souls_on_rebirth(),Vector2(0,75),18,content)
	var rebirth_button := make_button("ПЕРЕРОДИТЬСЯ",Vector2(0,112),Vector2(380,55),content)
	rebirth_button.disabled = frontier < 100
	rebirth_button.pressed.connect(confirm_rebirth)
	make_label("Сбрасываются: этап, золото, базовые улучшения, уровень героя и опыт.\nСохраняются: оружие, навыки, кристаллы, души, титулы, сюжет, достижения.",Vector2(0,180),16,content)
	for i in range(5):
		var description: String = ["Урон +10%", "Золото +10%", "Опыт +10%", "Шанс крита +0.5%", "Офлайн-награды +20%"][i]
		var b := make_button("%s (ур. %d) • %s • %d душ" % [SOUL_NAMES[i],soul_ranks[i],description,soul_price(i)],Vector2(0,240+i*49),Vector2(760,43),content)
		b.disabled = souls < soul_price(i)
		b.pressed.connect(buy_soul_upgrade.bind(i))
	make_label("Всего офлайн: %d ч • Последняя награда: %s G / %s XP" % [int(total_offline_seconds / 3600),short_num(offline_gold_last),short_num(offline_xp_last)],Vector2(780,260),14,content)

func buy_soul_upgrade(id: int) -> void:
	var amount := soul_price(id)
	if souls < amount:
		return
	souls -= amount
	soul_ranks[id] += 1
	save_game()
	show_tab(14)

func confirm_rebirth() -> void:
	if frontier < 100:
		return
	var dialog := ConfirmationDialog.new()
	dialog.title = "Подтвердить перерождение"
	dialog.dialog_text = "Получить %d душ? Этап, золото, уровень героя и обычные улучшения будут сброшены. Коллекции и постоянный прогресс сохранятся." % souls_on_rebirth()
	dialog.confirmed.connect(do_rebirth)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.canceled.connect(dialog.queue_free)
	add_child(dialog)
	dialog.popup_centered()

func do_rebirth() -> void:
	if frontier < 100:
		return
	best_stage_ever = maxi(best_stage_ever,frontier)
	souls += souls_on_rebirth()
	rebirths += 1
	gold = 0
	stage = 1
	frontier = 1
	farming = false
	dungeon = -1
	dungeon_left = 0
	boss_failed = false
	damage = 10
	cost = 20
	ranks = [0,0,0,0]
	hero_level = 1
	xp = 0
	elapsed = 0.0
	spawn_enemy()
	message.text = "Перерождение завершено! Постоянные бонусы активны."
	save_game()
	show_tab(14)
