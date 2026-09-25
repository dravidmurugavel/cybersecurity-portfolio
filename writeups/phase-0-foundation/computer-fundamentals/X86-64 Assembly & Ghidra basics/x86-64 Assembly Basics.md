# x86-64 Assembly Basics â€” Security-Focused Learning

## Overview

I studied x86-64 assembly as part of my cybersecurity foundation, with a specific goal: understand what is happening underneath a program when I debug, reverse engineer, or investigate a memory-corruption issue.

I did not try to memorize the entire x86-64 instruction set. Instead, I focused on the instructions, registers, stack behavior, and calling convention that are useful during security analysis.

---

## What I Learned

### 1. x86-64 Architecture

My lab environment uses the x86-64 architecture. Understanding the architecture gives me the foundation needed to read disassembly and understand debugger output.

The most important concepts for my work were:

- 64-bit registers
- Memory addressing
- Little-endian byte order
- Stack-based function execution
- Instruction pointer
- Calling conventions

The main security reason for learning this is simple: tools such as GDB and Ghidra show low-level information, and I need to understand what that information represents instead of treating it as random hexadecimal and assembly.

---

## 2. Important Registers

The registers I focused on were:

| Register | Purpose |
|---|---|
| `RAX` | General-purpose register; commonly used for return values |
| `RDI` | First integer/pointer function argument |
| `RSI` | Second integer/pointer function argument |
| `RDX` | Third integer/pointer function argument |
| `RCX` | Fourth integer/pointer function argument |
| `R8` | Fifth integer/pointer function argument |
| `R9` | Sixth integer/pointer function argument |
| `RBP` | Common frame-pointer reference |
| `RSP` | Stack pointer |
| `RIP` | Instruction pointer |

### RIP

`RIP` tells me where the CPU is executing.

During GDB practice, I used:

```gdb
info registers rip
```

This helped me connect an instruction shown by the debugger with the actual execution location.

### RSP

`RSP` points to the current top of the stack.

### RBP

When frame pointers are preserved, `RBP` provides a stable reference for a function's stack frame.

This became especially useful when examining local variables and the saved return information around a stack frame.

---

## 3. Hexadecimal and Memory Addresses

Assembly and debugger output frequently use hexadecimal.

Some basic relationships I practiced were:

```text
1 hex digit = 4 bits
2 hex digits = 1 byte
```

For example:

```text
0x2A = 42 decimal
```

Memory addresses are also normally displayed in hexadecimal, such as:

```text
0x7fffffffdf20
```

Being comfortable with hexadecimal made it much easier to calculate offsets between registers, buffers, and other stack locations.

---

## 4. Little-Endian Memory

x86-64 systems use little-endian byte order.

For example, the multi-byte value:

```text
0x78563412
```

is represented in memory as:

```text
12 34 56 78
```

This matters when examining:

- Memory dumps
- Stack contents
- Binary files
- Hex editors
- Debugger output

Understanding byte order is particularly useful when interpreting raw memory during reverse engineering.

---

## 5. `mov`

`mov` transfers data between registers, memory, and immediate values.

For example:

```asm
mov %rsp, %rbp
```

can be understood as:

```text
RBP = RSP
```

During GDB practice I examined an instruction that stored the value `42` relative to `RBP`:

```asm
movl $0x2a,-0x4(%rbp)
```

I then examined that memory location in GDB and verified that the value had actually been written.

This was an important lesson: I was not just reading assembly syntax; I was connecting an instruction to a real change in memory.

---

## 6. `lea`

`lea` means **Load Effective Address**.

It calculates an address rather than loading the value stored at that address.

For example:

```asm
lea -0x8(%rbp), %rax
```

can be understood conceptually as:

```text
RAX = address of RBP - 0x8
```

This is commonly encountered when compiled code needs the address of a local variable or buffer.

---

## 7. Stack Frames

A function commonly creates a stack frame when it starts.

A typical prologue looks like:

```asm
push %rbp
mov  %rsp,%rbp
sub  $0x10,%rsp
```

Conceptually:

1. Save the previous frame pointer.
2. Establish the current frame reference.
3. Reserve stack space for local data.

On x86-64, the stack grows toward lower memory addresses.

The exact layout can vary depending on the compiler, optimization settings, and other protections, so I learned not to assume that every program will have an identical frame.

---

## 8. `push` and `pop`

`push` places data on the stack.

Conceptually:

```text
RSP decreases
value is written to [RSP]
```

`pop` removes a value:

```text
value is read from [RSP]
RSP increases
```

These instructions are important when understanding saved registers and function frames.

---

## 9. `call` and `ret`

### `call`

A `call` transfers execution to another function while saving information needed to return afterward.

Conceptually:

```text
save return address
jump to function
```

### `ret`

`ret` returns from a function.

Conceptually, it uses the value at the top of the stack as the return address and loads it into `RIP`.

This relationship is particularly important for understanding stack corruption:

```text
saved return address
        â†“
       ret
        â†“
       RIP
```

If the saved return address has been corrupted, `ret` can load the corrupted value into `RIP`, potentially causing unintended control flow or a crash.

---

## 10. `cmp`, Flags, and Conditional Jumps

`cmp` compares values by updating CPU flags.

Important flags include:

- `ZF` â€” Zero Flag
- `SF` â€” Sign Flag
- `CF` â€” Carry Flag
- `OF` â€” Overflow Flag

Conditional jumps then use these flags.

Examples:

```asm
je
jne
jg
jl
jge
jle
ja
jb
```

I also learned that signed and unsigned comparisons use different conditional jumps. That distinction matters when interpreting compiled code.

`jmp` is an unconditional jump and changes control flow without checking a condition.

---

## 11. Linux x86-64 Calling Convention

For Linux programs using the System V AMD64 calling convention, integer and pointer arguments are passed through registers.

The first six are:

```text
1st â†’ RDI
2nd â†’ RSI
3rd â†’ RDX
4th â†’ RCX
5th â†’ R8
6th â†’ R9
```

Return values are normally placed in:

```text
RAX
```

This became very useful when reading function calls in Ghidra.

For example:

```c
strcpy(buffer, input);
```

Conceptually:

```text
RDI â†’ buffer   (destination)
RSI â†’ input    (source)
```

Knowing this allowed me to trace data between functions instead of relying only on the decompiler's labels.

---

## 12. GDB Practice

I used GDB to connect assembly instructions with runtime state.

Commands I practiced included:

```gdb
start
info registers rip rsp rbp
x/i $rip
x/wx ADDRESS
x/12gx ADDRESS
p &buffer
p sizeof(buffer)
```

One useful exercise involved stopping inside a function, checking `RIP`, `RSP`, and `RBP`, stepping through an instruction, and examining the affected memory.

This helped establish the difference between:

```text
Static analysis â†’ what the binary contains
Runtime analysis â†’ what the program is actually doing
```

---

## 13. Stack Corruption and Security

The assembly concepts became much more useful when I connected them to a stack-based buffer overflow.

A local variable such as:

```c
char buffer[8];
```

can reside inside a function's stack frame.

If an unsafe operation writes more data than the buffer can hold, the write may continue into adjacent stack memory.

Conceptually:

```text
Higher addresses

+----------------------+
| Return address       |
+----------------------+
| Saved RBP             |
+----------------------+
| buffer[8]             |
+----------------------+

Lower addresses
```

The exact layout is compiler- and build-dependent.

The important security lesson is that a memory-safety error can corrupt data belonging to the surrounding stack frame.

---

## 14. What Assembly Added to My Security Skills

Learning x86-64 assembly gave me a much better mental model for:

- Reverse engineering
- GDB debugging
- Ghidra analysis
- Function calls
- Stack frames
- Memory addressing
- Control flow
- Calling conventions
- Memory corruption
- Understanding why a corrupted return address can affect `RIP`

The biggest improvement was moving from:

> "I see an assembly instruction."

to:

> "I can explain what this instruction changes and why that matters to security."

---

## Security Mental Model

When I read low-level code, I now try to follow this chain:

```text
Instruction
    â†“
Register / Memory operation
    â†“
CPU state
    â†“
Program control flow
    â†“
Security consequence
```

That mental model is more useful to me than trying to memorize every assembly instruction.

---

## Practical Evidence

The learning was supported by hands-on GDB and Ghidra exercises rather than theory alone.

The most useful evidence includes:

- GDB register inspection
- Stack memory inspection
- Local-variable address inspection
- Instruction-level stepping
- Ghidra decompiler analysis
- Ghidra assembly listing analysis
- Calling-convention tracing

---

## Conclusion

This exercise gave me the low-level foundation needed to understand what is happening inside a compiled program.

I can now read common x86-64 instructions, identify important registers, follow stack frames, understand function arguments, use GDB to inspect runtime state, and connect those observations to security problems such as memory corruption.

This is not intended to be a complete x86-64 assembly reference. It is a security-focused foundation that I can build on during reverse engineering, vulnerability analysis, and incident investigation.
