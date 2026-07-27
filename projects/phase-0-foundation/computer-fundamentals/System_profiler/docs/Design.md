# System Profiler – Design Documentation

## 1. Purpose

The System Profiler is a Bash-based utility designed to collect essential Linux system information through a simple interactive interface. It provides administrators and cybersecurity practitioners with a quick overview of a host's configuration, running processes, network exposure, and overall system health.

The project was developed to strengthen Bash scripting skills while applying Linux administration concepts in a practical cybersecurity context.

---

# 2. Design Goals

The project was designed with the following objectives:

* Keep the implementation simple and easy to understand.
* Use only standard Linux utilities whenever possible.
* Follow a modular function-based architecture.
* Produce human-readable reports.
* Support graceful fallback when preferred commands are unavailable.
* Demonstrate defensive security and system administration concepts.

---

# 3. Architecture

The application follows a modular design where each function is responsible for collecting a specific category of system information.

```text
                    +------------------+
                    |      Banner      |
                    +---------+--------+
                              |
                              v
                    +------------------+
                    |   Main Menu      |
                    +---------+--------+
                              |
      ---------------------------------------------------------
      |        |         |         |         |         |       |
      v        v         v         v         v         v       v
 OS Info   CPU Info  Memory   Storage  Process   Port Info  Full Report
                                                    |
                                                    v
                                          Summary & Health Check
```

---

# 4. Module Overview

## Banner Module

Displays the application banner using **figlet** when available and falls back to a plain-text banner otherwise.

---

## OS Information

Collects operating system and host information.

Primary command:

* `hostnamectl`

Fallback:

* `uname -a`

---

## CPU Information

Collects processor details.

Primary command:

* `lscpu`

Fallback:

* `/proc/cpuinfo`

---

## Memory Information

Displays RAM and swap usage.

Primary command:

* `free -h`

Fallback:

* `/proc/meminfo`

---

## Storage Information

Displays mounted filesystems and storage utilization.

Command used:

* `df -hT`

---

## Process Information

Displays:

* Top CPU-consuming processes
* Top memory-consuming processes

Command used:

* `ps`

---

## Port Information

Displays listening network ports.

Primary command:

* `ss`

Fallback:

* `netstat`

---

## Summary Module

Provides a concise overview of:

* Hostname
* Kernel version
* CPU model
* CPU cores
* CPU load
* RAM
* Root filesystem usage
* Running processes
* Listening ports
* Uptime

---

## Health Check Module

Performs simple health checks by evaluating:

* Root filesystem utilization
* RAM utilization
* Swap utilization
* Running process count
* Listening port count
* Gateway connectivity
* Internet connectivity

The module concludes with an overall system health status.

---

# 5. Report Generation

Every module can display its output directly in the terminal.

When generating a full report, the application combines all module outputs into a single timestamped report stored in the **reports/** directory.

Each report includes:

* Execution timestamp
* Executing user
* Complete system profile
* Summary
* Health assessment

---

# 6. Error Handling

The project includes several defensive programming techniques:

* Command availability checks before execution.
* Fallback commands when primary utilities are unavailable.
* Automatic report directory creation.
* Interactive menu input validation.

These mechanisms improve portability across different Linux distributions.

---

# 7. Design Decisions

Several design choices were made during development:

* Functions were separated according to responsibility.
* Standard Linux utilities were preferred over external dependencies.
* Reports were generated in plain text for readability.
* The menu-driven interface was chosen for ease of use.
* Optional dependencies (such as `figlet`) were handled gracefully.

---

# 8. Limitations

Current limitations include:

* Linux-only support.
* Interactive interface only.
* Plain-text report format.
* Basic health assessment rather than comprehensive diagnostics.
* Limited compatibility with minimal Linux distributions lacking standard utilities.

---

# 9. Future Enhancements

Potential future improvements include:

* JSON and CSV report generation.
* Command-line argument support.
* Service and daemon inspection.
* Cron job analysis.
* Network interface reporting.
* Installed package inventory.
* Hardware information expansion.
* Docker and container awareness.
* Enhanced health scoring.
* Cross-distribution compatibility improvements.

---

# 10. Lessons Learned

Developing this project strengthened practical knowledge of:

* Bash scripting
* Modular programming
* Linux command-line utilities
* System profiling
* Security baselining
* Defensive scripting practices
* Report generation
* Error handling
* Function-based software design

---

# Conclusion

The System Profiler demonstrates how Bash scripting can be used to automate routine system administration and defensive security tasks. While intentionally lightweight, the project emphasizes clean design, modularity, portability, and practical cybersecurity applications, making it a solid foundation for future enhancements.
