# 01 – Virtualisation Fundamentals

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Virtualisation: Hypervisors, Virtual Machines & Containers

**Subtopic:** Virtualisation Fundamentals

**Estimated Study Time:** 30–45 Minutes

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* Virtualisation
* Cybersecurity Foundations

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* Digital Forensics Analyst
* Penetration Tester
* Threat Hunter
* Cloud Security Engineer

---

# Overview

**Virtualisation** is a technology that creates virtual computers, allowing multiple operating systems to run independently on a single physical computer. Instead of requiring separate physical machines, virtualization enables isolated environments that share the same underlying hardware while behaving like independent computers.

Each virtual machine operates with its own operating system, memory, storage, and applications, providing a secure and flexible platform for testing, development, malware analysis, and cybersecurity laboratories.

Today, virtualization is a fundamental technology in enterprise infrastructure, cloud computing, and cybersecurity operations.

---

# Why This Matters in Cybersecurity

Cybersecurity professionals frequently execute untrusted code, analyze malware, perform penetration testing, and investigate incidents. Performing these activities directly on a production or personal computer introduces significant risk.

Virtualisation provides isolated environments where security professionals can safely:

* Analyze malware.
* Build penetration testing labs.
* Test suspicious software.
* Reproduce attacks.
* Practice exploitation techniques.
* Restore systems to a clean state using snapshots.

Isolation makes virtualization one of the most valuable technologies in modern cybersecurity.

---

# Core Concepts

## What is Virtualisation?

Virtualisation is the process of creating a **virtual computer** that behaves like a physical computer while sharing the hardware resources of the host machine.

Rather than purchasing multiple physical systems, a single computer can host multiple independent operating systems running simultaneously.

Each virtual machine functions as if it were a separate physical computer.

---

## Why Was Virtualisation Created?

Before virtualization, organizations often required separate physical computers for different operating systems, applications, or testing environments.

This resulted in:

* Increased hardware costs.
* Poor hardware utilization.
* Higher maintenance requirements.
* Reduced flexibility.

Virtualisation solved these problems by allowing multiple isolated operating systems to share the same physical hardware, improving efficiency while reducing infrastructure costs.

---

## Host OS

The **Host Operating System** is the operating system installed directly on the physical computer.

Examples include:

* Windows 11
* Kali Linux
* Ubuntu
* macOS

The Host OS manages the physical hardware and provides computing resources to the virtualization platform.

---

## Guest OS

A **Guest Operating System** is an operating system running inside a virtual machine.

The Guest OS uses virtual hardware provided by the virtualization platform while consuming physical resources such as CPU, memory, and storage from the host machine.

Examples include:

* Kali Linux running inside VirtualBox on Windows.
* Windows 11 running inside VMware on Ubuntu.
* Ubuntu running inside Hyper-V on Windows.

From the Guest OS perspective, it behaves like a normal physical computer.

---

## Isolation

The primary advantage of virtualization is **isolation**.

Each virtual machine operates independently from the host system and other virtual machines.

Activities performed inside one virtual machine generally do not affect the host operating system.

This isolation enables security professionals to safely experiment with malware, exploit vulnerable systems, and test software in controlled environments.

Although virtualization provides strong isolation, it is not absolute. Advanced vulnerabilities such as **VM escape** may allow an attacker to break out of a virtual machine into the host system, although such attacks are uncommon and typically require specific conditions.

---

# Hands-on Lab

## Linux

Display operating system information:

```bash id="5mxxgy"
hostnamectl
```

Identify:

* Your Host Operating System.
* Your Guest Operating System.
* Why you use Kali Linux inside a virtual machine instead of installing it directly on your primary computer.

---

# Real-World Security Example

A malware analyst receives a suspicious executable for investigation.

Rather than executing it on a production workstation, the analyst launches a Kali Linux virtual machine inside VirtualBox.

The malware is executed inside the isolated environment while monitoring:

* File creation.
* Registry modifications (Windows guests).
* Network activity.
* Running processes.
* System calls.

If the virtual machine becomes infected, the analyst simply restores a previous snapshot and returns the environment to a known clean state without affecting the host operating system.

This safe and repeatable workflow makes virtualization an essential technology for malware analysis and incident response.

---

# Key Learnings

After completing this topic, I understand:

* What virtualization is.
* Why virtualization was created.
* The difference between a Host OS and a Guest OS.
* Why isolation is the primary advantage of virtualization.
* Why virtualization is fundamental in cybersecurity.

---

# Learning Outcome

After completing this topic, I can:

* Explain the purpose of virtualization.
* Differentiate between Host and Guest operating systems.
* Describe how virtualization enables multiple operating systems to share one physical computer.
* Explain the importance of isolation in secure computing.
* Relate virtualization to malware analysis, penetration testing, and cybersecurity laboratories.

---

# Portfolio Reflection

Before studying virtualization, I understood that multiple operating systems could run on a single computer, but I did not fully understand how this was achieved or why it is so important in cybersecurity. I now understand that virtualization creates isolated virtual computers that share the hardware of a physical machine while operating independently.

I also learned the roles of the Host OS and Guest OS, and why isolation makes virtualization essential for malware analysis, penetration testing, incident response, and security research. This knowledge provides the foundation for understanding hypervisors, virtual machines, containers, and cloud computing in future modules.
