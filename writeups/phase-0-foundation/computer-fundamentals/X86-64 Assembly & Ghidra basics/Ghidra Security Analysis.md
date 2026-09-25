# Ghidra Security Analysis â€” Stack-Based Buffer Overflow

## Overview

In this exercise I used **Ghidra for static analysis** and **GDB for runtime verification**.

The objective was to analyze a small compiled program, trace an external input through the program, identify an unsafe memory operation, and then verify the relevant stack layout while the program was running.

The focus was on understanding and documenting the vulnerability, not exploiting it.

---

## 1. Training Program

The important function in the training program was:

```c
void process(char *input) {
    char buffer[8];
    strcpy(buffer, input);
    printf("%s\n", buffer);
}
```

The key lines are:

```c
char buffer[8];
strcpy(buffer, input);
```

The destination is an 8-byte stack buffer.

The source is the function parameter `input`.

The copy operation is performed by `strcpy()`.

---

## 2. First Finding in Ghidra

When I opened the binary in Ghidra and examined the `process()` function in the Decompiler, I could see:

```c
void process(char *input)
{
    char buffer[8];
    strcpy(buffer, input);
    printf("%s\n", buffer);
}
```

The important relationship was:

```text
Source      â†’ input
Operation   â†’ strcpy()
Destination â†’ buffer[8]
```

This immediately raised a memory-safety concern.

`strcpy()` does not receive the size of the destination buffer. It continues copying until the source string reaches its terminating null byte.

Therefore, if the source string is larger than the available destination space, the copy can continue past the end of `buffer`.

The security finding is a:

> **Potential stack-based buffer overflow.**

---

## 3. Tracing Where the Input Comes From

I did not assume that `input` was attacker-controlled just because it was a function parameter.

I traced the caller.

The program contains:

```c
int main(int argc, char *argv[]) {
    if (argc > 1)
        process(argv[1]);

    return 0;
}
```

This means the first command-line argument is passed into `process()`.

The resulting data-flow chain is:

```text
Command-line input
       â†“
     argv[1]
       â†“
 process(input)
       â†“
strcpy(buffer, input)
       â†“
   buffer[8]
```

This was an important part of the analysis.

The vulnerability is stronger when I can show not only that a dangerous function exists, but also where its input originates.

---

## 4. Understanding `argv[1]` in Assembly

In Ghidra's Listing, I followed the instructions that retrieve `argv[1]` before the call to `process()`.

Conceptually, the flow is:

```text
argv
 â†“
argv + 0x8
 â†“
argv[1]
 â†“
function argument
 â†“
process()
```

On a 64-bit system, each pointer occupies 8 bytes, which explains the `0x8` pointer offset used to reach the second element of the `argv` array.

The exact register names shown by Ghidra can sometimes be affected by its variable-label representation, so I used the underlying instruction behavior and the x86-64 calling convention rather than blindly trusting a variable label.

For the Linux System V AMD64 calling convention, the first pointer argument is passed in:

```text
RDI
```

Therefore, conceptually:

```text
argv[1] â†’ RDI â†’ process(input)
```

---

## 5. Understanding the `strcpy()` Call

Inside `process()`, I followed the instructions associated with the `strcpy()` call.

The important calling-convention relationship is:

```text
RDI â†’ destination â†’ buffer
RSI â†’ source      â†’ input
```

Therefore:

```c
strcpy(buffer, input);
```

can be understood at the assembly level as:

```text
buffer address â†’ RDI
input address  â†’ RSI
        â†“
     strcpy()
```

This allowed me to connect the high-level C code with the low-level function-call mechanism.

---

## 6. Why `strcpy()` Is Dangerous Here

The problem is not simply that `strcpy()` is an old or dangerous function.

The actual issue is the combination of:

```text
Fixed-size destination
+
Unbounded string copy
+
Input whose length is not restricted by the destination
```

Here:

```text
Destination size = 8 bytes
Copy operation   = strcpy()
Input source     = argv[1]
```

If the supplied input is larger than the destination can hold, `strcpy()` can write beyond the boundary of `buffer`.

That creates the potential for memory corruption.

---

## 7. Runtime Verification with GDB

After identifying the issue statically, I used GDB to inspect the function while it was executing.

I stopped inside `process()` and ran:

```gdb
info registers rbp rsp
```

The runtime values were:

```text
RBP = 0x7fffffffdf20
RSP = 0x7fffffffdf00
```

I then checked the address of the local buffer:

```gdb
p &buffer
```

The result was:

```text
0x7fffffffdf18
```

I also checked its size:

```gdb
p sizeof(buffer)
```

The result was:

```text
8
```

So the important runtime information was:

```text
RBP    = 0x7fffffffdf20
RSP    = 0x7fffffffdf00
buffer = 0x7fffffffdf18
size   = 8 bytes
```

---

## 8. Calculating the Buffer's Position

I calculated the distance between `RBP` and the beginning of `buffer`:

```text
0x7fffffffdf20
-0x7fffffffdf18
----------------
0x8
```

Therefore:

```text
buffer = RBP - 0x8
```

This gave me direct runtime evidence of where the local buffer sits relative to the frame pointer.

---

## 9. Inspecting the Stack

I then examined memory around the stack frame:

```gdb
x/4gx $rbp-0x10
```

The relevant output included:

```text
0x7fffffffdf20:  0x00007fffffffdf40  0x000055555555519f
```

Using the normal stack-frame interpretation:

```text
[RBP]     â†’ saved RBP
[RBP+8]   â†’ return address
```

The runtime relationship was therefore:

```text
RBP-0x8  â†’ buffer[8]
RBP      â†’ saved RBP
RBP+0x8  â†’ return address
```

This was the most important runtime evidence in the exercise.

---

## 10. Why the Stack Layout Matters

The stack layout can be visualized as:

```text
Higher memory addresses

+---------------------------+
| Return address [RBP+8]    |
+---------------------------+
| Saved RBP [RBP]           |
+---------------------------+
| buffer[8] [RBP-0x8]       |
+---------------------------+

Lower memory addresses
```

This means that a write extending beyond the local buffer can reach adjacent stack memory.

The exact layout is not universal. Compiler options, optimization, architecture details, and security mitigations can change the arrangement.

The important concept is that the local buffer and control-related stack data are part of the same stack frame.

---

## 11. Connection to `ret` and `RIP`

This is where the x86-64 assembly knowledge became important.

A function eventually returns using:

```asm
ret
```

Conceptually, `ret` obtains the return address from the stack and places it into `RIP`.

The security chain is therefore:

```text
Oversized input
      â†“
strcpy()
      â†“
Write beyond buffer
      â†“
Possible stack corruption
      â†“
Possible corruption of saved return address
      â†“
ret
      â†“
RIP receives the corrupted value
      â†“
Unexpected control flow or crash
```

The important distinction is:

**The memory corruption occurs during the write.**

The potential control-flow consequence occurs later when the corrupted control data is used.

---

## 12. Static Analysis vs Runtime Analysis

This exercise showed me why using both Ghidra and GDB is valuable.

### Ghidra answered:

- What functions exist?
- What does `process()` do?
- Where does the input originate?
- Which function receives the input?
- Which operation copies the data?
- What is the apparent destination?

### GDB answered:

- Where is the function executing?
- What are the actual `RBP` and `RSP` values?
- Where is `buffer` located in memory?
- How large is the buffer?
- What data exists around the stack frame?

The combined workflow was:

```text
Ghidra
Static analysis
     â†“
Identify suspicious data flow
     â†“
Form security hypothesis
     â†“
GDB
Runtime verification
     â†“
Confirm relevant memory layout
```

---

## 13. Final Security Finding

### Potential Stack-Based Buffer Overflow

**Root Cause**

The program copies a command-line argument into a fixed-size stack buffer using `strcpy()`, which does not enforce the destination buffer's size.

**Source**

```text
argv[1]
```

**Destination**

```text
buffer[8]
```

**Dangerous operation**

```c
strcpy(buffer, input);
```

**Data flow**

```text
argv[1]
   â†“
process(input)
   â†“
strcpy(buffer, input)
   â†“
buffer[8]
```

**Potential Impact**

If sufficiently large input is supplied, the copy may write beyond the boundaries of the destination buffer and corrupt adjacent stack memory.

Depending on the actual binary, compiler settings, and enabled mitigations, consequences can include:

- Program crash
- Memory corruption
- Unexpected behavior
- Potential unintended control flow

This analysis does not assume exploitability. Exploitability would require additional analysis of the compiled binary, protections, memory layout, and runtime behavior.

---

## 14. What I Learned

The biggest lesson from this exercise was that finding a vulnerable function is only the beginning.

Instead of stopping at:

> "`strcpy()` is dangerous."

I learned to ask:

1. Where does the input originate?
2. How does the input reach the function?
3. What function processes it?
4. What is the destination?
5. How large is the destination?
6. Where is the destination located in memory?
7. What data exists next to it?
8. What could happen if the boundary is exceeded?

That gives me a repeatable method for analyzing unfamiliar binaries.

---

## 15. Screenshots / Evidence

The most useful screenshots for this write-up are the ones that support the security conclusion.

### Screenshot 1 â€” Ghidra Decompiler: `process()`

Show:

```c
char buffer[8];
strcpy(buffer, input);
```

**Purpose:** Demonstrates the vulnerable source-level data flow.

### Screenshot 2 â€” Ghidra Listing: `process()`

Show the instructions surrounding the `strcpy()` call and argument preparation.

**Purpose:** Demonstrates the assembly-level function-call analysis.

### Screenshot 3 â€” Ghidra Listing: `main()`

Show the code that obtains `argv[1]` and passes it to `process()`.

**Purpose:** Demonstrates the external input source.

### Screenshot 4 â€” GDB Runtime Stack

Show the relevant commands/output for:

```gdb
info registers rbp rsp
p &buffer
p sizeof(buffer)
x/4gx $rbp-0x10
```

**Purpose:** Provides runtime evidence for the stack layout.

---

## Security Analysis Mental Model

The reusable pattern from this exercise is:

```text
Input Source
     â†“
Data Flow
     â†“
Function Argument
     â†“
Sensitive Operation
     â†“
Memory Destination
     â†“
Boundary
     â†“
Potential Memory Corruption
     â†“
Security Impact
```

This is the analysis approach I can reuse when examining binaries in Ghidra.

---

## Conclusion

This exercise connected the high-level source code, Ghidra's static analysis, x86-64 calling conventions, and GDB's runtime memory inspection.

I was able to trace a command-line argument from:

```text
argv[1]
```

through:

```text
process(input)
```

to:

```text
strcpy(buffer, input)
```

and then verify the stack layout at runtime.

The exercise helped turn assembly and reverse-engineering concepts into a practical vulnerability-analysis workflow rather than treating Ghidra and GDB as tools to operate without understanding what the results mean.
