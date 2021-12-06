package simple.display.shader;

class SPShaderHub
{
    public var shaders(default, null): Array<SPShader>;

    public function new()
    {
        shaders = [];
    }

    public function update(elapsed: Float) 
    {
        for(shader in shaders)
            shader.update(elapsed);
    }

    public function registerShader(shader: SPShader)
    {
        shaders.push(shader);
    }
}