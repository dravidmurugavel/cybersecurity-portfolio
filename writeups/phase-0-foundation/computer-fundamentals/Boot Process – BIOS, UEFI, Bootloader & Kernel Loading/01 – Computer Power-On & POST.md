# 01 – Computer Power-On & POST

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Boot Process – BIOS/UEFI, Bootloader & Kernel Loading

**Subtopic:** Computer Power-On & POST

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

Every computer follows a sequence of events before an operating system starts. Pressing the power button does not immediately launch Windows or Linux. Instead, control is first transferred to the system firmware, which initializes hardware and verifies that essential components are functioning correctly.

The first stage of this process is the **Power-On Self-Test (POST)**, which prepares the computer for booting by checking critical hardware before the operating system is loaded.

Understanding this sequence provides the foundation for learning BIOS, UEFI, bootloaders, and kernel loading.

---

# Why This Matters in Cybersecurity

The boot process begins before any operating system or security software is running.

Because firmware executes first, attackers who compromise it can potentially gain control of a system before antivirus, endpoint detection, or logging mechanisms become active.

Understanding the early boot process helps security professionals:

* Troubleshoot boot failures.
* Understand firmware-based attacks.
* Investigate bootkits.
* Verify firmware configuration during incident response.

---

# Core Concepts

## Power-On Sequence

When the power button is pressed, electrical power is supplied to the motherboard and processor.

The CPU begins executing instructions stored in the system firmware rather than immediately starting the operating system.

The simplified startup sequence is:

```text
Power Button
      │
      ▼
Power Supply
      │
      ▼
Firmware (BIOS / UEFI)
```

At this stage, Windows or Linux has not yet started.

---

## Firmware

Firmware is low-level software permanently stored on the motherboard.

Modern computers use one of two firmware interfaces:

* **BIOS (Basic Input/Output System)** – Legacy firmware found on older systems.
* **UEFI (Unified Extensible Firmware Interface)** – Modern firmware used by most current computers.

Firmware is responsible for:

* Initializing hardware.
* Performing hardware checks.
* Detecting bootable storage devices.
* Starting the operating system's bootloader.

It is the first software executed during the startup process.

---

## Power-On Self-Test (POST)

Before loading an operating system, the firmware performs the **Power-On Self-Test (POST)**.

POST verifies that essential hardware components are working correctly.

Typical hardware checked includes:

* CPU
* RAM
* Graphics adapter
* Keyboard
* Storage devices

If POST detects a critical hardware failure, the boot process stops and the system reports the error through on-screen messages, diagnostic LEDs, or beep codes.

---

## Boot Process So Far

After completing this topic, the startup process can be summarized as:

```text
Power Button
      │
      ▼
Firmware (BIOS / UEFI)
      │
      ▼
POST
      │
      ▼
Locate Boot Device
```

The operating system has **not yet** been loaded.

---

# Hands-on Lab

## Linux

Identify whether the system is using BIOS or UEFI:

```bash
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS"
```

View early kernel boot messages:

```bash
dmesg | head
```

---

## Windows

Open **System Information (`msinfo32`)**.

Observe:

* BIOS Mode
* BIOS Version
* Secure Boot State

---

# Real-World Security Example

A user's computer suddenly fails to boot after a firmware update.

During troubleshooting, the security team discovers that POST repeatedly reports memory initialization errors, preventing the operating system from loading.

In another scenario, investigators suspect a firmware-level compromise after malware persists even after the operating system is reinstalled. Because firmware executes before Windows, malicious code hidden at this level could survive operating system replacement and execute before endpoint protection software starts.

These examples demonstrate why understanding firmware and POST is important for both troubleshooting and cybersecurity investigations.

---

# Key Learnings

After completing this topic, I understand:

* What happens immediately after pressing the power button.
* The role of firmware during system startup.
* The purpose of POST.
* Which hardware components are verified before booting.
* Why the operating system starts only after POST completes successfully.
* Why firmware is an attractive target for advanced attacks.

---

# Learning Outcome

After completing this topic, I can:

* Explain the first stage of the computer boot process.
* Describe the responsibilities of firmware.
* Explain how POST validates hardware.
* Interpret the relationship between firmware and the operating system.
* Relate firmware security to incident response and malware analysis.

---

# Portfolio Reflection

Before studying the boot process, I assumed that pressing the power button immediately started the operating system. I now understand that firmware is the first software executed and that it performs essential hardware initialization before Windows or Linux begins loading.

I also learned that POST verifies critical hardware components before the boot process continues. From a cybersecurity perspective, I recognize why firmware is considered part of the system's trusted computing base and why attacks targeting firmware are particularly dangerous, as they execute before the operating system and most security software become active.
