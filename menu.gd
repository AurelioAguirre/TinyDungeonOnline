extends CanvasLayer

var menu_dict = {
	"gender":"male",
	"male_image_path":"res://assets/male_character.png",
	"female_image_path":"res://assets/female_character.png"
}

@onready var character_image = $MenuPanel/GenderPanel/CharacterImage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_male_button_down():
	if menu_dict["gender"] != "male":
		var char_texture = load(menu_dict["male_image_path"])
		character_image.set_texture(char_texture)
		menu_dict["gender"] = "male"


func _on_female_button_down():
	if menu_dict["gender"] != "female":
		var char_texture = load(menu_dict["female_image_path"])
		character_image.set_texture(char_texture)
		menu_dict["gender"] = "female"
