# 04 – Mounting & Directory Structure

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Storage – HDD/SSD, Partitioning & File Systems

**Subtopic:** Mounting & Directory Structure

**Estimated Study Time:** 30–45 Minutes

**Skill Category:**

* Computer Fundamentals
* Linux Fundamentals
* Windows Fundamentals
* Operating Systems
* Digital Forensics Foundation

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Threat Hunter
* Security Researcher

**Prerequisites:**

* Storage Fundamentals
* Disk Partitioning
* File Systems

---

# Overview

A partition containing a file system cannot be used until the operating system makes it accessible. This process is known as **mounting**.

Once mounted, the partition becomes part of the operating system's directory structure, allowing users and applications to access files normally. Linux and Windows organize mounted storage differently, making it important to understand both approaches when working across operating systems.

---

# Why This Matters in Cybersecurity

Cybersecurity investigations often involve locating files across multiple storage devices and operating systems.

Understanding mount points and directory structures enables investigators to:

* Locate malware and persistence mechanisms.
* Analyze configuration files.
* Review system logs.
* Identify user data.
* Navigate forensic disk images efficiently.

Knowing where important files are stored significantly speeds up incident response and forensic investigations.

---

# Core Concepts

## What is Mounting?

**Mounting** is the process of connecting a partition to the operating system's directory tree so its contents can be accessed.

Before mounting:

* The partition exists.
* The file system exists.
* Files remain stored on the partition.
* The operating system cannot access them through its directory hierarchy.

After mounting:

```text id="4gt01u"
Physical Disk
      │
Partition
      │
File System
      │
Mounted
      │
Accessible Files
```

Applications can now read and write data normally.

---

## Linux Directory Structure

Linux uses a **single hierarchical directory tree** beginning at the root directory:

```text id="j0qz6x"
/
```

Common directories include:

| Directory | Purpose                    |
| --------- | -------------------------- |
| `/boot`   | Boot files                 |
| `/dev`    | Device files               |
| `/etc`    | Configuration files        |
| `/home`   | User home directories      |
| `/root`   | Root user's home directory |
| `/tmp`    | Temporary files            |
| `/usr`    | Applications and utilities |
| `/var`    | Variable data and logs     |

Every mounted partition becomes part of this unified directory tree.

---

## Windows Directory Structure

Windows organizes storage using **drive letters**.

Examples:

```text id="ajd34q"
C:\
D:\
E:\
```

Common directories include:

| Directory          | Purpose                 |
| ------------------ | ----------------------- |
| `C:\Windows`       | Operating system files  |
| `C:\Users`         | User profiles           |
| `C:\Program Files` | Installed applications  |
| `C:\ProgramData`   | Shared application data |

Each partition typically receives its own drive letter.

---

## Linux vs Windows

| Linux                               | Windows                           |
| ----------------------------------- | --------------------------------- |
| Single directory tree               | Multiple drive letters            |
| Root directory `/`                  | Drive letters (`C:\`, `D:\`)      |
| Partitions mounted into directories | Partitions assigned drive letters |

Although both systems organize files differently, the goal is the same: provide a structured way to access stored data.

---

# Hands-on Lab

## Linux

Display mounted file systems:

```bash id="twx2zv"
findmnt
```

or

```bash id="sfr4mg"
mount
```

List the root directory:

```bash id="cb3l3w"
ls /
```

Display the current working directory:

```bash id="k8tb0d"
pwd
```

---

## Windows

Open:

* File Explorer
* Disk Management

Observe:

* Drive letters
* Mounted volumes
* Windows system directories
* User directories

---

# Real-World Security Example

During a Linux incident response investigation, an analyst discovers suspicious activity originating from `/tmp`, where malware temporarily stores downloaded payloads before execution.

Later, the analyst examines `/var/log` to reconstruct the attack timeline and reviews `/etc` to identify unauthorized configuration changes used for persistence.

On a Windows system, evidence is recovered from `C:\Users`, while malicious binaries are located in `C:\ProgramData`.

Understanding the directory structure enables investigators to quickly locate evidence and determine how an attacker interacted with the operating system.

---

# Key Learnings

After completing this topic, I understand:

* The purpose of mounting.
* Why partitions must be mounted before use.
* How Linux organizes files using a unified directory tree.
* How Windows organizes storage using drive letters.
* Common directories examined during cybersecurity investigations.

---

# Learning Outcome

After completing this topic, I can:

* Explain the mounting process.
* Navigate Linux and Windows directory structures.
* Identify important investigation locations.
* Differentiate Linux mount points from Windows drive letters.
* Apply directory knowledge during malware analysis and digital forensics.

---

# Portfolio Reflection

Before studying mounting, I assumed that files became immediately available once they were stored on a disk. I now understand that a partition must first be mounted before its contents become accessible to the operating system.

I also learned that Linux and Windows organize storage differently. Linux integrates mounted partitions into a single directory hierarchy, while Windows assigns drive letters to each partition. Recognizing these structures helps me efficiently locate logs, configuration files, user data, and malware artifacts during incident response and forensic investigations.

---

## Next Step

**05 – File System Metadata**

The next topic explores how file systems store metadata such as timestamps, permissions, ownership, and links, providing essential knowledge for malware analysis and digital forensics.
