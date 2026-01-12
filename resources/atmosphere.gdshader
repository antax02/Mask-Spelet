shader_type canvas_item;

uniform vec4 sea_color : source_color = vec4(0.25, 0.55, 0.95, 1.0);
uniform vec4 mid_color : source_color = vec4(0.05, 0.1, 0.3, 1.0);
uniform vec4 space_color : source_color = vec4(0.0, 0.0, 0.02, 1.0);

uniform float horizon_height = 0.35;
uniform float falloff = 1.5;

void fragment() {
    float h = 1.0 - UV.y; // bottom = sea level, top = space

    // Atmospheric density curve
    float density = exp(-h * falloff);

    // Blend sea → mid → space
    vec4 atmosphere = mix(mid_color, sea_color, smoothstep(0.0, horizon_height, h));
    vec4 color = mix(space_color, atmosphere, density);

    COLOR = color;
}
