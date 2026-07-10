
# Hexadecimal Fundamentals

**Job-Role Tag:** Malware Analyst / Reverse Engineer / SOC Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Number Systems & Data Representation

**Date:** 2026-07-09

---

# Objective

Understand why hexadecimal is the standard representation of binary data in cybersecurity, learn how hexadecimal maps directly to bytes, and develop the ability to read and interpret hexadecimal values during file, memory, and network analysis.

---

# Why This Matters

Computers operate using binary (0s and 1s), but binary quickly becomes difficult for humans to read.

For example, a single byte can be represented as:

```text
01000011
```

Hexadecimal represents the same byte more compactly:

```text
43
```

Nothing about the data changes—only its representation.

Because hexadecimal is concise and maps cleanly to bytes, it has become the universal language for inspecting:

* Executable files
* Memory dumps
* Network packets
* Disk images
* Shellcode
* Debugger output

Nearly every cybersecurity tool displays raw data in hexadecimal.

---

# Key Concepts

## Binary vs. Hexadecimal

Binary is the native language of computer hardware.

Hexadecimal is a human-friendly notation for binary.

Example:

| Binary   | Hex |
| -------- | --- |
| 00000000 | 00  |
| 00000001 | 01  |
| 00001111 | 0F  |
| 01000001 | 41  |
| 11111111 | FF  |

Both forms describe the exact same data.

---

## Bits, Nibbles, and Bytes

Understanding the relationship between bits and hexadecimal is fundamental.

```text
1 Bit = Smallest unit of data

4 Bits = 1 Nibble

1 Hex Digit = 4 Bits

2 Hex Digits = 1 Byte = 8 Bits
```

Examples:

```text
41 → 01000001

FF → 11111111

7F → 01111111
```

This direct relationship makes hexadecimal ideal for displaying bytes.

---

## Why Security Professionals Prefer Hexadecimal

Hexadecimal offers several advantages:

* Compact representation of binary.
* Easy alignment with byte boundaries.
* Simple conversion between memory addresses and values.
* Consistent representation across operating systems and tools.

Whether using:

* `xxd`
* `hexdump`
* GDB
* Wireshark
* Ghidra
* IDA Pro

you will almost always encounter hexadecimal.

---

# Hands-on Lab

## Commands Used

Display ASCII bytes:

```bash
printf "ABC" | xxd
```

View a text file:

```bash
printf "Cyber" > hello.txt

xxd hello.txt
```

---

## Observed Output

```text
00000000: 4142 43
```

and

```text
00000000: 4379 6265 72
```

From the lab:

| Character | Hex |
| --------- | --- |
| A         | 41  |
| B         | 42  |
| C         | 43  |
| C         | 43  |
| y         | 79  |
| b         | 62  |
| e         | 65  |
| r         | 72  |

One important observation was that the spaces displayed by `xxd` are **visual formatting** for readability and are **not stored** inside the file.

---

# Real Incident

## WannaCry Ransomware (2017)

During analysis of WannaCry, malware analysts examined executable files using hexadecimal views to identify PE headers, embedded strings, and encrypted resources before deeper reverse engineering.

Hexadecimal allowed investigators to inspect the exact bytes stored within the malware without modifying the sample.

**Security Takeaway**

Hexadecimal is the primary language used by analysts to inspect raw binary safely and accurately during malware investigations.

---

# My Learning Journey

At first, I thought hexadecimal represented machine instructions directly.

Through the exercises, I realized that hexadecimal is simply a representation of raw bytes.

Those bytes might later be interpreted as:

* ASCII text
* Machine instructions
* Executable headers
* Images
* Compressed data
* Encrypted content

The meaning depends on context—not on hexadecimal itself.

---

# What I Got Wrong First

## Initial Misconceptions

I initially believed:

* One byte consisted of four bits.
* Hexadecimal itself represented instructions.

## Correct Understanding

A byte contains **eight bits**.

Each hexadecimal digit represents **four bits**.

Therefore:

```text
2 Hex Digits = 1 Byte
```

Hexadecimal does not define meaning.

It simply provides a readable representation of binary.

The interpretation of those bytes depends on the software or processor reading them.

---

# Core Takeaway

Hexadecimal is not another type of data—it is a compact way of displaying binary.

Because every byte maps exactly to two hexadecimal digits, cybersecurity professionals use hexadecimal to inspect memory, executables, network packets, and storage media efficiently without altering the underlying data.

---

# Interview Practice

## Question

Why do reverse engineers and malware analysts work primarily with hexadecimal instead of binary?

---

## My Answer

Hexadecimal represents binary values in a shorter, less confusing, and more human-readable form. It allows analysts to identify byte patterns, instructions, commands, and data structures more efficiently while preserving the exact underlying binary values.

---

## Feedback

### Strengths

* Correctly explained the readability advantage.
* Connected hexadecimal with practical security work.
* Recognized that hexadecimal preserves the original binary data.

### Improvement

Clarify that hexadecimal itself does not reveal whether bytes represent text, instructions, or images. The analyst must interpret those bytes in the correct context.

---

# Skills Demonstrated

* Binary-to-hexadecimal reasoning
* Understanding nibbles and bytes
* Reading hexadecimal dumps
* Mapping hexadecimal to ASCII
* Using `xxd` for byte inspection
* Explaining hexadecimal during technical discussions

---

# Commands Used

```bash
printf "ABC" | xxd

printf "Cyber" > hello.txt

xxd hello.txt
```

---

# Related Resources

* Intel® 64 and IA-32 Architectures Software Developer's Manual (Volume 1)
* GNU `xxd` Manual
* Practical Binary Analysis — Dennis Andriesse
* Practical Malware Analysis — Michael Sikorski & Andrew Honig
* HexEd.it (Online Hex Editor)

---

# Summary

Hexadecimal is the standard representation of binary data in cybersecurity because it provides a compact, byte-aligned, and human-readable view of raw information. Mastering hexadecimal enables analysts to inspect executables, memory, network traffic, and disk images with confidence while maintaining an accurate understanding of the underlying binary data. This skill forms a critical bridge between low-level computer architecture and practical security analysis.
