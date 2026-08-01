# 02 – Disk Partitioning

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Storage – HDD/SSD, Partitioning & File Systems

**Subtopic:** Disk Partitioning

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

---

# Overview

A storage device is a single physical piece of hardware, but operating systems do not use the entire disk as one large storage area. Instead, the disk is divided into **logical sections called partitions**.

Each partition behaves like an independent storage area and can contain its own file system, operating system, or user data. Partitioning improves organization, simplifies system management, and forms the foundation for booting an operating system.

---

# Why This Matters in Cybersecurity

Disk partitioning is frequently encountered during:

* Operating system installation
* Incident response
* Malware analysis
* Digital forensics
* Disk imaging

Understanding partition layouts helps investigators locate hidden recovery partitions, identify dual-boot systems, and ensure that all potential evidence is preserved during forensic acquisition.

---

# Core Concepts

## Physical Disk vs Partition

A **physical disk** is the actual HDD or SSD installed in a computer.

A **partition** is a logical division created on that disk.

```text
1 TB SSD
│
├── EFI System Partition
├── Windows
├── Linux
└── Data
```

Although only one storage device exists, each partition functions independently.

---

## Why Partition a Disk?

Partitioning allows a system to:

* Separate operating system files from user data.
* Install multiple operating systems.
* Create recovery partitions.
* Simplify backup and recovery.
* Reduce the impact of file system corruption.

---

## MBR vs GPT

A computer needs a **partition table** to identify where partitions begin and end.

### MBR (Master Boot Record)

* Older standard
* BIOS based
* Supports disks up to 2 TB
* Maximum of four primary partitions

### GPT (GUID Partition Table)

* Modern standard
* UEFI based
* Supports disks larger than 2 TB
* Supports many partitions
* Stores backup partition information for improved reliability

| MBR                    | GPT                     |
| ---------------------- | ----------------------- |
| BIOS                   | UEFI                    |
| Up to 2 TB             | Greater than 2 TB       |
| 4 Primary Partitions   | Many Partitions         |
| Single Partition Table | Backup Partition Tables |

Modern Windows and Linux systems generally use GPT.

---

## Primary, Extended & Logical Partitions

These concepts apply only to **MBR**.

* **Primary Partition** – Can directly contain an operating system.
* **Extended Partition** – Acts as a container for additional partitions.
* **Logical Partition** – Created inside the Extended Partition.

GPT removes this limitation by allowing many partitions without requiring Extended or Logical partitions.

---

## Linux Partition Naming

Linux identifies storage devices inside the **/dev** directory.

Examples:

```text
/dev/sda
```

* **sd** → Storage device
* **a** → First physical disk

Partitions are identified as:

```text
/ dev/sda1
/ dev/sda2
/ dev/sda3
```

NVMe drives use names such as:

```text
/dev/nvme0n1
/dev/nvme0n1p1
```

Recognizing these names is important when working with logs, forensic images, and incident response tools.

---

# Hands-on Lab

## Linux

View disks and partitions:

```bash
lsblk
```

Display partition tables:

```bash
sudo fdisk -l
```

Show mounted file systems:

```bash
df -h
```

Identify block devices:

```bash
blkid
```

---

## Windows

Open **Disk Management** and observe:

* Physical disks
* MBR or GPT
* EFI System Partition
* Recovery Partition
* Windows partition

---

# Real-World Security Example

During a forensic investigation, an analyst receives a disk image from a compromised laptop.

Instead of examining only the Windows partition, the analyst inspects the entire physical disk and discovers:

* An EFI System Partition
* A hidden recovery partition
* Unallocated space containing remnants of deleted malware

Had only the Windows partition been examined, valuable evidence would have been missed.

This demonstrates why forensic investigators acquire and analyze the **entire physical disk** rather than a single partition.

---

# Key Learnings

After completing this topic, I understand:

* The difference between a physical disk and a partition.
* Why disks are partitioned.
* The differences between MBR and GPT.
* The purpose of Primary, Extended, and Logical partitions.
* Linux partition naming conventions.
* Why complete disk acquisition is important during forensic investigations.

---

# Learning Outcome

After completing this topic, I can:

* Explain disk partitioning.
* Differentiate MBR and GPT.
* Interpret Linux partition names.
* Identify common partition layouts.
* Relate partitioning concepts to incident response and digital forensics.

---

# Portfolio Reflection

Before studying disk partitioning, I assumed a storage device contained one continuous area for storing files. I now understand that operating systems organize disks into logical partitions, each serving a specific purpose such as booting the system, storing user data, or providing recovery functionality.

I also learned that modern systems primarily use GPT because it supports larger disks, more partitions, and improved reliability. From a cybersecurity perspective, I now recognize why investigators acquire entire physical disks instead of individual partitions, ensuring that hidden partitions, recovery areas, and deleted artifacts are preserved for analysis.

---

## Next Step

**03 – File Systems (NTFS, ext4 & FAT)**

The next topic explores how each partition organizes files and directories, providing the foundation for understanding file storage, permissions, timestamps, and digital forensic analysis.
