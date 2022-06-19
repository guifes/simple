package simple.display.particles.renderer;

import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import polygonal.ds.Hashable;
import polygonal.ds.Itr;

class SPTile extends Tile implements Hashable
{
    public var key(default, null): Int;

	private static var count: Int = 0;

    public function new()
    {
        super();

		key = count++;
    }
}

class SPParticleTilemapRenderer extends Sprite implements ISPParticleRenderer
{
    private var _tilemap: Tilemap;
	private var _tilePool: SPPool<SPTile>;
    private var _tileLookup: Map<Int, SPTile>;

    public function new(width: Int, height: Int, bitmap: BitmapData, count: Int)
    {
        super();
        
		var tileset = new Tileset(bitmap);
		tileset.addRect(bitmap.rect);
        
		_tilemap = new Tilemap(width, height, tileset, false);
        
        _tilePool = new SPPool<SPTile>(() -> new SPTile(), count);
		_tileLookup = new Map<Int, SPTile>();

        for(tile in _tilePool.dead())
            _tilemap.addTile(tile);

		addChild(_tilemap);
    }
    
	public function addParticle(particle: SPParticle)
	{
        var tile = _tilePool.get();
		tile.x = particle.pos_x;
		tile.y = particle.pos_y;
		tile.alpha = particle.color.alphaFloat;
        tile.visible = true;
		
        tile.colorTransform = new ColorTransform(
            1, 1, 1, 1,
            particle.color.red,
            particle.color.green,
            particle.color.blue
        );
        
        if(_tilePool.getAliveCount() > _tilemap.numTiles)
			_tilemap.addTile(tile);

		_tileLookup.set(particle.id, tile);
    }

	public function removeParticle(id: Int)
	{
        var tile = _tileLookup.get(id);
        tile.visible = false;

        _tilePool.putBack(tile);
        _tileLookup.remove(id);
    }

	public function update(particles: Itr<SPParticle>)
	{
        for(particle in particles)
        {
            var tile = _tileLookup.get(particle.id);
            tile.x = particle.pos_x + (this.width * 0.5);
			tile.y = particle.pos_y + (this.height * 0.5);
			tile.alpha = particle.color.alphaFloat;
            tile.colorTransform.redOffset = particle.color.red;
			tile.colorTransform.greenOffset = particle.color.green;
			tile.colorTransform.blueOffset = particle.color.blue;
        }
    }

    public function getRoot()
    {
        return this;
    }
}