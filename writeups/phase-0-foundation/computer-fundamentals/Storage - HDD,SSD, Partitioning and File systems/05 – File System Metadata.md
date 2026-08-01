# 05 – File System Metadata

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Storage – HDD/SSD, Partitioning & File Systems

**Subtopic:** File System Metadata

**Estimated Study Time:** 30–45 Minutes

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

**Prerequisites:**

* Storage Fundamentals
* Disk Partitioning
* File Systems
* Mounting & Directory Structure

---

# Overview

Every file consists of two components: the actual file data and **metadata**. While the file data contains the information a user creates or views, metadata stores information about the file itself, such as its owner, permissions, timestamps, and size.

Operating systems rely on metadata to manage files efficiently, while cybersecurity professionals use it to reconstruct events, identify unauthorized activity, and analyze evidence during investigations.

---

# Why This Matters in Cybersecurity

Metadata often provides evidence that cannot be obtained from file contents alone.

It helps investigators determine:

* Who owns a file.
* When a file was created.
* When it was modified.
* When it was last accessed.
* Who can access or modify it.
* Whether a file is a normal file or a link.

These details are essential for building attack timelines and understanding attacker behavior.

---

# Core Concepts

## What is Metadata?

**Metadata** means **data about data**.

Every file contains:

```text id="t5ez5j"
File
│
├── File Data
└── Metadata
```

Metadata typically includes:

* File name
* File size
* Owner
* Permissions
* Creation time
* Modification time
* Access time

While users focus on file contents, the operating system relies on metadata to organize and manage files.

---

## File Timestamps

Most file systems maintain timestamps that record file activity.

The three fundamental timestamps are:

| Timestamp | Purpose                                  |
| --------- | ---------------------------------------- |
| Created   | When the file was created                |
| Modified  | When the file contents were last changed |
| Accessed  | When the file was last opened or read    |

Investigators use these timestamps to reconstruct the sequence of events during an incident.

---

## Permissions & Ownership

Metadata also records:

* File owner
* Group ownership
* Access permissions

Linux expresses permissions using the familiar **rwx** notation.

Example:

```text id="xgbmcb"
-rwxr-xr--
```

Windows stores similar information using **Access Control Lists (ACLs)**.

Permissions determine who can read, modify, or execute a file, while ownership identifies the account responsible for it.

---

## Hard Links vs Symbolic Links

### Hard Link

A hard link creates another directory entry that references the same underlying file data.

The file remains accessible until all hard links are removed.

### Symbolic Link

A symbolic link (symlink) acts as a pointer to another file or directory.

If the original target is deleted, the symbolic link becomes invalid.

Understanding the difference helps investigators distinguish between actual files and references to files.

---

# Hands-on Lab

## Linux

Display permissions:

```bash id="odtjq5"
ls -l
```

View detailed metadata:

```bash id="5mb5el"
stat filename
```

Create a symbolic link:

```bash id="l41d7z"
ln -s file.txt shortcut.txt
```

Verify the symbolic link:

```bash id="17k8ui"
ls -l
```

---

## Windows

Right-click a file and open **Properties**.

Observe:

* Owner
* Permissions
* Size
* Created
* Modified
* Accessed timestamps

Compare metadata between multiple files to understand how changes affect timestamps.

---

# Real-World Security Example

During a ransomware investigation, analysts discover a suspicious executable stored within a user's Downloads directory.

Although the executable itself provides valuable evidence, its metadata reveals even more.

The timestamps show when the file first appeared, when it was executed, and when it was last modified. Ownership identifies the affected user account, while permissions confirm that the executable was allowed to run. Additional investigation discovers a symbolic link pointing to another malicious payload used for persistence.

By analyzing metadata rather than file contents alone, investigators can reconstruct the attack timeline and better understand how the compromise occurred.

---

# Key Learnings

After completing this topic, I understand:

* The purpose of file system metadata.
* The difference between file contents and metadata.
* The importance of timestamps during investigations.
* How ownership and permissions control file access.
* The difference between hard links and symbolic links.
* Why metadata is critical during malware analysis and digital forensics.

---

# Learning Outcome

After completing this topic, I can:

* Explain file system metadata.
* Interpret common file timestamps.
* Analyze Linux and Windows file permissions.
* Differentiate hard links from symbolic links.
* Apply metadata analysis during incident response and forensic investigations.

---

# Portfolio Reflection

Before studying file system metadata, I primarily focused on the contents of files. I now understand that metadata often provides equally important information by revealing when a file was created, modified, or accessed, who owns it, and who is allowed to interact with it.

I also learned that links can behave differently depending on whether they are hard links or symbolic links. Most importantly, I recognize that metadata plays a central role in digital forensics by helping investigators reconstruct attack timelines, identify unauthorized changes, and understand how attackers interacted with a compromised system.

---