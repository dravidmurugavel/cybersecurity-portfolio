
# Cybersecurity Learning Portfolio

A hands-on cybersecurity learning portfolio documenting my journey from computer fundamentals to advanced security concepts through practical labs, technical write-ups, and interview preparation.

## 🎯 Goal

Develop the mindset and practical skills of a cybersecurity professional by focusing on:

* Hands-on learning
* Real-world security incidents
* Technical analysis
* Interview preparation
* Repeatable investigation workflows
* Public documentation of completed labs

---

# Learning Roadmap

| Phase                 | Module                                         |    Status   |
| --------------------- | ---------------------------------------------- | :---------: |
| Computer Fundamentals | Number Systems & Data Representation           | ✅ Complete |
| Computer Fundamentals | CPU Architecture & Instruction Sets            | ✅ Complete |
| Computer Fundamentals | Memory (RAM, Cache, Virtual Memory, Paging)    | ✅ Complete |
| Computer Fundamentals | Storage (HDD/SSD, Partitions, File Systems)    | ✅ Complete |
| Computer Fundamentals | Boot Process (BIOS/UEFI, Bootloader, Kernel)   | ✅ Complete |
| Computer Fundamentals | Interrupts, System Calls & Context Switching   | ✅ Complete |
| Computer Fundamentals | Virtualization (Hypervisors, VMs & Containers) | ✅ Complete |

---

# Module 1 — Number systems & Data representation

**Status:** ✅ Complete

## Learning Objectives

* Understand how computers represent data.
* Read and interpret binary, hexadecimal, and ASCII.
* Understand Unicode and character encoding.
* Explain endianness and byte ordering.
* Identify files using magic numbers.
* Apply these concepts to safe malware triage.

---

## Portfolio Index

|  #  | Topic                                                                                                                            | Job Role                                          | Skill Category        | Status |
| :-: | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- | --------------------- | :----: |
|  01 | [Binary Fundamentals](writeups/fundamentals/data-representation/2026-07-09-binary-fundamentals.md)                               | Malware Analyst / Reverse Engineer / SOC Analyst  | Computer Fundamentals |    ✅   |
|  02 | [Hexadecimal Fundamentals](writeups/fundamentals/data-representation/2026-07-09-hexadecimal-fundamentals.md)                     | Malware Analyst / Reverse Engineer / SOC Analyst  | Computer Fundamentals |    ✅   |
|  03 | [ASCII & Unicode](writeups/fundamentals/data-representation/2026-07-09-ascii-unicode.md)                                         | Malware Analyst / DFIR Analyst / SOC Analyst      | Computer Fundamentals |    ✅   |
|  04 | [Bytes, Words & Endianness](writeups/fundamentals/data-representation/2026-07-09-bytes-words-endianness.md)                      | Malware Analyst / Reverse Engineer / DFIR Analyst | Computer Fundamentals |    ✅   |
|  05 | [Reading Hex Dumps & File Signatures](writeups/fundamentals/data-representation/2026-07-09-reading-hex-dumps-file-signatures.md) | DFIR Analyst / Malware Analyst / SOC Analyst      | Computer Fundamentals |    ✅   |
|  06 | [Exercise — Analyzing an Unknown File](writeups/fundamentals/data-representation/2026-07-09-putting-it-together.md)   | SOC Analyst / DFIR Analyst / Malware Analyst      | Computer Fundamentals |    ✅   |

---

# Skills Acquired

### Technical Foundations

* Binary representation
* Hexadecimal notation
* ASCII & Unicode encoding
* Bits, bytes and nibbles
* Endianness
* File signatures (magic numbers)
* Static file triage
* Cryptographic hash verification

### Tools Practiced

```text
printf
xxd
hexdump
file
strings
sha256sum
```

---

# Investigation Workflow

```text
Unknown File
      │
      ▼
Verify file type
      │
      ▼
Inspect hex dump
      │
      ▼
Identify magic number
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

---

# Repository Structure

```text
cybersecurity-learning-portfolio/
│
├── README.md
│
├── writeups/
    └── fundamentals/
        └── Number systems & Data representation/
            ├── 1_binary-fundamentals.md
            ├── 2_hexadecimal-fundamentals.md
            ├── 3_ascii-unicode.md
            ├── 4_bytes-words-endianness.md
            ├── 5_reading-hex-dumps-file-signatures.md
            └── 6_exercise.md
            └── README.md

```

---

# What's Next

The next module in this learning journey is:

**Computer Fundamentals → Memory (RAM, Cache, Virtual Memory & Paging)**

This module builds directly on the concepts introduced here and prepares the foundation for operating systems, reverse engineering, malware analysis, exploit development, and digital forensics.

---

## About This Portfolio

Every write-up in this repository is based on my own hands-on lab work, guided learning, and post-lab reflection. The focus is on understanding core concepts, documenting practical exercises, correcting misconceptions, and building a repeatable investigative mindset applicable to defensive cybersecurity roles.
