
# Bytes, Words & Endianness

**Job-Role Tag:** Malware Analyst / Reverse Engineer / DFIR Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Number Systems & Data Representation

**Date:** 2026-07-09

---

# Objective

Understand how multi-byte values are stored and interpreted in computer memory, learn the difference between byte storage and CPU interpretation, and explain why endianness matters when analyzing executables, memory dumps, network data, and debugger output.

---

# Why This Matters

During malware analysis, reverse engineering, digital forensics, or exploit development, analysts constantly inspect raw memory.

The bytes displayed by a debugger or hex editor are **the exact bytes stored in memory**, but the CPU may interpret those bytes differently depending on its endianness.

Confusing **storage** with **interpretation** is one of the most common beginner mistakes.

Understanding endianness allows analysts to correctly read:

* Memory addresses
* Function pointers
* Integer values
* Stack contents
* Register values
* Executable headers

Without this knowledge, debugger output can easily be misinterpreted.

---

# Key Concepts

## Byte

A byte is the smallest addressable unit of memory on modern systems.

```text
1 Byte = 8 Bits
```

Example:

```text
12
```

One byte has no byte order because there is only one byte.

---

## Multi-byte Values

Suppose a four-byte integer is stored as:

```text
12 34 56 78
```

The bytes remain stored exactly like this in memory.

The difference lies in **how the CPU interprets these four bytes as one integer**.

---

## Big Endian

The byte at the **lowest memory address** is treated as the **Most Significant Byte (MSB)**.

Stored bytes:

```text
12 34 56 78
```

Interpreted value:

```text
0x12345678
```

---

## Little Endian

The byte at the **lowest memory address** is treated as the **Least Significant Byte (LSB)**.

Stored bytes:

```text
12 34 56 78
```

Interpreted value:

```text
0x78563412
```

Modern Intel and AMD x86/x64 processors use little-endian byte order.

---

# Hands-on Lab

## Commands Used

Create a binary file:

```bash
printf '\x12\x34\x56\x78' > endian.bin
```

Inspect the bytes:

```bash
xxd endian.bin
```

Observed output:

```text
00000000: 1234 5678
```

Notice that `xxd` displays the bytes exactly as they are stored.

It does **not** reverse them.

---

## Lab Observation

The bytes remained:

```text
12 34 56 78
```

throughout the inspection.

Only the CPU's interpretation changes when those bytes are treated as a multi-byte integer.

---

# Real Incident

## CVE-2017-0144 (EternalBlue)

During analysis of the SMB packets and shellcode used by EternalBlue, reverse engineers and malware analysts had to correctly interpret little-endian values while examining memory structures, packet fields, and exploit code.

Incorrect assumptions about byte order would lead to incorrect addresses, corrupted offsets, and failed exploit analysis.

**Security Takeaway**

Endianness is fundamental when reading memory, disassembling binaries, and interpreting exploit payloads.

---

# My Learning Journey

Initially, I believed that:

> The CPU "reverses the bytes."

Through the exercises, I realized this mental model was incorrect.

The bytes stored in memory **never change**.

Instead:

* the CPU follows an interpretation rule,
* while tools such as `xxd` simply display the stored bytes.

This distinction made debugger output much easier to understand.

---

# What I Got Wrong First

## Initial Misconception

I thought:

> Little-endian physically reverses bytes in memory.

## Correct Understanding

The bytes remain stored sequentially.

Example:

| Address | Byte |
| ------- | ---- |
| 0x1000  | 12   |
| 0x1001  | 34   |
| 0x1002  | 56   |
| 0x1003  | 78   |

Nothing moves.

When the CPU reads these four bytes as one integer:

* **Big-endian →** `0x12345678`
* **Little-endian →** `0x78563412`

The difference is **interpretation**, not storage.

---

# Core Takeaway

Endianness is a rule for interpreting multi-byte values.

It does **not** change:

* file contents,
* memory layout,
* or hex editor output.

It only affects how the CPU constructs a value from consecutive bytes.

Remembering this distinction prevents many common mistakes during malware analysis and reverse engineering.

---

# Interview Practice

## Question

A debugger displays the bytes:

```text
12 34 56 78
```

running on an x86-64 processor.

What integer does the CPU interpret, and why?

---

## My Answer

Since x86-64 uses little-endian architecture, the CPU interprets the byte at the lowest memory address as the least significant byte. Therefore, the bytes `12 34 56 78` are interpreted as the integer `0x78563412`. The bytes themselves remain unchanged; only the CPU's interpretation differs.

---

## Feedback

### Strengths

* Distinguished storage from interpretation.
* Correctly identified little-endian behavior.
* Explained that the bytes themselves never change.

### Improvement

Avoid saying:

> "The CPU reverses the bytes."

Instead, say:

> "The CPU interprets consecutive bytes according to little-endian rules."

This wording is technically precise and interview-ready.

---

# Skills Demonstrated

* Reading hexadecimal byte sequences
* Understanding byte ordering
* Differentiating storage from interpretation
* Explaining little-endian vs. big-endian
* Using `xxd` to inspect binary data
* Communicating technical concepts clearly

---

# Commands Learned

```bash
printf '\x12\x34\x56\x78' > endian.bin

xxd endian.bin
```

---

# Related Resources

* Intel® 64 and IA-32 Architectures Software Developer's Manual (Volume 1)
* "Practical Binary Analysis" – Dennis Andriesse
* GDB Documentation
* Malware Unicorn – Reverse Engineering 101
* Practical Malware Analysis (Sikorski & Honig)

---

# Summary

Endianness defines how a CPU interprets multi-byte values stored in memory. The stored bytes never move or change order; only their interpretation differs. Understanding this distinction is essential for debugging, reverse engineering, exploit development, malware analysis, and digital forensics, where correctly interpreting raw memory directly impacts the accuracy of an investigation.
