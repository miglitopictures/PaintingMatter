# PaintingMatter 0.0.1
*A simple painting program with some CA explorations made with Godot 4.2!*



# Introduction

I’m happy to release **PaintingMatter v0.0.1**, a physics-based painting toy featuring Cellular Automata (CA) explorations, developed with Godot 4.2 as a study practice. This early version aims to provide a foundation for future development and invites the open-source community to contribute and expand its capabilities.


# Cellular Automata

A cellular automaton consists of a regular grid of cells, each in one of a finite number of states, such as on and off (in contrast to a coupled map lattice). The grid can be in any finite number of dimensions. For each cell, a set of cells called its neighborhood is defined relative to the specified cell. An initial state (time t = 0) is selected by assigning a state for each cell. A new generation is created (advancing t by 1), according to some fixed rule (generally, a mathematical function) that determines the new state of each cell in terms of the current state of the cell and the states of the cells in its neighborhood. [Check the Wikipedia article!](https://en.wikipedia.org/wiki/Cellular_automaton) Or maybe [watch this!](https://www.youtube.com/watch?v=L4u7Zy_b868)


# Commands

I have to apologize, but there isn’t much in terms of a graphical interface yet! I surely plan to implement it but, meanwhile, here is a list of the keyboard commands:

**SIMULATE -> SPACEBAR**
>PaintingMatter will boot with the simulation paused by default. To run it, press the spacebar.

**NEXT FRAME -> RIGHT_ARROW**
>While testing, a need to more meticulously control the simulation frames appeared. Ideally, you should be able to go back and forth, easily going back a few frames, changing something to see the outcome. For now, use the right arrow to jump a frame in the simulation. 

**DRAW  -> LEFT_CLICK**
>Left click to draw.

**ERASE -> RIGHT_CLICK**
>Right click to erase.*
*If the current draw mode is sand (RED), the eraser acts on any type of matter. If in solid draw mode (BLUE), the eraser acts as a dissolver, transforming solid matter into sand.

**RESIZE -> MOUSE WHEEL**
>Use the mouse wheel to change your brush size.

**CHANGE MODE -> TAB**
>Change draw mode. The current draw mode represents the type of matter your strokes will include in the simulation. By default, the draw mode is set to sand (RED); press tab to change it to solid (BLUE).

**BOX SELECT -> SHIFT+MOUSE DRAG**
>Hold shift, click, and drag to create a rectangle selection. This area will be affected in the same way the "normal" drawing and erasing would, depending on the current mode.

**SOLIDIFY -> "Y"**
>Transform all matter into solid! A very experimental and niche feature, but it does look good.

**CLEAR CANVAS -> DELETE**
>Erase everything from the canvas.

**TOGGLE HISTORY -> "H"**
>I am calling it history, although I don’t know if it's a good description yet. I am referring to the (orange by default) mark your brush leaves in the background as you draw and the pixels enter the simulation. It should be useful for drawing specific static shapes that don’t affect the simulation like a background or something like that, but sometimes it's a little distracting, so I added a shortcut to disable it.

**CLEAR HISTORY -> CTRL + "H"**
>Clear the history, but maintain it enabled.

**SHOW INSTRUCTIONS -> ESCAPE**
>Press escape to go to the menu. There you will find the current colors (change those by clicking it) and a list of the instructions! As well as a link to this very GitHub repository.

**SAVE IMAGE (.PNG) -> CTRL + "S"**
>Save a PNG file in your directory of choice!


# Issues

There is a list of [Known Issues](https://github.com/miglitopictures/PaintingMatter/issues) (things to be fixed or that aren't yet implemented).

If you found a bug or have a new idea/feature for the program, [you can report them](https://github.com/miglitopictures/PaintingMatter/issues/new).


# Credits

Developed by [Miglito](https://www.instagram.com/miglitopictures)

Boot screen artwork by [Ryan Yves](https://www.instagram.com/naoquenao/)


# License

This program is distributed under the **MIT License**