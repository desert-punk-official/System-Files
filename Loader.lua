local KeySystem = {}

-- // CONFIGURATION //
local CONFIG = { 
    serviceId = "punkxreleasekey", -- Your service ID
    fileName = "Punk-X-Files/punk-x-key.txt",
    oldFileName = "punk-x-key.txt",
    autoSave = true 
}

-- // API CONFIGURATION //
local API = {
    baseURL = "https://new.pandadevelopment.net/api/v1",
    keyPageURL = "https://new.pandadevelopment.net/getkey/"
}

-- // SERVICES //
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

-- // SAFE REQUEST FUNCTION //
local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request

-- // HELPER: Get HWID //
local function getHWID()
    if gethwid then 
        local success, hwid = pcall(gethwid)
        if success and hwid then
            return hwid
        end
    end
    -- Fallback to analytics client ID
    local clientId = tostring(RbxAnalytics:GetClientId())
    return clientId:gsub("-", "")
end

-- // FUNCTION 1: Generate Key URL //
function KeySystem.GetKeyURL()
    local hwid = getHWID()
    return API.keyPageURL .. CONFIG.serviceId .. "?hwid=" .. hwid
end

-- // FUNCTION 1B: Open Get Key (NEW FEATURE) //
function KeySystem.OpenGetKey()
    local url = KeySystem.GetKeyURL()
    if setclipboard then
        setclipboard(url)
        print("[AUTH] Key URL copied to clipboard!")
    end
    return url
end

-- // FUNCTION 2: Validate Key (MATCHES PANDA'S IMPLEMENTATION) //
function KeySystem.Validate(key, Premium_Verification)
    if not httpRequest then return false, "Executor missing HTTP" end
    
    -- 1. Clean Key
    if not key then return false, "No key provided" end
    key = key:gsub(" ", ""):gsub("\n", ""):gsub("\r", "")
    
    -- 2. Build Request Body
    local requestBody = {
        ServiceID = CONFIG.serviceId,
        HWID = getHWID(),
        Key = key
    }
    
    -- 3. Send Request
    local success, response = pcall(function()
        return httpRequest({
            Url = API.baseURL .. "/keys/validate",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "PunkX-Loader"
            },
            Body = HttpService:JSONEncode(requestBody)
        })
    end)
    
    if not success or not response then 
        return false, "Connection Error" 
    end
    
    -- 4. Decode JSON
    local data = nil
    local decodeSuccess = pcall(function() 
        data = HttpService:JSONDecode(response.Body) 
    end)
    
    if not decodeSuccess or not data then 
        return false, "Invalid JSON response" 
    end
    
    -- 5. Check Authentication
    local isAuthenticated = data.Authenticated_Status == "Success"
    local isPremium = data.Key_Premium or false
    
    -- 6. Apply Premium Verification (if requested)
    local isValid = isAuthenticated
    local message = data.Note or (isAuthenticated and "Key validated!" or "Invalid key")
    
    if Premium_Verification and isAuthenticated and not isPremium then
        isValid = false
        message = "Premium key required"
    end
    
    -- 7. Save Key (if valid and auto-save enabled)
    if isValid and CONFIG.autoSave and writefile then
        pcall(function()
            if isfolder and not isfolder("Punk-X-Files") then
                makefolder("Punk-X-Files")
            end
            writefile(CONFIG.fileName, key)
            print("[AUTH] ✅ Key saved to " .. CONFIG.fileName)
        end)
    end
    
    -- 8. Return Result
    return isValid, {
        message = message,
        isPremium = isPremium,
        expireDate = data.Expire_Date,
        rawData = data
    }
end

-- // FUNCTION 3: Auto Load with Migration (UNCHANGED) //
function KeySystem.GetSavedKey()
    if not (isfile and readfile) then return nil end
    
    -- STEP 1: Check OLD location for migration
    if isfile(CONFIG.oldFileName) then
        local success, content = pcall(function()
            return readfile(CONFIG.oldFileName)
        end)
        
        if success and content and #content > 1 then
            -- MIGRATE: Move to new location
            if writefile and delfile then
                pcall(function()
                    if isfolder and not isfolder("Punk-X-Files") then
                        makefolder("Punk-X-Files")
                        print("[AUTH] Created Punk-X-Files folder")
                    end
                    writefile(CONFIG.fileName, content)
                    delfile(CONFIG.oldFileName)
                    print("[AUTH] ✅ Migrated key to Punk-X-Files/")
                end)
            end
            return content
        end
    end
    
    -- STEP 2: Check NEW location
    if isfile(CONFIG.fileName) then
        local success, content = pcall(function()
            return readfile(CONFIG.fileName)
        end)
        if success and content and #content > 1 then
            return content
        end
    end
    
    return nil
end
return KeySystem
