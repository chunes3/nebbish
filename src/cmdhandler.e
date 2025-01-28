namespace cmd

include std/cmdline.e
include std/convert.e
include std/filesys.e
include std/io.e
include std/map.e

constant
	FIRST_ARG = 3,  -- we don't care about the program/interpreter name
	STDOUT = 1,
	$

public map options = new_from_kvpairs({
	{"-g", 0},
	{"-h", 0},
	{"-s", 0}
})

public sequence src = ""
public sequence input = {}

public procedure handle()
	integer parsing_options = 1
	sequence cmd = command_line()
	sequence args = cmd[FIRST_ARG..$]
	for i = 1 to length(args) do
		if args[i][1] = '-' and parsing_options = 1 then  -- an option/flag
			if equal(args[i], "-h") then
				print_usage()
				abort(0)
			else
				handle_option(args[i])
			end if
		elsif args[i][1] != '-' and parsing_options = 1 then  -- source code path
			parsing_options = 0  -- no longer parsing options
			if file_exists(args[i]) then
				src = io:read_file(args[i])
			else
				puts(STDOUT, "[ERROR] Cannot find source file: " & args[i] & "\n")
				abort(1)
			end if
		else  -- input argument
			input = append(input, parse_arg(args[i]))
		end if
	end for
end procedure

procedure handle_option(sequence option)
	if map:has(options, option) then
		map:put(options, option, 1)
	else
		puts(STDOUT, "[ERROR] Unrecognized option: " & option & "\n")
		print_usage()
		abort(1)
	end if
end procedure

procedure print_usage()
	puts(STDOUT, "+------------------------------+\n")
	puts(STDOUT, "| Nebbish language interpreter |\n")
	puts(STDOUT, "+------------------------------+\n")
    puts(STDOUT, "Usage: nebbish [OPTIONS] <path_to_source_file> [ARGS]...\n\n")
    puts(STDOUT, "Options:\n")
	puts(STDOUT, "  -g         Format for CGSE\n")
    puts(STDOUT, "  -h         Show this help message\n")
	puts(STDOUT, "  -s         Show output as string instead of raw sequence\n\n")
end procedure

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

-- parse a sequence given as a string
-- e.g. "{1,2,{3,4}}" --> {1,2,{3,4}}
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
