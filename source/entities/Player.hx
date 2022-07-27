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
    public static inline var RUN_SPEED = 70;
    public static inline var GRAVITY = 850;
    public static inline var MAX_FALL_SPEED = 200;
    public static inline var JUMP_POWER = 185;
    public static inline var JUMP_FLOAT_VELOCITY = 25;
    public static inline var JUMP_FLOAT_FACTOR = 0.4;

    private var sprite:Spritemap;
    private var velocity:Vector2;

    public function new(x:Float, y:Float) {
        super(x, y);
        mask = new Hitbox(9, 25);
        sprite = new Spritemap("graphics/player.png", 64, 32);
        sprite.add("idle", [1]);
        sprite.add("run", [0, 1, 2, 1], 6);
        sprite.add("jump", [5]);
        sprite.add("crouch", [8]);
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
                velocity.x = -RUN_SPEED;
            }
            else if(Input.check("right")) {
                velocity.x = RUN_SPEED;
            }
            else {
                velocity.x = 0;
            }

            velocity.y = MAX_FALL_SPEED / 4;
            if(Input.pressed("jump")) {
                velocity.y = -JUMP_POWER;
            }
        }
        else {
            var gravity:Float = GRAVITY;
            if(Math.abs(velocity.y) < JUMP_FLOAT_VELOCITY) {
                gravity *= JUMP_FLOAT_FACTOR;
            }
            velocity.y += gravity * HXP.elapsed;
            velocity.y = Math.min(velocity.y, MAX_FALL_SPEED);
        }

        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, ["walls"]);
    }

    override public function moveCollideX(e:Entity) {
        return true;
    }

    override public function moveCollideY(e:Entity) {
        return true;
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
