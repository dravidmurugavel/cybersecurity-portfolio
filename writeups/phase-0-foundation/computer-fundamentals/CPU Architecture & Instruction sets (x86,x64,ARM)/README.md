# CPU Architecture & Instruction Sets (x86/x64/ARM)

> **Phase 0 – Computer Fundamentals**

Understanding how a processor executes instructions is one of the most important foundations in cybersecurity. Every executable—whether it is a legitimate application or a piece of malware—ultimately relies on the CPU to interpret and execute machine instructions. Before analyzing malware, debugging binaries, or reverse engineering software, it is essential to understand how processors work.

This module documents my learning journey through CPU Architecture and Instruction Sets. Rather than memorizing theory, I focused on understanding **how software is actually executed**, how the processor makes decisions, and why these concepts are fundamental to malware analysis and incident response.

---

# Learning Objectives

After completing this module, I am able to:

* Explain the purpose of CPU Architecture.
* Differentiate between x86, x64, and ARM architectures.
* Understand the role of the Instruction Set Architecture (ISA).
* Identify processor architectures using Linux and Windows tools.
* Understand how CPU registers influence program execution.
* Follow execution using the Instruction Pointer (RIP).
* Analyze stack behavior using RSP and RBP.
* Interpret conditional execution through RFLAGS.
* Understand how functions exchange information using calling conventions.
* Apply these concepts while debugging and reverse engineering executables.

---

# Module Structure

| #  | Topic                              | Status |
| -- | ---------------------------------- | ------ |
| 01 | What is CPU Architecture?          | ✅      |
| 02 | Instruction Set Architecture (ISA) | ✅      |
| 03 | x86 vs x64                         | ✅      |
| 04 | ARM Architecture                   | ✅      |
| 05 | CPU Registers                      | ✅      |
| 06 | Calling Conventions                | ✅      |
| 07 | Security Mental Model              | ✅      |

---

# Skills Developed

Throughout this module, I developed practical knowledge in:

* Computer Architecture
* Instruction Set Architecture (ISA)
* Assembly Language Fundamentals
* CPU Registers
* Stack Fundamentals
* Calling Conventions
* Debugging Basics
* Reverse Engineering Fundamentals
* Malware Analysis Foundations

---

# Hands-on Activities

During this module, I practiced identifying processor architectures and observing CPU behavior using Linux tools.

Examples include:

```bash
lscpu

uname -m

file sample

gdb

info registers
```

I also compared Linux and Windows processor architectures, examined register values during debugging, and followed program execution using assembly instructions.

These exercises helped bridge the gap between theoretical concepts and practical malware analysis.

---

# Cybersecurity Relevance

Every malware sample eventually becomes machine instructions executed by a processor.

Understanding CPU Architecture allows me to answer questions such as:

* Which processor can execute this binary?
* Which debugger should I use?
* Which registers should I inspect?
* Which calling convention is being used?
* Why did execution branch to another location?
* Which function is being called?
* What arguments are being passed?

These questions form the foundation of reverse engineering and malware analysis.

---

# Security Mental Model

The following workflow summarizes how a program executes from the processor's perspective.

```text
Executable
      │
      ▼
Operating System loads program
      │
      ▼
CPU Architecture
(x86 / x64 / ARM)
      │
      ▼
Instruction Set Architecture (ISA)
      │
      ▼
Instruction Fetch
      │
      ▼
Registers
      │
      ▼
RIP
      │
      ▼
General-Purpose Registers
      │
      ▼
RFLAGS
      │
      ▼
Conditional Execution
      │
      ▼
Calling Convention
      │
      ▼
Operating System APIs
      │
      ▼
Program Continues
```

This mental model provides a structured approach to understanding how software executes and how malware behaves at runtime.

---

# Key Takeaways

This module fundamentally changed how I approach executable analysis.

Instead of viewing programs as black boxes, I now understand the execution pipeline from the processor's perspective. Every instruction, register update, function call, and branch contributes to the program's behavior.

This knowledge provides the foundation for future topics including Operating Systems, Process Management, Memory Internals, Reverse Engineering, Exploit Development, and Malware Analysis.

---

# What's Next?

The next module is:

## **Operating Systems & Process Management**

Having learned how the processor executes instructions, the next step is understanding how the operating system creates, manages, schedules, and terminates processes.

In the next module, I will explore:

* Operating System Fundamentals
* Kernel vs User Space
* Processes and Threads
* Process Memory Layout
* System Calls
* File Descriptors
* Signals
* Process Privileges
* Linux and Windows Process Management

Together with this module, these topics will build a complete understanding of how software executes from the hardware level to the operating system level.

---

**Repository Learning Path**

```text
Number Systems & Data Representation
                │
                ▼
Memory Fundamentals
                │
                ▼
CPU Architecture & Instruction Sets
                │
                ▼
Operating Systems & Process Management
                │
                ▼
File Systems
                │
                ▼
Networking
                │
                ▼
Cybersecurity Specializations
```

> **Progress:** Phase 0 – Computer Fundamentals ✅
