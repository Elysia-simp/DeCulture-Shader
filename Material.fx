//SP goes into SPHERE and Mask goes into TOON slots in pmxe

#define model_type 0 // 0: Uta Macross 1: MGF
//#define MGF_uv_offset //depending on how you port the uvs might be above the texture space and I clamp some things so this is to fix that

#define Eye 0 // 0: not eye at all 1: eye_right only 2: look_down needed (Uta only)

//#define Blush // blush morph needed (Uta only)

#define animation 0 // 0: not animated 1: Mikumo's hair 2: Skater animation (Uta only)

//#define additive //additive alpha for textures with no mask (Uta only)



#include <shader.fxh>