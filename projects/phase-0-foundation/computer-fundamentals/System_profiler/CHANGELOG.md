# Changelog

All notable changes to this project will be documented in this file.

This project follows a simple versioning approach inspired by [Keep a Changelog](https://keepachangelog.com/).

---

## [1.0.0] - 2026-07-27

### Added

* Interactive menu-driven interface
* Operating System information module
* CPU information module
* Memory information module
* Storage information module
* Process information module
* Network port information module
* Full system report generation
* Report export to the `reports/` directory
* System summary section
* System health assessment
* Automatic report timestamping
* Report execution metadata (date and user)
* `hostnamectl` with `uname -a` fallback
* `lscpu` with `/proc/cpuinfo` fallback
* `ss` with `netstat` fallback
* Optional `figlet` banner
* Modular Bash functions
* Command availability checks
* MIT License
* Project documentation

### Security

* Collects host inventory information for security baselining.
* Displays listening ports for network exposure awareness.
* Lists top CPU and memory consuming processes.
* Performs basic host health checks.

---

## Planned

* Command-line arguments (`--all`, `--cpu`, etc.)
* JSON report export
* CSV report export
* Service status reporting
* Logged-in user information
* Cron job inspection
* Network interface information
* Kernel module inspection
* Hardware inventory improvements
* Cross-distribution compatibility
* Enhanced health scoring
* Automated ShellCheck integration
