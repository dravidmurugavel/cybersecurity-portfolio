# LinSec Auditor — System Design

## 1. Architecture Overview

LinSec Auditor uses a modular Bash architecture.

The design separates:

```text
Security Checks
      ↓
Risk Engine
      ↓
Finding Engine
      ↓
Sorting / Recommendations
      ↓
Output / Reporting
      ↓
CLI / Interactive Interface
```

This separation makes individual security checks easier to maintain and allows the assessment engine to remain independent from the presentation layer.

---

# 2. High-Level Architecture

```text
                    ┌──────────────────────┐
                    │      auditor.sh      │
                    │   Main Controller    │
                    └──────────┬───────────┘
                               │
                ┌──────────────┴──────────────┐
                ↓                             ↓
        Interactive Mode                 CLI Mode
                │                             │
                └──────────────┬──────────────┘
                               ↓
                       Security Checks
                               │
        ┌──────────────────────┼──────────────────────┐
        ↓          ↓           ↓          ↓           ↓
     Accounts   Files       Network     Services     Auth
        │          │           │           │           │
        └──────────┴───────────┴───────────┴───────────┘
                               ↓
                         Finding Engine
                               ↓
                          Risk Engine
                               ↓
                     Severity Classification
                               ↓
                       Finding Prioritization
                               ↓
                  ┌────────────┴────────────┐
                  ↓                         ↓
             Terminal/TXT                 JSON
```

---

# 3. Project Structure

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

---

# 4. Main Controller

`auditor.sh` acts as the application controller.

Its responsibilities include:

* Loading modules.
* Parsing CLI arguments.
* Starting interactive mode.
* Running security checks.
* Managing scan state.
* Managing findings.
* Selecting output format.
* Handling exit codes.

The controller does not contain the implementation of every security check.

Instead, it calls modular check functions.

---

# 5. Security Check Layer

The `checks/` directory contains individual security assessment modules.

Each module focuses on one security domain.

For example:

```text
checks/suid.sh
        ↓
SUID detection

checks/cron.sh
        ↓
Cron investigation

checks/network.sh
        ↓
Listening-port investigation

checks/systemd.sh
        ↓
Systemd service investigation
```

This follows a single-responsibility approach.

A new check can be added without rewriting the entire application.

---

# 6. Check Execution Model

Each check follows the general model:

```text
Start Check
    ↓
Collect System Data
    ↓
Evaluate Condition
    ↓
Collect Evidence
    ↓
Assign Risk Factors
    ↓
Create Finding
    ↓
Return Status
```

The check itself should focus on **detecting and describing** the condition.

Risk calculation and finding storage are handled centrally.

---

# 7. Finding Engine

The finding engine provides a common representation for security findings.

The central function is:

```text
add_finding()
```

A check provides:

```text
Check
Title
Description
Evidence
Risk Factors
```

The finding engine then:

```text
Generate Finding ID
        ↓
Calculate Risk
        ↓
Classify Severity
        ↓
Generate Recommendation
        ↓
Store Finding
```

This prevents individual checks from implementing their own inconsistent finding structures.

---

# 8. Finding Data Model

Internally, findings are stored in arrays.

Conceptually:

```text
Finding
├── ID
├── Check
├── Title
├── Description
├── Evidence
├── Privilege
├── Exposure
├── Likelihood
├── Confidence
├── Risk Score
├── Severity
└── Recommendation
```

This structured representation allows the same finding data to be used by:

```text
Terminal output
TXT reports
JSON reports
Sorting
Future integrations
```

---

# 9. Risk Engine

The risk engine is centralized in:

```text
engine/risk_engine.sh
```

The engine validates the four risk inputs:

```text
Privilege   0–3
Exposure    0–3
Likelihood  0–3
Confidence  1–3
```

The calculation is:

```text
Risk Score = (P + E + L) × C
```

Maximum:

```text
27
```

Centralizing this logic ensures every finding uses the same calculation.

---

# 10. Severity Engine

Severity is determined from the calculated risk score.

```text
0–5     → INFO
6–11    → LOW
12–17   → MEDIUM
18–22   → HIGH
23–27   → CRITICAL
```

The classification is deterministic.

A finding with the same risk score will always receive the same severity.

---

# 11. Recommendation Engine

The recommendation engine is located in:

```text
engine/recommendation.sh
```

Recommendations are generated according to severity.

Conceptually:

```text
CRITICAL
    ↓
Immediate investigation / evidence preservation

HIGH
    ↓
Prompt investigation

MEDIUM
    ↓
Configuration and evidence review

LOW
    ↓
Routine hardening review

INFO
    ↓
Documentation / awareness
```

The engine does not automatically remediate findings.

---

# 12. Finding Prioritization

Findings are sorted using their risk score.

The sorting layer:

```text
engine/finding_sort.sh
```

produces finding indexes ordered by descending score.

Conceptually:

```text
Finding A → 24
Finding B → 18
Finding C → 12
Finding D → 7
Finding E → 3
```

The highest-risk observations therefore appear first in reports.

---

# 13. Service Baseline

Expected services and ports are represented in:

```text
config/service_baseline.conf
```

Example:

```text
apache2|tcp|80
systemd-resolve|udp|53
systemd-resolve|tcp|53
tor|tcp|9050
```

The baseline provides environmental context.

It is not intended to declare every unlisted service malicious.

Instead:

```text
Observed service
      ↓
Compare baseline
      ↓
Known?
 ┌────┴────┐
Yes        No
 ↓          ↓
Expected   Review
```

---

# 14. Output Architecture

The output layer is separated from detection.

```text
output/
├── status.sh
├── terminal.sh
├── json.sh
├── banner.sh
├── colors.sh
└── menu.sh
```

This prevents presentation logic from being tightly coupled to security checks.

---

# 15. Terminal Output

Terminal output is designed for human investigation.

It includes:

* Check status
* Findings
* Severity
* Risk score
* Evidence
* Recommendations
* Summary

Color coding provides quick visual differentiation between severity levels.

---

# 16. JSON Output

JSON output is generated from the structured finding data.

The project uses `jq` to safely serialize finding values.

This avoids problems caused by manually constructing JSON strings containing:

* Quotes
* Backslashes
* Newlines
* Control characters

The resulting structure is suitable for programmatic processing.

---

# 17. CLI Architecture

The CLI supports:

```text
--help
--full
--check NAME
--format txt|json
--output FILE
```

The parser processes arguments independently rather than relying on a single positional argument.

Conceptually:

```text
Command
   ↓
Argument Parser
   ↓
Validate Options
   ↓
Select Scan
   ↓
Select Format
   ↓
Execute
   ↓
Return Exit Code
```

---

# 18. Interactive Architecture

When no CLI operation is requested, the auditor can operate interactively.

```text
Main Menu
│
├── Complete Security Scan
│
├── Run Individual Check
│
├── Export Report
│
└── Exit
```

Individual checks are isolated by resetting the finding state before execution.

This prevents findings from previous scans from leaking into subsequent reports.

---

# 19. JSON Output Isolation

A key architectural requirement is that machine-readable output must not be contaminated by human-readable status messages.

Therefore JSON CLI execution follows:

```text
CLI JSON Mode
      ↓
Suppress scan UI
      ↓
Execute checks
      ↓
Store findings
      ↓
Generate JSON
      ↓
Output JSON
```

This allows:

```bash
./auditor.sh --full --format json | jq .
```

without terminal messages corrupting the JSON stream.

---

# 20. Error Handling

The architecture distinguishes between:

```text
No findings
```

and:

```text
Execution failure
```

Exit codes communicate the result to external automation:

```text
0 → clean
1 → findings
2 → usage error
3 → execution error
```

This separation is important because a security finding is not itself an application failure.

---

# 21. Security and Safety Model

The auditor follows a read-only model.

```text
Collect
  ↓
Inspect
  ↓
Evaluate
  ↓
Report
```

It does not follow:

```text
Detect
  ↓
Modify
  ↓
Disable
  ↓
Delete
```

No automatic remediation is performed.

This reduces the risk of the auditor itself causing changes during an investigation.

---

# 22. Evidence Model

Findings should contain enough evidence to allow an investigator to reproduce the observation.

Examples include:

```text
File path
Permissions
Owner
Port
Protocol
Service
ExecStart
User
Group
Cron entry
Authentication event
```

The goal is:

```text
Finding
   ↓
Evidence
   ↓
Independent verification
```

rather than producing unexplained security alerts.

---

# 23. Persistence Investigation Design

Systemd and cron are treated as related persistence sources.

The investigation model is:

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
Command
   ↓
Executable
```

The investigator can then correlate:

```text
Executable
   ↓
Owner
   ↓
Permissions
   ↓
Timestamps
   ↓
Process activity
   ↓
Logs
```

This allows the auditor to support a broader persistence investigation rather than simply reporting that a scheduled task exists.

---

# 24. Testing Architecture

Testing is performed at multiple levels:

```text
Syntax
  ↓
Individual functions/checks
  ↓
CLI behavior
  ↓
Output formats
  ↓
Exit codes
  ↓
Regression tests
```

JSON output is validated using `jq`.

Bash syntax is validated using:

```bash
bash -n
```

The architecture therefore separates implementation from validation.

---

# 25. Design Principles

The project follows these principles:

### Modularity

Each security domain is implemented separately.

### Centralization

Risk calculation and finding creation are centralized.

### Explainability

Findings contain supporting evidence.

### Determinism

Risk scoring and severity classification are predictable.

### Safety

The auditor is read-only.

### Automation

CLI options, JSON output, and exit codes support automation.

### Maintainability

The project avoids placing all functionality into a single Bash script.

### Security-first design

The tool prioritizes evidence collection and investigation rather than automatic remediation.

---

# 26. Future Architecture

Future versions could extend the architecture with:

```text
Current Architecture
       ↓
Additional Checks
       ↓
Configuration Layer
       ↓
CI/CD Testing
       ↓
External Log Sources
       ↓
SIEM Integration
       ↓
Optional AI Explanation Layer
```

AI should remain an optional analytical layer rather than replacing deterministic detection and risk calculations.

---

# 27. Final Architecture Summary

The final design can be summarized as:

```text
                 LINSEC AUDITOR
                       │
                       ↓
                 INPUT / CLI
                       │
                       ↓
               SECURITY CHECKS
                       │
                       ↓
                EVIDENCE DATA
                       │
                       ↓
                FINDING ENGINE
                       │
             ┌─────────┴─────────┐
             ↓                   ↓
        RISK ENGINE       RECOMMENDATION
             │                   │
             └─────────┬─────────┘
                       ↓
                PRIORITIZATION
                       │
             ┌─────────┴─────────┐
             ↓                   ↓
        HUMAN OUTPUT       MACHINE OUTPUT
             │                   │
           TXT/CLI              JSON
```

The architecture intentionally separates **detection, assessment, prioritization, and presentation** so that the project can evolve without requiring a complete rewrite.

---

## Design Status

```text
Requirements Architecture    ✅
Modular Check Layer           ✅
Finding Engine                ✅
Risk Engine                   ✅
Recommendation Engine         ✅
Prioritization                ✅
CLI Architecture              ✅
Interactive Interface         ✅
TXT Reporting                 ✅
JSON Reporting                ✅
Safety Model                  ✅
Testing Architecture          ✅
```

**Design status: Complete**

**Project version: 2.1.0**
