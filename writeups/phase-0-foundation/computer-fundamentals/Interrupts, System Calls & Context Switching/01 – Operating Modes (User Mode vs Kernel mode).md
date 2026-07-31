# 01 – Operating Modes (User Mode vs Kernel Mode)

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Interrupts, System Calls & Context Switching

**Subtopic:** Operating Modes (User Mode vs Kernel Mode)

**Estimated Study Time:** 30–45 Minutes

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* OS Internals
* Cybersecurity Foundations

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Threat Hunter
* Security Researcher
* Reverse Engineer

---

# Overview

Modern operating systems separate program execution into **User Mode** and **Kernel Mode** to ensure system stability and security. This separation prevents ordinary applications from directly accessing hardware or executing privileged operations that could compromise the operating system.

Applications such as web browsers, text editors, and terminals execute in **User Mode**, while the operating system kernel executes in **Kernel Mode** with unrestricted access to hardware resources.

Understanding this privilege separation is fundamental to learning system calls, interrupts, process scheduling, malware analysis, and operating system security.

---

# Why This Matters in Cybersecurity

Privilege separation is one of the most important security mechanisms in modern operating systems.

By restricting applications to User Mode, the operating system prevents software bugs and malicious programs from directly manipulating hardware or interfering with other processes.

Many security products—including antivirus software, Endpoint Detection and Response (EDR) solutions, and sandboxing technologies—depend on this boundary to monitor and control application behavior.

Kernel-level compromises, however, can bypass many of these protections, making them significantly more dangerous.

---

# Core Concepts

## Why Operating Modes Exist

Imagine if every application could directly:

* Read or modify physical memory.
* Execute privileged CPU instructions.
* Disable storage devices.
* Shut down the processor.
* Read another application's memory.

A single programming error—or malicious application—could crash or compromise the entire operating system.

To prevent this, modern operating systems divide execution into two privilege levels:

* User Mode
* Kernel Mode

This separation provides stability, isolation, and security.

---

## User Mode

**User Mode** is the restricted execution environment where ordinary applications run.

Examples include:

* Web browsers
* Terminal applications
* Visual Studio Code
* Microsoft Word
* Media players
* Calculator

Applications running in User Mode:

* Can access only their allocated memory.
* Can request operating system services.
* Cannot directly access hardware.
* Cannot execute privileged CPU instructions.
* Cannot read kernel memory.

If an application crashes while running in User Mode, the operating system typically continues running without affecting other applications.

---

## Kernel Mode

**Kernel Mode** is the privileged execution environment where the operating system kernel executes.

The kernel has unrestricted access to:

* CPU
* RAM
* Storage devices
* Network interfaces
* Device drivers
* Process scheduling
* File systems

Because the kernel controls every hardware resource, software executing in Kernel Mode has complete authority over the system.

---

## Relationship Between User Mode and Kernel Mode

Applications do not communicate directly with hardware.

Instead, every hardware request passes through the operating system kernel.

```text id="6s8yfa"
Application (User Mode)
          │
          ▼
System Call
          │
          ▼
Kernel (Kernel Mode)
          │
          ▼
Hardware
```

This controlled boundary allows the operating system to validate requests, enforce permissions, and safely manage hardware resources.

---

# Hands-on Lab

## Linux

Display the current shell process:

```bash id="0v1eun"
ps -p $$
```

Display the running kernel version:

```bash id="1mlqtk"
uname -r
```

Observe that:

* Your shell executes in **User Mode**.
* The Linux kernel manages the operating system in **Kernel Mode**.

---

## Windows

Open **Task Manager**.

Observe:

* User applications such as Notepad, Chrome, or Microsoft Edge.

Open **System Information (`msinfo32`)**.

Review kernel-related operating system information.

---

# Real-World Security Example

A malicious PDF document exploits a vulnerability in a document reader.

Initially, the malware executes in **User Mode**, where its capabilities are restricted by the operating system. It cannot directly modify kernel memory or control hardware.

The attacker then exploits a vulnerable kernel driver to obtain **Kernel Mode** privileges. With unrestricted access, the malware disables security software, hides malicious processes, manipulates system memory, and establishes persistence.

This illustrates why defenders prioritize patching kernel vulnerabilities and why attackers actively seek privilege escalation exploits.

---

# Key Learnings

After completing this topic, I understand:

* Why modern operating systems separate User Mode and Kernel Mode.
* The responsibilities of User Mode.
* The responsibilities of Kernel Mode.
* Why applications cannot directly access hardware.
* How the kernel acts as a controlled interface between applications and hardware.
* Why Kernel Mode compromises are significantly more dangerous than User Mode compromises.

---

# Learning Outcome

After completing this topic, I can:

* Explain the purpose of User Mode and Kernel Mode.
* Differentiate the privileges of each execution mode.
* Describe why operating systems isolate applications from hardware.
* Explain the kernel's role as an intermediary between applications and hardware.
* Relate privilege separation to malware analysis, exploit development, and incident response.

---

# Portfolio Reflection

Before studying operating modes, I understood that the operating system managed hardware but did not fully appreciate how it protected itself from applications. I now understand that modern operating systems isolate applications in **User Mode**, preventing them from directly accessing hardware or executing privileged operations. Every request for hardware access must pass through the kernel, which validates permissions and safely manages system resources.

I also learned why **Kernel Mode** is one of the most security-critical components of an operating system. Because the kernel has unrestricted access to hardware and memory, compromising it allows attackers to bypass security controls, manipulate system resources, and gain complete control of the system. This concept provides the foundation for understanding system calls, interrupts, privilege escalation, and kernel-level malware.
