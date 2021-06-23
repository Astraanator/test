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
-- 0.73
