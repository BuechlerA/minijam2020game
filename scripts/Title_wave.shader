shader_type canvas_item;

void fragment(){
	vec2 _uv = UV;
	_uv.y += (sin(  _uv.x*12.0 + TIME*0.5 )) * 0.025;
	vec4 tex = texture(TEXTURE,_uv);
	COLOR = tex;
	
}