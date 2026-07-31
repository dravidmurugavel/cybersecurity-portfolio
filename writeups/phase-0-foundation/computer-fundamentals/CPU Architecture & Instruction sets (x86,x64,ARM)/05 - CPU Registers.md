# 05 – CPU Registers

**Phase:** Phase 0 – Computer Fundamentals

**Module:** CPU Architecture & Instruction Sets (x86/x64/ARM)

**Subtopic:** CPU Registers

**Estimated Study Time:** 20–30 Minutes

**Skill Category:**

* Computer Architecture
* Assembly Language Fundamentals
* Reverse Engineering
* Malware Analysis
* Debugging Fundamentals

**Relevant Job Roles:**

* SOC Analyst
* Malware Analyst
* Reverse Engineer
* Digital Forensics Analyst
* Threat Hunter
* Incident Responder
* Security Researcher

**Prerequisites:**

* What is CPU Architecture?
* Instruction Set Architecture (ISA)
* x86 vs x64
* ARM Architecture

---

# Overview

After understanding processor architectures and Instruction Set Architectures (ISA), I wanted to know how the CPU temporarily stores the information it needs while executing instructions.

The answer is **registers**.

Registers are the CPU's fastest storage locations. Every arithmetic operation, comparison, function call, conditional branch, and memory access relies on registers. During reverse engineering, registers provide a live view of what the processor is doing at any given moment.

Before learning this topic, I thought registers were simply variables inside the CPU. I now understand that they represent the processor's working state and often contain the most valuable evidence when debugging malware.

---

# Why This Matters in Cybersecurity

When malware analysts debug an executable, one of the first things they inspect is the register state.

Registers reveal information such as:

* The current instruction being executed.
* Function arguments.
* Return values.
* Memory addresses.
* Stack location.
* Results of comparisons.
* Execution flow.

Unlike decompiled code, registers expose the program's **actual runtime state**. They allow analysts to observe what the CPU is doing rather than what the developer intended.

Understanding registers transforms debugging from stepping through instructions to understanding the processor's decision-making process.

---

# Core Concept

Registers are tiny storage locations built directly into the processor.

Because they are physically inside the CPU, accessing them is significantly faster than retrieving information from cache, RAM, or storage.

A useful way to think about storage speed is:

```text
Registers
      │
CPU Cache
      │
RAM
      │
SSD / HDD
```

Whenever the processor performs an operation, it first moves the required values into registers, performs the computation, and stores the result back in a register before writing it elsewhere if necessary.

---

# Register Categories

Although processors contain many registers, the ones encountered most frequently during reverse engineering fall into four categories:

* General-Purpose Registers
* Instruction Pointer
* Stack Registers
* Status Register

Each serves a different role during execution.

---

# General-Purpose Registers

General-purpose registers store temporary values used during program execution.

Some common x86-64 registers include:

```text
RAX
RBX
RCX
RDX
RDI
RSI
R8–R15
```

Unlike specialized registers, these can hold integers, memory addresses, function arguments, loop counters, or intermediate calculations.

During one of the labs, I examined:

```text
RAX = 10
RBX = 15
```

After executing:

```asm
add rax, 5
```

the result became:

```text
RAX = 15
RBX = 15
```

Only the destination register changed.

This demonstrated that arithmetic instructions operate directly on registers rather than modifying every operand involved.

---

# RIP – Instruction Pointer

The **Instruction Pointer** (**RIP**) stores the address of the **next instruction** the processor will execute.

Every instruction completed by the CPU causes RIP to move to the next address unless the execution flow changes through instructions such as:

```asm
jmp
call
ret
jne
je
```

During debugging I observed values similar to:

```text
RIP = 0x402500
```

Rather than representing data, RIP represents **where execution is heading next**.

Following RIP while debugging is one of the simplest ways to understand a program's behavior.

---

# RSP & RBP – The Stack

The stack is a memory region used for function execution.

Two registers are particularly important:

### RSP (Stack Pointer)

RSP always points to the **top of the stack**.

Every time data is pushed or popped, RSP changes.

Examples:

```asm
push rax
pop rbx
call printf
ret
```

All of these modify RSP.

---

### RBP (Base Pointer)

RBP usually acts as a stable reference point for the current function.

Unlike RSP, which constantly changes, RBP often remains fixed until the function returns.

During debugging I learned:

* RSP changes frequently.
* RBP provides a consistent frame of reference.

This distinction makes stack analysis much easier.

---

# Why the Stack Matters

Every function call stores a **return address** on the stack.

When the function finishes:

```asm
ret
```

the processor loads that return address into RIP.

This causes execution to continue exactly where the function was called.

During our discussion, I learned why attackers target return addresses.

If an attacker overwrites the stored return address, the processor loads an attacker-controlled address into RIP, redirecting execution.

This is the fundamental idea behind classic **stack-based buffer overflow attacks**.

---

# RFLAGS

The **RFLAGS** register stores the results of arithmetic and comparison operations.

It contains multiple status flags.

One of the most important is:

```text
ZF (Zero Flag)
```

Example:

```asm
cmp rax, rbx
jne skip
```

If:

```text
RAX == RBX
```

then:

```text
ZF = 1
```

The jump is **not** taken.

Instead, execution continues to the next instruction.

During the hands-on lab, I observed that conditional jumps depend entirely on the status flags rather than the comparison instruction itself.

Understanding RFLAGS helped me understand how malware makes decisions during execution.

---

# Hands-on Lab

During this topic I practiced observing registers inside GDB.

Some of the values I encountered included:

```text
RAX = 5

RCX = Loop Counter

RSP = Stack Address

RIP = Next Instruction Address
```

I also followed execution through comparison instructions and observed how changing register values influenced program flow.

Rather than simply reading assembly, I was able to watch the processor execute instructions step by step.

---

# Windows Perspective

The same concepts apply on Windows.

Using tools such as:

* WinDbg
* x64dbg
* Visual Studio Debugger

I can inspect:

* RIP
* RSP
* RBP
* RAX
* RCX
* RDX
* RFLAGS

Although the debugging tools differ from Linux, the processor behaves exactly the same because the architecture defines register behavior rather than the operating system.

---

# Real-World Security Example

Suppose I am debugging ransomware.

Execution reaches:

```asm
call fopen
```

Immediately afterward:

```asm
test rax, rax
je failed
```

Instead of guessing what happened, I inspect RAX.

If:

```text
RAX = 0
```

the file failed to open.

If:

```text
RAX ≠ 0
```

the returned file handle is valid, and execution continues.

Similarly, inspecting:

* RIP shows the current execution path.
* RSP reveals stack activity.
* RCX and RDX expose function arguments.
* RFLAGS explains why conditional branches are taken.

This demonstrates why registers provide immediate visibility into a program's runtime behavior.

---

# Key Learnings

This topic showed me that registers are much more than temporary storage locations.

They represent the processor's current state and expose valuable runtime information during debugging.

I also learned that:

* RIP tracks execution.
* RSP manages the stack.
* RBP stabilizes stack frames.
* General-purpose registers carry data.
* RFLAGS determines execution decisions.

Together, these registers explain nearly every action performed by the CPU during program execution.

---

# Learning Outcome

After completing this topic, I can:

* Explain the purpose of CPU registers.
* Differentiate between general-purpose and specialized registers.
* Follow execution using RIP.
* Understand stack behavior through RSP and RBP.
* Interpret conditional execution using RFLAGS.
* Apply register analysis during malware debugging.

---

# Portfolio Reflection

Before studying registers, assembly instructions appeared disconnected from one another. I could read individual instructions but struggled to understand the processor's overall execution flow.

Learning how registers interact changed that perspective completely. I now see registers as the CPU's live workspace, where every instruction leaves evidence of what the processor is doing. Instead of passively reading assembly, I can actively follow execution through RIP, inspect data flowing through general-purpose registers, observe stack behavior using RSP and RBP, and understand execution decisions through RFLAGS.

For future malware analysis and reverse engineering, inspecting the register state will be one of my first steps because it provides immediate insight into how a program behaves at runtime.

---

## Next Step

**06 – Calling Conventions**

Having learned how the CPU stores and manipulates data in registers, the next step is understanding how functions communicate. Calling conventions explain where function arguments are placed, how return values are delivered, and how registers are used during function calls—knowledge that is essential for tracing API calls and understanding malware behavior.
