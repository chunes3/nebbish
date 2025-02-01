--- standard library imports
include std/cmdline.e
include std/convert.e
include std/io.e
include std/map.e
include std/math.e
include std/search.e
include std/sequence.e
include std/sort.e
include std/text.e

--- nebbish project imports
include cmdhandler.e as cmd

constant STDOUT = 1

cmd:handle()  -- handle parsing command line

sequence src = cmd:src  -- source code
sequence stack = cmd:input  -- data stack initialized w/ command line args
sequence return_stack = {}  -- start indices for nested loops
sequence shadow_realm  -- for temporary shadowing of the data stack
integer i = 1  -- instruction pointer
object x = 25 -- register 1
object y = 100 -- register 2
sequence context_stack = {}  -- keep track of nested context (register I)
integer string_mode = 0  -- are we pushing a string?

while i <= length(src) do
	if string_mode then
		if src[i] = '`' then  -- command mode
			string_mode = 0
			i += 1
			continue
		end if
		stack &= src[i]
		i += 1
		continue
	end if
	switch src[i] do
		case '0' then  -- push single digits as integers
			stack &= 0
		case '1' then
			stack &= 1
		case '2' then
			stack &= 2
		case '3' then
			stack &= 3
		case '4' then
			stack &= 4
		case '5' then
			stack &= 5
		case '6' then
			stack &= 6
		case '7' then
			stack &= 7
		case '8' then
			stack &= 8
		case '9' then
			stack &= 9
		case '+' then  -- add
			object sum = stack[$-1] + stack[$]
			stack = stack[1..$-1]
			stack[$] = sum
		case '-' then  -- subtract
			object diff = stack[$-1] - stack[$]
			stack = stack[1..$-1]
			stack[$] = diff
		case '*' then  -- multiply
			object prod = stack[$-1] * stack[$]
			stack = stack[1..$-1]
			stack[$] = prod
		case '/' then  -- divide
			object div = stack[$-1] / stack[$]
			stack = stack[1..$-1]
			stack[$] = div
		case '^' then  -- power
			object pow = power(stack[$-1], stack[$])
			stack = stack[1..$-1]
			stack[$] = pow
		case '%' then  -- mod
			object rem = remainder(stack[$-1], stack[$])
			stack = stack[1..$-1]
			stack[$] = rem
		case '#' then  -- join ints
			stack[$] = join_ints(stack[$])
		case '=' then  -- equal?
			object eq = stack[$-1] = stack[$]
			stack = stack[1..$-1]
			stack[$] = eq
		case '>' then  -- greater than
			integer flag = stack[$-1] > stack[$]
			stack = stack[1..$-1]
			stack[$] = flag
		case '<' then  -- less than
			integer flag = stack[$-1] < stack[$]
			stack = stack[1..$-1]
			stack[$] = flag
		case ':' then  -- dup
			stack = append(stack, stack[$])
		case '~' then  -- swap
			object temp = stack[$]
			stack[$] = stack[$-1]
			stack[$-1] = temp
		case ',' then  -- over
			stack = append(stack, stack[$-1])
		case '}' then  -- bury
			stack = rotate(stack, ROTATE_RIGHT)
		case '{' then  -- exhume
			stack = rotate(stack, ROTATE_LEFT)
		case ';' then  -- drop
			stack = stack[1..$-1]
		case '"' then  -- string mode
			string_mode = 1
		case '[' then  -- loop
			return_stack &= i + 1
			context_stack &= 1
		case ']' then  -- end loop
			i = return_stack[$]
			context_stack[$] += 1
			continue
		case '\\' then  -- comment
			while src[i] != '\n' and i < length(src) do
				i += 1
			end while
		case '\n' then  -- ignore whitespace
			fallthru
		case '\t' then
			fallthru
		case ' ' then
			fallthru
		case '\r' then
			i += 1
			continue
		case 'a' then  -- append
			sequence appended = append(stack[$-1], stack[$])
			stack = stack[1..$-1]
			stack[$] = appended
		case 'b' then  -- break if
			object flag = stack[$]
			stack = stack[1..$-1]
			if flag then
				sequence brackets = {}
				while 1 do
					if src[i] = '[' then
						brackets &= '['
					elsif src[i] = ']' then
						if length(brackets) > 1 then
							brackets = brackets[1..$-1]
						else
							exit
						end if
					end if
					i += 1
				end while
				return_stack = return_stack[1..$-1]
				context_stack = context_stack[1..$-1]
			end if
		case 'c' then  -- concat
			sequence concated = stack[$-1] & stack[$]
			stack = stack[1..$-1]
			stack[$] = concated
		case 'd' then  -- dump
			dump()
		case 'f' then  -- floor
			stack[$] = floor(stack[$])
		case 'i' then  -- context
			stack = append(stack, context_stack[1])
		case 'I' then  -- intangibilize
			shadow_realm = stack
			stack = {}
		case 'j' then  -- deeper context
			stack = append(stack, context_stack[2])
		case 'k' then  -- deepest context
			stack = append(stack, context_stack[$])
		case 'l' then  -- length
			stack[$] = length(stack[$])
		case 'L' then  -- listify
			stack = append(stack, stack)
			stack = stack[$..$]
		case 'N' then  -- output newline
			puts(STDOUT, "\n")
		case 'p' then  -- print
			puts(STDOUT, stack[$])
			stack = stack[1..$-1]
		case 'P' then  -- prettyprint
			print(STDOUT, stack[$])
			stack = stack[1..$-1]
		case 'r' then  -- random
			object limit = stack[$]
			stack[$] = rand(limit)
		case 's' then  -- sum
			stack[$] = sum(stack[$])
		case 'S' then  -- sort
			stack[$] = sort(stack[$])
		case 'T' then  -- tangibilize
			stack = shadow_realm & stack
		case 'x' then  -- copy register X to stack
			stack = append(stack, x)
		case 'X' then  -- move TOS to register X
			x = stack[$]
			stack = stack[1..$-1]
		case 'y' then  -- copy register Y to stack
			stack = append(stack, y)
		case 'Y' then  -- move TOS to register Y
			y = stack[$]
			stack = stack[1..$-1]
		case else
			puts(STDOUT, "\n[ERROR] Unrecognized character '" & src[i] & "'\n")
			puts(STDOUT, "at command number " & sprint(i) & "\n")
			abort(1)
	end switch
	i += 1  -- increment instruction pointer
end while

-- once program is complete,
-- print stack contents, one object per line
if map:get(cmd:options, "-s") = 0 then
	for j = 1 to length(stack) do
		? stack[j]
	end for
else
	for j = 1 to length(stack) do
		puts(STDOUT, stack[j])
	end for
end if

---------------------------

procedure dump()
	puts(STDOUT, "Registers ---\n")
	puts(STDOUT, "X: " & sprint(x) & "  ")
	puts(STDOUT, "Y: " & sprint(y) & "\n")
	puts(STDOUT, "Return stack ---\n")
	for j = 1 to length(return_stack) do
		print(STDOUT, return_stack[j])
		puts(STDOUT, " ")
	end for
	puts(STDOUT, "\n")
	puts(STDOUT, "Data stack ---\n")
	for j = 1 to length(stack) do
		? stack[j]
	end for
	puts(STDOUT, "--- (dump)\n")
end procedure

function join_ints(sequence ints)
	sequence result = ""
	for i = 1 to length(ints) do
		result &= sprint(ints[i])
	end for
	return to_integer(result)
end function
