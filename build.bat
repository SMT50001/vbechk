mkdir build
del /Q build\*.*
fasm-win\fasm vbechk.asm build\vbechk.com -s build\vbechk.fas
