shader_type canvas_item;

void fragment() {
    // uv in [0,1] over the screen
    vec2 uv = SCREEN_UV;
    float t = TIME;  // built-in, automatically updates

    // animated wave pattern
    float wave = sin((uv.x + t * 0.2) * 10.0) * 0.1
               + cos((uv.y + t * 0.3) * 15.0) * 0.1;
    float brightness = 0.1 + wave * 0.3;

    // dark base tint
    vec3 base_color = vec3(0.05, 0.06, 0.12);
    vec3 color = base_color + vec3(brightness * 0.5,
                                   brightness * 0.3,
                                   brightness);

    COLOR = vec4(color, 1.0);
}
