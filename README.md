# Nebbish
<img src="res/nebbish-logo.png" width="150" height="100">

> `X01[:}+ix=b];` A program to calculate the nth Fibonacci number.

> `[[ij*P84*pj9=b]Ni9=b]` A program to show a times table.

## Overview

Nebbish is a stack-based golf language that uses one printable ASCII character per command. Unlike say, a language like [Vyxal](https://github.com/Vyxal/Vyxal), with a command for everything, Nebbish aims to provide a modest set of primitives that combine to tackle golf-style problems orthagonally. The primary goal of the language is to make terse procedural code fun to write. Terseness itself is secondary.

## Table of contents
- [Installation](#installation)
- [Your first program](#your-first-program)
- [Commands](#commands)
- [Building](#building)

## Installation

## Your first program

## Commands

### Arithmetic
| Instruction | Name        | Signature | Examples |
|-------------|-------------|------------|--------|
| `+`         | Add         | `obj obj -- obj` | `11+ \ 2` <br> `123L2+ \ {3,4,5}` <br> `123LI456LT+ \ {5,7,9}` |
| `-`         | Subtract    | `obj obj -- obj` | `106L#7- \ 99` |
| `*`         | Multiply    | `obj obj -- obj` |
| `/`         | Divide      | `obj obj -- obj` |
| `^`         | Power       | `obj obj -- obj` |
| `%`         | Mod         | `obj obj -- obj` |
| `f`         | Floor       | `obj -- obj` |

### Stack
| Instruction | Name         |
|-------------|--------------|
| `:`         | Dup          |
| `~`         | Swap         |
| `;`         | Drop         |
| `I`         | Intangibilize|
| `T`         | Tangibilize  |
| `}`         | Bury          |
| `{`         | Exhume         |

### List
| Instruction | Name         |
|-------------|--------------|
| `a`         | Append       |
| `c`         | Concat       |
| `l`         | Length       |
| `L`         | Listify      |
| `s`         | Sum          |
| `S`         | Sort         |

### String
| Instruction | Name        |
|-------------|-------------|
| `"`         | String mode  |
| `` ` ``     | Command mode  |

### Loop
| Instruction | Name         |
|-------------|--------------|
| `[`         | Start loop         |
| `]`         | End loop         |
| `b`         | Break if     |
| `i`         | iteration index      |
| `j`         | deeper iteration index      |
| `k`         | deepest iteration index      |

### Comparison
| Instruction | Name         |
|-------------|--------------|
| `=`         | Equal        |
| `>`         | Greater than |
| `<`         | Less than    |

### Register
| Instruction | Name         |
|-------------|--------------|
| `x`         | Copy from X       |
| `X`         | Move to X    |
| `y`         | Copy from Y       |
| `Y`         | Move to Y    |

### Output
| Instruction | Name         |
|-------------|--------------|
| `p`         | Print        |
| `P`         | Prettyprint  |
| `N`         | Output newline |

### Miscellaneous
| Instruction | Name         |
|-------------|--------------|
| `d`         | Dump         |
| `#`         | Join Ints    |
| `r`         | Random    |

## Building

More to come soon!
