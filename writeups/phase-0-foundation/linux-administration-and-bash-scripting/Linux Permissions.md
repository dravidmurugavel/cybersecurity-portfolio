# Module 03 — Linux Permissions

## Overview

This module focused on how Linux controls access to files and directories.

I already knew basic Linux permissions, so instead of only memorizing `chmod` syntax, I focused on understanding permissions from a **security perspective**—especially how incorrect ownership, excessive permissions, SUID, SGID, sticky bits, and ACLs can create security risks.

The main principle I learned was:

> **Always look at ownership, permissions, special bits, and what the file actually does together.**

---

# Topics Covered

* `chmod`
* Symbolic `chmod`
* `chown`
* SUID
* SGID
* Sticky Bit
* ACLs
* Permission security auditing

---

# 1. `chmod` — Changing Permissions

`chmod` changes the permissions of a file or directory.

Linux permissions are divided into three categories:

```text
user   → owner
group  → owning group
other  → everyone else
```

The basic permissions are:

```text
r → read
w → write
x → execute
```

For example:

```text
-rwxr-xr--
```

can be interpreted as:

```text
owner  → rwx
group  → r-x
other  → r--
```

---

## Numeric Permissions

Linux represents permissions numerically:

```text
r = 4
w = 2
x = 1
```

Therefore:

```text
rwx = 7
r-x = 5
r-- = 4
```

For example:

```bash
chmod 755 script.sh
```

means:

```text
Owner  → rwx
Group  → r-x
Others → r-x
```

Another example:

```bash
chmod 640 file.txt
```

means:

```text
Owner  → rw-
Group  → r--
Others → ---
```

### Security relevance

Excessive permissions can allow unauthorized users or processes to read, modify, or execute files.

For example:

```text
-rwxrwxrwx suspicious.sh
```

gives everyone read, write, and execute access.

A user or process that should not be able to modify the file could potentially alter its contents.

This led to an important security principle:

> **Give users only the permissions they actually need.**

---

# 2. Symbolic `chmod`

Numeric permissions are useful when setting the complete permission state.

Symbolic permissions are useful when making a **specific change**.

The syntax is:

```text
chmod [who][operation][permission] file
```

### Who

```text
u → user/owner
g → group
o → others
a → everyone
```

### Operations

```text
+ → add
- → remove
= → set exactly
```

### Examples

Add execute permission to the owner:

```bash
chmod u+x script.sh
```

Remove group write permission:

```bash
chmod g-w script.sh
```

Remove write permission from others:

```bash
chmod o-w script.sh
```

Set everyone to read-only:

```bash
chmod a=r file.txt
```

---

## Security Advantage

Symbolic permissions are useful when I want to make a **targeted change**.

For example:

```bash
chmod g-w script.sh
```

means:

> Remove only the group's write permission.

It doesn't replace the entire permission set.

This is useful when making small permission corrections during administration or security hardening.

---

# 3. `chown` — Ownership

`chmod` answers:

> **What can they do?**

`chown` answers:

> **Who owns it?**

Basic syntax:

```bash
chown USER file
```

Change the owner:

```bash
sudo chown root script.sh
```

Change owner and group:

```bash
sudo chown root:root script.sh
```

Change only the group:

```bash
sudo chown :security script.sh
```

I verified ownership using:

```bash
ls -l file.txt
```

For example:

```text
-rw-r--r-- kali kali file.txt
```

Here:

```text
kali → owner
kali → group
```

---

## Ownership vs Permissions

These are separate concepts.

```text
Ownership
├── User/owner
└── Group

Permissions
├── User permissions
├── Group permissions
└── Other permissions
```

Changing the group with:

```bash
sudo chown :root ownership_test.txt
```

changed the group ownership while leaving the owner and permission bits unchanged.

### Security relevance

Ownership becomes particularly important when combined with permissions.

Consider:

```text
root-owned script
       +
ordinary user can write
       ↓
user modifies script
       ↓
root executes script
       ↓
potential privilege escalation
```

Therefore, when auditing a sensitive file, I should examine:

```text
Owner + Group + Permissions
```

rather than looking at permissions alone.

---

# 4. SUID — Set User ID

SUID was one of the most security-focused topics in this module.

SUID allows an executable to run with the **effective privileges of the file owner**.

For example:

```text
-rwsr-xr-x
   ↑
  SUID
```

The `s` appears in the owner's execute position.

### Normal execution

```text
kali
 ↓
program
 ↓
kali privileges
```

### SUID root program

```text
kali
 ↓
SUID program
 ↓
root effective privileges
```

The important distinction is between:

```text
Real UID
→ Who launched the program?

Effective UID
→ Whose privileges is the program currently using?
```

For example:

```text
Real UID       = 1000
Effective UID  = 0
```

means the `kali` user launched a program that is operating with root's effective privileges.

---

## Security relevance

A root-owned SUID program can become dangerous if it contains a vulnerability or can be influenced by an unprivileged user.

The important attack pattern is:

```text
Root-owned SUID program
          +
        Vulnerability
          ↓
Unprivileged user
          ↓
Potential privilege escalation
```

I also practiced identifying SUID files:

```bash
find / -perm -4000 -type f 2>/dev/null
```

The `4000` permission bit represents SUID.

---

# 5. SGID — Set Group ID

SGID stands for **Set Group ID**.

The `s` appears in the group execute position:

```text
-rwxr-sr-x
      ↑
     SGID
```

### SGID on a file

For an executable, SGID can cause the program to run with the **effective group of the file**.

Mental model:

```text
SUID → effective USER
SGID → effective GROUP
```

---

## SGID on a Directory

SGID has another important behavior when applied to a directory.

New files and directories created inside the SGID directory inherit the directory's group.

Example:

```text
investigation/
    group = analysts
    SGID
       ↓
new evidence file
    group = analysts
```

I tested this by creating an SGID directory:

```bash
mkdir shared
sudo chown root:root shared
sudo chmod 2775 shared
```

The resulting permissions included:

```text
drwxrwsr-x
     ↑
    SGID
```

A file created inside inherited the directory's group.

### Security relevance

This is useful for shared investigation environments.

For example:

```text
investigation/
group → security-team
SGID
   ↓
new files inherit security-team group
```

This prevents administrators from having to manually change group ownership on every newly created file.

### Important distinction

SGID does **not automatically grant everyone `rwx` permissions**.

The directory's normal permissions and other access controls still determine who can actually access the files.

---

# 6. Sticky Bit

The sticky bit protects files inside shared directories.

It appears as `t` in the others' execute position:

```text
drwxrwxrwt
       ↑
   Sticky Bit
```

A common example is:

```bash
ls -ld /tmp
```

### What it does

In a sticky-bit directory, users can create files according to the directory permissions, but ordinary users generally cannot delete or rename files belonging to other users.

Conceptually:

```text
Shared directory
       ↓
Multiple users
       ↓
Each creates files
       ↓
Sticky bit
       ↓
Users cannot normally delete
each other's files
```

### Security relevance

This is particularly useful for shared directories such as `/tmp`.

Without appropriate deletion controls, one user could potentially remove another user's temporary files.

---

# 7. SGID vs Sticky Bit

These two directory permissions have different purposes.

```text
SGID
 ↓
Group inheritance
```

```text
Sticky Bit
 ↓
Deletion/rename protection
```

### Easy memory trick

> **SGID → GROUP inheritance**
> **Sticky → DELETE protection**

For example:

```text
Shared investigation directory
        │
        ├── SGID
        │    ↓
        │  New files inherit group
        │
        └── Sticky bit
             ↓
           Users can't normally
           delete each other's files
```

---

# 8. ACLs — Access Control Lists

Traditional Linux permissions provide:

```text
Owner
Group
Others
```

ACLs provide more granular access.

For example:

```text
Owner       → rwx
Group       → r-x
acluser     → rw-
Other       → ---
```

This allows a specific user to receive permissions without changing the main ownership structure.

---

## Viewing ACLs

I used:

```bash
getfacl acl_test.txt
```

The command displays the file's ACL.

To add a specific user's permissions:

```bash
setfacl -m u:acluser:rw acl_test.txt
```

This produced an entry such as:

```text
user:acluser:rw-
```

The important thing was:

```text
Owner → unchanged
Group → unchanged
acluser → rw-
Others → unchanged
```

### Security relevance

ACLs are useful when a specific investigator needs access to a file without changing the primary owner or group.

For example:

```text
Evidence file
     │
     ├── Owner → investigator1
     ├── Group → security-team
     └── ACL → investigator2:rw
```

This provides more precise access control.

---

# 9. ACL Mask

While working with ACLs, I also learned about the **ACL mask**.

The mask can limit the effective permissions of:

* Named users
* Named groups
* The owning group

For example:

```text
user:acluser:rw-
mask::r--
```

The requested permission is `rw`, but the effective permission can be limited by the mask.

Therefore, when auditing ACLs, I should not only look at the named user's entry.

I should also check the mask.

---

# 10. Permission Security Audit

For the capstone, I treated the lab as a small Linux security assessment.

### Find world-writable files

```bash
find ~/permissions-lab -type f -perm -0002 -ls
```

World-writable files deserve attention because users other than the owner can modify them.

### Find SUID files

```bash
find ~/permissions-lab -type f -perm -4000 -ls
```

### Find SGID files

```bash
find ~/permissions-lab -type f -perm -2000 -ls
```

### Inspect ACLs

```bash
getfacl ~/permissions-lab/acl_test.txt
```

### Inspect directory permissions

```bash
ls -ld ~/permissions-lab/shared
```

---

# Security Findings

The most obvious dangerous permission configuration I identified was:

```text
777
```

because it provides:

```text
Owner  → rwx
Group  → rwx
Others → rwx
```

This means everyone can potentially read, modify, and execute the file.

However, I learned that **the most dangerous configuration isn't necessarily the largest permission number**.

For example:

```text
root-owned
    +
SUID
    +
writable by ordinary user
```

can be much more significant because it combines **elevated execution privileges with unauthorized modification**.

---

# Security Mental Model

The permission model I developed during this module is:

```text
                 FILE
                   │
          ┌────────┴────────┐
          │                 │
      WHO OWNS IT?      WHAT CAN THEY DO?
          │                 │
        chown          chmod / ACL
          │                 │
          └────────┬────────┘
                   │
             SPECIAL BITS
                   │
       ┌───────────┼───────────┐
       │           │           │
      SUID        SGID       Sticky
       │           │           │
    User ID     Group ID    Delete/
    execution   /inheritance rename
                   protection
```

The key security principle is:

> **Don't judge a permission in isolation.**

Always consider:

```text
Owner
+
Group
+
Permissions
+
Special bits
+
ACLs
+
What the file actually does
```

---

# Key Commands

| Command      | Purpose                    | Security Application         |
| ------------ | -------------------------- | ---------------------------- |
| `chmod`      | Change permissions         | Access control/hardening     |
| `chown`      | Change ownership           | Ownership management         |
| `ls -l`      | View ownership/permissions | Permission auditing          |
| `find -perm` | Find special permissions   | Security auditing            |
| `getfacl`    | View ACLs                  | Access-control investigation |
| `setfacl`    | Modify ACLs                | Granular access control      |

---

# What I Learned

After completing this module, I can:

* Read Linux permission strings.
* Convert numeric permissions such as `755` and `640`.
* Make targeted changes using symbolic `chmod`.
* Understand ownership separately from permissions.
* Change file ownership with `chown`.
* Explain SUID and effective user identity.
* Explain SGID and effective group identity.
* Understand SGID inheritance on directories.
* Explain the purpose of the sticky bit.
* Distinguish SGID from the sticky bit.
* Use ACLs to provide specific users with additional permissions.
* Understand the purpose of the ACL mask.
* Search for world-writable, SUID, and SGID files.
* Identify potentially dangerous permission combinations.
* Analyze permissions from a privilege-escalation perspective.

---

# Final Takeaway

This module changed how I look at Linux permissions.

A permission such as:

```text
777
```

is easy to identify as excessive, but real security analysis requires looking deeper.

For example:

```text
Who owns the file?
        ↓
Who can modify it?
        ↓
Can anyone execute it?
        ↓
Does it have SUID/SGID?
        ↓
Are ACLs present?
        ↓
What does the program actually do?
```

The most important lesson I took from this module is:

> **Linux security is not simply about permissions being high or low. It's about whether the right users and processes have the right level of access to the right resources.**

This provides the foundation for the next module:

**Module 04 — User Management**

```text
useradd
usermod
passwd
sudo
/etc/shadow
```

There, the focus moves from **file access control** to **identity, authentication, and privilege management**.
