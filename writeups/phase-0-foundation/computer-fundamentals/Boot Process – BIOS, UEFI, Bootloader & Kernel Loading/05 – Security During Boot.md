# 05 – Security During Boot

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Boot Process – BIOS/UEFI, Bootloader & Kernel Loading

**Subtopic:** Security During Boot

**Estimated Study Time:** 30–45 Minutes

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* System Boot Process
* Cybersecurity Foundations
* Malware Analysis Fundamentals

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Threat Hunter
* Security Researcher

---

# Overview

The boot process establishes the foundation of trust for the entire operating system. Every stage of startup depends on the integrity of the previous stage. If an attacker compromises an early component, malicious code can execute before the operating system and security software become active.

Modern systems address this risk through technologies such as **Secure Boot**, which helps ensure that only trusted boot components are executed. Understanding boot security is essential for defending against advanced threats such as bootkits and for maintaining the integrity of the operating system.

---

# Why This Matters in Cybersecurity

The boot process occurs before antivirus software, endpoint detection, and most security controls begin running.

Attackers who compromise firmware, the bootloader, or other early boot components can gain highly privileged access and establish persistent malware that is difficult to detect and remove.

Security professionals rely on boot security concepts to:

* Protect the trusted boot chain.
* Detect boot-level malware.
* Verify firmware integrity.
* Investigate startup-related compromises.
* Harden enterprise systems against pre-boot attacks.

---

# Core Concepts

## Trusted Boot Chain

The **Trusted Boot Chain** is the sequence of startup components in which each stage relies on the integrity of the previous one.

```text id="fr9zj8"
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
Applications
```

If any component in this chain is compromised, every subsequent stage can also become compromised.

Maintaining the integrity of the trusted boot chain is fundamental to system security.

---

## Secure Boot

**Secure Boot** is a security feature provided by **UEFI** firmware.

Before executing boot components, Secure Boot verifies their digital signatures against trusted certificates.

If a component has been modified or is not trusted, Secure Boot can prevent it from loading.

Its primary objective is to stop unauthorized code from executing before the operating system starts.

---

## Bootkits

A **bootkit** is malware that targets the boot process.

Common targets include:

* Firmware
* Bootloader
* Early kernel loading

Because bootkits execute before the operating system and most security software, they are particularly difficult to detect and remove.

Bootkits often provide attackers with long-term persistence and privileged access to compromised systems.

---

## Bootkit vs Rootkit

Although both attempt to evade detection, they operate at different stages.

| Bootkit                                  | Rootkit                                   |
| ---------------------------------------- | ----------------------------------------- |
| Targets the boot process                 | Targets the running operating system      |
| Executes before the OS starts            | Executes after the OS starts              |
| Often infects firmware or the bootloader | Commonly operates in kernel or user space |
| Focuses on startup persistence           | Focuses on hiding malicious activity      |

Understanding this distinction is important during malware analysis and incident response.

---

# Hands-on Lab

## Linux

Check whether the system uses UEFI:

```bash id="zrwd0u"
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "Legacy BIOS"
```

If available, verify Secure Boot status:

```bash id="jqvpf8"
mokutil --sb-state
```

---

## Windows

Open **System Information (`msinfo32`)**.

Review:

* BIOS Mode
* Secure Boot State

Verify whether Secure Boot is enabled on the system.

---

# Real-World Security Example

During an incident response investigation, analysts discover that a workstation continues to execute malicious code immediately after power-on, even after the operating system has been reinstalled.

Further analysis reveals that the system's bootloader was modified by a bootkit. Because the malicious code executes before the operating system loads, traditional endpoint security solutions never observe the initial compromise.

If Secure Boot had detected the unauthorized modification, the compromised bootloader would have failed verification and the attack could have been prevented before execution.

This illustrates why protecting the trusted boot chain is essential for maintaining system integrity.

---

# Key Learnings

After completing this topic, I understand:

* The concept of the Trusted Boot Chain.
* The purpose of Secure Boot.
* How Secure Boot protects the startup process.
* What a bootkit is.
* The difference between a bootkit and a rootkit.
* Why boot process integrity is critical for cybersecurity.

---

# Learning Outcome

After completing this topic, I can:

* Explain the Trusted Boot Chain.
* Describe how Secure Boot verifies trusted boot components.
* Differentiate bootkits from rootkits.
* Explain why early boot attacks are difficult to detect.
* Relate boot security concepts to malware analysis, incident response, and enterprise system hardening.

---

# Portfolio Reflection

Before learning boot security, I viewed the startup process as a sequence of components that simply loaded the operating system. I now understand that each stage forms part of a trusted boot chain, where the integrity of one component directly affects every stage that follows.

I also learned how UEFI Secure Boot strengthens this chain by verifying the digital signatures of boot components before execution. Most importantly, I recognize why attackers target firmware and bootloaders with bootkits. Because these attacks occur before the operating system and security software become active, they can achieve persistence and evade traditional detection methods, making boot security a critical aspect of modern cybersecurity.
