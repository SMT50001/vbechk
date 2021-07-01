#!/bin/sh

mkdir build
rm build/vbechk.com
fasm-linux/fasm vbechk.asm build/vbechk.com
