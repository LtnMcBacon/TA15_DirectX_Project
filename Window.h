#ifndef WINDOW_H
#define WINDOW_H

#include <d3d11.h>	// We require the d3d11 header for Direct3D functions
#include <d3dcompiler.h>	// We also need the D3DCompiler header to compile shaders
#include "MacroDefinitions.h"

using namespace std;

//----------------------------------------------------------------------------------------------------------------------------------//
// WINDOW FUNCTIONS
//----------------------------------------------------------------------------------------------------------------------------------//

LRESULT CALLBACK WindowProcedure(HWND windowHandle, UINT message, WPARAM wParam, LPARAM lParam);

bool WindowInitialize(HWND &windowHandle);	// Function to run the application

#endif WINDOW_H
