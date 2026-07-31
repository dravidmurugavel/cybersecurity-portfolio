
# Reading Hex Dumps & File Signatures

**Job-Role Tag:** DFIR Analyst / Malware Analyst / SOC Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Number Systems & Data Representation

**Date:** 2026-07-09

---

# Objective

Learn how to inspect raw bytes using a hex editor, identify common file signatures (magic numbers), and understand why security professionals trust file headers over filenames when analyzing unknown files.

---

# Why This Matters

Attackers frequently disguise malicious files by changing their filenames or extensions.

Examples:

```text
invoice.pdf.exe
photo.jpg.exe
report.doc.scr
malware.pdf
```

To an unsuspecting user, these files may appear harmless. However, a cybersecurity professional does **not** trust the filename—they verify the file's true identity by examining its first few bytes.

This skill is used daily in:

* Malware triage
* Digital forensics
* Email security
* Threat hunting
* Incident response

---

# Key Concepts

## Hex Dump

A hex dump displays the raw bytes stored in a file.

Example:

```text
00000000: 7f45 4c46 0201 0100
```

The left column is the file offset.

The middle section displays hexadecimal bytes.

The right section (when available) displays printable ASCII characters.

The bytes themselves are the source of truth.

---

## File Signature (Magic Number)

A file signature is a sequence of bytes located at the beginning of a file that identifies its format.

Unlike filenames, these bytes are part of the file itself.

Examples:

| File Type      | Hex Signature | ASCII  |
| -------------- | ------------- | ------ |
| ELF Executable | `7F 45 4C 46` | `.ELF` |
| Windows PE     | `4D 5A`       | `MZ`   |
| PDF            | `25 50 44 46` | `%PDF` |
| ZIP            | `50 4B 03 04` | `PK..` |
| PNG            | `89 50 4E 47` | `.PNG` |

---

## Why Extensions Cannot Be Trusted

A filename is metadata.

Anyone can rename:

```text
malware.exe
```

to

```text
invoice.pdf
```

The extension changes.

The file signature does not.

---

# Hands-on Lab

## Commands Used

Create sample files:

```bash
printf "Hello" > hello.txt

touch empty.bin

cp /bin/ls sample
```

Inspect the files:

```bash
file sample

xxd -l 16 sample

xxd hello.txt

xxd empty.bin
```

---

## Observed Output

### Sample Executable

```text
7F 45 4C 46
```

The `file` command identified the file as:

```text
ELF 64-bit LSB executable
```

---

### Text File

```text
48 65 6C 6C 6F
```

ASCII:

```text
Hello
```

Unlike executables, the text file begins immediately with printable ASCII characters.

---

### Empty File

The file contained zero bytes.

There is no file signature because no data has been written.

---

# Analysis

The extension of a file should never be treated as proof of its type.

Instead, the investigation should begin by reading the first few bytes.

For example:

```text
invoice.pdf
```

could actually begin with:

```text
4D 5A
```

which immediately identifies it as a Windows executable rather than a PDF document.

---

# Real Incident

## Stuxnet (2010)

During the investigation of Stuxnet, analysts examined Windows Portable Executable (PE) files to understand how the malware propagated and executed. The `MZ` and `PE` headers allowed investigators to quickly identify executable files before performing deeper reverse engineering.

The file header provided an immediate indication of the file format, regardless of its filename.

**Security Takeaway**

The first few bytes of a file are often more trustworthy than its extension.

---

# Investigation Workflow

When presented with an unknown file, my workflow is:

```text
Unknown File
      │
      ▼
Inspect the first bytes (xxd)
      │
      ▼
Identify the file signature
      │
      ▼
Verify using the file command
      │
      ▼
Calculate SHA-256 hash
      │
      ▼
Check reputation (VirusTotal / Internal IOC Database)
      │
      ▼
Extract printable strings
      │
      ▼
Analyze safely inside an isolated sandbox
```

This process minimizes risk while providing valuable information before execution.

---

# What I Got Wrong First

## Initial Misconception

I initially thought that the file extension revealed the actual file type.

## Correct Understanding

The filename is only a label.

The file signature is part of the file's binary structure and provides a much more reliable indication of its format.

A renamed executable remains an executable because its internal structure has not changed.

---

# Core Takeaway

The first few bytes of a file reveal its true identity.

A security analyst should always verify file signatures before trusting filenames or extensions.

This simple habit prevents many common mistakes during malware triage and digital forensic investigations.

---

# Interview Practice

## Question

You receive an email attachment named:

```text
invoice.pdf
```

The first four bytes are:

```text
4D 5A 90 00
```

Walk me through your investigation.

---

## My Answer

Although the attachment is named `invoice.pdf`, the first two bytes (`4D 5A`) identify it as a Windows PE executable. I would verify the file type using the `file` command, calculate its SHA-256 hash, and check its reputation using VirusTotal and the organization's internal IOC database. Next, I would use the `strings` command to extract printable information such as URLs, domains, registry paths, or commands without executing the file. Finally, I would analyze the sample inside an isolated sandbox to observe its behavior safely.

---

## Feedback

### Strengths

* Correctly identified the executable header.
* Distinguished between the filename and the actual file type.
* Demonstrated a logical investigation workflow.
* Prioritized safe static analysis before execution.

### Improvement

Explicitly mention that the mismatch between the filename and the file signature is itself an Indicator of Suspicion (IoS) that warrants further investigation.

---

# Skills Demonstrated

* Reading hex dumps
* Identifying file signatures
* Recognizing executable headers
* Differentiating file signatures from extensions
* Using `xxd`
* Using `file`
* Static malware triage
* Developing a structured investigation workflow

---

# Commands Learned

```bash
file

xxd

strings

sha256sum
```

---

# Related Resources

* Gary Kessler File Signature Table
* `man file`
* `man xxd`
* Practical Malware Analysis (Sikorski & Honig)
* Malware Unicorn – Reverse Engineering 101

---

# Summary

File signatures provide a reliable method for identifying file types regardless of their filenames or extensions. By inspecting the first few bytes of a file, verifying the type with the `file` command, checking its hash reputation, extracting printable strings, and analyzing it in a sandbox, a cybersecurity professional can safely triage suspicious files while minimizing the risk of accidental execution.
