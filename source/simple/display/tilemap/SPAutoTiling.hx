package simple.display.tilemap;

class SPAutoTiling
{
    static var offsetAutoTile:Array<Int> = [
		 0,   0, 0, 0,  2,   2, 0,   3, 0, 0, 0, 0,  0,   0, 0,   0,
		11,  11, 0, 0, 13,  13, 0,  14, 0, 0, 0, 0, 18,  18, 0,  19,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		51,  51, 0, 0, 53,  53, 0,  54, 0, 0, 0, 0,  0,   0, 0,   0,
		62,  62, 0, 0, 64,  64, 0,  65, 0, 0, 0, 0, 69,  69, 0,  70,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		86,  86, 0, 0, 88,  88, 0,  89, 0, 0, 0, 0, 93,  93, 0,  94,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		 0, 159, 0, 0,  0, 162, 0, 163, 0, 0, 0, 0,  0,   0, 0,   0,
		 0, 172, 0, 0,  0, 175, 0, 176, 0, 0, 0, 0,  0, 181, 0, 182,
		 0,   0, 0, 0,  0,   0, 0,   0, 0, 0, 0, 0,  0,   0, 0,   0,
		 0, 199, 0, 0,  0, 202, 0, 203, 0, 0, 0, 0,  0, 208, 0, 209
	];

    public static function getIdWithAutoTilingSettings(i: Int, startingIndex: Int, autoTile: SPAutoTilingPolicy, widthInTiles: Int, heightInTiles: Int, data: Array<Int>, ?mapping: Array<Int>)
    {
        var val = data[i];

        return switch(autoTile)
        {
            case OFF: val - startingIndex;
			case AUTO: SPAutoTiling.autoTileAuto(i, widthInTiles, heightInTiles, mapping, data);
			case ALT: SPAutoTiling.autoTileAlt(i, widthInTiles, heightInTiles, mapping, data);
			case FULL: SPAutoTiling.autoTileFull(i, widthInTiles, heightInTiles, mapping ,data);
        }
    }

    static function autoTileAuto(i: Int, widthInTiles: Int, heightInTiles: Int, mapping: Array<Int>, data: Array<Int>)
    {
        var val = data[i];

        if(val == 0)
            return -1;

        var totalTiles = widthInTiles * heightInTiles;
        var id = 0;

        // UP
        if ((i - widthInTiles < 0) || (data[i - widthInTiles] > 0))
            id += 1;
        // RIGHT
        if ((i % widthInTiles >= widthInTiles - 1) || (data[i + 1] > 0))
            id += 2;
        // DOWN
        if ((Std.int(i + widthInTiles) >= totalTiles) || (data[i + widthInTiles] > 0))
            id += 4;
        // LEFT
        if ((i % widthInTiles <= 0) || (data[i - 1] > 0))
            id += 8;

        id += 1;

        return id - 1;
    }

    static function autoTileAlt(i: Int, widthInTiles: Int, heightInTiles: Int, mapping: Array<Int>, data: Array<Int>)
    {
        var val = data[i];

        if(val == 0)
            return -1;

        var totalTiles = widthInTiles * heightInTiles;
        var id = 0;

        // UP
        if ((i - widthInTiles < 0) || (data[i - widthInTiles] > 0))
            id += 1;
        // RIGHT
        if ((i % widthInTiles >= widthInTiles - 1) || (data[i + 1] > 0))
           id += 2;
        // DOWN
        if (((i + widthInTiles) >= totalTiles) || (data[i + widthInTiles] > 0))
            id += 4;
        // LEFT
        if ((i % widthInTiles <= 0) || (data[i - 1] > 0))
            id += 8;

        // The alternate algo checks for interior corners
        if (id == 15)
        {
            // BOTTOM LEFT OPEN
            if ((i % widthInTiles > 0) && (Std.int(i + widthInTiles) < totalTiles) && (data[i + widthInTiles - 1] <= 0))
                id = 1;
            // TOP LEFT OPEN
            if ((i % widthInTiles > 0) && (i - widthInTiles >= 0) && (data[i - widthInTiles - 1] <= 0))
                id = 2;
            // TOP RIGHT OPEN
            if ((i % widthInTiles < widthInTiles - 1) && (i - widthInTiles >= 0) && (data[i - widthInTiles + 1] <= 0))
                id = 4;
            // BOTTOM RIGHT OPEN
            if (
                (i % widthInTiles < widthInTiles - 1) &&
                ((i + widthInTiles) < totalTiles) &&
                (data[i + widthInTiles + 1] <= 0)
            )
                id = 8;
        }

        id += 1;

        return id - 1;
    }

    static function autoTileFull(i: Int, widthInTiles: Int, heightInTiles: Int, mapping: Array<Int>, data: Array<Int>)
    {
        var val = data[i];

        if(val == 0)
            return -1;

        var totalTiles = widthInTiles * heightInTiles;
        var id = 0;

        var wallUp = i - widthInTiles < 0;
        var wallRight = i % widthInTiles >= widthInTiles - 1;
        var wallDown = (i + widthInTiles) >= totalTiles;
        var wallLeft = i % widthInTiles <= 0;

        var up = wallUp || data[i - widthInTiles] > 0;
        var upRight = wallUp || wallRight || data[i - widthInTiles + 1] > 0;
        var right = wallRight || data[i + 1] > 0;
        var rightDown = wallRight || wallDown || data[i + widthInTiles + 1] > 0;
        var down = wallDown || data[i + widthInTiles] > 0;
        var downLeft = wallDown || wallLeft || data[i + widthInTiles - 1] > 0;
        var left = wallLeft || data[i - 1] > 0;
        var leftUp = wallLeft || wallUp || data[i - widthInTiles - 1] > 0;

        if (up)
            id += 1;
        if (upRight && up && right)
            id += 2;
        if (right)
            id += 4;
        if (rightDown && right && down)
            id += 8;
        if (down)
            id += 16;
        if (downLeft && down && left)
            id += 32;
        if (left)
            id += 64;
        if (leftUp && left && up)
            id += 128;

        id -= offsetAutoTile[id] - 1;

		if (mapping != null && mapping.length == 48)
		    id = mapping[id - 1];
        else
            id = id - 1;

        return id;
    }
}