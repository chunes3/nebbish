# Nebbish
<img src="res/nebbish-logo.png" width="150" height="100">

> `X01[:}+ix=b];` A program to calculate the nth Fibonacci number.

> `[[ij*P84*pj9=b]Ni9=b]` A program to show a times table.

## Characteristics

Nebbish is a stack-based golf language that uses one printable ASCII character per command. Unlike say, a language like [Vyxal](https://github.com/Vyxal/Vyxal), with a command for everything, Nebbish aims to provide a modest set of primitives that combine to tackle golf-type problems orthagonally. The primary goal of the language is to make terse procedural code fun to write. Terseness itself is a secondary goal.

## Commands

### Arithmetic
| Instruction | Name        |
|-------------|-------------|
| `+`         | Add         |
| `-`         | Subtract    |
| `*`         | Multiply    |
| `/`         | Divide      |
| `^`         | Power       |
| `%`         | Mod         |

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

More to come soon!
