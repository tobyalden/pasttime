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
    public static inline var ATTACK_STARTUP = 0.175;
    public static inline var ATTACK_DURATION = 0.275;

    public var whip(default, null):Whip;
    private var sprite:Spritemap;
    private var velocity:Vector2;
    private var willAttack:Bool;
    private var attackStartup:Alarm;
    private var attackTimer:Alarm;

    public function new(x:Float, y:Float) {
        super(x, y);
        mask = new Hitbox(9, 25);
        sprite = new Spritemap("graphics/player.png", 64, 32);
        sprite.add("idle", [1]);
        sprite.add("run", [0, 1, 2, 1], 6);
        sprite.add("attack_startup", [3]);
        sprite.add("attack", [4]);
        sprite.add("jump", [5]);
        sprite.add("hit", [6]);
        sprite.add("die", [7]);
        sprite.add("crouch", [8]);
        sprite.add("crouch_attack_startup", [9]);
        sprite.add("crouch_attack", [10]);
        sprite.play("idle");
        sprite.x = -19;
        sprite.y = -7;
        graphic = sprite;
        velocity = new Vector2();

        whip = new Whip();
        willAttack = false;
        attackStartup = new Alarm(ATTACK_STARTUP, function() {
            willAttack = true;
        });
        addTween(attackStartup);
        attackTimer = new Alarm(ATTACK_DURATION);
        addTween(attackTimer);
    }

    override public function update() {
        super.update();
        combat();
        movement();
        animation();
    }

    private function combat() {
        if(Input.pressed("attack")) {
            if(!attackStartup.active && !attackTimer.active) {
                attackStartup.start();
            }
        }
        if(willAttack) {
            attackTimer.start();
            willAttack = false;
        }
    }

    private function movement() {
        if(isOnGround()) {
            if(attackStartup.active || attackTimer.active) {
                velocity.x = 0;
            }
            else if(Input.check("left")) {
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
        whip.x = sprite.flipX ? x - whip.width : x + width;
        whip.y = y + 6;
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

        if(attackTimer.active) {
            sprite.play("attack");
        }
        else if(attackStartup.active) {
            sprite.play("attack_startup");
        }
        else if(!isOnGround()) {
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
