# Module 07 — Linux Networking & Network Administration

## Overview

Module 07 focused on understanding how Linux networking works from both an **administration** and **security investigation** perspective.

The goal was not just to memorize networking commands, but to understand how to move from a basic connectivity problem to identifying the exact process responsible for a network service.

I also worked with **nftables** to understand firewall tables, chains, rules, counters, verdicts, rule ordering, and persistence through systemd.

The biggest lesson from this module was:

> **A network investigation should move from connectivity → service → process → user → executable → configuration → risk assessment.**

---

# Topics Covered

* Network interfaces
* IPv4 addressing
* Routing and default gateways
* ARP/neighbour discovery
* NetworkManager
* DNS investigation
* Connectivity troubleshooting
* TCP/UDP sockets
* `ss`
* `lsof`
* `/proc`
* `curl`
* HTTP/HTTPS
* HTTP status codes
* Redirects
* HTTP headers
* Authentication headers
* Cookies
* JSON APIs
* `wget`
* File integrity with SHA-256
* `nftables`
* Firewall tables and chains
* Firewall rules
* `accept`, `drop`, and `reject`
* Rule counters
* Rule handles and ordering
* Runtime vs persistent firewall configuration
* systemd firewall persistence
* Network investigation workflow
* SOC-style network investigation

---

# 1. Network Interfaces

I started by identifying the network interface used by my Kali VM.

The interface was:

```text
eth0
```

I used:

```bash
ip addr
```

and:

```bash
ip link show eth0
```

The interface showed:

```text
state UP
```

This means the interface is enabled and operational at the interface/link level.

However:

> **`state UP` does not prove that Internet connectivity is working.**

It only tells us that the interface itself is up.

---

# 2. IPv4 Address

I checked the IPv4 configuration using:

```bash
ip -4 addr show eth0
```

My VM had:

```text
192.168.213.128/24
```

The `/24` represents the subnet mask:

```text
255.255.255.0
```

This confirmed that `eth0` had an IPv4 address.

The troubleshooting process therefore became:

```text
Interface
    ↓
IPv4 address
```

---

# 3. Routing

I inspected the routing table with:

```bash
ip route
```

My default gateway was:

```text
192.168.213.2
```

The default route tells Linux where to send traffic when no more specific route exists.

I also previously used:

```bash
ip route get 8.8.8.8
```

This showed Linux selecting:

```text
dev eth0
src 192.168.213.128
```

This helped me understand that Linux makes an actual routing decision before sending traffic.

---

# 4. ARP / Neighbour Discovery

I investigated local network neighbours using:

```bash
ip neigh
```

I observed neighbour states such as:

```text
REACHABLE
STALE
```

I learned that:

* `REACHABLE` means the neighbour has recently been confirmed reachable.
* `STALE` means Linux has a known neighbour entry but it has not recently confirmed reachability.

An important lesson was:

> **A STALE neighbour entry is not automatically suspicious.**

It is simply part of normal neighbour-cache behavior.

---

# 5. NetworkManager

I used:

```bash
nmcli device status
```

My interface appeared as:

```text
eth0
ethernet
connected
Wired connection 1
```

I also investigated the connection using:

```bash
nmcli connection show "Wired connection 1"
```

and:

```bash
nmcli device show eth0
```

This allowed me to see information such as:

```text
IP4.ADDRESS
IP4.GATEWAY
IP4.DNS
```

This demonstrated how NetworkManager provides another layer for investigating Linux network configuration.

---

# 6. DNS Investigation

I tested DNS resolution using:

```bash
dig google.com
```

The response returned multiple IPv4 addresses.

I also tested:

```bash
dig google.com A
```

and:

```bash
dig google.com AAAA
```

This showed the difference between:

```text
A     → IPv4
AAAA  → IPv6
```

I also investigated reverse DNS:

```bash
dig -x 8.8.8.8
```

which returned:

```text
dns.google
```

I learned that reverse DNS uses PTR records and can help identify the hostname associated with an IP address.

---

# 7. Connectivity Troubleshooting

I built a layered troubleshooting workflow instead of immediately assuming that an Internet problem was a DNS problem.

The workflow became:

```text
Interface
    ↓
IP address
    ↓
Route
    ↓
Gateway
    ↓
Public IP
    ↓
DNS
    ↓
TCP port
    ↓
Application
```

I tested my gateway:

```bash
ping -c 4 192.168.213.2
```

Result:

```text
0% packet loss
```

Then I tested a public IP:

```bash
ping -c 4 8.8.8.8
```

Again:

```text
0% packet loss
```

This demonstrated that the network path was working without involving DNS.

---

# 8. HTTP / HTTPS with curl

I used `curl` extensively to understand application-layer networking.

For example:

```bash
curl -I https://google.com
```

This returned a:

```text
301 Moved Permanently
```

I learned that a `301` is a redirect response, not necessarily a failure.

Using:

```bash
curl -I -L https://google.com
```

allowed curl to follow the redirect.

The final response returned:

```text
200 OK
```

This demonstrated:

```text
Request
   ↓
301 redirect
   ↓
curl follows redirect
   ↓
200 OK
```

---

# 9. curl Verbose Mode

I used:

```bash
curl -v https://google.com
```

This helped me observe the connection process:

```text
DNS resolution
     ↓
TCP connection
     ↓
TLS handshake
     ↓
Certificate verification
     ↓
HTTP request
     ↓
HTTP response
```

I also compared sites such as Google and Yahoo to observe differences in:

* TLS certificates
* Certificate authorities
* HTTP response headers
* Redirect behavior
* Server information
* Timing

This gave me a much better understanding of what actually happens when an HTTPS connection is established.

---

# 10. HTTP Headers

I used:

```bash
curl -I https://google.com
```

to inspect response headers.

I learned to pay attention to fields such as:

```text
HTTP status
Content-Type
Location
Server
Strict-Transport-Security
```

The `Location` header is particularly important when investigating redirects.

I also experimented with custom request headers:

```bash
curl -H "X-SOC-Lab: test" ...
```

This helped demonstrate how HTTP headers can carry additional information between a client and server.

---

# 11. HTTP Status Codes

I practiced extracting status codes programmatically:

```bash
curl -s -o /dev/null -w '%{http_code}\n' https://google.com
```

This is useful for automation because a script can make decisions based on the HTTP status.

I also investigated a nonexistent API resource and received:

```text
404 Not Found
```

This taught me an important distinction:

> **An HTTP error response is different from a curl/network failure.**

The server successfully responded; the requested resource simply wasn't found.

---

# 12. curl Error Handling

I experimented with:

```bash
curl --fail
```

and examined curl's exit status.

For a 4xx/5xx response, `--fail` can cause curl to return a non-zero exit status.

This demonstrated an important automation pattern:

```text
HTTP request
     ↓
Check exit status
     ↓
Success?
     ↓
Continue

Failure?
     ↓
Handle error
```

This is particularly useful when curl is incorporated into security scripts.

---

# 13. curl Authentication

I practiced several authentication concepts.

### Basic Authentication

I used:

```bash
curl -u test:soc123 https://httpbin.org/basic-auth/test/soc123
```

This demonstrated HTTP Basic Authentication.

The credentials are Base64-encoded rather than encrypted, which is why HTTPS is essential.

### Bearer Authentication

I also tested:

```bash
curl -H "Authorization: Bearer soc-lab-token-123" ...
```

This demonstrated how bearer tokens are normally supplied through the `Authorization` header.

A key security lesson was:

> **Bearer tokens should be treated like credentials.**

I also learned that using:

```bash
curl -v
```

during authentication testing can expose sensitive headers in terminal output.

---

# 14. Cookies

I practiced saving and reusing cookies:

```bash
curl -c cookies.txt ...
```

and:

```bash
curl -b cookies.txt ...
```

This demonstrated the difference between:

```text
-c → save cookies
-b → send cookies
```

Cookies are important during web investigations because they can represent:

* Sessions
* Authentication state
* Tracking identifiers
* Application state

---

# 15. JSON APIs

I practiced sending JSON using:

```bash
curl -X POST \
-H "Content-Type: application/json" \
-d '{"username":"test","role":"soc"}' \
https://httpbin.org/post
```

I also worked with the API Challenges practice environment.

I created a challenge session and used an `X-CHALLENGER` header to interact with the API.

I investigated:

```text
/api/challenges
/api/todos
/api/todos/1
/api/todos/9999
```

This gave me practical experience with:

* API authentication/session headers
* GET requests
* HTTP status codes
* JSON responses
* Resource enumeration
* 404 handling

---

# 16. wget

I compared `wget` with `curl`.

I used:

```bash
wget https://example.com
```

and:

```bash
wget -O yahoo.html https://yahoo.com
```

I learned that `wget` is particularly convenient for downloading files, while `curl` is often more flexible for HTTP/API interaction and request manipulation.

I also used:

```bash
wget --server-response --spider https://example.com
```

`--spider` allows checking a resource without downloading it.

This can be useful during reconnaissance and troubleshooting.

---

# 17. wget Error Handling

I tested a nonexistent resource:

```bash
wget --timeout=5 -q -O missing.html \
https://example.com/does-not-exist
```

The exit status was:

```text
8
```

I learned that wget's exit code can be used by scripts to determine whether an operation succeeded.

For example:

```bash
if wget -q -O test.html https://example.com; then
    echo "Download successful"
    sha256sum test.html
else
    echo "Download failed"
fi
```

This introduced a practical pattern for security automation.

---

# 18. File Integrity with SHA-256

After downloading a file, I used:

```bash
sha256sum test.html
```

I learned that SHA-256 is a **cryptographic hash**, not encryption.

The same file produces the same hash when its content remains unchanged.

After modifying the file:

```bash
echo "modified" >> test.html
```

the SHA-256 hash changed completely.

I also created and verified a baseline:

```bash
sha256sum test.html > test.sha256
sha256sum -c test.sha256
```

A valid file produced:

```text
OK
```

After modification:

```text
FAILED
```

This demonstrated how hashes can be used for integrity verification.

---

# 19. nftables

I then moved into Linux firewall administration using `nftables`.

I first checked the existing configuration:

```bash
sudo nft list ruleset
```

The initial ruleset was empty.

I created a lab table:

```bash
sudo nft add table inet lab
```

Then an input chain:

```bash
sudo nft add chain inet lab input \
'{ type filter hook input priority 0; policy accept; }'
```

This introduced the nftables structure:

```text
Table
   ↓
Chain
   ↓
Rule
```

---

# 20. nftables Rules and Counters

I created a logging/counter rule:

```bash
sudo nft add rule inet lab input counter log prefix "SOC-LAB: "
```

I learned that:

```text
counter
```

tracks packets and bytes, while:

```text
log
```

records matching traffic.

I then created an ICMP-specific rule:

```bash
sudo nft add rule inet lab input ip protocol icmp counter
```

After running:

```bash
ping -c 4 127.0.0.1
```

the ICMP counter increased.

This demonstrated:

```text
Packet
  ↓
Rule match
  ↓
Counter increments
```

---

# 21. accept, drop, and reject

I tested the three important firewall behaviors.

### accept

Allows matching traffic.

### drop

Silently discards the packet.

### reject

Discards the packet while actively notifying the sender.

I tested these behaviors against a local TCP port.

The practical difference was:

```text
DROP
→ connection waits / times out

REJECT
→ connection fails immediately
```

From a security perspective, this helped me understand that firewall behavior can affect both **connectivity and information exposure**.

---

# 22. Rule Ordering and Handles

I learned that nftables processes rules from top to bottom.

I used:

```bash
sudo nft -a list chain inet lab input
```

to display rule handles.

A handle identifies a specific rule.

For example:

```text
handle 8
```

I could remove that exact rule with:

```bash
sudo nft delete rule inet lab input handle 8
```

I also learned that handles do not determine ordering.

To insert a rule at a specific position, I used:

```bash
sudo nft insert rule ...
```

This taught me that:

```text
Position → controls rule order
Handle   → identifies the rule
```

---

# 23. Runtime vs Persistent Firewall Rules

One of the most important nftables lessons was understanding the difference between **runtime configuration** and **persistent configuration**.

Rules added directly with:

```bash
nft add ...
```

exist in the running firewall configuration.

They are not automatically permanent.

I inspected:

```bash
/etc/nftables.conf
```

and found the default persistent configuration.

I also verified that the systemd service uses:

```text
ExecStart=/usr/sbin/nft -f /etc/nftables.conf
```

Therefore:

```text
systemd
   ↓
nftables.service
   ↓
nft -f /etc/nftables.conf
   ↓
persistent ruleset
```

---

# 24. Testing Firewall Persistence

I exported my tested lab rules:

```bash
sudo nft list ruleset > nft-lab-backup.conf
```

I removed the lab table:

```bash
sudo nft delete table inet lab
```

Then restored it from the saved configuration:

```bash
sudo nft -f nft-lab-backup.conf
```

This confirmed that the rules could be recreated from a saved configuration.

I then copied the tested configuration into:

```text
/etc/nftables.conf
```

and validated it:

```bash
sudo nft -c -f /etc/nftables.conf
```

No output indicated that the syntax validation passed.

---

# 25. systemd Firewall Persistence

I verified that the nftables service was enabled:

```bash
sudo systemctl status nftables
```

The service showed:

```text
enabled
active (exited)
```

I then restarted it:

```bash
sudo systemctl restart nftables
```

and checked:

```bash
sudo nft list ruleset
```

The expected tables and rules returned.

Finally, I generated ICMP traffic:

```bash
ping -c 4 127.0.0.1
```

and confirmed that the ICMP counter increased.

This proved:

```text
/etc/nftables.conf
        ↓
nftables.service
        ↓
inet lab
        ↓
ICMP rule
        ↓
traffic matched
```

---

# 26. Network Socket Investigation

I investigated listening network services with:

```bash
ss -tuln
```

I found several listening ports, including:

```text
53
80
9050
5355
```

However, I learned that a port number alone does not tell me whether a service is legitimate or malicious.

I therefore used:

```bash
sudo ss -tulpn
```

to connect ports with processes and PIDs.

My findings included:

```text
53    → systemd-resolved
5355  → systemd-resolved
80    → apache2
9050  → tor
```

---

# 27. Process Attribution with lsof

I used:

```bash
sudo lsof -i -P -n | grep -E ':(53|80|9050|5355)'
```

This provided another way to correlate:

```text
Port
 ↓
Process
 ↓
PID
 ↓
User
```

For example:

```text
9050
 ↓
tor
 ↓
PID 763
 ↓
debian-tor
```

This demonstrated why port investigation should not stop at `ss`.

---

# 28. `/proc` Investigation

I then investigated PID 763 directly.

To identify the executable:

```bash
sudo readlink -f /proc/763/exe
```

Result:

```text
/usr/bin/tor
```

I then examined the command line:

```bash
sudo tr '\0' ' ' < /proc/763/cmdline
```

The command line showed:

```text
/usr/bin/tor
--defaults-torrc /usr/share/tor/tor-service-defaults-torrc
-f /etc/tor/torrc
--RunAsDaemon 0
```

This gave me a deeper attribution chain:

```text
Port
 ↓
PID
 ↓
User
 ↓
Executable
 ↓
Command line
 ↓
Configuration
```

---

# 29. systemd Service Investigation

During the capstone investigation, I initially investigated:

```text
tor.service
```

It showed:

```text
active (exited)
```

and its `ExecStart` was:

```text
/bin/true
```

This initially appeared inconsistent with the running Tor process.

Instead of assuming something was wrong, I investigated further.

I ran:

```bash
systemctl list-units --type=service | grep -i tor
```

and discovered:

```text
tor.service
tor@default.service
```

The actual running instance was:

```text
tor@default.service
```

Its Main PID was:

```text
763
```

which matched the process listening on:

```text
127.0.0.1:9050
```

This was an important investigation lesson:

> **Don't stop at the first service name. Understand how systemd units relate to the actual process.**

---

# 30. Tor Configuration Investigation

I confirmed the service configuration using:

```bash
systemctl show tor@default \
-p ExecStart \
-p FragmentPath
```

The service used:

```text
/usr/bin/tor
```

with:

```text
/etc/tor/torrc
```

as its configuration file.

I safely inspected the active configuration with:

```bash
sudo grep -vE '^\s*#|^\s*$' /etc/tor/torrc
```

One active configuration directive was:

```text
NewCircuitPeriod 60
```

This was consistent with Tor's normal configuration behavior.

---

# 31. SOC-Style Network Investigation

The final capstone simulated an SOC alert:

> **Unexpected network service detected on the host.**

I investigated the service rather than immediately labeling it malicious.

The investigation followed:

```text
Network context
       ↓
Interface
       ↓
IP address
       ↓
Default route
       ↓
Gateway
       ↓
Internet connectivity
       ↓
DNS
       ↓
Listening ports
       ↓
PID
       ↓
Process
       ↓
User
       ↓
Executable
       ↓
Command line
       ↓
systemd service
       ↓
Startup configuration
       ↓
Configuration file
       ↓
Risk assessment
```

The suspicious service selected for investigation was:

```text
Tor
```

The evidence showed:

```text
127.0.0.1:9050
        ↓
PID 763
        ↓
debian-tor
        ↓
/usr/bin/tor
        ↓
tor@default.service
        ↓
/etc/tor/torrc
```

Based on the available evidence, I classified the finding as:

```text
LEGITIMATE / EXPECTED
```

The important reason was not simply that Tor is legitimate software.

The decision was based on the observed evidence and the need to determine whether the service was **authorized and expected on the host**.

---

# Security Mental Model

The biggest mental model I developed during this module is:

```text
NETWORK
   │
   ├── Interface
   │      ↓
   │    IP address
   │      ↓
   │    Route
   │      ↓
   │    Gateway
   │      ↓
   │    DNS
   │
   └── Services
          ↓
       Listening port
          ↓
          PID
          ↓
        Process
          ↓
         User
          ↓
      Executable
          ↓
      Command line
          ↓
     Configuration
          ↓
      Risk assessment
```

For firewall investigation:

```text
Packet
   ↓
Table
   ↓
Chain
   ↓
Rule
   ↓
Match
   ↓
Action / verdict
   ↓
Counter / log
```

---

# Key Commands

| Command                  | Purpose                       | Security Application         |
| ------------------------ | ----------------------------- | ---------------------------- |
| `ip addr`                | Show interfaces and addresses | Network configuration        |
| `ip link`                | Show interface state          | Interface troubleshooting    |
| `ip route`               | Show routing table            | Route investigation          |
| `ip route get`           | Show route decision           | Traffic-path analysis        |
| `ip neigh`               | Show neighbour cache          | Local network investigation  |
| `nmcli`                  | Manage/inspect NetworkManager | Network administration       |
| `dig`                    | DNS queries                   | DNS investigation            |
| `ping`                   | Test IP connectivity          | Connectivity troubleshooting |
| `curl`                   | HTTP/API client               | Web/API investigation        |
| `wget`                   | Download/test resources       | Retrieval and automation     |
| `ss`                     | Show sockets/listeners        | Port investigation           |
| `lsof`                   | Show open files/sockets       | Process attribution          |
| `readlink /proc/.../exe` | Identify executable           | Process investigation        |
| `/proc/.../cmdline`      | Inspect command line          | Process investigation        |
| `systemctl`              | Manage/inspect services       | Service investigation        |
| `nft`                    | Manage firewall               | Firewall administration      |
| `sha256sum`              | Calculate file hash           | Integrity verification       |

---

# What I Learned

After completing Module 07, I can:

* Identify Linux network interfaces.
* Interpret interface states.
* Identify IPv4 addresses and subnet notation.
* Understand default gateways.
* Inspect Linux routing decisions.
* Investigate neighbour-cache states.
* Use NetworkManager for network inspection.
* Perform DNS lookups with `dig`.
* Perform reverse DNS lookups.
* Troubleshoot connectivity layer-by-layer.
* Understand TCP ports and listening services.
* Use `ss` to identify listening sockets.
* Attribute sockets to processes with `lsof`.
* Use `/proc` to identify executables and command lines.
* Understand HTTP status codes.
* Investigate HTTP redirects.
* Inspect HTTP headers.
* Understand Basic and Bearer authentication.
* Work with cookies and JSON APIs.
* Use curl exit codes for automation.
* Use wget for downloads and resource checks.
* Verify downloaded files with SHA-256.
* Understand nftables tables, chains, and rules.
* Understand counters and logging.
* Understand `accept`, `drop`, and `reject`.
* Understand firewall rule ordering.
* Use nftables rule handles.
* Distinguish runtime and persistent firewall configuration.
* Understand nftables systemd persistence.
* Investigate network services from a SOC perspective.
* Correlate ports, processes, users, executables, services, and configuration.
* Perform a basic network-service risk assessment.

---

# Final Takeaway

The biggest lesson from Module 07 was:

> **Don't investigate a network problem or suspicious service from only one layer. Follow the evidence from the network interface all the way to the process and configuration responsible for the activity.**

When investigating an unexpected network service, I should ask:

```text
What interface is involved?
        ↓
What IP address?
        ↓
What route?
        ↓
What destination?
        ↓
What port?
        ↓
What process owns it?
        ↓
Which user runs it?
        ↓
What executable is running?
        ↓
How was it launched?
        ↓
What configuration controls it?
        ↓
Is it expected?
        ↓
Is there evidence of malicious behavior?
```

This gives me a practical foundation for **Linux network administration, network troubleshooting, and SOC-focused network investigation**.

---

## Module Progress

```text
Module 01 → File & Metadata Investigation       ✅
Module 02 → Evidence Handling & File Operations  ✅
Module 03 → Linux Permissions & ACLs             ✅
Module 04 → Linux User Management                ✅
Module 05 → Process Management                   ✅
Module 06 → Services & Persistence               ✅
Module 07 → Networking & Network Administration  ✅
```

**Next: Module 08 — Linux Logs & Log Investigation.**
