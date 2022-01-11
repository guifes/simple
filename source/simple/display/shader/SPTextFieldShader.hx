package simple.display.shader;

import simple.SPColor;
import simple.display.shader.SPShader;

class SPTextFieldShader extends SPShader
{
    @:glFragmentSource('
        #pragma header
                
        // Outline
        uniform vec4 _outline_color;
        
        vec4 outline(sampler2D tex, vec2 textureCoord, vec2 textureSize, vec4 fragColor, vec4 textColor)
        {
            float a_buffer = 0.0;

            for(float i = 0.0; i <= 2.0; i++)
            {
                float j = i - 1.0;
                float offset = j / textureSize.x;
                vec2 texCoord = vec2(textureCoord.x + offset, textureCoord.y);

                float alpha = texture2D(tex, texCoord).a;
                alpha *= step(0.0, texCoord.x);
                alpha *= step(0.0, 1.0 - texCoord.x);

                a_buffer += alpha;
            }

            for(float i = 0.0; i <= 2.0; i++)
            {
                float j = i - 1.0;
                float offset = j / textureSize.y;
                vec2 texCoord = vec2(textureCoord.x, textureCoord.y + offset);

                float alpha = texture2D(tex, texCoord).a;
                alpha *= step(0.0, texCoord.y);
                alpha *= step(0.0, 1.0 - texCoord.y);

                a_buffer += alpha;
            }

            a_buffer = sign(a_buffer);

            float gate = sign(textColor.a);

            vec4 output_color = fragColor * gate;

            output_color += (_outline_color * _outline_color.a) * (1.0 - gate) * a_buffer;
            
            return output_color;
        }
        
        void main(void)
        {
            #pragma body
            
            gl_FragColor = outline(openfl_Texture, openfl_TextureCoordv, openfl_TextureSize, gl_FragColor, color);
        }
    ')

    // Outline
    public var outlineColor(default, set): SPColor;
    
	public function new()
	{
        super();
        
        // Outline
        this._outline_color.value = SPColor.TRANSPARENT.toFloatArray();
    }

    public function set_outlineColor(value: SPColor): SPColor
    {
        this._outline_color.value = value.toFloatArray();
        return outlineColor = value;
    }
}