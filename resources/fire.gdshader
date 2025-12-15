shader_type canvas_item;

uniform float stretch_x : hint_range(0.1, 5.0) = 1.0;

uniform float time_scale : hint_range(0.01, 3.0) = 1.0;
uniform float flame_intensity : hint_range(0.5, 2.0) = 1.2;
uniform float turbulence : hint_range(0.1, 2.0) = 0.8;
uniform float color_bands : hint_range(3.0, 20.0) = 8.0;
uniform float sway_amount : hint_range(0.0, 0.5) = 0.15;
uniform float sway_speed : hint_range(0.1, 3.0) = 1.0;
uniform vec3 fire_color_hot : source_color = vec3(1.0, 0.9, 0.3);
uniform vec3 fire_color_mid : source_color = vec3(1.0, 0.3, 0.05);
uniform vec3 fire_color_dark : source_color = vec3(0.4, 0.05, 0.02);

// Hash function for noise
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Smooth noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal Brownian Motion for detailed fire
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    for(int i = 0; i < 6; i++) {
        value += amplitude * noise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}

// Create flowing fire pattern
float fire_pattern(vec2 uv, float time) {
    // Flip Y so fire rises from bottom
    vec2 flow_uv = uv;
    flow_uv.y = 1.0 - flow_uv.y;

    // Add horizontal swaying that increases with height
    // Different flame columns sway at different rates based on X position
    float height_factor = (1.0 - uv.y); // 0 at top, 1 at bottom
    float sway1 = sin(time * sway_speed * 0.8 + uv.x * 2.0) * height_factor;
    float sway2 = sin(time * sway_speed * 1.3 + uv.x * 3.5) * height_factor * 0.5;
    float sway3 = sin(time * sway_speed * 0.5 + uv.x * 1.2) * height_factor * 0.7;

    flow_uv.x += (sway1 + sway2 + sway3) * sway_amount * 0.3;

    flow_uv.y -= time * 0.3; // Time scale affects speed elsewhere

    // Add turbulent distortion - much higher frequency for detail
    float distort_x = fbm(flow_uv * 8.0 + time * 0.2) * turbulence * 0.15;
    float distort_y = fbm(flow_uv * 6.0 + time * 0.15) * turbulence * 0.15;

    vec2 distorted_uv = flow_uv + vec2(distort_x, distort_y);

    // Multiple layers of fire at much higher frequencies
    float fire1 = fbm(distorted_uv * 15.0);
    float fire2 = fbm(distorted_uv * 22.0 + vec2(10.0, 10.0));
    float fire3 = fbm(distorted_uv * 30.0 - vec2(5.0, 5.0));

    // Combine layers with vertical gradient for flame shape
    float vertical_gradient = uv.y; // Now bottom = hot, top = cool
    float combined = (fire1 * 0.5 + fire2 * 0.3 + fire3 * 0.2) * vertical_gradient;

    return combined * flame_intensity;
}

void fragment() {
    vec2 uv = UV;

    // apply stretch
    uv.x *= stretch_x;

    float time = TIME * time_scale;

    float fire = fire_pattern(uv, time);

    // second layer also stretched
    vec2 uv2 = uv * 1.2 + vec2(0.05, 0.05);
    float fire_secondary = fire_pattern(uv2, time * 1.3) * 0.3;
    fire += fire_secondary;

    float flicker = noise(vec2(uv.x * 20.0, time * 4.0)) * 0.2;
    fire += flicker * uv.y;

    fire = floor(fire * color_bands) / color_bands;

    vec3 color;
    if (fire > 0.7) {
        float t = (fire - 0.7) / 0.3;
        color = mix(fire_color_mid, fire_color_hot, t);
    } else if (fire > 0.3) {
        float t = (fire - 0.3) / 0.4;
        color = mix(fire_color_dark, fire_color_mid, t);
    } else {
        float t = fire / 0.3;
        color = mix(vec3(0.1, 0.0, 0.0), fire_color_dark, t);
    }

    float brightness = 1.0 + noise(uv * 15.0 + time * 0.5) * 0.2;
    color *= brightness;

    color = max(color, vec3(0.05, 0.0, 0.0));

    COLOR = vec4(color, 1.0);
}