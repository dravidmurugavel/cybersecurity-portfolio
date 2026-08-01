# Virtualisation: Hypervisors, Virtual Machines & Containers

## Module Overview

This module introduced the fundamentals of virtualization and its role in modern cybersecurity. I learned how multiple operating systems and applications can safely share the same physical hardware while remaining isolated from one another. The module progressed from understanding virtualization concepts to applying them in realistic cybersecurity scenarios involving malware analysis, penetration testing, cloud computing, and application deployment.

Rather than treating virtualization as simply a way to run multiple operating systems, I now understand it as a core security technology that enables safe testing environments, efficient resource utilization, and scalable infrastructure used across enterprise networks and cloud platforms.

---

# Learning Objectives

After completing this module, I can:

* Explain the purpose of virtualization.
* Describe the role of a hypervisor.
* Differentiate between Type 1 and Type 2 hypervisors.
* Explain how virtual machines work.
* Identify common virtual hardware components.
* Explain the purpose of VM snapshots and cloning.
* Describe how containers work.
* Differentiate between virtual machines and containers.
* Select the appropriate virtualization technology for different cybersecurity scenarios.

---

# Topics Covered

## 01 – Virtualisation Fundamentals

* Purpose of virtualization.
* Host Operating System.
* Guest Operating System.
* Benefits of virtualization.
* Importance in cybersecurity.

**Key Takeaway**

Virtualization allows multiple isolated operating systems to safely share the same physical hardware, making it essential for cybersecurity laboratories, malware analysis, and penetration testing.

---

## 02 – Hypervisors

* What a hypervisor is.
* Resource management.
* Type 1 Hypervisors.
* Type 2 Hypervisors.
* Enterprise vs personal usage.

**Key Takeaway**

A hypervisor is the software layer that creates, manages, and isolates virtual machines while allocating physical hardware resources.

---

## 03 – Virtual Machines

* Virtual Machine architecture.
* Virtual hardware.
* Snapshots.
* Cloning.
* Safe malware analysis.

**Key Takeaway**

Virtual machines provide strong isolation by running independent Guest Operating Systems, making them ideal for malware analysis, digital forensics, penetration testing, and incident response.

---

## 04 – Containers

* Container architecture.
* Container images.
* Shared Host OS kernel.
* Container engines.
* Lightweight application isolation.

**Key Takeaway**

Containers virtualize applications rather than entire computers, providing fast startup, efficient resource usage, and consistent software deployment for cloud-native environments.

---

## 05 – Capstone: Choosing the Right Technology

The capstone combined all concepts into a realistic cybersecurity scenario involving malware analysis and virtualization technology selection.

Key decisions included:

* Selecting a Virtual Machine for malware analysis.
* Choosing a Type 2 hypervisor for a personal cybersecurity lab.
* Creating snapshots before executing suspicious software.
* Restoring the laboratory after analysis.
* Identifying situations where containers are a better choice than virtual machines.

**Key Takeaway**

The correct virtualization technology depends on the security objective. Virtual machines prioritize isolation, while containers prioritize efficiency and application deployment.

---

# Cybersecurity Applications

The knowledge gained in this module directly supports:

* Malware Analysis
* Reverse Engineering
* Digital Forensics
* Incident Response
* Penetration Testing
* Active Directory Laboratories
* Cloud Security
* DevSecOps
* Container Security

Virtualization allows security professionals to investigate threats, reproduce attacks, and recover systems quickly without exposing production environments to unnecessary risk.

---

# Mental Model

```text
                    Physical Hardware
                           │
                    Host Operating System
                           │
                    ┌───────────────┐
                    │               │
             Hypervisor        Container Engine
                    │               │
          ┌─────────┴─────────┐     │
          ▼                   ▼     ▼
      Virtual Machine     Virtual Machine   Containers
      (Guest OS)          (Guest OS)      (Share Host Kernel)
```

**Remember:**

* **Hypervisor → Creates Virtual Machines**
* **Virtual Machine → Virtualizes an entire computer**
* **Container Engine → Creates Containers**
* **Container → Virtualizes an application**

---

# Skills Acquired

After completing this module, I can confidently:

* Build a secure cybersecurity lab using virtualization.
* Choose between Type 1 and Type 2 hypervisors.
* Configure and manage virtual machines.
* Use snapshots and cloning to improve laboratory efficiency.
* Explain container architecture and container images.
* Differentiate between Virtual Machines and Containers.
* Select the appropriate technology for malware analysis, cloud workloads, and security testing.

---

# Portfolio Reflection

This module changed the way I think about virtualization. Initially, I viewed virtual machines and containers as similar technologies. I now understand that they serve different purposes. Virtual machines emulate complete computers with independent operating systems and provide strong isolation, making them the preferred choice for malware analysis and high-risk security testing. Containers, on the other hand, package applications with their dependencies while sharing the Host Operating System's kernel, making them ideal for cloud-native applications, DevSecOps, and efficient software deployment.

The capstone exercise reinforced that cybersecurity professionals must choose technologies based on the security objective rather than convenience. This practical understanding has given me a solid foundation for future topics such as cloud security, Active Directory, malware analysis, and modern enterprise infrastructure.
