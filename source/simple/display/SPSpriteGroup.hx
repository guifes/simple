package simple.display;

import openfl.display.DisplayObject;
import openfl.display.Sprite;

class SPSpriteGroup extends Sprite
{
    public static inline var ASCENDING: Int = -1;
    public static inline var DESCENDING: Int = 1;

	private var _childrenSortingArray: Array<DisplayObject>;

	public function new()
	{
		super();

        _childrenSortingArray = new Array<DisplayObject>();
	}

    ////////////
    // Sprite //
    ////////////

    public function sort(func: DisplayObject -> DisplayObject -> Int)
    {
        _childrenSortingArray.sort(func);

        for (i in 0..._childrenSortingArray.length)
            super.setChildIndex(_childrenSortingArray[i], i);
    }

    public function add(child: DisplayObject): DisplayObject
    {
        _childrenSortingArray.push(child);
        
        return super.addChild(child);
    }

    public function remove(child: DisplayObject): DisplayObject
    {
        _childrenSortingArray.remove(child);

        return super.removeChild(child);
    }
}