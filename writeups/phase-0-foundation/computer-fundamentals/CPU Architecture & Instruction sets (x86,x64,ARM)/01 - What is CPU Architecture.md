# 01 – What is CPU Architecture?

**Phase:** Phase 0 – Computer Fundamentals

**Module:** CPU Architecture & Instruction Sets (x86/x64/ARM)

**Subtopic:** What is CPU Architecture?

**Estimated Study Time:** 20–30 Minutes

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

---

# Overview

Every executable file eventually becomes instructions that are executed by the processor. Whether it is a legitimate application, ransomware, or a remote access trojan, none of them can run unless the processor understands the instruction format they were compiled for.

Before learning this topic, I viewed CPU architecture simply as "Intel", "AMD", or "ARM." After completing this lesson, I understand that CPU architecture defines the execution environment of a program. It determines how instructions are interpreted, how registers are organized, how memory is addressed, and ultimately how software interacts with the hardware.

For a cybersecurity professional, identifying the CPU architecture is one of the very first steps before beginning malware analysis or reverse engineering.

---

# Why This Matters in Cybersecurity

One of the first questions asked during binary analysis is:

> **"What architecture was this executable built for?"**

The answer immediately influences the rest of the investigation.

By identifying the architecture, I can determine:

* Which debugger or disassembler should be used.
* Which register set I should expect.
* Which instruction format I will encounter.
* Which calling convention the executable follows.
* Whether the sample can execute on the current machine.

For example, malware compiled for **x86-64 Windows** cannot execute natively on an ARM processor because the processor cannot interpret x86-64 machine instructions. Likewise, an ARM malware sample requires an ARM environment or emulation for analysis.

Understanding the architecture before opening the binary prevents unnecessary troubleshooting and establishes the correct analysis environment from the beginning.

---

# Core Concept

CPU Architecture is the overall design of a processor that defines **how programs are executed**.

It specifies how the processor:

* Executes instructions.
* Organizes registers.
* Addresses memory.
* Performs arithmetic and logical operations.
* Communicates with the operating system and hardware.

Each processor family follows its own architecture. Although two processors may perform the same task, the instructions they understand and the way they execute them may be completely different.

Some of the most common processor architectures include:

* **x86** – 32-bit architecture widely used in older desktop and enterprise systems.
* **x86-64 (AMD64)** – 64-bit extension of x86, now the standard architecture for modern desktops, laptops, workstations, and servers.
* **ARM** – A power-efficient architecture used extensively in smartphones, tablets, embedded systems, IoT devices, and Apple Silicon computers.

An executable compiled for one architecture cannot normally run on another architecture without translation, emulation, or recompilation because the processor does not understand a different instruction format.

---

# Hands-on Lab

To identify my processor architecture, I used the following command on my Kali Linux system:

```bash
lscpu
```

### Observation

The output showed:

* Architecture: **x86_64**
* CPU Vendor: **GenuineIntel**

From this single command, I immediately learned that:

* My Kali virtual machine is running on a **64-bit Intel-compatible processor**.
* Every Linux executable I analyze inside this VM will use the **x86-64 architecture** unless otherwise specified.
* While debugging, I should expect **64-bit registers** such as RAX, RIP, and RSP.
* Reverse engineering tools such as Ghidra, GDB, and objdump should interpret binaries using the x86-64 instruction set.

This simple enumeration step provides valuable context before beginning any malware investigation.

---

# Windows Perspective

Windows provides similar architecture information through multiple methods.

Using Command Prompt:

```cmd
echo %PROCESSOR_ARCHITECTURE%
```

or

```cmd
systeminfo
```

Architecture information can also be viewed from:

* **Settings → System → About**
* **System Information (msinfo32)**

Before analyzing a Windows malware sample, confirming the processor architecture ensures that the correct debugger, disassembler, and virtual machine configuration are selected.

---

# Real-World Security Example

Suppose I receive an unknown executable named:

```text
invoice.exe
```

Instead of opening it immediately in a debugger, I first identify its architecture.

On Linux:

```bash
file invoice.exe
```

Output:

```text
PE32+ executable (GUI) x86-64, for MS Windows
```

This tells me several important facts before I inspect a single assembly instruction:

* The executable targets **64-bit Windows**.
* The processor architecture is **x86-64**.
* The binary will use **64-bit registers**.
* The calling convention will follow the Windows x64 ABI.
* My analysis environment should be configured for x64 debugging.

With one command, I gain enough context to prepare an appropriate analysis workflow.

---

# Key Learnings

Throughout this topic, I learned that CPU architecture is much more than a processor name or hardware specification. It defines the execution environment in which every program operates.

I also learned that identifying the processor architecture is one of the first tasks performed during malware analysis because it influences register usage, instruction decoding, debugging tools, and the overall reverse engineering process.

Most importantly, I now understand that an executable is only meaningful if the processor understands the architecture for which it was compiled.

---

# Learning Outcome

After completing this subtopic, I can:

* Explain the purpose of CPU architecture.
* Identify common processor architectures.
* Determine the architecture of a Linux or Windows system.
* Explain why architecture identification is the first step in malware analysis.
* Relate CPU architecture to reverse engineering and debugging workflows.

---

# Portfolio Reflection

This topic fundamentally changed how I approach executable analysis. Previously, I considered architecture as basic hardware information. I now recognize it as the foundation for understanding how software executes on a system.

From this point onward, my first step when examining any unknown executable will be to identify its processor architecture. Doing so immediately tells me which instruction set, registers, debugger configuration, and analysis techniques I should expect. This simple habit reduces confusion during reverse engineering and establishes the correct context before investigating malware behavior.

---

## Next Step

**02 – Instruction Set Architecture (ISA)**

Now that I understand what CPU Architecture is, the next step is to learn **how the processor actually understands and executes instructions**, which is defined by the **Instruction Set Architecture (ISA)**.
