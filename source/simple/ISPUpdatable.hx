package simple;

import guifes.collection.IHashable;

interface ISPUpdatable
{
    function update(elapsed: Int, deltaTime: Int): Void;
}