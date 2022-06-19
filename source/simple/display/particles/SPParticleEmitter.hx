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

class SPParticleEmitter extends Sprite implements ISPDestroyable
{
    public var settings: SPParticleEmitterSettings;
	
    static var particleCounter: Int = 0;
	
    var _renderer: ISPParticleRenderer;
    var _particlePool: SPPool<SPParticle>;
    var _time: Int;
	var _lastEmission: Int;
    var _atMaxParticles: Bool;
	var _active: Bool;
	var _manualUpdate: Bool = false;

	public function new(count: Int, width: Int, height: Int, bitmap: BitmapData = null, type: SPParticleRenderType = SPParticleRenderType.TILEMAP, manualUpdate: Bool = false)
    {
        super();
        
		this.settings = new SPParticleEmitterSettings(count);
        
		_particlePool = new SPPool<SPParticle>(() -> new SPParticle(), count);
		_manualUpdate = manualUpdate;

		bitmap = bitmap == null ? new BitmapData(1, 1, false, SPColor.TRANSPARENT) : bitmap;

		this._renderer = switch (type)
        {
			default: new SPParticleTilemapRenderer(width, height, bitmap, count);
		}

		// this.graphics.beginFill(SPColor.CYAN, 0.25);
		// this.graphics.drawRect(0, 0, width, height);
		// this.graphics.endFill();

		var root = this._renderer.getRoot();
        
		addChild(root);

		if (!_manualUpdate)
			SPEngine.addEventListener(SPEvent.UPDATE, updateEvent);
    }

	public function start()
	{
		_time = 0;
		_active = true;
	}

	public function stop()
	{
		_active = false;
	}

	function updateEvent(e: SPEvent)
	{
		update(e.elapsed, e.deltaTime);
	}
	
    public function update(elapsed: Int, deltaTime: Int)
    {
        var wasAtMaxParticles = _atMaxParticles;
		var aliveParticles = _particlePool.getAliveCount();
		var availableToSpawn = this.settings.max_particles - aliveParticles;

		_atMaxParticles = aliveParticles >= this.settings.max_particles;
        
		var isComplete = this.settings.emission_duration >= 0 ? _time >= this.settings.emission_duration : false;
		var shouldSpawn = _active && !isComplete && !_atMaxParticles;

		// Spawn particle
		if (shouldSpawn)
		{
            if (wasAtMaxParticles)
				_lastEmission = _time;
			
			var deltaSinceLastEmission: Int = elapsed - _lastEmission;
			var toEmit: Int = MathUtil.imin(Std.int(deltaSinceLastEmission * this.settings.emission_rate), availableToSpawn);
            
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
				particle.color = this.settings.from_color;
				
				this._renderer.addParticle(particle);
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
				particle.color = SPColor.interpolate(
					this.settings.from_color,
					this.settings.to_color,
					particle.lifetime_count / particle.lifetime
				);
            }
        }

		this._renderer.update(_particlePool.alive());

		_time = elapsed;
    }

	////////////////////
	// ISPDestroyable //
	////////////////////

	public function destroy()
	{
		if(!_manualUpdate)
			SPEngine.removeEventListener(SPEvent.UPDATE, updateEvent);
	}
}