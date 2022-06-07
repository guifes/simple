package simple;

import openfl.events.Event;

class SPEvent extends Event
{
    public static inline var UPDATE = "sp_update";

	public var elapsed(default, null): Int;
	public var deltaTime(default, null): Int;

    public function new(type: String, elapsed: Int, deltaTime: Int)
    {
        super(type);

        this.elapsed = elapsed;
        this.deltaTime = deltaTime;
    }
}