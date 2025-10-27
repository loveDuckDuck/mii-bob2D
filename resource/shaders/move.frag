vec4 resultCol;
extern number stepSize;

number alpha;

vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
{
    // get color of pixels:
    alpha = texture2D( texture, texturePos + vec2(0,-stepSize)).a;
    alpha -= texture2D( texture, texturePos + vec2(0,stepSize) ).a;

    // calculate resulting color
    resultCol = vec4( 1.0f, 1.0f, 1.0f, 0.5f*alpha );
    // return color for current pixel
    return resultCol;
}