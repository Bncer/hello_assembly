# hello_assembly

Hello world in [nasm](https://www.nasm.us/) assembler

Architecture: Linux x86_64

```
nasm -felf64 hello_world.asm &&
ld hello_world.o -o hello_world &&
./hello_world
```
