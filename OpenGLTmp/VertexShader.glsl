attribute vec4 position;
attribute vec4 sourceColor;
attribute vec2 sourceTextCoord;

uniform mat4 projection;

varying vec4 color;
varying vec2 textCoord;

void main()
{
    gl_Position = projection * position;
	color = sourceColor;
	textCoord = sourceTextCoord;
}