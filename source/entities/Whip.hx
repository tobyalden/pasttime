package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Whip extends Entity
{
    public function new() {
        super();
        mask = new Hitbox(22, 4);
        graphic = new ColoredRect(width, height, 0xFF0000);
        graphic.alpha = 0.33;
    }
}

