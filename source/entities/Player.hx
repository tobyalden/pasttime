package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Player extends Entity
{
    public static inline var SPEED = 100;
    public static inline var GRAVITY = 800;
    public static inline var MAX_FALL_SPEED = 200;
    public static inline var JUMP_POWER = 200;

    private var sprite:Spritemap;
    private var velocity:Vector2;

    public function new(x:Float, y:Float) {
        super(x, y);
        mask = new Hitbox(9, 25);
        sprite = new Spritemap("graphics/player.png", 64, 32);
        sprite.add("idle", [1]);
        sprite.add("run", [0, 1, 2, 1], 6);
        sprite.add("jump", [5]);
        sprite.play("idle");
        sprite.x = -19;
        sprite.y = -7;
        graphic = sprite;
        velocity = new Vector2();
    }

    override public function update() {
        movement();
        animation();
        super.update();
    }

    private function movement() {
        if(isOnGround()) {
            if(Input.check("left")) {
                velocity.x = -SPEED;
            }
            else if(Input.check("right")) {
                velocity.x = SPEED;
            }
            else {
                velocity.x = 0;
            }
        }

        velocity.y += GRAVITY * HXP.elapsed;
        velocity.y = Math.min(velocity.y, MAX_FALL_SPEED);

        if(isOnGround() && Input.pressed("jump")) {
            velocity.y = -JUMP_POWER;
        }
        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, ["walls"]);
    }

    private function animation() {
        if(velocity.x < 0) {
            sprite.flipX = true;
            sprite.x = -36;
        }
        else if (velocity.x > 0) {
            sprite.flipX = false;
            sprite.x = -19;
        }

        if(!isOnGround()) {
            sprite.play("jump");
        }
        else if(velocity.x != 0) {
            sprite.play("run");
        }
        else {
            sprite.play("idle");
        }
    }

    private function isOnGround() {
        return collide("walls", x, y + 1) != null;
    }
}
