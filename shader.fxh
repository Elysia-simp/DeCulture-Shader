//includes
#include <sub/header.fxh>
//

//base structure
struct vs_in
{
    float4 pos          : POSITION;
    float3 normal       : NORMAL;
    float2 uv            : TEXCOORD0;
    float4 vertexcolor   : TEXCOORD2; 
};

//vertex shader 
struct vs_out
{
    float4 pos          : POSITION;
    float2 uv           : TEXCOORD0;
    float4 vertex       : TEXCOORD1;
    float3 normal       : TEXCOORD2;
    float3 view         : TEXCOORD3;
};

vs_out vs_model ( vs_in i )
{
    vs_out o = (vs_out)0; //if you write this as in/out or input/output...
    //just know you're no longer safe
    o.pos = mul(i.pos, mmd_wvp);
    o.uv = i.uv;
	o.normal = normalize(mul((float3x3) mmd_world, i.normal));
    o.view = mmd_cameraPosition - mul(i.pos.xyz, (float3x3)mmd_world);
    o.vertex = i.vertexcolor;
    return o;
}

float4 ps_model(vs_out i, float vface : VFACE) : COLOR0
{
    //cause i know my ass isnt writing i.func all day
    float2 uv = i.uv;
    #ifdef MGF_uv_offset
    uv.y -= -1;
    #endif
    float3 normal = normalize(i.normal);
    float3 view = normalize(i.view);
    //
    float4 color = 1;
    if (animation == 1)
    {
        uv.y += time_elapsed * 0.05;
    }
    else if(animation == 2)
    {
        uv.y -= time_elapsed * 0.05; 
    }
    if(Eye == 1)
    {
        uv.x += Eye_slider;
    }
    else if(Eye == 2)
    {
        uv.x += Eye_slider;
        uv.y += Eye_slider2;
    } // i could clamp these but the game also uses very small values for these so no complaining
    float4 diffuse = tex2D(diffuseSampler, uv);
    float4 RimMask = tex2D(spSampler, uv).r;
    float4 AlphaMask = tex2D(maskSampler, uv);
    //animation related stuff
    color.a = AlphaMask;
    if (animation == 1)
    {
        color.a = i.vertex;
    }
    // so it doesnt take in alpha by mistake
    if(model_type == 0){
    color.rgb = diffuse.rgb;
    }
    else if(model_type == 1)
    {
    color = diffuse;
    }
    //rimlight
    float ndotv = saturate(1 - (dot(normal, view)));;
    float4 rim = tex2D(spSampler, ndotv).g;
    //lerps
    color.rgb += saturate(rim * RimMask);
    //misc stuff

    #ifdef blush
    color.a *= blush_slider;
    #endif
    color *= egColor;

    return color;
}

//edgeline shader
struct edge_out
{
    float4 pos          : POSITION;
    float2 uv           : TEXCOORD0;
    float4 vertex       : TEXCOORD1;
    float3 normal       : TEXCOORD2;
};

edge_out vs_edge ( vs_in i )
{
    edge_out o = (edge_out)0;
    o.uv = i.uv;
    o.vertex = i.vertexcolor;
    i.pos.xyz = i.pos.xyz + normalize(i.normal) * o.vertex * 0.015;
    o.pos = mul(i.pos, mmd_wvp);
    return o;
};

float4 ps_edge( edge_out i ) : COLOR0
{
    float2 uv = i.uv;
    float4 color = 1;
    float4 diffuse = tex2D(diffuseSampler, uv);
    if(model_type == 0)
    {
    color.rgb = diffuse.rgb * diffuse.rgb * 0.7;
    } else if(model_type == 1)
    {
    color = float4(0,0,0,1);
    }
    color.a = i.vertex;
    #ifdef blush
    color.a = 0;
    #endif
    return color;
}

technique model_SS_tech <string MMDPASS = "object_ss"; >
{
    pass main
    {
        cullmode = ccw;
        AlphaBlendEnable = TRUE; 
        #ifdef additive
        SrcBlend = SrcColor;
        DestBlend = ONE;
        #endif
        VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_model();

    }
    pass edge
    {
        cullmode = cw;
        AlphaBlendEnable = TRUE; 
        VertexShader = compile vs_3_0 vs_edge();
        PixelShader = compile ps_3_0 ps_edge();
    }
}

technique tech_edge < string MMDPass = "edge"; >
{
}
