# CPU Architecture & Instruction Sets (x86/x64/ARM)

> *"Every malware sample, executable, exploit, or legitimate application ultimately becomes CPU instructions. Understanding how the processor executes those instructions is the foundation of reverse engineering and malware analysis."*

---

# Module Overview

This module explores how a Central Processing Unit (CPU) executes programs and why CPU architecture is one of the first things a cybersecurity professional should identify before analyzing an executable.

Throughout this module, I learned how operating systems load programs into memory, how different processor architectures execute instructions, how registers store runtime information, how functions communicate using calling conventions, and how the CPU makes execution decisions through status flags.

Rather than treating assembly language as unfamiliar syntax, I now understand it as the processor's native language and can relate instructions directly to the CPU's execution process.

---

# Learning Objectives

After completing this module, I can:

* Explain the role of CPU architecture in program execution.
* Differentiate CPU Architecture from Instruction Set Architecture (ISA).
* Compare x86, x64, and ARM architectures.
* Explain why architecture identification is the first step in malware analysis.
* Understand how registers assist CPU execution.
* Interpret RIP, RSP, RBP, General-Purpose Registers, and RFLAGS during debugging.
* Explain how functions communicate using calling conventions.
* Apply a structured CPU-centric mental model during reverse engineering.

---

# Module Structure

```text
CPU Architecture & Instruction Sets
│
├── 01 - What is CPU Architecture?
├── 02 - Instruction Set Architecture (ISA)
├── 03 - x86 vs x64
├── 04 - ARM Architecture
│
├── Registers
│     ├── 05.1 - What is a Register?
│     ├── 05.2 - RIP (Instruction Pointer)
│     ├── 05.3 - RSP & RBP (The Stack)
│     ├── 05.4 - General-Purpose Registers
│     └── 05.5 - RFLAGS
│
├── 06 - Calling Conventions
│
└── 07 - Security Mental Model
```

---

# Security Mental Model

The following diagram summarizes how every executable is processed by a modern computer.

```text
                     Executable
                          │
                          ▼
                Operating System Loader
                          │
                 Creates a Process
                          │
                   Loads into RAM
                          │
                          ▼
                  CPU Architecture
                          │
              Identifies Instruction Set
                          │
                          ▼
                Fetch → Decode → Execute
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
   Registers          Stack Frame        RFLAGS
(RAX, RIP, RSP,       (RSP/RBP)      Execution Decisions
 RCX, RDI...)             │                 │
        └─────────────────┼─────────────────┘
                          ▼
                  Function Calls
             (Calling Conventions)
                          │
                          ▼
               Program / Malware Behavior
                          │
                          ▼
             Reverse Engineering & Analysis
```

---

# Cybersecurity Workflow

When analyzing an unknown executable, I now follow this workflow:

```text
Identify Executable
        │
        ▼
Determine CPU Architecture
        │
        ▼
Determine Instruction Set
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
Analyze Function Calls
        │
        ▼
Inspect Return Values
        │
        ▼
Check RFLAGS
        │
        ▼
Understand Malware Behavior
```

This structured workflow allows me to analyze binaries systematically instead of randomly stepping through assembly instructions.

---

# Practical Skills Gained

During this module, I practiced:

* Identifying executable architectures using `file`.
* Inspecting processor information using `lscpu`.
* Viewing register contents using GDB.
* Following instruction execution through RIP.
* Understanding stack behavior using RSP and RBP.
* Tracing function arguments using calling conventions.
* Interpreting conditional execution using RFLAGS.
* Relating assembly instructions to malware behavior.

---

# Key Takeaways

* CPU architecture determines how a processor executes instructions.
* ISA defines the language understood by the processor.
* x86, x64, and ARM use different registers and instruction formats.
* Registers provide the fastest insight into runtime behavior.
* RIP controls execution flow, while RSP and RBP manage function execution.
* Calling conventions explain how functions exchange data.
* RFLAGS determines conditional execution paths.
* Identifying architecture before reverse engineering significantly improves analysis efficiency.

---

# Portfolio Reflection

This module transformed the way I understand software execution. I now see every executable as a sequence of processor instructions rather than simply a program launched by the operating system. More importantly, I have developed a CPU-centric mental model that guides my approach to reverse engineering and malware analysis. By identifying the architecture, understanding the instruction set, inspecting registers, following the Instruction Pointer, analyzing function calls, and interpreting CPU flags, I can systematically investigate how software behaves at runtime. This knowledge forms a strong foundation for future topics such as memory analysis, binary exploitation, malware reverse engineering, and advanced debugging.

---

**Module Status:** ✅ Completed

**Next Module:** **Operating Systems & Process Management**
