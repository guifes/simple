package simple.display.particles;

import guifes.math.MathUtil;
import json2object.JsonParser;
import openfl.geom.Point;
import simple.SPEasing;

class SPParticleEmitterSettings
{
    // Emission
	public var max_particles: Int;
    public var emission_rate: Float;
	public var particle_lifetime: Int;
	public var particle_lifetime_var: Int;
	public var emission_duration: Int;
	public var emission_shape: String;

    // Movement
	public var pos_x: Float;
	public var pos_y: Float;
	public var pos_x_var: Float;
	public var pos_y_var: Float;
	public var speed: Float;
	public var speed_var: Float;
    public var angle: Float;
    public var angle_var: Float;
	public var gravity_x: Float;
	public var gravity_y: Float;
	public var wiggle_x: Float;
	public var wiggle_y: Float;
	public var wiggle_x_freq: Float;
	public var wiggle_y_freq: Float;

	// Color
	public var from_color: Int;
	public var to_color: Int;
	public var color_easing: SPEasing;

    public function new(count: Int)
    {
		// Emission
		max_particles = count;
		emission_rate = 0.5;
		particle_lifetime = 1000;
		particle_lifetime_var = 500;
		emission_duration = -1;
		emission_shape = SPParticleEmitterShape.Rectangle;

		// Movement
		pos_x = 0;
		pos_y = 0;
		pos_x_var = 0;
        pos_y_var = 0;
		speed = 1;
		speed_var = 1;
		angle = 90;
		angle_var = 15;
		gravity_x = 0;
		gravity_y = 0;
		wiggle_x = 0;
		wiggle_x_freq = 0;
		wiggle_y = 0;
		wiggle_y_freq = 0;

		// Color
		from_color = SPColor.BLACK;
		to_color = SPColor.BLACK;
		color_easing = SPEasing.LINEAR;
    }

	public static function fromJson(json: String)
	{
		var parser = new JsonParser<SPParticleEmitterSettings>();
		return parser.fromJson(json);
	}
}