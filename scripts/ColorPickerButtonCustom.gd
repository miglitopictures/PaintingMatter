extends ColorPickerButton

@onready var picker = get_picker()
# Called when the node enters the scene tree for the first time.
func _ready():
	picker.color_modes_visible = false
	picker.can_add_swatches = false
	picker.hex_visible = false
	picker.sliders_visible = false
	picker.presets_visible = false
	picker.sampler_visible = false
	pass # Replace with function body.
