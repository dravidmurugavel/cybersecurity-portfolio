
# Stack vs Heap Memory

**Job-Role Tag:** Reverse Engineer / Malware Analyst / Exploit Developer / DFIR Analyst

**Skill Category:** Computer Fundamentals

**Phase:** Computer Fundamentals → Memory

**Date:** 2026-07-10

---

# Objective

Understand the difference between stack and heap memory, how each is managed, what type of data they store, and why this distinction is fundamental to software security, malware analysis, reverse engineering, and exploit development.

---

# Why This Matters

Every running program stores data in memory, but not all data belongs in the same place.

Function calls, local variables, dynamically allocated objects, and buffers all have different lifetimes and purposes. The operating system provides separate memory regions to manage them efficiently.

Many of the most important software vulnerabilities—including stack buffer overflows, use-after-free, and heap corruption—are impossible to understand without first understanding the difference between the stack and the heap.

---

# Key Concepts

## What is the Stack?

The **stack** is a region of memory used for **temporary data** associated with function execution.

It is managed automatically as functions are called and return.

The stack commonly stores:

* Local variables
* Function parameters
* Return addresses
* Saved registers (depending on the calling convention)

When a function finishes, its stack space is automatically reclaimed.

---

## What is the Heap?

The **heap** is a region of memory used for **dynamic memory allocation**.

Unlike the stack, memory on the heap remains allocated until the program explicitly releases it.

Programs typically allocate heap memory using functions such as:

```c id="e1a8cq"
malloc()
calloc()
realloc()
free()
```

Typical heap data includes:

* Dynamic arrays
* Objects
* Buffers
* Large data structures

---

## Stack vs Heap

```text id="v7u2sx"
STACK
------
• Automatic allocation
• Temporary lifetime
• Function calls
• Local variables
• Return addresses

HEAP
-----
• Dynamic allocation
• Lifetime controlled by the program
• Large objects
• Dynamic buffers
```

The stack is optimized for fast allocation and cleanup, while the heap provides flexibility for data whose size or lifetime is not known in advance.

---

# Hands-on Lab

## Source Code

```c id="5k9rbm"
#include <stdio.h>
#include <stdlib.h>

void demo() {
    int stack_var = 10;
    int *heap_var = malloc(sizeof(int));

    *heap_var = 20;

    printf("Stack variable: %p\n", (void *)&stack_var);
    printf("Heap variable : %p\n", (void *)heap_var);

    free(heap_var);
}

int main() {
    demo();
    return 0;
}
```

---

## Compile

```bash id="i0p7ld"
gcc stack_heap.c -o stack_heap
```

---

## Run

```bash id="7b3mqa"
./stack_heap
```

---

## Observed Output

Example addresses:

```text id="i4kqny"
Stack Variable:
0x7ffc1045eca4

Heap Variable:
0x5644f51c6310
```

Observation:

* The stack and heap occupy different regions of a process's virtual memory.
* Their addresses differ because they serve different purposes and are managed independently.

Due to ASLR (Address Space Layout Randomization), these addresses change between executions.

---

# Real Incident

## Morris Worm (1988)

The Morris Worm exploited a **stack buffer overflow** in the Unix `fingerd` service.

### Attack

The vulnerable program accepted more input than a stack buffer could hold.

The excess data overflowed the buffer and overwrote adjacent memory, including the function's **return address**.

When the function executed the `ret` instruction, the CPU jumped to an attacker-controlled address, allowing arbitrary code execution.

### Defense

Modern operating systems reduce the risk of stack-based attacks using:

* Stack Canaries
* ASLR (Address Space Layout Randomization)
* NX/DEP (Non-Executable Memory)

---

# My Learning Journey

Initially, I viewed the stack simply as temporary memory and the heap as long-term storage.

During the exercises, I learned that the key difference is **how their lifetime is managed**.

The stack is used automatically during function execution, while heap memory exists only as long as the program explicitly chooses to keep it allocated.

Understanding this distinction also clarified why classic buffer overflow attacks target stack memory.

---

# What I Got Wrong First

## Initial Misconception

I initially believed that the CPU automatically created variables on the stack.

## Correct Understanding

The operating system provides the stack region for each process, while the compiled program uses machine instructions that manipulate the stack during function calls.

The CPU simply executes those instructions.

The heap is different because the program explicitly requests and releases memory through allocation functions such as `malloc()` and `free()`.

---

# Core Takeaway

The stack and heap are separate memory regions designed for different purposes.

The stack automatically manages temporary function-related data, while the heap stores dynamically allocated data whose lifetime is controlled by the program.

Understanding this distinction forms the foundation for memory safety, secure software development, reverse engineering, and exploit development.

---

# Interview Practice

## Question

Why are stack buffer overflows considered dangerous?

---

## My Answer

If an attacker writes more data than a stack buffer can hold, the excess data may overwrite the function's return address. When the function returns, the CPU uses the overwritten return address, allowing execution to jump to an attacker-controlled location.

---

## Feedback

### Strengths

* Correctly identified the role of the return address.
* Connected memory corruption to changes in program control flow.
* Related the concept to a real-world vulnerability.

### Improvement

Remember that the overflow changes the program's control flow by corrupting adjacent stack memory—it is not related to the stack's memory address range or privilege level.

---

# Skills Demonstrated

* Understanding stack and heap memory
* Writing and compiling simple C programs
* Observing process memory layout
* Using `malloc()` and `free()`
* Explaining stack buffer overflows
* Connecting memory layout to software exploitation

---

# Commands Used

```bash id="u9d5jw"
gcc stack_heap.c -o stack_heap

./stack_heap
```

---

# Related Resources

* *Practical Malware Analysis* — Michael Sikorski & Andrew Honig
* *The Shellcoder's Handbook* — Chris Anley et al.
* *Hacking: The Art of Exploitation* — Jon Erickson
* Linux `malloc(3)` and `free(3)` Manual Pages

---

# Summary

The stack and heap are two fundamental memory regions used by every running program. The stack automatically manages temporary data such as local variables, function parameters, and return addresses, while the heap stores dynamically allocated objects whose lifetime is controlled by the program. Understanding how these regions work is essential for analyzing software behavior, investigating memory corruption, and understanding vulnerabilities such as stack buffer overflows that have shaped modern cybersecurity.
