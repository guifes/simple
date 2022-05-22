package simple.display.particles;

import guifes.math.MathUtil;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import simple.display.particles.renderer.ISPParticleRenderer;
import simple.display.particles.renderer.SPParticleRendererType;
import simple.display.particles.renderer.SPParticleTilemapRenderer;

class SPParticleEmitter extends Sprite
{
    public var settings: SPParticleEmitterSettings;

    static var particleCounter: Int = 0;

    var _renderer: ISPParticleRenderer;
    var _particlePool: SPPool<SPParticle>;
    var _time: Int;
	var _lastEmission: Int;
    var _atMaxParticles: Bool;

	public function new(count: Int, width: Int, height: Int, bitmap: BitmapData = null, type: SPParticleRenderType = SPParticleRenderType.TILEMAP)
    {
        super();
        
		this.settings = new SPParticleEmitterSettings(count);
        
		_particlePool = new SPPool<SPParticle>(() -> new SPParticle(), count);

		bitmap = bitmap == null ? new BitmapData(1, 1, false, SPColor.YELLOW) : bitmap;

		this._renderer = switch (type)
        {
			default: new SPParticleTilemapRenderer(width, height, bitmap, count);
		}
        
		var root = this._renderer.getRoot();
        
		addChild(root);
    }

    public function update(elapsed: Int, deltaTime: Int)
    {
        var wasAtMaxParticles = _atMaxParticles;
		var _atMaxParticles = _particlePool.getAliveCount() >= this.settings.max_particles;
        
		// Spawn particle
        
		if (!_atMaxParticles)
		{
            if (wasAtMaxParticles)
				_lastEmission = _time;
			
			var deltaSinceLastEmission: Int = elapsed - _lastEmission;
			var toEmit: Int = Std.int(deltaSinceLastEmission * this.settings.emission_rate);
            
            for(_ in 0...toEmit)
            {
				var particle = _particlePool.get();

                var spawnPoint = switch(this.settings.emission_shape)
                {
					default: new Point(
						this.settings.pos_x,
						this.settings.pos_y
					);
					
					case SPParticleEmitterShape.Rectangle: new Point(
						this.settings.pos_x + MathUtil.randomInRange(-this.settings.pos_x_var, this.settings.pos_x_var),
						this.settings.pos_y + MathUtil.randomInRange(-this.settings.pos_y_var, this.settings.pos_y_var)
					);
					
					case SPParticleEmitterShape.Ellipse: new Point(
						this.settings.pos_x + Math.sqrt(MathUtil.randomInRange(0, this.settings.pos_x_var)) * Math.cos(MathUtil.randomInRange(0, 2 * Math.PI)),
						this.settings.pos_y + Math.sqrt(MathUtil.randomInRange(0, this.settings.pos_y_var)) * Math.sin(MathUtil.randomInRange(0, 2 * Math.PI))
					);
                };

                // Apply variance
                var angle = this.settings.angle + MathUtil.randomInRange(-this.settings.angle_var, this.settings.angle_var);
				var speed = this.settings.speed + MathUtil.randomInRange(-this.settings.speed_var, this.settings.speed_var);
				var lifetime = this.settings.particle_lifetime + Std.int(MathUtil.randomInRange(-this.settings.particle_lifetime_var, this.settings.particle_lifetime_var));

				particle.id = particleCounter++;
                particle.lifetime = lifetime;
                particle.lifetime_count = 0;
				particle.pos_x = spawnPoint.x;
				particle.pos_y = spawnPoint.y;
				particle.speed_x = Math.cos(angle) * speed;
				particle.speed_y = Math.sin(angle) * speed;
				
				this._renderer.addParticle(particle.id, particle.pos_x, particle.pos_y);
            }

			_lastEmission = (toEmit > 0) ? elapsed : _lastEmission;
        }
    
        // Update particles
        
		for (particle in _particlePool.alive())
        {
			if (particle.lifetime_count > particle.lifetime)
            {
				_particlePool.putBack(particle);
				this._renderer.removeParticle(particle.id);
            }
            else
            {
				particle.lifetime_count += deltaTime;

                particle.pos_x += particle.speed_x;
                particle.pos_y += particle.speed_y;
				particle.speed_x += this.settings.gravity_x;
                particle.speed_y += this.settings.gravity_y;
            }
        }

		this._renderer.update(_particlePool.alive());

		_time = elapsed;
    }
}