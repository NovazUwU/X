positions = {
    [11468159863] = {
        ["Nomay Village"] = Vector3.new(3562.02392578125, 673.1098022460938, -2109.1650390625), 
        ["Mugen Train"] = Vector3.new(783.81005859375, 497.2205810546875, 900.3319091796875), 
        ["Wop City"] = Vector3.new(-31.218017578125, 601.2758178710938, -431.30999755859375),
        ["Village 2"] = Vector3.new(1215.5260009765625, 569.3946533203125, 95.47900390625),
        ["Cave 1"] = Vector3.new(4252.93798828125, 673.673095703125, 581.1719970703125),
        ["Cave 2"] = Vector3.new(1182.692138671875, 487.3731689453125, -1192.2979736328125),
        ["Mist Trainer Location"] = Vector3.new(4324.73486328125, 673.032470703125, -569.1719970703125),
        ["Akaza Cave"] = Vector3.new(1902.86083984375, 556.0686645507812, -150.78199768066406),
        ["Frozen Lake"] = Vector3.new(2049.285888671875, 483.02081298828125, -769.8250122070312),
        ["Beast Cave"] = Vector3.new(1840.259033203125, 483.6178283691406, 37.3060302734375), 
        ["Wop's Training Grounds"] = Vector3.new(223.949951171875, 597.646240234375, 483.4229736328125), 
    }, 
    ["Map 1"] = {
        
    }
}

table.sort(positions)

local old 
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if (not checkcaller()) and self == Player and getnamecallmethod():lower() == "kick" then 
        return 
    end 
    if (not checkcaller() and self.Name:match("moddel")) then 
        return 
    end 
    return old(self, ...)
end))

if game.ReplicatedStorage:FindFirstChild("Remotes") and game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("getclientping") then 
    game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("getclientping").OnClientInvoke = function(Novaz5792) 
        task.wait(5)
        return true 
    end 
end 

clans = {}
rarities = {"Common", "UnCommon", "Rare", "Legendary", "Mythic", "Supreme"} 

for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Global["Random_Clan_Picker"])) do 
    if table.find(rarities, i) then 
        for i1,v1 in pairs(v) do 
            table.insert(clans, v1)
        end 
    end 
end 

demonarts = {}

for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Global["Random_Demon_Art_Picker"]).Demon_Arts) do 
    if v ~= "None" then 
        table.insert(demonarts, v)
    end 
end 

bossnames = {}

if Workspace:FindFirstChild("Mobs") and Workspace.Mobs:FindFirstChild("Bosses") then 
    for i,v in pairs(Workspace.Mobs.Bosses:GetChildren()) do 
        if v:FindFirstChild("Npc_Configuration") then 
            table.insert(bossnames, require(v.Npc_Configuration).Name) 
        end 
        for i1,v1 in pairs(v:GetChildren()) do 
            if v1:FindFirstChild("Npc_Configuration") then 
                table.insert(bossnames, require(v1.Npc_Configuration).Name)
            end 
        end 
    end 
end 

mobnames = {}

if Workspace:FindFirstChild("Mobs") then 
    for i,v in pairs(Workspace.Mobs:GetDescendants()) do 
        if (Workspace.Mobs:FindFirstChild("Bosses") and (not v:IsDescendantOf(Workspace.Mobs.Bosses))) or true then 
            if v:FindFirstChild("Npc_Configuration") and (not table.find(mobnames, require(v.Npc_Configuration).Name)) and (not table.find(bossnames, require(v.Npc_Configuration).Name)) then 
                table.insert(mobnames, require(v.Npc_Configuration).Name)
            end 
        end 
    end 
end 


mobs = {} 

if Workspace:FindFirstChild("Mobs") then 
    for i,v in pairs(Workspace.Mobs:GetDescendants()) do 
        if v:FindFirstChild("Npc_Configuration") and v:FindFirstChild("Npc_Configuration"):IsA("ModuleScript") then
            local modu = require(v.Npc_Configuration) 
            table.insert(mobs, {v, modu.Npc_Spawning.Spawn_Locations[1] or modu.Npc_Spawning.Spawn_Locations, modu.Name})
        end 
        if v.Parent:FindFirstChild("Npc_Configuration") and v.Parent:FindFirstChild("Npc_Configuration"):IsA("ModuleScript") then
            local modu = require(v.Parent.Npc_Configuration) 
            table.insert(mobs, {v.Parent, modu.Npc_Spawning.Spawn_Locations[1] or modu.Npc_Spawning.Spawn_Locations, modu.Name})
        end 
    end 
        
    Workspace.Mobs.DescendantAdded:Connect(function(v)
        if v:FindFirstChild("Npc_Configuration") and v:FindFirstChild("Npc_Configuration"):IsA("ModuleScript") then
            local modu = require(v.Npc_Configuration) 
            table.insert(mobs, {v, modu.Npc_Spawning.Spawn_Locations[1] or modu.Npc_Spawning.Spawn_Locations, modu.Name})
        end 
        if v.Parent:FindFirstChild("Npc_Configuration") and v.Parent:FindFirstChild("Npc_Configuration"):IsA("ModuleScript") then
            local modu = require(v.Parent.Npc_Configuration) 
            table.insert(mobs, {v.Parent, modu.Npc_Spawning.Spawn_Locations[1] or modu.Npc_Spawning.Spawn_Locations, modu.Name})
        end
    end)
        
    Workspace.Mobs.DescendantRemoving:Connect(function(v)
        if v:IsA("Configuration") then 
            for i1,v1 in ipairs(mobs) do 
                if v1[1] == v then 
                    table.remove(mobs, i1)
                end 
            end 
        end
    end)
end

function getclosestmob()
    local ret = {{nil, Vector3.new()}, Huge} 
    for i,v in pairs(mobs) do
        local model = v[1]:FindFirstChildOfClass("Model")
        if model and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 then  
            local combined = {}
            if bossess and #bossess > 0 then 
                for i,v in pairs(bossess) do 
                    table.insert(combined, v)
                end 
            end 
            if mobss and #mobss > 0 then 
                for i,v in pairs(mobss) do 
                    table.insert(combined, v)
                end 
            end 
            if combined and #combined > 0 and (not table.find(combined, require(v[1].Npc_Configuration).Name)) then 
                continue 
            end 
            if model:FindFirstChild("HumanoidRootPart") and v[2] then 
                local magnitude1 = (HumanoidRootPart.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude
                if magnitude1 < ret[2] then 
                    ret[2] = magnitude1 
                    ret[1][1] = model 
                    ret[1][2] = v[2]
                end 
            elseif v[2] then
                local magnitude = (HumanoidRootPart.Position - v[2]).Magnitude 
                if magnitude < ret[2] then 
                    ret[2] = magnitude 
                    ret[1][1] = model 
                    ret[1][2] = v[2] 
                end 
            end 
        end 
    end
    return ret[1]
end 

function getclosestplayer()
    local ret = {nil, Huge}
    for i,v in pairs(Players:GetPlayers()) do 
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (not v.Character:FindFirstChild("ForceField")) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("UpperTorso") and (not v.Character.UpperTorso:FindFirstChild("Revive_Humanoid")) then 
            if plrw and table.find(plrw, v) then 
                continue 
            end 
            local magnitude = (HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude 
            if magnitude < ret[2] then 
                ret[2] = magnitude 
                ret[1] = v 
            end 
        end 
    end 
    return ret[1]
end 

Stepped:Connect(function()
    if autofarm or autocollectmoneybags or paff or autofarmmugen then 
        for i,v in pairs(Character:GetChildren()) do 
            if v.IsA(v, "BasePart") and v.CanCollide then 
                v.CanCollide = false 
            end 
        end 
        HumanoidRootPart.Velocity = Vector3.zero
    end 
        
    if math.floor(ws) ~= 16 then 
        Humanoid.WalkSpeed = ws 
    end 
        
    if math.floor(jp) ~= 50 then 
        Humanoid.JumpPower = jp 
    end 
end)

local oldmt55
oldmt55 = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    if (not checkcaller()) and (killaura or autofarmmugen) and (self.Name == "Handle_Initiate_S" or self.Name == "Handle_Initiate_S_") and args[2] == Player and args[3] == Character then 
        return 
    end 
    return oldmt55(self, ...)
end))
