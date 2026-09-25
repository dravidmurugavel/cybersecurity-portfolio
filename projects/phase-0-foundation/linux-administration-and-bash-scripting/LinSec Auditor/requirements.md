# LinSec Auditor — Requirements Specification

## 1. Project Overview

**LinSec Auditor** is a read-only Linux security auditing tool written in Bash.

The project is designed to inspect a Linux system for security-relevant configuration and system-state conditions, collect supporting evidence, assess risk, prioritize findings, and generate human-readable or machine-readable reports.

The tool is intended for:

* Linux security auditing
* Security hardening reviews
* Incident-response preparation
* Security automation
* Cybersecurity learning and portfolio demonstration

The auditor operates against the local Linux system and does not perform exploitation or vulnerability scanning.

---

# 2. Project Objectives

The primary objectives are to:

1. Automate common Linux security checks.
2. Collect useful evidence for each finding.
3. Evaluate findings using a consistent risk model.
4. Prioritize findings according to assessed risk.
5. Provide actionable security recommendations.
6. Support both interactive and command-line operation.
7. Produce TXT and JSON reports.
8. Provide automation-friendly exit codes.
9. Maintain a read-only security assessment model.
10. Demonstrate a complete security-tool development lifecycle.

---

# 3. Scope

## 3.1 In Scope

The first major release includes thirteen security checks:

1. Privileged accounts
2. Login-capable accounts
3. Sudo configuration
4. World-writable files
5. World-writable directories
6. SUID files
7. SGID files
8. Listening ports
9. Firewall configuration
10. SSH security
11. Cron jobs
12. Systemd services
13. Failed authentication activity

The project also includes:

* Centralized risk calculation
* Severity classification
* Structured findings
* Finding identifiers
* Finding prioritization
* Recommendation generation
* Service baselines
* Interactive menus
* CLI operation
* TXT reporting
* JSON reporting
* Output-file support
* Exit-code handling

---

# 4. Functional Requirements

## FR-01 — Privileged Account Detection

The auditor shall identify accounts with UID `0`.

The check shall record relevant account information and identify privileged accounts for further review.

---

## FR-02 — Login-Capable Account Detection

The auditor shall identify accounts that have interactive login-capable shells.

The check shall distinguish between system/service accounts and accounts capable of interactive login where possible.

---

## FR-03 — Sudo Configuration Assessment

The auditor shall inspect sudo privileges and identify broad or unrestricted administrative access requiring review.

The auditor shall not modify sudo configuration.

---

## FR-04 — World-Writable File Detection

The auditor shall identify files with world-writable permissions.

The finding should include sufficient evidence to determine:

* File path
* Ownership
* Permissions
* Security relevance

---

## FR-05 — World-Writable Directory Detection

The auditor shall identify world-writable directories.

The assessment should consider directory ownership and permissions.

---

## FR-06 — SUID Detection

The auditor shall identify SUID-enabled files.

The assessment should consider:

* Owner
* Permissions
* Location
* Executability
* Potential privilege boundary

---

## FR-07 — SGID Detection

The auditor shall identify SGID-enabled files.

The assessment should consider ownership, permissions, and execution context.

---

## FR-08 — Listening Port Detection

The auditor shall identify locally listening network sockets.

The check should attempt to associate listening ports with:

* Protocol
* Address
* Port
* Process/service

Known legitimate services may be compared against a configurable baseline.

---

## FR-09 — Firewall Assessment

The auditor shall inspect relevant firewall configuration and identify security-relevant configuration requiring review.

The auditor shall not modify firewall rules.

---

## FR-10 — SSH Security Assessment

The auditor shall inspect SSH exposure and relevant SSH configuration.

The auditor shall identify whether SSH is exposed and highlight configuration requiring investigation.

---

## FR-11 — Cron Assessment

The auditor shall inspect user and system-wide scheduled tasks.

Relevant locations include:

```text
/etc/crontab
/etc/cron.d/
/etc/cron.hourly/
/etc/cron.daily/
/etc/cron.weekly/
/etc/cron.monthly/
```

The auditor shall identify scheduled execution that may require investigation.

---

## FR-12 — Systemd Service Assessment

The auditor shall identify enabled systemd services that require investigation.

Relevant service information includes:

* Service name
* Enabled state
* Active state
* Unit file
* ExecStart
* User
* Group
* Executable
* Ownership
* Permissions

A configurable baseline may be used to reduce expected-service noise.

---

## FR-13 — Authentication Activity

The auditor shall inspect available authentication information for failed login activity.

The check shall handle systems where relevant authentication logs or commands are unavailable.

---

# 5. Risk Assessment Requirements

The auditor shall use a centralized risk model.

Each finding shall contain:

```text
Privilege
Exposure
Likelihood
Confidence
```

The risk score shall be calculated as:

```text
Risk Score = (Privilege + Exposure + Likelihood) × Confidence
```

The maximum score shall be:

```text
27
```

---

# 6. Severity Requirements

The auditor shall classify findings using the following thresholds:

| Score | Severity |
| ----: | -------- |
|   0–5 | INFO     |
|  6–11 | LOW      |
| 12–17 | MEDIUM   |
| 18–22 | HIGH     |
| 23–27 | CRITICAL |

The severity classification shall be deterministic.

---

# 7. Finding Requirements

Each finding shall contain:

```text
Finding ID
Check
Title
Description
Evidence
Privilege
Exposure
Likelihood
Confidence
Risk Score
Severity
Recommendation
```

Finding IDs shall identify the originating security check and finding sequence.

Example:

```text
SUID-001
PORT-008
FIREWALL-001
```

---

# 8. Recommendation Requirements

The auditor shall generate a recommendation based on finding severity.

Recommendations shall encourage investigation, evidence preservation, validation of authorization, and appropriate remediation or containment.

Recommendations shall not automatically modify the system.

---

# 9. Reporting Requirements

The auditor shall support:

### Interactive terminal output

Human-readable security results.

### TXT reports

Plain-text reports suitable for documentation and review.

### JSON reports

Structured reports suitable for:

* Automation
* SIEM ingestion
* Other security tooling
* Programmatic processing

JSON output shall be valid JSON.

---

# 10. CLI Requirements

The auditor shall support:

```bash
./auditor.sh --help
./auditor.sh --full
./auditor.sh --check <name>
./auditor.sh --format txt
./auditor.sh --format json
./auditor.sh --output <file>
```

Supported check names shall include:

```text
privileged
login
sudo
world-writable-files
world-writable-directories
suid
sgid
ports
firewall
ssh
cron
systemd
auth
```

CLI arguments shall be validated.

Invalid combinations shall return a usage error.

---

# 11. Exit-Code Requirements

The auditor shall provide automation-friendly exit codes:

| Code | Meaning                                   |
| ---: | ----------------------------------------- |
|  `0` | Scan completed with no findings           |
|  `1` | Scan completed and findings were detected |
|  `2` | Invalid CLI usage                         |
|  `3` | Execution or internal error               |

This allows the auditor to be integrated into automation workflows.

---

# 12. Safety Requirements

The auditor shall be read-only by design.

It shall not intentionally:

* Modify users
* Modify groups
* Change file permissions
* Modify firewall rules
* Disable services
* Remove persistence
* Execute discovered scripts
* Execute discovered binaries
* Exploit vulnerabilities
* Scan external systems

Where elevated privileges are required, the tool should use the minimum privileges necessary.

---

# 13. Error-Handling Requirements

The auditor shall:

* Detect invalid input.
* Handle unavailable commands where possible.
* Handle missing configuration files.
* Propagate check execution failures.
* Return appropriate CLI exit codes.
* Continue safely where an individual check can be skipped without compromising the scan.

---

# 14. Non-Functional Requirements

## NFR-01 — Portability

The project should target common Linux environments using standard command-line utilities where practical.

## NFR-02 — Maintainability

Security checks shall be modular rather than implemented entirely inside `auditor.sh`.

## NFR-03 — Explainability

Findings should provide enough evidence for a human investigator to understand why they were generated.

## NFR-04 — Determinism

Risk scoring and severity classification shall produce consistent results for the same inputs.

## NFR-05 — Automation

JSON reporting and exit codes shall support integration into automation pipelines.

## NFR-06 — Safety

The default behavior shall be observational rather than destructive.

---

# 15. Out of Scope

The following are intentionally outside the scope of the release:

* Exploitation
* Vulnerability exploitation
* Malware detection
* Remote host scanning
* Network vulnerability scanning
* Automatic remediation
* Exploit databases
* Compliance-framework auditing
* Advanced SELinux analysis
* Advanced AppArmor analysis
* Cloud security assessment
* Active penetration testing

---

# 16. Future Requirements

Potential future versions may introduce:

* Improved service baselines
* Improved cron baseline handling
* Additional Linux distributions
* More authentication analysis
* Additional security checks
* Configuration files
* Improved machine-readable output
* Automated testing infrastructure
* CI/CD integration
* Optional AI-assisted explanation of findings

AI should remain an **explanation and analysis aid**, not the authoritative security decision-maker.

---

# 17. Release Requirement

Version `2.1.0` shall be considered release-ready when:

```text
Requirements documented       ✅
Architecture documented       ✅
Implementation complete      ✅
Testing complete              ✅
Security findings documented  ✅
README complete               ✅
CHANGELOG complete            ✅
LICENSE present               ✅
CLI functional                ✅
JSON validated                ✅
```

**Release target: LinSec Auditor v2.1.0**
