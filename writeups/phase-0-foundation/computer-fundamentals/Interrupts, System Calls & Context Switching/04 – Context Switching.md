# 04 – Context Switching

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Interrupts, System Calls & Context Switching

**Subtopic:** Context Switching

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

Modern operating systems allow multiple applications to appear as though they are running simultaneously, even when a CPU core can execute only one task at a time. This is achieved through **context switching**, a process in which the operating system rapidly saves the execution state of one task and restores the state of another.

Context switching enables multitasking, allowing web browsers, terminals, background services, security software, and other applications to share CPU time efficiently while maintaining the illusion of parallel execution.

Understanding context switching is fundamental for learning process scheduling, performance analysis, malware behavior, and operating system internals.

---

# Why This Matters in Cybersecurity

Every program executed on a system—including legitimate applications, security software, and malware—runs as one or more processes scheduled by the operating system.

Security analysts routinely investigate running processes, analyze process trees, monitor CPU usage, and identify suspicious process creation during incident response.

Understanding how the operating system schedules and switches between processes helps explain application behavior, malware execution, and system performance during investigations.

---

# Core Concepts

## What is a Process?

A **process** is a running instance of a program.

Each process has its own:

* Process ID (PID)
* Virtual memory space
* Execution state
* System resources

Examples:

* Firefox
* Terminal
* Visual Studio Code
* Malware sample

Launching the same program multiple times creates multiple independent processes.

---

## What is a Thread?

A **thread** is the smallest unit of execution within a process.

Unlike processes, multiple threads share the same process memory and resources while executing independently.

For example, a web browser may use separate threads for:

* User interface
* Web page rendering
* File downloads
* Audio or video playback

Using multiple threads improves responsiveness while allowing related tasks to execute concurrently.

---

## What is Context Switching?

A **context switch** occurs when the operating system saves the execution state of the currently running task and restores the saved state of another task so it can continue execution.

The saved context typically includes:

* CPU registers
* Program Counter (Instruction Pointer)
* Stack Pointer
* CPU flags

By restoring this information later, the operating system allows a process to continue from exactly where it previously stopped.

---

## Context Switching Flow

The operating system performs the following sequence:

```text id="mg8p4i"
Process A Running
        │
        ▼
CPU Saves Execution State
        │
        ▼
Scheduler Selects Process B
        │
        ▼
CPU Restores Process B State
        │
        ▼
Process B Running
        │
        ▼
Later...
        │
        ▼
Process A Resumes
```

This process occurs thousands of times every second, enabling smooth multitasking.

---

## Why Context Switching Exists

Since a CPU core can actively execute only one task at a time, the operating system rapidly alternates between runnable processes.

Context switching allows:

* Multiple applications to run simultaneously.
* Background services to continue operating.
* User interaction without noticeable delays.
* Security software to monitor system activity.
* Efficient sharing of CPU resources.

Without context switching, only one application could execute on a CPU core until it completed.

---

## Performance Impact

Although context switching is essential, it introduces processing overhead.

Each switch requires the operating system to:

* Save the current execution state.
* Load another execution state.
* Execute scheduler logic.

Excessive context switching increases CPU overhead and can reduce overall system performance.

Operating systems therefore balance responsiveness with efficient CPU utilization.

---

# Hands-on Lab

## Linux

Display running processes:

```bash id="5n8pqx"
ps aux
```

Monitor processes in real time:

```bash id="7gvwfy"
top
```

Observe:

* Process IDs (PIDs)
* CPU utilization
* Multiple active processes

Notice that numerous processes share CPU time even on systems with a limited number of CPU cores.

---

## Windows

Open **Task Manager**.

Observe:

* Running processes
* CPU utilization
* Process Details

Notice that many applications remain active simultaneously because the operating system rapidly performs context switches between runnable tasks.

---

# Real-World Security Example

A user opens a web browser while an Endpoint Detection and Response (EDR) agent scans files in the background and an email client synchronizes messages.

Although the CPU executes only one task at a time on each core, the operating system rapidly switches between these processes, allowing all applications to remain responsive.

During a malware investigation, analysts may observe a malicious process creating additional processes while the scheduler continuously switches execution among legitimate applications, security tools, and the malware itself.

Understanding context switching helps explain why process activity appears concurrent and why monitoring process creation and execution is critical during incident response.

---

# Key Learnings

After completing this topic, I understand:

* What a process is.
* What a thread is.
* The purpose of context switching.
* How the operating system performs context switching.
* Why context switching enables multitasking.
* Why excessive context switching can reduce performance.

---

# Learning Outcome

After completing this topic, I can:

* Differentiate processes and threads.
* Explain how context switching works.
* Describe why context switching is necessary for multitasking.
* Explain the performance impact of excessive context switching.
* Relate process scheduling to malware analysis, incident response, and operating system behavior.

---

# Portfolio Reflection

Before learning about context switching, I knew that multiple applications could run at the same time but did not understand how a CPU with limited execution capability managed so many tasks. I now understand that the operating system rapidly saves and restores the execution state of processes, allowing the CPU to alternate between runnable tasks and create the appearance of simultaneous execution.

I also learned the difference between processes and threads, and how the scheduler coordinates CPU time among them. From a cybersecurity perspective, I recognize that malware, security software, and legitimate applications all compete for CPU resources through the same scheduling mechanism. Understanding context switching provides a strong foundation for analyzing process behavior, investigating suspicious activity, and interpreting system performance during incident response.
