--[[
~ Some Unicode notes ~

Byte-order marks:
https://en.wikipedia.org/wiki/Byte_order_mark#Byte_order_marks_by_encoding
The BOM for UTF-8 is '\239\187\191'
The BOM for UTF-16 LE is '\255\254'

Unicode in Rainmeter:
https://docs.rainmeter.net/tips/unicode-in-rainmeter/

A cursory read of the Rainmeter docs originally led me to believe that
all files (ini, lua, and txt) must be encoded in UTF-16 LE, but there
is actually a separate section on reading and writing Unicode files in Lua!
(It's at the end)

Takeaways:
1. The script file should be in UTF-16 LE
2. The file being read/written to should be UTF-8
3. Since the first character set of UTF-8 is identical to ANSI, always
   write a UTF-8 byte-order mark so that the file is unambiguously UTF-8

--]]
path, contents = nil, ""

function Initialize()
	path = SKIN:MakePathAbsolute(SKIN:GetVariable('notesfile', SKIN:ReplaceVariables('#@#notes.txt')))
	contents = readFromFile()
end

function Update()
	-- If update is not disabled, then the measure will read the file contents
	-- on every update, so that changes to the text from other programs appear
	-- contents = readFromFile()
	return contents
end

function writeToFile(text)
	local text = SELF:GetOption('temp')
	local file = io.open(path, 'w')
	assert(file, 'could not write to ' .. path)
	local bom = '\239\187\191'
	if text:sub(1, 3) == bom then
		file:write(text)
	else
		file:write(bom, text)
	end
	file:close()
end

function readFromFile()
	local file = io.open(path, 'r')
	assert(file, 'could not read from ' .. path)
	local text = file:read('*a')
	file:close()
	return text
end
