# Module 09 — Linux Package Management & Package Investigation

## Overview

Module 09 focused on understanding how Linux software is installed, updated, tracked, and verified.

The main goal was not simply learning package-management commands. I wanted to understand how package-management information can be used during **SOC operations, incident response, and Linux investigations**.

A package can provide useful evidence about:

* What software is installed.
* Where it came from.
* Which version is installed.
* Which files belong to it.
* When it was installed or modified.
* Which user initiated the transaction.
* Whether package files show verification discrepancies.

The main security lesson I learned was:

> **Package-management data can help an investigator determine whether software is expected, where it came from, when it appeared, and what files it controls.**

---

# Topics Covered

* APT fundamentals
* `apt update`
* `apt upgrade`
* `apt list`
* `apt show`
* `apt-cache policy`
* APT repositories
* Repository signing configuration
* APT history
* DPKG
* `dpkg -s`
* `dpkg -L`
* `dpkg -S`
* `dpkg -V`
* `/var/log/dpkg.log`
* Package ownership
* Package files and executables
* Package integrity verification
* Package timelines
* YUM
* DNF
* RPM
* Python `pip`
* Snap
* Package-management security investigation
* Suspicious software investigation

---

# 1. APT and DPKG

Kali Linux is based on Debian, so its primary package-management system uses:

```text
APT
 ↓
DPKG
 ↓
.deb packages
```

APT operates at a higher level and handles tasks such as:

* Repositories
* Package dependency resolution
* Package installation
* Package upgrades
* Package indexes

DPKG works with the local Debian package database and performs lower-level package operations.

A useful mental model is:

```text
APT
 │
 ├── repositories
 ├── package versions
 ├── dependencies
 └── transactions
        ↓
      DPKG
        ↓
 local package database
        ↓
 installed files
```

This distinction became important during package investigations.

---

# 2. `apt --version`

I first identified the APT version on my Kali system:

```bash
apt --version
```

The system reported:

```text
apt 3.3.2 (amd64)
```

This established the package-management environment before beginning the investigation.

---

# 3. `apt update`

I used:

```bash
sudo apt update
```

The important lesson was that:

> `apt update` does not normally install package upgrades.

Instead, it refreshes the local package-index information from configured repositories.

My system contacted repositories including:

```text
http://kali.download/kali
https://download.sublimetext.com
```

APT output included both:

```text
Get:
```

and:

```text
Hit:
```

`Get` indicates that repository information was downloaded, while `Hit` indicates that existing information was considered current.

### Security relevance

Repository configuration is important during investigations because an unexpected repository can potentially introduce untrusted software.

An investigator should ask:

```text
Who configured the repository?
        ↓
Is the repository legitimate?
        ↓
What signing key is trusted?
        ↓
What packages does it provide?
        ↓
Were packages from it installed?
```

---

# 4. `apt list --upgradable`

I checked for packages with newer available versions:

```bash
apt list --upgradable
```

The system showed packages including:

```text
gstreamer1.0-plugins-bad
layer-shell-qt
Perl libraries
```

This taught me an important distinction:

> A package being listed as upgradable does not necessarily mean that a normal `apt upgrade` will immediately install that version.

On my Kali system, package-management behavior can involve dependency changes that result in packages being held back.

---

# 5. `apt show`

I investigated one package with:

```bash
apt show gstreamer1.0-plugins-bad
```

The output provided information such as:

```text
Version
Installed-Size
Depends
Description
```

The package description referred to the GStreamer "Bad Plug-ins."

An important lesson was that the word **"Bad"** in the package name is a GStreamer project classification related to plugin maturity or quality.

It does **not** mean that the package is malicious.

### Security lesson

Package names and descriptions should be interpreted in context rather than judged based on a single word.

---

# 6. Installed vs Candidate Version

I used:

```bash
apt-cache policy gstreamer1.0-plugins-bad
```

The output showed:

```text
Installed: 1.28.1-2
Candidate: 1.28.6-1
```

The candidate version is the version APT currently considers the preferred available version.

The output also showed the repository:

```text
http://http.kali.org/kali
kali-rolling/main
```

The important mental model became:

```text
Repository
    ↓
Available versions
    ↓
Candidate version
    ↓
Local DPKG database
    ↓
Installed version
```

This is useful when determining where an installed package came from and whether it differs from the currently available version.

---

# 7. APT Repositories

I inspected configured repositories with:

```bash
grep -RhvE '^\s*#|^\s*$' \
/etc/apt/sources.list \
/etc/apt/sources.list.d/ 2>/dev/null
```

My system contained:

```text
deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware

Types: deb
URIs: https://download.sublimetext.com/
Suites: apt/stable/
Signed-By: /etc/apt/keyrings/sublimehq-pub.asc
```

The `Signed-By` field identifies the key APT should use when verifying packages from that repository.

### Security relevance

Unexpected package sources can become valuable investigation leads.

However:

> **Unexpected does not automatically mean malicious.**

The investigator should establish legitimacy through configuration history, ownership, repository identity, signing configuration, and installed-package history.

---

# 8. APT Installation History

I inspected APT transaction history using:

```bash
grep -A5 -B2 "ca-certificates" /var/log/apt/history.log
```

The investigation showed:

```text
Start-Date: 2026-09-07 14:47:55
Commandline: apt install --reinstall ca-certificates
Requested-By: kali (1000)
Reinstall: ca-certificates:amd64 (20260601)
End-Date: 2026-09-07 14:48:04
```

This provided several useful investigation fields:

```text
Who     → kali
What    → ca-certificates
Action  → reinstall
When    → 14:47:55–14:48:04
Version → 20260601
```

### Security relevance

APT history can help establish:

* What package operation occurred.
* When it occurred.
* Which account initiated it.
* Which version was involved.

However:

> `Requested-By` identifies the account that initiated the transaction; it does not prove the user's intent.

---

# 9. DPKG Package Information

I investigated the installed package with:

```bash
dpkg -s ca-certificates
```

Important fields included:

```text
Package: ca-certificates
Status: install ok installed
Architecture: all
Version: 20260601
```

DPKG provides information from the local package database.

This is different from asking the repository what is currently available.

---

# 10. Package → Files

I used:

```bash
dpkg -L ca-certificates | head -20
```

This showed files and directories associated with the package, including:

```text
/etc/ca-certificates
/etc/ssl/certs
/usr/sbin/update-ca-certificates
/usr/share/ca-certificates
/usr/share/ca-certificates/mozilla
```

There were also many certificate files under:

```text
/usr/share/ca-certificates/mozilla/
```

This established the relationship:

```text
Package
   ↓
Files
```

### Security relevance

When investigating software, knowing which files belong to a package helps determine whether an executable or configuration file is expected.

---

# 11. File → Package

I then reversed the relationship.

I investigated:

```bash
dpkg -S /usr/sbin/update-ca-certificates
```

The result identified:

```text
ca-certificates
```

This established:

```text
/usr/sbin/update-ca-certificates
             ↓
      ca-certificates
```

The two important DPKG commands became:

```text
dpkg -L PACKAGE
      ↓
PACKAGE → FILES
```

and:

```text
dpkg -S FILE
      ↓
FILE → PACKAGE
```

This is especially useful when an investigator encounters an unfamiliar file.

---

# 12. Package Integrity Verification

I checked the package using:

```bash
sudo dpkg -V ca-certificates
```

The command produced no output.

This means:

> No verification discrepancies were reported for the package files that DPKG could verify.

This was a positive finding.

However, it does not prove that the entire system or package is completely safe.

The correct interpretation is:

```text
No reported verification discrepancy
        ≠
Absolute proof of legitimacy
```

Verification is one piece of evidence within a larger investigation.

---

# 13. DPKG Transaction Timeline

I investigated the DPKG log:

```bash
grep "ca-certificates" /var/log/dpkg.log | tail -15
```

The log showed events such as:

```text
2026-09-07 14:47:57 status unpacked ca-certificates:all 20260601
2026-09-07 14:47:57 status half-configured ca-certificates:all 20260601
2026-09-07 14:48:01 status installed ca-certificates:all 20260601
2026-09-07 14:48:03 trigproc ca-certificates:all 20260601 <none>
2026-09-07 14:48:04 status installed ca-certificates:all 20260601
```

The sequence showed that package installation can involve multiple intermediate states.

For example:

```text
unpacked
   ↓
configuration
   ↓
installed
   ↓
trigger processing
```

### Security lesson

A `half-configured` entry during a normal package transaction is not automatically suspicious.

It can simply represent an intermediate package-management state.

The important thing is to correlate the DPKG timeline with other evidence.

---

# 14. Package File Permissions

I inspected the main utility:

```bash
ls -l /usr/sbin/update-ca-certificates
```

The result was:

```text
-rwxr-xr-x 1 root root 5.6K Jun 1 09:39 /usr/sbin/update-ca-certificates
```

This showed:

```text
Owner → root
Group → root
Permissions → 755
```

The permission structure means:

```text
root
 └── read + write + execute

others
 └── read + execute
```

Only the owner has write permission.

The ownership and permissions were consistent with a system utility.

---

# 15. YUM, DNF and RPM

I also learned how package management differs across Linux distributions.

The basic mapping is:

```text
Debian/Kali
    ↓
APT
    ↓
DPKG
    ↓
.deb
```

Compared with:

```text
Fedora/RHEL
    ↓
DNF
    ↓
RPM
    ↓
.rpm
```

Older RHEL-family systems commonly used:

```text
YUM
 ↓
RPM
```

The important conceptual mapping is:

```text
DPKG                  RPM

dpkg -s package   ↔   rpm -q package

dpkg -L package   ↔   rpm -ql package
```

For example:

```bash
rpm -ql nginx
```

would list files installed by an RPM package.

I did not install DNF on Kali simply for practice because Kali does not use DNF as its primary package manager.

---

# 16. Python `pip`

I investigated Python package management with:

```bash
pip --version
```

My system showed:

```text
pip 26.0.1
from /home/kali/miniconda3/lib/python3.13/site-packages/pip
```

This was important because the `pip` command was associated with a **Miniconda Python environment**.

I then used:

```bash
pip list
```

to inspect installed Python packages.

Examples included:

```text
urllib3
requests-related dependencies
certifi
click
typing_extensions
```

This demonstrated that Linux software investigations cannot always focus only on APT/DPKG.

Different software ecosystems can maintain their own package environments.

---

# 17. Investigating Python Package Metadata

I investigated:

```bash
pip show urllib3
```

Important information included:

```text
Name: urllib3
Version: 2.6.3
Location: /home/kali/miniconda3/lib/python3.13/site-packages
Required-by: requests
```

This established a dependency relationship:

```text
requests
   ↓
urllib3
```

I also used:

```bash
pip show -f urllib3
```

which showed files associated with the package.

Important metadata included:

```text
METADATA
RECORD
REQUESTED
WHEEL
direct_url.json
```

`RECORD` can contain file paths, hashes, and sizes.

`METADATA` contains package metadata and dependency information.

`direct_url.json` can provide provenance information about how the package was obtained.

---

# 18. Python Package `RECORD`

I inspected:

```bash
head -10 \
/home/kali/miniconda3/lib/python3.13/site-packages/urllib3-2.6.3.dist-info/RECORD
```

Entries contained:

```text
file path
hash
file size
```

For example:

```text
urllib3/__init__.py,
sha256=...,
6979
```

This demonstrated another package-integrity mechanism.

However:

> A package's own metadata should not automatically be treated as an independent trust anchor.

If an attacker can modify package files and the associated metadata, both could potentially be manipulated.

Therefore, package metadata should be correlated with trusted sources and other evidence.

---

# 19. Snap

I checked whether Snap was installed:

```bash
snap --version
```

The command was not available on my Kali system.

I learned that:

```bash
snap list
```

is normally used to list installed Snap packages.

The important lesson was that Linux systems can use multiple software-distribution mechanisms.

An investigator should therefore consider the environment rather than assuming:

```text
Everything installed → APT
```

---

# 20. Investigating a Non-Package-Owned File

During the module I also investigated:

```text
/usr/local/bin/mount-shared-folders
```

I checked package ownership:

```bash
dpkg -S /usr/local/bin/mount-shared-folders
```

DPKG did not associate the file with an installed package.

This was an important investigation finding.

A file without DPKG ownership is **not automatically malicious**.

Possible explanations include:

* Manually created software.
* Software installed outside APT.
* Source-built software.
* VMware tooling.
* Files extracted from archives.
* Other package ecosystems.
* Potentially an attacker-created file.

Therefore, the correct response is:

> **Investigate further rather than immediately declaring it malicious.**

---

# 21. Static Investigation of the File

I examined the file metadata:

```bash
stat /usr/local/bin/mount-shared-folders
```

The timestamps showed that the file was created and modified around:

```text
December 2, 2025
```

I then identified its type:

```bash
file /usr/local/bin/mount-shared-folders
```

The result showed:

```text
POSIX shell script, ASCII text executable
```

I safely inspected the contents:

```bash
cat /usr/local/bin/mount-shared-folders
```

The script checked for root privileges and interacted with VMware shared-folder tooling.

It used:

```text
vmware-hgfsclient
vmhgfs-fuse
```

---

# 22. Correlating the Helper Script

I checked:

```bash
command -v vmware-hgfsclient
```

The executable was located at:

```text
/usr/bin/vmware-hgfsclient
```

Then:

```bash
dpkg -S /usr/bin/vmware-hgfsclient
```

identified the owning package:

```text
open-vm-tools
```

This created an important correlation:

```text
/usr/local/bin/mount-shared-folders
              ↓
     vmware-hgfsclient
              ↓
/usr/bin/vmware-hgfsclient
              ↓
       open-vm-tools
```

The behavior and supporting evidence were consistent with a VMware guest helper.

### Final assessment

```text
Likely legitimate VMware helper
```

The key lesson was that **context and correlation matter more than package ownership alone**.

---

# 23. Package Security Investigation Workflow

The module's practical investigation workflow became:

```text
Identify package/file
        ↓
Check package ownership
        ↓
Identify installed version
        ↓
Identify candidate version
        ↓
Identify repository/source
        ↓
Check installation history
        ↓
Check DPKG transaction logs
        ↓
Inspect package files
        ↓
Check ownership/permissions
        ↓
Verify package files
        ↓
Correlate timestamps
        ↓
Assess legitimacy
```

For a suspicious software installation, I would ask:

```text
What is it?
     ↓
Where did it come from?
     ↓
Who installed it?
     ↓
When was it installed?
     ↓
Which files did it install?
     ↓
Who owns those files?
     ↓
What permissions do they have?
     ↓
Do verification checks show changes?
     ↓
What processes/services use it?
     ↓
Is the software expected?
```

---

# 24. Capstone Investigation — `ca-certificates`

For the final investigation, I used the legitimate:

```text
ca-certificates
```

package as a real-world package-management investigation target.

I established the package baseline:

```text
Package:
ca-certificates

Version:
20260601

Status:
install ok installed

Architecture:
all
```

I then traced the package through several evidence sources.

### Repository

```text
Kali rolling repository
```

### Installed version

```text
20260601
```

### Candidate version

```text
20260601
```

### APT history

```text
apt install --reinstall ca-certificates
```

Requested by:

```text
kali (UID 1000)
```

### DPKG timeline

The DPKG log showed a consistent installation/reinstallation sequence.

### Package files

The package contained expected certificate-management files.

### File ownership

```text
/usr/sbin/update-ca-certificates
        ↓
ca-certificates
```

### Integrity

```text
dpkg -V ca-certificates
```

returned no verification discrepancies.

### Permissions

```text
root:root
755
```

for the main system utility.

---

# 25. Capstone Assessment

The evidence was consistent across multiple sources:

```text
Repository
    ↓
Expected Kali source
    ↓
Installed version
    ↓
Matches candidate
    ↓
APT history
    ↓
Traceable transaction
    ↓
DPKG log
    ↓
Consistent timeline
    ↓
Package files
    ↓
Expected certificate files
    ↓
File ownership
    ↓
Expected package
    ↓
Integrity verification
    ↓
No reported discrepancies
```

### Final assessment

```text
🟢 Likely legitimate package activity
```

This does not mean that one investigation can prove a system is completely clean.

Instead, it means that the available package-management evidence did not reveal an obvious anomaly.

---

# Key Commands

| Command                             | Purpose                           | Security Application                |
| ----------------------------------- | --------------------------------- | ----------------------------------- |
| `apt --version`                     | Show APT version                  | Identify package environment        |
| `apt update`                        | Refresh package indexes           | Repository investigation            |
| `apt upgrade`                       | Upgrade installed packages        | Package maintenance                 |
| `apt list --upgradable`             | Show available upgrades           | Version investigation               |
| `apt show PACKAGE`                  | Show package metadata             | Package investigation               |
| `apt-cache policy PACKAGE`          | Show installed/candidate versions | Source/version investigation        |
| `dpkg -s PACKAGE`                   | Show package status               | Installed-package investigation     |
| `dpkg -L PACKAGE`                   | List package files                | Package → file mapping              |
| `dpkg -S FILE`                      | Identify owning package           | File → package mapping              |
| `dpkg -V PACKAGE`                   | Verify package files              | Integrity investigation             |
| `grep ... /var/log/apt/history.log` | Inspect APT transactions          | Installation timeline               |
| `grep ... /var/log/dpkg.log`        | Inspect DPKG events               | Detailed package timeline           |
| `rpm -q PACKAGE`                    | Query RPM package                 | RHEL/Fedora investigation           |
| `rpm -ql PACKAGE`                   | List RPM package files            | RPM file investigation              |
| `pip list`                          | List Python packages              | Python environment investigation    |
| `pip show PACKAGE`                  | Show Python package metadata      | Dependency/provenance investigation |
| `pip show -f PACKAGE`               | Show package files                | Python package investigation        |
| `snap list`                         | List Snap packages                | Snap package investigation          |
| `ls -l FILE`                        | Check ownership/permissions       | File security investigation         |
| `stat FILE`                         | Show detailed metadata            | Timeline investigation              |
| `file FILE`                         | Identify file type                | Static investigation                |

---

# What I Learned

After completing Module 09, I can:

* Explain the difference between APT and DPKG.
* Understand what `apt update` actually does.
* Distinguish package-index updates from package upgrades.
* Identify installed and candidate package versions.
* Investigate configured repositories.
* Understand repository signing configuration.
* Read APT transaction history.
* Identify the account that initiated an APT transaction.
* Investigate installed package metadata with DPKG.
* Map packages to their installed files.
* Identify which package owns a specific file.
* Perform basic DPKG package verification.
* Interpret DPKG transaction logs.
* Build a package-management timeline.
* Investigate file ownership and permissions.
* Understand the relationship between DNF, YUM, RPM, and APT/DPKG.
* Investigate Python packages using `pip`.
* Understand Python package metadata such as `RECORD` and `direct_url.json`.
* Recognize that Linux software can come from multiple package ecosystems.
* Investigate files that are not owned by the primary package manager.
* Correlate package information with filesystem evidence.
* Use package-management information as part of a Linux incident-response investigation.

---

# Security Mental Model

```text
                SOFTWARE
                    │
          ┌─────────┴─────────┐
          ↓                   ↓
       PACKAGE             FILE
          │                   │
          ↓                   ↓
      VERSION              OWNER
          │                   │
          ↓                   ↓
     REPOSITORY           PERMISSIONS
          │                   │
          ↓                   ↓
      SIGNING             TIMESTAMPS
          │                   │
          └─────────┬─────────┘
                    ↓
              INSTALLATION
                 HISTORY
                    │
                    ↓
                 DPKG
                 LOGS
                    │
                    ↓
             INTEGRITY CHECK
                    │
                    ↓
              CORRELATION
                    │
                    ↓
             RISK ASSESSMENT
                    │
                    ↓
             LEGITIMATE /
             INVESTIGATE
```

---

# Final Takeaway

The biggest lesson from Module 09 was:

> **Package management is also an investigation source.**

When suspicious software appears on a Linux system, I should not immediately assume it is malicious.

Instead, I should establish:

```text
What is it?
     ↓
Where did it come from?
     ↓
Who installed it?
     ↓
When was it installed?
     ↓
What version is installed?
     ↓
Which files does it control?
     ↓
Who owns those files?
     ↓
Are the permissions expected?
     ↓
Do integrity checks show discrepancies?
     ↓
Does the timeline make sense?
     ↓
Is the software legitimate?
```

This gives me a practical foundation for investigating **software installations, package provenance, file ownership, and potential suspicious software activity on Linux systems**.

---

## Module Progress

```text
Module 01 → File & Metadata Investigation       ✅
Module 02 → Evidence Handling & File Operations  ✅
Module 03 → Linux Permissions & ACLs             ✅
Module 04 → Linux User Management                ✅
Module 05 → Process Management                   ✅
Module 06 → Services & Persistence               ✅
Module 07 → Linux Networking & Administration    ✅
Module 08 → Linux Logs & Log Investigation       ✅
Module 09 → Linux Package Management             ✅
```

**Next: Module 10 — Linux Security & Hardening.**
