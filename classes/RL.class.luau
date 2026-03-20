-- RateLimit class in Luau
local RateLimit = {}
RateLimit.__index = RateLimit

-- Constructor
-- rate: number of requests
-- timeLimit: in seconds
function RateLimit.new(rate, timeLimit)
	local self = setmetatable({}, RateLimit)
	self.rate = rate
	self.timeLimit = timeLimit
	self.allowance = rate
	self.lastFilled = tick()   -- current time in seconds
	self.lastCheck = tick()
	return self
end

-- Records requests, returns true if allowed, false if exceeded
function RateLimit:consume(amount)
	local now = tick()
	local elapsed = now - self.lastFilled

	if elapsed >= self.timeLimit then
		self.allowance = self.rate
		self.lastFilled = now
	end

	self.allowance = self.allowance - amount
	self.lastCheck = now

	return self.allowance >= 0
end

function RateLimit:__tostring()
	return '{' .. `{script.Name}/instance/__tostring: rateLimit: {self.rate}, timeLimit: {self.timeLimit}, allowance: {self.allowance}, lastFilled: {self.lastFilled}, lastCheck: {self.lastCheck}` .. '}'
end

-- Example usage
-- local rl = RateLimit.new(100, 1)  -- 100 messages per second
-- for i = 1, 110 do
--     print(i, rl:record(1))
-- end

return RateLimit
