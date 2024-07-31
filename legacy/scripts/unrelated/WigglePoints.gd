extends Node2D

# Reference to the Line2D node
var line2d_node: Line2D

# Random number generator
var rng = RandomNumberGenerator.new()

func _ready():
	# Get the Line2D node
	line2d_node = $Line2D

func _process(delta):
	# Loop through each point in the Line2D
	for i in range(line2d_node.get_point_count()):
		# Get the current position of the point
		var current_position = line2d_node.get_point_position(i)
		
		# Add a random offset to the position
		var offset_x = rng.randf_range(-1, 1)
		var offset_y = rng.randf_range(-1, 1)
		var new_position = current_position + Vector2(offset_x, offset_y)
		
		# Set the new position for the point
		line2d_node.set_point_position(i, new_position)
