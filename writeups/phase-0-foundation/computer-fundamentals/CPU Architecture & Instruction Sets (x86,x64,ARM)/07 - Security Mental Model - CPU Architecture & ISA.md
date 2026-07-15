# 07 - Security Mental Model: CPU Architecture & Instruction Sets

> **Module:** Computer Fundamentals
> **Topic:** CPU Architecture & Instruction Sets (x86/x64/ARM)
> **Subtopic:** Security Mental Model

---

# Introduction

Throughout this module, I learned individual concepts such as CPU architecture, instruction sets, registers, the stack, function calls, and calling conventions. Although each concept is important on its own, real cybersecurity work requires understanding **how they work together**.

This document combines those concepts into a single mental model that I can apply during malware analysis, reverse engineering, debugging, and incident response.

Rather than memorizing isolated facts, I now visualize the complete execution path of a program from storage to the CPU.

---

# Why This Matters in Cybersecurity

Every executable eventually follows the same journey:

* It is loaded by the operating system.
* It becomes a process.
* It is placed into memory.
* The CPU executes its instructions.
* Registers store temporary data.
* Functions communicate using calling conventions.
* Decisions are made using CPU flags.

Understanding this sequence allows me to investigate suspicious software with a structured and repeatable methodology.

---

# Mental Model 1 — Program Execution

Every program follows the same high-level execution flow.

```text id="cpuflow01"
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
CPU
        │
Reads Instruction Set
        │
        ▼
Fetch → Decode → Execute
```

The operating system prepares the program, but the CPU performs the execution.

---

# Mental Model 2 — Identify the Architecture First

Before opening a binary in a debugger, I first determine its architecture.

```bash id="cmd01"
file malware
```

Possible output:

```text id="file01"
ELF 64-bit LSB executable, x86-64
```

or

```text id="file02"
ELF 64-bit LSB executable, ARM aarch64
```

From this single command, I immediately know:

* Target architecture
* Instruction set
* Register names
* Calling convention
* Appropriate debugging tools

This becomes my first step in every malware investigation.

---

# Mental Model 3 — CPU Execution

The processor repeatedly executes instructions.

```text id="cpuflow02"
RIP
 │
 ▼
Fetch
 │
 ▼
Decode
 │
 ▼
Execute
 │
 ▼
Update RIP
 │
 ▼
Repeat
```

Following RIP during debugging allows me to reconstruct the program's execution path.

---

# Mental Model 4 — Registers

During execution, the CPU stores active information inside registers.

```text id="regs01"
Registers

├── RIP → Next Instruction
├── RSP → Top of Stack
├── RBP → Current Stack Frame
├── RAX → Return Value
├── RDI → Argument 1
├── RSI → Argument 2
├── RCX → Counter / Argument
├── RDX → Argument
└── RFLAGS → CPU Decisions
```

Registers provide the quickest insight into a program's runtime behavior.

---

# Mental Model 5 — Function Calls

Programs communicate through functions.

Before:

```asm id="asm01"
call fopen
```

Registers contain:

```text id="call01"
RDI → Filename

RSI → Mode
```

After execution:

```text id="call02"
RAX → Return Value
```

Immediately afterward:

```asm id="asm02"
test rax, rax
je failed
```

The CPU decides whether execution should continue.

Understanding this pattern allows me to interpret many library function calls without reading large amounts of assembly.

---

# Mental Model 6 — The Stack

Whenever a function is called:

```text id="stack01"
call
 │
 ▼
Return Address Stored
 │
 ▼
RSP Changes
 │
 ▼
New Stack Frame
 │
 ▼
Function Executes
 │
 ▼
ret
 │
 ▼
Return Address Restored
```

This explains how the CPU moves between functions and why stack corruption can redirect execution.

---

# Mental Model 7 — Malware Analysis Workflow

When investigating malware, my workflow now becomes:

```text id="workflow01"
Identify Architecture
        │
        ▼
Determine ISA
        │
        ▼
Open in Ghidra / GDB
        │
        ▼
Follow RIP
        │
        ▼
Inspect Registers
        │
        ▼
Identify Function Calls
        │
        ▼
Check RAX
        │
        ▼
Inspect RFLAGS
        │
        ▼
Understand Malware Behavior
```

Instead of randomly stepping through instructions, I now follow a logical process.

---

# Practical Example

Suppose I discover an unknown executable.

First:

```bash id="cmd02"
file sample
```

Output:

```text id="file03"
ELF 64-bit LSB executable, x86-64
```

Then I know:

✓ x86-64 ISA

✓ System V AMD64 ABI

✓ RDI contains Argument 1

✓ RSI contains Argument 2

✓ RAX stores return values

✓ RIP tracks execution

Suppose I encounter:

```asm id="asm03"
mov rdi, "/home/user/.ssh/id_rsa"
mov rsi, "r"
call fopen

test rax, rax
je failed
```

Without source code, I can infer:

* The program opens the user's SSH private key.
* It attempts to read the file.
* It checks whether the operation succeeded.
* It follows the Linux x86-64 calling convention.

This demonstrates how the concepts from this module work together during real-world malware analysis.

---

# Common Mistakes

### Jumping into Assembly Immediately

Always identify the architecture first.

---

### Ignoring Register Values

Registers often reveal more information than the surrounding instructions.

---

### Following Every Instruction

Instead, focus on:

* Function calls
* Return values
* Stack changes
* Conditional jumps

These provide the highest-value information.

---

### Memorizing Registers Without Context

Understanding **how** registers interact during execution is more valuable than memorizing their names.

---

# Key Takeaways

* Every executable follows the same execution path from storage to the CPU.
* CPU architecture determines how instructions are executed.
* ISA defines the processor's language.
* RIP controls execution flow.
* RSP and RBP manage function execution.
* General-Purpose Registers store active program data.
* RFLAGS controls conditional execution.
* Calling conventions explain how functions communicate.
* Combining these concepts creates a structured workflow for malware analysis.

---

# Portfolio Reflection

Completing this module fundamentally changed my understanding of program execution. I no longer see an executable as a single file but as a sequence of interactions between the operating system, memory, CPU architecture, instruction set, registers, stack, and function calls. More importantly, I now have a repeatable mental model for approaching malware analysis. Instead of reading assembly line by line, I first identify the architecture, understand the calling convention, inspect registers, follow RIP, examine the stack, and use RFLAGS to explain control flow. This structured approach has given me a much stronger foundation for reverse engineering and prepares me for more advanced topics such as memory exploitation, binary analysis, and debugging.
