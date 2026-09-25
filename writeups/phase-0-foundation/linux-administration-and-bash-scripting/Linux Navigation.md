# Module 01 — Linux Navigation

> Security-focused Linux navigation and file investigation using `find`, `locate`, `which`, `file`, and `stat`.

---

## Objective

The goal of this module was to move beyond basic Linux navigation and learn how to **locate, identify, and inspect files from a security-investigation perspective**.

Instead of simply learning commands, each command was connected to a practical question:

> **Where is the file? What is it? Which executable will run? When was it changed?**

---

# 01 — `find`

## Purpose

`find` searches the filesystem directly and allows files to be filtered using multiple conditions.

Basic structure:

```bash
find <location> <conditions>
```

Example:

```bash
find /tmp -type f -name "*.sh"
```

This searches `/tmp` for regular files whose names end with `.sh`.

### Important Conditions

```text
-type f       Regular file
-type d       Directory
-name         Filename pattern
-mtime        Modification time
-perm         Permissions
-user         File owner
-size         File size
```

### Security Example

To find recently modified shell scripts that are executable by their owner:

```bash
find /tmp -type f -name "*.sh" -mtime -1 -perm -u=x
```

### Security Relevance

`find` is valuable during:

* Malware investigations
* IOC discovery
* Incident response
* Persistence hunting
* File-system analysis
* Privilege-escalation investigations

For example, an investigator may search for recently modified files in sensitive locations.

### Key Lesson

> `find` searches the current filesystem directly, making it useful when filesystem freshness matters.

---

# 02 — `locate`

## Purpose

`locate` searches a **prebuilt database of file paths** rather than scanning the filesystem directly.

Basic usage:

```bash
locate <pattern>
```

Example:

```bash
locate bash
```

### `locate` vs `find`

```text
find
 ↓
Filesystem
 ↓
Current information
 ↓
Generally slower


locate
 ↓
Prebuilt path database
 ↓
Potentially stale information
 ↓
Very fast
```

### Practical Test

A test file was created:

```bash
touch /tmp/locate_test_123
```

Searching immediately with:

```bash
find /tmp -name "locate_test_123"
```

found the file.

However:

```bash
locate locate_test_123
```

did not find it because the locate database had not yet been updated.

### Security Relevance

`locate` is useful for quickly finding known files or paths, but it should not be relied upon as the primary source when investigating **recent filesystem changes**.

### Key Lesson

> **Need speed → `locate`; need current filesystem state → `find`.**

---

# 03 — `which`

## Purpose

`which` identifies the executable found through the shell's `PATH` lookup.

Example:

```bash
which python
```

Possible result:

```text
/usr/bin/python
```

### Security Relevance

The executable's location can provide an important investigation clue.

For example:

```text
/usr/bin/python
```

would normally be expected on many Linux systems.

An unexpected result such as:

```text
/tmp/python
```

does not automatically mean malware, but it should trigger further investigation.

Possible follow-up checks include:

```bash
file /tmp/python
stat /tmp/python
ls -l /tmp/python
```

### `which` vs `type -a`

`which` primarily performs a PATH-based executable lookup.

```bash
which python
```

`type -a` provides broader command-resolution information and can show multiple matching locations.

```bash
type -a python
```

This can reveal situations where multiple executables could be selected depending on the environment.

### Security Relevance

This is useful when investigating:

* PATH manipulation
* Command hijacking
* Unexpected executables
* Suspicious binaries
* Environment-based persistence

### Key Lesson

> `which` helps determine which executable is being found through the current PATH.

---

# 04 — `file`

## Purpose

`file` identifies the likely format/type of a file by examining its contents rather than trusting its filename extension.

Basic usage:

```bash
file <filename>
```

Example:

```bash
file /bin/ls
```

A typical result identifies information such as:

* ELF format
* 64-bit architecture
* CPU architecture
* Dynamic linking
* Interpreter
* Other binary characteristics

### Why This Matters

A filename can be misleading.

For example:

```text
invoice.pdf
```

does not guarantee that the file is actually a PDF.

An attacker could rename an executable:

```text
malware.exe
        ↓
invoice.pdf
```

The filename changes, but the underlying file format does not.

`file` can expose this discrepancy.

### Security Relevance

`file` is useful for:

* Malware triage
* Suspicious attachments
* Disguised executables
* Binary analysis
* Digital forensics
* File-format identification

### Key Lesson

> **Do not trust the filename extension; inspect the actual file contents and format.**

---

# 05 — `stat`

## Purpose

`stat` displays detailed metadata about a file.

Example:

```bash
stat /bin/ls
```

Important information includes:

* File size
* Permissions
* UID
* GID
* Inode
* Access timestamp
* Modification timestamp
* Metadata/status-change timestamp

---

## Inodes

An inode is a filesystem data structure containing metadata about a file and references to the file's stored data.

It can contain information such as:

```text
File type
Permissions
Owner
Group
Size
Timestamps
Data-block references
```

---

# File Timestamps

Three particularly important timestamps are:

### Access — `atime`

Records when file contents were accessed/read.

### Modify — `mtime`

Records when the **contents of the file changed**.

### Change — `ctime`

Records when the file's **metadata/status changed**.

Example:

```text
Access  → contents accessed
Modify  → contents modified
Change  → metadata/status changed
```

### Important Distinction

Changing file contents normally changes:

```text
Modify
+
Change
```

because changing the contents also changes filesystem metadata such as file size.

The inode itself does not necessarily change.

---

# Forensic Relevance

Timestamps can help investigators construct a timeline.

For example:

```text
10:12 — suspicious file created
10:14 — file modified
10:16 — file accessed
10:18 — security incident detected
```

This can help investigators determine what happened before, during, and after an incident.

However, timestamps should be treated as **evidence rather than absolute proof**, because they can sometimes be modified or affected by normal system activity.

---

# Practical Investigation Workflow

The commands learned in this module can be combined into a simple investigation workflow:

```text
                 Suspicious File
                       │
                       ▼
              ┌─────────────────┐
              │ find / locate   │
              │ Locate the file │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │     which       │
              │ Executable path │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │      file       │
              │ Identify format │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │      stat       │
              │ Inspect metadata│
              └────────┬────────┘
                       │
                       ▼
                Investigation
```

---

# Practical Exercises Completed

## Exercise 1 — Search by filename

```bash
find /tmp -type f -name "*.sh"
```

Purpose:

> Locate regular shell-script files under `/tmp`.

---

## Exercise 2 — Search recent files

```bash
find /tmp -type f -mtime -1
```

Purpose:

> Identify regular files modified within the previous 24 hours.

---

## Exercise 3 — Combine conditions

```bash
find /tmp -type f -name "*.sh" -mtime -1 -perm -u=x
```

Purpose:

> Find recently modified shell scripts that are executable by their owner.

---

## Exercise 4 — `locate` freshness test

Created:

```bash
touch /tmp/locate_test_123
```

Then compared:

```bash
locate locate_test_123
```

with:

```bash
find /tmp -name "locate_test_123"
```

Result:

```text
locate → did not find newly created file
find   → found the file
```

This demonstrated the stale-database limitation of `locate`.

---

## Exercise 5 — Executable resolution

```bash
which python
type -a python
```

Purpose:

> Compare PATH-based executable lookup with broader command resolution.

---

## Exercise 6 — File identification

```bash
file /bin/ls
```

Purpose:

> Determine the actual binary format and architecture information of an executable.

---

## Exercise 7 — Metadata investigation

```bash
stat /bin/ls
```

and a controlled test file:

```bash
echo "suspicious content" > /tmp/investigation_test
stat /tmp/investigation_test
```

The file was then modified and `stat` was run again to observe timestamp changes.

---

# Security Skills Developed

After completing this module, I can:

* Search Linux files using multiple conditions.
* Search for recently modified files.
* Filter files by type.
* Filter files by permissions.
* Understand the difference between `find` and `locate`.
* Identify executables through PATH lookup.
* Investigate multiple command-resolution paths.
* Identify a file's actual format.
* Recognize why file extensions cannot be trusted.
* Inspect inode and file metadata.
* Understand `atime`, `mtime`, and `ctime`.
* Use timestamps as part of an investigation timeline.
* Combine multiple Linux commands into an investigation workflow.

---

# Security Mental Model

The central lesson of this module is:

```text
Don't trust the filename.
Don't trust the extension.
Don't trust the location.
Don't trust that a command resolves where you expect.
Investigate the metadata.
```

A suspicious file should be approached systematically:

```text
Where is it?
     ↓
What type of file is it?
     ↓
Which executable/path is involved?
     ↓
Who owns it?
     ↓
What permissions does it have?
     ↓
When was it modified?
     ↓
When was it accessed?
     ↓
What changed?
```

---

# Commands Covered

| Command   | Primary Purpose          | Security Application            |
| --------- | ------------------------ | ------------------------------- |
| `find`    | Filesystem search        | IOC discovery                   |
| `locate`  | Database filename search | Rapid lookup                    |
| `which`   | PATH executable lookup   | PATH investigation              |
| `type -a` | Command resolution       | Command hijacking investigation |
| `file`    | File identification      | Malware triage                  |
| `stat`    | Metadata inspection      | Forensics/timeline              |

---

# Final Takeaway

Linux navigation is more than moving between directories.

From a cybersecurity perspective, navigation becomes **file discovery and investigation**.

The combination of:

```bash
find
locate
which
file
stat
```

provides a basic but powerful workflow for answering:

> **Where is this file, what is it, how will it execute, and what does its metadata tell me?**

These skills form the foundation for the next module, **File Operations**, where the focus shifts from finding files to safely copying, moving, linking, synchronizing, and archiving them during administration and security investigations.
