# 06 – Calling Conventions

**Phase:** Phase 0 – Computer Fundamentals

**Module:** CPU Architecture & Instruction Sets (x86/x64/ARM)

**Subtopic:** Calling Conventions

**Estimated Study Time:** 45–60 Minutes

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

* CPU Architecture
* Instruction Set Architecture (ISA)
* x86 vs x64
* ARM Architecture
* CPU Registers

---

# Overview

After learning how registers store information during execution, the next question I had was:

> **"How do functions communicate with each other?"**

Programs constantly call functions. Some are written by developers, while others belong to operating system libraries. During execution, data must be passed into a function, and results must be returned back to the caller.

The rules that define this communication are called **Calling Conventions**.

Understanding calling conventions transformed the way I analyze assembly code. Instead of seeing random register values, I can now identify function arguments, track return values, and understand the purpose of many API calls during malware analysis.

---

# Why This Matters in Cybersecurity

Most malware analysis involves understanding what a program is trying to do.

Examples include:

* Opening files
* Reading credentials
* Connecting to remote servers
* Creating processes
* Modifying registry keys
* Encrypting data

These actions are usually performed through function calls.

If I understand the calling convention, I can inspect the registers before a function executes and determine:

* Which function is being called.
* What arguments are being supplied.
* What data is being accessed.
* Whether the operation succeeded.

Calling conventions therefore provide one of the fastest ways to understand malware behavior during debugging.

---

# Core Concept

A **Calling Convention** is a set of rules that defines how functions exchange information.

These rules specify:

* Where function arguments are stored.
* Where return values are placed.
* Which registers may be modified.
* How the stack is used.

Without calling conventions, the caller and callee would have no consistent method of communication.

---

# System V AMD64 Calling Convention

Most modern Linux x86-64 systems use the **System V AMD64 ABI**.

The first function arguments are passed through registers:

| Argument | Register |
| -------- | -------- |
| 1st      | RDI      |
| 2nd      | RSI      |
| 3rd      | RDX      |
| 4th      | RCX      |
| 5th      | R8       |
| 6th      | R9       |

The return value is stored in:

```text id="f8m7xl"
RAX
```

This means that simply inspecting these registers often reveals what data is being passed into a function.

---

# Hands-on Lab

During the lab, I examined a function call similar to:

```asm id="xg9n2q"
call fopen
```

Before the function executed:

```text id="z2g0ih"
RDI → filename
RSI → mode
```

From the register values, I determined:

```text id="epw9tl"
Argument 1 = filename
Argument 2 = mode
```

This allowed me to understand what file the program intended to open before the function even executed.

I also learned that:

```text id="c4r2ew"
RAX
```

contains the return value after the function finishes.

---

# Following a Real Function Call

Consider the following sequence:

```asm id="zq5sgt"
call fopen
test rax, rax
je failed
```

After the function returns:

```text id="s5l1dr"
RAX = Return Value
```

If:

```text id="x94kdi"
RAX = 0
```

the function failed.

If:

```text id="2g9ecf"
RAX ≠ 0
```

the function succeeded and returned a valid file handle.

This pattern appears frequently in both legitimate software and malware.

---

# Windows Perspective

Windows x64 uses a slightly different calling convention.

The first four arguments are passed using:

```text id="mh8u1x"
RCX
RDX
R8
R9
```

The return value still uses:

```text id="b4pnpg"
RAX
```

This difference is important during malware analysis because Linux and Windows binaries often place function arguments in different registers.

Identifying the platform allows me to correctly interpret function calls during debugging.

---

# Real-World Security Example

During the lab, I analyzed a simplified scenario:

```asm id="k38aqm"
call fopen
```

Register inspection showed:

```text id="0ahv9v"
Argument 1:
/home/user/.ssh/id_rsa

Argument 2:
r
```

Immediately, I could infer that the program was attempting to read the user's SSH private key.

After the function returned:

```asm id="1l6n7z"
test rax, rax
je failed

mov rdi, rax
call read
```

Because:

```text id="03l4q3"
RAX ≠ 0
```

the file was successfully opened.

The returned file handle was then passed to another function for reading.

Without understanding the calling convention, these instructions would appear unrelated. By following the register flow, I could reconstruct the program's behavior.

---

# Common Patterns in Malware

While studying calling conventions, I realized that malware often reveals its intentions through function arguments.

Examples include:

```text id="77k2o9"
File Paths
Registry Keys
URLs
IP Addresses
Encryption Keys
Command Strings
```

Many of these values appear inside argument registers before important API calls.

Inspecting function arguments is therefore one of the quickest ways to understand what malware is trying to accomplish.

---

# Key Learnings

This topic taught me that function calls are not mysterious events occurring inside a program.

Instead, they follow predictable rules defined by calling conventions.

I learned that:

* Function arguments are typically passed through registers.
* Return values are stored in RAX.
* Linux and Windows use different calling conventions.
* Register inspection often reveals program behavior immediately.

Most importantly, I learned that understanding function arguments is often more valuable than reading large amounts of assembly code.

---

# Learning Outcome

After completing this topic, I can:

* Explain the purpose of calling conventions.
* Identify where function arguments are stored.
* Determine where return values are placed.
* Differentiate Linux and Windows x64 calling conventions.
* Analyze API calls using register inspection.
* Follow data flow between functions during debugging.

---

# Portfolio Reflection

Before studying calling conventions, function calls appeared as black boxes. I could identify that a function was being executed, but I had little visibility into what data was being passed or returned.

Learning calling conventions changed that completely. I now understand that registers act as communication channels between functions. By inspecting argument registers and return values, I can often determine a function's purpose without reading its implementation.

This has become one of the most valuable techniques I have learned so far because it provides a structured way to understand malware behavior through API calls, file operations, and network activity.

---

## Next Step

**07 – Security Mental Model**

The final topic of this module combines everything learned so far. Instead of viewing architecture, instructions, registers, and function calls as separate concepts, I will build a complete mental model showing how a processor executes a program from start to finish and how that knowledge supports malware analysis and reverse engineering.
