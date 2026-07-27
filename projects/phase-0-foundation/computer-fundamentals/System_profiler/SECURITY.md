# Security Policy

## Purpose

**System Profiler** is a Bash-based Linux system profiling tool developed for **educational purposes**, **system administration**, and **defensive cybersecurity**. It provides a quick overview of a Linux system by collecting read-only system information using standard Linux utilities.

---

## Intended Use

This project is intended for use on:

* Systems you own.
* Systems you administer.
* Systems where you have explicit authorization to perform system administration or security assessments.

The tool is designed to support:

* System inventory
* Security baselining
* Incident response preparation
* Linux administration
* Cybersecurity education

---

## Security Design

The project follows several secure engineering principles:

* Read-only information collection
* Modular Bash scripting
* Minimal external dependencies
* Graceful fallback mechanisms
* Human-readable report generation

The script does **not** modify system configurations, change permissions, install software, or perform intrusive operations.

---

## Responsible Disclosure

If you discover a bug or security-related issue in this project, please open a GitHub Issue with:

* A description of the issue
* Steps to reproduce it
* Expected and actual behavior
* Relevant logs or screenshots (if applicable)

Please avoid publicly disclosing security issues until they have been reviewed.

---

## Disclaimer

This project is provided **as is**, without warranty of any kind. It is intended as a learning resource and portfolio project demonstrating Bash scripting, Linux system administration, and defensive cybersecurity concepts.

Users are responsible for ensuring the tool is used in a lawful, ethical, and authorized manner.
