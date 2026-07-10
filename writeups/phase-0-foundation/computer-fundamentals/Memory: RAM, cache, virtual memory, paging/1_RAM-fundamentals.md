
# RAM Fundamentals

**Job-Role Tag:** DFIR Analyst / Malware Analyst / Reverse Engineer

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Memory

**Date:** 2026-07-10

---

# Objective

Understand the purpose of Random Access Memory (RAM), how it differs from permanent storage, why the CPU executes programs from RAM instead of directly from disk, and why RAM is one of the most valuable sources of evidence during a cybersecurity investigation.

---

# Why This Matters

Every program you execute—including browsers, malware, debuggers, and forensic tools—must be loaded into RAM before the CPU can execute it.

Unlike storage devices such as SSDs or HDDs, RAM provides fast, temporary working space for running programs. Because it contains the live state of the system, RAM often holds evidence that never exists on disk, making it a primary target during digital forensic and incident response (DFIR) investigations.

Understanding RAM is the foundation for later topics including CPU caches, stack and heap memory, virtual memory, reverse engineering, malware analysis, and exploit development.

---

# Key Concepts

## What is RAM?

RAM (Random Access Memory) is the computer's temporary working memory.

Programs stored permanently on an SSD or HDD must first be loaded into RAM before the CPU can execute their instructions.

RAM is:

* Fast
* Volatile (contents are lost when power is removed)
* Readable and writable
* Shared by all running processes

---

## Storage vs RAM

A useful mental model is:

```text id="t3yq8f"
SSD/HDD = Filing Cabinet (Permanent Storage)

RAM = Office Desk (Workspace)

CPU = Employee (Executes Instructions)
```

The CPU cannot efficiently work directly from the filing cabinet. Instead, the operating system places the required documents (program code and data) onto the desk (RAM), where the CPU can access them quickly.

---

## Why the CPU Uses RAM

The CPU executes instructions only after they have been loaded into RAM.

During execution:

* Program code resides in RAM.
* Active data resides in RAM.
* Running processes continuously read from and write to RAM.

If the CPU had to read every instruction directly from an SSD, execution would be significantly slower because storage devices have much higher access latency than RAM.

---

## Volatile Memory

RAM is volatile memory.

When power is removed:

* Running programs stop.
* Unsaved work is lost.
* Memory contents disappear.

This volatility makes RAM one of the first acquisition targets during live incident response.

---

# Hands-on Lab

## Commands Used

Display memory usage:

```bash id="c5s9z2"
free -h
```

View detailed memory information:

```bash id="4xjv1d"
cat /proc/meminfo | head -10
```

Identify the processes consuming the most memory:

```bash id="v6n2er"
ps aux --sort=-%mem | head
```

---

## Observed Output

Example observations from the lab:

```text id="6a9lq7"
Total RAM: 3.8 GB
```

```text id="n8h3wd"
Top Memory Consumer:
Firefox (PID 4853)
```

This demonstrates that active applications occupy RAM while they are executing.

---

# Real Incident

## Cold Boot Attack (2008)

Researchers demonstrated that RAM contents do not disappear immediately after power loss. By rapidly rebooting a system—or cooling memory modules to slow data decay—they were able to recover sensitive information, including disk encryption keys, from RAM.

### Attack

An attacker with physical access could recover secrets believed to be lost after shutdown.

### Defense

Modern systems reduce this risk through:

* Full disk encryption with secure key handling
* Memory encryption (where supported)
* Secure shutdown procedures
* Restricting physical access to systems

---

# My Learning Journey

Initially, I understood that programs are stored on the SSD and later loaded into RAM for execution.

During the lab, I refined this understanding by recognizing that the CPU executes instructions only after the operating system has loaded the required code and data into RAM. I also learned that if some memory pages are moved to swap due to memory pressure, the operating system transparently reloads them into RAM before execution continues.

This clarified why RAM serves as the CPU's active workspace rather than permanent storage.

---

# What I Got Wrong First

## Initial Misconception

I initially thought that if RAM became full, the entire running process would simply be stored on the SSD.

## Correct Understanding

When RAM is under pressure, the operating system may move **individual memory pages** to swap space rather than moving the entire process.

When the CPU later needs one of those pages, a **page fault** occurs, and the operating system reloads the required page into RAM before execution resumes.

---

# Core Takeaway

RAM is the computer's temporary workspace where active program code and data reside. The CPU executes instructions from RAM—not directly from storage. Because RAM contains the live state of running processes, it often holds valuable forensic evidence such as active code, decrypted data, credentials, and encryption keys.

---

# Interview Practice

## Question

Why can't the CPU execute a program directly from an SSD?

---

## My Answer

The CPU can execute a program only after its instructions and required data have been loaded into RAM. If some memory pages have been swapped to disk due to low RAM, the operating system brings those pages back into RAM before the CPU accesses them.

---

## Feedback

### Strengths

* Correctly distinguished storage from RAM.
* Understood the operating system's role in loading programs.
* Recognized that swapped pages must return to RAM before execution.

### Improvement

Emphasize that the CPU executes instructions from RAM because RAM provides much lower latency than permanent storage.

---

# Skills Demonstrated

* Understanding the role of RAM
* Distinguishing RAM from permanent storage
* Reading Linux memory information
* Identifying memory-intensive processes
* Explaining why RAM is required for execution
* Connecting RAM concepts to digital forensics

---

# Commands Used

```bash id="k4q8nt"
free -h

cat /proc/meminfo | head -10

ps aux --sort=-%mem | head
```

---

# Related Resources

* Linux `proc` Filesystem Documentation (`/proc/meminfo`)
* *Practical Malware Analysis* — Michael Sikorski & Andrew Honig
* *The Art of Memory Forensics* — Michael Hale Ligh et al.
* Cold Boot Attack research paper (Halderman et al., 2008)

---

# Summary

RAM is the primary workspace of every running computer system. Before a program can execute, the operating system loads its code and required data from permanent storage into RAM, where the CPU can access them efficiently. Because RAM captures the live execution state of the system, it is one of the most valuable sources of evidence during malware analysis, incident response, and digital forensic investigations.
