# Memory Fundamentals

> **Module:** Computer Fundamentals → Memory
> **Learning Goal:** Build a security-first understanding of how memory works, how programs execute, and why memory is one of the most valuable sources of evidence during cybersecurity investigations.

---

# Overview

This module explores how modern operating systems manage memory and how the CPU executes programs. Instead of treating memory as a single concept, the module breaks it into practical components used daily by SOC Analysts, DFIR Analysts, Malware Analysts, Reverse Engineers, and Exploit Developers.

The learning path progresses from basic RAM concepts to a complete execution workflow, allowing the learner to understand exactly how data moves from permanent storage to CPU execution.

Every topic combines:

* Theory
* Linux hands-on labs
* Real-world security incidents
* Interview preparation
* Practical cybersecurity applications

---

# Learning Path

```
Memory Fundamentals
│
├── 1. RAM Fundamentals
│
├── 2. CPU Cache (L1, L2, L3)
│
├── 3. Stack vs Heap Memory
│
├── 4. Virtual Memory & Paging
│
└── 5. Following Data Through Memory
```

---

# Repository Structure

```
memory/
│
├── README.md
│
├── 1_ram-fundamentals.md
│
├── 2_cpu-cache-fundamentals.md
│
├── 3_stack-vs-heap-memory.md
│
├── 4_virtual-memory-and-paging.md
│
└── 5_following-data-through-memory.md
```

---

# Module Objectives

After completing this module, I can:

* Explain why programs execute from RAM instead of storage.
* Differentiate RAM from SSD/HDD.
* Explain the purpose of CPU caches.
* Describe the L1 → L2 → L3 cache hierarchy.
* Differentiate stack and heap memory.
* Explain dynamic memory allocation.
* Describe virtual memory and paging.
* Explain page faults and swap space.
* Follow the complete execution path of a program.
* Relate memory concepts to malware analysis and digital forensics.

---

# Security Mental Model

Understanding memory is easier when viewed as a complete execution pipeline rather than isolated concepts.

```
                 Program Stored on SSD/HDD
                           │
                           ▼
          Operating System Creates Process
                           │
                           ▼
          Virtual Address Space Created
                           │
                           ▼
          Required Pages Loaded into RAM
                           │
                           ▼
             CPU Cache (L3 → L2 → L1)
                           │
                           ▼
                  CPU Registers
                           │
                           ▼
               CPU Executes Instructions
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
 Function Calls                        Dynamic Allocation
     Stack                                  Heap
        │                                     │
        └──────────────────┬──────────────────┘
                           │
                           ▼
                Page Missing from RAM?
                           │
              ┌────────────┴────────────┐
              │                         │
             No                        Yes
              │                         │
              ▼                         ▼
      Continue Execution      CPU Raises Page Fault
                                        │
                                        ▼
                       Operating System Loads Page
                               From Swap/File
                                        │
                                        ▼
                           Update Page Tables
                                        │
                                        ▼
                            Resume Execution
```

---

# Why This Matters in Cybersecurity

Memory contains the live state of a running system.

Unlike files stored on disk, RAM can contain information that exists only while a program is executing.

Examples include:

* Running malware
* Injected code
* Process memory
* Command-line arguments
* Network connections
* Decrypted payloads
* Credentials
* Session tokens
* Cryptographic keys

Because RAM is volatile, it is one of the first acquisition targets during Digital Forensics and Incident Response (DFIR).

---

# Real-World Security Topics Covered

Throughout this module, the following real-world security topics were explored:

| Topic            | Security Lesson                                                                     |
| ---------------- | ----------------------------------------------------------------------------------- |
| Cold Boot Attack | Sensitive information can remain recoverable in RAM after shutdown.                 |
| Spectre          | CPU cache behavior can leak sensitive information through timing side channels.     |
| Morris Worm      | Stack buffer overflows can overwrite return addresses and hijack program execution. |
| Heartbleed       | Process memory may expose passwords, session cookies, and cryptographic keys.       |
| WannaCry         | Malware becomes active only after it is loaded into memory and executed.            |

---

# Linux Commands Practiced

```bash
free -h

cat /proc/meminfo | head -10

ps aux --sort=-%mem | head

lscpu

swapon --show

vmstat 1 5
```

---

# Skills Gained

By completing this module, I developed the ability to:

* Analyze Linux memory usage.
* Interpret CPU cache information.
* Explain stack and heap memory layouts.
* Understand virtual memory management.
* Explain page faults and swap activity.
* Follow the lifecycle of a running process.
* Understand where malware executes.
* Recognize valuable forensic artifacts in RAM.
* Build a complete execution mental model used in malware analysis and incident response.

---

# Recommended Reading

## Books

* *Computer Systems: A Programmer's Perspective* — Bryant & O'Hallaron
* *Operating Systems: Three Easy Pieces* — Arpaci-Dusseau & Arpaci-Dusseau
* *Practical Malware Analysis* — Michael Sikorski & Andrew Honig
* *The Art of Memory Forensics* — Michael Hale Ligh et al.

## Documentation

* Linux `/proc` Filesystem Documentation
* Linux `vmstat(8)` Manual
* Linux `free(1)` Manual
* Linux `lscpu(1)` Manual

---

# Final Takeaway

Memory is the bridge between permanent storage and CPU execution.

Every program, whether legitimate software or malware, follows the same execution path: the operating system creates a process, maps virtual memory, loads pages into RAM, the CPU retrieves frequently used data through its cache hierarchy, stores immediate values in registers, and executes instructions while using the stack and heap for runtime data. Understanding this complete workflow provides the foundation for malware analysis, reverse engineering, exploit development, digital forensics, and nearly every advanced area of cybersecurity.
