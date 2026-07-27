# 🖥️ System Profiler

An interactive **Bash-based Linux System Profiler** designed to collect essential system information for **system administration**, **security baselining**, and **incident response**. The tool provides a menu-driven interface to inspect operating system details, CPU, memory, storage, running processes, open ports, and an overall system health assessment.

---

## 📖 Overview

System Profiler is a lightweight utility that gathers important information about a Linux system and generates a comprehensive report. It is intended for educational purposes and demonstrates how standard Linux utilities can be combined through Bash scripting to automate system profiling.

This project was developed as part of my cybersecurity learning journey to strengthen Linux administration, Bash scripting, and defensive security skills.

---

## ✨ Features

* Interactive menu-driven interface
* Operating System and host information
* CPU information
* Memory information
* Storage information
* Top CPU-consuming processes
* Top memory-consuming processes
* Open listening ports
* System summary
* Basic system health assessment
* Report generation with timestamp
* Automatic report storage in the `reports/` directory
* Graceful fallback when certain utilities are unavailable

---

## 🎯 Security Use Cases

This tool can assist with:

* System inventory and asset identification
* Initial incident response triage
* Security baselining
* Resource utilization monitoring
* Identifying exposed network services
* Reviewing running processes
* Quick host health assessment

> **Note:** This project is intended for defensive security, system administration, and educational use on systems you own or are authorized to assess.

---

## 🛠️ Technologies Used

* Bash
* Linux
* GNU Core Utilities
* systemd (`hostnamectl`)
* procfs (`/proc`)
* `lscpu`
* `free`
* `df`
* `ps`
* `ss`
* `netstat`
* `awk`
* `figlet` (optional)

---

## 📂 Project Structure

```text
System-Profiler/
├── system_profiler.sh
├── README.md
├── LICENSE
├── CHANGELOG.md
├── .gitignore
├── reports/
│   └── sample_report.txt
├── screenshots/
│   ├── menu.png
│   ├── full_report.png
│   └── system_health.png
└── docs/
    ├── Design.md
    ├── Security-Writeup.md
    └── Learning-Reflection.md
```

---

## ⚙️ Requirements

* Linux operating system
* Bash
* Standard GNU utilities

Recommended commands:

* hostnamectl
* lscpu
* free
* df
* ps
* ss (or netstat)
* awk
* figlet (optional)

---

## 🚀 Installation

```bash
git clone https://github.com/dravidmurugavel/cybersecurity-portfolio/projects/phase-0-foundation/computer-fundamentals/System-Profiler.git

cd System-Profiler

chmod +x system_profiler.sh

./system_profiler.sh
```

---

## 📋 Menu

```text
1. OS Information
2. CPU Information
3. Memory Information
4. Storage Information
5. Process Information
6. Port Information
7. Generate Full Report
8. Exit
```

---

## 📄 Generated Report

The generated report includes:

* Report timestamp
* Executing user
* Operating System
* CPU Information
* Memory Information
* Storage Information
* Process Information
* Port Information
* System Summary
* System Health Assessment

Reports are automatically saved in the **reports/** directory.

---

## 📸 Screenshots

Include screenshots demonstrating:

* Main menu
* OS Information
* Full generated report
* System Health section

---

## 📚 What I Learned

Through this project I gained practical experience with:

* Bash scripting
* Functions and modular programming
* Conditional execution
* Linux command-line utilities
* Process inspection
* Network socket inspection
* Parsing command output
* System profiling
* Security baselining
* Report generation

---

## 🔮 Future Improvements

* JSON report export
* CSV export
* Command-line arguments (`--all`, `--cpu`, etc.)
* Logging support
* Colorized reports
* Additional health checks
* Docker support
* Cross-distribution compatibility
* Hardware inventory
* Service status monitoring

---

## 📜 License

This project is licensed under the **MIT License**.

---

## 👨‍💻 Author

**Dravid Murugavel**

Cybersecurity | Linux | Bash Scripting | Blue Team | SOC | Incident Response

---

## ⭐ Acknowledgements

This project was built as part of my cybersecurity portfolio to demonstrate practical Linux administration, Bash scripting, and defensive security skills through hands-on projects.
