package simple.display.particles;

import polygonal.ds.Hashable;

class SPParticle implements Hashable
{
	public var key(default, null): Int;

	private static var count: Int = 0;
	
	public var id: Int;

	// Lifetime
	public var lifetime: Int;
	public var lifetime_count: Int;

	// Movement
	public var pos_x: Float;
	public var pos_y: Float;
	public var speed_x: Float;
	public var speed_y: Float;
	
    public function new()
	{
		key = count++;
		lifetime_count = 0;
	}
}