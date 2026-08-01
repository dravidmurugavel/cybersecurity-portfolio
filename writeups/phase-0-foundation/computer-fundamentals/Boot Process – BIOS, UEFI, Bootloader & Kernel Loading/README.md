# Boot Process – BIOS/UEFI, Bootloader & Kernel Loading

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Boot Process – BIOS/UEFI, Bootloader & Kernel Loading

**Estimated Completion Time:** 3–4 Hours

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* Linux Fundamentals
* Windows Fundamentals
* Cybersecurity Foundations

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Threat Hunter
* Security Researcher

---

# Module Overview

Every time a computer starts, it follows a carefully ordered sequence before the operating system becomes usable. This startup sequence, known as the **boot process**, begins when the power button is pressed and ends when the user reaches the login screen or desktop.

This module explores each stage of the boot process, beginning with firmware initialization and the Power-On Self-Test (POST), continuing through BIOS and UEFI, the bootloader, kernel loading, and finally the security mechanisms that protect the startup sequence.

Understanding how a computer boots provides the foundation for operating system internals, malware analysis, incident response, digital forensics, and system hardening.

---

# Learning Objectives

After completing this module, I can:

* Explain what happens when a computer powers on.
* Describe the purpose of POST.
* Differentiate BIOS and UEFI.
* Compare MBR and GPT in relation to firmware.
* Explain the role of the bootloader.
* Differentiate GRUB and Windows Boot Manager.
* Describe how the kernel is loaded and initialized.
* Explain the role of `systemd` (Linux) during startup.
* Describe the Trusted Boot Chain.
* Explain Secure Boot.
* Differentiate bootkits and rootkits.
* Relate the complete boot process to cybersecurity investigations.

---

# Module Structure

## 01 – Computer Power-On & POST

**Learned:**

* Power-on sequence
* Firmware
* POST (Power-On Self-Test)
* Hardware initialization
* Boot device discovery

---

## 02 – BIOS vs UEFI

**Learned:**

* BIOS fundamentals
* UEFI fundamentals
* BIOS vs UEFI comparison
* MBR vs GPT relationship
* Secure Boot introduction

---

## 03 – Bootloader

**Learned:**

* Purpose of the bootloader
* Firmware to bootloader transition
* GRUB
* Windows Boot Manager
* Dual-boot systems

---

## 04 – Kernel Loading

**Learned:**

* Kernel fundamentals
* Bootloader to kernel transition
* Kernel initialization
* Memory management
* Process management
* Device drivers
* File systems
* Networking
* `systemd` / `init`

---

## 05 – Security During Boot

**Learned:**

* Trusted Boot Chain
* Secure Boot
* Bootkits
* Rootkits
* Boot process integrity

---

# Hands-on Skills Practiced

## Linux

```bash
dmesg | head
uname -r
uname -a
ps -p 1
ls /boot
ls /boot/grub*
cat /boot/grub/grub.cfg | head
findmnt
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "Legacy BIOS"
sudo parted -l
mokutil --sb-state
```

---

## Windows

* **System Information (`msinfo32`)**

  * BIOS Mode
  * BIOS Version
  * Secure Boot State
* **System Configuration (`msconfig`)**

  * Boot options
* **Disk Management**

  * MBR / GPT verification
* **Task Manager**

  * System process
* **BCDEdit**

  * Windows Boot Configuration Data (read-only)

---

# Security Mental Model

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
Bootloader
      │
      ▼
Kernel
      │
      ▼
systemd / Windows Initialization
      │
      ▼
Operating System Services
      │
      ▼
User Login
      │
      ▼
Applications
```

**Trusted Boot Chain**

Every stage depends on the integrity of the stage before it.

If firmware is compromised → the bootloader can be compromised.

If the bootloader is compromised → the kernel can be compromised.

If the kernel is compromised → the operating system can no longer be trusted.

Protecting the earliest stages of startup is therefore essential to maintaining the security of the entire system.

---

# Cybersecurity Relevance

The boot process forms the **root of trust** for every operating system.

This module demonstrated how firmware, bootloaders, and the kernel work together to establish a trusted startup sequence before any user applications or security software begin running.

Understanding the boot process enables security professionals to:

* Investigate startup failures.
* Verify firmware configuration.
* Detect bootkits and pre-boot malware.
* Understand Secure Boot.
* Analyze trusted boot chains.
* Perform incident response involving compromised systems.
* Build a strong foundation for malware analysis and operating system security.

These concepts are fundamental for both defensive and offensive cybersecurity roles because they explain how attackers attempt to gain control before the operating system is fully initialized.

---

# Key Takeaways

* The boot process begins with firmware, not the operating system.
* POST verifies that essential hardware is functioning correctly.
* UEFI replaces BIOS with improved performance and security.
* The bootloader loads the operating system's kernel into memory.
* The kernel initializes core operating system services and starts the first user-space process.
* Secure Boot helps prevent unauthorized boot components from executing.
* The Trusted Boot Chain ensures each stage verifies the integrity of the previous stage.
* Bootkits compromise the startup process, while rootkits compromise a running operating system.
* Understanding the boot process is essential for malware analysis, incident response, digital forensics, and system hardening.

---

# Portfolio Reflection

Completing this module fundamentally changed my understanding of how an operating system starts. I previously viewed the boot process as a simple transition from pressing the power button to reaching the desktop. I now understand that startup is a structured chain of trusted components, beginning with firmware, progressing through POST, the bootloader, and the kernel before finally initializing system services and user applications.

From a cybersecurity perspective, I learned that each stage of the boot process establishes trust for the next. Technologies such as UEFI and Secure Boot help protect this chain, while threats such as bootkits attempt to compromise it before the operating system and security software become active. This knowledge provides a strong foundation for understanding operating system internals, malware persistence, incident response, and digital forensics.
