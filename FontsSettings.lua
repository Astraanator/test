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
-- 0.59
