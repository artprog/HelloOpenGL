attribute vec4 position;
attribute vec2 sourceTextCoord;

uniform mat4 projection;
uniform vec4 ambientColor;
uniform vec4 diffuseColor;

varying vec4 ambientFragColor;
varying vec4 diffuseFragColor;
varying vec2 textCoord;

void main()
{
    gl_Position = projection * position;
	ambientFragColor = ambientColor;
	diffuseFragColor = diffuseColor;
	textCoord = sourceTextCoord;
}