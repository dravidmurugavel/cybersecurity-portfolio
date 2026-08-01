# 02 – BIOS vs UEFI

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Boot Process – BIOS/UEFI, Bootloader & Kernel Loading

**Subtopic:** BIOS vs UEFI

**Estimated Study Time:** 30–45 Minutes

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* System Boot Process
* Cybersecurity Foundations

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Threat Hunter
* Security Researcher

---

# Overview

Firmware is the first software executed when a computer starts. Historically, this role was performed by the **Basic Input/Output System (BIOS)**. As hardware evolved and storage capacities increased, BIOS limitations led to the development of the **Unified Extensible Firmware Interface (UEFI)**.

Although both BIOS and UEFI initialize hardware, perform POST, and locate a bootable device, UEFI introduces modern features such as GPT support, faster startup, improved hardware compatibility, and Secure Boot.

Understanding the differences between BIOS and UEFI is essential for system administration, operating system deployment, incident response, and cybersecurity.

---

# Why This Matters in Cybersecurity

The firmware is responsible for establishing the trusted starting point of the boot process.

Security professionals frequently verify whether systems boot in **Legacy BIOS** or **UEFI** mode because firmware configuration affects:

* Boot security
* Disk partitioning (MBR vs GPT)
* Secure Boot availability
* Operating system deployment
* Incident response investigations

Modern enterprise environments typically standardize on UEFI with Secure Boot enabled to strengthen the integrity of the boot process.

---

# Core Concepts

## BIOS

**BIOS (Basic Input/Output System)** is the traditional firmware used by older computers.

Its primary responsibilities are:

* Initializing hardware.
* Performing the Power-On Self-Test (POST).
* Detecting bootable storage devices.
* Loading the operating system's bootloader.

Limitations of BIOS include:

* Uses **Master Boot Record (MBR)** partitioning.
* Supports storage devices up to approximately **2 TB**.
* Text-based firmware interface.
* Limited extensibility.
* No native Secure Boot support.

---

## UEFI

**UEFI (Unified Extensible Firmware Interface)** is the modern firmware standard that replaces BIOS.

UEFI performs the same fundamental startup tasks while introducing significant improvements.

Advantages include:

* Faster boot process.
* Support for **GUID Partition Table (GPT)** disks.
* Support for storage devices larger than **2 TB**.
* Improved hardware compatibility.
* Graphical firmware interface.
* Native Secure Boot support.

Today, nearly all modern Windows and Linux systems use UEFI.

---

## BIOS vs UEFI

| BIOS                      | UEFI                            |
| ------------------------- | ------------------------------- |
| Legacy firmware           | Modern firmware                 |
| Uses MBR                  | Uses GPT                        |
| Supports disks up to 2 TB | Supports disks larger than 2 TB |
| Text-based interface      | Graphical interface (commonly)  |
| Slower startup            | Faster startup                  |
| No Secure Boot            | Supports Secure Boot            |

---

## Position in the Boot Process

Regardless of which firmware is present, the startup sequence remains:

```text id="0gnsy4"
Power Button
      │
      ▼
Firmware
(BIOS or UEFI)
      │
      ▼
POST
      │
      ▼
Bootloader
```

Both BIOS and UEFI occupy the same stage of the boot process. Their primary difference lies in the capabilities and features they provide while preparing the system to load the operating system.

---

# Hands-on Lab

## Linux

Determine the firmware mode:

```bash id="n3w6p7"
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "Legacy BIOS"
```

View the disk partition table:

```bash id="j4bm0t"
sudo parted -l
```

Observe whether the system disk uses **MBR** or **GPT**.

---

## Windows

Open **System Information (`msinfo32`)**.

Identify:

* BIOS Mode
* BIOS Version
* Secure Boot State

Open **Disk Management** and verify whether the primary disk uses **MBR** or **GPT**.

---

# Real-World Security Example

During a security assessment, an analyst discovers that several enterprise workstations are configured to boot in Legacy BIOS mode with MBR partitioning.

Although the systems function correctly, they cannot use Secure Boot, leaving the boot process more vulnerable to unauthorized modification.

After migrating the systems to UEFI with GPT partitioning and enabling Secure Boot, the organization strengthens the integrity of the startup process by ensuring that only trusted boot components are executed before the operating system loads.

This demonstrates how firmware configuration directly contributes to system security.

---

# Key Learnings

After completing this topic, I understand:

* The purpose of BIOS and UEFI.
* Why UEFI replaced BIOS.
* The relationship between BIOS and MBR.
* The relationship between UEFI and GPT.
* The major differences between BIOS and UEFI.
* Why Secure Boot is associated with UEFI.
* Why modern systems primarily use UEFI.

---

# Learning Outcome

After completing this topic, I can:

* Explain the responsibilities of BIOS and UEFI.
* Compare BIOS and UEFI features.
* Differentiate MBR and GPT in the context of firmware.
* Identify firmware mode on Linux and Windows systems.
* Explain why UEFI improves both system functionality and boot security.

---

# Portfolio Reflection

Before studying firmware, I assumed BIOS and UEFI simply started the operating system. I now understand that both serve as the first software executed after power-on, initializing hardware, performing POST, and locating the operating system's bootloader.

I also learned why UEFI replaced BIOS by addressing its limitations, including storage capacity, hardware compatibility, and security. Most importantly, I recognize that firmware forms the foundation of the trusted boot chain, making technologies such as Secure Boot essential for protecting systems before the operating system and security software begin running.
