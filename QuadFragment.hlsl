struct PS_IN{
	float4 Pos : SV_POSITION;
};

float4 PS_main() : SV_TARGET
{
	return float4(1.0f, 1.0f, 1.0f, 1.0f);
}