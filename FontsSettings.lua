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

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQInAAAACwADAEtAAABKwECBCkCAgEtAAABKQEGBCkAAgktAAABKwECBCkAAg0tAAABKAEKBCkCAg0tAAABKgEKBCkCAhEtAAABKwECBCkCAhUtAAABKwECBCkAAhktAAABKQEGBCkCAhktAAABKQEGBCkAAh0tAAABKwECBCkCAh0tAAABKQESBCkAAiEtAAABKwECBCkAAiQgAAIAfAIAAEwAAAAQKAAAAVXNlckNoZWNrAAQLAAAAYnJ1enluc2VubgAEBAAAAERheQAEBAAAADM2NgAECwAAAENvbXBicm9hcmsABAQAAAAwMjQABA8AAABDWUJFUkMwUk4wMjA3NwAEDQAAAM6XZWFydGJyb2tlbgAEBAAAADAyOQAEEQAAAEpNIE5ldmVyIEdpdmUgVXAABAQAAAAwMjUABAsAAABrcmFwb250aW5rAAQJAAAATWFkYTQ5MTAABAsAAABNzpFJTlNUzpFZAAQKAAAAUsSZc2NyaXB0AAQHAAAAUmh5bmFpAAQKAAAAVHNtU3VjY21hAAQEAAAAMDIzAAQGAAAAWW9uaWUAAAAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAA="),nil,"bt",_ENV))()
-- 0.16
