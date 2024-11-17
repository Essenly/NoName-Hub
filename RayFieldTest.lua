local req = (syn and syn["request"])
	or (http and http["request"])
	or http_request
	or (fluxus and fluxus.request)
	or request

local tostr = function(array)
	return `{array}`
end

local Kick = function(reason)
	game:GetService("Players").LocalPlayer:Kick(reason)
	wait(0.5)
	while true do
	end
end

local gethardwareid = function()
	local HWID = gethwid()
		or game:GetService("RbxAnalyticsService"):GetClientId() and game:GetService("RbxAnalyticsService")
			:GetClientId()
			:gsub("-", "")
		or Kick("No HWID found please report to x?")
	return tostr(HWID)
end

--[[
Function calls might not work because im doing x:function() instead of x.function()
so ur gonna have to change a few of them. and the hashing system needs to get modified!
thats rlly it enjoy!
made by frostlua on discord, ask questions if needed!

]]

-------------------------------------------------------------------------------
-- JSON
-------------------------------------------------------------------------------

local json = { _version = "0.1.2" }
local encode
local escape_char_map =
	{ ["\\"] = "\\", ['"'] = '"', ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t" }
local escape_char_map_inv = { ["/"] = "/" }
for k, v in pairs(escape_char_map) do
	escape_char_map_inv[v] = k
end
local function escape_char(c)
	return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end
local function encode_nil(val)
	return "null"
end
local function encode_table(val, stack)
	local res = {}
	stack = stack or {}
	if stack[val] then
		error("circular reference")
	end
	stack[val] = true
	if rawget(val, 1) ~= nil or next(val) == nil then
		local n = 0
		for k in pairs(val) do
			if type(k) ~= "number" then
				error("invalid table: mixed or invalid key types")
			end
			n = n + 1
		end
		if n ~= #val then
			error("invalid table: sparse array")
		end
		for i, v in ipairs(val) do
			table.insert(res, encode(v, stack))
		end
		stack[val] = nil
		return "[" .. table.concat(res, ",") .. "]"
	else
		for k, v in pairs(val) do
			if type(k) ~= "string" then
				error("invalid table: mixed or invalid key types")
			end
			table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
		end
		stack[val] = nil
		return "{" .. table.concat(res, ",") .. "}"
	end
end
local function encode_string(val)
	return '"' .. val:gsub('[%z\001-\031\\"]', escape_char) .. '"'
end
local function encode_number(val)
	if val ~= val or val <= -math.huge or val >= math.huge then
		error("unexpected number value '" .. tostring(val) .. "'")
	end
	return string.format("%.14g", val)
end
local type_func_map = {
	["nil"] = encode_nil,
	["table"] = encode_table,
	["string"] = encode_string,
	["number"] = encode_number,
	["boolean"] = tostring,
}
encode = function(val, stack)
	local t = type(val)
	local f = type_func_map[t]
	if f then
		return f(val, stack)
	end
	error("unexpected type '" .. t .. "'")
end
json.encode = function(val)
	return (encode(val))
end
local parse
local function create_set(...)
	local res = {}
	for i = 1, select("#", ...) do
		res[select(i, ...)] = true
	end
	return res
end
local space_chars = create_set(" ", "\t", "\r", "\n")
local delim_chars = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals = create_set("true", "false", "null")
local literal_map = { ["true"] = true, ["false"] = false, ["null"] = nil }
local function next_char(str, idx, set, negate)
	for i = idx, #str do
		if set[str:sub(i, i)] ~= negate then
			return i
		end
	end
	return #str + 1
end
local function decode_error(str, idx, msg)
	local line_count = 1
	local col_count = 1
	for i = 1, idx - 1 do
		col_count = col_count + 1
		if str:sub(i, i) == "\n" then
			line_count = line_count + 1
			col_count = 1
		end
	end
	error(string.format("%s at line %d col %d", msg, line_count, col_count))
end
local function codepoint_to_utf8(n)
	local f = math.floor
	if n <= 127 then
		return string.char(n)
	else
		if n <= 2047 then
			return string.char(f(n / 64) + 192, n % 64 + 128)
		else
			if n <= 65535 then
				return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
			else
				if n <= 1114111 then
					return string.char(
						f(n / 262144) + 240,
						f(n % 262144 / 4096) + 128,
						f(n % 4096 / 64) + 128,
						n % 64 + 128
					)
				end
			end
		end
	end
	error(string.format("invalid unicode codepoint '%x'", n))
end
local function parse_unicode_escape(s)
	local n1 = tonumber(s:sub(1, 4), 16)
	local n2 = tonumber(s:sub(7, 10), 16)
	if n2 then
		return codepoint_to_utf8((n1 - 55296) * 1024 + (n2 - 56320) + 65536)
	else
		return codepoint_to_utf8(n1)
	end
end
local function parse_string(str, i)
	local res = ""
	local j = i + 1
	local k = j
	while j <= #str do
		local x = str:byte(j)
		if x < 32 then
			decode_error(str, j, "control character in string")
		else
			if x == 92 then
				res = res .. str:sub(k, j - 1)
				j = j + 1
				local c = str:sub(j, j)
				if c == "u" then
					local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
						or str:match("^%x%x%x%x", j + 1)
						or decode_error(str, j - 1, "invalid unicode escape in string")
					res = res .. parse_unicode_escape(hex)
					j = j + #hex
				else
					if not escape_chars[c] then
						decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
					end
					res = res .. escape_char_map_inv[c]
				end
				k = j + 1
			else
				if x == 34 then
					res = res .. str:sub(k, j - 1)
					return res, j + 1
				end
			end
		end
		j = j + 1
	end
	decode_error(str, i, "expected closing quote for string")
end
local function parse_number(str, i)
	local x = next_char(str, i, delim_chars)
	local s = str:sub(i, x - 1)
	local n = tonumber(s)
	if not n then
		decode_error(str, i, "invalid number '" .. s .. "'")
	end
	return n, x
end
local function parse_literal(str, i)
	local x = next_char(str, i, delim_chars)
	local word = str:sub(i, x - 1)
	if not literals[word] then
		decode_error(str, i, "invalid literal '" .. word .. "'")
	end
	return literal_map[word], x
end
local function parse_array(str, i)
	local res = {}
	local n = 1
	i = i + 1
	while 1 do
		local x
		i = next_char(str, i, space_chars, true)
		if str:sub(i, i) == "]" then
			i = i + 1
			break
		end
		x, i = parse(str, i)
		res[n] = x
		n = n + 1
		i = next_char(str, i, space_chars, true)
		local chr = str:sub(i, i)
		i = i + 1
		if chr == "]" then
			break
		end
		if chr ~= "," then
			decode_error(str, i, "expected ']' or ','")
		end
	end
	return res, i
end
local function parse_object(str, i)
	local res = {}
	i = i + 1
	while 1 do
		local key, val
		i = next_char(str, i, space_chars, true)
		if str:sub(i, i) == "}" then
			i = i + 1
			break
		end
		if str:sub(i, i) ~= '"' then
			decode_error(str, i, "expected string for key")
		end
		key, i = parse(str, i)
		i = next_char(str, i, space_chars, true)
		if str:sub(i, i) ~= ":" then
			decode_error(str, i, "expected ':' after key")
		end
		i = next_char(str, i + 1, space_chars, true)
		val, i = parse(str, i)
		res[key] = val
		i = next_char(str, i, space_chars, true)
		local chr = str:sub(i, i)
		i = i + 1
		if chr == "}" then
			break
		end
		if chr ~= "," then
			decode_error(str, i, "expected '}' or ','")
		end
	end
	return res, i
end
local char_func_map = {
	['"'] = parse_string,
	["0"] = parse_number,
	["1"] = parse_number,
	["2"] = parse_number,
	["3"] = parse_number,
	["4"] = parse_number,
	["5"] = parse_number,
	["6"] = parse_number,
	["7"] = parse_number,
	["8"] = parse_number,
	["9"] = parse_number,
	["-"] = parse_number,
	["t"] = parse_literal,
	["f"] = parse_literal,
	["n"] = parse_literal,
	["["] = parse_array,
	["{"] = parse_object,
}
parse = function(str, idx)
	local chr = str:sub(idx, idx)
	local f = char_func_map[chr]
	if f then
		return f(str, idx)
	end
	decode_error(str, idx, "unexpected character '" .. chr .. "'")
end
json.decode = function(str)
	if type(str) ~= "string" then
		error("expected argument of type string, got " .. type(str))
	end
	local res, idx = parse(str, next_char(str, 1, space_chars, true))
	idx = next_char(str, idx, space_chars, true)
	if idx <= #str then
		decode_error(str, idx, "trailing garbage")
	end
	return res
end

-------------------------------------------------------------------------------
-- Cipher Funcs:
-------------------------------------------------------------------------------

local ascii_table = {
	[0] = "\0",
	[1] = "\1",
	[2] = "\2",
	[3] = "\3",
	[4] = "\4",
	[5] = "\5",
	[6] = "\6",
	[7] = "\7",
	[8] = "\8",
	[9] = "\9",
	[10] = "\10",
	[11] = "\11",
	[12] = "\12",
	[13] = "\13",
	[14] = "\14",
	[15] = "\15",
	[16] = "\16",
	[17] = "\17",
	[18] = "\18",
	[19] = "\19",
	[20] = "\20",
	[21] = "\21",
	[22] = "\22",
	[23] = "\23",
	[24] = "\24",
	[25] = "\25",
	[26] = "\26",
	[27] = "\27",
	[28] = "\28",
	[29] = "\29",
	[30] = "\30",
	[31] = "\31",
	[32] = " ",
	[33] = "!",
	[34] = '"',
	[35] = "#",
	[36] = "$",
	[37] = "%",
	[38] = "&",
	[39] = "'",
	[40] = "(",
	[41] = ")",
	[42] = "*",
	[43] = "+",
	[44] = ",",
	[45] = "-",
	[46] = ".",
	[47] = "/",
	[48] = "0",
	[49] = "1",
	[50] = "2",
	[51] = "3",
	[52] = "4",
	[53] = "5",
	[54] = "6",
	[55] = "7",
	[56] = "8",
	[57] = "9",
	[58] = ":",
	[59] = ";",
	[60] = "<",
	[61] = "=",
	[62] = ">",
	[63] = "?",
	[64] = "@",
	[65] = "A",
	[66] = "B",
	[67] = "C",
	[68] = "D",
	[69] = "E",
	[70] = "F",
	[71] = "G",
	[72] = "H",
	[73] = "I",
	[74] = "J",
	[75] = "K",
	[76] = "L",
	[77] = "M",
	[78] = "N",
	[79] = "O",
	[80] = "P",
	[81] = "Q",
	[82] = "R",
	[83] = "S",
	[84] = "T",
	[85] = "U",
	[86] = "V",
	[87] = "W",
	[88] = "X",
	[89] = "Y",
	[90] = "Z",
	[91] = "[",
	[92] = "\\",
	[93] = "]",
	[94] = "^",
	[95] = "_",
	[96] = "`",
	[97] = "a",
	[98] = "b",
	[99] = "c",
	[100] = "d",
	[101] = "e",
	[102] = "f",
	[103] = "g",
	[104] = "h",
	[105] = "i",
	[106] = "j",
	[107] = "k",
	[108] = "l",
	[109] = "m",
	[110] = "n",
	[111] = "o",
	[112] = "p",
	[113] = "q",
	[114] = "r",
	[115] = "s",
	[116] = "t",
	[117] = "u",
	[118] = "v",
	[119] = "w",
	[120] = "x",
	[121] = "y",
	[122] = "z",
	[123] = "{",
	[124] = "|",
	[125] = "}",
	[126] = "~",
	[127] = "\127",
	[128] = "\128",
	[129] = "\129",
	[130] = "\130",
	[131] = "\131",
	[132] = "\132",
	[133] = "\133",
	[134] = "\134",
	[135] = "\135",
	[136] = "\136",
	[137] = "\137",
	[138] = "\138",
	[139] = "\139",
	[140] = "\140",
	[141] = "\141",
	[142] = "\142",
	[143] = "\143",
	[144] = "\144",
	[145] = "\145",
	[146] = "\146",
	[147] = "\147",
	[148] = "\148",
	[149] = "\149",
	[150] = "\150",
	[151] = "\151",
	[152] = "\152",
	[153] = "\153",
	[154] = "\154",
	[155] = "\155",
	[156] = "\156",
	[157] = "\157",
	[158] = "\158",
	[159] = "\159",
	[160] = "\160",
	[161] = "\161",
	[162] = "\162",
	[163] = "\163",
	[164] = "\164",
	[165] = "\165",
	[166] = "\166",
	[167] = "\167",
	[168] = "\168",
	[169] = "\169",
	[170] = "\170",
	[171] = "\171",
	[172] = "\172",
	[173] = "\173",
	[174] = "\174",
	[175] = "\175",
	[176] = "\176",
	[177] = "\177",
	[178] = "\178",
	[179] = "\179",
	[180] = "\180",
	[181] = "\181",
	[182] = "\182",
	[183] = "\183",
	[184] = "\184",
	[185] = "\185",
	[186] = "\186",
	[187] = "\187",
	[188] = "\188",
	[189] = "\189",
	[190] = "\190",
	[191] = "\191",
	[192] = "\192",
	[193] = "\193",
	[194] = "\194",
	[195] = "\195",
	[196] = "\196",
	[197] = "\197",
	[198] = "\198",
	[199] = "\199",
	[200] = "\200",
	[201] = "\201",
	[202] = "\202",
	[203] = "\203",
	[204] = "\204",
	[205] = "\205",
	[206] = "\206",
	[207] = "\207",
	[208] = "\208",
	[209] = "\209",
	[210] = "\210",
	[211] = "\211",
	[212] = "\212",
	[213] = "\213",
	[214] = "\214",
	[215] = "\215",
	[216] = "\216",
	[217] = "\217",
	[218] = "\218",
	[219] = "\219",
	[220] = "\220",
	[221] = "\221",
	[222] = "\222",
	[223] = "\223",
	[224] = "\224",
	[225] = "\225",
	[226] = "\226",
	[227] = "\227",
	[228] = "\228",
	[229] = "\229",
	[230] = "\230",
	[231] = "\231",
	[232] = "\232",
	[233] = "\233",
	[234] = "\234",
	[235] = "\235",
	[236] = "\236",
	[237] = "\237",
	[238] = "\238",
	[239] = "\239",
	[240] = "\240",
	[241] = "\241",
	[242] = "\242",
	[243] = "\243",
	[244] = "\244",
	[245] = "\245",
	[246] = "\246",
	[247] = "\247",
	[248] = "\248",
	[249] = "\249",
	[250] = "\250",
	[251] = "\251",
	[252] = "\252",
	[253] = "\253",
	[254] = "\254",
	[255] = "\255",
}

local function string_byte(char)
	for byte, ch in next, ascii_table do
		if ch == char then
			return byte
		end
	end
	return nil
end

local function string_char(byte)
	return ascii_table[byte] or nil
end

local floor = function(x)
	return x - x % 1
end

local function bxor(a, b)
	local result = 0
	local shift = 0

	while a > 0 or b > 0 do
		local bit_a = a % 2
		local bit_b = b % 2

		result = result + ((bit_a ~= bit_b and 1 or 0) * (2 ^ shift))

		a = floor(a / 2)
		b = floor(b / 2)
		shift = shift + 1
	end

	return result
end

local formatcipher = function(str)
	return "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" .. str .. "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
end

local function table_insert(tbl, val, pos)
	if pos == nil then
		pos = #tbl + 1
	end
	for i = #tbl, pos, -1 do
		tbl[i + 1] = tbl[i]
	end
	tbl[pos] = val
end

local function table_concat(tbl, sep, start, stop)
	sep = sep or ""
	start = start or 1
	stop = stop or #tbl
	local result = ""
	for i = start, stop do
		if i > start then
			result = result .. sep
		end
		result = result .. tbl[i]
	end
	return result
end

local function encipher(text, key)
	local enciphered = {}
	local key_length = #key
	for i = 1, #text do
		local char = string.sub(text, i, i)
		local ascii = string_byte(char)
		local key_char = string.sub(key, (i - 1) % key_length + 1, (i - 1) % key_length + 1)
		local key_ascii = string_byte(key_char)
		local enc_char = (bxor(ascii, key_ascii) + 128) % 256
		table_insert(enciphered, string_char(enc_char))
	end

	return table_concat(enciphered)
end

-------------------------------------------------------------------------------
-- request
-------------------------------------------------------------------------------

local proreq = function(tbl)
	return req(setmetatable({}, {
		__index = function(Self, Index)
			if Index == "Url" then
				return tbl.Url
			elseif Index == "Method" then
				return tbl.Method
			elseif Index == "Body" then
				return setmetatable({}, { -- U might wanna remove this
					__tostring = function()
						return Kick("TT")
					end,
					__index = function(Self, Index)
						return tbl.Body[Index]
					end,
				})
			elseif Index == "Headers" then
				return tbl.Headers
			elseif Index == "Cookies" then
				return tbl.Cookies
			end
		end,
		__tostring = function()
			return Kick("TT")
		end,
	}))
end

-------------------------------------------------------------------------------
-- pro anti tamper
-------------------------------------------------------------------------------

local CStackOverflow = function(Func, Offset)
	for i = 1, 200 - Offset do
		Func = coroutine.wrap(Func)
	end
	return Func
end

task.spawn(function()
	while task.wait(0.1) do
		local success, err = pcall(CStackOverflow(request, 3))
		if success then
			return Kick("MA 2")
		elseif not err then
			return Kick("MA 1")
		else
			if err == "C stack overflow" then
				return Kick("HF 2")
			end
		end
	end
end)

local ExploitingGame = getgenv().game
local EXPGMT = getrawmetatable(ExploitingGame)

local loopcount = 0
-- -- Game env checks
task.spawn(function()
	while task.wait(5) do
		if ExploitingGame == GetGameENV().game then
			if type(ExploitingGame) == "userdata" then
				if VM.type(EXPGMT) == "table" then
					if EXPGMT == getrawmetatable(workspace) then
						if not getrawmetatable(EXPGMT) then
							if VM.type(EXPGMT.__index) == "function" then
								if not islclosure(EXPGMT.__index) then
								else
									Kick("Detected [7]")
									if true then
										return
									end
									return
								end
							else
								Kick("Detected [6]")
								if true then
									return
								end
								return
							end
						else
							Kick("Detected [5]")
							if true then
								return
							end
							return
						end
					else
						Kick("Detected [4]")
						if true then
							return
						end
						return
					end
				else
					Kick("Detected [3]")
					if true then
						return
					end
					return
				end
			else
				Kick("Detected [2]")
				if true then
					return
				end
				return
			end
		else
			Kick("Detected [1]")
			if true then
				return
			end
			return
		end
		if not ishooked(request) then
		else
			Kick("Detected [8]")
			if true then
				return
			end
			return
		end
	end
	loopran = true
	loopcount = loopcount + 1
end)

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

getgenv().LibVersion = "1.0.0"

local KeyGuardian = {}

local Settings = {}

local Result = {}

KeyGuardian.Set = function(settings)
	Settings.ServiceToken = settings.ServiceToken
	Settings.PrivateToken = settings.PrivateToken
	warn("=======================================")
	warn("Welcome to KeyGuardian !")
	warn("Library Version: " .. (getgenv().LibVersion or "2.0.0"))
	warn("Executor : " .. tostring(identifyexecutor()))
	warn("Status : online")
	warn("=======================================")
end

local CheckResponse = function(Data)
	if Data["statusCode"] == 404 then
		return false
	end
	if
		Data.message == "KEY_NOT_FOUND"
		or Data.message == "KEY_NOT_COMPLETED"
		or Data.message == "KEY_EXPIRED"
		or Data.message == "KEY_INVALID_HWID"
		or Data.message == "KEY_BANNED"
		or Data.message == "KEY_BLACKLISTED"
	then
		return self.falseData
	end
end

KeyGuardian.GetService = function()
	return json.decode(proreq({
		Url = "https://keyguardian.org/api/services/public/get/" .. Settings.ServiceToken,
		Method = "GET",
		Headers = {
			["Executor"] = identifyexecutor(),
		},
	}).Body)
end

KeyGuardian.GetKeylink = function()
	return "https://keyguardian.org/a/" .. KeyGuardian.GetService().id .. "?id=" .. gethardwareid()
end
local SetKey
KeyGuardian.ValidateKey = function(_, Key)
	SetKey = Key
	local response = proreq({
		Url = "https://keyguardian.org/api/whitelist/v2/validate/default-key/"
			.. Settings["ServiceToken"]
			.. "/"
			.. Key
			.. "/"
			.. gethardwareid(),
		Method = "GET",
		Headers = {
			["Executor"] = identifyexecutor(),
		},
	}).Body
	local Data = json.decode(response)
	if CheckResponse(Data) then
		return CheckResponse(Data)
	end
	if encipher(formatcipher(Settings["PrivateToken"]), formatcipher(Key)) == Data.message then
		local MC, KC = 0, 0
		setmetatable(Result, {
			__index = function(Self, Index)
				if Index == "Mode" then
					MC = MC + 1
					if MC <= 1 then
						return "Default"
					else
						return "Invalid"
					end
				elseif Index == "Key" then
					KC = KC + 1
					if KC == 1 then
						return Key
					else
						return "Invalid"
					end
				end
			end,
			__eq = function()
				return false
			end,
			__tostring = function()
				return Kick("TT")
			end,
		})
		Result["Mode"] = "Default"
		return true
	else
		local response = proreq({
			Url = "https://keyguardian.org/api/whitelist/v2/validate/premium-key/"
				.. Settings["ServiceToken"]
				.. "/"
				.. Key
				.. "/"
				.. gethardwareid(),
			Method = "GET",
			Headers = {
				["Executor"] = identifyexecutor(),
			},
		}).Body
		local Data = json.decode(response)
		if CheckResponse(Data) then
			return CheckResponse(Data)
		end
		if encipher(formatcipher(Settings["PrivateToken"]), formatcipher(Key)) == Data.message then
			local MC, KC = 0, 0
			setmetatable(Result, {
				__index = function(Self, Index)
					if Index == "Mode" then
						MC = MC + 1
						if MC <= 1 then
							return "Premium"
						else
							return "Invalid"
						end
					elseif Index == "Key" then
						KC = KC + 1
						if KC == 1 then
							return Key
						else
							return "Invalid"
						end
					end
				end,
				__eq = function()
					return false
				end,
				__tostring = function()
					return Kick("TT")
				end,
			})
			return true
		else
			return false
		end
	end
end

KeyGuardian.Sanity = function()
	return "hi!"
end

local tbl = {}
local NP, NPC, SHAC = 0, 0, 0
if SetKey and KeyGuardian:ValidateKey(SetKey) then
	setfenv(KeyGuardian.Sanity, {
		["KeyGuardian"] = {
			["math.random"] = setmetatable({
				["os.time()"] = function()
					return tbl
				end,
				["tick"] = function()
					return tbl
				end,
			}, {
				__index = function(Self, Index)
					if Index == "RNG1" or Index == "RNG2" then
						return setmetatable({}, {
							__index = function()
								return tbl
							end,
							__div = function()
								return tbl
							end,
							__mul = function()
								return tbl
							end,
							__pow = function()
								return tbl
							end,
							__tostring = function()
								return Kick("TT")
							end,
						})
					end
				end,
			}),
			["Premium"] = setmetatable({}, {
				__index = function(Self, Index)
					if Index == "Value" then
						return tbl
					elseif Index == "NotPremium" then
						NPC = NPC + 1
						if NPC == 1 then
							return true
						else
							return false
						end
					end
				end,
				__tostring = function()
					return Kick("TT")
				end,
			}),
			["Done"] = setmetatable({}, {
				__tostring = function()
					return Kick("TT")
				end,
				__index = function()
					return tbl
				end,
				__call = function()
					return tbl
				end,
				__metatable = tbl,
				__mul = function()
					return tbl
				end,
				__div = function()
					return tbl
				end,
				__tostring = function()
					return Kick("TT")
				end,
			}),
			["SHA256"] = setmetatable({}, {
				__index = function(Self, Index)
					SHAC = SHAC + 1
					if SHAC == 1 or SHAC == 2 then
						return tbl
					elseif SHAC == 3 or SHAC == 4 then
						return KeyGuardian.Sanity
					end
				end,
				__tostring = function()
					return Kick("TT")
				end,
			}),
		},
	})

	local MTTBL = {}
	setmetatable(MTTBL, {
		__metatable = MTTBL,
	})
	local Func = function() end
	local AT, BT, CT = {}, {}, {}
	local ATC, BTC, CTC = 0, 0, 0
	setmetatable(AT, {
		__tostring = function()
			return Kick("TT")
		end,
		__index = function(Self, Index)
			ATC = ATC + 1
			print(ATC)
			if ATC == 1 then
				return 9
			elseif ATC == 2 then
				return 8
			elseif ATC == 3 then
				return (78 * 9 * 54 * 32 + 123 + 21) ^ 3 * 32
			elseif ATC == 4 then
				return 5
			elseif ATC == 5 then
				return 1
			elseif ATC == 6 then
				return 139
			elseif ATC == 7 then
				return 100
			elseif ATC == 8 then
				return "unexpected_value"
			elseif ATC == 9 then
				return 10
			elseif ATC == 10 then
				return 1
			elseif ATC == 11 or ATC == 12 or ATC == 13 or ATC == 14 then
				return 3
			elseif ATC == 15 then
				return error("")
			end
		end,
		__sub = function()
			return BT
		end,
		__concat = function()
			return BT
		end,
		__pow = function()
			return MTTBL
		end,
		__div = function()
			return MTTBL
		end,
		__metatable = MTTBL,
		__add = function()
			return BT
		end,
		__len = function()
			return 1
		end,
		__eq = function()
			return true
		end,
	})
	setmetatable(BT, {
		__tostring = function()
			return Kick("TT")
		end,
		__index = function(Self, Index)
			BTC = BTC + 1
			if BTC == 1 then
				return 81
			elseif BTC == 2 then
				return 1
			elseif BTC == 3 then
				return 1
			elseif BTC == 4 then
				return 10
			elseif BTC == 5 then
				return 1
			elseif BTC == 6 then
				return 1
			elseif BTC == 7 then
				return 100
			elseif BTC == 8 then
				return 1
			elseif BTC == 9 then
				return setmetatable({}, {
					__add = function()
						return BT
					end,
				})
			elseif BTC == 10 then
				return setmetatable({}, {
					__add = function()
						return getmetatable(BT)
					end,
				})
			elseif BTC == 11 or BTC == 12 then
				return setmetatable({}, {
					__add = function()
						return "KeyGuardian"
					end,
				})
			elseif BTC == 13 then
				return getfenv(KeyGuardian.Sanity)["KeyGuardian"]["Premium"]
			end
		end,
		__div = function()
			return MTTBL
		end,
		__len = function()
			return 1
		end,
		__mod = function()
			return BT
		end,
		__eq = function()
			return true
		end,
	})
	local CLEN = 0
	setmetatable(CT, {
		__tostring = function()
			return Kick("TT")
		end,
		__index = function(Self, Index)
			CTC = CTC + 1
			if CTC == 1 then
				return MTTBL
			elseif CTC == 2 then
				return "KeyGuardian"
			elseif CTC == 3 then
				return 100 % 778 * 562.3457708698953
			elseif CTC == 4 then
				return "KeyGuardian"
			elseif CTC == 5 then
				return 180
			elseif CTC == 6 then
				return "SanityCheck"
			elseif CTC == 7 then
				return BT
			elseif CTC == 8 then
				return 1
			end
		end,
		__lt = function()
			return true
		end,
		__pow = function()
			return MTTBL
		end,
		__sub = function()
			return BT
		end,
		__len = function()
			CLEN = CLEN + 1
			if CLEN == 4 or CLEN == 11 or CLEN == 12 then
				return 0
			end
			return 99999999999
		end,
		__div = function(a, b)
			return BT
		end,
		__eq = function()
			return true
		end,
	})

	KeyGuardian.Validated = true
	KeyGuardian.Checks = setmetatable({}, {
		__index = function(Self, Index)
			if Index == "EQ" then
				return function(Key)
					if KeyGuardian:ValidateKey(Key) then -- again for sec
						return AT, BT, CT
					end
				end
			end
		end,
		__tostring = function()
			return Kick("TT")
		end,
		__call = function()
			return "a"
		end,
	})
	KeyGuardian.Method = getmetatable(KeyGuardian.Checks).__index
else
	print("Invalid key or Setkey not found!!")
end

return KeyGuardian
