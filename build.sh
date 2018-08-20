#!/bin/bash
cd "$(dirname -- "$(readlink -fn -- "${0}")")"

# Used commits:
# https://github.com/KhronosGroup/Vulkan-ValidationLayers/commit/a055501
# https://github.com/KhronosGroup/Vulkan-Headers/commit/c4e056d
# https://github.com/KhronosGroup/glslang/commit/1323bf8

rm -rf Vulkan-ValidationLayers
rm -rf Vulkan-Headers
rm -rf glslang

git clone --depth 1 https://github.com/KhronosGroup/Vulkan-ValidationLayers
git clone --depth 1 https://github.com/KhronosGroup/Vulkan-Headers
git clone --depth 1 https://github.com/KhronosGroup/glslang

rm -rf Vulkan-ValidationLayers/.git
rm -rf Vulkan-Headers/.git
rm -rf glslang/.git

cd glslang
./update_glslang_sources.py
mkdir -p build
cd build
cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Release
ninja
cd ../..

mkdir -p ~/Desktop/vulkan_layers/glslang/lib
cp ~/Desktop/vulkan_layers/glslang/build/External/spirv-tools/source/libSPIRV-Tools.a         .
cp ~/Desktop/vulkan_layers/glslang/build/External/spirv-tools/source/opt/libSPIRV-Tools-opt.a .
cp libSPIRV-Tools.a     ~/Desktop/vulkan_layers/glslang/lib/
cp libSPIRV-Tools-opt.a ~/Desktop/vulkan_layers/glslang/lib/

mkdir -p ~/Desktop/vulkan_layers/glslang/include
cp -r ~/Desktop/vulkan_layers/glslang/SPIRV                                    ~/Desktop/vulkan_layers/glslang/include/
cp -r ~/Desktop/vulkan_layers/glslang/External/spirv-tools/include/spirv-tools ~/Desktop/vulkan_layers/glslang/include/

# Dafuq?
# https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/a055501/cmake/FindVulkanHeaders.cmake#L55
mkdir -p ~/Desktop/vulkan_layers/Vulkan-Headers/share/vulkan
cp -r ~/Desktop/vulkan_layers/Vulkan-Headers/registry ~/Desktop/vulkan_layers/Vulkan-Headers/share/vulkan/

cd Vulkan-ValidationLayers
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DVULKAN_HEADERS_INSTALL_DIR=~/Desktop/vulkan_layers/Vulkan-Headers -DGLSLANG_INSTALL_DIR=~/Desktop/vulkan_layers/glslang ..
ninja
cd ../..

