# 01 - What is CPU Architecture?

> **Module:** Computer Fundamentals
> **Topic:** CPU Architecture & Instruction Sets (x86/x64/ARM)
> **Subtopic:** What is CPU Architecture?

---

# Introduction

CPU architecture is one of the first concepts every cybersecurity professional should understand. Whether performing malware analysis, reverse engineering, exploit development, or incident response, every executable ultimately relies on the processor to execute its instructions.

During my learning journey, I realized that an operating system does not actually execute a program. Instead, it prepares the environment by loading the executable into memory, after which the CPU begins executing instructions according to its own architecture. Understanding this distinction fundamentally changed how I view program execution and malware behavior.

---

# Why This Matters in Cybersecurity

Before analyzing any suspicious executable, an analyst should answer one simple question:

> **"Which CPU architecture was this program built for?"**

The answer determines:

* Which debugger to use
* Which disassembler settings to select
* Which registers will appear
* Which calling convention is used
* Which instruction set the processor understands

Without identifying the CPU architecture first, reverse engineering becomes unnecessarily difficult.

---

# What is CPU Architecture?

CPU architecture refers to the overall design of a processor and the rules it follows while executing instructions.

It defines:

* the instruction set the processor understands,
* the available registers,
* memory addressing capabilities,
* execution model,
* and communication between software and hardware.

A useful way to think about it is:

> **CPU Architecture is the processor's blueprint, while the Instruction Set Architecture (ISA) is the language defined by that blueprint.**

---

# CPU vs Operating System

One misconception I had was believing that the operating system executed applications.

In reality:

* The operating system creates the process.
* It allocates memory.
* It loads the executable into RAM.
* Then the CPU begins executing the instructions.

```text
Executable
      │
      ▼
Operating System
      │
Creates Process
      │
Loads into RAM
      │
      ▼
CPU
      │
Executes Instructions
```

The CPU is the component that actually runs the program.

---

# Common CPU Architectures

## x86 (32-bit)

Characteristics:

* 32-bit architecture
* Up to approximately 4 GB address space
* Legacy desktops and applications

Example:

```text
ELF 32-bit
PE32
```

---

## x86-64 (64-bit)

Also known as:

* AMD64
* Intel 64
* x64

Characteristics:

* 64-bit registers
* Large address space
* Modern desktops and servers

Example:

```text
ELF 64-bit LSB executable, x86-64
```

---

## ARM

Designed primarily for:

* Smartphones
* Tablets
* IoT devices
* Embedded systems
* Apple Silicon

Characteristics:

* Excellent power efficiency
* Reduced Instruction Set Computing (RISC)
* High performance per watt

Example:

```text
ELF 64-bit LSB executable, ARM aarch64
```

---

# Why Architecture Matters

A processor can only execute instructions built for its own architecture.

For example:

```text
Windows x64 Malware
        │
        ▼
x86-64 CPU

✓ Executes
```

But:

```text
Windows x64 Malware
        │
        ▼
ARM CPU

✗ Cannot Execute Natively
```

This explains why many applications require recompilation or emulation before they can run on different hardware.

---

# Practical Lab

## Identify Your CPU

```bash
lscpu
```

Example output:

```text
Architecture: x86_64
```

---

## Verify the System Architecture

```bash
uname -m
```

Example:

```text
x86_64
```

---

## Identify an Executable

```bash
file malware
```

Example:

```text
ELF 64-bit LSB executable, x86-64
```

From a single command, an analyst immediately knows:

* Target operating system
* CPU architecture
* Register size
* Appropriate debugging tools

---

# Cybersecurity Perspective

During malware analysis, architecture is one of the very first observations.

For example:

```bash
file suspicious_file
```

Output:

```text
ELF 64-bit LSB executable, x86-64
```

Without opening the executable in Ghidra or GDB, I already know:

* The malware targets Linux.
* It uses x86-64 registers.
* It follows the x86-64 instruction set.
* The System V AMD64 calling convention is likely used.

This small piece of information significantly reduces analysis time.

---

# Common Misconceptions

### "The Operating System Executes Programs"

Incorrect.

The operating system prepares the process.

The CPU executes every instruction.

---

### "Architecture and Operating System are the Same"

Incorrect.

Windows, Linux, and macOS are operating systems.

x86, x64, and ARM are CPU architectures.

A Linux system can run on x86-64 or ARM processors.

---

### "Changing the File Extension Changes Compatibility"

Incorrect.

Changing:

```text
malware.exe
```

to

```text
malware.bin
```

does not change the underlying machine instructions.

The CPU still requires instructions matching its own architecture.

---

# Security Mental Model

```text
Executable File
        │
        ▼
Operating System
        │
Creates Process
        │
Loads into RAM
        │
        ▼
CPU Architecture
        │
Checks Instruction Set
        │
        ▼
CPU Executes Program
```

Whenever I encounter an unknown executable, the first question I now ask is:

> **Which architecture was this built for?**

---

# Key Takeaways

* CPU architecture defines how a processor executes instructions.
* The operating system loads a program, but the CPU executes it.
* x86, x86-64, and ARM are the most common modern architectures.
* A processor cannot natively execute instructions built for another architecture.
* Identifying CPU architecture is the first step in malware analysis and reverse engineering.

---

# Portfolio Reflection

Learning CPU architecture changed my understanding of how software actually runs. I previously viewed an executable as something the operating system simply launched, but I now understand that the operating system only prepares the process. The CPU becomes responsible for executing every instruction according to its architecture and instruction set. This perspective has also improved my approach to malware analysis, as identifying the target architecture now serves as my starting point before selecting tools, interpreting assembly, or investigating program behavior.
