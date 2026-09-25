# LinSec Auditor

**Linux Security Auditor — Read-only Linux security assessment and risk-prioritization tool written in Bash**

LinSec Auditor is a modular Linux security auditing tool designed to inspect a local Linux system for common security weaknesses, collect supporting evidence, assess risk, and produce prioritized findings.

The project was developed as a practical cybersecurity portfolio project following a lightweight **Software Development Life Cycle (SDLC)**:

```text
Requirements
     ↓
Design
     ↓
Implementation
     ↓
Testing
     ↓
Security Assessment
     ↓
Improvement
     ↓
Release
```

The auditor follows a security-focused workflow:

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

---

## Features

* 13 Linux security checks
* Centralized risk-scoring engine
* Finding IDs and structured evidence
* Severity classification
* Deterministic security recommendations
* Human-readable terminal reports
* JSON report generation
* CLI and interactive modes
* Individual security checks
* Configurable service baseline
* Read-only security assessment design
* Automation-friendly exit codes
* Modular Bash architecture
* Evidence-oriented findings

---

# Security Checks

LinSec Auditor currently performs the following checks:

| #  | Check                      | Purpose                                                           |
| -- | -------------------------- | ----------------------------------------------------------------- |
| 1  | Privileged Accounts        | Identify accounts using UID 0                                     |
| 2  | Login-capable Accounts     | Identify system/service accounts with interactive shells          |
| 3  | Sudo Configuration         | Review administrative privileges                                  |
| 4  | World-writable Files       | Identify files writable by other users                            |
| 5  | World-writable Directories | Identify broadly writable directories                             |
| 6  | SUID Files                 | Identify SUID executables and investigate risky permissions       |
| 7  | SGID Files                 | Identify SGID executables and investigate risky permissions       |
| 8  | Listening Ports            | Identify network services listening locally                       |
| 9  | Firewall                   | Inspect firewall configuration and policies                       |
| 10 | SSH                        | Assess SSH exposure and configuration                             |
| 11 | Cron                       | Investigate scheduled tasks and persistence-related configuration |
| 12 | Systemd                    | Investigate enabled services and service execution configuration  |
| 13 | Failed Authentication      | Review failed authentication activity                             |

The tool does **not automatically classify every discovered configuration as malicious**.

Findings require contextual interpretation.

---

# Risk Assessment Engine

LinSec Auditor uses a centralized risk model to prioritize findings.

Each finding receives four factors:

```text
Privilege   P = 0–3
Exposure    E = 0–3
Likelihood  L = 0–3
Confidence  C = 1–3
```

The risk score is calculated as:

```text
Score = (P + E + L) × C
```

Maximum score:

```text
27
```

Severity classification:

| Score | Severity |
| ----: | -------- |
|   0–5 | INFO     |
|  6–11 | LOW      |
| 12–17 | MEDIUM   |
| 18–22 | HIGH     |
| 23–27 | CRITICAL |

### Example

A root-owned SUID executable that is writable by other users can receive a high privilege impact and high likelihood/confidence when the evidence supports those conditions.

The purpose of the risk engine is **prioritization**, not automatic proof of compromise.

---

# Finding Model

Each finding contains structured information:

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

Example:

```text
ID             : SUID-001
Check          : SUID
Severity       : CRITICAL
Risk Score     : 24

Title:
Writable privileged executable

Evidence:
-rwsrwxr-x root root /path/to/example
```

This allows findings from different checks to be handled consistently by the reporting layer.

---

# Architecture

```text
linux-security-auditor/
│
├── auditor.sh
│
├── checks/
│   ├── accounts.sh
│   ├── login.sh
│   ├── sudo.sh
│   ├── files.sh
│   ├── directories.sh
│   ├── suid.sh
│   ├── sgid.sh
│   ├── network.sh
│   ├── firewall.sh
│   ├── ssh.sh
│   ├── cron.sh
│   ├── systemd.sh
│   └── auth.sh
│
├── config/
│   └── service_baseline.conf
│
├── engine/
│   ├── risk_engine.sh
│   ├── finding.sh
│   ├── finding_sort.sh
│   └── recommendation.sh
│
├── output/
│   ├── status.sh
│   ├── terminal.sh
│   ├── json.sh
│   ├── banner.sh
│   ├── colors.sh
│   └── menu.sh
│
├── reports/
├── tests/
│
├── requirements.md
├── design.md
├── testing.md
├── findings.md
├── README.md
├── CHANGELOG.md
└── LICENSE
```

### Component responsibilities

**`auditor.sh`**

Main entry point. Handles initialization, CLI parsing, scan execution, interactive mode, and report selection.

**`checks/`**

Contains individual security assessment modules.

**`engine/`**

Contains shared finding management, risk calculation, severity classification, sorting, and recommendations.

**`output/`**

Contains terminal presentation, JSON serialization, colors, status messages, banners, and menus.

**`config/`**

Contains security assessment configuration such as the authorized service baseline.

**`reports/`**

Stores generated audit reports.

**`tests/`**

Contains project testing material.

---

# Service Baseline

Network listeners are evaluated against a local authorized-service baseline.

Example:

```text
# service|protocol|port

apache2|tcp|80
systemd-resolve|udp|53
systemd-resolve|tcp|53
systemd-resolve|udp|5355
systemd-resolve|tcp|5355
tor|tcp|9050
```

This allows the auditor to distinguish between:

```text
Expected service
        ↓
Known baseline
        ↓
Review configuration
```

and:

```text
Unexpected listener
        ↓
Not present in baseline
        ↓
Investigate
```

A service missing from the baseline is **not automatically malicious**. The baseline represents local authorization context and must be maintained appropriately.

---

# Usage

## Interactive Mode

Run:

```bash
./auditor.sh
```

The interactive interface provides:

```text
1. Complete Security Scan
2. Run Individual Check
3. Export Report
4. Exit
```

Individual checks can be selected when investigating a specific area of the system.

---

# Command-Line Interface

## Help

```bash
./auditor.sh --help
```

## Complete Scan

```bash
./auditor.sh --full
```

## Individual Check

```bash
./auditor.sh --check firewall
```

Examples:

```bash
./auditor.sh --check ssh
./auditor.sh --check suid
./auditor.sh --check cron
./auditor.sh --check systemd
```

## JSON Output

```bash
./auditor.sh --full --format json
```

Individual check:

```bash
./auditor.sh --check firewall --format json
```

## Save a Report

```bash
./auditor.sh --full --format json --output reports/full.json
```

Example:

```bash
./auditor.sh --check firewall --format txt --output reports/firewall.txt
```

---

# Available CLI Checks

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

---

# Exit Codes

LinSec Auditor provides automation-friendly exit codes:

| Code | Meaning                         |
| ---: | ------------------------------- |
|  `0` | Scan completed with no findings |
|  `1` | Scan completed with findings    |
|  `2` | Invalid command-line usage      |
|  `3` | Scan execution error            |

This allows the tool to be integrated into scripts or other security automation.

Example:

```bash
./auditor.sh --check firewall --format json

case $? in
    0) echo "No findings" ;;
    1) echo "Findings detected" ;;
    2) echo "Invalid usage" ;;
    3) echo "Execution error" ;;
esac
```

---

# Reporting

## Terminal Report

The terminal interface provides:

* Finding IDs
* Check names
* Evidence
* Risk factors
* Risk scores
* Severity
* Recommendations
* Severity summary

Findings are sorted by risk score so higher-priority findings appear first.

## JSON Report

JSON output provides structured findings suitable for:

* automation
* scripting
* future dashboards
* SIEM integration
* additional analysis

Example structure:

```json
{
  "findings": [
    {
      "id": "SUID-001",
      "check": "SUID",
      "title": "Writable privileged executable",
      "description": "A SUID executable is writable by its group or other users.",
      "evidence": "...",
      "privilege": 3,
      "likelihood": 3,
      "confidence": 3,
      "risk_score": 24,
      "severity": "CRITICAL",
      "recommendation": "..."
    }
  ]
}
```

---

# Safety Model

LinSec Auditor is designed as a **read-only assessment tool**.

The auditor does not:

* modify user accounts
* change passwords
* change permissions
* disable services
* modify firewall rules
* delete files
* execute discovered scripts
* execute discovered binaries
* exploit vulnerabilities
* scan external hosts

The tool is intended to **observe and report**, not automatically remediate.

Some checks may require elevated privileges to obtain complete system information.

The principle is:

```text
Observe
  ↓
Collect evidence
  ↓
Assess
  ↓
Report
```

rather than:

```text
Detect
  ↓
Automatically change system
```

---

# Security Investigation Workflow

The project is designed around a basic incident-response mindset:

```text
DISCOVERY
    ↓
Identify configuration or activity
    ↓
PRESERVE
    ↓
Record evidence
Ownership
Permissions
Timestamps
Configuration
    ↓
ANALYSIS
    ↓
Determine exposure
Determine privileges
Determine expected behavior
Correlate evidence
    ↓
RISK ASSESSMENT
    ↓
Calculate priority
    ↓
REPORT
    ↓
Review findings
    ↓
CONTAINMENT
```

The auditor itself stops at assessment and reporting.

Containment decisions remain the responsibility of the administrator or incident-response process.

---

# Persistence Investigation

The Cron and Systemd checks specifically support investigation of potential persistence mechanisms.

The security model is:

```text
Systemd
   ↓
Service
   ↓
ExecStart
   ↓
Executable
```

and:

```text
Cron
   ↓
Schedule
   ↓
User
   ↓
Command
```

Both can provide automatic execution.

Therefore, investigations should consider:

```text
What executes?
      ↓
Who executes it?
      ↓
With what privileges?
      ↓
When does it execute?
      ↓
Where is the executable?
      ↓
Is the configuration expected?
```

The presence of a scheduled task or enabled service alone does not establish malicious activity.

---

# Development and Testing

The project was developed incrementally using an SDLC-oriented workflow.

Testing included:

* Bash syntax validation
* Risk-engine unit testing
* Risk boundary testing
* Finding-generator testing
* Finding sorting
* Terminal reporting
* JSON serialization
* JSON validation with `jq`
* Individual-check execution
* Full-scan execution
* CLI argument validation
* Output redirection
* TXT report generation
* JSON report generation
* CLI exit-code testing
* Error-path testing

Project-wide Bash syntax validation:

```bash
find . -name "*.sh" -print0 | while IFS= read -r -d '' file; do
    bash -n "$file" || exit 1
done
```

JSON reports are validated using:

```bash
jq empty report.json
```

---

# Known Limitations

LinSec Auditor is intentionally focused on foundational Linux security assessment.

It does not currently provide:

* vulnerability exploitation
* malware analysis
* remote host scanning
* automated remediation
* vulnerability database integration
* full compliance-framework mapping
* advanced SELinux analysis
* advanced AppArmor analysis
* cloud-security assessment
* enterprise-scale centralized management

These limitations are deliberate.

The project focuses on producing **clear evidence and prioritized local security findings** rather than attempting to become a complete enterprise vulnerability-management platform.

---

# Future Improvements

Potential future versions could include:

* configurable check severity profiles
* expanded service baselines
* configurable exclusions
* richer JSON schema
* historical report comparison
* baseline drift detection
* automated report diffing
* additional authentication analysis
* stronger SSH configuration analysis
* system integrity checks
* optional dashboard
* integration with security automation pipelines

Future automation should preserve the project's read-only and evidence-first design.

---

# Portfolio Value

This project demonstrates practical experience with:

* Linux security administration
* Bash scripting
* Linux permissions
* SUID/SGID analysis
* User and privilege analysis
* Sudo configuration
* Network-service enumeration
* Firewall assessment
* SSH security assessment
* Cron investigation
* Systemd investigation
* Authentication-log analysis
* Risk scoring
* Evidence collection
* Structured reporting
* CLI design
* JSON serialization
* Security-focused software development
* Testing and validation

More importantly, the project demonstrates the ability to connect individual Linux concepts into a security assessment workflow:

```text
Linux Administration
        ↓
Security Observation
        ↓
Evidence Collection
        ↓
Risk Assessment
        ↓
Prioritization
        ↓
Security Reporting
```

---

# Project Status

**Version:** 2.1.0

**Status:** Release Candidate

The core auditor, risk engine, interactive interface, reporting system, CLI, exit-code handling, and regression testing are complete.

Final release activities include repository documentation, cleanup, final validation, and version control release.

---

# Disclaimer

LinSec Auditor is intended for authorized security assessment, defensive administration, education, and laboratory environments.

Only run the tool on systems you own or have explicit permission to assess.

The tool provides assessment information and does not guarantee that a system is secure or compromised.

---

## Author

Dravid Murugavel

Developed as a practical Linux cybersecurity portfolio project focused on:

**Linux Security • Bash Automation • Security Assessment • Incident Response Fundamentals**
