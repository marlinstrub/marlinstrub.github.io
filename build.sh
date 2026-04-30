#!/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$SCRIPT_DIR/assets/fonts"

export D2_FONT_REGULAR="$FONT_DIR/IBMPlexMono-Light.ttf"
export D2_FONT_BOLD="$FONT_DIR/IBMPlexMono-Medium.ttf"
export D2_FONT_ITALIC="$FONT_DIR/IBMPlexMono-LightItalic.ttf"
export D2_FONT_SEMIBOLD="$FONT_DIR/IBMPlexMono-SemiBold.ttf"
export D2_FONT_MONO="$FONT_DIR/IBMPlexMono-Light.ttf"
export D2_FONT_MONO_BOLD="$FONT_DIR/IBMPlexMono-Medium.ttf"
export D2_FONT_MONO_ITALIC="$FONT_DIR/IBMPlexMono-LightItalic.ttf"
export D2_FONT_MONO_SEMIBOLD="$FONT_DIR/IBMPlexMono-SemiBold.ttf"

# Scale d2 output so class-shape titles (24px in d2) match the page's 14px body.
export SCALE="0.5833"

emacs -Q --script build-site.el
