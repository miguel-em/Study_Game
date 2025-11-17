extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D  # Reference to Camera2D child
@export var zoom_speed = 5.0

#Movement Speed
const SPEED = 200

# --- Zoom Settings ---
const ZOOM_STEP = 0.1      # How much to zoom in/out each press
const MIN_ZOOM = 0.5       # Smallest allowed zoom
const MAX_ZOOM = 2.0       # Largest allowed zoom 

var target_zoom = Vector2.ONE


func _ready() -> void:
	if camera:
		target_zoom = camera.zoom


func _physics_process(delta: float) -> void:
	read_input()
	_handle_zoom_input()
	
	if camera:
		camera.zoom = camera.zoom.lerp(target_zoom, delta * zoom_speed)


# Reads the movement
func read_input() -> void:
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")

	velocity.x = input_direction.x * SPEED
	velocity.y = input_direction.y * SPEED

	if input_direction.length() == 0:
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("Walking")

		if input_direction.x > 0:
			animated_sprite.flip_h = false
		elif input_direction.x < 0:
			animated_sprite.flip_h = true

	move_and_slide()


# Camera Zoom Controls function
func _handle_zoom_input() -> void:
	if Input.is_action_just_pressed("ZoomOut"):  # = key
		_zoom_camera(-ZOOM_STEP)
	elif Input.is_action_just_pressed("ZoomIn"):  # - key
		_zoom_camera(ZOOM_STEP)


func _zoom_camera(amount: float) -> void:
	if not camera:
		return

	target_zoom += Vector2(amount, amount)
	target_zoom.x = clamp(target_zoom.x, MIN_ZOOM, MAX_ZOOM)
	target_zoom.y = clamp(target_zoom.y, MIN_ZOOM, MAX_ZOOM)
