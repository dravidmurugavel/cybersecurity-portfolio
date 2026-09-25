# Module 05 — Linux Process Management

## Overview

This module focused on understanding **Linux processes from both an administration and cybersecurity perspective**.

Instead of only learning how to start and stop processes, I learned how to investigate:

* What is running
* Who owns the process
* How much CPU/memory it uses
* Its process state
* Its parent process
* Its executable
* Its open resources
* How it can persist after logout
* When it should or shouldn't be terminated

The main lesson I learned was:

> **A process should be investigated by its identity, parent, executable, behavior, resources, and network activity—not simply by its name.**

---

# Topics Covered

* `ps`
* `top`
* `kill`
* Signals
* `nice` / `renice`
* `jobs`
* `bg`
* `fg`
* `nohup`
* `/proc`
* Process investigation
* Incident-response workflow

---

# 1. `ps`

`ps` provides a **snapshot of currently running processes**.

Basic usage:

```bash
ps
```

For a broader process view:

```bash
ps aux
```

I also used:

```bash
ps aux --sort=-%cpu | head
```

to identify processes consuming the most CPU.

For memory:

```bash
ps aux --sort=-%mem | head
```

I used a more investigation-focused format:

```bash
ps -eo user,pid,ppid,%cpu,%mem,stat,lstart,cmd --sort=-%cpu | head -15
```

This provided information such as:

```text
USER
PID
PPID
CPU
MEM
STAT
START TIME
COMMAND
```

---

## Security Relevance

`ps` helps answer:

> **What is running right now, and who is running it?**

For example, during the lab I investigated Firefox:

```text
Process: /usr/lib/firefox-esr/firefox-esr
PID:     2449
User:    kali
CPU:     ~16%
MEM:     ~15%
```

The process was not suspicious simply because it consumed significant resources.

This taught me:

> **High CPU or memory usage is an observation, not proof of malicious activity.**

A process needs to be investigated in context.

---

# 2. Process States

The `STAT` field in `ps` shows process state.

Important states include:

```text
R → Running/runnable
S → Interruptible sleep
D → Uninterruptible sleep
T → Stopped
Z → Zombie
```

I initially interpreted:

```text
Sl
```

as sleep and idle.

I learned that this is actually:

```text
S → Interruptible sleep
l → Multithreaded process
```

The `l` does not mean idle.

---

# 3. `top`

`top` provides **real-time process monitoring**.

I ran:

```bash
top
```

and used:

```text
P
```

to sort by CPU usage.

I also observed how CPU and memory consumption changed over time.

Firefox remained the highest CPU consumer during my observation, but its resource usage changed dynamically.

---

## `ps` vs `top`

A useful distinction:

```text
ps
 ↓
Snapshot
```

while:

```text
top
 ↓
Live monitoring
```

This matters during investigations.

A suspicious process might briefly consume significant resources and disappear before a single static snapshot is taken.

`top` allows an investigator to observe changing process behavior.

---

# 4. `kill`

The `kill` command sends a **signal** to a process.

For example:

```bash
kill PID
```

The default signal is:

```text
SIGTERM (15)
```

I tested this using a harmless process:

```bash
sleep 300 &
```

Then found its PID:

```bash
pgrep -a sleep
```

and terminated it:

```bash
kill PID
```

---

## SIGTERM vs SIGKILL

### SIGTERM

```text
SIGTERM = 15
```

It politely requests that the process terminate.

The process can handle the signal and perform cleanup.

### SIGKILL

```text
SIGKILL = 9
```

It forcefully terminates the process and cannot be caught or handled by the target process.

Mental model:

```text
SIGTERM
   ↓
"Please terminate."

SIGKILL
   ↓
"Terminate immediately."
```

---

# 5. Security Relevance of `kill`

During incident response, immediately killing a suspicious process can be a mistake.

A running process may contain valuable **volatile evidence**.

For example:

```text
Suspicious process
       ↓
Memory
       ↓
Network connections
       ↓
Open files
       ↓
Process relationships
```

Therefore, I learned this workflow:

```text
Observe
   ↓
Collect evidence
   ↓
Document
   ↓
Contain if necessary
   ↓
Terminate if justified
```

The correct response depends on the incident.

---

# 6. `nice` and `renice`

Linux uses scheduling priorities to determine how processes compete for CPU resources.

The nice value can generally range from:

```text
-20 → higher priority
  0 → normal
+19 → lower priority
```

I checked process priority using:

```bash
ps -o pid,ni,pri,cmd -p PID
```

I then used:

```bash
renice 10 -p PID
```

The process's nice value increased from:

```text
NI = 5
```

to:

```text
NI = 10
```

and its scheduling priority changed accordingly.

### Important relationship

> **Higher nice value = lower CPU scheduling priority.**

---

## Security/Admin Relevance

An administrator may lower the priority of a CPU-heavy background process so that more CPU resources are available for more important processes.

For example:

```text
Important process
      ↑
   more CPU

Background process
      ↓
   lower priority
```

This is primarily a resource-management concept, but it can also be useful during investigations when forensic or monitoring tools need system resources.

---

# 7. `jobs`

`jobs` displays jobs managed by the **current Bash shell**.

I started:

```bash
sleep 300
```

and pressed:

```text
Ctrl+Z
```

The process became suspended.

Then:

```bash
jobs
```

showed the suspended job.

This helped me understand the difference between a process being **stopped** and being **terminated**.

---

# 8. `bg`

`bg` continues a suspended shell job in the background.

Example:

```bash
bg %1
```

The process continues running without occupying the terminal interactively.

Mental model:

```text
Ctrl+Z
   ↓
Stopped
   ↓
bg %1
   ↓
Running in background
```

A background process can still consume significant CPU or memory.

Being in the background does **not** automatically mean it uses fewer resources.

---

# 9. `fg`

`fg` brings a background shell job back to the foreground.

Example:

```bash
fg %1
```

The process then takes control of the terminal again.

The complete workflow I practiced was:

```text
sleep 300
     ↓
Ctrl+Z
     ↓
Stopped
     ↓
bg %1
     ↓
Background
     ↓
fg %1
     ↓
Foreground
```

Finally, I used:

```text
Ctrl+C
```

to terminate the harmless process.

---

# 10. Stopped vs Terminated

This distinction was important.

### Stopped

A stopped process:

* Still exists.
* Is not currently executing.
* Can potentially be resumed.

### Terminated

A terminated process:

* Has exited.
* No longer executes.
* Its process ID is eventually released.

Therefore:

> **Stopped does not mean terminated.**

---

# 11. `nohup`

`nohup` means **"no hangup."**

It protects a process from the normal terminal hangup signal (`SIGHUP`), allowing it to continue when the terminal/session closes.

Example:

```bash
nohup sleep 300 &
```

This is useful when an administrator wants a long-running command to continue after logout.

---

## Security Relevance

`nohup` itself is not malicious.

However, during an investigation, an unexpected long-running process that survives logout may deserve attention.

I would investigate:

```text
Who owns it?
      ↓
What command launched it?
      ↓
What executable is being used?
      ↓
Who is the parent process?
      ↓
How long has it been running?
      ↓
What network connections exist?
```

This prevents me from incorrectly labeling legitimate administrative activity as malicious.

---

# 12. `/proc` Process Investigation

Linux exposes process information through:

```text
/proc/PID/
```

I investigated my Firefox process using:

```bash
ps -o user,pid,ppid,stat,ni,%cpu,%mem,lstart,cmd -p PID
```

This provided:

```text
User
PID
PPID
STAT
Nice value
CPU
Memory
Start time
Command
```

---

## Finding the Executable

I used:

```bash
readlink -f /proc/PID/exe
```

This showed the actual executable associated with the process.

For Firefox:

```text
/usr/lib/firefox-esr/firefox-esr
```

This is more useful than simply seeing a process name.

A suspicious process named something innocent could potentially be running from an unexpected location.

---

# 13. Parent Process — PPID

Every process normally has a parent process.

I found Firefox's:

```text
PID  → 2449
PPID → 1464
```

I used:

```bash
ps -o pid,ppid,user,cmd -p PID
```

to investigate the relationship.

### Why PPID matters

The parent process can help determine **how a process originated**.

For example:

```text
Parent Process
      │
      ├── Child
      ├── Child
      └── Suspicious Child
```

If the parent itself is suspicious, its child processes become important investigation targets.

This is why process trees are valuable during incident response.

---

# 14. Process File Descriptors

I also examined the process's open file descriptors:

```bash
ls -l /proc/PID/fd | head
```

This can help identify resources currently associated with the process.

An investigator may find connections to:

* Files
* Pipes
* Sockets
* Other system resources

This can provide additional context about what the process is doing.

---

# 15. Process Security Investigation

The final exercise simulated a suspicious process:

```text
USER:    kali
COMMAND: /tmp/unknown
PPID:    1464
STAT:    S
NI:      0
```

I learned that I should **not immediately kill it**.

My investigation workflow became:

```text
Suspicious Process
        ↓
Identify owner
        ↓
Identify PID / PPID
        ↓
Identify executable
        ↓
Investigate parent
        ↓
Inspect /proc
        ↓
Inspect open resources
        ↓
Check network connections
        ↓
Document evidence
        ↓
Observe behavior
        ↓
Contain if necessary
        ↓
Terminate if justified
```

---

# 16. Incident Response Mindset

The most important part of this module was learning that process management is not simply:

```text
find process → kill process
```

A security investigation should first preserve useful evidence.

For example:

```text
Suspicious Process
       │
       ├── Who owns it?
       ├── What is its PID?
       ├── Who is its parent?
       ├── What executable?
       ├── What arguments?
       ├── What files?
       ├── What network connections?
       ├── How long has it been running?
       └── What is it doing?
```

Only after collecting appropriate information should termination be considered.

---

# Key Commands

| Command                  | Purpose                    | Security Application           |
| ------------------------ | -------------------------- | ------------------------------ |
| `ps`                     | Process snapshot           | Process investigation          |
| `top`                    | Real-time monitoring       | Behavioral/resource monitoring |
| `pgrep`                  | Find process IDs           | Process identification         |
| `kill`                   | Send process signal        | Process control                |
| `renice`                 | Change scheduling priority | Resource management            |
| `jobs`                   | Show shell jobs            | Job management                 |
| `bg`                     | Continue job in background | Shell management               |
| `fg`                     | Bring job to foreground    | Shell management               |
| `nohup`                  | Ignore terminal hangup     | Persistent command execution   |
| `readlink /proc/PID/exe` | Identify executable        | Process investigation          |
| `ls /proc/PID/fd`        | Inspect file descriptors   | Resource investigation         |

---

# What I Learned

After completing this module, I can:

* Use `ps` to investigate running processes.
* Understand common process states.
* Distinguish a process snapshot from real-time monitoring.
* Use `top` to observe changing resource usage.
* Understand `SIGTERM` and `SIGKILL`.
* Understand why immediately killing suspicious processes can destroy volatile evidence.
* Understand Linux process scheduling and nice values.
* Use `jobs`, `bg`, and `fg`.
* Distinguish stopped processes from terminated processes.
* Understand how `nohup` works.
* Investigate process ownership.
* Identify process IDs and parent process IDs.
* Identify the actual executable of a process.
* Inspect process information through `/proc`.
* Investigate open file descriptors.
* Understand why process trees matter in incident response.
* Build a basic process investigation workflow.
* Think about process management from an incident-response perspective.

---

# Security Mental Model

```text
                    PROCESS
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
        WHO?         WHAT?        HOW?
          │            │            │
        USER       EXECUTABLE     STAT
          │            │            │
          └────────────┼────────────┘
                       ↓
                    PROCESS
                   RELATIONSHIP
                       │
                     PPID
                       ↓
                 Process Tree
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       FILES        NETWORK       RESOURCES
          │            │            │
          └────────────┼────────────┘
                       ↓
                  INVESTIGATE
                       ↓
                  DOCUMENT
                       ↓
                   CONTAIN
                       ↓
             TERMINATE IF NEEDED
```

---

# Final Takeaway

The biggest lesson from Module 05 was:

> **A suspicious process should be investigated before it is terminated whenever circumstances allow.**

Instead of simply asking:

> **"How do I kill this process?"**

I learned to ask:

> **"Who started it, what is it executing, where did it come from, what is its parent, what resources does it access, and what is it communicating with?"**

That shift from **process control → process investigation** is what makes these Linux commands useful for cybersecurity and incident response.

**Next module: Module 06 — Systemd, Services, Cron, Journald & Syslog.**
