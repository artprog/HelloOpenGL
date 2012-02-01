varying lowp vec4 ambientFragColor;
varying lowp vec4 diffuseFragColor;
varying lowp vec2 textCoord;

uniform sampler2D texture;
uniform bool textureAvailable;

void main()
{
	if ( textureAvailable )
	{
		gl_FragColor = ambientFragColor + diffuseFragColor * texture2D(texture, textCoord);
	}
	else
	{
		gl_FragColor = ambientFragColor + diffuseFragColor;
	}	
}