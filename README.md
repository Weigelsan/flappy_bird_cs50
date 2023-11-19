# flappy_bird_cs50
Flappy Bird clone for my final CS50 project

Itch.io: https://frauweigel.itch.io/flappy-godot
Youtube: https://youtu.be/JnivrDe8kBo

I made this small Flappy Bird clone in the game engine "Godot"
It was a breeze to work with it, because it is very intitive and GDscript is as easy as python.

In the past i tried Godot already, so this time i wanted to challange myself a bit and for the first time used
the CPU particle system, a shader to move the groud and a save and load function.
It took me a while to figure everything out, but in the end it worked and i am proud of it.

A little bit about the technical side of the Project:

The pillars spawn randomly between some min/max height and the gap between is always the same height, so that the player could
always fit trough them. After the pillar is not visible anymore it gets deleted.
The player rotation is based on the velocity, if the player jumps, the bird(Godot Head) looks up, if he falls it looks more and more downwards.
The sky, ground and every pillar has an collision shape attached, so that when the player collides it will end the round and saves the 
score to the savefile and checks if it is a new highscore.
The shader basically gets a direction, time and speed value to calculate the x axis offset.

Exept the backgroud and the Godot head, i created the art by myself.
For the background art and the sounds i thank kenney(https://www.kenney.nl/) very much for his awesome work to make game assets affordable.
