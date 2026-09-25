# Module 06 — Linux Services, Systemd, Cron & Persistence Investigation

## Overview

Module 06 focused on understanding how Linux services and scheduled tasks work, and how attackers can potentially abuse them for **persistence**.

In Module 05, I learned how to investigate processes that are currently running. In this module, I moved one level deeper and learned how processes can be **automatically started by services or scheduled tasks**.

The main security lesson I learned was:

> **A process tells us what is running now, while services and scheduled tasks can tell us what is configured to run automatically.**

This makes systemd and cron important areas to investigate during Linux incident response.

---

# Topics Covered

* `systemctl`
* systemd services
* `systemctl status`
* `systemctl start`
* `systemctl enable`
* `ExecStart`
* `cron`
* `crontab`
* `/etc/crontab`
* `/etc/cron.d/`
* `journalctl`
* Scheduled-task investigation
* Persistence investigation
* Incident-response workflow

---

# 1. `systemctl`

`systemctl` is the main command used to interact with **systemd**, the service and initialization system used by many modern Linux distributions.

I listed currently running services using:

```bash
systemctl list-units --type=service --state=running
```

This allowed me to see which services were currently active.

One service I investigated was:

```text
cron.service
```

Cron was:

```text
Active:  active (running)
Loaded:  loaded
Enabled: enabled
```

### Security relevance

During an investigation, an unexpected service can be interesting because it may have been:

* Legitimately installed by software.
* Created by an administrator.
* Created by a user.
* Added by an attacker for persistence.

However, an unfamiliar service is **not automatically malicious**.

It needs to be investigated in context.

---

# 2. `systemctl status`

I used:

```bash
systemctl status cron
```

This provided information about the service, including:

```text
Loaded
Active
Main PID
Process
```

My cron service showed:

```text
Active: active (running)
Main PID: 788
```

The Main PID is useful because it allows the investigator to connect the service to its actual process.

For example:

```text
cron.service
     ↓
Main PID
     ↓
Process
     ↓
Child processes
     ↓
Scheduled commands
```

### Security relevance

Knowing the Main PID allows an investigator to investigate:

* Process ownership
* Parent/child relationships
* Process state
* Executable
* Resource usage
* Network connections

---

# 3. `start` vs `enable`

One of the most important concepts in this module was understanding the difference between:

```bash
systemctl start
```

and:

```bash
systemctl enable
```

## `start`

Starts the service **now**.

```bash
sudo systemctl start cron
```

Mental model:

```text
start
  ↓
Run the service NOW
```

## `enable`

Configures the service to start automatically during boot.

```bash
sudo systemctl enable cron
```

Mental model:

```text
enable
   ↓
Configure automatic startup
   ↓
Boot
   ↓
Service starts
```

There is also:

```bash
sudo systemctl enable --now cron
```

which enables the service and starts it immediately.

---

# 4. Why `enable` Matters for Security

The `enable` state is especially important when investigating **boot persistence**.

For example:

```text
Malicious service
       ↓
systemctl enable
       ↓
System reboot
       ↓
Service automatically starts
       ↓
Malicious process
```

However:

> **Enabled does not mean malicious.**

Legitimate services are normally enabled so they automatically start when the system boots.

Therefore, an investigator needs to determine whether the service is expected.

---

# 5. Investigating `ExecStart`

After identifying the cron service, I investigated its configuration:

```bash
systemctl cat cron
```

I then used:

```bash
systemctl show cron -p User -p Group -p ExecStart -p FragmentPath
```

My output included:

```text
User:         none
Group:        none
ExecStart:    /usr/sbin/cron
FragmentPath: /usr/lib/systemd/system/cron.service
```

The important field here was:

```text
ExecStart=/usr/sbin/cron
```

`ExecStart` tells systemd **which command is launched when the service starts**.

### Security relevance

This is one of the most important fields to investigate when examining a suspicious service.

For example:

```text
Service
   ↓
ExecStart
   ↓
Executable
   ↓
Expected location?
   ↓
Expected program?
   ↓
Expected behavior?
```

An executable running from an unexpected or suspicious location would require further investigation.

---

# 6. `cron`

Cron is a Linux scheduling system used to execute commands automatically at specified times.

I checked my user's cron configuration using:

```bash
crontab -l
```

The important lesson was that:

> `crontab -l` only shows the current user's crontab.

If no user cron jobs exist, that does **not** mean cron isn't running.

The cron service can also process system-wide scheduled tasks.

---

# 7. System-Wide Cron

Important cron locations include:

```text
/etc/crontab
/etc/cron.d/
/etc/cron.hourly/
/etc/cron.daily/
/etc/cron.weekly/
/etc/cron.monthly/
```

I inspected:

```bash
cat /etc/crontab
```

and:

```bash
ls -la /etc/cron.d/
```

A system cron entry can contain a user field.

For example:

```text
17 * * * * root cd / && run-parts --report /etc/cron.hourly
```

The important structure is:

```text
schedule
   ↓
user
   ↓
command
```

---

# 8. Why the Executing User Matters

I learned that the user executing a scheduled command is an important part of a security investigation.

For example:

```text
Cron job
   ↓
root
   ↓
command executes with root privileges
```

If the scheduled command is malicious, compromise of that task could have a much greater impact.

Therefore, during an investigation I would ask:

```text
Who executes it?
      ↓
Is that user authorized?
      ↓
What privileges does the user have?
      ↓
What command is executed?
      ↓
What file/script does it execute?
```

---

# 9. Cron Persistence

Attackers can potentially abuse cron for persistence.

For example:

```text
Attacker gains access
       ↓
Creates scheduled task
       ↓
Cron executes command
       ↓
Command runs automatically
       ↓
Persistence
```

An unexpected cron job can therefore become a **persistence indicator**.

However, legitimate administrators and applications also use cron.

So the correct approach is to investigate the entry rather than immediately label it malicious.

---

# 10. `journalctl`

`journalctl` is used to read the **systemd journal**.

I started by viewing recent entries:

```bash
journalctl -n 20
```

Then I investigated cron specifically:

```bash
journalctl -u cron -n 20
```

This showed cron-related activity.

I observed events such as:

```text
cron sessions opened
cron activity
cron sessions closed
```

### Security relevance

Logs can help correlate scheduled activity with a timeline.

For example:

```text
Cron configuration
       ↓
Scheduled command
       ↓
Execution time
       ↓
Journal entry
       ↓
Timeline correlation
```

One important lesson was that cron logs may not always provide the complete command being executed, so they should be correlated with the actual cron configuration and scripts.

---

# 11. Investigating a Suspicious Cron Script

I worked through a simulated scenario involving:

```text
/etc/cron.d/update-check
```

which executed:

```text
/opt/.cache/update.sh
```

The script was owned by:

```text
root
```

and executed with root privileges.

I learned to investigate the script without executing it.

First:

```bash
ls -l /opt/.cache/update.sh
```

This can reveal:

* Owner
* Group
* Permissions
* File type information
* Basic timestamp information

Then:

```bash
stat /opt/.cache/update.sh
```

This provides more detailed metadata and timestamps.

Finally:

```bash
cat /opt/.cache/update.sh
```

allows the investigator to inspect the script contents.

---

# 12. Safe Script Analysis

An unknown script should **not be executed simply to find out what it does**.

Instead, inspect it safely.

Things I would look for include:

```text
Commands executed
        ↓
Files modified
        ↓
Users/groups modified
        ↓
Network connections
        ↓
Remote connections
        ↓
Downloads
        ↓
Persistence mechanisms
        ↓
Privilege escalation
        ↓
Backdoors
```

For example, a script containing commands that:

* Download unknown files.
* Connect to suspicious external systems.
* Create unauthorized users.
* Modify authentication configuration.
* Create additional persistence mechanisms.

would deserve deeper investigation.

---

# 13. Timestamps During Investigation

`stat` can help build a timeline.

Important timestamps include:

```text
btime → file creation time, when available
mtime → content modification
ctime → metadata/inode change
atime → access
```

These can be compared with the incident timeline.

For example:

```text
Incident
   │
   ├── suspicious script created
   ├── script modified
   ├── cron entry created
   └── script executed
```

Timeline correlation can help determine whether the persistence mechanism appeared before or after suspicious activity.

---

# 14. Persistence Investigation

The capstone combined systemd, cron, processes, and logs.

The simulated scenario was:

```text
Service:
suspicious-update.service

Status:
enabled

ExecStart:
/opt/.cache/update.sh

User:
root
```

And:

```text
Cron:
*/10 * * * * root /opt/.cache/update.sh
```

This created two separate persistence mechanisms pointing toward the same script.

That is particularly important because:

```text
systemd
   ↓
update.sh
```

and:

```text
cron
   ↓
update.sh
```

both provide automatic execution.

---

# 15. Incident Response Workflow

My final investigation workflow became:

```text
DISCOVERY
    ↓
Identify service / cron entry
    ↓
PRESERVE
    ↓
Record configuration
Ownership
Permissions
Timestamps
Hashes
    ↓
ANALYSIS
    ↓
Identify executing user
    ↓
Identify privileges
    ↓
Identify executable/script
    ↓
Read script safely
    ↓
Check process activity
    ↓
Check network activity
    ↓
Correlate logs and timestamps
    ↓
CONTAINMENT
    ↓
Disable/remove persistence
    ↓
Terminate malicious activity
    ↓
DOCUMENT
```

The exact order can change depending on the incident, but the important principle is:

> **Preserve and understand the evidence before taking actions that could destroy it, whenever circumstances allow.**

---

# 16. Security Mental Model

```text
                    PERSISTENCE
                         │
            ┌────────────┴────────────┐
            ↓                         ↓
         SYSTEMD                    CRON
            │                         │
        Service                    Schedule
            │                         │
        ExecStart                   Command
            │                         │
            └────────────┬────────────┘
                         ↓
                    EXECUTABLE
                         │
                    Script/File
                         │
          ┌──────────────┼──────────────┐
          ↓              ↓              ↓
        USER         PRIVILEGES       TIMELINE
          │              │              │
        root?          sudo?       btime/mtime
          │              │          ctime/atime
          └──────────────┼──────────────┘
                         ↓
                      LOGS
                         │
                    journalctl
                         ↓
                  CORRELATE EVENTS
                         ↓
                   RISK ASSESSMENT
                         ↓
                    CONTAINMENT
```

---

# Key Commands

| Command                | Purpose                       | Security Application         |
| ---------------------- | ----------------------------- | ---------------------------- |
| `systemctl list-units` | List services                 | Service discovery            |
| `systemctl status`     | Inspect service status        | Service investigation        |
| `systemctl start`      | Start service                 | Service administration       |
| `systemctl enable`     | Enable boot startup           | Persistence investigation    |
| `systemctl is-active`  | Check current state           | Service verification         |
| `systemctl is-enabled` | Check boot configuration      | Persistence detection        |
| `systemctl cat`        | Display service unit          | Configuration investigation  |
| `systemctl show`       | Display service properties    | Investigating execution/user |
| `crontab -l`           | Show current user's cron jobs | Scheduled-task investigation |
| `cat /etc/crontab`     | Inspect system cron           | System-wide scheduling       |
| `ls -la /etc/cron.d/`  | Inspect cron jobs             | Persistence investigation    |
| `journalctl`           | Read systemd journal          | Event/timeline investigation |
| `journalctl -u cron`   | View cron service logs        | Scheduled-task investigation |
| `ls -l`                | Inspect ownership/permissions | File investigation           |
| `stat`                 | Inspect detailed metadata     | Timeline investigation       |
| `cat`                  | Read script contents          | Safe static analysis         |

---

# What I Learned

After completing Module 06, I can:

* Understand what systemd does.
* List running services with `systemctl`.
* Investigate service status.
* Understand the difference between `start` and `enable`.
* Identify why enabled services matter for persistence.
* Investigate `ExecStart`.
* Identify the executable launched by a service.
* Understand the role of cron.
* Distinguish user crontabs from system-wide cron.
* Understand `/etc/crontab` and `/etc/cron.d/`.
* Identify the user executing a scheduled command.
* Understand why root-owned scheduled tasks deserve careful investigation.
* Use `journalctl` to investigate service activity.
* Correlate logs with scheduled tasks.
* Safely inspect suspicious scripts without executing them.
* Use `stat` to investigate timestamps.
* Recognize cron and systemd as potential persistence mechanisms.
* Build a basic Linux persistence investigation workflow.
* Understand why evidence should be preserved before containment when possible.

---

# Final Takeaway

The biggest lesson from Module 06 was:

> **Persistence is not just about what is running now—it is about what has been configured to run again automatically.**

The questions I should ask when investigating persistence are:

```text
What will execute?
       ↓
Who will execute it?
       ↓
With what privileges?
       ↓
When will it execute?
       ↓
Where is the executable?
       ↓
What does it actually do?
       ↓
When was it created or modified?
       ↓
What logs support the activity?
       ↓
Is the persistence mechanism legitimate?
```

This gives me a practical foundation for investigating **Linux persistence mechanisms during incident response**.

---

## Module Progress

```text
Module 01 → File & Metadata Investigation        ✅
Module 02 → Evidence Handling & File Operations  ✅
Module 03 → Linux Permissions & ACLs             ✅
Module 04 → Linux User Management                ✅
Module 05 → Process Management                   ✅
Module 06 → Services & Persistence               ✅
```

**Next: Module 07 — Linux Networking & Network Investigation.**
