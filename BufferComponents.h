#ifndef BUFFERCOMPONENTS_H
#define BUFFERCOMPONENTS_H

#include <d3d11.h>	// We require the d3d11 header for Direct3D functions
#include <d3dcompiler.h>	// We also need the D3DCompiler header to compile shaders
#include <DirectXMath.h>
#include "FBXLoader.h"
#include "Terrain.h"
#include <iostream>
#include "MacroDefinitions.h"
#include "Camera.h"

using namespace DirectX;

// We require a combined transformation matrix from all the previously created matrices and a matrix to preserve the world positions throughout the pipeline

struct GS_CONSTANT_BUFFER {

	XMMATRIX worldViewProj;
	XMMATRIX matrixWorld;
	XMMATRIX matrixView;
	XMMATRIX matrixProjection;
	XMMATRIX floorRot;
	XMFLOAT3 cameraPos;

};

class BufferComponents {

public:

	BufferComponents();
	~BufferComponents();

// Storing both the transposed WorldViewProj and WorldMatrix as global variables to easily reach them when performing calculations in the update loop

	XMMATRIX transformMatrix;
	XMMATRIX tWorldMatrix;
	XMMATRIX tFloorRot;

	vector<Vertex_Bone> fbxVector;

	ID3D11Buffer* gVertexBuffer;	// Vertex buffer
	ID3D11Buffer* gConstantBuffer;	// Constant buffer to provide the vertex shader with updated transformation data per frame

	ID3D11Texture2D* depthStencil;	// Depth-stencil texture
	ID3D11DepthStencilState* depthState;	// Depth-stencil state used for the output merger
	ID3D11DepthStencilView* depthView;	// Depth-stencil view to access the depth stencil texture

	void SetupScene(ID3D11Device* &gDevice, Camera &mCam, FbxImport &fbxImporter);

	bool CreateVertexBuffer(ID3D11Device* &gDevice);
	bool CreateSkeletalBuffers(ID3D11Device* &gDevice, FbxImport &fbxImporter);
	bool CreateConstantBuffer(ID3D11Device* &gDevice, Camera &mCam);

};

#endif BUFFERCOMPONENTS_H