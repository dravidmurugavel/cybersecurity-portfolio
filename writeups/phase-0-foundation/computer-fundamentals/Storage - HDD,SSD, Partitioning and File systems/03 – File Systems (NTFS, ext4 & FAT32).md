# 03 – File Systems (NTFS, ext4 & FAT)

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Storage – HDD/SSD, Partitioning & File Systems

**Subtopic:** File Systems (NTFS, ext4 & FAT)

**Estimated Study Time:** 45–60 Minutes

**Skill Category:**

* Computer Fundamentals
* Storage Fundamentals
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

---

# Overview

A partition provides storage space, but it cannot organize or manage files by itself. A **file system** defines how data is stored, named, organized, and retrieved within a partition.

Every operating system relies on a file system to manage files, directories, permissions, and available storage space. Without a file system, a partition is simply raw storage that cannot be used effectively.

Understanding file systems is fundamental to system administration, malware analysis, digital forensics, and incident response.

---

# Why This Matters in Cybersecurity

Most digital evidence exists inside a file system.

Examples include:

* Executables
* Log files
* Browser history
* User documents
* Malware
* Configuration files

Knowing which file system is in use helps investigators understand file permissions, recover evidence, and interpret system artifacts during forensic investigations.

---

# Core Concepts

## What is a File System?

A **file system** is a set of rules that organizes data stored within a partition.

It manages:

* Files
* Directories
* File names
* Metadata
* Free space

The relationship can be summarized as:

```text id="7mskcc"
Physical Disk
      │
Partition
      │
File System
      │
Files & Directories
```

Without a file system, the operating system has no structured way to locate or manage stored data.

---

## NTFS

**NTFS (New Technology File System)** is the default file system used by modern Windows operating systems.

Key features:

* Windows ACL permissions
* Encryption (EFS)
* Compression
* Journaling
* Large file support

Commonly used on:

* Windows 10
* Windows 11
* Windows Server

---

## ext4

**ext4 (Fourth Extended File System)** is the default file system used by most Linux distributions.

Key features:

* Linux ownership
* rwx permissions
* Journaling
* High reliability
* Large file support

Commonly used on:

* Ubuntu
* Debian
* Kali Linux
* Many enterprise Linux systems

---

## FAT32

**FAT32** is an older file system designed for maximum compatibility.

Key characteristics:

* Supported by Windows, Linux, and macOS
* Commonly used on USB drives and SD cards
* Maximum file size of **4 GB**
* No permissions
* No journaling

Because of its simplicity, FAT32 remains useful for portable storage but is rarely used as the primary file system for modern operating systems.

---

## File System Comparison

| Feature            | NTFS            | ext4          | FAT32                 |
| ------------------ | --------------- | ------------- | --------------------- |
| Default OS         | Windows         | Linux         | Portable Media        |
| Journaling         | ✅               | ✅             | ❌                     |
| Permissions        | Windows ACL     | Linux rwx     | ❌                     |
| Large File Support | ✅               | ✅             | ❌ (4 GB Limit)        |
| Typical Use        | Windows Systems | Linux Systems | USB Drives & SD Cards |

---

# Hands-on Lab

## Linux

View mounted file systems:

```bash id="z53n7j"
df -T
```

View storage devices and file systems:

```bash id="y8ij2m"
lsblk -f
```

Display block device information:

```bash id="h5frs8"
blkid
```

---

## Windows

Open **Disk Management** and identify:

* File system type
* Partition layout
* Drive letters

If available, format a removable USB drive and observe the supported file system options.

---

# Real-World Security Example

During an incident response investigation, an analyst receives a compromised Windows laptop.

The system uses **NTFS**, allowing the investigator to examine Windows permissions, identify suspicious executables, and analyze log files.

Later, a USB drive connected to the same system is examined. It uses **FAT32**, which contains no permission information but stores malware samples copied between systems.

On a Linux server, the analyst encounters an **ext4** file system and uses Linux ownership and `rwx` permissions to determine which user modified critical configuration files.

Understanding the underlying file system allows investigators to correctly interpret stored evidence across different operating systems.

---

# Key Learnings

After completing this topic, I understand:

* The purpose of a file system.
* Why partitions require file systems.
* The differences between NTFS, ext4, and FAT32.
* The security features provided by modern file systems.
* Why file systems are essential during forensic investigations.

---

# Learning Outcome

After completing this topic, I can:

* Explain how a file system organizes data.
* Differentiate NTFS, ext4, and FAT32.
* Identify common file systems on Windows and Linux.
* Interpret file system characteristics during investigations.
* Relate file systems to malware analysis and digital forensics.

---

# Portfolio Reflection

Before studying file systems, I viewed storage as a location where files were simply saved. I now understand that a partition becomes usable only after a file system organizes its contents.

I learned that different operating systems rely on different file systems, each providing its own capabilities for permissions, journaling, and data management. I also recognize that file systems are a primary source of forensic evidence, storing executables, log files, browser artifacts, and configuration data that investigators rely on during malware analysis and incident response.

---

## Next Step

**04 – Mounting & Directory Structure**

The next topic explores how operating systems make partitions accessible through mount points and how Linux and Windows organize files into directory structures.
