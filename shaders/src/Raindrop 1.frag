#version 440
//https://www.shadertoy.com/view/tltyRM

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 1) in vec2 fragCoord;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 iResolution;
    float iTime;
};

layout(binding = 1) uniform sampler2D iSource;

vec2 hash3(in vec2 p)
{
  vec2 q = vec2(dot(p, vec2(127.1,311.7)), dot(p, vec2(269.5,183.3)));
  return fract(sin(q) * 43758.5453);
}

float noise(in vec2 x)
{
  float intensity = 0.4;
  x *= intensity;

  vec2 p = floor(x);
  vec2 f = fract(x);

  float va = 0.0;
  for ( int j = -2; j <= 2 ; j ++ )
  for ( int i = -2; i <= 2 ; i ++ )
  {
    vec2 g = vec2(float(i), float(j));
    vec2 o = hash3(p + g);
    vec2 r = ((g - f) + o.xy) / intensity;
    float d = sqrt(dot(r, r));

    float a = max(cos(d - iTime * 2.0 + (o.x + o.y) * 5.0), 0.0);
    a = smoothstep(0.99, 0.999, a);

    float ripple = mix(a, 0.0, d);
    va += max(ripple, 0.0);
  }
  return va;
}


// 255, 55 200: 0.25 - 0.75
// 0, 255

void main() {
  fragColor = texture(iSource, qt_TexCoord0);
  vec2 uv = fragCoord.xy / iResolution.xy;
   // for concentric circles
   // uv.y/=2.;

	float f = noise(12.0 * uv);
	//if (f <= 0.0001);
	//  f = 1.0;
	// fragColor = vec4(f, f, f, qt_Opacity)
	// fragColor = fragColor * vec4(f, f, f, qt_Opacity);
	// fragColor = vec4(max(fragColor.x, 255)

  // Or as normal
  //vec3 normal = vec3(vec3(-dFdx(f), -dFdy(f), 0.5) + 0.5);
  vec3 normal = vec3(dFdy(f) + qt_Opacity, dFdy(f) + qt_Opacity, dFdy(f) + qt_Opacity);
  fragColor = fragColor * vec4(normal, qt_Opacity);

	// fragColor = fragColor * qt_Opacity;
}


// uniform vec3      iResolution;           // viewport resolution (in pixels)
// uniform float     iTime;                 // shader playback time (in seconds)
// uniform float     iTimeDelta;            // render time (in seconds)
// uniform float     iFrameRate;            // shader frame rate
// uniform int       iFrame;                // shader playback frame
// uniform float     iChannelTime[4];       // channel playback time (in seconds)
// uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
// uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
// uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
// uniform vec4      iDate;                 // (year, month, day, time in seconds)
// uniform float     iSampleRate;           // sound sample rate (i.e., 44100)
