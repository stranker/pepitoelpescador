shader_type canvas_item;

uniform float tint : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	pixel_color = pixel_color / tint;
	COLOR = pixel_color;
}
