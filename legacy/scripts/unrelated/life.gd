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
@export var resolution: int = 4  # Size of each cell in the grid
var brush_radius = 1  # Radius of the brush for drawing and erasing

# Variables to control the simulation and brush preview position
var simulation_running: bool = false  # Indicates whether the simulation is running
var brush_preview_position: Vector2 = Vector2()  # Position of the brush preview

# Called when the node enters the scene tree for the first time
func _ready():
	# Calculate the number of columns and rows based on the resolution and the size of the control
	grid_cols = int(size.x / resolution)
	grid_rows = int(size.y / resolution)
	
	# Create the grid with the calculated dimensions
	grid = make_2d_array(grid_cols, grid_rows)
	next_grid = make_2d_array(grid_cols, grid_rows)
	ever_alive_grid = make_2d_array(grid_cols, grid_rows)
	
	# Initialize the grids with 0 values (dead cells)
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
				draw_circle_pattern(event.position)  # Draw pattern on left mouse click
			else:
				# Prevent drawing on mouse release, but ensure it doesn't reset the brush preview position
				pass
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				erase_circle_pattern(event.position)  # Erase pattern on right mouse click
			else:
				# Prevent erasing on mouse release, but ensure it doesn't reset the brush preview position
				pass
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			brush_radius += 1  # Increase brush radius on mouse wheel up
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			brush_radius = max(0, brush_radius - 1)  # Decrease brush radius on mouse wheel down
	elif event is InputEventMouseMotion:
		brush_preview_position = event.position  # Update brush preview position on mouse move
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			draw_circle_pattern(event.position)  # Draw pattern while holding left mouse button
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			erase_circle_pattern(event.position)  # Erase pattern while holding right mouse button
	elif Input.is_key_pressed(KEY_SPACE):
		simulation_running = !simulation_running  # Toggle simulation state on space key
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
				draw_rect(Rect2(cell_position, Vector2(resolution, resolution)), Color(1, 1, 1))  # Draw cell as white rectangle
			elif ever_alive_grid[col][row] == 1:
				var cell_position = Vector2(col * resolution, row * resolution)  # Calculate cell position
				draw_rect(Rect2(cell_position, Vector2(resolution, resolution)), Color(1, 0.5, 0))  # Draw cell as orange rectangle
	
	# Draw brush preview
	draw_circle_pattern_preview(brush_preview_position)

# Function to update the grid for the next simulation step
func update_grid():
	# Use a temporary array to store the next state
	for col in range(grid_cols):
		for row in range(grid_rows):
			var neighbors = count_neighbors(grid, col, row)  # Count the number of alive neighbors
			var state = grid[col][row]  # Get the current state of the cell
			
			# Apply the rules of Conway's Game of Life
			if state == 0 and neighbors == 3:
				next_grid[col][row] = 1  # Cell becomes alive if it has exactly 3 neighbors
				ever_alive_grid[col][row] = 1  # Mark cell as ever alive
			elif state == 1 and (neighbors < 2 or neighbors > 3):
				next_grid[col][row] = 0  # Cell dies if it has fewer than 2 or more than 3 neighbors
			else:
				next_grid[col][row] = state  # Cell stays the same if it has 2 or 3 neighbors
	
	# Swap the grids to avoid copying data
	var temp = grid
	grid = next_grid
	next_grid = temp

# Function to count the number of alive neighbors for a given cell
func count_neighbors(grid: Array, x: int, y: int) -> int:
	var sum = 0  # Initialize the sum of neighbors
	# Iterate over the 3x3 neighborhood of the cell
	for i in range(-1, 2):
		for j in range(-1, 2):
			# Wrap around the grid horizontally and vertically
			var wrap_col = (x + i + grid_cols) % grid_cols
			var wrap_row = (y + j + grid_rows) % grid_rows
			sum += grid[wrap_col][wrap_row]  # Sum the state of the neighbors
	sum -= grid[x][y]  # Subtract the state of the cell itself
	return sum  # Return the number of alive neighbors

# Function to draw a circle pattern on the grid
func draw_circle_pattern(mouse_pos: Vector2):
	var col = int(mouse_pos.x / resolution)  # Calculate the column index based on the mouse position
	var row = int(mouse_pos.y / resolution)  # Calculate the row index based on the mouse position
	
	# Iterate over the cells within the brush radius
	for i in range(-brush_radius, brush_radius + 1):
		for j in range(-brush_radius, brush_radius + 1):
			if i * i + j * j <= brush_radius * brush_radius:  # Check if the cell is within the brush radius
				# Wrap around the grid horizontally and vertically
				var wrap_col = (col + i + grid_cols) % grid_cols
				var wrap_row = (row + j + grid_rows) % grid_rows
				grid[wrap_col][wrap_row] = 1  # Set the cell to alive
				ever_alive_grid[wrap_col][wrap_row] = 1  # Mark cell as ever alive

# Function to erase a circle pattern on the grid
func erase_circle_pattern(mouse_pos: Vector2):
	var col = int(mouse_pos.x / resolution)  # Calculate the column index based on the mouse position
	var row = int(mouse_pos.y / resolution)  # Calculate the row index based on the mouse position
	
	# Iterate over the cells within the brush radius
	for i in range(-brush_radius, brush_radius + 1):
		for j in range(-brush_radius, brush_radius + 1):
			if i * i + j * j <= brush_radius * brush_radius:  # Check if the cell is within the brush radius
				# Wrap around the grid horizontally and vertically
				var wrap_col = (col + i + grid_cols) % grid_cols
				var wrap_row = (row + j + grid_rows) % grid_rows
				grid[wrap_col][wrap_row] = 0  # Set the cell to dead

# Function to draw the preview of the circle pattern
func draw_circle_pattern_preview(mouse_pos: Vector2):
	var col = int(mouse_pos.x / resolution)  # Calculate the column index based on the mouse position
	var row = int(mouse_pos.y / resolution)  # Calculate the row index based on the mouse position
	
	# Iterate over the cells within the brush radius
	for i in range(-brush_radius, brush_radius + 1):
		for j in range(-brush_radius, brush_radius + 1):
			if i * i + j * j <= brush_radius * brush_radius:  # Check if the cell is within the brush radius
				# Wrap around the grid horizontally and vertically
				var wrap_col = (col + i + grid_cols) % grid_cols
				var wrap_row = (row + j + grid_rows) % grid_rows
				# Calculate the position and size of the cell
				var cell_position = Vector2(wrap_col * resolution, wrap_row * resolution)
				var cell_size = Vector2(resolution, resolution)
				# Draw the cell as a green rectangle with transparency
				draw_rect(Rect2(cell_position, cell_size), Color(0, 1, 0, 0.5))

# Function to reset the grid
func reset_grid():
	# Iterate over each cell in the grid
	for col in range(grid_cols):
		for row in range(grid_rows):
			# Set all cells to 0 (dead)
			grid[col][row] = 0
			ever_alive_grid[col][row] = 0  # Reset the ever alive grid as well
