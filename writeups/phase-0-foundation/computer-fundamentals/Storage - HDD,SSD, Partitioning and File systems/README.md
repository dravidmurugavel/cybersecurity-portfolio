# Storage – HDD/SSD, Partitioning & File Systems

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Storage – HDD/SSD, Partitioning & File Systems

**Estimated Completion Time:** 4–5 Hours

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* Linux Fundamentals
* Windows Fundamentals
* Digital Forensics Foundation

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Threat Hunter
* Security Researcher

---

# Module Overview

Storage is the foundation of every computing system. Before an operating system can boot, applications can execute, or files can be analyzed, data must first be stored on a physical device.

This module explores how data moves from a physical storage device into a structured, usable environment. Beginning with HDDs and SSDs, it progresses through partitioning, file systems, mounting, and file system metadata. Together, these concepts explain how operating systems organize data and why storage plays a central role in cybersecurity and digital forensics.

---

# Learning Objectives

After completing this module, I can:

* Explain the difference between RAM and permanent storage.
* Differentiate HDD and SSD technologies.
* Describe how disks are partitioned.
* Compare MBR and GPT partition tables.
* Explain how file systems organize data.
* Differentiate NTFS, ext4, and FAT32.
* Understand how partitions are mounted.
* Navigate Linux and Windows directory structures.
* Interpret file metadata, permissions, ownership, and timestamps.
* Relate storage concepts to incident response, malware analysis, and digital forensics.

---

# Module Structure

## 01 – Storage Fundamentals

Learned:

* Storage vs RAM
* HDD vs SSD
* Sectors, Blocks, and Clusters
* Program execution flow from storage to memory

---

## 02 – Disk Partitioning

Learned:

* Physical disks vs partitions
* Why disks are partitioned
* MBR vs GPT
* Primary, Extended, and Logical partitions
* Linux partition naming

---

## 03 – File Systems (NTFS, ext4 & FAT)

Learned:

* Purpose of file systems
* NTFS
* ext4
* FAT32
* File system comparison

---

## 04 – Mounting & Directory Structure

Learned:

* Mounting
* Linux directory hierarchy
* Windows directory hierarchy
* Common investigation locations

---

## 05 – File System Metadata

Learned:

* Metadata
* Timestamps
* Permissions
* Ownership
* Hard links
* Symbolic links

---

# Hands-on Skills Practiced

### Linux

```bash
lsblk
fdisk -l
df -h
df -T
lsblk -f
blkid
findmnt
mount
pwd
ls /
ls -l
stat
ln -s
```

### Windows

* Disk Management
* File Explorer
* File Properties
* Drive letters
* File system identification

---

# Security Mental Model

```text
Physical Storage (HDD / SSD)
            │
            ▼
Partition Table (MBR / GPT)
            │
            ▼
Partitions
            │
            ▼
File System (NTFS / ext4 / FAT32)
            │
            ▼
Mounted by the Operating System
            │
            ▼
Directories & Files
            │
            ▼
Metadata
(Owner • Permissions • Timestamps • Links)
            │
            ▼
Applications & Users
```

---

# Cybersecurity Relevance

Storage is one of the richest sources of digital evidence.

Throughout this module, I learned how operating systems organize data and why investigators analyze entire disks instead of individual files. Every executable, log file, browser artifact, configuration file, and malware sample ultimately resides on a storage device and is managed through a file system.

Understanding storage fundamentals enables security professionals to:

* Locate forensic evidence.
* Identify persistence mechanisms.
* Analyze malware artifacts.
* Recover deleted files.
* Interpret permissions and ownership.
* Reconstruct attack timelines using metadata.

These skills form the foundation for digital forensics, incident response, malware analysis, and operating system internals.

---

# Key Takeaways

* Storage is permanent; RAM is temporary.
* Partitions logically divide physical disks.
* MBR and GPT define how partitions are organized.
* File systems manage how data is stored and retrieved.
* Mounting makes partitions accessible to the operating system.
* Metadata provides valuable forensic evidence beyond file contents.
* Storage knowledge is essential for understanding operating systems and conducting cybersecurity investigations.

---

# Portfolio Reflection

Completing this module fundamentally changed how I view storage systems. I no longer see a hard drive or SSD as simply a place to save files. Instead, I understand the complete path that data follows—from physical storage, through partition tables and file systems, into mounted directories where users and applications interact with it.

Most importantly, I now recognize why storage is one of the primary sources of evidence during cybersecurity investigations. Every artifact left behind by an attacker—whether a malicious executable, log entry, configuration change, or timestamp—can help reconstruct an incident. This module established the storage foundation required for more advanced topics such as boot processes, operating system internals, malware analysis, and digital forensics.
