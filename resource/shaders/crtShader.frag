// Add these declarations at the very beginning of your shader code
extern vec2 iResolution; // Screen resolution or the size of the image/canvas being drawn
extern number iTime;     // Time elapsed (a float/number in LÖVE2D shaders)


vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.92 + 0.04;
	return uv;
}
vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screenCoords){
    vec2 finalUV = curve( uv );
    vec3 oricol = Texel( texture, vec2(finalUV.x, finalUV.y) ).xyz;
    vec3 col;
	float x =  sin(0.3*iTime+finalUV.y*21.0)*sin(0.7*iTime+finalUV.y*29.0)*sin(0.3+0.33*iTime+finalUV.y*31.0)*0.0017;

    col.r = Texel( texture, vec2(x+finalUV.x+0.001,finalUV.y+0.001) ).x+0.05;
    col.g = Texel( texture, vec2(x+finalUV.x+0.000,finalUV.y-0.002) ).y+0.05;
    col.b = Texel( texture, vec2(x+finalUV.x-0.002,finalUV.y+0.000) ).z+0.05;
    col.r += 0.08*Texel( texture, 0.75*vec2(x+0.025, -0.027)+vec2(finalUV.x+0.001,finalUV.y+0.001) ).x;
    col.g += 0.05*Texel( texture, 0.75*vec2(x+-0.022, -0.02)+vec2(finalUV.x+0.000,finalUV.y-0.002) ).y;
    col.b += 0.08*Texel( texture, 0.75*vec2(x+-0.02, -0.018)+vec2(finalUV.x-0.002,finalUV.y+0.000) ).z;

    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

    float vig = (0.0 + 1.0*16.0*finalUV.x*finalUV.y*(1.0-finalUV.x)*(1.0-finalUV.y));
	col *= vec3(pow(vig,0.3));

    col *= vec3(0.95,1.05,0.95);
	col *= 2.8;

	float scans = clamp( 0.35+0.35*sin(3.5*iTime+uv.y*iResolution.y*1.5), 0.0, 1.0);
	
	float s = pow(scans,1.7);
	col = col*vec3( 0.4+0.7*s) ;

    col *= 1.0+0.01*sin(110.0*iTime);
	if (finalUV.x < 0.0 || finalUV.x > 1.0)
		col *= 0.0;
	if (finalUV.y < 0.0 || finalUV.y > 1.0)
		col *= 0.0;
	
	col*=1.0-0.65*vec3(clamp((mod(screenCoords.x, 2.0)-1.0)*2.0,0.0,1.0));
	
    float comp = smoothstep( 0.1, 0.9, sin(iTime) );
 
	// Remove the next line to stop cross-fade between original and postprocess
	//	col = mix( col, oricol, comp );

    return  vec4(col,1.0);
}