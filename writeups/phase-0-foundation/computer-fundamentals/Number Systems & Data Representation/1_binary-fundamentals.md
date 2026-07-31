
# Binary Fundamentals

**Job-Role Tag:** Malware Analyst / Reverse Engineer / SOC Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Number Systems & Data Representation

**Date:** 2026-07-09

---

# Objective

Understand why computers use binary, learn how binary represents all forms of digital information, and explain why every cybersecurity investigation ultimately begins with bytes composed of binary digits.

---

# Why This Matters

Every piece of digital evidence eventually reduces to **bits**.

Whether investigating:

* malware,
* network packets,
* memory dumps,
* disk images,
* executable files,
* shellcode,

the analyst is ultimately examining binary data.

Modern tools such as Wireshark, GDB, xxd, IDA Pro, Ghidra, Volatility, and Hex editors simply present binary in formats that are easier for humans to understand.

A solid understanding of binary makes every future cybersecurity topic easier.

---

# Key Concepts

## What is Binary?

Binary is the numbering system understood directly by computer hardware.

Instead of ten digits (0–9), binary uses only two values:

```text
0
1
```

These values correspond to electrical states inside digital circuits.

Every instruction executed by a CPU, every character stored in memory, and every file saved to disk is ultimately represented using combinations of these two values.

---

## Bits and Bytes

The smallest unit of digital information is a **bit**.

```text
Bit = Binary Digit
```

A bit can hold only one value:

```text
0
or
1
```

Eight bits together form one byte.

```text
8 Bits = 1 Byte
```

Examples:

| Binary   | Decimal |
| -------- | ------: |
| 00000000 |       0 |
| 00000001 |       1 |
| 00000101 |       5 |
| 00101011 |      43 |
| 11111111 |     255 |

---

## Why Eight Bits?

Modern computer architectures standardize memory around bytes.

One byte is large enough to represent:

* one ASCII character,
* a small integer,
* part of a machine instruction,
* or a portion of any larger data structure.

Almost every cybersecurity tool displays information one byte at a time.

---

# Hands-on Lab

## Binary Conversion Practice

Exercises completed:

```text
00000101₂ = 5₁₀

00101011₂ = 43₁₀
```

These exercises demonstrated how binary values are converted into decimal values.

---

## Viewing Raw Bytes

Command used:

```bash
printf "Cyber" | xxd
```

Observed output:

```text
00000000: 4379 6265 72  Cyber
```

Observations:

* Five printable characters produced five bytes.
* The hexadecimal values correspond directly to ASCII characters.
* The ASCII view is another interpretation of the same bytes.

---

# Real Incident

## Mirai Botnet (2016)

The Mirai botnet infected thousands of Internet of Things (IoT) devices by exploiting weak credentials and executing compiled binaries for multiple processor architectures.

During malware analysis, investigators examined the binary executables to determine:

* supported CPU architectures,
* embedded strings,
* executable headers,
* and command-and-control behavior.

Although analysts viewed the files using hexadecimal and disassemblers, the underlying data remained binary.

**Security Takeaway**

Every malware sample ultimately consists of binary data. Understanding binary is the foundation for interpreting everything that follows.

---

# My Learning Journey

One of my first realizations was that tools rarely expose raw binary directly.

Instead, they present binary using representations such as:

* hexadecimal,
* ASCII,
* decimal,
* disassembled instructions.

These representations improve readability, but they all describe the same underlying data.

---

# What I Got Wrong First

## Initial Misconception

At the beginning, I viewed binary, hexadecimal, and ASCII as separate types of data.

## Correct Understanding

Binary is the actual stored data.

Hexadecimal, ASCII, decimal, and assembly language are simply different ways of interpreting or representing that same binary.

Understanding this relationship made later concepts such as hexadecimal, file signatures, and endianness much easier to grasp.

---

# Core Takeaway

Binary is the language understood directly by computer hardware.

Every file, network packet, memory dump, executable, and machine instruction ultimately consists of bits grouped into bytes.

Higher-level representations such as hexadecimal and ASCII make binary easier for humans to analyze, but the underlying bytes never change.

---

# Interview Practice

## Question

Why should a cybersecurity analyst understand binary when tools already display hexadecimal and assembly?

---

## My Answer

Although security tools present data in hexadecimal or assembly for readability, the underlying information is still binary. Understanding binary helps explain how different representations relate to the same bytes and prevents misinterpreting data during malware analysis, reverse engineering, or digital forensics.

---

## Feedback

### Strengths

* Recognized binary as the underlying representation.
* Connected binary with higher-level formats such as hexadecimal and assembly.
* Explained the practical value rather than defining binary academically.

### Improvement

Mention that understanding binary allows analysts to reason about unfamiliar tools and file formats instead of relying solely on automated output.

---

# Skills Demonstrated

* Binary-to-decimal conversion
* Understanding bits and bytes
* Reading raw byte output
* Relating binary to hexadecimal and ASCII
* Explaining binary in a cybersecurity context
* Building a foundation for reverse engineering and malware analysis

---

# Commands Used

```bash
printf "Cyber" | xxd
```

---

# Related Resources

* Intel® 64 and IA-32 Architectures Software Developer's Manual (Volume 1)
* Computer Systems: A Programmer's Perspective — Bryant & O'Hallaron
* Practical Binary Analysis — Dennis Andriesse
* Practical Malware Analysis — Michael Sikorski & Andrew Honig
* GNU `xxd` Manual

---

# Summary

Binary is the fundamental representation of all digital information. Every higher-level concept encountered in cybersecurity—hexadecimal, ASCII, machine instructions, memory structures, network packets, and executable files—ultimately derives from binary data. Mastering binary establishes the mental model needed for debugging, reverse engineering, malware analysis, digital forensics, and systems security.
