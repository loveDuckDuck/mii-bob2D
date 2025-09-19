// A simple black hole effect
extern vec2 center_pos;
extern float radius;
extern float strength;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 pos_from_center = screen_coords - center_pos;
    float dist = length(pos_from_center);
    
    // Check if the pixel is within the "black hole" radius
    if (dist < radius) {
        // Calculate the distortion based on distance from the center
        float distortion = 1.0 - (dist / radius) * strength;
        
        // Distort the texture coordinates
        vec2 distorted_coords = texture_coords + (pos_from_center / (dist + 0.001)) * distortion * 0.1;

        // Sample the texture at the distorted coordinates
        vec4 pixel_color = Texel(texture, distorted_coords);
        return pixel_color * color;
    }
    
    // Outside the radius, just draw normally
    return Texel(texture, texture_coords) * color;
}
