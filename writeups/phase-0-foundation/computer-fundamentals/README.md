# Computer Fundamentals

> Security-focused computer fundamentals for understanding how operating systems, hardware, storage, memory, boot processes, and virtualization work from an offensive and defensive cybersecurity perspective.

---

## Module Overview

This section covers the core computer fundamentals required to understand how modern operating systems and security mechanisms actually work.

The goal was not to study computer science theory in isolation, but to understand the underlying systems from a **cybersecurity perspective**.

The learning path progressed from physical hardware and data representation to operating-system internals and virtualization.

---

# Learning Objectives

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

---

# 01 – CPU Architecture & Instruction Sets

### Topics Covered

* CPU architecture
* x86 and x86-64
* ARM architecture
* Instruction Set Architecture (ISA)
* CPU registers
* General-purpose registers
* RIP
* RSP
* RBP
* CPU flags
* Basic relationship between instructions and machine execution

### Security Relevance

Understanding CPU architecture is essential for:

* Reverse engineering
* Assembly analysis
* Malware analysis
* Exploit development
* Debugging
* Memory corruption analysis
* Understanding CPU-level attacks

A security analyst analyzing a disassembly must understand what instructions such as `mov`, `push`, `pop`, `call`, `ret`, and `jmp` actually do.

### Key Takeaway

> **The ISA defines the instructions the CPU understands; understanding the ISA is foundational to understanding compiled programs and exploits.**

---

# 02 – Memory: RAM, Cache & Virtual Memory

### Topics Covered

* RAM
* CPU cache
* L1/L2/L3 cache
* Stack
* Heap
* Virtual memory
* Memory pages
* Page faults
* Swap
* Address spaces
* ASLR

### Security Relevance

Memory is central to:

* Buffer overflows
* Memory corruption
* Process analysis
* Exploit development
* Malware analysis
* Memory forensics
* Rootkits
* Side-channel attacks

Understanding the difference between stack and heap memory provides the foundation for understanding memory corruption vulnerabilities.

Virtual memory and ASLR also explain why a process's memory addresses do not necessarily correspond directly to physical RAM.

### Key Takeaway

> **Processes operate in virtual address spaces, while the operating system and hardware translate those addresses to physical memory.**

---

# 03 – Storage & File Systems

### Topics Covered

* Physical disks
* Partitions
* MBR
* GPT
* File systems
* NTFS
* ext4
* Mounting
* Linux directory structure
* Windows drive letters
* File metadata
* Timestamps
* File ownership
* File permissions
* Hard links
* Symbolic links

### Security Relevance

Storage contains some of the most valuable evidence during security investigations.

Security professionals may examine:

* Malware
* Configuration files
* Logs
* Browser history
* Persistence mechanisms
* Deleted or recovered files
* File timestamps
* Ownership
* Permissions
* Hidden partitions
* Recovery partitions

A forensic investigation should consider the **entire physical storage device**, not simply the operating system partition.

### Key Takeaway

> **A disk provides physical storage, partitions organize that storage, and file systems provide the logical structure used to store and retrieve files.**

---

# 04 – Number Systems & Data Representation

### Topics Covered

* Binary
* Decimal
* Hexadecimal
* Bits and bytes
* ASCII
* Unicode
* Hex editors
* File signatures
* Byte representation
* Endianness
* Little-endian architecture
* SHA-256 and data integrity
* `strings`
* `xxd`

### Security Relevance

Security analysts constantly encounter data represented as bytes rather than readable text.

These concepts are useful for:

* Hexadecimal analysis
* Malware analysis
* File-format identification
* Reverse engineering
* Network packet analysis
* Binary analysis
* Digital forensics
* Hash verification

For example:

```text
4D 5A
```

corresponds to:

```text
MZ
```

which is commonly found at the beginning of Windows PE executables.

### Key Takeaway

> **Everything ultimately becomes bytes; cybersecurity professionals need to understand how those bytes represent instructions, text, files, and data structures.**

---

# 05 – Boot Process: BIOS/UEFI, Bootloader & Kernel

### Topics Covered

* Firmware
* POST
* BIOS
* UEFI
* Secure Boot
* Bootloader
* GRUB
* Windows Boot Manager
* Kernel loading
* Trusted boot chain
* Bootkits
* Rootkits

### Security Relevance

The boot process establishes the initial trust chain of a computer.

Security concepts include:

* Secure Boot
* Firmware attacks
* Bootkits
* Rootkits
* Bootloader compromise
* Persistence before the operating system starts

A compromise occurring early in the boot chain can be extremely difficult to detect because traditional security software may not yet be running.

### Key Takeaway

```text
Firmware
   ↓
POST
   ↓
Bootloader
   ↓
Kernel
   ↓
User Space
```

> **Security begins before the operating system starts.**

---

# 06 – Operating System Internals

This module focused on how the operating system controls access between applications, the CPU, memory, and hardware.

---

## 06.01 – User Mode & Kernel Mode

### Topics Covered

* User mode
* Kernel mode
* Privilege levels
* Hardware access
* Privileged operations
* User/kernel boundary

### Security Relevance

The separation between user mode and kernel mode prevents ordinary applications from directly performing privileged operations.

A kernel compromise is therefore extremely serious because the attacker may gain highly privileged control over the system.

### Key Takeaway

> **User applications operate with restricted privileges; the kernel operates with high privileges and controls critical system resources.**

---

## 06.02 – Interrupts

### Topics Covered

* Hardware interrupts
* Software interrupts
* Interrupt handlers
* CPU state
* Interrupt-driven execution

Examples:

* Keyboard input
* Network packets
* USB devices

### Security Relevance

Interrupts provide an important connection between hardware and the operating system.

Understanding them helps with:

* Kernel analysis
* Rootkit research
* EDR concepts
* Low-level malware analysis
* Hardware security

### Key Takeaway

> **Interrupts allow the CPU to respond to events without continuously polling every device.**

---

## 06.03 – System Calls

### Topics Covered

* System calls
* User/kernel transition
* `read()`
* `write()`
* `open()`
* `execve()`
* `fork()`

Basic model:

```text
Application
     ↓
System Call
     ↓
Kernel
     ↓
Hardware / OS Resource
     ↓
Kernel
     ↓
Application
```

### Security Relevance

System calls reveal what applications are actually asking the operating system to do.

Monitoring system-call behavior is therefore useful for:

* Malware analysis
* EDR
* Threat hunting
* Behavioral detection
* Incident response

### Key Takeaway

> **System calls are the controlled interface through which user-space applications request privileged operating-system services.**

---

## 06.04 – Processes, Threads & Context Switching

### Topics Covered

* Processes
* Process IDs
* Threads
* Process memory
* CPU scheduling
* Context switching
* Saved CPU state
* Scheduler overhead

### Security Relevance

Understanding processes and threads is essential for:

* Process investigation
* Malware analysis
* Incident response
* EDR
* Rootkit detection
* Performance analysis

Security analysts need to understand what normal process behavior looks like before they can identify suspicious processes.

### Key Takeaway

> **A process is a running instance of a program, while threads provide execution paths within that process; the scheduler switches CPU execution between runnable tasks.**

---

## 06.05 – Integrated OS Execution Scenario

The concepts were combined into a single execution flow:

```text
Firefox starts
      ↓
Process created
      ↓
User-mode execution
      ↓
System call
      ↓
Kernel validates request
      ↓
Hardware performs operation
      ↓
Hardware interrupt
      ↓
Kernel handles result
      ↓
Result returned to Firefox
      ↓
Scheduler performs context switch
      ↓
Another process executes
      ↓
Firefox resumes
```

### Security Relevance

This connects the major operating-system concepts into one mental model.

When investigating suspicious software, the analyst can ask:

* What process was created?
* What system calls occurred?
* What files were accessed?
* What network connections were made?
* What privileges were requested?
* What kernel interactions occurred?
* What processes were spawned?

---

# 07 – Virtualisation

The virtualization module introduced how modern systems isolate workloads and how this technology is used in cybersecurity.

---

## 07.01 – Virtualisation Fundamentals

### Topics Covered

* Virtualization
* Host OS
* Guest OS
* Hardware abstraction
* Isolation
* Resource allocation

### Security Relevance

Virtualization allows security professionals to create isolated environments for:

* Malware analysis
* Penetration testing
* Digital forensics
* Incident response
* Security laboratories

### Key Takeaway

> **Virtualization allows multiple isolated computing environments to share the same physical hardware.**

---

## 07.02 – Hypervisors

### Topics Covered

* Hypervisors
* Type 1 hypervisors
* Type 2 hypervisors
* Resource management
* Virtual hardware
* Isolation

### Architecture

```text
Type 1:

Hardware
   ↓
Hypervisor
   ↓
Virtual Machines
```

```text
Type 2:

Hardware
   ↓
Host OS
   ↓
Hypervisor
   ↓
Virtual Machines
```

### Security Relevance

Hypervisors are critical security boundaries in:

* Cloud infrastructure
* Enterprise virtualization
* Malware laboratories
* Security testing environments

### Key Takeaway

> **Type 1 hypervisors run directly on hardware, while Type 2 hypervisors run on top of a Host OS.**

---

## 07.03 – Virtual Machines

### Topics Covered

* Virtual machines
* Virtual CPU
* Virtual RAM
* Virtual storage
* Virtual network adapters
* Snapshots
* Cloning

### Security Relevance

VMs provide strong isolation for:

* Malware analysis
* Penetration testing
* Digital forensics
* Active Directory labs
* Incident response simulations

Snapshots provide rapid recovery to a known clean state.

### Key Takeaway

> **A VM virtualizes an entire computer, including its operating system and virtual hardware.**

---

## 07.04 – Containers

### Topics Covered

* Containers
* Container images
* Container engines
* Shared Host OS kernel
* Lightweight isolation
* Resource efficiency

### Architecture

```text
Host OS Kernel
      │
Container Engine
      │
 ┌────┼────┐
 ▼    ▼    ▼
App  App  App
```

### Security Relevance

Containers are heavily used in:

* Cloud computing
* DevSecOps
* CI/CD
* Microservices
* Application security
* Cloud workload security

Because containers share the Host OS kernel, kernel security and container escape vulnerabilities are important security considerations.

### Key Takeaway

> **A container packages and isolates an application while sharing the Host OS kernel.**

---

## 07.05 – Capstone: Choosing the Right Technology

The final exercise applied virtualization concepts to a malware-analysis scenario.

### Decision

For unknown or potentially malicious software:

**Virtual Machine → preferred**

because it provides:

* Stronger isolation
* Independent Guest OS
* Independent Guest kernel
* Snapshots
* Easy recovery

For application deployment:

**Container → preferred**

because it provides:

* Lightweight isolation
* Fast startup
* Efficient resource usage
* Consistent deployment
* Cloud compatibility

### Security Decision Model

```text
             Security Objective
                    │
          ┌─────────┴─────────┐
          │                   │
     High-risk /           Application
     OS-level testing       deployment
          │                   │
          ▼                   ▼
       VM                    Container
          │                   │
   Strong isolation     Lightweight isolation
   Guest OS + kernel    Shared Host kernel
```

### Key Takeaway

> **VMs and containers are not competing technologies; they provide different levels of isolation and solve different operational problems.**

---

# Cross-Module Security Mental Model

The Computer Fundamentals section can now be viewed as one connected system:

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

---

# Security Mental Model

The most important lesson from this section is that cybersecurity is not just about applications and networks.

A threat can operate at many layers:

```text
Application
     ↓
Process
     ↓
System Call
     ↓
Kernel
     ↓
Memory
     ↓
CPU
     ↓
Firmware
     ↓
Hardware
```

And on the storage side:

```text
Physical Disk
     ↓
Partition
     ↓
File System
     ↓
Files
     ↓
Metadata
     ↓
Evidence
```

Understanding these layers allows a security professional to reason about **where an attack occurs, what privileges it has, what evidence it leaves behind, and how it can be detected or investigated.**

---

# Practical Skills Developed

Throughout this section, I developed an understanding of:

* CPU architecture and instruction sets.
* CPU registers and execution.
* Memory organization.
* Stack and heap concepts.
* Virtual memory and paging.
* Physical storage and partitions.
* MBR and GPT.
* NTFS and ext4.
* Linux mounting and directory structures.
* File metadata and permissions.
* Binary and hexadecimal representation.
* File signatures and endianness.
* BIOS and UEFI.
* Bootloaders and kernel loading.
* Secure Boot and trusted boot chains.
* User/kernel privilege separation.
* Interrupts.
* System calls.
* Processes and threads.
* Context switching.
* Virtualization.
* Hypervisors.
* Virtual machines.
* Containers.

---

# Cybersecurity Applications

These fundamentals directly support future cybersecurity topics such as:

| Foundation        | Future Security Application              |
| ----------------- | ---------------------------------------- |
| CPU Architecture  | Reverse Engineering, Exploit Development |
| Memory            | Malware Analysis, Memory Forensics       |
| Storage           | Digital Forensics, Incident Response     |
| File Systems      | Forensics, Malware Persistence           |
| Number Systems    | Binary Analysis, Packet Analysis         |
| Boot Process      | Rootkits, Bootkits, Secure Boot          |
| Kernel/User Mode  | Privilege Escalation, Rootkits           |
| Interrupts        | Kernel Security, EDR                     |
| System Calls      | Malware Analysis, Behavioral Detection   |
| Processes         | SOC, EDR, Incident Response              |
| Context Switching | OS Internals, Performance Analysis       |
| Virtual Machines  | Malware Analysis, Pen Testing            |
| Containers        | Cloud Security, DevSecOps                |

---

# Final Learning Outcome

After completing the Computer Fundamentals section, I can now look at a computer from multiple security layers instead of treating the operating system as a black box.

I understand how:

```text
Hardware
   ↓
CPU + Memory + Storage
   ↓
Firmware
   ↓
Bootloader
   ↓
Kernel
   ↓
Processes
   ↓
Applications
```

work together.

I also understand how virtualization creates additional isolation layers around operating systems and applications.

This foundation will allow me to better understand **malware behavior, exploitation, privilege escalation, memory corruption, persistence, digital forensics, incident response, reverse engineering, cloud security, and defensive monitoring** in the modules that follow.

---

# Module Status

| Module                               |   Status   |
| ------------------------------------ | :--------: |
| CPU Architecture & Instruction Sets  | ✅ Complete |
| Memory: RAM, Cache & Virtual Memory  | ✅ Complete |
| Storage & File Systems               | ✅ Complete |
| Number Systems & Data Representation | ✅ Complete |
| Boot Process                         | ✅ Complete |
| Operating System Internals           | ✅ Complete |
| Virtualisation                       | ✅ Complete |
| Virtualisation Capstone              | ✅ Complete |

**Overall Status:** 🟢 Complete

---

## Detailed Write-ups

Detailed notes, exercises, and portfolio write-ups for each topic are stored in the corresponding nested folders within this directory.

```text
computer-fundamentals/
│
├── README.md
│
├── 01-cpu-architecture/
├── 02-memory/
├── 03-storage-file-systems/
├── 04-number-systems-data-representation/
├── 05-boot-process/
├── 06-operating-system-internals/
└── 07-virtualisation/
```

Each module contains its own detailed README and individual subtopic documentation.

---

# Conclusion

Computer fundamentals form the foundation for everything that follows in cybersecurity.

A security professional who understands only tools can operate a tool.

A security professional who understands **how the computer actually works** can understand what the tool is detecting, why the behavior occurs, where the evidence exists, and how an attacker is interacting with the underlying system.

This section establishes that foundation before progressing into deeper cybersecurity topics.
