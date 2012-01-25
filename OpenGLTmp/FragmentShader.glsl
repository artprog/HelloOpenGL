varying lowp vec4 color;
varying lowp vec2 textCoord;
uniform sampler2D texture;

void main()
{
    gl_FragColor = color * texture2D(texture, textCoord);
}