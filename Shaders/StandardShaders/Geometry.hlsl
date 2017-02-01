//----------------------------------------------------------------------------------------------------------------------------------//
// Geometry Shader DirectX11
//
// Philip Velandria, Jonathan Sundberg, Linnea Vajda, Fredrik Linde
//----------------------------------------------------------------------------------------------------------------------------------//

// The registers are underlying hardware registers on the GPU where all data is stored during execution of the shaders
// There are different types of register for different types of data
// - Buffers uses "b"

cbuffer GS_CONSTANT_BUFFER : register(b0) {

	matrix worldViewProj;
	matrix matrixWorld;
	matrix matrixView;
	matrix matrixProjection;
	matrix floorRot;
};

struct GS_IN
{
	float3 Pos : POSITION;
	float2 Tex: TEXCOORD;

};

struct GS_OUT
{
	float4 Norm: NORMAL;
	float2 Tex: TEXCOORD;
	float4 Pos : SV_POSITION;
	float4 WPos : WPOSITION;

};

// The geometry shader takes an entire primitive as an array as its input, but it also require an upper limit for the amount of 
// vertices to output. Therefore the program runs for every primitive. Because we are going to output two triangles, the total 
// vertex count must be a total of 6

[maxvertexcount(6)]
void GS_main(triangle GS_IN input[3], inout TriangleStream<GS_OUT> triStream)
{
	GS_OUT output;

	// UINT is an unsigned INT. The range is 0 through 4294967295 decimals
	uint i;
	float3 offSet = float3(1.0f, 1.0f, 1.0f);

	// Calculate the length of the sides (edges) A and B to use them for calculating the normal (Delta Pos)

	float3 edge1 = input[1].Pos.xyz - input[0].Pos.xyz;
	float3 edge2 = input[2].Pos.xyz - input[0].Pos.xyz;
	
	// Calculate the normal to determine the direction for the new triangle to be created ( closer to the camera )

	float3 normalAB = normalize(cross(edge1, edge2));

	for (i = 0; i < 3; i++)
	{
		// To store and calculate the World position for output to the pixel shader, the input position must be multiplied with the World matrix

		output.WPos = mul(float4(input[i].Pos.xyz, 1.0f), matrixWorld);

		// To store and calculate the WorldViewProj, the input position must be multiplied with the WorldViewProj matrix

		output.Pos = mul(float4(input[i].Pos.xyz, 1.0f), worldViewProj);

		// For the normal to properly work and to later be used correctly when creating the basic diffuse shading, it's required to be computed in world coordinates

		output.Norm = mul(float4(normalAB, 1.0f), matrixWorld);

		output.Tex = input[i].Tex;

		triStream.Append(output);	// The output stream can be seen as list which adds the most recent vertex to the last position in that list
	}
	triStream.RestartStrip();
	for (i = 0; i < 3; i++)
	{
		output.WPos = mul(float4(input[i].Pos.xyz, 1.0f) + float4(offSet, 0.0f), matrixWorld);
		output.Pos = mul(float4(input[i].Pos.xyz, 1.0f) + float4(offSet, 0.0f), worldViewProj);
		output.Norm = mul(float4(normalAB, 1.0f), matrixWorld);
		output.Tex = input[i].Tex;
		triStream.Append(output);
	}

	// RestartStrip() function is called to restart the calculations for the next primitive and it doesn't matter whether we use a prmitive topology of TRIANGLELIST or 
	// TRIANGLESTRIP. We only have to restart after every triangle if we are using TRIANGLELIST as the defined primitive topology

};