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
-- 0.80
