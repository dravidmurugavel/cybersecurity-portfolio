
# Following Data Through Memory

**Job-Role Tag:** Malware Analyst / Reverse Engineer / DFIR Analyst / SOC Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Memory

**Date:** 2026-07-10

---

# Objective

Integrate the concepts of storage, RAM, virtual memory, CPU cache, registers, stack, and heap into a single mental model that explains how a program executes from launch to termination.

---

# Why This Matters

Understanding individual memory concepts is valuable, but cybersecurity professionals investigate **running systems**, not isolated components.

Whether analyzing malware, reverse engineering software, performing incident response, or debugging an application, the same execution path is followed every time a program runs.

Building a complete mental model allows an analyst to reason about where data exists, how it moves through the system, and where evidence can be collected during an investigation.

---

# The Complete Execution Journey

When a user launches an application, the following sequence occurs:

```text id="j8k1rw"
Executable Stored on SSD/HDD
            │
            ▼
Operating System Creates a Process
            │
            ▼
Virtual Address Space Created
            │
            ▼
Required Pages Loaded into RAM
            │
            ▼
CPU Fetches Frequently Used Data into Cache
            │
            ▼
Values Loaded into CPU Registers
            │
            ▼
CPU Executes Instructions
            │
            ▼
Function Calls Use the Stack
Dynamic Allocations Use the Heap
            │
            ▼
Page Fault (If Required)
            │
            ▼
Operating System Loads Missing Page
            │
            ▼
Execution Continues
```

This sequence occurs continuously while a program is running.

---

# Component Responsibilities

## SSD / HDD

Permanent storage for executables and data.

Programs remain here until they are launched.

---

## Operating System

Responsible for:

* Creating a process
* Assigning a virtual address space
* Loading required pages into RAM
* Managing page tables
* Handling page faults

---

## Virtual Memory

Provides each process with its own virtual address space.

The operating system translates virtual addresses into physical memory locations.

---

## RAM

Stores the active code and data required for execution.

The CPU executes instructions only after they have been loaded into RAM.

---

## CPU Cache

Stores frequently accessed instructions and data close to the processor to reduce memory access latency.

Cache improves performance but does not replace RAM.

---

## Registers

Registers are small storage locations inside the CPU.

Before an instruction executes, the CPU loads the required values into registers.

Registers hold the data currently being processed—they are not stored inside the cache.

---

## Stack

Automatically stores temporary function-related information, including:

* Local variables
* Function parameters
* Return addresses

The stack is automatically managed during function calls and returns.

---

## Heap

Stores dynamically allocated memory requested by the program.

Heap memory remains allocated until explicitly released.

---

# Memory Hierarchy

The complete execution hierarchy is:

```text id="d5n3mt"
SSD / HDD
     │
     ▼
Virtual Memory
     │
     ▼
Physical RAM
     │
     ▼
L3 Cache
     │
     ▼
L2 Cache
     │
     ▼
L1 Cache
     │
     ▼
CPU Registers
     │
     ▼
CPU Executes Instructions
```

Each layer exists to balance speed, capacity, and efficient resource management.

---

# Hands-on Review

Throughout this module, the following Linux commands were used:

```bash id="b4w8jp"
free -h
```

```bash id="q6v9hc"
cat /proc/meminfo | head -10
```

```bash id="f2p7mx"
ps aux --sort=-%mem | head
```

```bash id="x5k3ne"
lscpu
```

```bash id="a8m2rd"
swapon --show
```

```bash id="u1z6yt"
vmstat 1 5
```

These commands provide visibility into memory usage, cache information, swap activity, and running processes.

---

# Real Incident

## WannaCry (2017)

Once the WannaCry executable was launched:

1. The executable was loaded from disk into RAM.
2. The operating system created a process and assigned virtual memory.
3. The CPU fetched frequently executed instructions into cache.
4. Function calls used the stack.
5. Dynamic memory allocations used the heap.
6. Encryption keys and ransomware state existed within process memory during execution.

### Security Lesson

Malware becomes dangerous only after it executes.

This is why memory forensics is critical—RAM may contain:

* Running malware
* Decrypted payloads
* Encryption keys
* Network connections
* Injected code
* Command-line arguments
* Other volatile evidence that may never be written to disk.

---

# My Learning Journey

At the beginning of this module, I viewed memory as simply "RAM."

By the end of the exercises, I developed a complete execution model:

* Storage permanently holds programs.
* The operating system creates a process and manages virtual memory.
* RAM becomes the active workspace.
* CPU caches reduce memory access latency.
* Registers hold the values currently being processed.
* The stack manages temporary function data.
* The heap stores dynamically allocated memory.
* Page faults allow execution to continue when required pages are not immediately present in RAM.

This integrated view significantly improved my understanding of how software actually executes.

---

# What I Got Wrong First

## Initial Misconceptions

During the learning process, I initially believed:

* CPU registers were stored inside cache.
* The operating system simply "searched" for pages during a page fault.
* Virtual memory primarily meant using disk when RAM became full.

## Correct Understanding

I learned that:

* Registers are inside the CPU.
* Cache stores frequently accessed instructions and data.
* Virtual memory provides address abstraction.
* The operating system manages page mappings through page tables.
* Page faults are normal exceptions that allow missing pages to be loaded before execution resumes.

---

# Core Takeaway

A running program is not simply "loaded into RAM."

Execution is a coordinated process involving permanent storage, virtual memory, RAM, CPU cache, registers, the stack, the heap, and the operating system.

Understanding how these components interact provides the foundation for malware analysis, reverse engineering, exploit development, memory forensics, and secure software engineering.

---

# Interview Practice

## Question

Walk through what happens when a user double-clicks an executable, from storage to CPU execution.

---

## My Answer

The executable begins on permanent storage. When launched, the operating system creates a new process, assigns it a virtual address space, and loads the required pages into RAM. Frequently accessed instructions and data are placed into CPU caches, while the values needed for immediate execution are loaded into CPU registers. During execution, function calls use the stack, dynamic allocations use the heap, and any missing memory pages trigger page faults so the operating system can load them before execution continues.

---

## Feedback

### Strengths

* Correct sequencing from storage to execution.
* Proper distinction between RAM, cache, and registers.
* Correct explanation of stack, heap, and page faults.
* Connected memory concepts into a complete execution model.

### Improvement

Continue refining terminology by clearly distinguishing the responsibilities of the CPU, operating system, and program. Precise language becomes increasingly important in reverse engineering and exploit analysis.

---

# Skills Demonstrated

* Explaining complete program execution
* Understanding process memory layout
* Connecting storage, memory, and CPU execution
* Relating memory concepts to malware execution
* Understanding volatile forensic artifacts
* Building a security-focused mental model of program execution

---

# Related Resources

* *Computer Systems: A Programmer's Perspective* — Bryant & O'Hallaron
* *Operating Systems: Three Easy Pieces* — Arpaci-Dusseau & Arpaci-Dusseau
* *Practical Malware Analysis* — Michael Sikorski & Andrew Honig
* *The Art of Memory Forensics* — Michael Hale Ligh et al.

---

# Summary

Modern program execution is the result of cooperation between storage devices, the operating system, virtual memory, RAM, CPU caches, registers, the stack, and the heap. Rather than viewing these components independently, security professionals analyze them as a connected execution pipeline. This mental model is fundamental to incident response, malware analysis, reverse engineering, exploit development, and digital forensics because it explains where data resides, how it moves, and where valuable evidence can be recovered during an investigation.
