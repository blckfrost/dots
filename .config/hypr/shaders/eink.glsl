// HyprShade E-Ink Shader
// (C) 2026 — Adjust contrast and threshold as needed

uniform sampler2D tex;
in vec2 v_uv;
out vec4 fragColor;

// tweakable parameters
float contrast = 1.2;     // >1 for punchier, <1 for softer
float brightness = 0.0;   // adjust lightening
float threshold = 0.5;    // 0.0 = smooth gray, 1.0 = stark steps

void main() {
    vec4 color = texture(tex, v_uv);

    // convert to luminance
    float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // apply contrast
    lum = (lum - 0.5) * contrast + 0.5 + brightness;

    // optional threshold / posterize to simulate e-ink dot density
    lum = floor(lum * threshold * 255.0 + 0.5) / 255.0;

    fragColor = vec4(vec3(lum), color.a);
}
