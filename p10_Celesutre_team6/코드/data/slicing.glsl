#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform sampler2D texture2;

uniform vec2 pixels;

//float random(vec2 st) {
//    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
//}


void main(void)
{
  	vec2 p = vertTexCoord.st;
  //  vec3 randomColor = vec3(random(p.xy), random(p.xy + vec2(0.5)), random(p.xy + vec2(1.0)));
    
    
    

	p.x -= mod(p.x, 1.0 / pixels.x);
	
	vec3 col = texture2D(texture, p).rgb;
    vec3 textureColor = texture2D(texture2, p).rgb;
 
    vec3 col2=vec3(col.x,col.y,col.z);
    if((col.x<0.02)&& (col.y<0.02)&&(col.z<0.02)){col2=textureColor;}
	gl_FragColor = vec4(col2, 1.0);
}



