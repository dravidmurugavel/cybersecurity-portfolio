# 02 – Hypervisors (Type 1 vs Type 2)

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Virtualisation: Hypervisors, Virtual Machines & Containers

**Subtopic:** Hypervisors (Type 1 vs Type 2)

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

A **hypervisor** is the software layer responsible for creating, running, and managing virtual machines. It allows multiple operating systems to share the same physical hardware while ensuring each virtual machine remains isolated and receives its allocated resources.

Hypervisors provide virtual hardware—including virtual CPUs, memory, storage, and network interfaces—allowing every virtual machine to behave like an independent physical computer.

Modern virtualization platforms are built around two architectures: **Type 1 (Bare-Metal)** and **Type 2 (Hosted)** hypervisors. Understanding their differences is essential for enterprise infrastructure, cloud computing, and cybersecurity laboratories.

---

# Why This Matters in Cybersecurity

Hypervisors form the trust boundary between the physical machine and virtual machines.

Security professionals rely on hypervisors to:

* Build isolated penetration testing labs.
* Analyze malware safely.
* Create reproducible incident response environments.
* Host multiple operating systems on a single computer.
* Separate production workloads from testing environments.

Understanding how hypervisors manage resources and isolation helps explain why virtualization is trusted for security research and enterprise infrastructure.

---

# Core Concepts

## What is a Hypervisor?

A **hypervisor** is software that creates, manages, and runs virtual machines.

Its primary responsibilities include:

* Creating virtual machines.
* Allocating CPU resources.
* Allocating memory (RAM).
* Managing virtual storage.
* Providing virtual network adapters.
* Maintaining isolation between virtual machines.

Without a hypervisor, multiple operating systems could not safely share the same physical hardware.

---

## Why is a Hypervisor Required?

If multiple operating systems attempted to directly control the same physical hardware, several conflicts would occur:

* Memory allocation conflicts.
* CPU scheduling conflicts.
* Storage access conflicts.
* Device access conflicts.

The hypervisor prevents these problems by acting as the resource manager between virtual machines and the underlying hardware.

It ensures each virtual machine receives controlled access to physical resources while remaining isolated from other virtual machines.

---

## Type 1 Hypervisor (Bare-Metal)

A **Type 1 Hypervisor** runs directly on the physical hardware without requiring a Host Operating System.

Architecture:

```text id="7w6mbu"
Physical Hardware
        │
        ▼
Type 1 Hypervisor
        │
   ┌────┴────┐
   ▼         ▼
 VM 1      VM 2
```

Characteristics:

* No Host Operating System.
* High performance.
* Strong isolation.
* Lower resource overhead.
* Designed for enterprise infrastructure.

Common examples:

* VMware ESXi
* Microsoft Hyper-V Server
* Xen

Type 1 hypervisors are widely used in:

* Data centers.
* Cloud platforms.
* Enterprise virtualization.
* Production servers.

---

## Type 2 Hypervisor (Hosted)

A **Type 2 Hypervisor** runs as an application on top of an existing Host Operating System.

Architecture:

```text id="vjlwmq"
Physical Hardware
        │
        ▼
Host Operating System
        │
        ▼
Type 2 Hypervisor
        │
   ┌────┴────┐
   ▼         ▼
 VM 1      VM 2
```

Characteristics:

* Requires a Host Operating System.
* Easy installation.
* Simple management.
* Slightly higher overhead than Type 1.
* Ideal for personal computers and laboratories.

Common examples:

* Oracle VirtualBox
* VMware Workstation
* VMware Fusion

Type 2 hypervisors are commonly used for:

* Cybersecurity labs.
* Malware analysis.
* Learning operating systems.
* Software testing.
* Development environments.

---

## Type 1 vs Type 2 Comparison

| Feature                | Type 1            | Type 2                |
| ---------------------- | ----------------- | --------------------- |
| Runs On                | Physical hardware | Host Operating System |
| Host OS Required       | No                | Yes                   |
| Performance            | Higher            | Slightly lower        |
| Resource Overhead      | Lower             | Higher                |
| Enterprise Servers     | Yes               | Rarely                |
| Personal Labs          | Rarely            | Very common           |
| Cybersecurity Training | Limited           | Widely used           |

---

# Hands-on Lab

Identify your virtualization environment.

Determine:

* Your Host Operating System.
* Your Guest Operating System.
* The hypervisor you are using.
* Whether it is Type 1 or Type 2.

Example:

* Host OS: Windows 11
* Hypervisor: Oracle VirtualBox
* Type: Type 2
* Guest OS: Kali Linux

Explain why this environment is suitable for your cybersecurity laboratory.

---

# Real-World Security Example

A penetration tester uses a Windows laptop as the Host Operating System with Oracle VirtualBox installed as a Type 2 hypervisor.

Inside VirtualBox, the tester runs:

* Kali Linux
* Windows Server
* Windows 11
* Ubuntu

Each operating system functions independently while sharing the same physical hardware.

Snapshots allow the tester to quickly restore compromised virtual machines after malware execution or exploitation exercises, making Type 2 hypervisors ideal for cybersecurity training and laboratory environments.

In contrast, cloud providers and enterprise data centers typically use Type 1 hypervisors to host hundreds or thousands of virtual machines with maximum performance and strong isolation.

---

# Key Learnings

After completing this topic, I understand:

* What a hypervisor is.
* Why hypervisors are required.
* The responsibilities of a hypervisor.
* The differences between Type 1 and Type 2 hypervisors.
* Where each hypervisor type is commonly used.

---

# Learning Outcome

After completing this topic, I can:

* Explain the purpose of a hypervisor.
* Differentiate between Type 1 and Type 2 hypervisors.
* Describe how hypervisors allocate hardware resources.
* Explain why Type 1 hypervisors are preferred in enterprise environments.
* Explain why Type 2 hypervisors are commonly used for cybersecurity laboratories.

---

# Portfolio Reflection

Before learning about hypervisors, I understood that virtualization allowed multiple operating systems to run on a single computer, but I did not know which component managed those virtual machines. I now understand that the hypervisor is the software layer responsible for creating, managing, and isolating virtual machines while allocating physical hardware resources.

I also learned the architectural differences between Type 1 and Type 2 hypervisors. I understand why enterprises and cloud providers rely on Type 1 hypervisors for performance and scalability, while cybersecurity professionals frequently use Type 2 hypervisors to build safe, flexible, and easily recoverable laboratory environments for malware analysis, penetration testing, and security research.
