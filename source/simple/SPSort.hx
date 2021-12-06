package simple;

import openfl.display.DisplayObject;

class SPSort
{
    public static function byY(a: DisplayObject, b: DisplayObject): Int
    {
        if (a.y == b.y)
            return 0;

        if (a.y > b.y)
            return 1;

        return -1;
    }
}