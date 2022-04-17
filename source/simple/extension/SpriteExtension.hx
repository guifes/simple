package simple.extension;

import openfl.display.Sprite;
import simple.ISPDestroyable;

using simple.extension.SpriteExtension;

class SpriteExtension
{
	static public function destroyChildren(self: Sprite): Void
	{
        for (i in 0...self.numChildren)
		{
			var child = self.getChildAt(i);

			if(Std.isOfType(child, Sprite))
				cast(child, Sprite).destroyChildren();

			if (Std.isOfType(child, ISPDestroyable))
				cast(child, ISPDestroyable).destroy();
		}
	}
}