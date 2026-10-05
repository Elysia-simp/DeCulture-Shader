#define merge_strings(a,b) a##b 


texture diffuseTexture : MATERIALTEXTURE <>;
sampler diffuseSampler = sampler_state 
{
	texture = < diffuseTexture >;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = ANISOTROPIC;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};
texture spTexture : MATERIALSPHEREMAP<>;
sampler spSampler = sampler_state 
{
	texture = < spTexture >;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = ANISOTROPIC;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};
texture maskTexture : MATERIALTOONTEXTURE<>;
sampler maskSampler = sampler_state 
{
	texture = < maskTexture >;
	MINFILTER = LINEAR;
	MAGFILTER = LINEAR;
	MIPFILTER = ANISOTROPIC;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};