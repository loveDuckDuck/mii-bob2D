local time = os.time()
local index = 0
local val = 0

local max = 100000000
print("Max integer / 10000000 is: " .. max)

while index < max do
	local test = "test"
	if test == "test" then
		val = val + 1
	end
	index = index + 1
end

local elapsed = os.time() - time
print("Elapsed time: " .. elapsed .. " seconds")

table_test = {
	0,
	function()
		table_test[1] = table_test[1] + 1
	end,
}
index = 0

time = os.time()

while index < max do
	table_test[2]()
	index = index + 1
end
elapsed = os.time() - time
print("Elapsed time with table function: " .. elapsed .. " seconds")
