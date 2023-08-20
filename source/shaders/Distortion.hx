package shaders;

import flixel.system.FlxAssets.FlxShader;

class Distortion extends FlxShader
{
    @:glFragmentSource("
    #pragma header
    uniform float kV;
    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy - vec2(0.5);
        float uva = atan(uv.x, uv.y);
        float uvd = sqrt(dot(uv, uv));
        //k = negative for pincushion, positive for barrel
        float k = kV;
        uvd = uvd*(1.0 + k*uvd*uvd);
        gl_FragColor = flixel_texture2D(bitmap, vec2(0.5) + vec2(sin(uva), cos(uva))*uvd);
    }
    ")
    public function new()
    {
        super();
    }
}