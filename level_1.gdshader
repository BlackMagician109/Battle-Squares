shader_type canvas_item;

//const vec4 hint_color = vec4(1,0,0,0);

uniform sampler2D emission_texture;
uniform vec4 glow_color : source_color = vec4(1,0,0,0);


void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	vec4 emission_color = texture(emission_texture, UV);
	
	if(emission_color.r > 0.0){
		COLOR = emission_color + glow_color;
	}
	else{
		COLOR = current_color;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
