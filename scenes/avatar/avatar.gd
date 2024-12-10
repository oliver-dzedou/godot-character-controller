extends CharacterBody2D

##############
# Dependencies
##############
@export var event_bus: Node
@export var state: Node
@export var wall_raycast_bottom_right: RayCast2D
@export var wall_raycast_bottom_left: RayCast2D
@export var wall_raycast_top_right: RayCast2D
@export var wall_raycast_top_left: RayCast2D
@export var ceiling_raycast: RayCast2D
@export var corner_clip_bottom_left: RayCast2D
@export var corner_clip_top_left: RayCast2D
@export var corner_clip_bottom_right: RayCast2D
@export var corner_clip_top_right: RayCast2D
@export var debug_texture: TextureRect
@export var debug: RichTextLabel
###############
# Configuration
###############
# Movement
@export var speed: float = 700
@onready var acceleration = 300
# Dash
@export var dash_speed: float = 1680
@export var dash_duration: float = 0.25
@export var dash_cooldown: float = 0.35
# Jump
@export var jump_velocity: float = -2620
# Double jump
@export var double_jump_velocity: float = -1700
# Wall jump
@export var wall_cling_duration = 0.2
@export var wall_jump_horizontal_velocity: float = 1000
@export var wall_jump_duration: float = 0.25
# Gravity
@export var jump_gravity: float = 6580
@export var fall_gravity: float = 5580
@export var jump_apex_gravity: float = 1030
# Grace periods
@export var cancel_wall_cling_grace_period: float = 0.1
@export var touching_ceiling_grace_period: float = 0.1
@export var on_floor_grace_period: float = 0.1
# Corner clip
@export var corner_clip_dashing_target_position: Vector2 = Vector2(150, 0)
@export var corner_clip_target_position: Vector2 = Vector2(75, 0)
# Bumped head
@export var bumped_head_left_middle: RayCast2D
@export var bumped_head_left_edge: RayCast2D
@export var bumped_head_right_middle: RayCast2D
@export var bumped_head_right_edge: RayCast2D
# Coyote time
@export var coyote_time: float = 0.1
# Jump buffer
@export var jump_buffer: float = 0.1

#########
# Signals
#########
signal is_facing_right_changed
signal is_moving_changed
signal jumped
signal is_on_floor_changed
signal is_wall_jumping_changed
signal is_dashing_changed
signal is_dash_on_cooldown_changed
signal is_clinging_to_wall_right_changed
signal is_clinging_to_wall_left_changed
signal is_touching_wall_right_changed
signal is_touching_wall_left_changed
signal last_wall_cling_changed
signal dash_counter_changed
signal jump_counter_changed
signal is_coyote_time_changed
signal is_jump_buffer_changed

###########
# Built-ins
###########
func _ready():
	Global.avatar = self
	debug_texture.hide()
	event_bus.move_input.connect(on_move_input)
	event_bus.jump_input.connect(on_jump_input)
	event_bus.jump_input_released.connect(on_jump_input_released)
	event_bus.dash_input.connect(on_dash_input)

func _physics_process(delta: float) -> void:
	debug.set_text(
		"velocity.x: " + str(velocity.x) + "\n" +
		"velocity.y: " + str(velocity.y) + "\n"
		
	)
	debug.set_text(
		"velocity.x: " + str(velocity.x) + "\n" +
		"velocity.y: " + str(velocity.y)
	)
	velocity.y += get_custom_gravity() * delta
	
	# Corner clip
	adjust_corner_clip()
	adjust_corner_clip_length()
	
	# Head bump
	adjust_bumped_head()
	
	# Adjust velocity for wall cling	
	if (state.is_clinging_to_wall_right or state.is_clinging_to_wall_left):
		velocity.y = 0
		
	# Adjust velocity for dashing
	if state.is_dashing:
		velocity.y = 0
	detect_is_touching_wall()
	detect_is_clinging_to_wall()
	detect_is_on_floor()
	move_and_slide()

######################
# Custom Functionality
###################### 
# Gravity
func get_custom_gravity() -> float:
	if velocity.y < -100:
		return jump_gravity
	if abs(velocity.y) <= 50:
		return jump_apex_gravity
	else:
		return fall_gravity

# Basic movement
func on_move_input(direction: float) -> void:
	if state.is_wall_jumping:
		return
	if direction:
		velocity.x = move_toward(velocity.x, speed * Util.get_normalised_direction(direction), acceleration)
		var is_facing_right = false	
		if direction > 0:
			is_facing_right = true
		emit_signal("is_facing_right_changed", is_facing_right)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	var is_moving = false
	if velocity.x != 0:
		is_moving = true
	emit_signal("is_moving_changed", is_moving)

# Jumping
func on_jump_input() -> void:
	if not state.is_on_floor and not state.is_coyote_time and state.jump_counter >= 2:
		Util.create_timer(jump_buffer, on_jump_buffer_expired)
		emit_signal("is_jump_buffer_changed", true)
	# Can't jump
	if state.is_dashing or state.jump_counter >= 2:
		return
	emit_signal("jumped")
	# Normal jump
	if state.is_on_floor or state.is_jump_buffer:
		emit_signal("jump_counter_changed", state.jump_counter + 1)
		velocity.y = jump_velocity
		return
	elif state.is_coyote_time:
		emit_signal("jump_counter_changed", state.jump_counter + 1)
		velocity.y = jump_velocity
		return
	# Double jump
	if not state.is_on_floor:

		# Wall jump left
		if state.is_clinging_to_wall_left:
			emit_signal("is_clinging_to_wall_left_changed", null)
			Util.create_timer(wall_jump_duration, on_wall_jump_finished)
			emit_signal("is_wall_jumping_changed", true)
			emit_signal("jump_counter_changed", state.jump_counter + 1)
			velocity.x = wall_jump_horizontal_velocity
			velocity.y = jump_velocity * 0.70
			return
		# Wall jump right
		if state.is_clinging_to_wall_right:
			emit_signal("is_clinging_to_wall_right_changed", null)
			Util.create_timer(wall_jump_duration, on_wall_jump_finished)
			emit_signal("is_wall_jumping_changed", true)
			emit_signal("jump_counter_changed", state.jump_counter + 1)
			velocity.x = -wall_jump_horizontal_velocity
			velocity.y = jump_velocity * 0.70
			return
		# Double jump
		emit_signal("jump_counter_changed", state.jump_counter + 1)
		velocity.y = double_jump_velocity
		return


func on_jump_input_released() -> void:
	if state.is_wall_jumping:
		return
	if velocity.y < 0:
		velocity.y = 150
				
func on_wall_jump_finished() -> void:
	emit_signal("is_wall_jumping_changed", false)

# Wall stuff
func detect_is_touching_wall() -> void:
	var top_right_collider = wall_raycast_top_right.get_collider()
	var bottom_right_collider = wall_raycast_bottom_right.get_collider()
	var top_left_collider = wall_raycast_top_left.get_collider()
	var bottom_left_collider = wall_raycast_bottom_left.get_collider()
	if not state.is_touching_wall_right and (top_right_collider != null or bottom_right_collider != null) and (top_right_collider == bottom_right_collider):
		emit_signal("is_touching_wall_right_changed", top_right_collider)
		emit_signal("is_dashing_changed", false)
	if state.is_touching_wall_right and (top_right_collider == null and bottom_right_collider == null):
		emit_signal("is_touching_wall_right_changed", null)
	if not state.is_touching_wall_left and (top_left_collider != null or bottom_left_collider != null) and (top_left_collider == bottom_left_collider):
		emit_signal("is_touching_wall_left_changed", top_left_collider)
		emit_signal("is_dashing_changed", false)
	if state.is_touching_wall_left and (top_left_collider == null and bottom_left_collider == null):
		emit_signal("is_touching_wall_left_changed", null)

func detect_is_clinging_to_wall() -> void:
	if not state.is_clinging_to_wall_right and state.is_touching_wall_right and velocity.x > 0 and (state.is_touching_wall_right != state.last_wall_cling.wall or state.last_wall_cling.side != "right"):
		Util.create_timer(wall_cling_duration, on_wall_cling_right_duration_expired)
		emit_signal("is_clinging_to_wall_right_changed", state.is_touching_wall_right)
		emit_signal("last_wall_cling_changed", { "wall": state.is_touching_wall_right, "side": "right" })
		emit_signal("jump_counter_changed", 0)
		emit_signal("dash_counter_changed", 0)
	if state.is_clinging_to_wall_right and not (state.is_touching_wall_right or velocity.x < 0):
		Util.create_timer(cancel_wall_cling_grace_period, on_cancel_wall_cling_right_grace_period_expired)
	if not state.is_clinging_to_wall_left and state.is_touching_wall_left and velocity.x < 0 and (state.is_touching_wall_left != state.last_wall_cling.wall or state.last_wall_cling.side != "left"):
		Util.create_timer(wall_cling_duration, on_wall_cling_left_duration_expired)
		emit_signal("is_clinging_to_wall_left_changed", state.is_touching_wall_left)
		emit_signal("last_wall_cling_changed", { "wall": state.is_touching_wall_left, "side": "left" })
		emit_signal("jump_counter_changed", 0)
		emit_signal("dash_counter_changed", 0)
	if state.is_clinging_to_wall_left and (not state.is_touching_wall_left or velocity.x > 0):
		Util.create_timer(cancel_wall_cling_grace_period, on_cancel_wall_cling_left_grace_period_expired)
		
func on_wall_cling_right_duration_expired() -> void:
	emit_signal("is_clinging_to_wall_right_changed", null)
	
func on_wall_cling_left_duration_expired() -> void:
	emit_signal("is_clinging_to_wall_left_changed", null)
	
func on_cancel_wall_cling_right_grace_period_expired() -> void:
	emit_signal("is_clinging_to_wall_right_changed", null)
	
func on_cancel_wall_cling_left_grace_period_expired() -> void:
	emit_signal("is_clinging_to_wall_left_changed", null)
	
# Floor stuff
func detect_is_on_floor() -> void:
	if is_on_floor():
		if not state.is_on_floor:
			emit_signal("jump_counter_changed", 0)
			emit_signal("dash_counter_changed", 0)
			emit_signal("last_wall_cling_changed", { "wall": null, "side": null })
			emit_signal("is_on_floor_changed", true)
			if state.is_jump_buffer:
				velocity.y = jump_velocity
		return
	elif state.is_on_floor and not is_on_floor():
		if not Input.is_action_pressed("jump"):
			Util.create_timer(coyote_time, on_coyote_time_expired)
			emit_signal("is_coyote_time_changed", true)
		emit_signal("is_on_floor_changed", false)
	

# Dash
func on_dash_input(direction: float) -> void:
	if state.is_dash_on_cooldown or state.dash_counter >= 1 or state.is_dashing:
		return
	if direction and direction != 0:
		velocity.x = Util.get_normalised_direction(direction) * dash_speed
	else:
		if state.is_facing_right:
			velocity.x = 1 * dash_speed
		else:
			velocity.x = -1 * dash_speed
	if not state.is_on_floor:
		emit_signal("dash_counter_changed", state.dash_counter + 1)
	emit_signal("is_dashing_changed", true)
	Util.create_timer(dash_duration, on_dash_finished)

func on_dash_finished() -> void:
	Util.create_timer(dash_cooldown, on_dash_cooldown_finished)
	emit_signal("is_dash_on_cooldown_changed", true)
	emit_signal("is_dashing_changed", false)

func on_dash_cooldown_finished() -> void:
	emit_signal("is_dash_on_cooldown_changed", false)
		
# Corner clip
func adjust_corner_clip() -> void:
	if corner_clip_bottom_right.is_colliding() and not corner_clip_top_right.is_colliding() and velocity.x != 0 and not is_on_floor():
		position.y = position.y - 2
		
func adjust_corner_clip_length() -> void:
	if state.is_dashing and velocity.x > 0:
		corner_clip_top_right.target_position = corner_clip_dashing_target_position
		corner_clip_bottom_right.target_position = corner_clip_dashing_target_position
	else:
		corner_clip_top_right.target_position = corner_clip_target_position
		corner_clip_bottom_right.target_position = corner_clip_target_position
		
	if state.is_dashing and velocity.x < 0:
		corner_clip_top_left.target_position = -corner_clip_dashing_target_position
		corner_clip_bottom_left.target_position = -corner_clip_dashing_target_position	
	else:
		corner_clip_top_left.target_position = -corner_clip_target_position
		corner_clip_bottom_left.target_position = -corner_clip_target_position

# Bumped head
func adjust_bumped_head() -> void:
	if velocity.y >= 0:
		return
	if bumped_head_left_edge.is_colliding() and not bumped_head_left_middle.is_colliding():
		position.x = position.x + 5
	if bumped_head_right_edge.is_colliding() and not bumped_head_right_middle.is_colliding():
		position.x = position.x -5
		
# Coyote time
func on_coyote_time_expired() -> void:
	emit_signal("is_coyote_time_changed", false)

# Jump buffer
func on_jump_buffer_expired() -> void:
	emit_signal("is_jump_buffer_changed", false)
