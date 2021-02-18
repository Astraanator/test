local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function Base64Decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

assert(load(Base64Decode("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"),nil,"bt",_ENV))()
-- 0.50
