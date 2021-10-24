-- [ AutoUpdate ]
local Version = 4
do  
    local function AutoUpdate()
		local file_name = "PussyAntiMelee.lua"
		local url = "http://raw.githubusercontent.com/Astraanator/test/main/Champions/PussyAntiMelee.lua"        
        local web_version = http:get("http://raw.githubusercontent.com/Astraanator/test/main/Champions/PussyAntiMelee.version")
        console:log("AntiMelee.Lua Vers: "..Version)
		console:log("AntiMelee.Web Vers: "..tonumber(web_version))
		if tonumber(web_version) == Version then
            console:log("PussyAntiMelee successfully loaded.....")
        else
			http:download_file(url, file_name)
            console:log("New PussyAntiMelee Update available.....")
			console:log("Please reload via F5.....")
        end
    
    end	   
    AutoUpdate()
end
