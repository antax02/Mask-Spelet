shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float vine_threshold = 0.45;
uniform vec2 stretch = vec2(0.2, 1.0);

uniform vec3 color_a = vec3(0.08, 0.45, 0.15);
uniform vec3 color_b = vec3(0.2, 0.75, 0.3);

void fragment() {
    vec2 uv = UV;
    uv *= stretch;

    float n = texture(noise_tex, uv).r;

    // HARD cutoff: 0 or 1 only
    float vine = step(vine_threshold, n);

    // Color variation using the same noise
    vec3 color = mix(color_a, color_b, n);

    COLOR = vec4(color, vine);
}
