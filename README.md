<<<<<<< HEAD
# PaintingMatter 0.0.1
*A simple painting program with some CA explorations made with Godot 4.2!*



# Introduction

 I`m happy to release PaintingMatter v0.0.1, a physics-based painting toy featuring Cellular Automata (CA) explorations, developed with Godot 4.2 as a study practice. This early version aims to provide a foundation for future development and invites the open-source community to contribute and expand its capabilities.


# Cellular Automata

A cellular automaton consists of a regular grid of cells, each in one of a finite number of states, such as on and off (in contrast to a coupled map lattice). The grid can be in any finite number of dimensions. For each cell, a set of cells called its neighborhood is defined relative to the specified cell. An initial state (time t = 0) is selected by assigning a state for each cell. A new generation is created (advancing t by 1), according to some fixed rule (generally, a mathematical function) that determines the new state of each cell in terms of the current state of the cell and the states of the cells in its neighborhood. [Check the wikipedia article!](https://en.wikipedia.org/wiki/Cellular_automaton) Or maybe [watch this!](https://www.youtube.com/watch?v=L4u7Zy_b868)


# Commands

I have to apologize, but there isn`t much in terms of graphical interface, yet! I shurely plan to implement it but, meanwhile, here is lisk of the keyboard commands:

## SIMULATE -> SPACEBAR
Painting Matter will boot with the simulation paused by default, to run it press the spacebar.

## NEXT FRAME -> RIGHT_ARROW
While testing, a need to more meticously control the simulation frames apeared. Ideally, you should be able to go back and forth, easely going back a few frames changing something to see the outcome. For now, use the right arrow to jump a frame in the simulation. 

## DRAW  -> LEFT_CLICK
Left click to draw.

## ERASE -> RIGHT_CLICK
Right click to erase.*
*If current draw mode is sand (RED), the eraser acts on any type of matter. If in solid draw mode (BLUE), the eraser acts as a dissolver, transforming solid matter into sand.

## RESIZE -> MOUSE WHEEL
Use the mouse wheel to change your brush size.

## CHANGE MODE -> TAB
Change draw mode, the current draw mode represents the type of matter you strokes will include in the simulation. By default, the draw mode is set to sand (RED), press tab to change it to solid (BLUE).

## BOX SELECT -> SHIFT+MOUSE DRAG
Hold shift, click and drag to create a rectange selection, this area will be affected in the same way the "normal" drawing and erasing would, depending on the current mode.

## SOLIDIFY -> "Y"
Transform all matter into solid! A very experimental and niche feature, but it does look good.

## CLEAR CANVAS -> DELETE
Erase everithing from the canvas.

## TOGGLE HISTORY -> "H"
I am calling it history although i dont know is a good descriotion yet. i am refering to the (orange by default) mark your brush leaves in the background as you draw and the pixels enter the simulation. I should be usefull for drawing specific static shapes that dont affect the simulation lije a background or something like that, but sometimes its a little distracting, so i added a shortcut to disable it.

## CLEAR HISTORY -> CTRL + "H"
Clear the history, but maintain it enabled.

## SHOW INSTRUCTIONS -> ESCAPE
Press escape to go to the menu, there you will find the current colors (change those by clickng it) and a list of the instructions! As well as a link for this very github repository.

## SAVE IMAGE (.PNG) -> CTRL + "S"
Saves a PNG file on your directory of choice!


# Issues

There is a list of [Known Issues](https://link-url-here.org) (things to be fixed or that aren't yet implemented).

If you found a bug or have a new idea/feature for the program, [you can report them](https://link-url-here.org).


# Credits
Developed by [Miglito](https://www.instagram.com/miglitopictures)
Boot screen artwork by [Ryan Yves](https://www.instagram.com/naoquenao/)


# License
This program is distributed under the [MIT License](https://link-url-here.org)
=======
# PaintingMatter
 A simple painting program with some CA explorations made with Godot 4.2!


Commands:
- SIMULATE -> SPACEBAR
- NEXT FRAME -> RIGHT_ARROW
- DRAW  -> LEFT_CLICK
- ERASE -> RIGHT_CLICK
- RESIZE -> MOUSE WHEEL
- CHANGE MODE -> TAB
- BOX SELECT -> SHIFT+MOUSE DRAG
- SOLIDIFY -> "Y"
- CLEAR CANVAS -> DELETE
- TOGGLE HISTORY -> "H"
- CLEAR HISTORY -> CTRL + "H"
- SHOW INSTRUCTIONS -> ESCAPE
- SAVE IMAGE (.PNG) -> CTRL + "S"
>>>>>>> 2ec753b2bdaef07eabc24071efaab85c11c31790
