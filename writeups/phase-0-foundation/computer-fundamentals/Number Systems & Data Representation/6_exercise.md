
# Exercise — Analyzing an Unknown File

**Job-Role Tag:** SOC Analyst / DFIR Analyst / Malware Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Number Systems & Data Representation

**Date:** 2026-07-09

---

# Objective

Apply the concepts of binary, hexadecimal, ASCII, Unicode, endianness, and file signatures to build a safe, repeatable workflow for triaging an unknown file before execution.

---

# Why This Matters

In a real Security Operations Center (SOC) or Digital Forensics and Incident Response (DFIR) investigation, analysts are frequently asked to inspect suspicious files from email attachments, downloads, USB devices, or compromised hosts.

The goal is **not** to execute the file immediately.

Instead, the goal is to answer one question:

> **"What can I learn from this file without trusting or executing it?"**

This mindset reduces risk and provides valuable intelligence before moving to deeper analysis.

---

# Skills Combined

This lab brought together the following concepts:

* Binary is the computer's native representation.
* Hexadecimal provides a compact, human-readable view of binary.
* ASCII and Unicode allow printable bytes to be interpreted as text.
* Endianness determines how multi-byte values are interpreted by the CPU.
* File signatures identify the true file format regardless of its filename.
* Cryptographic hashes uniquely identify file contents.
* Static analysis gathers information without executing the sample.

---

# Investigation Scenario

A user reports an attachment named:

```text
invoice.pdf
```

The filename appears legitimate, but filenames can be changed easily.

Rather than trusting the extension, the investigation begins by examining the file itself.

---

# Hands-on Workflow

## Step 1 — Verify the File Type

```bash
file invoice.pdf
```

Purpose:

Determine the file type based on its contents rather than its filename.

---

## Step 2 — Inspect the File Header

```bash
xxd -l 16 invoice.pdf
```

Observed example:

```text
00000000: 4d5a 9000 ...
```

The bytes `4D 5A` correspond to the `MZ` signature, indicating a Windows Portable Executable (PE).

The filename suggests a PDF document, but the file header reveals an executable.

---

## Step 3 — Calculate the File Hash

```bash
sha256sum invoice.pdf
```

Purpose:

Generate a unique fingerprint of the file for:

* threat intelligence,
* reputation checks,
* IOC correlation,
* integrity verification.

---

## Step 4 — Check Reputation

The calculated SHA-256 hash can be compared against:

* organizational IOC databases,
* malware repositories,
* threat intelligence platforms,
* incident response records.

If the hash is unknown, further analysis is required.

---

## Step 5 — Extract Printable Strings

```bash
strings invoice.pdf
```

Purpose:

Safely extract readable text such as:

* URLs,
* domain names,
* registry paths,
* Windows API names,
* file paths,
* PowerShell commands.

This provides valuable context without executing the sample.

---

## Step 6 — Dynamic Analysis

Only after completing the previous steps should the file be transferred to an isolated sandbox or virtual machine for behavioral analysis.

During execution, monitor:

* process creation,
* file system activity,
* registry modifications,
* network connections,
* persistence mechanisms,
* child processes.

---

# Investigation Workflow

```text
Unknown File
      │
      ▼
Verify with file
      │
      ▼
Inspect header using xxd
      │
      ▼
Identify file signature
      │
      ▼
Generate SHA-256 hash
      │
      ▼
Check reputation
      │
      ▼
Extract printable strings
      │
      ▼
Sandbox analysis
      │
      ▼
Correlate findings
      │
      ▼
Assessment
```

This workflow minimizes risk while maximizing the information gathered during the initial triage.

---

# Real Incident

## NotPetya (2017)

Incident responders investigating NotPetya relied heavily on static analysis techniques before executing samples.

By examining:

* executable headers,
* hexadecimal data,
* printable strings,
* hashes,

they rapidly identified malicious artifacts and correlated them with known indicators before conducting dynamic analysis.

**Security Takeaway**

Effective incident response begins by trusting observable evidence within the file—not its filename or user-provided description.

---

# My Learning Journey

At the beginning of this topic, I viewed binary, hexadecimal, ASCII, endianness, and file signatures as separate concepts.

Through hands-on exercises, I learned that they are different perspectives of the same underlying data.

The most important realization was that cybersecurity investigations begin with **bytes**, not assumptions.

---

# What I Got Wrong First

## Initial Misconceptions

* I associated hexadecimal directly with machine instructions.
* I believed little-endian physically reversed bytes.
* I trusted filenames more than file signatures.

---

## Correct Understanding

* Hexadecimal is simply a representation of binary.
* Endianness affects CPU interpretation, not byte storage.
* File signatures reveal the true file format.
* Hashes change whenever any byte changes, including invisible characters.
* Static analysis should precede execution whenever possible.

---

# Core Takeaway

Every cybersecurity investigation begins with evidence.

Evidence starts with bytes.

By understanding how bytes are represented, interpreted, and verified, I can safely determine what a file really is before deciding how to investigate it further.

This mindset is applicable across malware analysis, reverse engineering, digital forensics, incident response, and threat hunting.

---

# Interview Practice

## Question

A user reports that an attachment named `invoice.pdf` triggered an antivirus alert. Explain how you would safely investigate the file before executing it.

---

## My Answer

I would first verify the file type using the `file` command instead of trusting the filename. Next, I would inspect the first few bytes with `xxd` to identify the file signature. I would calculate the SHA-256 hash and compare it with VirusTotal and the organization's internal IOC database. Then, I would extract printable strings using the `strings` command to identify URLs, domains, API names, or suspicious commands. Finally, I would transfer the sample to an isolated sandbox to observe its behavior, including process creation, file modifications, registry changes, persistence mechanisms, and network activity.

---

## Feedback

### Strengths

* Followed a structured investigation process.
* Prioritized static analysis before execution.
* Correctly distinguished filenames from file signatures.
* Demonstrated awareness of threat intelligence and reputation checks.
* Applied multiple foundational concepts in a coherent workflow.

### Improvement

During interviews, explicitly explain **why** each tool is used. Interviewers often evaluate your reasoning more than your memorization of commands.

---

# Skills Demonstrated

* Binary and hexadecimal interpretation
* Reading hex dumps
* Character encoding awareness
* Endianness reasoning
* File signature identification
* SHA-256 integrity verification
* Static malware triage
* Safe investigation workflow
* Incident response thinking

---

# Commands Used Throughout This Module

```bash
printf

xxd

hexdump -C

file

strings

sha256sum
```

---

# Related Resources

* Practical Malware Analysis — Michael Sikorski & Andrew Honig
* Practical Binary Analysis — Dennis Andriesse
* Intel® 64 and IA-32 Architectures Software Developer's Manual
* GNU Coreutils (`sha256sum`)
* `man file`
* `man strings`
* `man xxd`

---

# Module Summary

This module established the foundational skills required for every future cybersecurity discipline. Rather than treating binary, hexadecimal, ASCII, endianness, and file signatures as isolated topics, I learned to combine them into a structured investigation workflow. This foundation prepares me for subsequent topics such as memory analysis, operating systems, reverse engineering, malware analysis, exploit development, and digital forensics, where every investigation begins by understanding the underlying bytes.
