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

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIzAAAACwAEAEtAAABKwECBCkCAgEtAAABKQEGBCkAAgktAAABKwEGBCkAAg0tAAABKwEGBCkAAhEtAAABKgEKBCkCAhEtAAABKQEGBCkCAhUtAAABKwECBCkAAhktAAABKgEOBCkCAhktAAABKAESBCkCAh0tAAABKQEGBCkCAiEtAAABKQEGBCkAAiUtAAABKgEKBCkCAiUtAAABKgEKBCkAAiktAAABKQEGBCkCAiktAAABKwEWBCkAAi0tAAABKQEGBCkAAjAgAAIAfAIAAGQAAAAQKAAAAVXNlckNoZWNrAAQQAAAANCA4IGw1IEk2IDIzIDQyAAQEAAAARGF5AAQEAAAAMDMwAAQLAAAAYnJ1enluc2VubgAEBAAAADM2NgAECgAAAGNhanZwdGt4eAAEBAAAADAzNwAECQAAAENhbmVsb1JEAAQLAAAAQ29tcGJyb2FyawAEBAAAADAyNAAEDwAAAENZQkVSQzBSTjAyMDc3AAQJAAAAZGFuaWFsODEABA0AAADOl2VhcnRicm9rZW4ABAQAAAAwMjkABBEAAABKTSBOZXZlciBHaXZlIFVwAAQEAAAAMDI1AAQLAAAAa3JhcG9udGluawAECQAAAE1hZGE0OTEwAAQLAAAATc6RSU5TVM6RWQAECgAAAFLEmXNjcmlwdAAEBwAAAFJoeW5haQAECgAAAFRzbVN1Y2NtYQAEBAAAADAyMwAEBgAAAFlvbmllAAAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAA"),nil,"bt",_ENV))()
-- 0.21
