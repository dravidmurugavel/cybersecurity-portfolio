# Changelog

All notable changes to **LinSec Auditor** are documented in this file.

The project follows a practical security-tool development lifecycle:

```text
Requirements
    ↓
Design
    ↓
Implementation
    ↓
Testing
    ↓
Assessment
    ↓
Improvement
    ↓
Release
```

---

# [2.1.0] — Release Candidate

## Added

### Command-Line Interface

Added non-interactive CLI support for automation and repeatable security assessments.

Supported operations:

```bash
./auditor.sh --help
./auditor.sh --full
./auditor.sh --check firewall
./auditor.sh --check suid
```

### Report Formats

Added:

```bash
--format txt
--format json
```

### File Output

Added:

```bash
--output FILE
```

Example:

```bash
./auditor.sh --full --format json --output reports/full.json
```

### Automation Exit Codes

Added standardized exit codes:

```text
0 = Scan completed with no findings
1 = Scan completed with findings
2 = Invalid command-line usage
3 = Scan execution error
```

### CLI Validation

Added validation for invalid combinations such as:

```bash
./auditor.sh --format json
```

and:

```bash
./auditor.sh --output report.json
```

These require an explicit scan operation.

### JSON Serialization

Replaced manually constructed JSON with `jq`-based serialization.

This prevents malformed JSON caused by:

* quotes
* backslashes
* newlines
* control characters
* command output containing special characters

### CLI Output Isolation

Separated scan presentation output from machine-readable JSON output.

JSON mode now produces a clean JSON document suitable for:

* `jq`
* scripts
* automation
* downstream processing

### Regression Testing

Validated:

* full TXT scan
* full JSON scan
* individual TXT scan
* individual JSON scan
* JSON parsing
* CLI argument validation
* exit-code behavior
* output-file generation

---

# [2.0.0] — Risk Assessment Engine

## Added

### Central Risk Engine

Introduced centralized risk calculation:

```text
Score = (Privilege + Exposure + Likelihood) × Confidence
```

Factors:

```text
Privilege   0–3
Exposure    0–3
Likelihood  0–3
Confidence  1–3
```

Maximum score:

```text
27
```

### Severity Classification

Added:

```text
0–5     INFO
6–11    LOW
12–17   MEDIUM
18–22   HIGH
23–27   CRITICAL
```

### Structured Findings

Findings now contain:

* Finding ID
* Check
* Title
* Description
* Evidence
* Privilege
* Exposure
* Likelihood
* Confidence
* Risk score
* Severity
* Recommendation

### Finding IDs

Added deterministic finding identifiers such as:

```text
SUID-001
PORT-001
FIREWALL-001
CRON-001
```

### Finding Sorting

Findings are sorted by risk score so higher-priority findings appear first.

### Recommendation Engine

Added deterministic recommendations based on severity.

Recommendations are intended to guide investigation and review rather than automatically modify the system.

### Evidence-Oriented Assessment

Checks were redesigned to preserve supporting evidence with each finding.

---

# [1.0.0] — Initial Auditor

## Added

Initial modular Linux security auditing functionality.

### Security Checks

Implemented:

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

### Interactive Interface

Added interactive menu:

```text
1. Complete Security Scan
2. Run Individual Check
3. Export Report
4. Exit
```

### Individual Checks

Added the ability to execute a single security check without running the complete assessment.

### Terminal Reporting

Added human-readable terminal output with:

* status indicators
* colored severity
* finding summaries
* evidence
* recommendations

### Report Export

Added TXT and JSON report generation.

### Service Baseline

Added configurable authorized-service baseline for network-listening checks.

Example:

```text
service|protocol|port
```

### Modular Architecture

Separated security checks, assessment logic, and output components into dedicated directories.

---

# Development Milestones

## Requirements Phase

Defined the initial security assessment scope and established a read-only design.

Primary requirements included:

* local Linux assessment
* evidence collection
* modular checks
* human-readable output
* report generation
* safe execution

---

## Design Phase

Designed the project around independent security checks and shared assessment infrastructure.

The architecture evolved into:

```text
auditor.sh
    │
    ├── checks/
    │
    ├── engine/
    │
    ├── output/
    │
    └── config/
```

---

## Implementation Phase

Implemented the individual Linux security checks and supporting infrastructure.

---

## Risk-Engine Phase

The project evolved from:

```text
DISCOVER
   ↓
REPORT
```

into:

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

This changed the project from a collection of Linux enumeration commands into a more structured security assessment tool.

---

## CLI Phase

The interactive auditor was extended with a command-line interface to support repeatable and automation-friendly operation.

The CLI introduced:

```text
--help
--full
--check
--format
--output
```

along with standardized exit codes.

---

## Testing Phase

Testing expanded from individual component testing to integration and regression testing.

Validated areas included:

```text
Risk calculations
        ↓
Finding generation
        ↓
Finding sorting
        ↓
Terminal output
        ↓
JSON serialization
        ↓
CLI execution
        ↓
Exit codes
        ↓
Report validation
```

---

# Security Design Principles

Throughout development, the project maintained several principles.

### Read-only by default

The auditor observes the system rather than modifying it.

### Evidence before conclusions

A detected configuration is reported with supporting evidence instead of automatically being labeled malicious.

### Centralized risk logic

Risk calculation is handled by a shared engine rather than duplicated across individual checks.

### Deterministic output

Given the same system state and configuration, the assessment logic should produce predictable findings and recommendations.

### Automation compatibility

Machine-readable JSON and standardized exit codes allow the tool to participate in larger security workflows.

### Human oversight

The auditor assists security assessment; it does not automatically make containment or remediation decisions.

---

# Future Releases

Potential future work may include:

* baseline drift detection
* historical report comparison
* configurable exclusions
* expanded authentication analysis
* additional SSH checks
* integrity monitoring
* report diffing
* security automation integrations
* optional dashboard functionality

Future functionality should preserve the project's read-only, evidence-oriented design.

---

## Versioning

LinSec Auditor uses semantic versioning:

```text
MAJOR.MINOR.PATCH
```

Current release candidate:

```text
2.1.0
```
