# 03 – x86 vs x64

**Phase:** Phase 0 – Computer Fundamentals

**Module:** CPU Architecture & Instruction Sets (x86/x64/ARM)

**Subtopic:** x86 vs x64

**Estimated Study Time:** 30–40 Minutes

**Skill Category:**

* Computer Architecture
* Operating System Fundamentals
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
* Instruction Set Architecture (ISA)

---

# Overview

After understanding CPU Architecture and Instruction Set Architecture (ISA), the next step was to understand why **x86** and **x64** are treated as different architectures.

Initially, I assumed the only difference was that one was 32-bit and the other was 64-bit. However, I learned that the transition from x86 to x64 introduced much more than a larger address space. It expanded the register set, increased the amount of directly addressable memory, changed calling conventions, and improved overall performance. These differences directly influence how malware behaves and how analysts approach reverse engineering.

---

# Why This Matters in Cybersecurity

One of the first pieces of information I collect during malware analysis is whether a binary is **32-bit or 64-bit**.

This determines:

* Which registers I should expect.
* Which calling convention is used.
* Which debugger configuration is appropriate.
* Whether the malware can execute natively on the target system.
* How memory addresses should be interpreted.

Understanding this distinction allows me to avoid incorrect assumptions while debugging and reverse engineering.

---

# Core Concept

The **x86 architecture** refers to the traditional **32-bit** Intel-compatible architecture, while **x86-64** (also called **AMD64**) is its **64-bit extension**.

The most significant differences include:

| Feature                   | x86                                 | x64                                                                           |
| ------------------------- | ----------------------------------- | ----------------------------------------------------------------------------- |
| Register Size             | 32-bit                              | 64-bit                                                                        |
| Address Space             | ~4 GB                               | Vastly larger (theoretical 16 EB; practical limits depend on hardware and OS) |
| General-Purpose Registers | 8                                   | 16                                                                            |
| Register Prefix           | `E`                                 | `R`                                                                           |
| Typical Systems           | Older desktops and embedded systems | Modern desktops, laptops, servers                                             |

One of the biggest improvements is the addition of **eight new general-purpose registers (R8–R15)**, giving the processor more working space and reducing the need to access memory during execution.

---

# Hands-on Lab

To identify the architecture of executables, I used:

```bash
file sampleA
file sampleB
```

The results showed:

```text
sampleA → ELF 64-bit LSB executable, x86-64

sampleB → ELF 32-bit LSB executable, Intel 80386
```

From this observation, I concluded:

* **sampleA** targets the x86-64 architecture.
* **sampleB** targets the 32-bit x86 architecture.
* Although both are ELF executables for Linux, they require different execution environments and use different register sets.

I also learned that the prefix of the registers reveals the architecture:

```text
x86

EAX
EBX
ECX
ESP
EBP
```

```text
x86-64

RAX
RBX
RCX
RSP
RBP
R8
R9
R10
```

Simply identifying the register names often tells me whether I am examining a 32-bit or 64-bit binary.

---

# Windows Perspective

Windows executables can also be identified using the `file` command in environments such as WSL or by examining them with tools like PE Studio, Detect It Easy (DIE), or PE-bear.

For example:

```text
PE32 executable
```

indicates a **32-bit** Windows executable.

Whereas:

```text
PE32+ executable
```

indicates a **64-bit** Windows executable.

This information immediately influences the debugger, register view, and calling convention I expect during analysis.

---

# Real-World Security Example

Suppose I receive a suspicious executable and identify it as:

```text
PE32+ executable (GUI) x86-64
```

Before opening the binary, I already know:

* The malware targets **64-bit Windows**.
* It will use **64-bit registers** such as **RAX**, **RSP**, and **RIP**.
* The Windows x64 calling convention will be used.
* Memory addresses will be 64-bit.
* I should configure my debugger for x64 analysis.

This preparation saves time and prevents confusion when stepping through assembly instructions.

---

# Key Learnings

This topic showed me that x64 is much more than "x86 with bigger numbers."

The move to 64-bit architecture increased addressable memory, expanded the register set, and introduced new execution conventions that are visible throughout reverse engineering and debugging.

I also learned that identifying whether a binary is 32-bit or 64-bit should become a routine part of my analysis workflow before inspecting any assembly code.

---

# Learning Outcome

After completing this subtopic, I can:

* Differentiate between x86 and x64 architectures.
* Explain why x64 supports a much larger address space.
* Identify x86 and x64 executables using Linux tools.
* Recognize architecture from register names.
* Explain why architecture identification is important before reverse engineering a binary.

---

# Portfolio Reflection

Before this topic, I thought the difference between x86 and x64 was simply the number of bits used by the processor. I now understand that the transition to x64 introduced significant architectural improvements that affect program execution, debugging, and malware analysis.

From now on, identifying whether a binary is 32-bit or 64-bit will be one of my first analysis steps. It immediately tells me which registers, memory model, and calling convention I should expect, allowing me to investigate the executable with the correct assumptions from the beginning.

---

## Next Step

**04 – ARM Architecture**

Having understood the dominant desktop architecture, the next step is to explore **ARM**, the architecture powering modern smartphones, embedded systems, IoT devices, and Apple Silicon. As ARM adoption continues to grow, understanding its instruction set and execution model is becoming increasingly important for cybersecurity professionals.
