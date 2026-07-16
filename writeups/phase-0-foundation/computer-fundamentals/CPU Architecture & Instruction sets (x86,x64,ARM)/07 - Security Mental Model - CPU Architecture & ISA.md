# 07 – Security Mental Model

**Phase:** Phase 0 – Computer Fundamentals

**Module:** CPU Architecture & Instruction Sets (x86/x64/ARM)

**Type:** Module Capstone

**Estimated Study Time:** 20–30 Minutes

---

# Overview

Completing this module changed the way I view program execution.

At the beginning, I thought of executables as applications that simply "run" on a computer. I now understand that every executable follows a predictable execution path governed by the processor architecture, instruction set, registers, and operating system.

Rather than treating each subtopic independently, I can now connect them into a single execution model that explains how software behaves at runtime.

---

# Complete Execution Workflow

Every program follows a similar lifecycle.

```text
Executable File
       │
       ▼
Operating System loads the program
       │
       ▼
CPU identifies the Architecture
(x86 / x64 / ARM)
       │
       ▼
Instruction Set Architecture (ISA)
defines how instructions are interpreted
       │
       ▼
CPU Fetches Instruction
       │
       ▼
Instruction stored in RIP
       │
       ▼
Registers receive operands
(RAX, RCX, RDX...)
       │
       ▼
Arithmetic / Logic / Comparison
       │
       ▼
RFLAGS updated
       │
       ▼
Conditional Jump?
       │
       ▼
Function Call
       │
       ▼
Arguments passed using Calling Convention
       │
       ▼
Operating System API
(File, Memory, Network...)
       │
       ▼
Return Value → RAX
       │
       ▼
Next Instruction
(RIP Updated)
       │
       ▼
Program Continues
```

This workflow represents the execution path that I will repeatedly encounter while debugging software and analyzing malware.

---

# How Everything Connects

Throughout this module, I learned that every concept depends on the previous one.

**CPU Architecture** determines which processor executes the program.

↓

**Instruction Set Architecture (ISA)** defines the language understood by that processor.

↓

**Registers** temporarily store instructions, operands, addresses, and execution state.

↓

**RIP** controls which instruction executes next.

↓

**RSP** and **RBP** manage function execution through the stack.

↓

**General-Purpose Registers** carry data between instructions.

↓

**RFLAGS** records comparison results that influence execution flow.

↓

**Calling Conventions** define how functions exchange information.

↓

**Operating System APIs** perform real actions such as opening files, allocating memory, or communicating over the network.

Understanding this chain allows me to reason about program behavior instead of memorizing isolated concepts.

---

# Security Perspective

When I analyze malware, I no longer see individual assembly instructions.

Instead, I ask questions such as:

* Which architecture was this binary compiled for?
* Which ISA am I looking at?
* Which instruction is RIP executing?
* What values are stored in the registers?
* Why did RFLAGS cause this branch?
* Which function is being called?
* What arguments are being passed?
* Which operating system resource is being accessed?

These questions transform assembly into a logical sequence of actions rather than a collection of unfamiliar instructions.

---

# From Theory to Investigation

This module also changed my investigative workflow.

When receiving an unknown executable, I now follow a structured approach:

1. Identify the target architecture.
2. Select the appropriate debugger and disassembler.
3. Inspect the register state.
4. Follow RIP during execution.
5. Observe stack activity through RSP and RBP.
6. Interpret conditional branches using RFLAGS.
7. Inspect function arguments.
8. Determine which operating system APIs are being used.
9. Reconstruct the malware's behavior.

This workflow is repeatable regardless of whether I am analyzing legitimate software or malicious code.

---

# Module Summary

By completing this module, I developed the ability to:

* Identify processor architectures.
* Understand how CPUs interpret instructions.
* Differentiate x86, x64, and ARM platforms.
* Analyze register state during execution.
* Follow program flow using RIP.
* Understand stack behavior.
* Interpret conditional execution.
* Trace function arguments and return values.
* Correlate assembly instructions with real-world program behavior.

Together, these skills provide the foundation required for debugging, reverse engineering, exploit development, and malware analysis.

---

# Portfolio Reflection

This module fundamentally changed how I think about computers.

Before starting, I viewed applications as software that simply executed after being launched. I now understand that every executable follows a well-defined sequence controlled by the processor. Every instruction updates registers, modifies flags, interacts with the stack, and eventually requests services from the operating system.

This knowledge gives me a much stronger foundation for future topics such as operating systems, memory management, reverse engineering, exploit development, and malware analysis.

Rather than memorizing assembly syntax, I now understand **why** the processor performs each operation and **how** those operations reveal a program's true behavior.
