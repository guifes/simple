package simple.input;

class SPButton
{
    public var just_pressed(default, null): Bool;
    public var pressed(default, null): Bool;
    public var released(default, null): Bool;
    public var just_released(default, null): Bool;

    var _last: Bool;
    var _current: Bool;

    public function new()
    {

    }

    public function update(elapsed: Float)
    {
        just_pressed = (_current && !_last) || false;
        just_released = (!_current && _last) || false;
        pressed = _current;
        released = !_current;

        _last = _current;
    }

    public function press()
    {
        _current = true;
    }

    public function release()
    {
        _current = false;
    }

    public function reset()
    {
        _current = false;
        _last = false;
        pressed = false;
        released = true;
        just_pressed = false;
        just_released = false;
    }
}