extends Node2D

# --- 1. Resource and Node References ---
const DIRT_PATH_SCENE = preload("res://Assets/dirt_Path.tscn")
const WATER_ANIM_SCENE = preload("res://Assets/animated_sprite_2d.tscn")

@onready var tile_layer = $TileLayer
@onready var player = $Player
@onready var paths_container = $Paths
@onready var digs_label = $Player/Digs
@onready var timer_label = $Player/Timer   # ⏱️ Label that displays the countdown

# --- 2. Game Settings ---
const TILE_SIZE = 16
const MAX_DIGS = 1000
var digs_left = MAX_DIGS
var placed_paths: Dictionary = {}   # stores Vector2i → node (dirt or water)

# Timer variables
const START_TIME = 60  # 1 minutes 
var time_left = START_TIME
var countdown_active = true

# --- 3. Setup ---
func _ready() -> void:
	if not InputMap.has_action("Place"):
		push_warning("Action 'Place' not found in Input Map! Please add it in Project Settings > Input Map.")
	_update_digs_label()
	_update_timer_label()

# --- 4. Game Loop ---
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Place"):
		place_dirt_path()

	# Countdown timer ⏳
	if countdown_active:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			countdown_active = false
			_on_timer_finished()
		_update_timer_label()

# --- 5. Place Path Function ---
func place_dirt_path() -> void:
	if digs_left <= 0 or not countdown_active:
		digs_label.add_theme_color_override("font_color", Color.RED)
		return

	var tile_coords = Vector2i(
		int(round(player.global_position.x / TILE_SIZE)),
		int(round(player.global_position.y / TILE_SIZE))
	)

	# Prevent placing twice on same tile
	if placed_paths.has(tile_coords):
		return

	var tile_world_pos = Vector2(tile_coords.x * TILE_SIZE, tile_coords.y * TILE_SIZE)

	# If borderline → automatically water
	if _is_on_any_border(tile_coords):
		_place_water_animation(tile_world_pos, tile_coords)
	else:
		# Normal dirt placement
		var new_dirt = DIRT_PATH_SCENE.instantiate()
		new_dirt.global_position = tile_world_pos

		if paths_container:
			paths_container.add_child(new_dirt)
		else:
			add_child(new_dirt)

		placed_paths[tile_coords] = new_dirt

	digs_left -= 1
	_update_digs_label()

	# NEW: auto-water-spread
	_spread_water_from(tile_coords)

	_check_connection_lake_to_area1()

# --- 6. Place Water Animation ---
func _place_water_animation(tile_world_pos: Vector2, tile_coords: Vector2i) -> void:
	var water = WATER_ANIM_SCENE.instantiate()
	water.global_position = tile_world_pos

	if paths_container:
		paths_container.add_child(water)
	else:
		add_child(water)

	placed_paths[tile_coords] = water

	print("💧 Water placed at:", tile_coords)

	# NEW: auto-spread water outward
	_spread_water_from(tile_coords)

# --- 7. Update Labels ---
func _update_digs_label() -> void:
	digs_label.text = "Digs: " + str(digs_left)
	if digs_left > 0:
		digs_label.add_theme_color_override("font_color", Color.WHITE)

func _update_timer_label() -> void:
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	timer_label.text = "Time: %02d:%02d" % [minutes, seconds]

# --- Timer Finished ---
func _on_timer_finished() -> void:
	timer_label.add_theme_color_override("font_color", Color.RED)
	print("⏰ Time’s up!")

# --- 8. Border Checks ---
func _is_on_lake_border(tile: Vector2i) -> bool:
	return tile.y == 79 and tile.x >= 41 and tile.x <= 110

func _is_on_area1_border(tile: Vector2i) -> bool:
	return tile.x == 109 and tile.y >= 31 and tile.y <= 57

func _is_on_area2_border(tile: Vector2i) -> bool:
	return tile.x == 110 and tile.y >= -38 and tile.y <= 3

func _is_on_area3_border(tile: Vector2i) -> bool:
	return tile.y == -48 and tile.x >= 52 and tile.x <= 114

func _is_on_any_border(tile: Vector2i) -> bool:
	return _is_on_lake_border(tile) \
		or _is_on_area1_border(tile) \
		or _is_on_area2_border(tile) \
		or _is_on_area3_border(tile)

# --- 9. Connection Check: Lake → Area 1 ---
func _check_connection_lake_to_area1() -> void:
	if placed_paths.is_empty():
		return

	var visited := {}
	var queue := []

	# Start from lake top border
	for x in range(41, 111):
		var tile = Vector2i(x, 79)
		if placed_paths.has(tile):
			queue.append(tile)
			visited[tile] = true

	while not queue.is_empty():
		var current = queue.pop_front()
		if _is_on_area1_border(current):
			print("✅ Connection established: Lake → Area 1!")
			return

		for dir in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
			var neighbor = current + dir
			if placed_paths.has(neighbor) and not visited.has(neighbor):
				visited[neighbor] = true
				queue.append(neighbor)

# --- 10. Water Spread System (NEW) ---

func _get_neighbors(tile: Vector2i) -> Array:
	return [
		tile + Vector2i(1,0),
		tile + Vector2i(-1,0),
		tile + Vector2i(0,1),
		tile + Vector2i(0,-1)
	]

func _convert_dirt_to_water(tile: Vector2i) -> void:
	if not placed_paths.has(tile):
		return

	# Already water
	if placed_paths[tile] is AnimatedSprite2D:
		return

	var old_dirt = placed_paths[tile]
	if old_dirt:
		old_dirt.queue_free()

	var water = WATER_ANIM_SCENE.instantiate()
	water.global_position = Vector2(tile.x * TILE_SIZE, tile.y * TILE_SIZE)

	if paths_container:
		paths_container.add_child(water)
	else:
		add_child(water)

	placed_paths[tile] = water

func _spread_water_from(tile: Vector2i) -> void:
	for n in _get_neighbors(tile):
		if placed_paths.has(n):
			if not (placed_paths[n] is AnimatedSprite2D):
				_convert_dirt_to_water(n)
				_spread_water_from(n)

# --- 11. Window Controls ---
func _on_button_pressed() -> void:
	$Window.show()

func _on_window_close_requested() -> void:
	$Window.hide()
