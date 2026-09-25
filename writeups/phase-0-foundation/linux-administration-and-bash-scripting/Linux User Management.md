# Module 04 — Linux User Management

## Overview

This module focused on **Linux identity, authentication, and privilege management**.

The goal was not just to learn commands such as `useradd` or `passwd`, but to understand how user accounts become a security concern during system administration and incident investigation.

The main security principle I learned was:

> **An account should be evaluated based on its identity, groups, privileges, authentication state, and activity—not simply because the account exists.**

---

# Topics Covered

* `useradd`
* `usermod`
* `passwd`
* `sudo`
* `/etc/shadow`
* User security auditing
* User management security capstone

---

# 1. `useradd`

`useradd` creates a new Linux user account.

Basic usage:

```bash
sudo useradd username
```

For a normal account with a home directory:

```bash
sudo useradd -m username
```

The `-m` option creates:

```text
/home/username
```

I created a dedicated lab account:

```bash
sudo useradd -m audituser
```

Then verified it using:

```bash
id audituser
```

and:

```bash
getent passwd audituser
```

The account created in my lab had:

```text
UID = 1002
GID = 1002
Home = /home/audituser
```

### Security relevance

An unexpected account can be an **indicator of persistence or unauthorized access**.

However, an unfamiliar account is not automatically malicious.

During an investigation, I would ask:

```text
Unexpected account
       ↓
Who created it?
       ↓
When was it created?
       ↓
What groups does it belong to?
       ↓
Does it have sudo access?
       ↓
Has it logged in?
       ↓
Does its activity match its purpose?
```

---

# 2. `usermod`

`usermod` modifies an existing Linux user account.

I practiced account locking:

```bash
sudo usermod -L audituser
```

and unlocking:

```bash
sudo usermod -U audituser
```

I verified the account state using:

```bash
sudo passwd -S audituser
```

A locked account showed an `L` state.

### Group management

One important distinction I learned was:

```bash
sudo usermod -G group username
```

versus:

```bash
sudo usermod -aG group username
```

`-G` **replaces** the user's supplementary groups.

`-aG` **appends** the new group while preserving existing supplementary groups.

This matters because accidentally replacing a user's groups could:

* Remove legitimate access.
* Cause unexpected permission changes.
* Change the user's effective access to resources.

### Security relevance

Account locking can be useful for:

* Disabled accounts
* Dormant accounts
* Temporary accounts
* Suspicious accounts
* Accounts that should no longer be used

However, locking an account alone does not prove malicious activity.

---

# 3. `passwd`

The `passwd` command manages a user's password.

I created a password for the lab account:

```bash
sudo passwd audituser
```

Then checked its status:

```bash
sudo passwd -S audituser
```

A `P` state indicated that the account had a usable password.

---

## Password Aging

I used:

```bash
sudo chage -l audituser
```

This displays information such as:

* Last password change
* Minimum password age
* Maximum password age
* Password expiration
* Inactive period
* Account expiration

### Security relevance

Password-aging information can help identify accounts whose configuration doesn't match an organization's security policy.

For example:

```text
Account
   ↓
Password policy
   ↓
Expiration
   ↓
Compare with organizational requirements
   ↓
Identify potential policy violations
```

An unusually long password expiration period is **not automatically a vulnerability**. It needs to be compared with the intended policy and the purpose of the account.

---

# 4. `sudo`

`sudo` allows an authorized user to execute commands with elevated privileges, commonly as `root`.

I inspected my sudo permissions using:

```bash
sudo -l
```

This showed the commands and privileges available through sudo.

I also checked a specific user's sudo access using:

```bash
sudo -l -U audituser
```

My lab account did not have sudo access.

### Security relevance

Excessive sudo privileges can become a serious security risk.

For example:

```text
Normal user
     ↓
sudo permission
     ↓
Administrative command
     ↓
Elevated privileges
```

If a user is allowed to execute more administrative commands than necessary, compromise of that account can have a much larger impact.

During an investigation, I would ask:

```text
Who has sudo?
     ↓
What commands can they run?
     ↓
Can they run commands as root?
     ↓
Are those permissions expected?
```

---

# 5. `/etc/shadow`

`/etc/shadow` contains sensitive authentication information and password-aging data.

I inspected its permissions using:

```bash
ls -l /etc/shadow
```

The file was owned by:

```text
root
```

with the group:

```text
shadow
```

and restrictive permissions.

I also learned that passwords are **not stored as plain text**. Linux stores password hashes and related account-aging information.

### Security relevance

Unauthorized access to `/etc/shadow` is a serious security concern because exposed password hashes could potentially be subjected to **offline password-cracking attempts**.

Therefore, `/etc/shadow` should not be readable by ordinary users.

---

# 6. `/etc/passwd` vs `/etc/shadow`

An important distinction I learned:

### `/etc/passwd`

Contains account information such as:

```text
username
UID
GID
home directory
login shell
```

### `/etc/shadow`

Contains sensitive authentication-related information such as:

```text
password hash
password aging
password expiration
account expiration
```

A simplified mental model:

```text
/etc/passwd
     ↓
Who is the user?

/etc/shadow
     ↓
How is the account authenticated
and when does its authentication expire?
```

---

# 7. User Security Audit

For the capstone, I performed a basic security assessment of `audituser`.

I checked:

### Identity

```bash
id audituser
```

### Groups

```bash
groups audituser
```

### Password state

```bash
sudo passwd -S audituser
```

### Password aging

```bash
sudo chage -l audituser
```

### Sudo access

```bash
sudo -l -U audituser
```

### `/etc/shadow` permissions

```bash
ls -l /etc/shadow
```

---

# 8. Security Assessment

My lab account had:

```text
Account:          audituser
UID/GID:          1002/1002
Groups:           audituser
Password state:   Usable
Sudo access:      None
```

The account belonged only to its own non-privileged group and had no sudo access.

Therefore, based on the evidence collected:

> **There was no obvious privilege-related security risk associated with this account.**

The password expiration was unusually distant, which I considered worth checking against an organization's password policy.

However, I learned that this alone does not prove that the account is malicious.

A proper investigation requires additional evidence such as:

* Account creation information
* Login history
* Group membership
* Sudo privileges
* File access
* Process activity
* Authentication logs
* Whether the account matches an authorized role

---

# 9. Security Investigation Method

The biggest lesson from the capstone was to investigate **context instead of jumping to conclusions**.

For example:

```text
Account discovered
       ↓
Is it authorized?
       ↓
What groups?
       ↓
What privileges?
       ↓
What authentication state?
       ↓
What password policy?
       ↓
What files/resources can it access?
       ↓
What activity has it performed?
       ↓
Does the activity match its purpose?
```

An account named `audituser` isn't suspicious simply because it exists.

But if the same account:

```text
wasn't authorized
      +
belongs to privileged groups
      +
has sudo access
      +
has suspicious login activity
```

then the risk becomes much more significant.

---

# Key Commands

| Command             | Purpose                    | Security Application         |
| ------------------- | -------------------------- | ---------------------------- |
| `useradd`           | Create a user              | Account administration       |
| `usermod`           | Modify a user              | Account control              |
| `passwd`            | Manage passwords           | Authentication               |
| `chage`             | Manage password aging      | Password-policy auditing     |
| `sudo -l`           | Show sudo privileges       | Privilege auditing           |
| `id`                | Show UID/GID/groups        | Identity investigation       |
| `groups`            | Show group membership      | Access investigation         |
| `getent passwd`     | Query account database     | User enumeration             |
| `ls -l /etc/shadow` | Inspect shadow permissions | Authentication-file security |

---

# Security Mental Model

```text
                  USER ACCOUNT
                       │
             ┌─────────┴─────────┐
             │                   │
         IDENTITY            AUTHENTICATION
             │                   │
       useradd/usermod       passwd/chage
             │                   │
             └─────────┬─────────┘
                       │
                       ▼
                   PRIVILEGE
                       │
                      sudo
                       │
                       ▼
                    ACCESS
                       │
                 Groups + Files
                       │
                       ▼
                 SECURITY AUDIT
                       │
       ┌───────────────┼───────────────┐
       │               │               │
    Identity        Privileges      Activity
       │               │               │
       └───────────────┼───────────────┘
                       ▼
                  Risk Assessment
```

---

# What I Learned

After completing this module, I can:

* Create Linux users with `useradd`.
* Understand UID, GID, and home directories.
* Modify accounts using `usermod`.
* Lock and unlock accounts.
* Understand the difference between `-G` and `-aG`.
* Manage passwords using `passwd`.
* Inspect password-aging policies using `chage`.
* Understand the purpose of `sudo`.
* Audit sudo privileges using `sudo -l`.
* Explain why excessive sudo access is dangerous.
* Understand the purpose and sensitivity of `/etc/shadow`.
* Distinguish `/etc/passwd` from `/etc/shadow`.
* Investigate user groups and privileges.
* Perform a basic Linux user security audit.
* Assess whether an account is actually suspicious using evidence and context.

---

# Final Takeaway

The most important lesson from this module was:

> **A Linux account should never be judged by its name alone. Its security risk depends on its groups, privileges, authentication configuration, accessible resources, and actual activity.**

The investigation mindset I developed is:

```text
Who is this user?
       ↓
What groups are they in?
       ↓
What can they access?
       ↓
What privileges can they obtain?
       ↓
How is the account authenticated?
       ↓
What has the account actually done?
```

This provides the foundation for the next module:

# Module 05 — Process Management

```text
ps
top
kill
nice
jobs
bg
fg
nohup
```

The focus will shift from **who is operating on the system** to **what is actually running on the system**.
