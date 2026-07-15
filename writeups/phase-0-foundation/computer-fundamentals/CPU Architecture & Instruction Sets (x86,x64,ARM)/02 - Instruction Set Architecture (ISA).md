# 02 - Instruction Set Architecture (ISA)

> **Module:** Computer Fundamentals
> **Topic:** CPU Architecture & Instruction Sets (x86/x64/ARM)
> **Subtopic:** Instruction Set Architecture (ISA)

---

# Introduction

After understanding CPU architecture, the next logical question is:

> **How does the CPU understand a program?**

The answer lies in the **Instruction Set Architecture (ISA)**.

Every processor speaks a specific language. Regardless of whether software is written in C, C++, Rust, or Go, the processor cannot understand those languages directly. Before execution, the program must be translated into instructions that belong to the processor's ISA.

Understanding ISA is one of the most important skills in reverse engineering because assembly language is simply a human-readable representation of those instructions.

---

# Why This Matters in Cybersecurity

Whenever malware analysts begin investigating a binary, one of the first questions they ask is:

> **Which ISA was this malware compiled for?**

The answer determines:

* Which assembly language will appear.
* Which registers will be used.
* Which debugger and disassembler settings are required.
* Which calling convention is followed.
* How instructions should be interpreted.

Without identifying the ISA first, assembly instructions become difficult to understand correctly.

---

# What is an Instruction Set Architecture?

An **Instruction Set Architecture (ISA)** is the set of instructions that a processor understands and executes.

It acts as the communication bridge between software and hardware.

Think of it this way:

```text
Programmer
      │
Writes Code
      │
      ▼
Compiler
      │
Translates Code
      │
      ▼
Instruction Set Architecture
      │
      ▼
CPU Executes Instructions
```

The CPU never executes source code directly.

It only executes instructions defined by its ISA.

---

# Source Code to Machine Code

When a developer writes:

```c
int sum = a + b;
```

the compiler converts it into assembly instructions.

Example:

```asm
mov rax, rdi
add rax, rsi
```

The assembler then converts these instructions into machine code, which is finally executed by the CPU.

The complete flow is:

```text
Source Code
      │
      ▼
Compiler
      │
      ▼
Assembly
      │
      ▼
Machine Code
      │
      ▼
CPU
```

---

# ISA is the CPU's Language

Imagine speaking English to someone who understands only Japanese.

Communication fails.

Processors behave the same way.

An x86-64 processor understands x86-64 instructions.

An ARM processor understands ARM instructions.

A processor cannot natively execute instructions belonging to another ISA.

---

# Assembly vs Decompiled Code

One important realization during this module was that **assembly provides a much clearer picture of runtime behavior than decompiled source code.**

Decompiled code attempts to reconstruct what the original source might have looked like.

Assembly shows exactly what the processor executes.

For example:

```asm
mov rdi, filename
call fopen
```

Immediately tells me:

* A function is being called.
* The first argument is stored in RDI.
* The program is attempting to open a file.

Instead of reading reconstructed source code, I can observe the CPU's actual execution flow.

---

# Practical Lab

## Identify the Architecture

```bash
file malware
```

Example:

```text
ELF 64-bit LSB executable, x86-64
```

Immediately I know:

* ISA = x86-64
* Registers = RAX, RDI, RIP...
* Calling Convention = System V AMD64

---

Another example:

```text
ELF 64-bit LSB executable, ARM aarch64
```

Now I know:

* ISA = ARM64
* Registers = X0, X1, SP...
* ARM calling convention applies.

One command provides valuable context before opening the binary in Ghidra or GDB.

---

# Cybersecurity Perspective

During malware analysis, ISA influences every stage of investigation.

Knowing the ISA allows me to:

* choose the correct debugger,
* configure the disassembler properly,
* understand register names,
* recognize instruction syntax,
* interpret program behavior accurately.

Without ISA knowledge, assembly instructions appear as random text.

With ISA knowledge, they reveal the malware's intentions.

---

# Common Misconceptions

### "The CPU Understands C or Python"

Incorrect.

The CPU understands only machine instructions belonging to its ISA.

---

### "Assembly and Machine Code are Different Programs"

Incorrect.

Assembly is simply a human-readable representation of machine code.

Both describe the same instructions.

---

### "Changing Operating Systems Changes the ISA"

Incorrect.

The operating system does not determine the ISA.

The processor does.

Linux can run on:

* x86
* x86-64
* ARM
* RISC-V

The ISA depends on the CPU.

---

# Security Mental Model

```text
Source Code
      │
      ▼
Compiler
      │
      ▼
Assembly
      │
      ▼
Machine Code
      │
      ▼
Instruction Set Architecture
      │
      ▼
CPU Executes
```

Whenever I analyze a binary, I first determine its ISA before interpreting any assembly instructions.

---

# Key Takeaways

* ISA defines the language understood by the processor.
* The CPU cannot execute source code directly.
* Compilers translate programs into ISA-specific instructions.
* Assembly is a readable representation of machine code.
* Identifying the ISA is one of the first steps in malware analysis.
* Understanding ISA makes reverse engineering significantly easier.

---

# Portfolio Reflection

Learning Instruction Set Architecture completely changed how I view executable programs. I now understand that software is ultimately translated into processor-specific instructions before execution. Assembly is no longer just unfamiliar syntax—it is the CPU's language presented in a readable form. This understanding has made reverse engineering more approachable because I can now relate assembly instructions directly to processor behavior instead of viewing them as isolated commands. From now on, identifying the ISA will always be my first step before analyzing an unfamiliar executable.
