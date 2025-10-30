extern number actualHeight; // This will go from 0.0 to 1.0
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screenPos )
{

  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
    // If the pixel's Y position is "above" the current height...
    if(texture_coords.y < actualHeight) {
        // ...draw the pixel from the menu canvas.
        return pixel ;
    } else {
        // ...otherwise, draw a transparent pixel.
        return vec4(1.0, 1.0, 0.0, 1.0);
 
    }
}