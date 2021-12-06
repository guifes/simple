package simple.input;

class SPWheel
{
    public var delta(default, null): Int;
    
    var _rotated: Bool;

    public function new()
    {

    }

    public function update(elapsed: Float)
    {
        if(!_rotated)
            delta = 0;

        _rotated = false;
    }

    public function rotate(value: Int)
    {
        _rotated = true;
        delta = value;
    }
}