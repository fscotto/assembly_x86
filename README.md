# 🧠 Assembly x86 Examples (32-bit) - Intel Syntax

This repository contains a collection of simple **x86 32-bit assembly examples**, written using **Intel syntax**. These examples are meant to help you learn and experiment with low-level programming concepts on the x86 architecture.

## 🛠 Toolchain Used

- **Assembler:** [NASM (Netwide Assembler)](https://www.nasm.us/)
- **Linker:** `ld` (GNU Linker)
- **Target OS:** Linux (x86)

## ▶️ How to Compile and Run

Make sure you have `nasm` and `ld` installed. On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install nasm
```

### Compile

```bash
nasm -f elf32 file.asm -o file.o
ld -m elf_i386 file.o -o file
```

### Run

```bash
./file
```

### Full Example

```bash
nasm -f elf32 hello_world.asm -o hello_world.o
ld -m elf_i386 hello_world.o -o hello_world
./hello_world
```

## 📚 Intel Syntax

All source files use **Intel syntax**, where the **destination operand comes first**. For example:

```asm
mov eax, 1        ; Load 1 into eax
mov ebx, eax      ; Copy eax into ebx
mov ecx, [ebx]    ; Load into ecx the value at memory address stored in ebx
```

## 🧩 Requirements

- 32-bit architecture or compatibility with `elf32`
- Linux or a compatible environment with `nasm` + `ld`
- Optional: QEMU or Docker for emulation on pure 64-bit systems

## 📝 License

This project is licensed under the **MIT License**. Feel free to study, modify, and reuse the code.

## 🤝 Contributing

Contributions, improvements, or new demos are welcome! Open an issue or a pull request 🚀

---

> Made with ❤️ for low-level enthusiasts.
