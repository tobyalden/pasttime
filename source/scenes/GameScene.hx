package scenes;

import entities.*;
import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import openfl.Assets;

class GameScene extends Scene
{
    private var level:Level;
    private var background:Backdrop;

    override public function begin() {
        level = add(new Level("level"));
        for(entity in level.entities) {
            add(entity);
        }
        background = new Backdrop("graphics/background.png");
        addGraphic(background, 10);
    }

    override public function update() {
        super.update();
    }
}
