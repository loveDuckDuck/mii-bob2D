uniform float time;
uniform Image simplex;
uniform Image mask;

float speed=.05;
float amp=.05;

vec4 effect(vec4 color,Image texture,vec2 texture_coords,vec2 screen_coords){
    vec2 noise_time_index=fract(texture_coords+vec2(speed*time,speed*time));
    vec4 noisecolor=Texel(simplex,noise_time_index);
    float xy=noisecolor.b*.7071;
    noisecolor.r=(noisecolor.r+xy)/2;
    noisecolor.g=(noisecolor.g+xy)/2;
    
    vec2 displacement=texture_coords + (((amp*2)*vec2(noisecolor))-amp);
    
    vec4 mask_value=Texel(mask,texture_coords);
    vec4 mask_value_source=Texel(mask,displacement);
    
    vec4 texturecolor;
    if(mask_value.r==1 && mask_value_source.r==1){
        
        texturecolor=Texel(texture,displacement);
    }
    else{
        texturecolor=Texel(texture,texture_coords);
    }
    return texturecolor* color;
}
