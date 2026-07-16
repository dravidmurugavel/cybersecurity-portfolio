# 02 – Instruction Set Architecture (ISA)

**Phase:** Phase 0 – Computer Fundamentals

**Module:** CPU Architecture & Instruction Sets (x86/x64/ARM)

**Subtopic:** Instruction Set Architecture (ISA)

**Estimated Study Time:** 25–30 Minutes

**Skill Category:**

* Computer Architecture
* Assembly Fundamentals
* Reverse Engineering Foundations
* Malware Analysis Foundations

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

---

# Overview

After understanding CPU Architecture, the next question I had was:

> **"How does the CPU actually understand a program?"**

The answer is the **Instruction Set Architecture (ISA)**.

Every processor understands only a specific set of machine instructions. When a developer writes a program in C, C++, Rust, or another programming language, the compiler translates that source code into machine instructions belonging to a particular ISA. The CPU then executes those instructions one by one.

Understanding ISA helped me realize that assembly language is not simply another programming language—it is the human-readable representation of the instructions the processor actually executes.

---

# Why This Matters in Cybersecurity

Reverse engineering, malware analysis, and exploit development all revolve around understanding the processor's instructions.

When analyzing malware, I rarely have access to the original source code. Instead, I work with assembly instructions generated from machine code. Knowing the Instruction Set Architecture allows me to interpret these instructions correctly and understand what the malware is actually doing.

Without understanding the ISA, assembly appears as random mnemonics. Once I understood the ISA, I began seeing assembly as the processor's execution plan.

---

# Core Concept

An **Instruction Set Architecture (ISA)** is the language understood by a processor.

It defines:

* The instructions the processor can execute.
* Available registers.
* Memory addressing methods.
* Data types and operand sizes.
* Calling conventions and execution behavior.

The ISA acts as a contract between software and hardware.

A compiler converts source code into machine instructions that belong to a specific ISA. The processor then decodes and executes those instructions directly.

For example:

```text id="0fg8gn"
C Code
   │
Compiler
   │
Machine Code (x86-64 ISA)
   │
CPU Executes
```

If the compiled instructions do not match the processor's ISA, the program cannot execute natively.

---

# Hands-on Lab

To observe the processor architecture associated with the ISA, I used:

```bash id="a7xts8"
lscpu
```

The output confirmed:

```text id="dguu2j"
Architecture: x86_64
```

This tells me that every native executable running inside my Kali virtual machine uses the **x86-64 Instruction Set Architecture**.

During reverse engineering, this immediately tells me to expect instructions such as:

```asm id="6pmvpl"
mov
add
sub
cmp
call
jmp
```

along with registers such as:

```text id="3h7ylb"
RAX
RBX
RCX
RDX
RSP
RBP
RIP
```

Knowing the ISA allows me to interpret these instructions correctly when debugging or reading assembly.

---

# Windows Perspective

On Windows, the processor architecture can be identified using:

```cmd id="ghhh78"
systeminfo
```

or

```cmd id="lyv2l5"
echo %PROCESSOR_ARCHITECTURE%
```

If the architecture is **AMD64**, Windows executables will typically follow the x86-64 ISA and Windows x64 calling convention.

When investigating Windows malware, confirming the ISA ensures that I select the correct debugger and understand the expected register set.

---

# Real-World Security Example

Imagine I receive a suspicious Windows executable.

Using:

```bash id="jzpw9m"
file malware.exe
```

I identify it as:

```text id="86w4eh"
PE32+ executable (GUI) x86-64
```

When I load the binary into Ghidra, I immediately encounter assembly instructions such as:

```asm id="g3whmq"
mov rax, 5
call fopen
cmp rax, 0
jne success
```

Without understanding the ISA, these instructions would have little meaning.

However, because I know the processor's instruction set, I can interpret the malware's behavior by following the instructions executed by the CPU rather than relying on incomplete or unavailable source code.

---

# Key Learnings

This topic taught me that the CPU does not understand programming languages—it understands only its Instruction Set Architecture.

I also learned that compilers act as translators between high-level code and processor instructions. Once compiled, the processor executes only machine instructions defined by its ISA.

Most importantly, I realized that reverse engineering is the process of understanding these instructions to reconstruct a program's behavior.

---

# Learning Outcome

After completing this subtopic, I can:

* Define Instruction Set Architecture (ISA).
* Explain the relationship between source code, compilers, and machine code.
* Identify why different processors require different instruction sets.
* Understand why assembly language is central to reverse engineering.
* Explain why malware analysts work with ISA-specific assembly instructions.

---

# Portfolio Reflection

Before studying ISA, I believed assembly language was simply a lower-level programming language. I now understand that it represents the processor's native instruction set in a human-readable form.

This realization changed how I think about malware analysis. Instead of relying on decompiled source code, I now appreciate that the assembly generated from the Instruction Set Architecture reveals the exact sequence of operations performed by the processor. Understanding the ISA provides a much more accurate view of program behavior and forms the foundation for debugging, reverse engineering, and exploit analysis.

---

## Next Step

**03 – x86 vs x64**

Now that I understand how processors interpret instructions, the next step is to compare **32-bit and 64-bit architectures**, understand their differences, and explore how those differences affect malware analysis and reverse engineering.
