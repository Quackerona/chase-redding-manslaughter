package shaders;

import flixel.system.FlxAssets.FlxShader;

class CRT extends FlxShader
{
    @:glFragmentSource("
        #pragma header
        
        uniform float iTime;
        uniform vec3 iResolution;
        // Created by Frank Force
        // License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

        const float staticNoise = .7;
        uniform float chromatic;
        const float vignette = 2.;
        const float pi = 3.14159265359;

        // https://www.shadertoy.com/view/lsf3WH Noise by iq
        float hash(vec2 p)
        {
            p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
            return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
        }

        float noise( in vec2 p )
        {
            vec2 i = floor( p );
            vec2 f = fract( p );
            vec2 u = f*f*(3.0-2.0*f);
            return mix( mix( hash( i + vec2(0.0,0.0) ), 
                            hash( i + vec2(1.0,0.0) ), u.x),
                        mix( hash( i + vec2(0.0,1.0) ), 
                            hash( i + vec2(1.0,1.0) ), u.x), u.y);
        }

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            
            // noise
            vec4 c = vec4(0);
            c += staticNoise * ((sin(iTime)+2.)*.3)*sin(.8-uv.y+sin(iTime*3.)*.1) *
                noise(vec2(uv.y*999. + iTime*999., (uv.x+999.)/(uv.y+.1)*19.));
            
            // chromatic aberration
            c += vec4
            (
                flixel_texture2D(bitmap, uv + vec2(-chromatic, 0)).r,
                flixel_texture2D(bitmap, uv + vec2( 0        , 0)).g,
                flixel_texture2D(bitmap, uv + vec2( chromatic, 0)).b,
                1.
            );

            //vignette
            float OuterVig = 1.0; // Position for the Outer vignette
	        float InnerVig = 0.05; // Position for the inner Vignette Ring
            vec2 center = vec2(0.5,.5); // Center of Screen
            float dist  = distance(center,uv )*1.414213; // Distance  between center and the current Uv. Multiplyed by 1.414213 to fit in the range of 0.0 to 1.0 
            float vig = clamp((OuterVig-dist) / (OuterVig-InnerVig),0.3,1.0); // Generate the Vignette with Clamp which go from outer Viggnet ring to inner vignette ring with smooth steps
            c *= vig; // Multiply the Vignette with the texture color

            // scanline
            float scanlineIntesnsity = 0.185;
            float scanlineCount = 800.0;
            float scanlineYDelta = sin(iTime / 200.0);
            float scanline = sin((uv.y - scanlineYDelta) * scanlineCount) * scanlineIntesnsity;
            c -= scanline;
            
            gl_FragColor = c * 1.5;
        }
    ")
    public function new()
    {
        super();
    }
}