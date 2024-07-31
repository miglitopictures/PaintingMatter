extends Node2D

var mouse_position
var polygon_2d: Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	polygon_2d = $Polygon2D
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left click detected!", event.position)
			# Add your code to handle the left click here
			add_point_to_polygon(event.position)
			

func add_point_to_polygon(point: Vector2):
	# Get the current points of the Polygon2D
	var points = polygon_2d.polygon
	
	# Add the new point
	points.append(point)
	
	# Update the Polygon2D with the new points array
	polygon_2d.polygon = points
