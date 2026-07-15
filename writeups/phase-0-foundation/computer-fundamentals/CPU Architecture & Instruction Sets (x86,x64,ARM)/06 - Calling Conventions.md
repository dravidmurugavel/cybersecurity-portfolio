# 06 - Calling Conventions

> **Module:** Computer Fundamentals
> **Topic:** CPU Architecture & Instruction Sets (x86/x64/ARM)
> **Subtopic:** Calling Conventions

---

# Introduction

Programs are made up of hundreds or even thousands of functions. For these functions to communicate correctly, they must follow a common set of rules for passing arguments, returning values, and managing the stack. These rules are known as **calling conventions**.

During this module, I realized that understanding calling conventions makes assembly much easier to read. Instead of seeing random register values, I can identify function arguments, return values, and understand exactly what a program is attempting to do.

---

# Why This Matters in Cybersecurity

Calling conventions are one of the first things malware analysts rely on during reverse engineering.

By understanding them, I can quickly determine:

* Which function is being called.
* What data is passed to the function.
* Which register stores the return value.
* Whether the function succeeded or failed.
* What the malware is trying to access or manipulate.

Rather than reading hundreds of instructions, calling conventions allow me to understand a function call within seconds.

---

# What is a Calling Convention?

A **calling convention** is a standard set of rules that defines how functions communicate with one another.

It specifies:

* Where function arguments are placed.
* Where the return value is stored.
* Which registers may be modified.
* How the stack is managed.

Because every compiled program follows these rules, debuggers and reverse engineers can accurately interpret function calls.

---

# System V AMD64 Calling Convention

Most 64-bit Linux programs use the **System V AMD64 ABI**.

The first six function arguments are passed using registers.

| Argument | Register |
| -------- | -------- |
| 1st      | RDI      |
| 2nd      | RSI      |
| 3rd      | RDX      |
| 4th      | RCX      |
| 5th      | R8       |
| 6th      | R9       |

Additional arguments are passed on the stack.

The function's return value is stored in:

```text id="5t5t5q"
RAX
```

This convention appears frequently during malware analysis on Linux systems.

---

# Example Function Call

Consider the C code:

```c
fopen("secret.txt","r");
```

Before the function executes, the registers contain:

```text id="1c4ibz"
RDI → "secret.txt"

RSI → "r"
```

Then:

```asm
call fopen
```

After the function returns:

```text id="n8n97x"
RAX → FILE*
```

If opening the file failed:

```text id="gy8s7x"
RAX = NULL
```

Immediately after the call, many programs execute:

```asm
test rax, rax
je failed
```

to determine whether the operation succeeded.

---

# Practical Lab

Open GDB:

```bash id="ybzdl6"
gdb sample
```

Place a breakpoint before a function call.

Display registers:

```gdb
info registers
```

Suppose:

```text id="icdcqg"
RDI → "/etc/shadow"

RSI → "r"
```

The next instruction is:

```asm
call fopen
```

Without examining the source code, I already know the program is attempting to open:

```text
/etc/shadow
```

in read mode.

This demonstrates how calling conventions simplify reverse engineering.

---

# Return Values

Most functions return a value indicating success or failure.

In the System V AMD64 ABI, this value is stored in:

```text id="xjlwmm"
RAX
```

Example:

```asm
call fopen
```

After execution:

```text id="sl30jy"
RAX → File Handle
```

or

```text id="09jlwm"
RAX → NULL
```

Checking RAX immediately after a function call often reveals whether the operation succeeded.

---

# Cybersecurity Perspective

Suppose malware executes:

```asm
mov rdi, filename
mov rsi, "rb"
call fopen
```

Before stepping into the function, I can already determine:

Function:

```text id="vqnnfg"
fopen()
```

Argument 1:

```text id="sl3j9k"
filename
```

Argument 2:

```text id="1vlqkt"
"rb"
```

Immediately after:

```asm
call fopen
```

I inspect:

```text id="tz3eym"
RAX
```

If:

```text id="8m2z3n"
RAX = NULL
```

the file failed to open.

Otherwise, the malware continues processing the file.

Using calling conventions dramatically reduces the amount of assembly I need to read.

---

# Real-World Example

During this module, we analyzed a function similar to:

```asm
mov rdi, "/home/user/.ssh/id_rsa"
mov rsi, "r"
call fopen

test rax, rax
je failed

mov rdi, rax
call read
```

From only a few instructions, I could infer:

* The malware attempts to open the user's private SSH key.
* RDI contains the file path.
* RSI specifies read mode.
* RAX stores the returned file handle.
* If the operation succeeds, the file is immediately read.

Understanding the calling convention allowed me to interpret the malware's behavior without needing the original source code.

---

# Common Misconceptions

### "Registers Always Mean the Same Thing"

Incorrect.

Their meaning depends on the calling convention and the point in execution.

For example, RDI usually contains the first argument only **before** a function call.

---

### "Arguments Are Always Stored on the Stack"

Incorrect.

On 64-bit Linux, the first six arguments are stored in registers.

The stack is used only when additional arguments are required.

---

### "RAX Always Stores Arithmetic Results"

Incorrect.

Although RAX often stores arithmetic results, it also stores return values from function calls.

---

# Security Mental Model

```text id="klyzwk"
Prepare Arguments
        │
        ▼
RDI
RSI
RDX
RCX
R8
R9
        │
        ▼
call Function
        │
        ▼
Function Executes
        │
        ▼
Return Value
        │
        ▼
RAX
        │
        ▼
Program Continues
```

Whenever I encounter a function call during reverse engineering, I first inspect the argument registers and then examine RAX after the function returns.

---

# Key Takeaways

* Calling conventions define how functions communicate.
* Linux x86-64 commonly uses the System V AMD64 ABI.
* The first six function arguments are passed through registers.
* RAX stores the return value.
* Understanding calling conventions makes assembly easier to interpret.
* Calling conventions are essential for reverse engineering, malware analysis, and debugging.

---

# Portfolio Reflection

Learning calling conventions transformed how I analyze assembly code. Instead of viewing function calls as isolated instructions, I now understand how arguments move through registers and how return values indicate success or failure. This allows me to quickly reconstruct a program's behavior by examining only a few instructions around a function call. Calling conventions have become one of my most valuable tools for malware analysis and reverse engineering because they provide immediate context without requiring access to the original source code.
