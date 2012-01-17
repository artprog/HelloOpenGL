attribute vec4 position;
attribute vec4 sourceColor;

uniform mat4 projection;
uniform mat4 rotationX;
uniform mat4 rotationY;

varying vec4 color;

void main()
{
    gl_Position = projection * rotationX * rotationY * position;
	color = sourceColor;
}