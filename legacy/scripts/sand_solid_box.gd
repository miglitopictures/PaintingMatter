extends Control

# Function to create a 2D array with the specified number of columns and rows
func make_2d_array(cols: int, rows: int) -> Array:
	var array_2d: Array = []  # Initialize an empty array
	array_2d.resize(cols)  # Resize the array to have the number of columns
	for col in range(cols):
		array_2d[col] = Array()  # Initialize each column as an empty array
		array_2d[col].resize(rows)  # Resize each column array to have the number of rows
	return array_2d  # Return the created 2D array

# Variables to store the grid and its dimensions
var grid: Array
var next_grid: Array
var ever_alive_grid: Array
var grid_cols: int
var grid_rows: int

# Exported variables for resolution and brush radius, which can be set in the Godot editor
@export var resolution: int = 10  # Size of each cell in the grid
var brush_radius = 1  # Radius of the brush for drawing and erasing

# Exported color variables for easy manipulation from the editor
@export var sand_color: Color = Color(1, 1, 1)  # Color for sand cells
@export var solid_color: Color = Color(0.4, 0.4, 0.4)  # Color for solid cells
@export var ever_alive_color: Color = Color(1, 0.5, 0)  # Color for ever alive cells
@export var brush_color: Color = Color(0, 0.2, 0.7, 0.5)  # Color for brush preview
@export var ctrl_brush_color: Color = Color(0.7, 0, 0.2, 0.5)  # Color for brush preview when holding Ctrl

# Variables to control the simulation and brush preview position
var simulation_running: bool = false  # Indicates whether the simulation is running
var brush_preview_position: Vector2 = Vector2()  # Position of the brush preview

# Variables for box selection
var box_selecting: bool = false
var box_start: Vector2 = Vector2()
var box_end: Vector2 = Vector2()

# Called when the node enters the scene tree for the first time
func _ready():
	# Calculate the number of columns and rows based on the resolution and the size of the control
	grid_cols = int(size.x / resolution)
	grid_rows = int(size.y / resolution)
	
	# Create the grid with the calculated dimensions
	grid = make_2d_array(grid_cols, grid_rows)
	next_grid = make_2d_array(grid_cols, grid_rows)
	ever_alive_grid = make_2d_array(grid_cols, grid_rows)
	
	# Initialize the grids with 0 values (empty cells)
	for col in range(grid_cols):
		for row in range(grid_rows):
			grid[col][row] = 0
			ever_alive_grid[col][row] = 0
	
	# Enable the _process function to be called every frame
	set_process(true)
	# Enable the _input function to handle input events
	set_process_input(true)

# Called every frame
func _process(_delta):
	if simulation_running:
		update_grid()  # Update the grid if the simulation is running
	queue_redraw()  # Request to redraw the scene

# Called to handle input events
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if Input.is_key_pressed(KEY_SHIFT):
					box_selecting = true
					box_start = event.position
					box_end = event.position
				else:
					if Input.is_key_pressed(KEY_CTRL):
						draw_circle_pattern(event.position, 2)  # Draw solid matter with Ctrl+LeftClick
					else:
						draw_circle_pattern(event.position, 1)  # Draw sand with LeftClick
			else:
				if box_selecting:
					box_selecting = false
					apply_box_selection(box_start, box_end, 1, Input.is_key_pressed(KEY_CTRL))
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if Input.is_key_pressed(KEY_SHIFT):
					box_selecting = true
					box_start = event.position
					box_end = event.position
				else:
					if Input.is_key_pressed(KEY_CTRL):
						transform_circle_pattern(event.position, 2, 1)  # Convert solid matter to sand with Ctrl+RightClick
					else:
						erase_circle_pattern(event.position)  # Erase pattern on RightClick
			else:
				if box_selecting:
					box_selecting = false
					apply_box_selection(box_start, box_end, 0, Input.is_key_pressed(KEY_CTRL))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			brush_radius += 1  # Increase brush radius on mouse wheel up
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			brush_radius = max(1, brush_radius - 1)  # Decrease brush radius on mouse wheel down
	elif event is InputEventMouseMotion:
		brush_preview_position = event.position  # Update brush preview position on mouse move
		if box_selecting:
			box_end = event.position
		else:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if Input.is_key_pressed(KEY_CTRL):
					draw_circle_pattern(event.position, 2)  # Draw solid matter with Ctrl+LeftClick
				else:
					draw_circle_pattern(event.position, 1)  # Draw sand with LeftClick
			elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				if Input.is_key_pressed(KEY_CTRL):
					transform_circle_pattern(event.position, 2, 1)  # Convert solid matter to sand with Ctrl+RightClick
				else:
					erase_circle_pattern(event.position)  # Erase pattern with RightClick
	elif Input.is_key_pressed(KEY_SPACE):
		simulation_running = !simulation_running  # Toggle simulation state on space key
	elif Input.is_key_pressed(KEY_F1):
		reset_history()  # Reset the grid on F1 key
	elif Input.is_key_pressed(KEY_ESCAPE):
		reset_grid()  # Reset the grid on ESC key
		simulation_running = false  # Stop the simulation

# Called to draw the scene
func _draw():
	# Draw the grid cells
	for col in range(grid_cols):
		for row in range(grid_rows):
			if grid[col][row] == 1:
				var cell_position = Vector2(col * resolution, row * resolution)  # Calculate cell position
				draw_rect(Rect2(cell_position, Vector2(resolution, resolution)), sand_color)  # Draw sand cell as white rectangle
			elif grid[col][row] == 2:
				var cell_position = Vector2(col * resolution, row * resolution)  # Calculate cell position
				draw_rect(Rect2(cell_position, Vector2(resolution, resolution)), solid_color)  # Draw solid cell as gray rectangle
			elif ever_alive_grid[col][row] == 1:
				var cell_position = Vector2(col * resolution, row * resolution)  # Calculate cell position
				draw_rect(Rect2(cell_position, Vector2(resolution, resolution)), ever_alive_color)  # Draw cell as orange rectangle
	
	# Draw brush preview
	draw_circle_pattern_preview(brush_preview_position)
	
	# Draw box selection preview
	if box_selecting:
		draw_box_selection_preview(box_start, box_end)

# Function to update the grid for the next simulation step
func update_grid():
	# Use a temporary array to store the next state
	for col in range(grid_cols):
		for row in range(grid_rows - 1, -1, -1):  # Iterate from bottom to top
			var current_state = grid[col][row]  # Get the current state of the cell
			
			if current_state == 1:  # If cell is sand
				if row < grid_rows - 1 and grid[col][row + 1] == 0:  # Move down if space below is empty
					next_grid[col][row] = 0
					next_grid[col][row + 1] = 1
				elif col > 0 and row < grid_rows - 1 and grid[col - 1][row + 1] == 0:  # Move down-left if space is empty
					next_grid[col][row] = 0
					next_grid[col - 1][row + 1] = 1
				elif col < grid_cols - 1 and row < grid_rows - 1 and grid[col + 1][row + 1] == 0:  # Move down-right if space is empty
					next_grid[col][row] = 0
					next_grid[col + 1][row + 1] = 1
				else:
					next_grid[col][row] = current_state  # Stay in place if no movement is possible
			else:
				next_grid[col][row] = current_state  # Stay in place if current state is not sand
	
	# Swap the grids to avoid copying data
	var temp = grid
	grid = next_grid
	next_grid = temp

# Function to draw a circle pattern on the grid
func draw_circle_pattern(mouse_pos: Vector2, state: int):
	var col = int(mouse_pos.x / resolution)  # Calculate the column index based on the mouse position
	var row = int(mouse_pos.y / resolution)  # Calculate the row index based on the mouse position
	
	# Iterate over the cells within the brush radius
	for i in range(-brush_radius, brush_radius + 1):
		for j in range(-brush_radius, brush_radius + 1):
			if i * i + j * j <= brush_radius * brush_radius:  # Check if the cell is within the brush radius
				# Ensure indices are within bounds
				if col + i >= 0 and col + i < grid_cols and row + j >= 0 and row + j < grid_rows:
					grid[col + i][row + j] = state  # Set the cell to the specified state
					if state == 1:
						ever_alive_grid[col + i][row + j] = 1  # Mark cell as ever alive if it is sand

# Function to transform a circle pattern on the grid from one state to another
func transform_circle_pattern(mouse_pos: Vector2, from_state: int, to_state: int):
	var col = int(mouse_pos.x / resolution)  # Calculate the column index based on the mouse position
	var row = int(mouse_pos.y / resolution)  # Calculate the row index based on the mouse position
	
	# Iterate over the cells within the brush radius
	for i in range(-brush_radius, brush_radius + 1):
		for j in range(-brush_radius, brush_radius + 1):
			if i * i + j * j <= brush_radius * brush_radius:  # Check if the cell is within the brush radius
				# Ensure indices are within bounds
				if col + i >= 0 and col + i < grid_cols and row + j >= 0 and row + j < grid_rows:
					if grid[col + i][row + j] == from_state:
						grid[col + i][row + j] = to_state  # Transform the cell from the specified from_state to to_state
						if to_state == 1:
							ever_alive_grid[col + i][row + j] = 1  # Mark cell as ever alive if it is sand

# Function to erase a circle pattern on the grid
func erase_circle_pattern(mouse_pos: Vector2):
	var col = int(mouse_pos.x / resolution)  # Calculate the column index based on the mouse position
	var row = int(mouse_pos.y / resolution)  # Calculate the row index based on the mouse position
	
	# Iterate over the cells within the brush radius
	for i in range(-brush_radius, brush_radius + 1):
		for j in range(-brush_radius, brush_radius + 1):
			if i * i + j * j <= brush_radius * brush_radius:  # Check if the cell is within the brush radius
				# Ensure indices are within bounds
				if col + i >= 0 and col + i < grid_cols and row + j >= 0 and row + j < grid_rows:
					grid[col + i][row + j] = 0  # Set the cell to empty

# Function to draw the preview of the circle pattern
func draw_circle_pattern_preview(mouse_pos: Vector2):
	var col = int(mouse_pos.x / resolution)  # Calculate the column index based on the mouse position
	var row = int(mouse_pos.y / resolution)  # Calculate the row index based on the mouse position
	
	# Iterate over the cells within the brush radius
	for i in range(-brush_radius, brush_radius + 1):
		for j in range(-brush_radius, brush_radius + 1):
			if i * i + j * j <= brush_radius * brush_radius:  # Check if the cell is within the brush radius
				# Ensure indices are within bounds
				if col + i >= 0 and col + i < grid_cols and row + j >= 0 and row + j < grid_rows:
					# Calculate the position and size of the cell
					var cell_position = Vector2((col + i) * resolution, (row + j) * resolution)
					var cell_size = Vector2(resolution, resolution)
					# Change brush preview color based on whether Ctrl is held down
					var preview_color = ctrl_brush_color if Input.is_key_pressed(KEY_CTRL) else brush_color
					# Draw the cell as a rectangle with transparency
					draw_rect(Rect2(cell_position, cell_size), preview_color)

# Function to draw the preview of the box selection
func draw_box_selection_preview(start: Vector2, end: Vector2):
	var start_col = int(start.x / resolution)
	var start_row = int(start.y / resolution)
	var end_col = int(end.x / resolution)
	var end_row = int(end.y / resolution)
	
	for col in range(min(start_col, end_col), max(start_col, end_col) + 1):
		for row in range(min(start_row, end_row), max(start_row, end_row) + 1):
			if col >= 0 and col < grid_cols and row >= 0 and row < grid_rows:
				var cell_position = Vector2(col * resolution, row * resolution)
				var cell_size = Vector2(resolution, resolution)
				draw_rect(Rect2(cell_position, cell_size), Color(0.8, 0.8, 0.8, 0.3))  # Light gray with transparency

# Function to apply box selection
func apply_box_selection(start: Vector2, end: Vector2, state: int, is_ctrl: bool):
	var start_col = int(start.x / resolution)
	var start_row = int(start.y / resolution)
	var end_col = int(end.x / resolution)
	var end_row = int(end.y / resolution)
	
	for col in range(min(start_col, end_col), max(start_col, end_col) + 1):
		for row in range(min(start_row, end_row), max(start_row, end_row) + 1):
			if col >= 0 and col < grid_cols and row >= 0 and row < grid_rows:
				if is_ctrl:
					if state == 0:
						if grid[col][row] == 2:  # Erase solid
							grid[col][row] = 0
					else:
						grid[col][row] = 2  # Create solid
				else:
					grid[col][row] = state  # Create sand or erase

# Function to reset the grid
func reset_grid():
	# Iterate over each cell in the grid
	for col in range(grid_cols):
		for row in range(grid_rows):
			# Set all cells to 0 (empty)
			grid[col][row] = 0
			ever_alive_grid[col][row] = 0  # Reset the ever alive grid as well

# Function to reset the history
func reset_history():
	# Iterate over each cell in the grid
	for col in range(grid_cols):
		for row in range(grid_rows):
			# Set all cells in the ever_alive_grid to 0 (empty)
			ever_alive_grid[col][row] = 0
