shader_type canvas_item;

global uniform float wind_strength = 0.03;
uniform float speed = 1.0;
instance uniform float mass = 1.0;
instance uniform float y_origin = 200;
uniform int restrict_dir : hint_range(-1,1) = 0;

void vertex() {
	float strength = wind_strength * mass;
	float x = sin(TIME*speed)*(VERTEX.y-y_origin)*strength+sin(TIME*speed)*strength*8.0;
    VERTEX.x += x*float(restrict_dir==0)+abs(x)*float(-restrict_dir);
}