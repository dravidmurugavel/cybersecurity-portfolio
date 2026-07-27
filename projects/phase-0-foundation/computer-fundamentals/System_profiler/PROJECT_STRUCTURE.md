# Project Structure

```text
System-Profiler/
│
├── system_profiler.sh          # Main Bash application
├── README.md                   # Project overview and usage guide
├── LICENSE                     # MIT License
├── CHANGELOG.md                # Version history
├── CONTRIBUTING.md             # Contribution guidelines
├── SECURITY.md                 # Security policy
├── .gitignore                  # Git ignore rules
│
├── docs/
│   ├── Design.md               # System architecture and design decisions
│   ├── Security-Writeup.md     # Cybersecurity relevance and use cases
│   └── Learning-Reflection.md  # Personal learning outcomes
│
├── reports/
│   └── sample_report.txt       # Example generated report
│
└── screenshots/
    ├── menu.png                # Main menu
    ├── full_report.png         # Generated report
    └── system_health.png       # System health summary
```

---

# Repository Overview

## `system_profiler.sh`

The main Bash application that collects system information, displays an interactive menu, and generates system profiling reports.

---

## `README.md`

Provides an overview of the project, installation instructions, usage examples, screenshots, and project objectives.

---

## `LICENSE`

Specifies the licensing terms under the MIT License.

---

## `CHANGELOG.md`

Tracks project versions and notable changes.

---

## `CONTRIBUTING.md`

Provides guidelines for reporting issues, suggesting improvements, and contributing to the project.

---

## `SECURITY.md`

Describes the intended use of the project, responsible disclosure process, and security considerations.

---

## `docs/`

Contains supporting documentation explaining the project's design, cybersecurity relevance, and development journey.

---

## `reports/`

Contains a sample system profiling report. Generated reports are excluded from version control through `.gitignore`.

---

## `screenshots/`

Contains images demonstrating the application's interface and generated reports.

---

# Design Philosophy

The repository is organized to separate:

* Source code
* Documentation
* Sample outputs
* Project assets

This structure improves readability, maintainability, and ease of navigation for contributors and reviewers.

---

# Purpose

The repository demonstrates practical skills in:

* Bash scripting
* Linux system administration
* System profiling
* Defensive cybersecurity
* Software documentation
* Modular project organization
