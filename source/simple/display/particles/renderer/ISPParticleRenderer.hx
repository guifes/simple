package simple.display.particles.renderer;

import openfl.display.DisplayObject;
import polygonal.ds.Itr;

interface ISPParticleRenderer
{
    function addParticle(particle: SPParticle): Void;
    function removeParticle(id: Int): Void;
    function update(particles: Itr<SPParticle>): Void;
    function getRoot(): DisplayObject;
}