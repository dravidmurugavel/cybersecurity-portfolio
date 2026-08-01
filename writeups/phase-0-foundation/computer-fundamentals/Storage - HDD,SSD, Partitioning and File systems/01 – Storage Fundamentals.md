# 01 – Storage Fundamentals

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Storage – HDD/SSD, Partitioning & File Systems

**Subtopic:** Storage Fundamentals

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

* Number Systems & Data Representation
* Memory Fundamentals
* CPU Architecture & Instruction Sets

---

# Overview

Storage is the permanent memory of a computer. Unlike RAM, which temporarily holds data while programs execute, storage preserves information even after the system is powered off.

Every operating system, application, document, log file, and malware sample begins its life on a storage device before being loaded into memory for execution.

Understanding storage provides the foundation for learning partitioning, file systems, boot processes, and digital forensics.

---

# Why This Matters in Cybersecurity

Nearly every cyber investigation involves data stored on a disk.

Storage devices contain:

* Operating systems
* Executables
* Log files
* Malware
* Configuration files
* User documents

Understanding how storage works helps explain how attackers leave artifacts behind, why deleted files may still be recoverable, and how forensic investigators collect evidence.

---

# Core Concepts

## Storage vs RAM

Storage is **non-volatile**, meaning data remains even after power is removed.

RAM is **volatile**, meaning its contents are lost when the system shuts down.

A program follows this execution flow:

```text id="vb1qtm"
Storage
   │
Read
   ▼
RAM
   │
CPU Executes
   │
Write Changes
   ▼
Storage
```

The CPU executes instructions from RAM, but those instructions are first loaded from storage.

---

## HDD vs SSD

Modern computers primarily use two storage technologies.

### HDD (Hard Disk Drive)

* Magnetic spinning platters
* Mechanical read/write head
* Larger capacity at lower cost
* Slower access speed
* More vulnerable to physical shock

### SSD (Solid State Drive)

* Flash memory chips
* No moving parts
* Faster data access
* Lower power consumption
* Better resistance to physical damage

Although both permanently store data, they use completely different physical technologies.

---

## Sectors, Blocks & Clusters

Storage devices organize data into increasingly larger units.

```text id="crjcbh"
Storage Device
      │
      ▼
Sectors
      │
      ▼
Blocks
      │
      ▼
Clusters
      │
      ▼
Files
```

### Sector

The smallest physical unit that a storage device can read or write.

### Block

A logical unit used by the operating system when transferring data.

### Cluster

The allocation unit used by the file system.

When a file is saved, the operating system allocates clusters rather than individual bytes.

For example:

```text id="rrjzrx"
File Size = 2 KB

Cluster Size = 4 KB

Allocated = 1 Cluster

Unused = 2 KB
```

---

# Hands-on Lab

## Linux

Identify storage devices:

```bash id="8vv64g"
lsblk
```

Display disk information:

```bash id="hmxpw9"
sudo fdisk -l
```

Show mounted file systems:

```bash id="g3vsod"
df -h
```

---

## Windows

Open:

```text id="q5rmj2"
Disk Management
```

Observe:

* Physical disks
* Partitions
* File systems
* Drive letters

---

# Real-World Security Example

A malware sample is downloaded onto an SSD.

The executable remains on storage until the user launches it.

The operating system loads the executable into RAM, where the CPU begins execution.

During execution, the malware creates log files, downloads additional payloads, and modifies configuration files. Even if the malware process terminates, these artifacts remain on storage and can later be analyzed by incident responders.

Similarly, when a file is deleted on an HDD, the file system often marks its clusters as available without immediately erasing the data. Until those clusters are overwritten, forensic tools may recover the deleted file. On SSDs, technologies such as TRIM and garbage collection can make recovery more difficult.

---

# Key Learnings

After completing this topic, I understand:

* The difference between RAM and permanent storage.
* How HDDs and SSDs physically store data.
* How storage is organized into sectors, blocks, and clusters.
* Why file systems allocate clusters instead of individual bytes.
* Why deleted files may remain recoverable.
* Why storage is a primary source of forensic evidence.

---

# Learning Outcome

After completing this topic, I can:

* Explain the purpose of permanent storage.
* Differentiate HDD and SSD technologies.
* Describe sectors, blocks, and clusters.
* Explain how programs move from storage to RAM.
* Relate storage concepts to malware analysis and digital forensics.

---

# Portfolio Reflection

Before studying storage, I viewed a hard drive simply as a place where files were saved.

I now understand that every executable, document, log file, and malware sample begins on permanent storage before being loaded into memory for execution. I also learned that storage devices organize data into sectors, blocks, and clusters, allowing operating systems and file systems to efficiently manage information.

Most importantly, I now recognize why storage is one of the most valuable sources of evidence during incident response and digital forensic investigations.

---

## Next Step

**02 – Disk Partitioning**

The next topic explores how a single physical storage device is divided into multiple logical partitions, preparing the foundation for boot loaders, operating systems, and file systems.
