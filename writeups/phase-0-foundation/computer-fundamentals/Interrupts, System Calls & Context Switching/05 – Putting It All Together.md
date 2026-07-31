# 05 – Putting It All Together

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Interrupts, System Calls & Context Switching

**Subtopic:** Putting It All Together

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
* Reverse Engineer
* Security Researcher

---

# Overview

Modern operating systems rely on multiple mechanisms that work together to execute applications securely and efficiently. A running application cannot directly access hardware, communicate with storage devices, or control CPU execution. Instead, the operating system coordinates every interaction through the kernel.

This topic combines the concepts of **User Mode**, **Kernel Mode**, **System Calls**, **Interrupts**, and **Context Switching** into one complete execution flow. Understanding how these components interact provides the foundation for operating system internals, malware analysis, digital forensics, and incident response.

---

# Why This Matters in Cybersecurity

Every application—whether legitimate software or malware—follows the same operating system execution model.

Applications execute in User Mode, request privileged services through system calls, receive hardware responses via interrupts, and share CPU time through context switching.

Security professionals monitor these interactions to understand application behavior, detect malicious activity, investigate incidents, and analyze malware execution.

---

# Complete Operating System Execution Flow

Consider the example of launching **Firefox**.

The operating system performs the following sequence:

---

## Step 1 – Program Execution

The Firefox executable is stored on the storage device.

When the user launches Firefox, the operating system:

* Loads the executable into RAM.
* Creates a new process.
* Assigns a Process ID (PID).
* Creates the initial thread.
* Allocates virtual memory.

Firefox begins executing in **User Mode**.

---

## Step 2 – Requesting Operating System Services

Firefox needs to read:

* Configuration files.
* User profiles.
* Browser preferences.
* Cookies.

Since User Mode applications cannot directly access storage devices, Firefox performs a **system call** requesting the kernel to read the required files.

The kernel validates the request before interacting with hardware.

---

## Step 3 – Kernel Performs the Operation

The CPU switches from **User Mode** to **Kernel Mode**.

The operating system kernel:

* Verifies permissions.
* Locates the requested file.
* Communicates with the storage device.
* Initiates the read operation.

The application itself never directly communicates with hardware.

---

## Step 4 – Hardware Responds

After the storage device finishes reading the requested data, it generates a **hardware interrupt**.

The interrupt notifies the CPU that the requested operation has completed.

Instead of continuously checking the storage device (polling), the CPU responds only when notified, improving system efficiency.

---

## Step 5 – Interrupt Handling

When the interrupt occurs, the CPU:

1. Pauses the current execution.
2. Saves the current execution state.
3. Executes the interrupt handler.
4. Receives the completed data.
5. Restores the saved execution state.

The kernel now has the requested information.

---

## Step 6 – Returning to the Application

The kernel returns the requested data to Firefox.

Execution transitions back to **User Mode**.

Firefox continues loading using the data returned by the operating system.

---

## Step 7 – Context Switching

While Firefox continues executing, numerous other processes also require CPU time.

Examples include:

* Terminal
* Endpoint Detection and Response (EDR)
* Network services
* Background system processes

The scheduler performs a **context switch** by:

* Saving Firefox's execution state.
* Selecting another runnable process.
* Restoring that process's saved execution state.
* Resuming execution.

Later, Firefox resumes exactly where it previously stopped.

---

# Integrated Execution Flow

```text id="ywn98q"
User Opens Firefox
        │
        ▼
Process Created
        │
        ▼
Runs in User Mode
        │
        ▼
Requests File Access
        │
        ▼
System Call
        │
        ▼
Kernel Mode
        │
        ▼
Storage Device Reads File
        │
        ▼
Hardware Interrupt
        │
        ▼
Kernel Handles Interrupt
        │
        ▼
Return Data to Firefox
        │
        ▼
Return to User Mode
        │
        ▼
Scheduler Performs Context Switch
        │
        ▼
Another Process Executes
        │
        ▼
Firefox Resumes
```

This execution chain represents how modern operating systems coordinate applications, hardware, and CPU resources.

---

# Cybersecurity Perspective

Every application follows this execution model, including malware.

A malicious program:

* Executes as a process.
* Runs in User Mode.
* Requests operating system services through system calls.
* Reads or writes files.
* Opens network connections.
* Receives hardware events through interrupts.
* Shares CPU time through context switching.

The operating system mechanisms remain identical; only the application's behavior differs.

Because of this, security tools monitor:

* Process creation.
* System calls.
* File access.
* Network communication.
* Process scheduling.
* Context switching behavior.

Behavioral analysis provides defenders with visibility into what software is actually doing rather than relying solely on filenames or signatures.

---

# Hands-on Lab

## Linux

Launch multiple applications:

```bash id="a4l8ez"
firefox &
```

```bash id="kq2a7g"
top
```

Observe:

* Running processes.
* CPU utilization.
* Multiple active applications.

Use:

```bash id="4sdjlwm"
strace firefox
```

Observe system calls while Firefox executes.

---

## Windows

Open:

* Task Manager
* Resource Monitor
* Process Monitor (Procmon)

Observe:

* Process creation.
* File access.
* CPU activity.
* System operations generated by launching an application.

---

# Key Learnings

After completing this topic, I understand:

* How an application starts executing.
* How User Mode applications communicate with the kernel.
* How system calls provide controlled access to operating system services.
* How hardware interrupts notify the CPU.
* How context switching enables multitasking.
* How all operating system components work together during application execution.

---

# Learning Outcome

After completing this topic, I can:

* Explain the complete execution lifecycle of an application.
* Connect User Mode, Kernel Mode, System Calls, Interrupts, and Context Switching into one execution flow.
* Describe how the operating system coordinates communication between applications and hardware.
* Relate operating system execution flow to malware analysis, incident response, and security monitoring.

---

# Portfolio Reflection

Before completing this module, I understood User Mode, Kernel Mode, interrupts, system calls, and context switching as separate operating system concepts. I now understand how these mechanisms work together to execute every application on a modern operating system.

I can explain the complete execution lifecycle of a program—from process creation, system calls, and kernel interaction to hardware interrupts and context switching. I also recognize that both legitimate applications and malware follow the same operating system mechanisms, with the key difference being their behavior. This integrated understanding provides a strong foundation for malware analysis, digital forensics, reverse engineering, and incident response.
