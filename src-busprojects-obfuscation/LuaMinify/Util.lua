
--
-- Util.lua
--
-- Provides some common utilities shared throughout the project.
--

function lookupify(tb)
	for _, v in pairs(tb) do
		tb[v] = true
	end
	return tb
end

function CountTable(tb)
	local c = 0
	for _ in pairs(tb) do c = c + 1 end
	return c
end

function PrintTable(tb, atIndent)
	if tb.Print then
		return tb.Print()
	end
	atIndent = atIndent or 0
	local useNewlines = (CountTable(tb) > 1)
	local baseIndent = string.rep('    ', atIndent+1)
	local out = "{"..(useNewlines and '\n' or '')
	for k, v in pairs(tb) do
		if type(v) ~= 'function' then
			out = out..(useNewlines and baseIndent or '')
			if type(k) == 'number' then
				--nothing to do
			elseif type(k) == 'string' and k:match("^[A-Za-z_][A-Za-z0-9_]*$") then
				out = out..k.." = "
			elseif type(k) == 'string' then
				out = out.."[\""..k.."\"] = "
			else
				out = out.."["..tostring(k).."] = "
			end
			if type(v) == 'string' then
				out = out.."\""..v.."\""
			elseif type(v) == 'number' then
				out = out..v
			elseif type(v) == 'table' then
				out = out..PrintTable(v, atIndent+(useNewlines and 1 or 0))
			else
				out = out..tostring(v)
			end
			if next(tb, k) then
				out = out..","
			end
			if useNewlines then
				out = out..'\n'
			end
		end
	end
	out = out..(useNewlines and string.rep('    ', atIndent) or '').."}"
	return out
end