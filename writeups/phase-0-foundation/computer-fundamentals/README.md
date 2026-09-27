# Computer Fundamentals

> Security-focused computer fundamentals for understanding how operating systems, hardware, storage, memory, boot processes, and virtualization work from an offensive and defensive cybersecurity perspective.

---

## Module Overview

This section covers the core computer fundamentals required to understand how modern operating systems and security mechanisms actually work.

The goal was not to study computer science theory in isolation, but to understand the underlying systems from a **cybersecurity perspective**.

The learning path progressed from physical hardware and data representation to operating-system internals and virtualization, then extended into a bonus reverse-engineering track (x86-64 assembly + Ghidra) once the core foundation was solid.

---

## Learning Objectives

By completing this section, I can:

* Explain how modern CPUs execute instructions.
* Understand x86-64 architecture and CPU registers.
* Explain RAM, cache, virtual memory, paging, and swap.
* Understand physical disks, partitions, file systems, and mounting.
* Interpret binary, hexadecimal, ASCII, file signatures, and endianness.
* Explain the BIOS/UEFI boot process.
* Understand bootloaders and kernel loading.
* Explain user mode and kernel mode.
* Understand hardware and software interrupts.
* Explain system calls and the user/kernel boundary.
* Understand processes, threads, and context switching.
* Explain virtualization, hypervisors, virtual machines, and containers.
* Select appropriate virtualization technology for different cybersecurity scenarios.
* Read x86-64 assembly and calling conventions well enough to follow disassembled code.
* Navigate a binary in Ghidra and identify security-relevant functions.

---

## Cross-Module Security Mental Model

```text
                         COMPUTER
                            │
             ┌──────────────┴──────────────┐
             │                             │
           CPU                          Storage
             │                             │
       Instructions                  Partitions
       Registers                     File Systems
             │                             │
             └──────────────┬──────────────┘
                            │
                          Memory
                            │
                  Virtual Memory / RAM
                            │
                            ▼
                       Boot Process
                            │
                    BIOS / UEFI
                            │
                       Bootloader
                            │
                          Kernel
                            │
                  ┌─────────┴─────────┐
                  │                   │
              User Mode          Kernel Mode
                  │                   │
             Applications       OS Services
                  │                   │
                  └──── System Calls ┘
                            │
                       Processes
                            │
                      Threads / CPU
                            │
                   Context Switching
                            │
                    Virtualisation
                            │
              ┌─────────────┴─────────────┐
              │                           │
          Virtual Machines            Containers
              │                           │
        Guest OS + Kernel          Shared Host Kernel
```

The most important lesson from this section is that cybersecurity is not just about applications and networks — a threat can operate at any layer, from firmware and CPU up through the kernel to the running application. Understanding these layers is what lets a security professional reason about **where** an attack occurs, **what privileges** it has, **what evidence** it leaves behind, and **how** it can be detected or investigated.

---

## Cybersecurity Applications

| Foundation         | Future Security Application               |
| ------------------- | ------------------------------------------ |
| CPU Architecture    | Reverse Engineering, Exploit Development   |
| Memory              | Malware Analysis, Memory Forensics         |
| Storage             | Digital Forensics, Incident Response       |
| File Systems        | Forensics, Malware Persistence             |
| Number Systems      | Binary Analysis, Packet Analysis           |
| Boot Process        | Rootkits, Bootkits, Secure Boot            |
| Kernel/User Mode    | Privilege Escalation, Rootkits             |
| Interrupts          | Kernel Security, EDR                       |
| System Calls        | Malware Analysis, Behavioral Detection     |
| Processes           | SOC, EDR, Incident Response                |
| Context Switching   | OS Internals, Performance Analysis         |
| Virtual Machines    | Malware Analysis, Pen Testing              |
| Containers          | Cloud Security, DevSecOps                  |
| x86-64 Assembly     | Reverse Engineering, Exploit Development   |
| Ghidra / Static RE  | Malware Analysis, Vulnerability Research   |

---

## Module Status

| Module                                                | Status      |
| ------------------------------------------------------ | :---------: |
| Number Systems & Data Representation                    | ✅ Complete |
| CPU Architecture & Instruction Sets (x86, x64, ARM)      | ✅ Complete |
| Memory: RAM, Cache, Virtual Memory & Paging              | ✅ Complete |
| Storage: HDD/SSD, Partitioning & File Systems            | ✅ Complete |
| Boot Process: BIOS, UEFI, Bootloader & Kernel Loading    | ✅ Complete |
| Interrupts, System Calls & Context Switching             | ✅ Complete |
| Virtualisation: Hypervisors, VMs & Containers            | ✅ Complete |
| **Bonus:** x86-64 Assembly & Ghidra Basics               | ✅ Complete |

**Overall Status:** 🟢 Complete (core) + bonus RE track

---

## Detailed Write-ups

Each topic below is documented as a standalone folder containing a `README.md` plus one markdown file per subtopic, matching the actual structure of this repository.

```text
computer-fundamentals/
│
├── README.md
│
├── Number Systems & Data Representation/
├── CPU Architecture & Instruction sets (x86,x64,ARM)/
├── Memory: RAM, cache, virtual memory, paging/
├── Storage - HDD,SSD, Partitioning and File systems/
├── Boot Process – BIOS, UEFI, Bootloader & Kernel Loading/
├── Interrupts, System Calls & Context Switching/
├── Virtualisation - Hypervisors, Virtual Machines & Containers/
└── X86-64 Assembly & Ghidra basics/        (bonus content)
```

Each folder contains its own detailed write-ups, working through the subtopic step by step with a "Security Relevance" and "Key Takeaway" for every concept.

### Bonus Content
The **x86-64 Assembly & Ghidra basics** folder goes beyond the original Phase 0 scope, covering:
- x86-64 registers, memory addressing, and calling conventions from a security-analysis angle (not full ISA memorization).
- Static reverse-engineering practice in Ghidra, with a dedicated Ghidra security analysis write-up and screenshots of the actual analysis session.

This was added because reading disassembly is a prerequisite for later Phase 2/3 work (malware analysis, vulnerability research), so getting comfortable with it early made sense.

---

## Conclusion

Computer fundamentals form the foundation for everything that follows in cybersecurity.

A security professional who understands only tools can operate a tool. A security professional who understands **how the computer actually works** can understand what the tool is detecting, why the behavior occurs, where the evidence exists, and how an attacker is interacting with the underlying system.

This section establishes that foundation before progressing into deeper cybersecurity topics, starting with [Linux Administration & Bash Scripting](../linux-administration-and-bash-scripting/README.md).
