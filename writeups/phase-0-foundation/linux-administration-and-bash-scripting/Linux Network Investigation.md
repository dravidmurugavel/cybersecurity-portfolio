# Module 07 — Linux Networking & Network Investigation

## Overview

This module focused on understanding Linux networking from a **security investigation perspective**.

The goal was not to become a network engineer, but to learn how to answer questions such as:

* What network interfaces does this host have?
* Where does network traffic go?
* Which ports are listening?
* Which process created a connection?
* Which user owns that process?
* What executable is actually running?
* What parent process started it?
* Is the connection normal or does it require investigation?

The central idea throughout the module was:

```text
Network Activity
      ↓
IP / Port
      ↓
Process
      ↓
PID
      ↓
User
      ↓
Executable
      ↓
Parent / Child Process
      ↓
DNS / Hostname
      ↓
Investigation Verdict
```

---

# 1. Network Interfaces

The first step in network investigation is understanding the host's network interfaces.

### Command

```bash
ip addr
```

This displays network interfaces, IP addresses, interface state, and related information.

During the investigation, the active interface was:

```text
eth0
```

The system also had:

```text
lo
```

which is the loopback interface.

The IPv4 address assigned to `eth0` helped identify the host's local network identity.

### Security relevance

Knowing the local IP address is useful when correlating:

* Network connections
* Packet captures
* Firewall logs
* DNS activity
* Proxy logs
* Incident timelines

The local IP alone does not indicate malicious activity. It is primarily useful for **correlation and attribution**.

---

# 2. Routing Table Investigation

After identifying the network interfaces, the next step was understanding where traffic is sent.

### Command

```bash
ip route
```

The routing table showed a default gateway on the local network.

A default route tells Linux:

> If there is no more-specific route for a destination, send the packet through this gateway.

Conceptually:

```text
Host
 ↓
Routing table
 ↓
Specific route?
 ├── Yes → use specific route
 └── No  → use default gateway
```

### Security relevance

Unexpected routes can become investigation leads because attackers, VPNs, containers, or other software can modify routing behavior.

However, an unusual route is **not automatically malicious**. It needs to be correlated with the system's configuration and activity.

---

# 3. Active Network Connections

To see active connections, I used:

```bash
ss -tunap
```

Important options:

```text
-t → TCP
-u → UDP
-n → numeric addresses and ports
-a → all sockets
-p → process information
```

This allows an investigator to connect network activity with the process responsible for it.

Example investigation:

```text
Local IP:Port
      ↓
Remote IP:Port
      ↓
Process
      ↓
PID
```

One observed connection was associated with:

```text
Process: firefox-esr
PID:     2449
Remote:  104.28.32.47:443
```

This immediately provided more context than looking at an IP address alone.

---

# 4. Listening Ports

Listening sockets were investigated using:

```bash
ss -lntup
```

A listening socket means a process is **waiting for incoming network traffic**.

One important finding was:

```text
127.0.0.53:53
```

This was associated with:

```text
systemd-resolve
```

The `127.0.0.53` address is a local loopback DNS resolver.

Using:

```bash
sudo ss -lntup
```

provided additional process information that was not visible to the unprivileged command.

### Security lesson

A listening port should not be considered suspicious simply because it is unfamiliar.

The investigator should ask:

```text
What port?
      ↓
What address?
      ↓
What process?
      ↓
What executable?
      ↓
Why is it listening?
```

---

# 5. DNS Investigation

DNS investigation was performed with:

```bash
resolvectl status
```

This showed the configured DNS information for the network interface.

DNS essentially provides a relationship between:

```text
Domain name ↔ IP address
```

For example:

```text
google.com
     ↓
IPv4 address
```

The DNS resolver used by the system was:

```text
127.0.0.53
```

---

# 6. Reverse DNS and PTR Records

Reverse DNS works in the opposite direction from normal DNS.

### Normal DNS

```text
Domain
   ↓
IP address
```

### Reverse DNS

```text
IP address
   ↓
PTR record
   ↓
Hostname
```

A PTR record is a DNS record used to associate an IP address with a hostname.

Reverse lookups can be performed with:

```bash
dig -x <IP>
```

For example:

```bash
dig -x 34.107.243.93
```

### Important DNS responses

#### NXDOMAIN

```text
NXDOMAIN
```

means the queried DNS name does not exist.

It does **not** mean that the IP is malicious.

#### NOERROR

```text
NOERROR
```

means the DNS query was processed successfully.

The investigator should still check the `ANSWER SECTION` to determine whether useful data was returned.

---

# 7. DNS A Records

An `A` record maps a domain name to an IPv4 address.

Example:

```text
google.com
     ↓
A record
     ↓
IPv4 address
```

A domain can have multiple A records.

This can happen for reasons such as:

* Load distribution
* Availability
* Geographic routing
* Redundancy

Therefore, a DNS lookup may return several IPv4 addresses.

The important investigation principle is:

> A DNS result does not necessarily mean the host is currently communicating with every returned IP.

Actual connections should be correlated using tools such as `ss` and `lsof`.

---

# 8. DNS Cache Investigation

DNS cache statistics were checked with:

```bash
resolvectl statistics
```

The observed system showed:

```text
Cache hits:   23
Cache misses: 44
```

The basic model is:

```text
DNS request
     ↓
Is the answer cached?
     ├── Yes → Cache hit
     │
     └── No → Cache miss
              ↓
          DNS lookup
```

Cache statistics help provide context about DNS activity, but they do not independently indicate compromise.

---

# 9. Network Connection → Process Investigation

One of the most important skills developed in this module was connecting network activity to a specific process.

For example:

```text
Remote IP:Port
      ↓
Firefox
      ↓
PID 2449
```

The process information was examined using:

```bash
ps -fp <PID>
```

This allowed the investigation to identify the user running the process.

For Firefox:

```text
User: kali
PID:  2449
```

---

# 10. Identifying the Actual Executable

Knowing only the process name is not always enough.

The actual executable was identified with:

```bash
readlink -f /proc/<PID>/exe
```

For Firefox:

```text
/usr/lib/firefox-esr/firefox-esr
```

The file was then examined using:

```bash
ls -l <executable>
```

The executable was:

```text
Owner: root
Permissions: rwxr-xr-x
```

This demonstrated an important distinction:

> A program file can be owned by root while the program itself runs under a normal user account.

Firefox's executable was root-owned, while the Firefox process was running as the `kali` user.

---

# 11. Process Trees

Network investigation should not stop at the process that owns the connection.

The process's ancestry can provide additional context.

### Command

```bash
pstree -aps <PID>
```

The Firefox process was traced through the desktop session:

```text
systemd
  ↓
lightdm
  ↓
lightdm session
  ↓
xfce4-session
  ↓
xfce4-panel
  ↓
firefox-esr
```

This was consistent with a normal graphical Linux desktop session.

### Security relevance

Process trees can reveal unexpected execution chains.

For example:

```text
firefox
   ↓
bash
   ↓
/tmp/.hidden
```

would deserve investigation because the relationship between the browser, shell, and unusual executable is abnormal.

---

# 12. Parent → Child Relationships

A process tree helps answer:

> Which process started this process?

This is important during incident response because malicious activity can hide behind an otherwise legitimate process.

For example:

```text
Legitimate process
       ↓
Unexpected child
       ↓
Suspicious executable
```

The parent process can therefore provide important context when determining how execution occurred.

---

# 13. Network Connection Triage

A major lesson from this module was that **one indicator is rarely enough**.

A network connection should be evaluated using multiple pieces of evidence:

```text
Remote IP
   +
Remote Port
   +
Process
   +
User
   +
Executable
   +
Parent Process
   +
DNS
   +
Context
```

For example:

```text
Firefox
↓
kali
↓
/usr/lib/firefox-esr/firefox-esr
↓
443
↓
Expected browser activity
```

is very different from:

```text
unknown process
↓
kali
↓
/tmp/.update-helper
↓
bash
↓
443
```

The second scenario would be an **investigation lead**, not automatically confirmed malware.

---

# 14. Suspicious Connection Indicators

Several indicators were used to identify connections that deserve additional investigation.

### Examples

**Unknown process**

```text
Process: unknown
```

**Unusual executable location**

```text
/tmp/.update-helper
```

**Hidden-looking filename**

```text
.update-helper
```

**Unexpected parent process**

```text
bash
```

**External network connection**

```text
Remote: x.x.x.x:443
```

Individually, these may have legitimate explanations.

Together, however, they create a stronger investigation lead.

---

# 15. `lsof` for Network Attribution

The following command was used:

```bash
sudo lsof -i -P -n | grep <PID>
```

This provides another way to associate a process with network connections.

For Firefox, the investigation showed multiple established TCP connections over port 443.

Example:

```text
firefox-esr
PID 2449
kali
TCP
remote:443
ESTABLISHED
```

This confirmed that the Firefox process was actively associated with those network connections.

### Why use both `ss` and `lsof`?

They provide overlapping but useful perspectives.

```text
ss
 ↓
Socket / network perspective

lsof
 ↓
Open-file / process perspective
```

Using both can strengthen attribution during investigation.

---

# 16. Network Investigation Mental Model

The most important mental model from this module is:

```text
             NETWORK ACTIVITY
                    │
                    ▼
              IP : PORT
                    │
                    ▼
                PROCESS
                    │
                    ▼
                   PID
                    │
                    ▼
                  USER
                    │
                    ▼
               EXECUTABLE
                    │
                    ▼
            PARENT / CHILD
                    │
                    ▼
              DNS / HOSTNAME
                    │
                    ▼
                 CONTEXT
                    │
                    ▼
          NORMAL / INVESTIGATE
```

This approach prevents jumping directly from:

```text
Unknown IP
```

to:

```text
Malware
```

Instead, evidence is progressively correlated.

---

# 17. Practical Investigation Example

During the final exercise, a simulated connection looked like:

```text
Remote:     185.XX.XX.XX:443
Process:    update-helper
PID:        3821
User:       kali
Executable: /tmp/.update-helper
Parent:     bash
```

The correct verdict was:

```text
Investigation Lead
```

### Why?

Because several unusual characteristics appeared together:

```text
Unknown process
      ↓
User-level execution
      ↓
Executable in /tmp
      ↓
Hidden-looking filename
      ↓
bash parent
      ↓
External network connection
```

However, this was **not enough to confirm malware**.

Further evidence would be required.

---

# 18. Key Commands

| Purpose                     | Command                       |
| --------------------------- | ----------------------------- |
| Network interfaces          | `ip addr`                     |
| Routing table               | `ip route`                    |
| Active connections          | `ss -tunap`                   |
| Listening ports             | `ss -lntup`                   |
| DNS configuration           | `resolvectl status`           |
| DNS statistics              | `resolvectl statistics`       |
| DNS lookup                  | `dig <domain>`                |
| Reverse DNS                 | `dig -x <IP>`                 |
| Process details             | `ps -fp <PID>`                |
| Executable path             | `readlink -f /proc/<PID>/exe` |
| File permissions            | `ls -l <file>`                |
| Process tree                | `pstree -aps <PID>`           |
| Network/process attribution | `lsof -i -P -n`               |

---

# 19. Security Lessons Learned

### 1. Don't investigate IPs in isolation

An IP address becomes much more useful when correlated with:

```text
IP → Process → User → Executable
```

### 2. Port numbers are context, not proof

Port `443` normally indicates HTTPS/TLS traffic, but:

```text
443 ≠ automatically legitimate
```

### 3. Legitimate programs can make suspicious connections

Seeing Firefox does not automatically prove the connection is safe.

Investigate the complete context.

### 4. Process ancestry matters

Unexpected parent-child relationships can reveal suspicious execution chains.

### 5. Unusual does not automatically mean malicious

A suspicious-looking process should become an:

```text
Investigation Lead
```

until sufficient evidence supports a stronger conclusion.

---

# 20. Module Completion

**Module 07 — Linux Networking & Network Investigation: COMPLETE ✅**

I can now:

* Identify Linux network interfaces
* Read the routing table
* Inspect active network connections
* Identify listening ports
* Investigate DNS configuration
* Perform forward and reverse DNS lookups
* Understand A and PTR records
* Identify the process responsible for a connection
* Trace a process to its executable
* Identify process owners
* Investigate parent-child process relationships
* Use `ss` and `lsof` for network attribution
* Triage suspicious connections
* Build an evidence-based network investigation
* Distinguish an **investigation lead** from **confirmed malicious activity**

## Next Module

**Module 08 — Linux Logs & Log Investigation**

The next step is to add **time and historical evidence** to the investigation:

```text
Network activity
      +
Process activity
      +
Logs
      ↓
Timeline
      ↓
Incident investigation
```
