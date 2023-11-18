#!/usr/bin/env zsh
set -ex
. ./_common.sh

pushd "$SRC/openal"
mkdir -p build
pushd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="$OPENAL_DIR" \
      -DCMAKE_OSX_ARCHITECTURES:STRING=x86_64\;arm64 \
      -DALSOFT_BACKEND_PORTAUDIO=OFF \
      -DALSOFT_BACKEND_PULSEAUDIO=OFF \
      -DALSOFT_EXAMPLES=OFF \
      -DALSOFT_UTILS=OFF \
      -DALSOFT_MIDI_FLUIDSYNTH=OFF \
      -GNinja ..
cmake --build .
mkdir -p "$OPENAL_DIR"
cmake --install . --prefix "$OPENAL_DIR"
popd
popd