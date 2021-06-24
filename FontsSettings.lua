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
-- 0.77
