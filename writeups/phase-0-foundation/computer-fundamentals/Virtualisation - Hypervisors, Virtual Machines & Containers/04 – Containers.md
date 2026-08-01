# 04 – Containers

**Phase:** Phase 0 – Computer Fundamentals

**Module:** Virtualisation: Hypervisors, Virtual Machines & Containers

**Subtopic:** Containers

**Estimated Study Time:** 30–45 Minutes

**Skill Category:**

* Computer Fundamentals
* Operating Systems
* Virtualisation
* Cloud Computing
* Cybersecurity Foundations

**Relevant Job Roles:**

* SOC Analyst
* Incident Responder
* Malware Analyst
* DevSecOps Engineer
* Cloud Security Engineer
* Application Security Engineer
* Penetration Tester

---

# Overview

A **container** is an isolated application environment that packages an application together with its required libraries, dependencies, and runtime. Unlike a virtual machine, a container does not include a complete Guest Operating System. Instead, it shares the Host Operating System's kernel while maintaining isolation from other containers.

Containers are lightweight, portable, and start within seconds, making them ideal for modern software development, cloud computing, and DevSecOps. Their efficiency has made container technology a core component of enterprise infrastructure and cloud-native applications.

---

# Why This Matters in Cybersecurity

Containers are widely used in cloud platforms, CI/CD pipelines, Kubernetes environments, and modern enterprise applications. Security professionals routinely encounter containers while performing cloud security assessments, application security reviews, incident response, and vulnerability management.

Understanding how containers work helps analysts investigate compromised workloads, identify insecure container configurations, and understand the risks associated with container escape vulnerabilities.

---

# Core Concepts

## What is a Container?

A **container** is an isolated application environment that packages:

* Application code
* Required libraries
* Dependencies
* Runtime

Unlike a virtual machine, a container does not run its own Guest Operating System.

Instead, all containers running on the same host share the Host Operating System's kernel while remaining isolated from one another.

---

## Containers vs Virtual Machines

A Virtual Machine contains:

* Guest Operating System
* Virtual Hardware
* Applications

A Container contains:

* Application
* Libraries
* Dependencies

Containers rely on the Host Operating System kernel instead of booting a separate operating system.

This significantly reduces startup time and resource consumption.

---

## Container Images

A **container image** is a read-only template used to create containers.

A container image contains:

* Application code
* Required libraries
* Runtime
* Configuration files
* Dependencies

An image acts as a blueprint from which multiple identical containers can be created.

One image can generate many independent container instances.

---

## Why Containers Start Faster

Virtual machines require:

* Booting a Guest Operating System.
* Initializing virtual hardware.
* Starting operating system services.

Containers simply start the application because they already share the Host Operating System kernel.

As a result, containers:

* Launch within seconds.
* Require less RAM.
* Consume less storage.
* Support higher application density on the same hardware.

---

## Container Engine

A **container engine** is responsible for creating and managing containers.

Examples include:

* Docker
* Podman
* containerd

The container engine interacts with the Host Operating System kernel and provides the environment required for containers to execute.

Unlike virtual machines, containers do not require a hypervisor to virtualize an entire operating system.

---

# Hands-on Lab

If Docker is installed:

Display container images:

```bash id="y0x6lz"
docker images
```

Display running containers:

```bash id="d5bryo"
docker ps
```

Observe:

* Available images.
* Running containers.
* Container IDs.
* Resource efficiency.

If Docker is not installed, identify:

* Your Host Operating System.
* Whether containers have their own Guest Operating System.
* Why one Host Operating System can efficiently run many containers.

---

# Real-World Security Example

A DevSecOps team deploys a web application using Docker containers.

Instead of installing the application manually on every server, the team creates a single container image containing:

* Application code.
* Required libraries.
* Runtime environment.
* Configuration.

The same image is deployed consistently across development, testing, and production.

Security teams scan the container image for vulnerabilities before deployment and continuously monitor running containers for suspicious activity.

Unlike malware analysis, which is typically performed inside virtual machines for stronger isolation, containers are primarily used to package and deploy applications efficiently in cloud and enterprise environments.

---

# Key Learnings

After completing this topic, I understand:

* What a container is.
* How containers differ from virtual machines.
* What a container image is.
* Why containers start faster than virtual machines.
* The role of a container engine.
* Why containers are widely used in cloud computing and cybersecurity.

---

# Learning Outcome

After completing this topic, I can:

* Explain how containers work.
* Differentiate containers from virtual machines.
* Describe the purpose of container images.
* Explain why containers provide lightweight application isolation.
* Relate containers to cloud security, DevSecOps, and enterprise application deployment.

---

# Portfolio Reflection

Before learning about containers, I assumed they were simply smaller virtual machines. I now understand that containers and virtual machines solve different problems. A virtual machine virtualizes an entire computer, while a container virtualizes an application by sharing the Host Operating System's kernel instead of running its own Guest Operating System.

I also learned how container images act as reusable templates, why containers start significantly faster than virtual machines, and why they are widely adopted in cloud computing and DevSecOps. From a cybersecurity perspective, I understand that containers provide efficient application isolation but rely on the Host OS kernel, making kernel security and protection against container escape vulnerabilities important considerations in modern enterprise environments.
