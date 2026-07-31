# 03 – System Calls

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Interrupts, System Calls & Context Switching

**Subtopic:** System Calls

**Estimated Study Time:** 30–45 Minutes

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* OS Internals
* Linux Fundamentals
* Cybersecurity Foundations

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Threat Hunter
* Reverse Engineer
* Security Researcher

---

# Overview

A **system call** is the controlled mechanism through which a **User Mode** application requests privileged services from the **Kernel**. Since applications cannot directly access hardware or execute privileged CPU instructions, they rely on system calls whenever they need the operating system to perform protected operations.

Everyday actions such as opening a file, reading data, writing to storage, creating a process, or establishing a network connection all involve one or more system calls. They form the primary communication channel between applications and the operating system.

Understanding system calls is fundamental for operating system internals, malware analysis, behavioral detection, incident response, and reverse engineering.

---

# Why This Matters in Cybersecurity

System calls reveal what a program is actually doing rather than what it claims to do.

Malware often disguises itself with legitimate filenames or processes, but its interaction with the operating system can expose its true behavior.

Security tools such as Endpoint Detection and Response (EDR), sandboxes, and behavioral analysis platforms monitor system call activity to identify suspicious actions including unauthorized file access, process creation, privilege escalation attempts, and network communication.

---

# Core Concepts

## What is a System Call?

A **system call** is a controlled request made by a User Mode application to the operating system kernel for a service that requires privileged access.

Rather than directly accessing hardware, applications ask the kernel to perform the operation on their behalf.

Examples include:

* Opening a file.
* Reading data.
* Writing data.
* Creating a process.
* Executing a program.
* Establishing a network connection.

The kernel validates the request, checks permissions, performs the operation if permitted, and returns the result to the application.

---

## Why Do System Calls Exist?

Applications execute in **User Mode**, where they have restricted privileges.

Without system calls, applications could directly manipulate hardware, access protected memory, or interfere with other processes, threatening the stability and security of the operating system.

System calls enforce controlled access by ensuring that every privileged operation passes through the kernel.

This design protects both the operating system and running applications.

---

## System Call Flow

Every privileged request follows a controlled execution path.

```text id="h44hyl"
Application
(User Mode)
        │
        ▼
System Call
        │
        ▼
Kernel
(Kernel Mode)
        │
        ▼
Hardware
        │
        ▼
Kernel
        │
        ▼
Application
```

The kernel acts as the trusted intermediary between applications and hardware, ensuring that all requests are validated before execution.

---

## Common Linux System Calls

Although Linux provides hundreds of system calls, a small number are frequently encountered during everyday system activity and malware analysis.

| System Call | Purpose                          |
| ----------- | -------------------------------- |
| `open()`    | Opens a file                     |
| `read()`    | Reads data from a file or device |
| `write()`   | Writes data to a file or device  |
| `fork()`    | Creates a new process            |
| `execve()`  | Executes a program               |

Examples:

* Opening `/etc/passwd` → `open()`
* Reading a log file → `read()`
* Saving a document → `write()`
* Launching a new application → `fork()` followed by `execve()`

---

## System Calls in Security Monitoring

System calls expose the real behavior of an application.

For example, a malicious program disguised as a PDF reader may repeatedly execute system calls that:

* Read sensitive files.
* Create hidden processes.
* Modify system configurations.
* Write malicious files.
* Connect to external servers.

Because these operations cannot occur without interacting with the kernel, monitoring system calls provides security analysts with valuable insight into application behavior.

---

# Hands-on Lab

## Linux

Trace system calls made by a command:

```bash id="djp5c3"
strace ls
```

Trace a file read operation:

```bash id="d7pj3j"
strace cat /etc/hostname
```

Observe common system calls such as:

* `open()`
* `read()`
* `write()`
* `close()`

Focus on identifying the names and purposes of these calls rather than understanding every line of output.

---

## Windows

Using **Process Monitor (Procmon)** from Microsoft Sysinternals, observe operations such as:

* CreateFile
* ReadFile
* WriteFile
* CreateProcess

These operations eventually invoke Windows system calls handled by the operating system kernel.

---

# Real-World Security Example

An attacker distributes malware disguised as a legitimate document viewer.

Although the application appears harmless, behavioral analysis reveals repeated system calls to open sensitive system files, create new processes, write executable files to temporary directories, and establish outbound network connections.

These system call patterns expose the malware's true behavior, allowing security analysts and EDR platforms to detect malicious activity even when filenames, icons, or process names appear legitimate.

This demonstrates why behavioral monitoring is often more effective than relying solely on signatures.

---

# Key Learnings

After completing this topic, I understand:

* What a system call is.
* Why applications require system calls.
* Why User Mode applications cannot directly access hardware.
* The controlled relationship between applications, the kernel, and hardware.
* Common Linux system calls.
* Why system call monitoring is valuable in cybersecurity.

---

# Learning Outcome

After completing this topic, I can:

* Explain the purpose of system calls.
* Describe how User Mode applications communicate with the kernel.
* Identify common Linux system calls and their functions.
* Explain the complete system call execution flow.
* Relate system call behavior to malware analysis, EDR detection, and incident response.

---

# Portfolio Reflection

Before learning about system calls, I understood that applications could not directly access hardware, but I did not know how they communicated with the operating system. I now understand that every privileged operation is performed through a controlled request known as a system call. The kernel validates these requests, enforces permissions, interacts with hardware when appropriate, and returns the result to the requesting application.

From a cybersecurity perspective, I learned that system calls reveal the true behavior of a program. Regardless of its filename or appearance, malware must eventually request services from the operating system. Monitoring system calls allows security professionals to identify suspicious actions such as unauthorized file access, process creation, and network communication, making behavioral analysis a powerful detection technique.
