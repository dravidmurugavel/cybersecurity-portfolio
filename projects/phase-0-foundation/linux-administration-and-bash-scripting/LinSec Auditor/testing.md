# Linux Security Auditor — Testing Documentation

## 1. Purpose

This document describes the testing performed for the Linux Security Auditor project.

The goal was to verify that the auditor:

* Executes correctly.
* Handles valid and invalid CLI input.
* Runs full and individual checks.
* Produces valid TXT and JSON output.
* Returns meaningful exit codes.
* Handles execution errors.
* Maintains valid Bash syntax across the project.
* Produces automation-friendly output.

Testing focused on **functional correctness and regression prevention** rather than attempting to prove that every possible Linux security condition can be detected.

---

# 2. Testing Environment

Testing was performed in an authorized Linux lab environment.

Environment:

```text
OS: Kali GNU/Linux Rolling 2026.2
Architecture: x86_64
Hostname: kali
Shell: Bash
```

The auditor was tested against the local Linux system only.

---

# 3. Bash Syntax Testing

All Bash scripts were checked with Bash's syntax-only mode.

Command:

```bash
find . -name "*.sh" -print0 | while IFS= read -r -d '' file; do
    bash -n "$file" || exit 1
done
```

Result:

```text
Exit code: 0
```

This confirmed that the project's Bash scripts passed syntax validation.

---

# 4. ShellCheck

ShellCheck availability was checked with:

```bash
command -v shellcheck
```

ShellCheck was not installed in the test environment.

No package installation was performed because the project already passed Bash syntax validation and functional regression testing.

ShellCheck remains a possible future quality-assurance improvement.

---

# 5. CLI Help Testing

Command:

```bash
./auditor.sh --help
```

Verified:

* Help text is displayed.
* Full scan option is documented.
* Individual check option is documented.
* TXT and JSON formats are documented.
* Output file option is documented.
* Available check names are listed.
* Exit codes are documented.

---

# 6. Full Scan Testing

The complete auditor was executed using:

```bash
./auditor.sh --full --format txt
```

The test verified that all 13 security checks could be executed through the CLI.

Checks included:

```text
Privileged Accounts
Login-capable Accounts
Sudo Configuration
World-writable Files
World-writable Directories
SUID Files
SGID Files
Listening Ports
Firewall Configuration
SSH Security Assessment
Cron Jobs
Systemd Services
Failed Authentication
```

---

# 7. Individual Check Testing

Individual checks were tested through the CLI.

Example:

```bash
./auditor.sh --check firewall --format txt
```

The test confirmed that a single check can execute independently without requiring a complete scan.

The same approach was used for other supported check names.

---

# 8. JSON Output Testing

JSON output was tested using:

```bash
./auditor.sh --full --format json >/tmp/full.json
```

The generated JSON was then validated using:

```bash
jq empty /tmp/full.json
```

Result:

```text
Exit code: 0
```

An individual-check JSON report was also tested:

```bash
./auditor.sh --check firewall --format json >/tmp/firewall.json
jq empty /tmp/firewall.json
```

Result:

```text
Exit code: 0
```

This confirmed that the JSON output was syntactically valid.

---

# 9. Output Isolation Regression Test

A regression issue was identified during development where terminal UI output could contaminate JSON output.

For example:

```text
[CHECK] Privileged Accounts
[PASS] ...
{
    "findings": [...]
}
```

This is invalid JSON.

The CLI was changed so that JSON scans suppress scan-phase terminal output before the JSON report is generated.

The corrected workflow is:

```text
CLI JSON mode
      ↓
Run scan silently
      ↓
Collect findings
      ↓
Generate JSON
      ↓
Write JSON only
```

The regression test:

```bash
./auditor.sh --full --format json >/tmp/full.json
jq empty /tmp/full.json
```

returned:

```text
0
```

The same test passed for the firewall JSON report.

---

# 10. Exit Code Testing

The auditor uses the following exit-code model:

| Exit Code | Meaning                                   |
| --------: | ----------------------------------------- |
|       `0` | Successful scan with no findings          |
|       `1` | Scan completed and findings were detected |
|       `2` | Invalid usage or CLI input                |
|       `3` | Execution or internal scan error          |

This allows the tool to be used in automation.

---

# 11. Invalid Check Testing

An invalid check name was supplied to the CLI.

Example:

```bash
./auditor.sh --check invalid-check
```

Expected behavior:

```text
Exit code: 2
```

This confirmed that invalid user input is treated as a usage error.

---

# 12. Invalid Option Combination Testing

The following command was tested:

```bash
./auditor.sh --format json
```

Because a format is only meaningful when a scan mode is selected, the command was expected to fail.

Result:

```text
Exit code: 2
```

The same validation was tested with:

```bash
./auditor.sh --output reports/test.json
```

Result:

```text
Exit code: 2
```

This confirmed that `--format` and `--output` cannot be used without `--full` or `--check`.

---

# 13. Findings Exit Code Testing

The auditor was tested against checks capable of producing findings.

The expected behavior is:

```text
Scan completes
      ↓
Findings exist
      ↓
Exit code 1
```

This separates:

```text
Successful execution
```

from:

```text
No security findings
```

A finding is therefore not treated as an execution failure.

---

# 14. Clean Scan Exit Code

A check with no findings should return:

```text
Exit code: 0
```

This allows automation to distinguish a clean result from a scan containing findings.

---

# 15. Execution Error Testing

The error-handling path was tested using a temporary test condition that caused a check to return an execution failure.

Expected behavior:

```text
Check failure
      ↓
run_check propagates failure
      ↓
Full scan reports failure
      ↓
CLI returns:
3
```

Observed result:

```text
Exit code: 3
```

The temporary test branch was removed after validation.

This confirmed that the auditor distinguishes execution errors from security findings.

---

# 16. Regression Testing

The final regression test executed four core CLI combinations:

```bash
./auditor.sh --full --format txt >/tmp/full.txt
./auditor.sh --full --format json >/tmp/full.json
./auditor.sh --check firewall --format txt >/tmp/firewall.txt
./auditor.sh --check firewall --format json >/tmp/firewall.json
```

The two JSON files were then validated:

```bash
jq empty /tmp/full.json
jq empty /tmp/firewall.json
```

Both returned:

```text
0
```

This confirmed that the major CLI output paths remained functional after the latest changes.

---

# 17. Interactive Testing

The interactive interface was also tested.

The following areas were verified:

```text
Main Menu
    ↓
Complete Security Scan

Main Menu
    ↓
Run Individual Check
    ↓
Select Check

Main Menu
    ↓
Export Report
    ├── TXT
    ├── JSON
    └── Both
```

Interactive individual checks were also verified to reset previous findings before generating their report.

This prevents findings from a previous scan from incorrectly appearing in a later individual check.

---

# 18. Report Export Testing

TXT report export was tested through the interactive interface.

The generated report was written under:

```text
reports/
```

JSON report export was also tested.

Both-report export was verified through:

```text
Export Both
    ↓
TXT report
    ↓
JSON report
```

The JSON report was subsequently validated with `jq`.

---

# 19. Security-Safety Testing

The auditor was designed as a read-only security assessment tool.

Testing confirmed that the auditor does not intentionally:

* Modify users.
* Modify groups.
* Change permissions.
* Disable services.
* Modify firewall rules.
* Execute discovered scripts.
* Execute discovered binaries.
* Exploit vulnerabilities.
* Scan external hosts.

The tool collects and evaluates configuration and system-state information.

---

# 20. Final Test Matrix

| Test                          | Expected Result        | Result |
| ----------------------------- | ---------------------- | ------ |
| `--help`                      | Help displayed         | PASS   |
| Full TXT scan                 | Scan completes         | PASS   |
| Full JSON scan                | Valid JSON             | PASS   |
| Individual TXT check          | Check completes        | PASS   |
| Individual JSON check         | Valid JSON             | PASS   |
| `jq empty` full JSON          | Exit `0`               | PASS   |
| `jq empty` firewall JSON      | Exit `0`               | PASS   |
| Invalid check                 | Exit `2`               | PASS   |
| Format without scan           | Exit `2`               | PASS   |
| Output without scan           | Exit `2`               | PASS   |
| Findings detected             | Exit `1`               | PASS   |
| Clean scan                    | Exit `0`               | PASS   |
| Execution error               | Exit `3`               | PASS   |
| Bash syntax validation        | Exit `0`               | PASS   |
| Interactive individual checks | Correct findings reset | PASS   |
| TXT export                    | Report generated       | PASS   |
| JSON export                   | Report generated       | PASS   |
| Both exports                  | Both reports generated | PASS   |

---

# 21. Testing Conclusion

The Linux Security Auditor passed the project's planned functional and regression tests.

The most important validation areas were:

```text
CLI
 ↓
Checks
 ↓
Finding Engine
 ↓
Risk Assessment
 ↓
Terminal Reporting
 ↓
JSON Reporting
 ↓
Exit Codes
 ↓
Error Handling
```

The final regression tests confirmed that the primary CLI workflows continue to function correctly after the implementation changes.

The project can therefore move from implementation/testing into final release preparation.

---

## Testing Status

```text
Bash Syntax Tests       ✅
CLI Tests               ✅
Individual Checks       ✅
Full Scan               ✅
JSON Validation         ✅
Exit Code Tests         ✅
Error Handling          ✅
Interactive Testing     ✅
Report Export           ✅
Regression Testing      ✅
```

**Status: Testing Complete**
