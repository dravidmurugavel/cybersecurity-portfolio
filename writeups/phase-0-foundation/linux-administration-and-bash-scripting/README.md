# Linux Administration & Bash Scripting

> Security-focused Linux administration, investigation, and bash scripting — learning Linux not just as a user, but as someone who has to answer "what happened on this machine?"

---

## Module Overview

This section covers Linux administration from a dual lens: **day-to-day system administration** and **security investigation**. Every command was learned alongside the question a security analyst or incident responder would actually ask — not just "how do I run this?" but "what does this tell me, and what would it look like if something were wrong?"

The section builds toward a capstone module — **Security & Hardening** — that ties every prior module together into a single analyst mindset, and an applied project — **[LinSec Auditor](../../../projects/phase-0-foundation/linux-administration-and-bash-scripting/README.md)** — that turns that mindset into a working bash security auditing tool.

---

## Learning Objectives

By completing this section, I can:

* Navigate and search the filesystem to locate, identify, and inspect files (`find`, `locate`, `which`, `file`, `stat`).
* Perform and reason about file operations from an evidence-handling perspective (copying, moving, permissions-preserving operations).
* Read and reason about Linux permissions, ownership, and access control (`chmod`, `chown`, SUID/SGID, sticky bit).
* Manage and investigate Linux users, groups, and authentication (`useradd`, `passwd`, `/etc/passwd`, `/etc/shadow`).
* Investigate running processes, ownership, and resource usage, and distinguish normal from suspicious activity (`ps`, `top`, `/proc`).
* Understand services, systemd units, cron jobs, and how each can be abused for persistence.
* Administer and investigate Linux networking — interfaces, routing, sockets, and firewalls with `nftables` (`ip`, `ss`, `lsof`, `curl`).
* Trace a network connection from IP/port back to the responsible process, user, and executable.
* Read and correlate Linux logs across `journalctl`, `/var/log`, `auth.log`, `syslog`, and `kern.log` during an investigation.
* Track installed software and verify package integrity (`apt`/`dpkg`, package investigation).
* Assess a Linux system's overall security posture — accounts, privileges, exposure, and persistence — as a single hardening review.
* Combine these commands into working bash tools rather than running them manually one at a time.

---

## Investigation Mental Model

A theme repeated across every networking and process module in this section:

```text
Network Activity / Suspicious Behaviour
              ↓
         IP / Port
              ↓
          Process
              ↓
            PID
              ↓
            User
              ↓
         Executable
              ↓
   Parent / Child Process
              ↓
      DNS / Hostname
              ↓
     Investigation Verdict
```

The same "trace it back to a root cause" pattern applies whether the entry point is a listening port, a running process, a cron job, or a log entry — connectivity leads to a service, a service leads to a process, a process leads to a user and executable, and that's where a judgment call gets made. Module 10 (Security & Hardening) makes this explicit by asking one question of the whole system: *who can access this, what can they do, and what runs automatically without anyone watching?*

---

## Modules

| # | Module | Topics Covered | Security Relevance |
|---|---|---|---|
| 01 | [Linux Navigation](Linux%20Navigation.md) | `find`, `locate`, `which`, `file`, `stat` | Locating, identifying, and inspecting files from an investigation standpoint |
| 02 | [File Operations](Linux%20File%20Operations.md) | File handling, copying/moving, evidence-safe operations | Preserving integrity of files/directories during investigation |
| 03 | [Permissions](Linux%20Permissions.md) | `chmod`, ownership, SUID/SGID, sticky bit | Misconfigured permissions as a privilege-escalation vector |
| 04 | [User Management](Linux%20User%20Management.md) | `useradd`, `passwd`, `/etc/passwd`, `/etc/shadow` | Identity, authentication, and privilege management |
| 05 | [Process Management](Linux%20Process%20Management.md) | `ps`, `top`, `/proc`, process ownership | Distinguishing normal vs. suspicious running processes |
| 06 | [Services, Systemd, Cron & Persistence](Linux%20Services%2C%20Systemd%2C%20Cron%20%26%20Persistence%20Investigation.md) | systemd units, cron jobs, scheduled tasks | How attackers abuse services/cron for persistence |
| 07 | [Networking & Network Administration](Linux%20Network%20Administration.md) | Interfaces, routing, `nftables`, firewall rules | Administering and hardening Linux network configuration |
| 07 | [Network Investigation](Linux%20Network%20Investigation.md) | `ss`, `lsof`, `/proc`, connection tracing | Tracing a connection back to process, user, and executable |
| 08 | [Logs & Log Investigation](Linux%20Logs%20%26%20Log%20Investigation.md) | `journalctl`, `/var/log`, `auth.log`, `syslog`, `kern.log` | Reconstructing activity and authentication events during IR |
| 09 | [Package Management & Investigation](Linux%20Package%20Management%20%26%20Package%20Investigation.md) | `apt`/`dpkg`, install tracking, integrity checks | Verifying what software is installed and whether it's trusted |
| 10 | [Security & Hardening (Capstone)](Linux%20Security%20%26%20Hardening.txt) | Accounts, privileges, SUID/SGID, sudo, services, cron, networking, firewalls, SSH, auth logs, persistence, timeline analysis | Consolidates every prior module into one system-hardening review |

Module 07 is split into two write-ups — administration and investigation — since networking was substantial enough to warrant treating "how it's configured" and "how it's investigated" separately.

---

## Applied Project

Reading about a command is different from being able to reach for it under pressure. **[LinSec Auditor](../../../projects/phase-0-foundation/linux-administration-and-bash-scripting/README.md)** is a modular bash security auditing tool built directly from the Module 10 hardening checklist — it automates 13 of the checks covered in this section (privileged accounts, SUID/SGID, sudo config, listening ports, firewall, SSH exposure, cron, systemd, failed authentication, and more) into a single tool with risk scoring, prioritized findings, and both terminal and JSON reporting. It's the practical proof that the investigative habits built across Modules 01–10 translate into a real, usable security tool.

---

## Module Status

| Module                                            | Status      |
| --------------------------------------------------- | :---------: |
| Navigation                                          | ✅ Complete |
| File Operations                                     | ✅ Complete |
| Permissions                                         | ✅ Complete |
| User Management                                     | ✅ Complete |
| Process Management                                  | ✅ Complete |
| Services, Systemd, Cron & Persistence               | ✅ Complete |
| Networking & Network Administration                 | ✅ Complete |
| Network Investigation                               | ✅ Complete |
| Logs & Log Investigation                            | ✅ Complete |
| Package Management & Investigation                  | ✅ Complete |
| Security & Hardening (Capstone)                     | ✅ Complete |
| Applied Bash Project (LinSec Auditor)                | ✅ Complete |

**Overall Status:** 🟢 Complete

---

## Conclusion

Linux administration is often treated as a checklist of commands to memorize. This section instead treats each command as a lens for an investigation question — not just "how do I list processes" but "how would I know if one of them shouldn't be there." That investigative habit, more than any single command, is the actual skill this section was built to develop, and it carries forward directly into the SOC, DFIR, and pentesting domains later in this roadmap — as well as directly into the [LinSec Auditor](../../../projects/phase-0-foundation/linux-administration-and-bash-scripting/README.md) project above.
