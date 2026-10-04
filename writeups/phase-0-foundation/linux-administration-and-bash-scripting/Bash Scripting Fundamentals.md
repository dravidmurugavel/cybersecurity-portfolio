# Module 11 — Bash Scripting Fundamentals

## Overview

Module 11 focused on learning Bash scripting from the ground up with a cybersecurity mindset.

The goal was not simply to memorize Linux commands. The goal was to understand how Bash scripts are structured, how data moves through a script, how decisions and loops work, how functions improve organization, how command-line interfaces are designed, how structured data is handled, and how scripts can be written safely and reliably.

The module was deliberately fundamentals-focused, but not rushed. The objective was to build enough Bash knowledge to independently write future cybersecurity automation scripts rather than simply copy existing examples.

The central idea was:

> **A Bash script is a sequence of commands organized with variables, input/output handling, conditions, loops, functions, data structures, and error handling to automate a task reliably.**

---

# Module Goals

The full original Module 11 scope contains **13 topics**:

1. Bash Script Structure
2. Variables & Environment Variables
3. Input & Output
4. Exit Status & Error Handling
5. Conditional Logic
6. Loops
7. Functions
8. Arguments & CLI Interfaces
9. Arrays & Data Handling
10. Text Processing
11. Bash Symbols & Syntax
12. Files, Commands & Safe Scripting
13. Script Debugging & Reliability

The module builds progressively:

```text
Bash basics
    ↓
Variables
    ↓
Input / Output
    ↓
Exit statuses
    ↓
Conditions
    ↓
Loops
    ↓
Functions
    ↓
CLI interfaces
    ↓
Arrays / Data
    ↓
Text processing
    ↓
Bash syntax
    ↓
Safe scripting
    ↓
Debugging & reliability
    ↓
Security automation foundation
```

---

# Topic 1 — Bash Script Structure

## 1.1 Shebang

A Bash script normally begins with:

```bash
#!/usr/bin/env bash
```

The shebang tells the operating system which interpreter should execute the script.

Using:

```bash
#!/usr/bin/env bash
```

allows the system to locate Bash through the environment.

---

## 1.2 Basic Script Structure

A simple script can look like:

```bash
#!/usr/bin/env bash

# Display the current user
echo "User: $USER"

# Display the home directory
echo "Home: $HOME"
```

Bash executes commands from top to bottom.

Mental model:

```text
Script starts
    ↓
Command 1
    ↓
Command 2
    ↓
Command 3
    ↓
Script ends
```

---

## 1.3 Comments

Comments begin with:

```bash
#
```

Example:

```bash
# Check whether the file exists
if [[ -f "$file" ]]; then
    echo "File exists"
fi
```

Comments should explain useful context, reasoning, or security decisions rather than simply repeating obvious code.

---

## 1.4 Creating and Executing Scripts

Create:

```bash
nano script.sh
```

Make executable:

```bash
chmod +x script.sh
```

Execute:

```bash
./script.sh
```

Or explicitly invoke Bash:

```bash
bash script.sh
```

The important distinction is that `./script.sh` requires executable permission, while `bash script.sh` explicitly asks Bash to interpret the file.

---

# Topic 2 — Variables & Environment Variables

## 2.1 Creating Variables

Bash assignment uses:

```bash
name="kali"
```

There must not be spaces around `=`.

Incorrect:

```bash
name = "kali"
```

Correct:

```bash
name="kali"
```

---

## 2.2 Variable Expansion

Use:

```bash
echo "$name"
```

Example:

```bash
username="kali"

echo "Current user: $username"
```

---

## 2.3 Environment Variables

Important environment variables include:

```bash
$USER
$HOME
$PATH
```

For example:

```bash
echo "$USER"
echo "$HOME"
echo "$PATH"
```

These provide information about the current execution environment.

Security scripts frequently need information about:

* The current user
* Home directories
* Executable search paths
* The current environment

---

## 2.4 Command Substitution

Command output can be stored:

```bash
current_user=$(whoami)
```

Then:

```bash
echo "$current_user"
```

Mental model:

```text
command
   ↓
output
   ↓
$(...)
   ↓
variable
```

---

## 2.5 Quoting Variables

Prefer:

```bash
echo "$filename"
```

rather than:

```bash
echo $filename
```

Quoting prevents unwanted word splitting and pathname expansion.

This became an important security scripting habit throughout the module.

---

# Topic 3 — Input & Output

Input and output were covered extensively because security automation depends heavily on controlling data flow.

---

## 3.1 `echo`

Basic output:

```bash
echo "Hello"
```

---

## 3.2 `printf`

`printf` provides controlled formatting:

```bash
printf "User: %s\n" "$USER"
```

Important placeholders:

```text
%s → string
%d → integer
%f → floating point
```

`%s` is particularly common in security scripting.

---

## 3.3 `read`

Read input:

```bash
read name
```

Prompt:

```bash
read -p "Enter username: " name
```

Silent input:

```bash
read -s password
```

Read a limited number of characters:

```bash
read -n 1 answer
```

`read -s` hides input while typing but does not make the stored value inherently secure. Sensitive information should not be unnecessarily logged.

---

# 3.4 Standard File Descriptors

Linux processes normally use:

```text
0 → stdin
1 → stdout
2 → stderr
```

Mental model:

```text
stdin  → input
stdout → normal output
stderr → errors / diagnostics
```

---

## 3.5 stdout vs stderr

Normal output:

```bash
ls /
```

Error output:

```bash
ls /does/not/exist
```

The distinction matters because scripts may need to:

* Save normal results.
* Keep errors separate.
* Redirect errors to another file.
* Log diagnostics independently.

---

## 3.6 Output Redirection

Overwrite:

```bash
command > output.txt
```

Append:

```bash
command >> output.txt
```

---

## 3.7 Error Redirection

Overwrite stderr:

```bash
command 2> errors.txt
```

Append stderr:

```bash
command 2>> errors.txt
```

---

## 3.8 Input Redirection

```bash
command < input.txt
```

---

## 3.9 Combining stdout and stderr

Redirect stderr to stdout:

```bash
command > output.txt 2>&1
```

Bash also supports:

```bash
command &> output.txt
```

The order of redirections matters.

`2>&1` means:

> Send stderr to wherever stdout is currently being sent.

---

## 3.10 Pipes

A pipe sends stdout from one command into stdin of another:

```bash
command1 | command2
```

Example:

```bash
ps aux | grep ssh
```

Mental model:

```text
Command A
   ↓ stdout
   ↓
Command B
   ↓
result
```

Pipelines are fundamental to Linux security automation.

---

## 3.11 `||`

`||` can execute a fallback when the previous command fails:

```bash
command || echo "Command failed"
```

It can also act as logical OR:

```bash
if [[ "$user" == "root" || "$user" == "admin" ]]; then
    echo "Privileged user"
fi
```

In `case`, `|` separates alternative patterns:

```bash
case "$answer" in
    y|Y)
        echo "Yes"
        ;;
esac
```

---

## 3.12 Here Documents

A here document supplies multiple lines of input:

```bash
cat <<EOF
Line one
Line two
Line three
EOF
```

An unquoted delimiter allows expansion:

```bash
name="kali"

cat <<EOF
User: $name
EOF
```

A quoted delimiter prevents expansion:

```bash
cat <<'EOF'
User: $name
EOF
```

---

## 3.13 Here Strings

A here string supplies a string as stdin:

```bash
grep "root" <<< "$line"
```

Mental model:

```text
string
  ↓
<<<
  ↓
stdin
  ↓
command
```

---

## 3.14 Process Substitution

Process substitution:

```bash
< <(command)
```

makes command output available as file-like input.

Example:

```bash
while IFS= read -r line
do
    echo "$line"
done < <(printf '%s\n' one two three)
```

---

## 3.15 Safe Line-by-Line File Processing

A standard pattern is:

```bash
while IFS= read -r line
do
    echo "$line"
done < file.txt
```

Important elements:

```text
IFS=
read -r
```

help preserve whitespace and backslashes.

This pattern is useful for:

* IOC lists
* Logs
* Configuration files
* User lists
* Security findings

---

## 3.16 `tee`

`tee` sends output to both the terminal and a file:

```bash
command | tee report.txt
```

Append:

```bash
command | tee -a report.txt
```

Mental model:

```text
command
   ↓
 tee
 ↙   ↘
screen file
```

---

## 3.17 File Descriptors

Standard descriptors:

```text
0 → stdin
1 → stdout
2 → stderr
```

Custom descriptors can also be created.

Example:

```bash
exec 3> audit.log
```

Write to FD 3:

```bash
printf "Audit started\n" >&3
```

Close it:

```bash
exec 3>&-
```

This allows scripts to maintain separate logging channels.

---

# Topic 4 — Exit Status & Error Handling

Every command returns an exit status.

```text
0       → success
non-zero → failure
```

---

## 4.1 `$?`

`$?` contains the previous command's exit status:

```bash
ls /does/not/exist
echo "$?"
```

The exact non-zero status depends on the command.

---

## 4.2 Capture Status Immediately

Because `$?` changes after another command:

```bash
command
status=$?
```

---

## 4.3 `&&`

Run the second command only if the first succeeds:

```bash
command1 && command2
```

---

## 4.4 `||`

Run the second command only if the first fails:

```bash
command1 || command2
```

---

## 4.5 `if` and Exit Status

Commands can directly act as conditions:

```bash
if command; then
    echo "Success"
else
    echo "Failure"
fi
```

---

## 4.6 `exit`

Success:

```bash
exit 0
```

Failure:

```bash
exit 1
```

Scripts can use different non-zero values to represent different error conditions.

---

## 4.7 `!`

`!` reverses an exit status:

```bash
if ! grep -q "malware" log.txt; then
    echo "No match"
fi
```

---

## 4.8 `set -e`

```bash
set -e
```

causes Bash to stop when an unhandled command failure occurs, subject to Bash's conditional-context behavior.

---

## 4.9 `set -u`

```bash
set -u
```

treats use of unset variables as errors.

---

## 4.10 `pipefail`

```bash
set -o pipefail
```

allows pipeline failures from earlier commands to propagate.

A common reliability combination is:

```bash
set -euo pipefail
```

These options improve reliability but do not replace deliberate error handling.

---

# Topic 5 — Conditional Logic

Conditional logic allows scripts to make decisions.

---

## 5.1 `[[ ]]`

Modern Bash scripts commonly use:

```bash
[[ condition ]]
```

Example:

```bash
if [[ -f "$file" ]]; then
    echo "File exists"
fi
```

---

## 5.2 `[ ]` and `test`

Traditional forms include:

```bash
[ condition ]
```

and:

```bash
test condition
```

For Bash-specific scripts, `[[ ]]` is generally preferred.

---

## 5.3 File Tests

Important tests:

```text
-e → exists
-f → regular file
-d → directory
-r → readable
-w → writable
-x → executable
-s → non-empty
```

Example:

```bash
if [[ -f "$file" && -r "$file" ]]; then
    echo "Readable regular file"
fi
```

---

## 5.4 String Tests

Equality:

```bash
[[ "$user" == "root" ]]
```

Inequality:

```bash
[[ "$user" != "root" ]]
```

Empty:

```bash
[[ -z "$value" ]]
```

Non-empty:

```bash
[[ -n "$value" ]]
```

---

## 5.5 Glob Patterns

Common glob patterns:

```text
*      → any number of characters
?      → one character
[...]  → character class
```

Example:

```bash
[[ "$file" == *.log ]]
```

Glob patterns are different from regular expressions.

---

## 5.6 Regular Expressions

Bash supports regex with:

```bash
=~
```

Example:

```bash
if [[ "$value" =~ ^error[0-9]+$ ]]; then
    echo "Valid error format"
fi
```

Important concepts:

```text
^       → beginning
$       → end
[0-9]   → digit
+       → one or more
```

---

## 5.7 `BASH_REMATCH`

Bash stores regex match information in:

```bash
BASH_REMATCH
```

This can be used to extract information from matches.

---

## 5.8 Numeric Comparisons

Operators:

```text
-eq → equal
-ne → not equal
-gt → greater than
-ge → greater than or equal
-lt → less than
-le → less than or equal
```

Arithmetic contexts are also useful:

```bash
if (( count > 5 )); then
    echo "More than five"
fi
```

---

## 5.9 Logical Operators

```text
&& → AND
|| → OR
!  → NOT
```

---

## 5.10 `if / elif / else`

Example:

```bash
if [[ "$severity" == "critical" ]]; then
    echo "Immediate attention"
elif [[ "$severity" == "high" ]]; then
    echo "High priority"
else
    echo "Lower priority"
fi
```

---

## 5.11 `case`

Example:

```bash
case "$mode" in
    basic)
        echo "Basic mode"
        ;;
    full)
        echo "Full mode"
        ;;
    *)
        echo "Invalid mode"
        ;;
esac
```

`case` is particularly useful for CLI parsing and fixed choices.

---

## 5.12 Security-Focused Conditions

Input validation:

```bash
if [[ "$severity" =~ ^(low|medium|high|critical)$ ]]; then
    echo "Valid severity"
fi
```

Configuration checks can combine multiple conditions:

```bash
if [[ -f "$config" && -r "$config" ]]; then
    echo "Configuration available"
fi
```

---

# Topic 6 — Loops

Loops allow Bash to process repeated data.

---

## 6.1 `for`

```bash
for item in one two three
do
    echo "$item"
done
```

---

## 6.2 Brace Expansion

```bash
for number in {1..5}
do
    echo "$number"
done
```

---

## 6.3 C-Style `for`

```bash
for ((i=0; i<10; i++))
do
    echo "$i"
done
```

Increment by different amounts:

```bash
for ((i=0; i<=20; i+=5))
do
    echo "$i"
done
```

---

## 6.4 `while`

```bash
count=0

while (( count < 5 ))
do
    echo "$count"
    ((count++))
done
```

---

## 6.5 `until`

```bash
count=0

until (( count >= 5 ))
do
    echo "$count"
    ((count++))
done
```

---

## 6.6 Arrays and Loops

```bash
files=("one" "two" "three")

for file in "${files[@]}"
do
    echo "$file"
done
```

---

## 6.7 Safe File Processing

```bash
while IFS= read -r line
do
    echo "$line"
done < file.txt
```

This preserves whitespace, backslashes, and empty lines more safely.

---

## 6.8 Command Output and Process Substitution

Avoid blindly using:

```bash
for item in $(command)
```

because word splitting can break data.

For line-oriented processing:

```bash
while IFS= read -r item
do
    ...
done < <(command)
```

is often safer.

---

## 6.9 Globbing and Quoting

Prefer:

```bash
"$file"
```

rather than:

```bash
$file
```

to prevent unexpected word splitting and pathname expansion.

---

## 6.10 Loop Control

`break` exits a loop:

```bash
break
```

`continue` skips the current iteration:

```bash
continue
```

---

## 6.11 Retry Loops

A retry loop should normally include:

* Maximum attempts
* Controlled delay
* Failure handling
* Clear termination

Mental model:

```text
attempt
   ↓
success? ── yes → continue
   │
   no
   ↓
wait
   ↓
retry
```

---

## 6.12 Timeouts

Commands can be constrained using:

```bash
timeout 5 command
```

This prevents an operation from waiting indefinitely.

---

## 6.13 Background Jobs

Run a command in the background:

```bash
command &
```

Capture its PID:

```bash
pid=$!
```

Wait for it:

```bash
wait "$pid"
```

These concepts provide the foundation for basic parallel security automation.

---

## 6.14 Security Automation Loops

Loops can process:

* IOC lists
* Logs
* Users
* Files
* Services
* Ports
* Processes
* Configuration entries

Example:

```bash
while IFS= read -r ioc
do
    [[ -z "$ioc" ]] && continue

    if grep -qF -- "$ioc" sample.log; then
        echo "[MATCH] $ioc"
    else
        echo "[OK] $ioc"
    fi
done < iocs.txt
```

---

# Topic 7 — Functions

Functions divide scripts into reusable components.

---

## 7.1 Function Fundamentals

```bash
check_file() {
    echo "Checking file"
}
```

Call:

```bash
check_file
```

Defining a function does not execute it.

Calling it does.

---

## 7.2 Function Arguments

```bash
check_file() {
    echo "File: $1"
}
```

Call:

```bash
check_file "/etc/passwd"
```

Important variables:

```text
$1     → first argument
$2     → second argument
$3     → third argument
$#     → argument count
"$@"   → all arguments separately
```

---

## 7.3 `"$@"`

If called with:

```bash
check_files "file one" "file two"
```

then:

```bash
"$@"
```

preserves the two arguments separately.

---

## 7.4 Local Variables

Use:

```bash
local file="$1"
```

inside functions.

This prevents unnecessary modification of global variables.

---

## 7.5 Function Return Status

Example:

```bash
check_file() {
    if [[ -f "$1" ]]; then
        return 0
    fi

    return 1
}
```

Then:

```bash
if check_file "/etc/passwd"; then
    echo "Found"
fi
```

---

## 7.6 `return` vs `exit`

`return` returns from a function.

`exit` terminates the script.

This distinction is important when designing reusable security functions.

---

## 7.7 Capturing Function Output

Example:

```bash
get_file_owner() {
    local file="$1"
    stat -c '%U' "$file"
}

owner=$(get_file_owner "/etc/passwd")
```

The function's stdout becomes data.

Its exit status remains separate.

---

## 7.8 Functions + Conditions

Functions can act as reusable tests:

```bash
if check_file "$file"; then
    echo "File exists"
fi
```

They can also be combined:

```bash
check_file "$file" && check_readable "$file"
```

---

## 7.9 Functions + Loops

```bash
for file in "${files[@]}"
do
    check_file "$file"
done
```

This separates loop logic from validation logic.

---

## 7.10 Function Error Handling

Diagnostics can go to stderr:

```bash
echo "File missing: $file" >&2
return 1
```

Functions should return meaningful statuses.

---

## 7.11 Function Input Validation

Check required arguments:

```bash
if [[ $# -lt 1 ]]; then
    echo "Usage: check_file <file>" >&2
    return 2
fi
```

This is especially important when using:

```bash
set -u
```

---

## 7.12 Regex Validation

Example:

```bash
check_port() {
    local port="$1"

    if [[ ! "$port" =~ ^[0-9]+$ ]]; then
        echo "Invalid port" >&2
        return 1
    fi

    echo "Valid port: $port"
}
```

---

## 7.13 Default Arguments

```bash
local name="${1:-Guest}"
```

If `$1` is missing or empty, `Guest` is used.

---

## 7.14 `shift`

Example:

```bash
show_args() {
    while (( $# > 0 ))
    do
        echo "Argument: $1"
        shift
    done
}
```

Call:

```bash
show_args one two three
```

---

## 7.15 Security-Focused Functions

Prefer focused functions such as:

```text
check_file
check_owner
check_permissions
check_user
check_service
check_ioc
```

instead of one giant function such as:

```text
audit_everything
```

---

## 7.16 Function Architecture

A security script can be structured as:

```text
Discovery
    ↓
Validation
    ↓
Analysis
    ↓
Finding
    ↓
Reporting
```

This separation makes scripts easier to understand, test, and maintain.

---

# Topic 8 — Arguments & CLI Interfaces

CLI interfaces make scripts reusable.

---

## 8.1 Positional Arguments

Important variables:

```text
$0 → script name
$1 → first argument
$2 → second argument
$3 → third argument
$# → argument count
"$@" → all arguments
```

---

## 8.2 Defaults

```bash
mode="${1:-basic}"
```

This supplies a default.

Required arguments should be explicitly validated.

---

## 8.3 CLI Flags with `case`

Example:

```bash
case "$1" in
    --help)
        echo "Usage: $0 [options]"
        ;;
    --verbose)
        echo "Verbose mode"
        ;;
    *)
        echo "Unknown option"
        ;;
esac
```

---

## 8.4 `getopts`

Example:

```bash
while getopts "hvf:m:" opt
do
    case "$opt" in
        h)
            echo "Help"
            ;;
        v)
            echo "Verbose"
            ;;
        f)
            file="$OPTARG"
            ;;
        m)
            mode="$OPTARG"
            ;;
        *)
            echo "Invalid option" >&2
            exit 1
            ;;
    esac
done
```

Important variables:

```text
OPTARG → option value
OPTIND → current option index
```

After parsing:

```bash
shift "$((OPTIND - 1))"
```

---

## 8.5 Required Options

`getopts` parses options but does not automatically know which options are mandatory.

Example:

```bash
if [[ -z "$file" ]]; then
    echo "Error: -f <file> is required" >&2
    exit 2
fi
```

---

## 8.6 CLI Architecture

A strong structure is:

```text
parse_args
    ↓
validate configuration
    ↓
main functionality
```

Argument parsing should generally be separated from the actual security operation.

---

## 8.7 Security-Focused CLI Design

Important principles:

* Quote arguments.
* Validate paths.
* Validate values.
* Reject unknown options.
* Use meaningful exit codes.
* Provide help.
* Use `--` when appropriate.
* Separate CLI parsing from functionality.
* Never blindly execute user-controlled strings.

Avoid:

```bash
eval "$input"
```

or:

```bash
bash -c "$input"
```

for untrusted data.

---

# Topic 9 — Arrays & Data Handling

Arrays allow scripts to store multiple values.

---

## 9.1 Indexed Arrays

```bash
files=("passwd" "shadow" "hosts")
```

Indexes start at zero:

```text
files[0] → passwd
files[1] → shadow
files[2] → hosts
```

Access:

```bash
echo "${files[0]}"
```

Length:

```bash
echo "${#files[@]}"
```

---

## 9.2 Append and Update

Append:

```bash
files+=("group")
```

Specific index:

```bash
files[5]="sudoers"
```

Bash allows gaps in indexed arrays.

---

## 9.3 Safe Array Loops

```bash
for file in "${files[@]}"
do
    echo "$file"
done
```

`"${files[@]}"` preserves each element separately.

---

## 9.4 Security Example

```bash
files=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/hosts"
    "/etc/sudoers"
)

for file in "${files[@]}"
do
    if [[ -f "$file" ]]; then
        echo "[FOUND] $file"
    else
        echo "[MISSING] $file"
    fi
done
```

---

## 9.5 `"${array[@]}"` vs `"${array[*]}"`

For safely processing individual elements, prefer:

```bash
"${array[@]}"
```

Quoted `@"` preserves separate elements.

Quoted `"${array[*]}"` typically combines the elements into one expansion.

---

## 9.6 Array Slicing

```bash
files=("a" "b" "c" "d" "e")

echo "${files[@]:1:3}"
```

This starts at index `1` and takes `3` elements.

---

## 9.7 Removing Elements

```bash
unset 'files[2]'
```

This removes the element but does not automatically renumber the remaining indexes.

---

## 9.8 Copying Arrays

```bash
new_files=("${files[@]}")
```

This preserves the array structure.

---

## 9.9 Passing Arrays to Functions

```bash
check_files() {
    for file in "$@"
    do
        echo "Checking: $file"
    done
}

check_files "${files[@]}"
```

Each array element becomes a separate function argument.

---

## 9.10 Associative Arrays

Create:

```bash
declare -A severity
```

Store key-value data:

```bash
severity["malware"]="critical"
severity["failed_login"]="high"
severity["weak_password"]="medium"
```

Access:

```bash
echo "${severity["malware"]}"
```

---

## 9.11 Associative Array Keys

Check a key:

```bash
[[ -v severity["malware"] ]]
```

Get keys:

```bash
echo "${!severity[@]}"
```

Loop:

```bash
for finding in "${!severity[@]}"
do
    echo "$finding → ${severity[$finding]}"
done
```

---

## 9.12 Security Uses

Associative arrays can represent:

```text
IOC       → severity
username  → privilege
service   → status
finding   → category
port      → service
```

---

## 9.13 `mapfile`

Read lines into an array:

```bash
mapfile -t targets < targets.txt
```

The `-t` option removes newline characters.

---

## 9.14 Command Output into Arrays

Example:

```bash
mapfile -t users < <(cut -d: -f1 /etc/passwd)
```

Mental model:

```text
command
   ↓
output
   ↓
mapfile
   ↓
array
   ↓
loop
   ↓
security processing
```

---

# Topic 10 — Text Processing

> **Status: Remaining planned topic in the original Module 11 scope.**

Text processing is essential because much of Linux security data appears as text:

```text
logs
configuration files
process output
network information
IOC lists
user databases
service information
command output
```

The purpose of this topic is to learn the core Linux text-processing tools that Bash scripts use to transform and analyze this data.

---

## 10.1 `grep`

`grep` searches text for patterns.

Basic:

```bash
grep "root" /etc/passwd
```

Case-insensitive:

```bash
grep -i "error" logfile
```

Show line numbers:

```bash
grep -n "error" logfile
```

Invert matches:

```bash
grep -v "normal" logfile
```

Quiet existence check:

```bash
grep -q "malware" logfile
```

Fixed-string search:

```bash
grep -F "192.168.1.10" logfile
```

Regular-expression search:

```bash
grep -E "error|failed|denied" logfile
```

Security uses include:

* IOC searching
* Log filtering
* Error detection
* Authentication investigation
* Configuration checks

---

## 10.2 `cut`

`cut` extracts fields or characters.

Example:

```bash
cut -d: -f1 /etc/passwd
```

This extracts usernames from `/etc/passwd`.

Mental model:

```text
raw line
   ↓
delimiter
   ↓
field selection
   ↓
result
```

---

## 10.3 `sort`

Sort data:

```bash
sort users.txt
```

Reverse:

```bash
sort -r users.txt
```

Numeric sorting:

```bash
sort -n numbers.txt
```

Sorting is useful before counting or grouping data.

---

## 10.4 `uniq`

Remove adjacent duplicate lines:

```bash
sort users.txt | uniq
```

Count occurrences:

```bash
sort users.txt | uniq -c
```

Security example:

```bash
grep "Failed password" auth.log \
    | cut -d' ' -f11 \
    | sort \
    | uniq -c
```

This can help identify repeated values in authentication logs.

---

## 10.5 `tr`

Translate or remove characters.

Example:

```bash
echo "HELLO" | tr 'A-Z' 'a-z'
```

Convert uppercase to lowercase.

Remove characters:

```bash
tr -d ':' 
```

`tr` is useful for basic normalization and cleanup.

---

## 10.6 `head`

Show the beginning of a file:

```bash
head file.txt
```

Specify lines:

```bash
head -n 20 file.txt
```

---

## 10.7 `tail`

Show the end:

```bash
tail file.txt
```

Specify lines:

```bash
tail -n 20 file.txt
```

Follow a changing log:

```bash
tail -f logfile
```

---

## 10.8 `wc`

Count lines:

```bash
wc -l file.txt
```

Count words:

```bash
wc -w file.txt
```

Count bytes:

```bash
wc -c file.txt
```

Security scripts can use these for basic statistics.

---

## 10.9 `sed`

`sed` performs stream-based text transformations.

Example:

```bash
sed 's/old/new/' file.txt
```

Replace globally on each line:

```bash
sed 's/old/new/g' file.txt
```

Delete lines:

```bash
sed '/pattern/d' file.txt
```

`sed` is useful for controlled text transformations and extraction.

---

## 10.10 `awk`

`awk` is particularly useful for field-based text processing.

Example:

```bash
awk '{print $1}' file.txt
```

With a delimiter:

```bash
awk -F: '{print $1}' /etc/passwd
```

This can extract usernames from `/etc/passwd`.

`awk` becomes particularly powerful when security data contains structured fields.

---

## 10.11 Pipelines

The major security pattern is combining tools:

```text
input
  ↓
grep
  ↓
cut
  ↓
sort
  ↓
uniq
  ↓
report
```

Example:

```bash
grep "Failed password" auth.log |
    awk '{print $11}' |
    sort |
    uniq -c
```

The important lesson is not memorizing individual commands.

It is understanding how commands can be chained into a processing pipeline.

---

## 10.12 Text Processing Security Applications

These tools can support:

* Failed-login analysis
* IOC matching
* Log filtering
* Configuration auditing
* Process analysis
* User enumeration
* Network output parsing
* Alert generation

---

# Topic 11 — Bash Symbols & Syntax

> **Status: Remaining planned topic in the original Module 11 scope.**

This topic exists because Bash uses many symbols whose meaning changes depending on context.

Understanding them prevents syntax mistakes and makes security scripts easier to read.

---

## 11.1 `$`

Variable expansion:

```bash
echo "$USER"
```

Command substitution:

```bash
result=$(command)
```

Arithmetic expansion:

```bash
result=$((5 + 5))
```

---

## 11.2 `#`

Comment:

```bash
# This is a comment
```

---

## 11.3 `=`

Variable assignment:

```bash
name="kali"
```

---

## 11.4 `==`

Comparison:

```bash
[[ "$user" == "root" ]]
```

---

## 11.5 `{}`

Braces appear in several Bash constructs.

Parameter expansion:

```bash
"${name}"
```

Brace expansion:

```bash
echo {1..5}
```

Command grouping can also use braces:

```bash
{
    echo "one"
    echo "two"
}
```

---

## 11.6 `[]`

Used in:

* Traditional test syntax
* Indexed arrays
* Character classes in patterns and regex

Examples:

```bash
[ -f "$file" ]
```

```bash
files[0]="passwd"
```

```text
[0-9]
```

---

## 11.7 `()`

Parentheses appear in:

* Subshells
* Arrays
* Grouping contexts

Example:

```bash
(
    cd /tmp
    ls
)
```

The commands execute in a subshell.

Arrays:

```bash
files=("a" "b" "c")
```

---

## 11.8 `^`

In regular expressions:

```text
^
```

means the beginning of a string.

Example:

```bash
[[ "$value" =~ ^root ]]
```

---

## 11.9 `$` in Regex

In regex:

```text
$
```

means the end of a string.

Example:

```bash
[[ "$value" =~ root$ ]]
```

---

## 11.10 `:`

The colon is the Bash null command:

```bash
:
```

It can also appear in parameter expansion and other Bash syntax.

---

## 11.11 `\`

Backslash is an escape character.

Example:

```bash
echo "Hello \$USER"
```

This prevents `$USER` from being expanded.

Backslashes are also important when processing text safely.

---

## 11.12 `/`

The slash is commonly used as the Linux path separator:

```text
/etc/passwd
/var/log/auth.log
/home/kali
```

---

## 11.13 `~`

Tilde expansion represents the current user's home directory:

```bash
cd ~
```

It is commonly equivalent to:

```bash
cd "$HOME"
```

---

## 11.14 `*`

Wildcard:

```bash
*.log
```

Arithmetic multiplication:

```bash
(( result = 5 * 2 ))
```

Its meaning depends on context.

---

## 11.15 `?`

Glob wildcard representing one character:

```bash
file?.txt
```

---

## 11.16 `;`

Separates commands:

```bash
command1; command2
```

---

## 11.17 `&&`

Logical AND / conditional command chaining:

```bash
command1 && command2
```

---

## 11.18 `||`

Logical OR / failure fallback:

```bash
command1 || command2
```

---

## 11.19 `!`

Negation:

```bash
if ! command; then
    echo "Command failed"
fi
```

---

## 11.20 Quoting

Double quotes:

```bash
"$variable"
```

allow expansion while preventing most word splitting and glob expansion.

Single quotes:

```bash
'$variable'
```

preserve the text literally.

Understanding quoting is one of the most important Bash security skills.

---

# Topic 12 — Files, Commands & Safe Scripting

> **Status: Remaining planned topic in the original Module 11 scope.**

This topic brings together Bash scripting, Linux files, external commands, permissions, and safe execution.

The goal is to understand not just how to make a command work, but how to make scripts behave safely.

---

## 12.1 Check Files Before Using Them

Example:

```bash
if [[ ! -f "$file" ]]; then
    echo "File does not exist" >&2
    exit 1
fi
```

Scripts should not blindly assume files exist.

---

## 12.2 Validate Paths

When accepting a path from a user:

```bash
file="$1"

if [[ ! -e "$file" ]]; then
    echo "Path does not exist" >&2
    exit 1
fi
```

Additional checks can determine whether it is:

* A regular file
* A directory
* Readable
* Writable
* Executable

---

## 12.3 Quoting Paths

Always consider:

```bash
cat "$file"
```

rather than:

```bash
cat $file
```

This prevents paths containing spaces from being split into multiple arguments.

---

## 12.4 `--`

Many commands support:

```bash
--
```

to indicate the end of options.

Example:

```bash
grep -F -- "$pattern" "$file"
```

This helps prevent data beginning with `-` from accidentally being interpreted as an option.

---

## 12.5 Avoid `eval`

Avoid:

```bash
eval "$input"
```

when handling untrusted input.

`eval` causes Bash to interpret a string as shell code.

That can transform data into executable commands.

---

## 12.6 Avoid Unnecessary Shell Evaluation

Be cautious with:

```bash
bash -c "$input"
```

or similar patterns.

Prefer passing data as arguments:

```bash
command -- "$value"
```

rather than constructing shell code dynamically.

---

## 12.7 Command Paths

Security scripts sometimes need to know which executable is being used.

Useful commands include:

```bash
command -v command_name
```

and:

```bash
type command_name
```

These help identify how Bash resolves a command.

---

## 12.8 Permissions

A script may need to examine:

```bash
ls -l "$file"
```

or:

```bash
stat "$file"
```

to understand:

* Owner
* Group
* Permissions
* Timestamps
* File metadata

This is especially relevant for security auditing.

---

## 12.9 Temporary Files

Temporary files should be handled carefully.

A secure approach should avoid predictable temporary filenames where possible.

The principle is:

> **Do not assume `/tmp` is private or trustworthy.**

---

## 12.10 External Commands

Bash scripts frequently call Linux commands.

The script therefore depends on:

```text
Bash
  ↓
external command
  ↓
stdout/stderr
  ↓
exit status
  ↓
Bash logic
```

A robust script should account for command failures.

---

## 12.11 Command Existence

Before depending on a tool, a script can check:

```bash
if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required" >&2
    exit 1
fi
```

This avoids confusing failures later in execution.

---

## 12.12 Safe File Handling

A security script should consider:

```text
Does the file exist?
       ↓
Is it the expected type?
       ↓
Who owns it?
       ↓
What permissions does it have?
       ↓
Can the script read it?
       ↓
Can an attacker modify it?
       ↓
Should the script trust its contents?
```

This is particularly important when scripts run with elevated privileges.

---

# Topic 13 — Script Debugging & Reliability

> **Status: Remaining planned topic in the original Module 11 scope.**

The final topic focuses on making Bash scripts easier to troubleshoot and more reliable.

A script that works once is not necessarily a reliable security tool.

---

## 13.1 `bash -x`

Run a script with tracing:

```bash
bash -x script.sh
```

Bash prints commands as they execute.

This helps identify:

* Incorrect variables
* Unexpected branches
* Wrong arguments
* Incorrect command execution
* Flow problems

---

## 13.2 `set -x`

Tracing can also be enabled inside a script:

```bash
set -x
```

Disable:

```bash
set +x
```

---

## 13.3 `set -euo pipefail`

A common reliability baseline is:

```bash
set -euo pipefail
```

Meaning:

```text
-e → stop on unhandled command failures
-u → detect unset variables
pipefail → detect failures inside pipelines
```

These options improve reliability but should be understood rather than blindly copied.

---

## 13.4 Check Exit Statuses

Instead of assuming success:

```bash
command
```

check it when appropriate:

```bash
if command; then
    echo "Success"
else
    echo "Failure" >&2
fi
```

---

## 13.5 Debug Variables

A common debugging technique is:

```bash
printf 'DEBUG: file=%s\n' "$file" >&2
```

Sending debug information to stderr keeps it separate from normal data output.

---

## 13.6 `trap`

Bash can execute commands when certain events occur.

Example:

```bash
trap 'echo "Script interrupted" >&2' INT
```

This can be useful for:

* Cleanup
* Temporary files
* Interrupt handling
* Exit logging

---

## 13.7 Cleanup

Scripts that create temporary resources should clean them up.

Concept:

```text
create temporary resource
        ↓
use resource
        ↓
cleanup
        ↓
exit
```

This becomes especially important for security tools that create temporary reports or intermediate files.

---

## 13.8 Syntax Checking

Bash can check syntax without executing the script:

```bash
bash -n script.sh
```

This is useful before running a script after making changes.

---

## 13.9 ShellCheck

A major Bash scripting tool is:

```bash
shellcheck script.sh
```

ShellCheck can identify many common Bash problems involving:

* Quoting
* Variables
* Expansions
* Conditions
* Portability
* Common scripting mistakes

It should become part of the development workflow for serious Bash projects.

---

## 13.10 Debugging Workflow

A practical debugging process is:

```text
Syntax check
    ↓
bash -n
    ↓
Static analysis
    ↓
ShellCheck
    ↓
Trace execution
    ↓
bash -x
    ↓
Check variables
    ↓
Check exit statuses
    ↓
Test edge cases
    ↓
Verify output
```

---

# Bash Security Principles

The entire module repeatedly reinforced several principles.

## 1. Quote Variables

Prefer:

```bash
"$file"
```

over:

```bash
$file
```

---

## 2. Keep Data Separate from Code

User input should remain data.

Avoid turning strings into shell commands.

---

## 3. Validate Inputs

Validate:

* Paths
* Numbers
* Strings
* CLI options
* File types
* Expected values

---

## 4. Use Exit Statuses

Functions and commands should communicate success or failure through exit statuses.

---

## 5. Separate stdout and stderr

Normal data:

```text
stdout
```

Diagnostics:

```text
stderr
```

This makes scripts easier to automate.

---

## 6. Use Safe File Processing

For line-oriented files:

```bash
while IFS= read -r line
do
    ...
done < file
```

---

## 7. Prefer Arrays for Structured Data

Instead of trying to encode multiple values into a single string, use arrays:

```bash
files=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/hosts"
)
```

---

## 8. Keep Functions Small

Prefer:

```text
check_file
check_owner
check_permissions
```

over one massive function.

---

## 9. Validate External Dependencies

Example:

```bash
command -v jq >/dev/null 2>&1
```

before assuming a required tool exists.

---

## 10. Debug Before Blaming the Environment

Use:

```bash
bash -n
shellcheck
bash -x
```

before randomly changing working code.

---

# Complete Bash Security Mental Model

The full Module 11 can be represented as:

```text
                         BASH SCRIPT
                              │
                              ↓
                       SCRIPT STRUCTURE
                              │
                              ↓
                    VARIABLES / ENVIRONMENT
                              │
                              ↓
                       INPUT / OUTPUT
                              │
                  ┌───────────┼───────────┐
                  ↓           ↓           ↓
               stdin       stdout      stderr
                  │           │           │
                  └───────────┼───────────┘
                              ↓
                        EXIT STATUS
                              │
                              ↓
                     CONDITIONS / LOGIC
                              │
                              ↓
                           LOOPS
                              │
                              ↓
                         FUNCTIONS
                              │
                              ↓
                       CLI INTERFACE
                              │
                              ↓
                      ARRAYS / DATA
                              │
                              ↓
                     TEXT PROCESSING
                              │
                              ↓
                     FILE / COMMAND SAFETY
                              │
                              ↓
                       DEBUGGING
                              │
                              ↓
                         RELIABILITY
                              │
                              ↓
                   SECURITY AUTOMATION
```

---

# Practical Security Script Architecture

The skills from the module combine into an architecture such as:

```text
                         CLI
                          │
                          ↓
                     parse_args()
                          │
                          ↓
                    validate_input()
                          │
                          ↓
                     collect_data()
                          │
              ┌───────────┴───────────┐
              ↓                       ↓
          arrays                  command output
              │                       │
              └───────────┬───────────┘
                          ↓
                       loops
                          │
                          ↓
                     check_ functions
                          │
              ┌───────────┼───────────┐
              ↓           ↓           ↓
            files       users      services
              │           │           │
              └───────────┼───────────┘
                          ↓
                     text parsing
                          │
                          ↓
                       findings
                          │
                          ↓
                       report
                          │
                          ↓
                    exit status
```

This is the foundation for the next stage of Bash security automation.

---

# Key Commands and Constructs

| Construct             | Purpose                          |
| --------------------- | -------------------------------- |
| `#!/usr/bin/env bash` | Bash interpreter                 |
| `echo`                | Simple output                    |
| `printf`              | Formatted output                 |
| `read`                | Read input                       |
| `$(...)`              | Command substitution             |
| `>`                   | Redirect stdout                  |
| `>>`                  | Append stdout                    |
| `2>`                  | Redirect stderr                  |
| `2>>`                 | Append stderr                    |
| `<`                   | Redirect stdin                   |
| `2>&1`                | Redirect stderr to stdout        |
| `&>`                  | Redirect stdout and stderr       |
| `\|`                  | Pipe                             |
| `<<`                  | Here document                    |
| `<<<`                 | Here string                      |
| `< <(...)`            | Process substitution             |
| `tee`                 | Output to screen and file        |
| `exec`                | File-descriptor management       |
| `$?`                  | Previous exit status             |
| `exit`                | Exit script                      |
| `return`              | Return from function             |
| `set -e`              | Stop on unhandled failures       |
| `set -u`              | Detect unset variables           |
| `pipefail`            | Detect pipeline failures         |
| `[[ ]]`               | Bash conditional                 |
| `=~`                  | Regex matching                   |
| `if`                  | Conditional branching            |
| `case`                | Pattern-based branching          |
| `for`                 | Iteration                        |
| `while`               | Conditional loop                 |
| `until`               | Loop until success               |
| `break`               | Exit loop                        |
| `continue`            | Skip iteration                   |
| `local`               | Function-local variable          |
| `shift`               | Shift positional arguments       |
| `getopts`             | Parse CLI options                |
| `declare -A`          | Associative array                |
| `"${array[@]}"`       | Expand array elements separately |
| `mapfile -t`          | Read lines into an array         |
| `grep`                | Search text                      |
| `sed`                 | Stream text transformation       |
| `awk`                 | Field-based text processing      |
| `cut`                 | Extract fields                   |
| `sort`                | Sort data                        |
| `uniq`                | Group/remove adjacent duplicates |
| `tr`                  | Translate/delete characters      |
| `head`                | Beginning of data                |
| `tail`                | End/follow data                  |
| `wc`                  | Count lines/words/bytes          |
| `bash -n`             | Syntax checking                  |
| `bash -x`             | Execution tracing                |
| `shellcheck`          | Static Bash analysis             |
| `trap`                | Event/cleanup handling           |

---

# What I Learned

After completing the full Module 11 curriculum, the target capability is to independently write Bash scripts that can:

* Start with a correct Bash structure.
* Use variables safely.
* Work with environment variables.
* Capture command output.
* Read user input.
* Control stdin, stdout, and stderr.
* Redirect data.
* Build pipelines.
* Process files safely.
* Use here documents and here strings.
* Use process substitution.
* Work with file descriptors.
* Understand command exit statuses.
* Handle failures.
* Use `set -euo pipefail`.
* Build conditional logic.
* Use file tests.
* Use string tests.
* Use glob patterns.
* Use regular expressions.
* Use `BASH_REMATCH`.
* Use numeric comparisons.
* Build `if/elif/else` logic.
* Build `case` statements.
* Write `for`, `while`, and `until` loops.
* Implement retries and timeouts.
* Work with background processes.
* Build reusable functions.
* Pass arguments to functions.
* Control variable scope.
* Return function statuses.
* Capture function output.
* Validate function input.
* Use defaults and `shift`.
* Design security-focused functions.
* Build CLI interfaces.
* Parse options with `getopts`.
* Validate required options.
* Separate CLI parsing from application logic.
* Use indexed arrays.
* Use associative arrays.
* Safely expand arrays.
* Pass arrays to functions.
* Use `mapfile`.
* Store command output in arrays.
* Process structured text.
* Use `grep`, `sed`, `awk`, `cut`, `sort`, `uniq`, `tr`, `head`, `tail`, and `wc`.
* Understand Bash symbols and syntax.
* Safely handle files and external commands.
* Avoid common command-injection patterns.
* Validate external dependencies.
* Debug scripts using Bash tracing.
* Perform syntax checking.
* Use ShellCheck.
* Design cleanup and reliability mechanisms.

---

# Security Automation Readiness

The purpose of Module 11 is not to make Bash the final cybersecurity skill.

It establishes the programming foundation needed for the next module.

The progression is:

```text
Module 11
Bash fundamentals
        ↓
Module 12
Bash security automation
        ↓
Log parsers
        ↓
IOC processing
        ↓
Port scanners
        ↓
Alert automation
        ↓
Security automation projects
```

The distinction is important:

> **Module 11 teaches how to program in Bash. Module 12 applies Bash to cybersecurity automation.**

---

# Final Takeaway

The biggest lesson from Module 11 is:

> **Good Bash scripting is not about making commands run once. It is about controlling input, processing data safely, handling failures, organizing logic, and producing predictable results.**

A reliable security script should follow a mental model such as:

```text
What input am I receiving?
        ↓
Can I trust it?
        ↓
How should I validate it?
        ↓
How should I store the data?
        ↓
What logic should process it?
        ↓
What can fail?
        ↓
How will I detect failure?
        ↓
What output should be produced?
        ↓
How will I debug it?
        ↓
Can I trust the final result?
```

That mindset turns Bash from a collection of Linux commands into a practical security automation language.

---

# Module Progress

```text
Module 01 → File & Metadata Investigation       ✅
Module 02 → Evidence Handling & File Operations  ✅
Module 03 → Linux Permissions & ACLs             ✅
Module 04 → Linux User Management                ✅
Module 05 → Process Management                   ✅
Module 06 → Services & Persistence               ✅
Module 07 → Linux Networking                     ✅
Module 08 → Linux Logs & Log Investigation       ✅
Module 09 → Linux Package Management             ✅
Module 10 → Linux Security & Hardening           ✅
Module 11 → Bash Scripting Fundamentals          🔄
```

## Original Module 11 Scope

```text
01 → Bash Script Structure
02 → Variables & Environment Variables
03 → Input & Output
04 → Exit Status & Error Handling
05 → Conditional Logic
06 → Loops
07 → Functions
08 → Arguments & CLI Interfaces
09 → Arrays & Data Handling
10 → Text Processing
11 → Bash Symbols & Syntax
12 → Files, Commands & Safe Scripting
13 → Script Debugging & Reliability
```

## Next Module

**Module 12 — Bash Scripting for Security Automation**

Planned focus:

```text
Bash programming foundation
          ↓
Security-oriented data processing
          ↓
Log parsers
          ↓
IOC processing
          ↓
Port scanners
          ↓
Alert automation
          ↓
Practical security automation
          ↓
Portfolio-ready projects
```

The full Module 11 therefore serves as the programming foundation for writing the Bash-based cybersecurity tools planned for Module 12 and the later portfolio projects.
