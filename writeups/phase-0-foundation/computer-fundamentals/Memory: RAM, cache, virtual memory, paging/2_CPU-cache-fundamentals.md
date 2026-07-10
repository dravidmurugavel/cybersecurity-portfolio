
# CPU Cache Fundamentals (L1, L2 & L3)

**Job-Role Tag:** Malware Analyst / Reverse Engineer / Hardware Security Researcher

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Memory

**Date:** 2026-07-10

---

# Objective

Understand why CPU caches exist, how the L1, L2, and L3 cache hierarchy improves execution speed, and why CPU caches have become both a performance optimization and a security consideration.

---

# Why This Matters

Modern CPUs execute billions of instructions every second.

Although RAM is significantly faster than an SSD, it is still much slower than the CPU itself. If the processor had to wait for RAM every time it needed an instruction or data, a large portion of CPU time would be wasted.

CPU caches solve this performance gap by storing frequently accessed instructions and data close to the processor.

For cybersecurity professionals, understanding cache behavior is essential because several hardware vulnerabilities—including Spectre—exploit cache timing rather than software bugs.

---

# Key Concepts

## What is CPU Cache?

A CPU cache is a small, extremely fast memory located on or very close to the processor.

Its purpose is to temporarily store frequently accessed instructions and data so the CPU can retrieve them much faster than reading directly from RAM.

The CPU always attempts to retrieve data from cache before accessing RAM.

---

## Cache Hierarchy

Modern processors typically implement three cache levels:

```text id="3f9aqr"
L1 Cache
Smallest
Fastest
Private to each CPU core

↓

L2 Cache
Larger
Slightly slower
Usually private to each core

↓

L3 Cache
Largest cache
Shared among CPU cores

↓

RAM
Much larger
Much slower
```

As cache size increases, access speed decreases.

---

## Cache Lookup Order

When the CPU requires instructions or data, it follows this sequence:

```text id="9j4mte"
L1 Cache
     ↓
L2 Cache
     ↓
L3 Cache
     ↓
RAM
```

The CPU stops searching as soon as the required information is found.

---

## Why Not Use RAM Directly?

RAM provides far more capacity than cache but has higher latency.

Instead of repeatedly fetching the same instructions from RAM, the CPU keeps frequently used instructions and data inside cache, significantly reducing execution time.

---

# Hands-on Lab

## Commands Used

Display CPU information:

```bash id="fj7s0x"
lscpu
```

---

## Observed Output

System information:

```text id="2mw7dn"
CPU Cores: 4
```

Cache sizes reported:

```text id="igpl6b"
L1 Data Cache: 192 KB

L1 Instruction Cache: 256 KB

L2 Cache: 8 MB

L3 Cache: 36 MB
```

The lab demonstrated that each successive cache level provides greater storage capacity at the cost of increased access time.

---

# Real Incident

## Spectre (2018)

Spectre demonstrated that hardware performance optimizations can unintentionally expose sensitive information.

### Attack

Spectre manipulated speculative execution so that secret data influenced which cache lines were loaded.

Although the speculative execution path was discarded, the altered cache state remained.

Attackers then measured cache access times to infer sensitive information such as passwords and cryptographic keys.

### Defense

Mitigations included:

* CPU microcode updates
* Operating system patches
* Compiler-based protections
* Software techniques that reduce cache timing leakage

---

# My Learning Journey

Initially, I understood that caches existed to reduce the time required to transfer data from RAM to the CPU.

During the exercises, I refined this understanding by recognizing that caches do not store entire programs. Instead, they temporarily store frequently accessed instructions and data from running programs.

I also learned that cache behavior is not only a performance feature but can also become a source of information leakage through timing side channels.

---

# What I Got Wrong First

## Initial Misconception

I initially believed that the CPU stored registers inside the cache.

## Correct Understanding

Registers and cache serve different purposes.

The CPU loads frequently accessed instructions and data into cache.

When execution occurs, the required values are loaded from cache (or RAM if necessary) into CPU registers.

The execution path is therefore:

```text id="m0x74a"
RAM

↓

CPU Cache

↓

Registers

↓

CPU Executes Instructions
```

Registers are part of the CPU itself and are not stored inside the cache.

---

# Core Takeaway

CPU caches bridge the speed gap between RAM and the processor.

By storing frequently accessed instructions and data close to the CPU, caches dramatically improve execution speed.

However, because cache state can reveal information through timing differences, hardware optimizations themselves can become attack surfaces.

---

# Interview Practice

## Question

Why does a CPU maintain L1, L2, and L3 caches instead of reading directly from RAM?

---

## My Answer

Because RAM is significantly slower than the CPU. The processor stores frequently accessed instructions and data in L1, L2, and L3 caches so they can be accessed much faster than repeatedly reading from RAM.

---

## Feedback

### Strengths

* Correctly identified the performance gap between CPU and RAM.
* Explained the purpose of cache in improving execution speed.
* Connected cache behavior to real-world processor operation.

### Improvement

Remember that cache stores frequently used instructions and data—not entire programs or CPU registers.

---

# Skills Demonstrated

* Understanding cache hierarchy
* Interpreting `lscpu` output
* Explaining CPU memory hierarchy
* Understanding cache latency
* Relating cache behavior to hardware security

---

# Commands Used

```bash id="p5w9rc"
lscpu
```

---

# Related Resources

* Intel® 64 and IA-32 Architectures Software Developer's Manual (Volume 3)
* Spectre Attack Whitepaper (Kocher et al., 2018)
* *Computer Systems: A Programmer's Perspective* — Bryant & O'Hallaron
* Linux `lscpu` Manual

---

# Summary

CPU caches are high-speed memory layers that reduce the latency between RAM and the processor. The CPU checks L1, L2, and L3 caches before accessing RAM, allowing frequently used instructions and data to be retrieved much more quickly. While this design greatly improves performance, research such as Spectre demonstrated that cache behavior can unintentionally leak sensitive information, making cache architecture an important topic in both computer performance and cybersecurity.
