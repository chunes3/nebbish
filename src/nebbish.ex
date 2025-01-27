include std/cmdline.e
include std/convert.e
include std/error.e
include std/io.e
include std/math.e
include std/search.e
include std/sort.e
include std/text.e

constant STDOUT = 1

sequence cmd = command_line()
cmd = cmd[3..$]

if length(cmd) = 0 or find(cmd, {{"-h"}, {"-?"}, {"-help"}}) then
	print_usage()
end if

sequence src = read_file(cmd[1])
sequence stack = {}  -- data stack
sequence shadow_realm
integer i = 1  -- instruction pointer
object x = 25 -- register 1
object y = 100 -- register 2
object z = 1 -- register 3 (context; register I)
integer loop_start = 1  -- flow control
integer loop_end = length(src)
integer string_mode = 0  -- are we pushing a string?

-- parse any input from command line and push to stack
if length(cmd) > 1 then
	for j = 2 to length(cmd) do
		stack = append(stack, parse_arg(cmd[j]))
	end for
end if

while i <= length(src) do
	if string_mode then
		if src[i] = '`' then
			string_mode = 0
			i += 1
			continue
		end if
		stack &= src[i]
		i += 1
		continue
	end if
	switch src[i] do
		case '0' then
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
		case ';' then  -- drop
			stack = stack[1..$-1]
		case '"' then
			string_mode = 1
		case 'a' then  -- append
			sequence appended = append(stack[$-1], stack[$])
			stack = stack[1..$-1]
			stack[$] = appended
		case 'b' then  -- break if
			object flag = stack[$]
			stack = stack[1..$-1]
			if flag then
				i = loop_end
				loop_start = 1
				loop_end = length(src)
				z = 1
				continue
			end if
		case 'c' then  -- concat
			sequence concated = stack[$-1] & stack[$]
			stack = stack[1..$-1]
			stack[$] = concated
		case 'd' then  -- dump
			dump()
		case 'i' then  -- context
			stack = append(stack, z)
		case 'I' then  -- intangibilize
			shadow_realm = stack
			stack = {}
		case 'j' then  -- jump
			loop_end = i + 1
			i = loop_start
			z += 1
			continue
		case 'l' then  -- length
			stack[$] = length(stack[$])
		case 'L' then  -- listify
			stack = append(stack, stack)
			stack = stack[$..$]
		case 'm' then  -- mark
			loop_start = i
		case 'p' then  -- print
			puts(STDOUT, stack[$])
			stack = stack[1..$-1]
		case 'P' then  -- prettyprint
			? stack[$]
			stack = stack[1..$-1]
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
			crash("Unrecognized character -- '" & src[i] & "'")
	end switch
	i += 1  -- increment instruction pointer
end while

-- once program is complete,
-- print stack contents, one object per line
for j = 1 to length(stack) do
	? stack[j]
end for

-- ----------------------
procedure dump()
	puts(STDOUT, "Registers ---\n")
	puts(STDOUT, "X: " & sprint(x) & "  ")
	puts(STDOUT, "Y: " & sprint(y) & "  ")
	puts(STDOUT, "I: " & sprint(z) & "\n")
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

function find_matching_brace(sequence s, integer start_index)
    integer open_braces = 0
    for i = start_index to length(s) do
        if s[i] = '{' then
            open_braces += 1
        elsif s[i] = '}' then
            open_braces -= 1
            if open_braces = 0 then
                return i
            end if
        end if
    end for
    return 0 -- return 0 if no matching brace is found
end function

function parse_seq(sequence s)
    sequence result = {}
    integer index = 1
    while index <= length(s) do
        if s[index] = '{' then
            integer closing_brace = find_matching_brace(s, index)
            sequence inner_seq = parse_seq(s[index + 1 .. closing_brace - 1])
            result = append(result, inner_seq)
            index = closing_brace + 1
        elsif s[index] >= '0' and s[index] <= '9' then
            integer next_comma = match(",", s, index)
            if next_comma = 0 then
                result = append(result, to_number(s[index .. $]))
                exit
            else
                result = append(result, to_number(s[index .. next_comma - 1]))
                index = next_comma + 1
            end if
        else
            index += 1
        end if
    end while
    return result
end function

function parse_sequence(sequence s)
	sequence result = parse_seq(s)
	return result[1]
end function

function parse_arg(sequence s)
	if s[1] = '{' then
		return parse_sequence(s)
	end if
	object result = to_number(s, -1)
	if atom(result) then
		return result
	end if
	return s
end function

procedure print_usage()
	puts(STDOUT, "+------------------------------+\n")
	puts(STDOUT, "| Nebbish language interpreter |\n")
	puts(STDOUT, "+------------------------------+\n")
    puts(STDOUT, "Usage: nebbish [OPTIONS] <path_to_source_file> [ARGS]...\n\n")
    puts(STDOUT, "Options:\n")
	puts(STDOUT, "  -g         Format for CGSE\n")
    puts(STDOUT, "  -h         Show this help message\n")
	puts(STDOUT, "  -s         Show output as string instead of raw sequence\n\n")
    abort(0)
end procedure
