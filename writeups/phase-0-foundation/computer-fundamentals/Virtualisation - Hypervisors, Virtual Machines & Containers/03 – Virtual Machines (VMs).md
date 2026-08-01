# 03 – Virtual Machines (VMs)

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Virtualisation: Hypervisors, Virtual Machines & Containers

**Subtopic:** Virtual Machines (VMs)

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

A **Virtual Machine (VM)** is an isolated virtual computer created and managed by a hypervisor. It behaves like a physical computer while using virtual hardware backed by the physical resources of the host machine.

Each virtual machine has its own operating system, applications, storage, memory, and network configuration. Multiple virtual machines can run simultaneously on a single physical computer while remaining isolated from one another.

Virtual machines are widely used in cybersecurity because they provide safe, repeatable, and easily recoverable environments for malware analysis, penetration testing, digital forensics, and security research.

---

# Why This Matters in Cybersecurity

Cybersecurity professionals constantly work with potentially dangerous software and vulnerable systems. Running these directly on a production workstation would expose the host system to unnecessary risk.

Virtual machines provide isolated environments where analysts can safely:

* Execute malware.
* Practice penetration testing.
* Build Active Directory laboratories.
* Perform digital forensic investigations.
* Simulate incident response scenarios.
* Restore systems to a known clean state after experiments.

This isolation makes virtual machines one of the most important tools in modern cybersecurity.

---

# Core Concepts

## What is a Virtual Machine?

A **Virtual Machine (VM)** is a software-based computer that runs inside a hypervisor.

Although it is virtual, it behaves like a physical computer and can:

* Install an operating system.
* Execute applications.
* Store files.
* Connect to networks.
* Run background services.

Each VM operates independently from other virtual machines and the host operating system.

---

## Virtual Hardware

Every virtual machine is provided with virtual hardware by the hypervisor.

Common virtual hardware includes:

* Virtual CPU (vCPU)
* Virtual RAM (vRAM)
* Virtual Hard Disk (VHD, VMDK, etc.)
* Virtual Network Interface Card (vNIC)
* Virtual Graphics Adapter
* Virtual BIOS or UEFI
* Virtual DVD/ISO Drive

The Guest Operating System recognizes these components as if they were real physical hardware.

---

## VM Snapshots

A **snapshot** captures the complete state of a virtual machine at a specific point in time.

A snapshot may include:

* Virtual disk contents.
* Installed applications.
* System configuration.
* Operating system state.
* Memory state (depending on the hypervisor).

If the virtual machine becomes unstable or infected, the snapshot can be restored to return the system to its previous state.

Snapshots provide fast recovery without reinstalling the operating system.

---

## VM Cloning

**Cloning** creates an independent copy of an existing virtual machine.

The cloned VM contains:

* The operating system.
* Installed software.
* System configuration.
* Virtual hardware settings.

Cloning allows multiple laboratory environments to be created without repeating the installation and configuration process.

For example, a single Windows Server virtual machine can be cloned into separate environments for:

* Active Directory practice.
* Malware analysis.
* Digital forensics.
* Incident response exercises.

---

# Hands-on Lab

Using your virtualization platform (VirtualBox or VMware), identify:

* Number of virtual CPUs assigned.
* Amount of virtual RAM allocated.
* Virtual disk size.
* Network configuration (NAT or Bridged).
* Existing VM snapshots (if any).

Observe how these resources differ from the physical hardware of the host machine.

---

# Real-World Security Example

A malware analyst receives a suspicious executable for investigation.

The analyst launches a Kali Linux virtual machine and first creates a **snapshot** named **Clean State**.

The malware is then executed while monitoring:

* Running processes.
* File creation.
* Network connections.
* Registry changes (Windows guests).
* System behavior.

After completing the investigation, the analyst restores the **Clean State** snapshot, instantly returning the virtual machine to its original condition without reinstalling the operating system.

For larger security laboratories, the analyst can create **clones** of the original VM to build multiple testing environments while preserving the original configuration.

---

# Key Learnings

After completing this topic, I understand:

* What a virtual machine is.
* How virtual machines differ from physical computers.
* The purpose of virtual hardware.
* The role of VM snapshots.
* The purpose of VM cloning.
* Why virtual machines are widely used in cybersecurity.

---

# Learning Outcome

After completing this topic, I can:

* Explain how a virtual machine operates.
* Identify the common virtual hardware assigned to a VM.
* Explain the purpose of snapshots and cloning.
* Describe how virtual machines provide isolation.
* Relate virtual machines to malware analysis, penetration testing, incident response, and digital forensics.

---

# Portfolio Reflection

Before learning about virtual machines, I understood that virtualization allowed multiple operating systems to run on one physical computer, but I did not understand how an individual virtual machine functioned. I now understand that a virtual machine is an isolated virtual computer with its own virtual hardware, operating system, and applications, all managed by a hypervisor.

I also learned how snapshots allow rapid recovery to a known clean state and how cloning enables the creation of multiple laboratory environments without repeating installation and configuration. These features make virtual machines indispensable for malware analysis, penetration testing, digital forensics, and security research, where isolation and repeatability are critical.
