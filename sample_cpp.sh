#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd "$SCRIPTPATH/external/sample_layer_cpp/"

git apply ../cpp.patch

printf "cpp\n" && rm -f libsample_layer.so && make &&
env \
    ENABLE_SAMPLE_LAYER=1 \
    VK_ADD_LAYER_PATH="$(realpath .)" \
    VK_LOADER_LAYERS_ENABLE="VK_LAYER_SAMPLE_SampleLayer" \
    VK_LOADER_DEBUG=all \
    vkcube

rm -f libsample_layer.so
cd "$SCRIPTPATH/external/sample_layer_cpp/" && git reset --hard
