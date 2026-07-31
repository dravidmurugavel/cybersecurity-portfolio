
# ASCII & Unicode Fundamentals

**Job-Role Tag:** Malware Analyst / DFIR Analyst / SOC Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Number Systems & Data Representation

**Date:** 2026-07-09

---

# Objective

Learn how computers represent text as bytes using character encoding standards, understand the difference between ASCII and Unicode, and recognize why this knowledge is important when analyzing files, memory, network traffic, and malware.

---

# Why This Matters

Cybersecurity professionals rarely see plain text first—they see **bytes**.

Whether examining:

* a memory dump,
* a network packet,
* a malware sample,
* a disk image, or
* a hex dump,

the analyst must determine whether those bytes represent **text**, **machine code**, **encrypted data**, or **compressed data**.

Recognizing ASCII strings inside raw bytes often provides the first clues during an investigation, such as:

* URLs
* Domain names
* Registry paths
* File paths
* PowerShell commands
* API names
* Error messages

Understanding character encoding allows analysts to distinguish meaningful human-readable data from arbitrary binary.

---

# Key Concepts

## Character Encoding

A computer stores everything as bytes.

Character encoding defines **how those bytes map to human-readable characters**.

Example:

```text
Byte
 ↓
48
 ↓
ASCII Table
 ↓
'H'
```

Without an encoding standard, the byte `48` would have no meaning.

---

## ASCII

ASCII (American Standard Code for Information Interchange) is a **7-bit character encoding** containing 128 characters.

It includes:

* English letters
* Numbers
* Basic punctuation
* Control characters

Example:

| Character | Hex | Decimal |
| --------- | --: | ------: |
| A         |  41 |      65 |
| B         |  42 |      66 |
| H         |  48 |      72 |
| a         |  61 |      97 |
| 0         |  30 |      48 |

---

## Unicode

ASCII works well for English but cannot represent most of the world's languages.

Unicode was created to support:

* Arabic
* Chinese
* Japanese
* Korean
* Hindi
* Tamil
* Emoji
* Mathematical symbols
* Thousands of additional characters

UTF-8 is the most common Unicode encoding and remains backward compatible with ASCII.

---

# Hands-on Lab

## Commands Used

```bash
printf "Cyber" | xxd

printf "Cyber" | hexdump -C

strings hello.txt
```

---

## Observed Output

```text
00000000: 4379 6265 72  Cyber
```

Character mapping:

| Character | Hex |
| --------- | --- |
| C         | 43  |
| y         | 79  |
| b         | 62  |
| e         | 65  |
| r         | 72  |

---

## Analysis

Each character occupies one byte because every character belongs to the ASCII character set.

The hexadecimal values displayed by `xxd` correspond directly to entries in the ASCII table.

The printable text shown on the right side of the hex dump is **not additional data**—it is simply another interpretation of the same bytes.

---

# Real Incident

## NotPetya (2017)

During analysis of the NotPetya malware, investigators extracted printable ASCII strings from executables and memory to quickly identify:

* imported Windows API functions,
* file paths,
* embedded commands,
* registry keys,
* and other useful indicators.

Rather than immediately reverse engineering thousands of assembly instructions, analysts first inspected printable strings to gain rapid situational awareness.

**Security Takeaway**

Recognizing ASCII strings is often one of the fastest methods for triaging suspicious files before deeper static or dynamic analysis.

---

# Lab Reflection

One important realization during this lab was that:

> A hex editor is not displaying two different datasets.

Instead:

* the left side displays hexadecimal,
* the right side displays printable ASCII,

both representing the **same underlying bytes**.

This understanding makes it much easier to interpret unknown files during forensic analysis.

---

# What I Got Wrong First

## Initial Misconception

I initially viewed hexadecimal and ASCII as separate pieces of information.

## Correct Understanding

Hexadecimal and ASCII are simply **two different interpretations of the same bytes**.

For example:

```text
43
```

can be interpreted as:

* hexadecimal value `43`
* ASCII character `C`

The byte itself never changes.

Only its interpretation changes.

---

# Core Takeaway

Raw bytes are the source of truth.

ASCII and Unicode are simply standardized ways to interpret those bytes as text.

When examining malware, memory dumps, or disk images, recognizing printable strings provides valuable investigative clues without executing the file.

---

# Interview Practice

## Question

Why do malware analysts frequently run the `strings` command before opening a suspicious executable?

---

## My Answer

Because `strings` extracts printable characters from raw bytes without executing the file, allowing analysts to identify useful information such as URLs, domains, registry paths, commands, API names, and file paths during the initial investigation.

---

## Feedback

Strengths

* Correctly identified static analysis.
* Demonstrated awareness of safe investigation practices.
* Connected character encoding with malware analysis.

Improvement

Mention that not every printable string is meaningful. Analysts must correlate extracted strings with other evidence before drawing conclusions.

---

# Skills Demonstrated

* Reading ASCII values from hexadecimal
* Mapping hexadecimal bytes to characters
* Understanding UTF-8 compatibility
* Using `xxd`
* Using `hexdump`
* Using `strings`
* Performing safe static analysis

---

# Commands Learned

```bash
printf

xxd

hexdump -C

strings
```

---

# Related Resources

* RFC 3629 – UTF-8 Specification
* GNU `strings` Manual
* GNU `xxd` Manual
* Malware Unicorn – Reverse Engineering 101
* Practical Malware Analysis (Sikorski & Honig)

---

# Summary

ASCII and Unicode provide standardized ways to interpret raw bytes as human-readable text. Understanding character encoding enables cybersecurity professionals to quickly recognize valuable information hidden inside files, memory, and network traffic. Tools such as `xxd` and `strings` leverage this knowledge to support safe and efficient malware triage, digital forensics, and incident response.
