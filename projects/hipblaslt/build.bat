@echo off
setlocal

call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

echo "====================================================="
echo "venv: C:\Develop\.venv-3.13.7\Scripts\activate"
@REM call C:\Develop\.venv-3.13.7\Scripts\activate
echo "====================================================="

set ROCM_PATH=C:/Develop/.venv-3.13.7/Lib/site-packages/_rocm_sdk_devel
set PATH=%ROCM_PATH%/bin;%ROCM_PATH%/lib/llvm/bin/;%PATH%
set ROCM_DIR=%ROCM_PATH%
set HIP_PATH=%ROCM_PATH%
set HIP_DIR=%ROCM_PATH%
set CC=%ROCM_PATH%/lib/llvm/bin/clang.exe
set CXX=%ROCM_PATH%/lib/llvm/bin/clang++.exe
set CMAKE_CC_COMPILER=%ROCM_PATH%/lib/llvm/bin/clang.exe
set CMAKE_CXX_COMPILER=%ROCM_PATH%/lib/llvm/bin/clang++.exe
set HIP_CLANG_PATH=%ROCM_PATH%/lib/llvm/bin/
set HIP_DEVICE_LIB_PATH=%ROCM_PATH%/lib/llvm/amdgcn/bitcode
set PYTORCH_ROCM_ARCH=gfx1151
set HIP_PLATFORM=amd

rmdir /s /q build

cmake -B build -S . ^
-D CMAKE_BUILD_TYPE=Release ^
-D CMAKE_CXX_COMPILER=%CXX% ^
-D CMAKE_C_COMPILER=%CC% ^
-D CMAKE_CXX_FLAGS="-DNOMINMAX" ^
-D GPU_TARGETS=gfx1151 ^
-D HIPBLASLT_ENABLE_ROCM_SMI=OFF ^
-D HIP_PLATFORM=amd ^
-D HIPBLASLT_ENABLE_BLIS=OFF ^
-D TENSILELITE_BUILD_TESTING=OFF ^
-D HIPBLASLT_BUILD_TESTING=OFF ^
-D HIPBLASLT_ENABLE_ROCROLLER=OFF ^
-D HIPBLASLT_ENABLE_FETCH=OFF ^
-D HIPBLASLT_ENABLE_THEROCK=ON ^
-D HIPBLASLT_ENABLE_CLIENT=OFF ^
-D CMAKE_PREFIX_PATH="depend/Release"

cmake --build build --target all  --config Release

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Build completed. Starting installation...
    cmake --install build --prefix C:/opt/hipblaslt/Release
)

endlocal