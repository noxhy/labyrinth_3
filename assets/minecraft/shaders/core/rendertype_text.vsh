#version 150
#define VSH
#define RENDERTYPE_TEXT

#moj_import <fog.glsl>

// These are inputs and outputs to the shader
// If you are merging with a shader, put any inputs and outputs that they have, but are not here already, in the list below
in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform float GameTime;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 baseColor;
out vec4 lightColor;

#moj_import <spheya_packs_impl.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    baseColor = Color;
    lightColor = texelFetch(Sampler2, UV2 / 16, 0);

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = baseColor * lightColor;
    texCoord0 = UV0;

    // SCREENFILL #f0f2f2
    if ((Color.x * 255.0) == 240.0){
        if ((Color.y * 255.0) == 242.0){
            if ((Color.z * 255.0) == 242.0){
                switch (gl_VertexID % 4) {
                    case 0: gl_Position = vec4(-1, 1, Position.z, 1); break;
                    case 3: gl_Position = vec4(1, 1, Position.z, 1); break;
                    case 1: gl_Position = vec4(-1, -1, Position.z, 1); break;
                    case 2: gl_Position = vec4(1, -1, Position.z, 1); break;
                 }
                vertexColor = Color;
                return;
            }
        }
    }
    // hide shadow of screenfill
    if ((Color.x * 255.0) == 60.0){
        if ((Color.y * 255.0) == 60.0){
            if ((Color.z * 255.0) == 60.0){
                gl_Position = vec4(-100,-100,Position.z, 1);
                return;
            }
        }
    }
    // SCREENFILL_FIRE #a8f2f2 and #a4f2f2
    if (((Color.x * 255.0) == 164.0) || ((Color.x * 255.0) == 168.0)){
        if ((Color.y * 255.0) == 242.0){
            if ((Color.z * 255.0) == 242.0){
                float index = int(mod(GameTime*1200,1.0)*16.0)*0.0625;
                float index2 = index-0.0625;
                float smooth_progress = sin(Color.a*1.5707);
                float x_pos_1 = 1-smooth_progress;
                if ((Color.x * 255.0) == 168.0){ //fire 1
                    x_pos_1 = -2+smooth_progress;
                }
                float x_pos_2 = x_pos_1+1;
                vertexColor.a = 1.0;
                switch (gl_VertexID % 4) {
                    case 0: gl_Position = vec4(x_pos_1, 1, Position.z, 1); texCoord0 = vec2(UV0.x,index);break;
                    case 3: gl_Position = vec4(x_pos_2, 1, Position.z, 1); texCoord0 = vec2(UV0.x,index); break;
                    case 1: gl_Position = vec4(x_pos_1, -1, Position.z, 1); texCoord0 = vec2(UV0.x,index2); break;
                    case 2: gl_Position = vec4(x_pos_2, -1, Position.z, 1); texCoord0 = vec2(UV0.x,index2); break;
                 }
                vertexColor = vec4(1.0,1.0,1.0,1.0);
                return;
            }
        }
    }
    // hide shadow of screenfill_fire_1
    if (((Color.x * 255.0) == 42.0) || ((Color.x * 255.0) == 41.0)){
        if ((Color.y * 255.0) == 60.0){
            if ((Color.z * 255.0) == 60.0){
                gl_Position = vec4(-100,-100,Position.z, 1);
                return;
            }
        }
    }
    if(applySpheyaPacks()) return;
}
