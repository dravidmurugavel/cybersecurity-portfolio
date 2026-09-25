# Module 02 — File Operations

## Overview

This module focused on Linux file operations from both an **administration** and **cybersecurity** perspective.

Instead of learning commands only by memorizing syntax, I practiced how these commands behave when handling files, directories, evidence, logs, and suspicious files.

The main focus was:

> **Understand what each operation does to a file, its metadata, inode, timestamps, and contents before using it during an investigation.**

---

## Topics Covered

* `cp`
* `mv`
* `rm`
* `touch`
* `mkdir`
* `ln`
* `rsync`
* `tar`

---

# 1. `cp` — Copying Files

`cp` is used to copy files and directories.

### Basic usage

```bash
cp source.txt destination.txt
```

For directories:

```bash
cp -r source_directory destination_directory
```

The `-r` option means **recursive**, allowing the directory and its contents to be copied.

### Preserving metadata

For security investigations, I learned about:

```bash
cp -p source.txt destination.txt
```

`-p` attempts to preserve important attributes such as:

* Permissions
* Ownership
* Timestamps

### Security relevance

When a suspicious file is discovered, I should avoid directly modifying the original.

A safer approach is:

```text
Original file
     ↓
Preserve
     ↓
Working copy
     ↓
Analyze
```

This helps prevent accidental modification of potential evidence.

### Important lesson

File ownership does not necessarily identify who originally created a file. It identifies the current owner/group.

---

# 2. `mv` — Moving and Renaming

`mv` is used to move or rename files.

```bash
mv old.txt new.txt
```

It can also move a file into another directory:

```bash
mv suspicious.sh evidence/
```

### Inode behavior

When a file is renamed within the same filesystem, its inode normally remains the same.

```text
old_filename
     ↓ mv
new_filename
     ↓
same inode
```

The directory entry changes, but the underlying filesystem object remains the same.

### Timestamp behavior

Renaming a file does not modify its contents, so the `Modify` timestamp normally remains unchanged.

However, the metadata/status-change timestamp (`Change`) can change because the filesystem metadata was altered.

### Security relevance

An attacker could rename or move a suspicious file:

```text
/tmp/malware
     ↓
/tmp/normal-looking-file
```

If an investigation depends only on filenames and paths, the file could become harder to locate.

This reinforced an important lesson:

> **A filename is not the same thing as the underlying filesystem object.**

---

# 3. `rm` — Removing Files

`rm` removes files.

```bash
rm file.txt
```

For directories:

```bash
rm -r directory/
```

The `-r` option recursively removes the directory and its contents.

### Interactive deletion

```bash
rm -i file.txt
```

`-i` asks for confirmation before deleting.

This provides a useful safety checkpoint:

```text
rm -i
  ↓
Confirmation
  ↓
Delete / Cancel
```

### Security relevance

Deleting a suspicious file during an investigation can destroy valuable evidence.

Therefore:

```text
Suspicious file
      ↓
Preserve
      ↓
Document / hash
      ↓
Analyze
      ↓
Remove only when appropriate
```

I also learned that `rm` does not necessarily mean the underlying data is immediately and permanently unrecoverable.

---

# 4. `touch` — Files and Timestamps

`touch` creates an empty file if it doesn't exist.

```bash
touch test.txt
```

If the file already exists, `touch` normally updates its timestamps.

I tested this using:

```bash
echo "DO NOT DELETE" > timestamp_test
touch timestamp_test
```

The contents remained unchanged.

### Important lesson

`touch` does **not** overwrite existing file contents.

It primarily affects timestamps.

The important timestamps I already learned in the previous module are:

```text
Access  → access/read time
Modify  → content modification time
Change  → metadata/status change time
```

### Security relevance

Unexpected timestamp changes can be useful investigation clues.

However, a changed timestamp alone does not prove malicious activity.

An investigator should correlate timestamps with:

* System logs
* Process activity
* User activity
* Other filesystem evidence

---

# 5. `mkdir` — Directory Management

`mkdir` creates directories.

```bash
mkdir evidence
```

For nested directories:

```bash
mkdir -p case01/evidence/raw
```

The `-p` option creates missing parent directories.

### Investigation workspace

I created a structure like:

```text
case01/
├── evidence/
│   ├── raw/
│   └── working/
├── logs/
└── reports/
```

The idea is to keep original/preserved material separate from files being actively analyzed.

```text
raw/
 ↓
Preserved evidence

working/
 ↓
Analysis copies
```

### Security relevance

Good directory organization reduces the chance of:

* Modifying original evidence
* Accidentally deleting files
* Mixing raw evidence with analysis results
* Losing track of investigation artifacts

---

# 6. `ln` — Hard Links and Symbolic Links

Linux supports different types of links. The two important ones for this module were:

* Hard links
* Symbolic links

---

## Hard Link

Created with:

```bash
ln original.txt hardlink.txt
```

A hard link creates another directory entry pointing to the **same inode**.

```text
original ──┐
           ├──> same inode ──> data
hardlink ──┘
```

I verified this using:

```bash
ls -li original.txt hardlink.txt
```

Both showed the same inode number.

If the original filename is deleted, the hard link can still access the data.

---

## Symbolic Link

Created with:

```bash
ln -s original.txt symlink.txt
```

A symbolic link points to a pathname.

```text
symlink
   ↓
pathname
   ↓
target
   ↓
inode
   ↓
data
```

A symbolic link has its own inode.

If the target is deleted:

```text
symlink
   ↓
target missing
   ↓
broken/dangling symlink
```

The symlink itself remains.

### Security relevance

Understanding links is useful when investigating:

* Persistence
* Suspicious paths
* Unexpected redirects
* Privilege escalation
* Filesystem manipulation

An unexpected symlink should not automatically be considered malicious, but it is worth investigating.

---

# 7. `rsync` — Synchronizing Files

`rsync` synchronizes files and directories efficiently.

Basic usage:

```bash
rsync source/ destination/
```

A commonly used form is:

```bash
rsync -av source/ destination/
```

Where:

```text
-a → archive mode
-v → verbose output
```

### `--dry-run`

One of the most useful options I practiced was:

```bash
rsync -av --dry-run source/ destination/
```

A dry run **does not perform the synchronization**.

Instead, it shows what `rsync` would do.

```text
--dry-run
    ↓
Preview
    ↓
No files copied
No files deleted
```

This is especially useful before potentially destructive operations.

---

## Incremental synchronization

After the initial synchronization, I modified only one file and ran `rsync` again.

The modified file was transferred, while the unchanged file was not.

This demonstrates one of the major advantages of `rsync`:

> It avoids unnecessarily transferring data that is already synchronized.

This is useful for:

* Large log collections
* Backups
* Repeated evidence collection
* Investigation data synchronization

---

## Trailing `/`

I also learned that the trailing slash matters.

```bash
rsync -av source/ destination/
```

means to synchronize the **contents** of `source`.

Without the trailing slash:

```bash
rsync -av source destination/
```

the source directory itself can be placed inside the destination.

---

## `--delete`

`rsync` also provides:

```bash
rsync -av --delete source/ destination/
```

This can remove files from the destination that don't exist in the source.

For example:

```text
SOURCE                 DESTINATION

log1.txt               log1.txt
log2.txt               log2.txt
                       old.log
```

With `--delete`, `old.log` may be removed from the destination.

### Security risk

This can be dangerous during investigations because destination files could contain:

* Evidence
* Logs
* Collected artifacts
* Investigation results

Therefore, I learned to preview it first:

```bash
rsync -av --delete --dry-run source/ destination/
```

> Always understand the source, destination, and consequences before using `--delete`.

---

# 8. `tar` — Archiving and Compression

`tar` is commonly used to bundle files and directories into an archive.

Create an archive:

```bash
tar -cf evidence.tar evidence/
```

Extract:

```bash
tar -xf evidence.tar
```

Important options:

```text
-c  Create
-x  Extract
-t  List contents
-f  Archive filename
-z  gzip compression
```

---

## Creating a `.tar.gz`

```bash
tar -czf evidence.tar.gz evidence/
```

This involves two concepts:

```text
Files/directories
       ↓
     tar
       ↓
   one archive
       ↓
     gzip
       ↓
 compressed archive
```

So:

```text
.tar
→ archive

.tar.gz
→ archive + gzip compression
```

### Archiving vs compression

**Archiving** bundles multiple files/directories together.

**Compression** reduces the amount of space required to store the data.

They are different operations.

---

## Inspecting an Archive

Before extracting an archive, I practiced:

```bash
tar -tzf evidence.tar.gz
```

This lists its contents without extracting it.

This creates a safer workflow:

```text
Untrusted archive
       ↓
List contents
       ↓
Inspect
       ↓
Extract to controlled location
       ↓
Analyze
```

### Extracting to a specific directory

The `-C` option specifies where the archive should be extracted:

```bash
tar -xzf evidence.tar.gz -C extracted/
```

### Security relevance

This is useful when dealing with:

* Investigation archives
* Log collections
* Malware samples
* Backups
* Incident-response artifacts

An untrusted archive should not automatically be extracted into a normal working directory.

---

# Module 02 Capstone

## Scenario

A suspicious shell script was discovered:

```text
/tmp/suspicious.sh
```

The goal was to preserve the file, create a working copy, inspect it, synchronize investigation material, and archive the case.

### Investigation structure

```bash
mkdir -p ~/fileops-lab/case01/{evidence/{raw,working},logs,reports}
```

Result:

```text
case01/
├── evidence/
│   ├── raw/
│   └── working/
├── logs/
└── reports/
```

### Preserve the original

```bash
cp -p /tmp/suspicious.sh \
~/fileops-lab/case01/evidence/raw/
```

### Create a working copy

```bash
cp -p ~/fileops-lab/case01/evidence/raw/suspicious.sh \
~/fileops-lab/case01/evidence/working/
```

### Inspect the working copy

```bash
file ~/fileops-lab/case01/evidence/working/suspicious.sh
```

```bash
stat ~/fileops-lab/case01/evidence/working/suspicious.sh
```

### Preview synchronization

```bash
rsync -av --dry-run \
~/fileops-lab/case01/evidence/working/ \
~/fileops-lab/case01/evidence/raw/
```

### Archive the case

```bash
tar -czf ~/fileops-lab/case01.tar.gz \
~/fileops-lab/case01/
```

Then inspect:

```bash
tar -tzf ~/fileops-lab/case01.tar.gz
```

---

# Security Workflow

The complete workflow from this module can be summarized as:

```text
             Suspicious File
                    │
                    ▼
               Preserve
                 cp -p
                    │
                    ▼
                 raw/
                    │
                    ▼
              Working Copy
                    │
                    ▼
              ┌─────┴─────┐
              │           │
             file        stat
              │           │
          File type    Metadata
              │           │
              └─────┬─────┘
                    ▼
                  rsync
               --dry-run
                    │
                    ▼
                 tar.gz
                    │
                    ▼
             Investigation Case
```

---

# Security Skills Developed

After completing this module, I can:

* Copy files while preserving important metadata.
* Understand how `mv` affects filenames, inodes, and timestamps.
* Safely handle file deletion with `rm -i`.
* Understand how `touch` affects timestamps without modifying file contents.
* Build organized investigation directories.
* Understand hard links and symbolic links.
* Identify broken symbolic links.
* Synchronize data efficiently with `rsync`.
* Use `--dry-run` to preview synchronization.
* Understand the risks of `rsync --delete`.
* Create and inspect `tar.gz` archives.
* Extract archives into controlled directories.
* Separate raw evidence from working copies.
* Think about file operations from a forensic perspective.

---

# Security Mental Model

The most important lesson from this module was:

> **Before using a file operation, understand exactly what it will change.**

A careless workflow could look like:

```text
Find
 ↓
Modify
 ↓
Move
 ↓
Delete
```

A safer investigation workflow is:

```text
Find
 ↓
Preserve
 ↓
Copy
 ↓
Inspect
 ↓
Analyze working copy
 ↓
Synchronize carefully
 ↓
Archive
 ↓
Verify/document
```

This approach helps reduce accidental evidence modification and makes file handling more controlled.

---

# Key Commands

| Command | Purpose                  | Security Use                  |
| ------- | ------------------------ | ----------------------------- |
| `cp`    | Copy files/directories   | Evidence preservation         |
| `mv`    | Move/rename              | File tracking                 |
| `rm`    | Remove files             | Safe deletion awareness       |
| `touch` | Create/update timestamps | Timeline investigation        |
| `mkdir` | Create directories       | Investigation structure       |
| `ln`    | Create links             | Filesystem investigation      |
| `rsync` | Synchronize files        | Backup/evidence collection    |
| `tar`   | Archive/compress         | Case packaging/log collection |

---

# Final Takeaway

This module showed me that Linux file operations are not just everyday administrative commands. In cybersecurity, they directly affect how **evidence, malware samples, logs, backups, and investigation artifacts** are handled.

The biggest lessons I took from this module are:

```text
Preserve before analyzing.
Work on copies when appropriate.
Understand inode behavior.
Don't blindly delete files.
Preview destructive operations.
Inspect archives before extracting them.
Keep raw evidence separate from working files.
```

These concepts provide the foundation for the next module:

**Module 03 — Linux Permissions**

```text
chmod
chown
SUID
SGID
Sticky Bit
ACLs
```

The focus will shift from **handling files** to understanding **who can access, modify, execute, and control them**—which is critical for Linux security and privilege escalation.
