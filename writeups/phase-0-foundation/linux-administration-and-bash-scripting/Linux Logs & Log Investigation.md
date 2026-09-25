# Module 08 — Linux Logs & Log Investigation

## Overview

Module 08 focused on understanding how Linux records system activity and how those logs can be used during incident response.

In earlier modules, I learned how to investigate files, users, processes, services, network connections, and persistence mechanisms. This module added another layer:

> **Logs help establish what happened, when it happened, who was involved, and whether the activity was expected.**

I practiced two major Linux logging approaches:

1. **systemd journal** using `journalctl`
2. **Traditional log files** under `/var/log/`

The main lesson was that finding an error, warning, authentication failure, or critical event does **not automatically mean compromise**.

The investigator must correlate the event with its source, timestamp, user, command, service, and known activity.

---

# Module Objectives

By the end of this module, I wanted to be able to:

* Navigate Linux logging sources.
* Use `journalctl`.
* Filter logs by service.
* Filter logs by time.
* Filter logs by severity.
* Investigate kernel events.
* Investigate authentication activity.
* Investigate `sudo` activity.
* Investigate Cron activity.
* Investigate traditional `/var/log` files.
* Correlate events into a timeline.
* Distinguish normal activity from investigation leads.
* Understand why context matters when interpreting logs.

---

# 1. Linux Logging Architecture

Linux systems can record events through different logging mechanisms.

The two important areas I investigated were:

```text
Linux Logging
      │
      ├── systemd Journal
      │       │
      │       └── journalctl
      │
      └── Traditional Logs
              │
              └── /var/log/
```

Modern Linux distributions commonly use the systemd journal, while traditional log files may still exist depending on the distribution and logging configuration.

On my Kali system, I found files such as:

```text
/var/log/auth.log
/var/log/boot.log
/var/log/cron.log
/var/log/kern.log
/var/log/syslog
/var/log/user.log
/var/log/nginx/
/var/log/postgresql/
/var/log/mysql/
```

Not every file or directory was populated.

---

# 2. `/var/log` Reconnaissance

I started the traditional-log investigation with:

```bash
ls -lah /var/log
```

This allowed me to identify which logging sources were actually available on my system.

The important lesson was:

> **Never assume a particular log file exists on every Linux distribution.**

For example, I did not have populated:

```text
messages
secure
daemon.log
```

These names are common on some Linux distributions, but Kali's logging configuration is different.

---

# 3. `journalctl`

`journalctl` is the primary command I used to investigate the systemd journal.

I started with:

```bash
journalctl -n 20
```

This displayed recent journal entries.

Example activity included:

```text
NetworkManager
systemd
mtp-probe
cron
```

One example was:

```text
CRON session opened for user root
```

This was normal scheduled system activity.

### Security relevance

The journal provides a centralized source for many types of system events, making it useful for incident-response investigation.

---

# 4. Service-Specific Logs

I investigated individual services using:

```bash
journalctl -u NetworkManager -n 20
```

This filters the journal by systemd unit.

Example:

```text
dhcp4 (eth0): state changed new lease,
address=192.168.213.128
```

This represented normal DHCP activity.

I also investigated:

```bash
journalctl -u rtkit-daemon -n 20
```

and:

```bash
sudo journalctl -u systemd-logind -n 20
```

These showed normal system and hardware-related activity.

### Security lesson

Service-specific filtering is useful because it reduces unrelated log entries and focuses the investigation on a particular component.

---

# 5. Time-Based Investigation

I used:

```bash
journalctl --since "10 minutes ago"
```

and:

```bash
sudo journalctl --since "30 minutes ago"
```

This allows an investigator to focus on a specific time window.

This is especially useful when an incident has a known approximate time.

For example:

```text
Suspicious event
      ↓
Identify timestamp
      ↓
Search surrounding time window
      ↓
Find related events
      ↓
Build timeline
```

---

# 6. ISO-Style Timestamps

I used:

```bash
journalctl -o short-iso
```

Example:

```text
2026-09-05T16:15:41.466162-04:00
```

The timestamp contains:

```text
2026-09-05
    ↓
Date

T
↓
Date/time separator

16:15:41.466162
    ↓
Time

-04:00
    ↓
UTC offset
```

The `-04:00` portion is an offset from UTC; it does not mean the timestamp itself is UTC.

### Security relevance

Consistent timestamps are important for correlating:

* Linux logs
* Network activity
* Process activity
* Authentication events
* SIEM events
* Application logs

---

# 7. Log Priorities

I investigated journal severity using:

```bash
journalctl -p warning -n 20
```

and:

```bash
sudo journalctl --since "1 hour ago" -p warning..emerg -n 20
```

Important severity levels include:

```text
warning
   ↓
err
   ↓
crit
   ↓
alert
   ↓
emerg
```

Higher-priority events deserve attention, but priority alone does not determine whether something is malicious.

For example, I encountered:

```text
kali : 2 incorrect password attempts
```

This appeared at higher priority levels because it was an authentication problem.

However, I had intentionally generated the failed authentication during the lab.

Therefore:

```text
Severity: High
Context: Known lab activity
Verdict: Normal
```

### Important lesson

> **Severity helps prioritize events; context determines their meaning.**

---

# 8. Kernel Log Investigation

I investigated kernel messages with:

```bash
sudo journalctl -k -n 20
```

I found:

```text
e1000: eth0 NIC Link is Up
1000 Mbps Full Duplex
```

This represented normal network-interface activity.

I then filtered kernel messages by warning priority:

```bash
sudo journalctl -k -p warning -n 20
```

I encountered:

```text
piix4_smbus 0000:00:07.3:
SMBus Host Controller not enabled!
```

This was related to the virtualized environment.

### Verdict

```text
Normal
```

### Security relevance

Kernel logs can provide evidence about:

* Network interfaces
* Drivers
* Hardware
* Devices
* Kernel-level events
* System initialization

---

# 9. Authentication Investigation with `journalctl`

I searched for authentication-related events using:

```bash
sudo journalctl |
grep -Ei 'failed password|authentication failure|invalid user' |
tail -20
```

I found authentication failures that were intentionally generated during the lab.

For example:

```text
pam_unix(sudo:auth):
authentication failure
```

Because I knew the event was generated intentionally, I classified it as:

```text
Normal
```

### Real-world interpretation

In an actual incident, an unexplained authentication failure would initially be treated as an **Investigation Lead**.

It could indicate:

* Mistyped password
* Unauthorized access attempt
* Brute-force activity
* Credential testing
* Privilege escalation attempts

The event requires context.

---

# 10. `sudo` Investigation

I investigated sudo activity using:

```bash
sudo journalctl --since "1 hour ago" |
grep -Ei 'sudo|su|session opened|session closed' |
tail -20
```

Example:

```text
kali : TTY=pts/1 ;
PWD=/home/kali/audit/assembly ;
USER=root ;
COMMAND=/usr/bin/journalctl ...
```

This provided several important fields:

```text
User:
kali

Target user:
root

Command:
journalctl

TTY:
pts/1

Working directory:
 /home/kali/audit/assembly
```

This allowed me to determine:

```text
Who?
kali

What?
Executed journalctl through sudo

Privilege?
root

When?
Timestamp in the log entry
```

The activity was normal because it was my own investigation command.

---

# 11. Cron Investigation

I investigated Cron activity using:

```bash
sudo journalctl --since "1 hour ago" \
-u cron.service -n 20
```

I found:

```text
CRON[1333133]:
(root) CMD
(command -v debian-sa1 > /dev/null &&
debian-sa1 1 1)
```

This was a routine `sysstat`/`sar` data-collection task.

### Verdict

```text
Normal
```

### Security relevance

Cron is important because attackers can potentially use scheduled tasks for persistence.

Therefore, an investigator should determine:

```text
Who runs the task?
       ↓
What command executes?
       ↓
When does it execute?
       ↓
Is the task expected?
```

---

# 12. D-Bus Investigation

I investigated D-Bus events using:

```bash
sudo journalctl --since "1 hour ago" \
-u dbus.service -n 20
```

Example:

```text
Successfully activated service
'org.freedesktop.nm_dispatcher...'
```

This represented normal activation of a NetworkManager-related service.

I also encountered:

```text
Activation via systemd failed for unit
'dbus-org.freedesktop.Avahi.service':
Unit ... not found.
```

This looked concerning because it contained the word `failed`.

However, the event simply indicated that the requested service unit was unavailable.

### Lesson

A log containing the word:

```text
failed
```

does not automatically represent a security incident.

---

# 13. systemd-logind Investigation

I investigated:

```bash
sudo journalctl --since "1 hour ago" \
-u systemd-logind -n 20
```

Example:

```text
Watching system buttons on
/dev/input/event5
(VMware VMware ...)
```

This was related to VMware's virtual hardware.

### Verdict

```text
Normal
```

This reinforced an important lesson:

> **The environment in which the investigation occurs matters.**

Virtual machines can produce hardware and driver messages that would look unusual without virtualization context.

---

# 14. Authentication Logs in `/var/log/auth.log`

After investigating `journalctl`, I moved to traditional Linux log files.

I started with:

```bash
sudo tail -20 /var/log/auth.log
```

I observed entries such as:

```text
kali : TTY=pts/1 ;
PWD=/home/kali/audit/assembly ;
USER=root ;
COMMAND=/usr/bin/tail -20 /var/log/auth.log
```

and:

```text
pam_unix(sudo:session):
session opened for user root(uid=0)
by kali(uid=1000)
```

These entries were generated because I used `sudo` to access the log.

### Lesson

Traditional logs can contain the same underlying activity that appears in the systemd journal.

This provides another source for correlation.

---

# 15. Filtering `auth.log`

I searched authentication events with:

```bash
sudo grep -Ei \
'authentication failure|failed password|accepted password|invalid user' \
/var/log/auth.log | tail -20
```

I found:

```text
pam_unix(sudo:auth):
authentication failure
```

This was intentionally generated during the lab.

### Verdict

```text
Normal
```

The important point was not merely recognizing an authentication failure, but correlating it with known activity.

---

# 16. Successful Authentication in `auth.log`

I also searched for successful authentication/session events:

```bash
sudo grep -Ei \
'accepted password|session opened' \
/var/log/auth.log | tail -20
```

Example:

```text
pam_unix(sudo:session):
session opened for user root(uid=0)
by kali(uid=1000)
```

This showed that:

```text
kali
   ↓
authenticated through sudo
   ↓
root session opened
```

This was normal activity performed during the lab.

---

# 17. SSH Investigation in `auth.log`

I searched for SSH authentication events using:

```bash
sudo grep -Ei \
'sshd.*(accepted|failed|invalid)' \
/var/log/auth.log | tail -20
```

The output I observed was my own `sudo grep` command rather than an SSH authentication event.

This was an important distinction.

### Lesson

A command used to search for an event is not necessarily evidence that the event occurred.

Always inspect the **process/source field**.

---

# 18. Traditional `syslog` Investigation

I examined:

```bash
sudo tail -20 /var/log/syslog
```

I found:

```text
CRON[1360007]:
(root) CMD
(command -v debian-sa1 > /dev/null &&
debian-sa1 1 1)
```

This was the same routine scheduled `sysstat` activity seen through `journalctl`.

### Lesson

Different logging mechanisms can record the same underlying system event.

This makes cross-source correlation useful during incident response.

---

# 19. Filtering `syslog`

I used:

```bash
sudo grep -Ei \
'error|failed|failure|warning' \
/var/log/syslog | tail -20
```

I found:

```text
dbus-daemon:
Activation via systemd failed for unit
'dbus-org.freedesktop.Avahi.service':
Unit ... not found.
```

The event was classified as:

```text
Normal
```

because it represented a missing/unavailable service rather than evidence of malicious activity.

---

# 20. Traditional `kern.log`

I investigated:

```bash
sudo tail -20 /var/log/kern.log
```

I found:

```text
e1000: eth0 NIC Link is Up
1000 Mbps Full Duplex
```

This matched the kernel activity observed through:

```bash
journalctl -k
```

### Verdict

```text
Normal
```

### Lesson

`kern.log` can provide a traditional-file view of kernel events.

---

# 21. Traditional `cron.log`

I investigated:

```bash
sudo tail -20 /var/log/cron.log
```

I found:

```text
CRON[1365181]:
(root) CMD
(command -v debian-sa1 > /dev/null &&
debian-sa1 1 1)
```

Again, this was routine system activity.

### Verdict

```text
Normal
```

This demonstrated that Cron activity may be investigated through both:

```text
journalctl -u cron.service
```

and:

```text
/var/log/cron.log
```

depending on the system's logging configuration.

---

# 22. Traditional `user.log`

I examined:

```bash
sudo tail -20 /var/log/user.log
```

I found:

```text
mtp-probe:
bus: 2, device: 58 was not an MTP device
```

This was normal device-detection activity.

### Verdict

```text
Normal
```

---

# 23. Empty Log Files and Missing Logs

Some traditional log locations were empty or unavailable.

Examples included:

```text
/var/log/boot.log
/var/log/postgresql/error.log
/var/log/mysql/
/var/log/nginx/access.log
/var/log/nginx/error.log
```

I also did not have:

```text
/var/log/messages
/var/log/secure
/var/log/daemon.log
```

### Important Lesson

An empty or missing log file does not automatically indicate:

* System failure
* Logging failure
* Security compromise

It may simply mean:

* The service is not installed.
* The service is not running.
* The logging configuration uses another destination.
* The file is not populated on that distribution.
* The service has generated no events.

Therefore:

> **Always understand the logging configuration before interpreting an empty result.**

---

# 24. `journalctl` vs `/var/log`

The module gave me practical experience with both logging approaches.

| Source                 | Example                   | Main Use                                 |
| ---------------------- | ------------------------- | ---------------------------------------- |
| systemd journal        | `journalctl`              | Centralized system/service investigation |
| Service journal        | `journalctl -u cron`      | Service-specific investigation           |
| Kernel journal         | `journalctl -k`           | Kernel/driver/system events              |
| `/var/log/auth.log`    | `grep`, `tail`            | Authentication and sudo                  |
| `/var/log/syslog`      | `grep`, `tail`            | General system activity                  |
| `/var/log/kern.log`    | `tail`                    | Kernel activity                          |
| `/var/log/cron.log`    | `tail`                    | Scheduled-task activity                  |
| `/var/log/user.log`    | `tail`                    | User-level system activity               |
| `/var/log/nginx/`      | `access.log`, `error.log` | Web-server activity                      |
| `/var/log/mysql/`      | MySQL logs                | Database activity                        |
| `/var/log/postgresql/` | PostgreSQL logs           | Database activity                        |

The exact files available depend on the Linux distribution and logging configuration.

---

# 25. Log Correlation

One of the most important skills developed in this module was **correlation**.

A single event provides limited information.

Multiple sources can provide stronger evidence.

For example:

```text
auth.log
    ↓
sudo authentication event
    ↓
journalctl
    ↓
same timestamp/process
    ↓
syslog
    ↓
related system activity
    ↓
timeline
```

This makes it possible to determine whether events are connected.

---

# 26. Who / What / When

For each important event, I learned to extract:

### Who?

Who performed the action?

```text
kali
root
system service
```

### What?

What actually happened?

```text
sudo command
authentication failure
Cron execution
network event
service activation
```

### When?

When did it occur?

```text
2026-09-05T16:19:13-04:00
```

This creates the foundation for timeline analysis.

---

# 27. Analyst Activity vs Incident Activity

A particularly important lesson from this module was that **the investigator can generate logs too**.

Many of my logs contained commands such as:

```text
sudo journalctl
sudo grep
sudo tail
```

These were not attacker activity.

They were generated by me during the investigation.

Therefore, during a real incident:

```text
Log event
    ↓
Was this caused by the incident?
        OR
Was this caused by the investigator?
```

This distinction is critical when building an incident timeline.

---

# 28. Investigation Verdict Model

I used a simple classification system:

```text
                 LOG EVENT
                     │
                     ▼
                Identify source
                     │
                     ▼
                Identify user
                     │
                     ▼
               Check timestamp
                     │
                     ▼
               Understand action
                     │
                     ▼
             Check known context
                     │
             ┌───────┴───────┐
             ▼               ▼
          Expected        Unexpected
             │               │
             ▼               ▼
          NORMAL      INVESTIGATION LEAD
```

An **Investigation Lead** does not mean confirmed malware.

It means:

> The event is unusual or unexplained enough to require further investigation.

---

# 29. Incident-Response Log Workflow

My final workflow became:

```text
DISCOVERY
    ↓
Identify available logging sources
    ↓
journalctl + /var/log
    ↓
FILTER
    ↓
Time
Service
Severity
Keywords
    ↓
IDENTIFY
    ↓
User
Process
Command
Service
Timestamp
    ↓
CORRELATE
    ↓
Compare related logs
    ↓
Compare with known activity
    ↓
BUILD TIMELINE
    ↓
Normal or Investigation Lead
    ↓
Further investigation / containment
```

---

# Key Commands

## `journalctl`

```bash
journalctl -n 20
```

Recent journal entries.

```bash
journalctl -u <service> -n 20
```

Service-specific logs.

```bash
journalctl --since "1 hour ago"
```

Time-based filtering.

```bash
journalctl -k -n 20
```

Kernel messages.

```bash
journalctl -p warning -n 20
```

Warning-level and higher-priority events.

```bash
journalctl -o short-iso
```

ISO-style timestamps.

```bash
journalctl --since "1 hour ago" \
-p warning..emerg
```

Combined time and priority filtering.

---

## `/var/log`

```bash
sudo ls -lah /var/log/
```

Discover available traditional logs.

```bash
sudo tail -20 /var/log/auth.log
```

Authentication logs.

```bash
sudo tail -20 /var/log/syslog
```

General system logs.

```bash
sudo tail -20 /var/log/kern.log
```

Kernel logs.

```bash
sudo tail -20 /var/log/cron.log
```

Cron logs.

```bash
sudo tail -20 /var/log/user.log
```

User-level system logs.

```bash
sudo grep -Ei 'failed|failure|authentication' \
/var/log/auth.log
```

Search authentication-related events.

---

# Security Lessons

## 1. Logs are evidence

Logs can help establish:

```text
What happened
When it happened
Who was involved
Which process/service was involved
```

---

## 2. Severity is not a verdict

A:

```text
warning
error
critical
alert
```

event may still be legitimate.

Severity helps determine what deserves attention first.

---

## 3. Context determines meaning

For example:

```text
Authentication failure
```

could mean:

```text
Mistyped password
```

or:

```text
Brute-force attempt
```

Context determines which interpretation is more appropriate.

---

## 4. Empty results require interpretation

No matching log entries do not necessarily mean no activity occurred.

The investigator must understand:

```text
Which log?
Which time range?
Which filter?
Which logging configuration?
```

---

## 5. Multiple sources strengthen investigations

Correlating:

```text
auth.log
+
syslog
+
kern.log
+
journalctl
```

can provide a stronger timeline than relying on one source.

---

## 6. Investigators generate evidence too

Commands executed during an investigation may themselves appear in logs.

This must be accounted for when reconstructing an incident timeline.

---

# Module 08 Capstone

The final investigation combined:

```text
systemd journal
       +
traditional /var/log files
       +
authentication events
       +
service events
       +
kernel events
       +
Cron events
       +
timestamps
       +
analyst activity
```

I investigated normal events such as:

```text
NIC link activation
Cron sysstat execution
NetworkManager DHCP activity
VMware virtual hardware events
D-Bus service activation
MTP device detection
sudo activity generated by myself
```

I also investigated events that initially looked suspicious because they contained terms such as:

```text
failed
failure
authentication failure
critical
warning
```

After correlating them with my intentional lab activity, I correctly classified them as:

```text
Normal
```

The final capstone demonstrated that **classification requires context rather than simply reacting to keywords or severity levels.**

---

# What I Learned

After completing Module 08, I can:

* Understand Linux logging at a practical level.
* Use `journalctl`.
* Filter journal events by service.
* Filter events by time.
* Filter events by priority.
* Investigate kernel messages.
* Investigate authentication events.
* Investigate sudo activity.
* Investigate Cron activity.
* Interpret ISO-style timestamps.
* Search logs using `grep`.
* Investigate `/var/log/auth.log`.
* Investigate `/var/log/syslog`.
* Investigate `/var/log/kern.log`.
* Investigate `/var/log/cron.log`.
* Investigate `/var/log/user.log`.
* Recognize service-specific log directories.
* Understand why some traditional logs may be empty or missing.
* Correlate events across different logging sources.
* Distinguish investigator activity from incident activity.
* Build a basic Linux event timeline.
* Classify events as Normal or Investigation Lead based on context.

---

# Final Takeaway

The biggest lesson from Module 08 was:

> **A log entry is only a piece of evidence. Its meaning comes from context, correlation, and timeline.**

When investigating a Linux event, I should ask:

```text
What happened?
      ↓
When did it happen?
      ↓
Who was involved?
      ↓
Which process/service generated it?
      ↓
What command or action occurred?
      ↓
Is it expected?
      ↓
Does another log source confirm it?
      ↓
Does it correlate with other suspicious activity?
      ↓
Normal or Investigation Lead?
```

This gives me a practical foundation for **Linux log analysis and incident-response investigation**.

---

## Module Progress

```text
Module 01 → File & Metadata Investigation       ✅
Module 02 → Evidence Handling & File Operations  ✅
Module 03 → Linux Permissions & ACLs             ✅
Module 04 → Linux User Management                ✅
Module 05 → Process Management                   ✅
Module 06 → Services & Persistence               ✅
Module 07 → Linux Networking & Network IR        ✅
Module 08 → Linux Logs & Log Investigation       ✅
```

**Next: Module 09 — Linux Security & Hardening Investigation.**
