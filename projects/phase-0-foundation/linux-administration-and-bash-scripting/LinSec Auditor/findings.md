# Linux Security Auditor — Security Findings

## 1. Assessment Overview

This document records representative findings identified during testing of the **LinSec Auditor** on the authorized Kali Linux lab system.

The purpose of this assessment was to demonstrate how the auditor:

```text
DISCOVER
   ↓
DETECT
   ↓
ASSESS
   ↓
EXPLAIN RISK
   ↓
PRIORITIZE
   ↓
REPORT
```

The findings are observations from the test environment and should not be interpreted as evidence that the system is compromised.

An unexpected configuration requires investigation and context before it can be classified as malicious.

---

# 2. Risk Assessment Methodology

The auditor assigns four factors to each finding:

```text
Privilege   (P) → 0–3
Exposure    (E) → 0–3
Likelihood  (L) → 0–3
Confidence  (C) → 1–3
```

The risk score is calculated as:

```text
Risk Score = (P + E + L) × C
```

Maximum score:

```text
(3 + 3 + 3) × 3 = 27
```

## Severity Classification

| Score | Severity |
| ----: | -------- |
|   0–5 | INFO     |
|  6–11 | LOW      |
| 12–17 | MEDIUM   |
| 18–22 | HIGH     |
| 23–27 | CRITICAL |

The score is an assessment aid rather than proof of compromise.

---

# 3. Finding: Writable SUID Executable

**Finding ID:** `SUID-001`

**Severity:** CRITICAL

**Risk Score:** 24

**Location:**

```text
/home/kali/test/permissions-lab/suid_demo
```

## Observation

The auditor identified a file that was:

* Owned by `root`
* SUID-enabled
* Writable by an unauthorized user

The combination of privileged ownership, SUID execution, and write access creates a potentially dangerous privilege boundary.

## Risk Factors

```text
Privilege:  3
Exposure:   2
Likelihood: 3
Confidence: 3
```

Calculation:

```text
(3 + 2 + 3) × 3 = 24
```

Result:

```text
CRITICAL
```

## Security Significance

A writable SUID executable can potentially allow modification of code that executes with elevated privileges.

This is why SUID files should be evaluated together with:

```text
Owner
Permissions
Location
Purpose
Expected software
Integrity
```

The finding itself does not prove exploitation occurred.

## Recommended Investigation

An investigator should:

1. Verify whether the SUID permission is expected.
2. Confirm the file owner.
3. Review the file permissions.
4. Identify the software or lab component that created it.
5. Preserve relevant evidence.
6. Determine whether the file should remain SUID-enabled.

---

# 4. Finding: Unrestricted Sudo Privileges

**Finding ID:** `SUDO-001`

**Severity:** HIGH

The auditor identified unrestricted sudo privileges for the current `kali` user.

## Observation

The account can use sudo privileges without a narrowly restricted command policy.

## Security Significance

Sudo configuration should be reviewed because it defines which users can perform privileged operations.

Broad administrative privileges increase the impact of an account compromise.

However, unrestricted sudo access can also be completely legitimate for an administrator or laboratory account.

Therefore, authorization and operational context are required before treating the configuration as a security issue.

## Recommended Investigation

Review:

```bash
sudo -l
```

and the applicable sudo configuration.

Determine:

```text
Who has sudo?
      ↓
Why do they need it?
      ↓
What commands can they execute?
      ↓
Is the access appropriate?
```

---

# 5. Finding: Listening Service Outside Baseline

**Finding ID:** `PORT-008` / related port findings

**Severity:** HIGH for the observed non-baseline listeners

The auditor detected listening services that were not present in the configured service baseline.

Examples included system resolver-related listeners on:

```text
TCP 5355
UDP 5355
```

## Security Significance

A listening service increases the attack surface of a system.

However:

> A port that is not in the baseline is not automatically malicious.

The service must be identified and evaluated.

## Investigation Workflow

```text
Listening port
      ↓
Identify process
      ↓
Identify executable
      ↓
Identify service owner
      ↓
Review configuration
      ↓
Compare against baseline
      ↓
Determine whether exposure is expected
```

Useful commands include:

```bash
ss -lntup
```

and:

```bash
systemctl status <service>
```

---

# 6. Finding: Firewall Configuration Requires Review

**Finding IDs:** `FIREWALL-001`, `FIREWALL-002`, `FIREWALL-003`

**Severity:** HIGH

The auditor identified firewall configurations containing ACCEPT behavior that requires review.

The test environment had UFW inactive while nftables rules were present.

## Security Significance

Firewall security cannot be determined from the presence or absence of one firewall frontend alone.

For example:

```text
UFW inactive
      ↓
Does NOT automatically mean
      ↓
No firewall exists
```

Another firewall framework may still be enforcing rules.

Therefore, firewall assessment should consider the active packet-filtering framework and its rules.

## Investigation

The assessment considered:

* Firewall frontend status.
* Packet-filtering rules.
* Input policy.
* Forwarding policy.
* Accept behavior.

The correct conclusion is that the observed configuration requires review rather than automatically declaring the host unprotected.

---

# 7. Finding: World-Writable File

**Finding ID:** `FILE-001`

**Severity:** MEDIUM

**Location:**

```text
/home/kali/project/notes.sh
```

## Observation

The auditor identified a world-writable file.

## Security Significance

World-writable files can allow unauthorized users to modify content.

The risk depends heavily on:

```text
Owner
Location
Purpose
Execution status
Permissions
Who can access it
Whether it is trusted code
```

A world-writable text file is not equivalent to a world-writable executable.

## Recommended Investigation

Review:

```bash
ls -l /home/kali/project/notes.sh
```

and:

```bash
stat /home/kali/project/notes.sh
```

Determine whether the permissions are intentional.

---

# 8. Finding: Login-Capable Account

**Finding ID:** `LOGIN-001`

**Severity:** MEDIUM

The auditor identified a login-capable `postgres` account.

## Observation

The account had:

```text
UID: 123
Shell: /bin/bash
```

## Security Significance

Service accounts generally do not need interactive login shells.

However, changing a service account's shell without understanding how the software operates can break legitimate functionality.

The finding therefore requires contextual review.

## Investigation Questions

```text
Is interactive login required?
        ↓
Is the account used by a service?
        ↓
Does the application require this shell?
        ↓
Was the configuration intentionally changed?
```

---

# 9. Finding: Cron Configuration

The auditor identified multiple cron entries during assessment.

Examples included standard system cron tasks and periodic execution directories.

## Important Interpretation

Many of these entries are expected Linux functionality.

Therefore:

> **Cron detection is not equivalent to malicious persistence detection.**

The auditor identifies scheduled execution that requires contextual evaluation.

## Investigation Workflow

```text
Cron entry
    ↓
Who executes it?
    ↓
What command runs?
    ↓
What file/script is involved?
    ↓
Who owns the file?
    ↓
What permissions exist?
    ↓
When was it created?
    ↓
Is the task expected?
```

This is particularly important for entries that execute commands as `root`.

---

# 10. Finding: Expected Services and Ports

The test environment also contained legitimate services such as:

```text
systemd-resolve
tor
apache2
```

Some services were represented in the configured baseline.

## Security Lesson

A security auditor should distinguish between:

```text
Expected service
```

and:

```text
Unexpected service
```

This is why the project includes:

```text
config/service_baseline.conf
```

Example baseline entries:

```text
apache2|tcp|80
systemd-resolve|udp|53
systemd-resolve|tcp|53
tor|tcp|9050
```

A baseline provides context for detection.

It does not automatically prove that an unlisted service is malicious.

---

# 11. Persistence Investigation Example

A simulated persistence scenario was used during development.

The scenario contained:

```text
Service:
suspicious-update.service

ExecStart:
/opt/.cache/update.sh

User:
root
```

and:

```text
Cron:
*/10 * * * * root /opt/.cache/update.sh
```

## Security Significance

Two independent persistence mechanisms referenced the same executable:

```text
systemd
   │
   └── /opt/.cache/update.sh
             ↑
   ┌─────────┘
   │
cron
```

This demonstrates why persistence investigations should correlate multiple configuration sources.

The existence of two mechanisms does not by itself establish malicious intent, but it increases the importance of understanding:

* Ownership
* Permissions
* File timestamps
* Script contents
* Executing user
* Process activity
* Network activity
* Related logs

---

# 12. Evidence and Timeline Analysis

For suspicious files, the auditor's investigation workflow includes:

```bash
ls -l <file>
```

```bash
stat <file>
```

and safe inspection of contents.

Important timestamps include:

```text
btime → creation time, when available
mtime → content modification
ctime → metadata/inode change
atime → access
```

These can be correlated with:

```text
Service changes
Cron changes
Process execution
Authentication events
Network activity
```

Example:

```text
Suspicious file created
        ↓
Cron entry created
        ↓
Service enabled
        ↓
Process executed
        ↓
Network activity
```

A timeline provides stronger investigative context than examining a single artifact in isolation.

---

# 13. Findings vs Compromise

The auditor deliberately distinguishes between:

```text
Finding
```

and:

```text
Confirmed compromise
```

A finding means:

> The auditor identified a configuration or system condition that deserves investigation.

It does **not** automatically mean:

* An attacker is present.
* Exploitation occurred.
* Malware exists.
* A vulnerability was exploited.
* The system is compromised.

This distinction is important for responsible security reporting.

---

# 14. Assessment Summary

Representative findings from the lab assessment included:

| Finding                                 | Category             | Severity          |
| --------------------------------------- | -------------------- | ----------------- |
| Writable SUID executable                | Privilege boundary   | CRITICAL          |
| Unrestricted sudo access                | Privilege management | HIGH              |
| Non-baseline listening services         | Network exposure     | HIGH              |
| Firewall configuration requiring review | Network security     | HIGH              |
| World-writable file                     | File permissions     | MEDIUM            |
| Login-capable service account           | Account security     | MEDIUM            |
| Standard cron entries                   | Scheduled execution  | Context-dependent |
| Expected baseline services              | Service exposure     | Context-dependent |

The severity shown by the auditor reflects the configured risk model and the evidence available during the assessment.

---

# 15. Lessons Learned

The assessment reinforced several important Linux security principles.

### 1. Context matters

An unfamiliar configuration is an investigation lead, not automatically malicious activity.

### 2. Privilege boundaries matter

Root ownership, SUID, SGID, sudo, and root-executed scheduled tasks deserve careful examination.

### 3. Exposure matters

Listening services and firewall configuration determine how the system can be reached.

### 4. Persistence requires correlation

Cron and systemd should be examined together when investigating automatic execution.

### 5. Evidence should be preserved

Configuration, ownership, permissions, timestamps, logs, and process information should be recorded before destructive containment actions when circumstances allow.

### 6. Risk prioritization is useful

A large list of observations is less useful than a smaller set of findings prioritized by:

```text
Privilege
Exposure
Likelihood
Confidence
```

---

# 16. Final Assessment

The Linux Security Auditor successfully demonstrated a complete security-assessment workflow:

```text
System State
     ↓
Security Checks
     ↓
Evidence Collection
     ↓
Structured Finding
     ↓
Risk Calculation
     ↓
Severity Classification
     ↓
Recommendation
     ↓
Prioritized Report
```

The project therefore demonstrates more than basic Bash scripting.

It demonstrates how security automation can transform raw Linux configuration data into structured, explainable assessment results.

---

## Assessment Status

```text
13 Security Checks          ✅
Risk Engine                 ✅
Finding IDs                 ✅
Severity Classification     ✅
Recommendations             ✅
Evidence Collection         ✅
Finding Prioritization      ✅
Terminal Reporting          ✅
JSON Reporting              ✅
CLI Automation              ✅
Testing Documentation       ✅
```

**Assessment status: Complete**

**Project version: 2.1.0 Release Candidate**
