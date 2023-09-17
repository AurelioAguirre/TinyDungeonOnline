extends CharacterBody2D

const WALK_SPEED = 200

var chat_timer = 0
var chat_timeout = 0
var image_path
var player_id = "PlayerX"


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	var main = get_parent().get_parent()
	if str(multiplayer.get_unique_id()) == name:
		main.local_player_character = self
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chat_timer += delta
	if chat_timeout != 0 and chat_timer > chat_timeout:
		$PlayerChat.text = ""
		chat_timeout = 0
		
	if is_multiplayer_authority():
		velocity = Vector2.ZERO
		if Input.is_action_pressed("Up"):
			velocity.y += -1	
		if Input.is_action_pressed("Down"):
			velocity.y += 1
		if Input.is_action_pressed("Left"):
			velocity.x += -1
		if Input.is_action_pressed("Right"):
			velocity.x += 1
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * WALK_SPEED
		
		move_and_slide()

func set_the_player_image():
	var character_texture = load(image_path)
	$PlayerImage.set_texture(character_texture)
	
	
#@rpc("call_local")
#func change_player_image(img_path):
#	image_path = img_path
#	set_player_image()

#@rpc("call_local")
#func send_image_path():
#	rpc("change_player_image", image_path)

@rpc("authority", "call_local", "reliable", 1)
func display_chat_message(message):
	$PlayerChat.text = message
	chat_timeout = chat_timer + 8

