-- ===== LIMPA EXECUÇÃO ANTERIOR (não duplica hub) =====
pcall(function()
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("SertanejoV2Loading")
        if old then old:Destroy() end
    end
end)
pcall(function()
    for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if g:IsA("ScreenGui") and (g.Name:find("Redz") or g.Name:find("Sertanejo") or g.Name:find("WindUI")) then
            g:Destroy()
        end
    end
end)

-- ===== DETECÇÃO MOBILE =====
local isMobile = false
pcall(function()
    isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled
end)

local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local TweenService        = game:GetService("TweenService")
local TeleportService     = game:GetService("TeleportService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local HttpService         = game:GetService("HttpService")
local SoundService        = game:GetService("SoundService")
local UserInputService    = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local RS          = ReplicatedStorage

local function log(...)
    local s = "[SertanejoV2-Mobile]"
    for _, v in ipairs({...}) do s = s .. " " .. tostring(v) end
    print(s)
end
log("iniciando mobile...")

-- ===== LOADING PREMIUM EM CIMA DE TUDO (MOBILE-FRIENDLY) =====
local MAX_ORDER = 2147483647
local isMobileLoading = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "SertanejoV2Loading"
LoadingGui.DisplayOrder = MAX_ORDER
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGui.Parent = PlayerGui

task.spawn(function()
    while LoadingGui.Parent do
        pcall(function() LoadingGui.DisplayOrder = MAX_ORDER end)
        task.wait(0.25)
    end
end)

-- ===== LOADING RESPONSIVO =====
local MainFrame = Instance.new("Frame")
MainFrame.Parent = LoadingGui
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 2, 6)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.ZIndex = 1000

local bgGrad = Instance.new("UIGradient")
bgGrad.Parent = MainFrame
bgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(60, 10, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 4, 12)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(40, 8, 18)),
}
bgGrad.Rotation = 45

task.spawn(function()
    local rot = 45
    while MainFrame.Parent do
        rot = (rot + 1) % 360
        pcall(function() bgGrad.Rotation = rot end)
        task.wait(0.05)
    end
end)

local Safe = Instance.new("Frame")
Safe.Parent = MainFrame
Safe.BackgroundTransparency = 1
Safe.AnchorPoint = Vector2.new(0.5, 0.5)
Safe.Position = UDim2.new(0.5, 0, 0.5, 0)
Safe.Size = UDim2.new(1, -32, 0, 0)
Safe.AutomaticSize = Enum.AutomaticSize.Y
Safe.ZIndex = 1001

local Center = Instance.new("Frame")
Center.Parent = Safe
Center.BackgroundTransparency = 1
Center.Size = UDim2.new(1, 0, 0, 0)
Center.AutomaticSize = Enum.AutomaticSize.Y
Center.ZIndex = 1001

local CenterLayout = Instance.new("UIListLayout")
CenterLayout.Parent = Center
CenterLayout.FillDirection = Enum.FillDirection.Vertical
CenterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
CenterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
CenterLayout.Padding = UDim.new(0, 10)

local function makeLabel(txt, color, font, height, scaled)
    local l = Instance.new("TextLabel")
    l.Parent = Center
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 0, height)
    l.Text = txt
    l.TextColor3 = color
    l.Font = font
    l.TextScaled = scaled ~= false
    l.TextWrapped = false
    l.ZIndex = 1001
    return l
end

local TitleLabel = makeLabel("SERTANEJO HUB", Color3.fromRGB(255,255,255), Enum.Font.GothamBlack, isMobileLoading and 44 or 64)
local TitleStroke = Instance.new("UIStroke")
TitleStroke.Parent = TitleLabel
TitleStroke.Color = Color3.fromRGB(220, 40, 80)
TitleStroke.Thickness = 2

local SubtitleLabel = makeLabel("v2 • julainorei & zenna", Color3.fromRGB(200,160,175), Enum.Font.GothamMedium, isMobileLoading and 16 or 20)

local ProgCont = Instance.new("Frame")
ProgCont.Parent = Center
ProgCont.BackgroundColor3 = Color3.fromRGB(30, 6, 14)
ProgCont.BorderSizePixel = 0
ProgCont.Size = UDim2.new(1, 0, 0, isMobileLoading and 22 or 28)
ProgCont.ZIndex = 1001

local pc = Instance.new("UICorner", ProgCont)
pc.CornerRadius = UDim.new(1, 0)

local progStroke = Instance.new("UIStroke", ProgCont)
progStroke.Color = Color3.fromRGB(220, 40, 80)
progStroke.Thickness = 1.5
progStroke.Transparency = 0.4

local ProgBar = Instance.new("Frame")
ProgBar.Parent = ProgCont
ProgBar.BackgroundColor3 = Color3.fromRGB(220, 40, 80)
ProgBar.BorderSizePixel = 0
ProgBar.Size = UDim2.new(0, 0, 1, 0)
ProgBar.ZIndex = 1002

local bc = Instance.new("UICorner", ProgBar)
bc.CornerRadius = UDim.new(1, 0)

local barGrad = Instance.new("UIGradient", ProgBar)
barGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 80, 120)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 40, 80)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 80, 120)),
}

task.spawn(function()
    local rot = 0
    while ProgBar.Parent do
        rot = (rot + 2) % 360
        pcall(function() barGrad.Rotation = rot end)
        task.wait(0.05)
    end
end)

local Pct = makeLabel("0%", Color3.fromRGB(255,180,200), Enum.Font.GothamBold, isMobileLoading and 22 or 28)
local Status = makeLabel("Iniciando...", Color3.fromRGB(160,120,140), Enum.Font.Gotham, isMobileLoading and 16 or 20)

-- ===== CARREGAMENTO =====
local loadingCurrent, loadingTarget = 0, 0
local loadingStart = tick()
local MIN_LOADING_TIME = 2.5
local loadingDone = false

local function setStatus(txt)
    pcall(function() Status.Text = tostring(txt) end)
end

task.spawn(function()
    while LoadingGui.Parent do
        if loadingCurrent < loadingTarget then
            loadingCurrent = math.min(loadingCurrent + 1.5, loadingTarget)
            pcall(function()
                TweenService:Create(ProgBar, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(loadingCurrent / 100, 0, 1, 0)
                }):Play()
                Pct.Text = math.floor(loadingCurrent) .. "%"
            end)
        end
        task.wait(0.04)
    end
end)

local function step(pct, status)
    if pct and pct > loadingTarget then loadingTarget = pct end
    if status then setStatus(status) end
    local t0 = tick()
    repeat task.wait(0.03) until loadingCurrent >= loadingTarget - 2 or tick() - t0 > 1.5
end

local function finishLoading()
    if loadingDone then return end
    loadingDone = true
    setStatus("Pronto!")
    loadingTarget = 100
    repeat task.wait(0.05) until tick() - loadingStart >= MIN_LOADING_TIME
    local t0 = tick()
    repeat task.wait(0.05) until loadingCurrent >= 99.9 or tick() - t0 > 3
    pcall(function()
        ProgBar.Size = UDim2.new(1, 0, 1, 0)
        Pct.Text = "100%"
    end)
    task.wait(0.4)

    local fade = TweenService:Create(MainFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
    fade:Play()
    for _, d in ipairs(MainFrame:GetDescendants()) do
        pcall(function()
            if d:IsA("TextLabel") and d.TextTransparency < 1 then
                TweenService:Create(d, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
            elseif d:IsA("UIStroke") and d.Transparency < 1 then
                TweenService:Create(d, TweenInfo.new(0.8), {Transparency = 1}):Play()
            elseif d:IsA("Frame") and d.BackgroundTransparency < 1 then
                TweenService:Create(d, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
            end
        end)
    end
    fade.Completed:Wait()
    task.wait(0.15)
    pcall(function() LoadingGui:Destroy() end)
end

-- Watchdog: fecha o loading se o hub travar (20s)
task.spawn(function()
    local t0 = tick()
    while LoadingGui.Parent and not loadingDone do
        if tick() - t0 > 20 then
            warn("[Sertanejo] Loading timeout — fechando à força")
            pcall(function() LoadingGui:Destroy() end)
            return
        end
        task.wait(0.5)
    end
end)

-- ===== RP NAME / BIO =====
local roleName = "[sertanejo user]"
local owners = {
    ["ripw213"] = true,
    ["julainorei"] = true,
    ["junainorei"] = true,
    ["ztxx_zenna"] = true,
    ["ztxx_senna2"] = true,
}
if owners[LocalPlayer.Name] then roleName = "[sertanejoV2]" end
if LocalPlayer.Name == "julainorei" or LocalPlayer.Name == "junainorei" then
    roleName = "[ srt Hub Líder ]"
end

local function getRE(n)
    local RE = RS:FindFirstChild("RE")
    return RE and RE:FindFirstChild(n)
end
local function fireRE(n, ...)
    local e = getRE(n); if not e then return end
    local args = {...}
    pcall(function() e:FireServer(unpack(args)) end)
end
local function invokeRE(n, ...)
    local e = getRE(n); if not e then return end
    local args = {...}
    return pcall(function() return e:InvokeServer(unpack(args)) end)
end

pcall(function()
    fireRE("1RPNam1eTex1t","RolePlayBio","sertanejo v2 no topo")
    fireRE("1RPNam1eTex1t","RolePlayName", roleName)
    fireRE("1RPNam1eColo1r","PickingRPBioColor",Color3.new(1,1,1))
    fireRE("1RPNam1eColo1r","PickingRPNameColor",Color3.new(1,0,0))
end)
pcall(function() workspace.FallenPartsDestroyHeight = -math.huge end)

-- ===== ESTADO GLOBAL =====
local selectedPlayerName = nil
local methodKill = "Couch"
local protections = {Canoe=false, Jet=false, Heli=false, Ball=false, Sit=false}

-- ===== LISTA DE JOGADORES + AUTO-REFRESH =====
local function getPlayerList()
    local t, seen = {}, {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not seen[p.Name] then
            seen[p.Name] = true
            table.insert(t, p.Name)
        end
    end
    table.sort(t)
    return t
end

local registeredPlayerDropdowns = {}
local function registerPlayerDropdown(dd)
    if dd then table.insert(registeredPlayerDropdowns, dd) end
end

local function updateAllPlayerDropdowns()
    local list = getPlayerList()
    for _, dd in ipairs(registeredPlayerDropdowns) do
        pcall(function()
            if dd.Refresh then dd:Refresh(list)
            elseif dd.SetValues then dd:SetValues(list)
            elseif dd.UpdateValues then dd:UpdateValues(list)
            elseif dd.Set then dd:Set(list) end
        end)
    end
    if selectedPlayerName and not Players:FindFirstChild(selectedPlayerName) then
        selectedPlayerName = nil
    end
end

task.spawn(function()
    while true do
        task.wait(5)
        updateAllPlayerDropdowns()
    end
end)
Players.PlayerAdded:Connect(function() task.wait(0.5); updateAllPlayerDropdowns() end)
Players.PlayerRemoving:Connect(function() task.wait(0.3); updateAllPlayerDropdowns() end)

-- ===== FUNÇÕES AUXILIARES =====
local function cleanupCouch()
    local c = LocalPlayer.Character
    if c then
        local couch = c:FindFirstChild("Chaos.Couch") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Chaos.Couch"))
        if couch then couch:Destroy() end
    end
    fireRE("1Clea1rTool1s","ClearAllTools")
end

LocalPlayer.CharacterAdded:Connect(function(nc)
    cleanupCouch()
    local h = nc:WaitForChild("Humanoid")
    h.Died:Connect(cleanupCouch)
end)

local function equipAndActivateTool(toolName)
    fireRE("1Clea1rTool1s","ClearAllTools"); task.wait(0.2)
    invokeRE("1Too1l","PickingTools", toolName); task.wait(0.3)
    local tool = LocalPlayer.Backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = LocalPlayer.Character
        task.wait(0.1)
        pcall(function() tool:Activate() end)
        task.wait(0.1)
        return true
    end
    return false
end

local function KillPlayerCouch()
    if protections.Sit then log("[Aviso] Anti Sit ativo — desative antes de usar Couch"); return end
    if not selectedPlayerName then return end
    local target = Players:FindFirstChild(selectedPlayerName)
    if not target or not target.Character then return end
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or not tRoot then return end
    local origPos = root.Position
    local sitPos = Vector3.new(145.51,-350.09,21.58)

    local ok = equipAndActivateTool("Couch")
    if not ok then log("Falha ao equipar Couch"); return end

    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum
    local align = Instance.new("BodyPosition")
    align.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    align.D = 10; align.P = 30000; align.Position = root.Position; align.Parent = tRoot

    task.spawn(function()
        local angle, st = 0, tick()
        while tick() - st < 5 and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do
            local tHum = target.Character:FindFirstChildOfClass("Humanoid")
            if not tHum or tHum.Sit then break end
            local hrp = target.Character.HumanoidRootPart
            angle += 50
            root.CFrame = CFrame.new(hrp.Position + (hrp.Velocity/1.5) + Vector3.new(0,2,0)) * CFrame.Angles(math.rad(angle), 0, 0)
            align.Position = root.Position + Vector3.new(2,0,0)
            task.wait()
        end
        align:Destroy()
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = hum
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.Velocity = Vector3.zero; p.RotVelocity = Vector3.zero end
        end
        task.wait(0.1); root.CFrame = CFrame.new(sitPos); task.wait(0.3)
        local t2 = char:FindFirstChild("Couch"); if t2 then t2.Parent = LocalPlayer.Backpack end
        task.wait(0.01); invokeRE("1Too1l","PickingTools","Couch"); task.wait(0.2)
        root.CFrame = CFrame.new(origPos)
    end)
end

local function BringPlayerCouch()
    if protections.Sit then log("[Aviso] Anti Sit ativo — desative antes de usar Couch"); return end
    if not selectedPlayerName then return end
    local target = Players:FindFirstChild(selectedPlayerName)
    if not target or not target.Character then return end
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or not tRoot then return end
    local origPos = root.Position

    local ok = equipAndActivateTool("Couch")
    if not ok then log("Falha ao equipar Couch"); return end

    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum
    local align = Instance.new("BodyPosition")
    align.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    align.D = 10; align.P = 30000; align.Position = root.Position; align.Parent = tRoot

    task.spawn(function()
        local angle, st = 0, tick()
        while tick() - st < 5 and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do
            local tHum = target.Character:FindFirstChildOfClass("Humanoid")
            if not tHum or tHum.Sit then break end
            local hrp = target.Character.HumanoidRootPart
            angle += 50
            root.CFrame = CFrame.new(hrp.Position + (hrp.Velocity/1.5) + Vector3.new(0,2,0)) * CFrame.Angles(math.rad(angle), 0, 0)
            align.Position = root.Position + Vector3.new(2,0,0)
            task.wait()
        end
        align:Destroy()
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = hum
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.Velocity = Vector3.zero; p.RotVelocity = Vector3.zero end
        end
        task.wait(0.1); root.Anchored = true; root.CFrame = CFrame.new(origPos)
        task.wait(0.001); root.Anchored = false; task.wait(0.7)
        local t2 = char:FindFirstChild("Couch"); if t2 then t2.Parent = LocalPlayer.Backpack end
    end)
end

local function FlingBall(target)
    local player = LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local backpack = player:WaitForChild("Backpack")
    local wc = workspace:FindFirstChild("WorkspaceCom"); if not wc then return end
    local ServerBalls = wc:WaitForChild("001_SoccerBalls", 5); if not ServerBalls then return end
    local function GetBall()
        if not backpack:FindFirstChild("SoccerBall") then invokeRE("1Too1l","PickingTools","SoccerBall") end
        local t0 = tick()
        repeat task.wait() until backpack:FindFirstChild("SoccerBall") or tick() - t0 > 3
        if not backpack:FindFirstChild("SoccerBall") then return end
        backpack.SoccerBall.Parent = char
        local t1 = tick()
        repeat task.wait() until ServerBalls:FindFirstChild("Soccer"..player.Name) or tick() - t1 > 3
        char.SoccerBall.Parent = backpack
        return ServerBalls:FindFirstChild("Soccer"..player.Name)
    end
    local Ball = ServerBalls:FindFirstChild("Soccer"..player.Name) or GetBall()
    if not Ball then return end
    Ball.CanCollide = false; Ball.Massless = true
    Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)
    if target ~= player then
        local tchar = target.Character
        if tchar and tchar:FindFirstChild("HumanoidRootPart") and tchar:FindFirstChild("Humanoid") then
            local troot = tchar.HumanoidRootPart
            local thum = tchar.Humanoid
            if Ball:FindFirstChildWhichIsA("BodyVelocity") then Ball:FindFirstChildWhichIsA("BodyVelocity"):Destroy() end
            local bv = Instance.new("BodyVelocity", Ball)
            bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 9e900
            workspace.CurrentCamera.CameraSubject = thum
            repeat
                if troot.Velocity.Magnitude > 0 then
                    Ball.CFrame = CFrame.new(troot.Position + (troot.Velocity/1.5))
                else
                    for _, v in pairs(tchar:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide and not v.Anchored then Ball.CFrame = v.CFrame; task.wait(1/6000) end
                    end
                end
                task.wait(1/6000)
            until troot.Velocity.Magnitude > 1000 or thum.Health <= 0
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

local function houseBanKill()
    if not selectedPlayerName then return end
    local P = LocalPlayer; local C = P.Character
    local H = C and C:FindFirstChildOfClass("Humanoid")
    local R = C and C:FindFirstChild("HumanoidRootPart")
    local V = workspace:FindFirstChild("Vehicles")
    if not (P and C and H and R and V) then return end
    local sel = Players:FindFirstChild(selectedPlayerName)
    if not sel or not sel.Character then return end
    local PC = V:FindFirstChild(P.Name.."Car")
    if not PC then
        R.CFrame = CFrame.new(1118.81, 75.998, -1138.61); task.wait(0.5)
        fireRE("1Ca1r","PickingCar","SchoolBus"); task.wait(0.5)
        PC = V:FindFirstChild(P.Name.."Car")
    end
    if PC then
        local Seat = PC:FindFirstChild("Body") and PC.Body:FindFirstChild("VehicleSeat")
        if Seat and not H.Sit then
            repeat task.wait(); R.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1,1), 0) until H.Sit
        end
        local TC = sel.Character
        local TH = TC and TC:FindFirstChildOfClass("Humanoid")
        local TR = TC and TC:FindFirstChild("HumanoidRootPart")
        if TH and TR and not TH.Sit then
            while not TH.Sit do
                task.wait()
                pcall(function() PC:PivotTo(CFrame.new(TR.Position) * CFrame.new(0,1.5,0) * CFrame.Angles(math.rad(math.random(-180,180)),0,0)) end)
            end
        end
    end
    fireRE("1Ca1r","DeleteAllVehicles")
end

-- ══════════════════════════════════════════════
-- HUB — carrega PRIMEIRO, loading fecha DEPOIS
-- ══════════════════════════════════════════════
task.spawn(function()
    step(6, "Preparando ambiente...")
    task.wait(0.15)

    -- ===== LIB =====
    step(12, "Baixando library...")
    local okLib, RedzLib = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/minhdepzai-v/LibraryRobloc/refs/heads/main/RedzLibrary.lua"))()
    end)
    if not okLib or not RedzLib then
        setStatus("❌ Falha ao baixar a library. Verifique sua internet e reexecute.")
        loadingTarget = 100
        warn("[Sertanejo] Falha ao carregar Redz Library")
        return
    end
    step(28, "Library carregada.")

    local Window = RedzLib:MakeWindow({ Title = "Sertanejo Hub v2", SubTitle = "julainorei & zenna" })
    pcall(function()
        Window:AddMinimizeButton({
            Button = { Image = "rbxassetid://1234567890", BackgroundTransparency = 0 },
            Corner = { CornerRadius = UDim.new(35, 1) },
        })
    end)
    step(35, "Montando interface...")

    -- ===== HELPERS DE UI =====
    local function isValidTab(t)
        if not t then return false end
        for _, m in ipairs({"AddButton","AddSection","AddToggle","AddParagraph","AddDropdown","AddSlider"}) do
            if type(t[m]) == "function" then return true end
        end
        return false
    end
    local function forceTabName(tab, title)
        pcall(function() tab.Name = title end)
        pcall(function() tab.Title = title end)
        pcall(function() tab.Text = title end)
    end
    local function CreateTab(title, icon)
        local variants = {
            {Name = title, Title = title, Icon = icon},
            {Title = title, Icon = icon},
            {Name = title, Icon = icon},
            {title, icon},
        }
        for i, cfg in ipairs(variants) do
            local ok, tab = pcall(function() return Window:MakeTab(cfg) end)
            if ok and isValidTab(tab) then forceTabName(tab, title); return tab end
        end
        return nil
    end
    local function AddSection(tab, title)
        if not tab then return end
        local ok = pcall(function() tab:AddSection({title}) end)
        if ok then return end
        ok = pcall(function() tab:AddSection({Name = title, Title = title}) end)
        if ok then return end
        pcall(function() tab:AddSection(title) end)
    end
    local function AddParagraph(tab, name, desc)
        if not tab then return end
        local ok = pcall(function() tab:AddParagraph({name, desc}) end)
        if ok then return end
        ok = pcall(function() tab:AddParagraph({Title = name, Description = desc}) end)
        if ok then return end
        pcall(function() tab:AddParagraph({Name = name, Content = desc}) end)
    end
    local function AddButton(tab, cfg)
        if not tab then return end
        pcall(function() tab:AddButton({Name = cfg.Title, Title = cfg.Title, Callback = cfg.Callback, Description = cfg.Description or ""}) end)
    end
    local function AddToggle(tab, cfg)
        if not tab then return end
        pcall(function() tab:AddToggle({Name = cfg.Title, Title = cfg.Title, Default = cfg.Default or false, Value = cfg.Default or false, Callback = cfg.Callback}) end)
    end
    local function AddSlider(tab, cfg)
        if not tab then return end
        pcall(function() tab:AddSlider({Name = cfg.Title, Title = cfg.Title, Min = cfg.Min, Max = cfg.Max, Default = cfg.Default, Value = cfg.Default, Callback = cfg.Callback}) end)
    end
    local function AddDropdown(tab, cfg)
        if not tab then return end
        local v = cfg.Values or {}
        local ok, obj = pcall(function()
            return tab:AddDropdown({
                Name = cfg.Title, Title = cfg.Title,
                Values = v, Options = v,
                Default = v[1], Multi = false,
                Callback = cfg.Callback
            })
        end)
        if ok then return obj end
        return nil
    end
    local function AddInput(tab, cfg)
        if not tab then return end
        pcall(function() tab:AddInput({Name = cfg.Title, Title = cfg.Title, Placeholder = cfg.Placeholder or "", Callback = cfg.Callback}) end)
    end
    local function extractValue(v)
        if type(v) == "string" then return v end
        if type(v) == "number" then return tostring(v) end
        if type(v) == "table" then return v.Name or v.Value or v.Title or v.Text or v[1] end
        return nil
    end

    -- ===== ABA: INFORMAÇÕES =====
    local InfoTab = CreateTab("Informations", "info")
    if InfoTab then
        AddSection(InfoTab, "Internet Things")
        if type(InfoTab.AddDiscordInvite) == "function" then
            pcall(function()
                InfoTab:AddDiscordInvite({
                    Name = "Sertanejo Hub",
                    Description = "Entre no Discord do Sertanejo Hub!",
                    Logo = "rbxassetid://1234567890",
                    Invite = "https://discord.gg/sertanejohub",
                })
            end)
        end
        AddSection(InfoTab, "Credits")
        AddParagraph(InfoTab, "Owners", "julainorei & zenna")
        AddParagraph(InfoTab, "Programmers", "Sertanejo | Team")
        AddParagraph(InfoTab, "Loading", "sertanejo (julainorei & zenna)")
        AddSection(InfoTab, "Informations")
        AddParagraph(InfoTab, "Idioma:", "Portuguese")
        AddParagraph(InfoTab, "Jogando:", "Brookhaven RP")
        AddParagraph(InfoTab, "Hub:", "Sertanejo Hub")
        AddParagraph(InfoTab, "Versão:", "v2")
        AddSection(InfoTab, "Others")
        AddButton(InfoTab, { Title = "Rejoin", Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end })
        AddButton(InfoTab, { Title = "Server Hop", Callback = function()
            pcall(function()
                local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                local data = HttpService:JSONDecode(game:HttpGet(url))
                for _, srv in ipairs(data.data) do
                    if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                        return
                    end
                end
            end)
        end })
    end

    -- ===== ABA: SUPORTE =====
    local SupportTab = CreateTab("Suporte", "life-buoy")
    if SupportTab then
        AddSection(SupportTab, "Comunidade")
        AddButton(SupportTab, { Title = "📋 Copiar Discord", Callback = function()
            pcall(function() setclipboard("https://discord.gg/sertanejohub") end)
            log("Discord copiado!")
        end })
        AddSection(SupportTab, "Problemas comuns")
        AddParagraph(SupportTab, "Hub não carrega", "Verifique sua conexão e execute novamente. O loading fecha sozinho em 20s se travar.")
        AddParagraph(SupportTab, "Admin não abre", "Use uma key válida na aba Admin (SRT-...).")
        AddSection(SupportTab, "Sessão")
        AddButton(SupportTab, { Title = "Rejoin", Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end })
    end

    -- ═══════════════════════════════════════════════════════════════
    -- ABA: ADMIN (verificação de key + painel)
    -- ═══════════════════════════════════════════════════════════════
    local AdminTab = CreateTab("Admin", "shield")
    if AdminTab then
        AddSection(AdminTab, "🔐 Verificação de Key")

        -- Keys fixas (qualquer SRT-... também é aceita)
        local VALID_KEYS = {
            ["SERTANEJO-ADMIN-2024"] = true,
            ["JULAINOREI-MASTER"]    = true,
            ["ZENNA-OWNER"]          = true,
        }

        -- Gera key única por usuário
        if getgenv and not getgenv().SertanejoMinhaKey then
            getgenv().SertanejoMinhaKey = "SRT-" .. HttpService:GenerateGUID(false):upper():sub(1,18)
        end

        local function validarKey(key)
            if type(key) ~= "string" or key == "" then return false end
            key = key:gsub("%s+", ""):upper()
            if VALID_KEYS[key] then return true end
            if key:match("^SRT%-.+$") then return true end
            if getgenv and getgenv().SertanejoMinhaKey and key == getgenv().SertanejoMinhaKey then return true end
            return false
        end

        local keyValidada = (getgenv and getgenv().SertanejoKeyValid) or false

        AddParagraph(AdminTab, "Status:",
            keyValidada and "✅ Key validada nesta sessão" or "❌ Nenhuma key validada")
        AddParagraph(AdminTab, "Sua key:",
            (getgenv and getgenv().SertanejoMinhaKey) or "gerando...")
        AddParagraph(AdminTab, "Como funciona:",
            "Qualquer key começando com SRT- é aceita. Ex: SRT-a, SRT-123, SRT-qualquercoisa")

        -- Toast helper
        local function toast(msg, ok)
            pcall(function()
                local sg = Instance.new("ScreenGui")
                sg.Name = "SA_Toast"; sg.DisplayOrder = 999; sg.ResetOnSpawn = false
                sg.Parent = PlayerGui
                local f = Instance.new("Frame", sg)
                f.Size = UDim2.new(0, 340, 0, 60)
                f.Position = UDim2.new(0.5, -170, 0, 30)
                f.BackgroundColor3 = Color3.fromRGB(35, 8, 15)
                f.BorderSizePixel = 0
                Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
                local st = Instance.new("UIStroke", f)
                st.Color = ok and Color3.fromRGB(60, 220, 90) or Color3.fromRGB(220, 60, 90)
                st.Thickness = 2
                local t = Instance.new("TextLabel", f)
                t.Size = UDim2.new(1, -20, 1, -20); t.Position = UDim2.new(0, 10, 0, 10)
                t.BackgroundTransparency = 1; t.Text = msg
                t.TextColor3 = Color3.new(1,1,1)
                t.Font = Enum.Font.GothamBold; t.TextScaled = true
                task.delay(2.5, function() pcall(function() sg:Destroy() end) end)
            end)
        end

        -- Executa o painel admin (WindUI)
        local function executarPainelAdmin()
            if getgenv and getgenv().SertanejoAdminRevoked then
                toast("⚠️ Acesso revogado", false); return
            end
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            local cg = game:GetService("CoreGui")
            if (pg and pg:FindFirstChild("SertanejoAdmin")) or cg:FindFirstChild("WindUI") then
                toast("✅ Painel já aberto", true); return
            end
            if getgenv then
                getgenv().SertanejoKeyValid = true
                getgenv().SertanejoAdminRevoked = false
            end
            toast("✅ Key válida! Abrindo painel...", true)

            task.spawn(function()
                local _Players = Players
                local _RS = ReplicatedStorage
                local _LP = LocalPlayer
                local _PG = PlayerGui

                -- Board (lousa da escola)
                local Board = { count = nil, label = nil, remote = nil, pronto = false }
                local function tentarBoard()
                    local ok, res = pcall(function()
                        local wc = workspace:FindFirstChild("WorkspaceCom")
                        if not wc then return end
                        local school = wc:FindFirstChild("001_School")
                        if not school then return end
                        local board = school:FindFirstChild("SchoolDryBoard")
                        if not board then return end
                        local words = board:FindFirstChild("Words")
                        if not words then return end
                        local count = words:FindFirstChild("Count")
                        local label = words:FindFirstChildWhichIsA("TextLabel", true)
                        local RE = _RS:FindFirstChild("RE")
                        local remote = RE and RE:FindFirstChild("1Schoo1lDr1yBoard1s")
                        if count and label and remote then
                            return { count = count, label = label, remote = remote }
                        end
                    end)
                    if ok and res then
                        Board.count, Board.label, Board.remote, Board.pronto = res.count, res.label, res.remote, true
                        return true
                    end
                    return false
                end
                tentarBoard()
                if not Board.pronto then
                    task.spawn(function() while not Board.pronto do task.wait(1); tentarBoard() end end)
                end

                local _boardSeq = 0
                local function WriteBoard(t)
                    if not Board.pronto then return end
                    _boardSeq = _boardSeq + 1
                    pcall(function() if Board.count then Board.count.Value = _boardSeq end end)
                    pcall(function() Board.remote:FireServer("ReturningBoardName", Board.count, tostring(t or "")) end)
                end

                local _queue = {}
                local _sending = false
                local function _processQueue()
                    if _sending or not Board.pronto or #_queue == 0 then return end
                    _sending = true
                    local txt = table.remove(_queue, 1)
                    WriteBoard(txt)
                    task.delay(0.5, function()
                        WriteBoard(";noop "..tostring(os.clock()).."_"..math.random(1,999999))
                        task.delay(0.3, function()
                            _sending = false
                            _processQueue()
                        end)
                    end)
                end
                local function EnviarBoard(cmd, target, extra)
                    if not Board.pronto then return end
                    local txt
                    if extra and extra ~= "" and target and target ~= "" then
                        txt = ";"..cmd.." "..target:lower().." "..extra
                    elseif target and target ~= "" then
                        txt = ";"..cmd.." "..target:lower()
                    elseif extra and extra ~= "" then
                        txt = ";"..cmd.." "..extra
                    else
                        txt = ";"..cmd
                    end
                    table.insert(_queue, txt)
                    _processQueue()
                end

                local function userTemHub(p)
                    if not p then return false end
                    local bp = p:FindFirstChild("Backpack")
                    if bp and bp:FindFirstChild("LaundryBasket") then return true end
                    local char = p.Character
                    if char and char:FindFirstChild("LaundryBasket") then return true end
                    local pg = p:FindFirstChild("PlayerGui")
                    if pg then
                        if pg:FindFirstChild("SertanejoV2Loading") then return true end
                        if pg:FindFirstChild("SertanejoHub") then return true end
                    end
                    return false
                end
                local function usersHub()
                    local list = {}
                    for _, p in ipairs(_Players:GetPlayers()) do
                        if p ~= _LP and userTemHub(p) then table.insert(list, p.Name) end
                    end
                    table.sort(list); return list
                end

                -- WindUI
                local Version = "1.4.0"
                local success, result = pcall(function()
                    local url = "https://github.com/Footagesus/WindUI/releases/download/"..Version.."/main.lua"
                    return loadstring(game:HttpGet(url, true))()
                end)
                if not success or not result then
                    toast("❌ Falha ao baixar WindUI", false); return
                end
                local WindUI = result
                task.wait(0.5)

                local isMobileAdmin = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
                local AdminWindow = WindUI:CreateWindow({
                    Title = "Sertanejo Admin",
                    Icon = "shield",
                    Author = "sertanejo hub",
                    Folder = "SertanejoAdmin",
                    Size = isMobileAdmin and UDim2.fromOffset(320, 420) or UDim2.fromOffset(380, 460),
                    Transparent = true,
                    Theme = "Dark",
                    Resizable = true,
                    SideBarWidth = isMobileAdmin and 120 or 150,
                    HideSearchBar = true,
                    ScrollBarEnabled = true,
                    User = { Enabled = true, Anonymous = false, Callback = function() end }
                })
                WindUI:SetTheme("Dark")

                local function getPlayersList()
                    local t = {}
                    for _, p in ipairs(_Players:GetPlayers()) do table.insert(t, p.Name) end
                    table.sort(t); return t
                end

                local CmdTab = AdminWindow:Tab({ Title = "Comandos", Icon = "terminal" })
                local alvoSelecionado = nil
                CmdTab:Dropdown({
                    Title = "Alvo",
                    Values = getPlayersList(),
                    Multi = false,
                    Callback = function(v) alvoSelecionado = v end
                })
                local cmdTexto = ""
                CmdTab:Input({
                    Title = "Comando",
                    Placeholder = ";kill nome",
                    Callback = function(v) cmdTexto = v end
                })
                CmdTab:Button({
                    Title = "▶ Executar comando",
                    Callback = function()
                        if cmdTexto == "" then toast("Digite um comando", false); return end
                        EnviarBoard(cmdTexto)
                        toast("Comando enviado", true)
                    end
                })

                CmdTab:Section({ Title = "Ações Rápidas" })
                local acoes = {
                    {"💀 Kill","kill"},{"🔄 Reset","reset"},{"👢 Kick","kick"},
                    {"🔥 Fire","fire"},{"❄ Freeze","freeze"},{"💥 Explode","explode"},
                    {"🪑 Sit","sit"},{"📦 Jail","jail"},{"🚀 Fling","fling"},
                    {"👻 Jumpscare 1","jumps1"},{"👻 Jumpscare 2","jumps2"},
                }
                for _, a in ipairs(acoes) do
                    CmdTab:Button({
                        Title = a[1],
                        Callback = function()
                            if not alvoSelecionado then toast("Selecione um alvo", false); return end
                            EnviarBoard(a[2], alvoSelecionado)
                            toast("Enviado: "..a[2].." → "..alvoSelecionado, true)
                        end
                    })
                end

                local HubTab = AdminWindow:Tab({ Title = "Usuários Hub", Icon = "users" })
                HubTab:Button({
                    Title = "🔄 Atualizar lista",
                    Callback = function()
                        local lista = usersHub()
                        if #lista == 0 then toast("Ninguém com hub aberto", false)
                        else toast("Com hub: "..table.concat(lista, ", "), true) end
                    end
                })
                HubTab:Button({
                    Title = "📢 Aviso em todos",
                    Callback = function()
                        local lista = usersHub()
                        if #lista == 0 then toast("Ninguém com hub", false); return end
                        for _, n in ipairs(lista) do
                            EnviarBoard("aviso "..n, "Mensagem do admin Sertanejo!")
                        end
                        toast("Aviso enviado pra "..#lista.." pessoas", true)
                    end
                })

                local LoopTab = AdminWindow:Tab({ Title = "Loops", Icon = "repeat" })
                local loopAtivo = {}
                local function toggleLoop(cmd, uncmd, nome)
                    if loopAtivo[nome] then
                        loopAtivo[nome] = false
                        EnviarBoard(uncmd, alvoSelecionado)
                        toast("Loop "..nome.." desligado", true)
                    else
                        if not alvoSelecionado then toast("Selecione alvo", false); return end
                        loopAtivo[nome] = true
                        task.spawn(function()
                            while loopAtivo[nome] do
                                EnviarBoard(cmd, alvoSelecionado)
                                task.wait(1.2)
                            end
                        end)
                        toast("Loop "..nome.." ligado", true)
                    end
                end
                LoopTab:Button({ Title = "💀 Loop Kill", Callback = function() toggleLoop("loopkill","unloopkill","kill") end })
                LoopTab:Button({ Title = "🔥 Loop Fire", Callback = function() toggleLoop("loopfire","unloopfire","fire") end })
                LoopTab:Button({ Title = "🪑 Loop Sit", Callback = function() toggleLoop("loopsit","unloopsit","sit") end })

                local SysTab = AdminWindow:Tab({ Title = "Sistema", Icon = "settings" })
                SysTab:Paragraph({ Title = "Key validada", Desc = "Sessão autorizada ✅" })
                SysTab:Paragraph({ Title = "Sua key", Desc = (getgenv and getgenv().SertanejoMinhaKey) or "?" })
                SysTab:Button({
                    Title = "🚪 Revogar minha key",
                    Callback = function()
                        if getgenv then
                            getgenv().SertanejoKeyValid = false
                            getgenv().SertanejoAdminRevoked = true
                        end
                        for _, g in ipairs(_PG:GetChildren()) do
                            if g:IsA("ScreenGui") and (g.Name:find("SertanejoAdmin") or g.Name:find("WindUI")) then g:Destroy() end
                        end
                        for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do
                            if g:IsA("ScreenGui") and (g.Name:find("SertanejoAdmin") or g.Name:find("WindUI")) then g:Destroy() end
                        end
                        toast("✅ Key revogada", true)
                    end
                })
                SysTab:Button({
                    Title = "🔄 Revalidar (limpar revogação)",
                    Callback = function()
                        if getgenv then
                            getgenv().SertanejoAdminRevoked = false
                            getgenv().SertanejoKeyValid = false
                        end
                        toast("Pode verificar novamente", true)
                    end
                })

                print("[SertanejoAdmin] painel aberto via key")
            end)
        end

        local inputKey = nil
        AddInput(AdminTab, {
            Title = "Key de Acesso",
            Placeholder = "Cole sua key (SRT-...) ou use a sua gerada",
            Callback = function(v)
                inputKey = tostring(extractValue(v) or ""):gsub("%s+", "")
            end
        })

        AddButton(AdminTab, { Title = "🔓 Verificar Key", Callback = function()
            local key = inputKey or ""
            if key == "" then
                toast("❌ Digite uma key primeiro", false); return
            end
            if validarKey(key) then
                log("[Admin] Key válida:", key)
                executarPainelAdmin()
            else
                toast("❌ Key inválida. Use SRT-... ou sua key gerada.", false)
                log("[Admin] Key inválida:", key)
            end
        end })

        AddButton(AdminTab, { Title = "📋 Copiar minha key", Callback = function()
            if getgenv and getgenv().SertanejoMinhaKey then
                pcall(function() setclipboard(getgenv().SertanejoMinhaKey) end)
                toast("✅ Key copiada!", true)
            else
                toast("❌ Key não gerada", false)
            end
        end })

        if keyValidada then
            AddButton(AdminTab, { Title = "⚡ Reabrir Painel (já validado)", Callback = executarPainelAdmin })
        end

        AddSection(AdminTab, "🔑 Gerenciamento")
        AddButton(AdminTab, { Title = "🚪 Revogar minha key", Callback = function()
            pcall(function()
                if getgenv then
                    getgenv().SertanejoKeyValid = false
                    getgenv().SertanejoAdminRevoked = true
                end
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                if pg then
                    for _, g in ipairs(pg:GetChildren()) do
                        if g:IsA("ScreenGui") and (g.Name:find("SertanejoAdmin") or g.Name:find("WindUI")) then g:Destroy() end
                    end
                end
                for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do
                    if g:IsA("ScreenGui") and (g.Name:find("SertanejoAdmin") or g.Name:find("WindUI")) then g:Destroy() end
                end
            end)
            toast("✅ Key revogada", true)
        end })

        AddButton(AdminTab, { Title = "🔄 Revalidar key", Callback = function()
            if getgenv then getgenv().SertanejoAdminRevoked = false end
            toast("✅ Pode verificar novamente", true)
        end })
    end
    step(44, "Aba Admin (key).")

    -- ===== ABA: RGB =====
    local RGBTab = CreateTab("RGB", "sparkles")
    if RGBTab then
        local rgbSpeed = 3
        local state = {nameRGB=false, bioRGB=false, vehicle=false, bike=false, radio=false, house=false, houseText=false, hacked=false, propRGB=false, orbit=false}
        local function rainbow() return Color3.fromHSV((tick() * rgbSpeed % 5) / 5, 1, 1) end
        local function rgbFire(name, args)
            local RE = RS:FindFirstChild("RE"); if not RE then return false end
            local ev = RE:FindFirstChild(name); if not ev then return false end
            ev:FireServer(unpack(args or {})); return true
        end
        local function getMyProps()
            local props = {}
            local lots = workspace:FindFirstChild("001_Lots"); if not lots then return props end
            local myHouse = lots:FindFirstChild(LocalPlayer.Name .. "House"); if not myHouse then return props end
            for _, d in pairs(myHouse:GetDescendants()) do
                if d:FindFirstChild("ChangePropColor") or d:FindFirstChild("SetCurrentCFrame") then table.insert(props, d) end
            end
            return props
        end
        local function RGBToggle(title, default, callback)
            local ok = pcall(function() RGBTab:AddToggle({ Name = title, Title = title, Default = default, Callback = callback }) end)
            if not ok then pcall(function() RGBTab:AddToggle({ Name = title, Default = default, Callback = callback }) end) end
        end
        AddSection(RGBTab, "Velocidade")
        pcall(function()
            RGBTab:AddSlider({Name = "Velocidade RGB (1-5)", Title = "Velocidade RGB (1-5)", Min = 1, Max = 5, Default = 3,
                Callback = function(v) rgbSpeed = tonumber(v) or 3 end})
        end)
        AddSection(RGBTab, "Em Você")
        RGBToggle("Nome RGB", false, function(s)
            state.nameRGB = s
            if s then task.spawn(function()
                while state.nameRGB and LocalPlayer.Character do rgbFire("1RPNam1eColo1r", {"PickingRPNameColor", rainbow()}); task.wait(0.03) end
            end) end
        end)
        RGBToggle("Bio RGB", false, function(s)
            state.bioRGB = s
            if s then task.spawn(function()
                while state.bioRGB and LocalPlayer.Character do rgbFire("1RPNam1eColo1r", {"PickingRPBioColor", rainbow()}); task.wait(0.03) end
            end) end
        end)
        AddSection(RGBTab, "Veículos")
        RGBToggle("Vehicle RGB (Carro)", false, function(s)
            if s then
                if not state.vehicle then
                    state.vehicle = true
                    task.spawn(function()
                        local ok, remote = pcall(function()
                            return LocalPlayer:WaitForChild("PlayerGui", 3):WaitForChild("MainGUIHandler", 3):WaitForChild("VehicleControl", 3):WaitForChild("UIColorPicker", 3):WaitForChild("SetColor", 3)
                        end)
                        if not ok or not remote then state.vehicle = false; return end
                        while state.vehicle do
                            remote:FireServer(Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255)))
                            RunService.RenderStepped:Wait()
                        end
                    end)
                end
            else state.vehicle = false end
        end)
        RGBToggle("RGB Bicicleta", false, function(s)
            state.bike = s
            if s then task.spawn(function() while state.bike do rgbFire("1Player1sCa1r", {"NoMotorColor", rainbow()}); task.wait(0.1) end end) end
        end)
        RGBToggle("Rádio RGB", false, function(s)
            state.radio = s
            if s then task.spawn(function()
                while state.radio and LocalPlayer.Character do
                    local ok, remote = pcall(function()
                        return LocalPlayer:WaitForChild("PlayerGui", 3):WaitForChild("ToolGui", 3):WaitForChild("ToolSettings", 3):WaitForChild("Settings", 3):WaitForChild("PropsColor", 3):WaitForChild("SetColor", 3)
                    end)
                    if ok and remote then remote:FireServer(rainbow()) end
                    task.wait(0.03)
                end
            end) end
        end)
        AddSection(RGBTab, "Casa")
        RGBToggle("House RGB", false, function(s)
            state.house = s
            if s then task.spawn(function() while state.house do rgbFire("1Player1sHous1e", {"ColorPickHouse", Color3.fromHSV(math.random(),1,1)}); RunService.RenderStepped:Wait() end end) end
        end)
        RGBToggle("Housetext RGB", false, function(s)
            state.houseText = s
            if s then task.spawn(function() while state.houseText do rgbFire("1RPHous1eEven1tColo1r", {"PickingBusinessNameColor", Color3.fromHSV(math.random(),1,1)}); RunService.RenderStepped:Wait() end end) end
        end)
        AddSection(RGBTab, "Props")
        RGBToggle("Prop RGB", false, function(s)
            state.propRGB = s
            if s then task.spawn(function()
                while state.propRGB do
                    local c = Color3.fromHSV((tick()*0.5)%1, 1, 1)
                    for _, prop in ipairs(getMyProps()) do
                        if prop and prop.Parent and prop:FindFirstChild("ChangePropColor") then prop.ChangePropColor:InvokeServer(c) end
                    end
                    RunService.Heartbeat:Wait()
                end
            end) end
        end)
        RGBToggle("Orbit Prop", false, function(s)
            state.orbit = s
            if s then task.spawn(function()
                local speed, radius, height, angle = 2, 6, -3, 0
                while state.orbit do
                    local dt = RunService.Heartbeat:Wait()
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local props = getMyProps()
                        if #props > 0 then
                            angle += dt * speed
                            local spacing = (math.pi * 2) / #props
                            for i, prop in ipairs(props) do
                                if prop and prop.Parent then
                                    local a = angle + i * spacing
                                    local pos = root.Position + Vector3.new(math.cos(a)*radius, height, math.sin(a)*radius)
                                    local remote = prop:FindFirstChild("SetCurrentCFrame")
                                    if remote then remote:InvokeServer(CFrame.lookAt(pos, root.Position)) end
                                end
                            end
                        end
                    end
                end
            end) end
        end)
    end
    step(50, "Aba RGB.")

    -- ===== ABA: MÚSICA =====
    local MusicTab = CreateTab("Music", "music")

    local function tocarMusica(id)
        if id == nil then return end
        id = tostring(id)
        pcall(function() RS:WaitForChild("RE"):WaitForChild("PlayerToolEvent"):FireServer("ToolMusicText", id) end)
        pcall(function() RS:WaitForChild("RE"):WaitForChild("1Player1sHous1e"):FireServer("PickHouseMusicText", id) end)
        pcall(function() RS:WaitForChild("RE"):WaitForChild("1Player1sCa1r"):FireServer("PickingCarMusicText", id) end)
        pcall(function() RS:WaitForChild("RE"):WaitForChild("1NoMoto1rVehicle1s"):FireServer("PickingScooterMusicText", id) end)
        if id == "" then log("Música parada") else log("Tocando ID:", id) end
    end

    local function addMusicTextBox()
        local ok = pcall(function()
            MusicTab:AddTextBox({
                Name = "ID da música",
                Title = "ID da música",
                PlaceholderText = "Digite o ID e pressione Enter",
                Placeholder = "Digite o ID e pressione Enter",
                Callback = function(value)
                    local v = extractValue(value)
                    if v and v ~= "" then tocarMusica(tostring(v)) end
                end
            })
        end)
        if ok then return end
    end
    addMusicTextBox()

    local function createMusicDropdown(title, musicOptions, defaultOption)
        local musicNames, categoryMap = {}, {}
        for category, sounds in pairs(musicOptions) do
            for _, music in ipairs(sounds) do
                if music.name ~= "" then
                    table.insert(musicNames, music.name)
                    categoryMap[music.name] = {id = music.id, category = category}
                end
            end
        end
        local function playMusic(soundId) tocarMusica(tostring(soundId)) end
        pcall(function()
            MusicTab:AddDropdown({
                Name = title, Title = title, Description = "all",
                Default = defaultOption, Multi = false, Options = musicNames,
                Callback = function(selectedSound)
                    local sel = extractValue(selectedSound)
                    if sel and categoryMap[sel] then
                        local soundId = categoryMap[sel].id
                        if soundId and soundId ~= "" then playMusic(soundId) end
                    end
                end
            })
        end)
    end

    createMusicDropdown("Forro", {["forro"] = {
        {name="nunca vai ser eu",id="122871200237533"},{name="boate azul",id="106412079335663"},
        {name="Bloquinho Macumbeira",id="138345050819224"},{name="eu já tava bem",id="93590122047380"},
        {name="a culpa e nossa",id="72213295707216"},{name="chuva da arroz",id="102120036739514"},
        {name="GRELO E O FE",id="72200166265935"},{name="ama nao e pecado",id="89460438416730"},
        {name="escolha certa",id="107088620814881"},{name="forro da rezenha",id="120973520531216"},
        {name="forro dudu",id="74404168179733"},{name="ja que me ensino a beber",id="102593134121793"},
    }}, "Option 1")

    createMusicDropdown("Musicas e Memes Aleatorio", {["Memes"] = {
        {name="desca dai seu corno",id="119738878921996"},{name="GTA ESTOURADO",id="109337680029292"},
        {name="ANXIETY",id="101483901475189"},{name="Meu corpo, minhas regras",id="127587901595282"},
        {name="Megalovania",id="104500091160463"},{name="Bamm Bamm",id="128730685516895"},
        {name="CELL!",id="117634275895085"},{name="carro do ovo",id="3148329638"},
        {name="MIKU",id="112783541496955"},
    }}, "Option 1")

    createMusicDropdown("Funk", {["Funk"] = {
        {name="Meu Hd Chei De Cp",id="118351471702293"},{name="porra isabella",id="124950663117359"},
        {name="ela e profisonal",id="80282038249456"},{name="gurizada da polenta",id="138981629726601"},
        {name="manda de batom",id="74423035509776"},{name="so mandelao",id="100109274854032"},
        {name="baile da dz7",id="127275242574475"},{name="maceta",id="94365050554101"},
        {name="da uma mamada",id="76182545182727"},{name="toma",id="132877691651436"},
        {name="antares estorado",id="102853170480978"},{name="antares",id="122938948937941"},
        {name="antaresv2",id="79075022796596"},{name="berimbau da turquia",id="80937607674721"},
        {name="vou passa a chequicha",id="129784572747585"},{name="meia noite",id="86617433885915"},
        {name="maldita de ex",id="139081830944037"},{name="mutiplico",id="135750430892149"},
        {name="ela gemeu",id="126682676484892"},{name="sacanagem",id="124054822886984"},
        {name="tu toma dj c4",id="80488815553151"},{name="quem de fazer fumaça",id="77654661905802"},
        {name="tem que respeita",id="113496103486826"},{name="solza",id="125681143524900"},
        {name="sla",id="98468932764512"},{name="ela apredeu a passar macha",id="108226178439659"},
        {name="dj blakes",id="115660500409059"},
    }}, "Option 1")

    createMusicDropdown("Phonk", {["phonk"] = {
        {name="wyles",id="85385155970460"},{name="Vai Que E No Vapor!",id="94845998956451"},
        {name="phonk kawai",id="91502410121438"},{name="tatiu wim",id="122871512353520"},
        {name="phonk1",id="77501611905348"},{name="phonk2",id="126887144190812"},
        {name="phonk sarra",id="132436320685732"},{name="rede globo",id="138487820505005"},
        {name="BALA SELVAGEM!",id="96180057167470"},{name="CRISTAL",id="103445348511856"},
        {name="SKY HIGH",id="123517126955383"},
    }}, "Option 1")

    MusicTab:AddButton({
        Name = "Stop",
        Description = "ALL music",
        Callback = function() tocarMusica("") end
    })
    step(60, "Aba Música.")

    -- ===== ABA: ÁUDIOS =====
    local AUDIOS = {
        {"Yamete Kudasai",108494476595033},{"Gritinho",5710016194},{"Jumpscare",85435253347146},
        {"Áudio Alto",6855150757},{"Ruído",120034877160791},{"Amongus",6651571134},
        {"Sus",6701126635},{"Sonic.exe",2496367477},{"Tubers93 1",270145703},
        {"Tubers93 2",18131809532},{"Nuclear Siren",675587093},{"Grito 2",91412024101709},
        {"Estora tímpano",268116333},{"Toma Jack",132603645477541},{"Pede ifood",133843750864059},
    }
    local AudioTab = CreateTab("Áudios", "volume-2")
    local selAudioID, audioLoop, audioSpam = nil, false, false
    local function audioServer(id)
        if type(id) ~= "number" then return end
        local ev = RS:FindFirstChild("1Gu1nSound1s", true)
        if ev then pcall(function() ev:FireServer(workspace, id, 1) end) end
    end
    local function audioClient(id)
        if type(id) ~= "number" then return end
        local f = workspace:FindFirstChild("Audio all client")
        if not f then f = Instance.new("Folder"); f.Name = "Audio all client"; f.Parent = workspace end
        local s = Instance.new("Sound"); s.SoundId = "rbxassetid://"..id; s.Volume = 1; s.Parent = f; s:Play()
        task.delay(1, function() if s and s.Parent then s:Destroy() end end)
    end
    if AudioTab then
        AddSection(AudioTab, "Tocar Áudio")
        for _, a in ipairs(AUDIOS) do
            local nome, idAudio = a[1], a[2]
            AddButton(AudioTab, { Title = "▶ "..nome, Callback = function()
                selAudioID = idAudio
                audioServer(idAudio)
                task.spawn(function() audioClient(idAudio) end)
            end })
        end
        AddSection(AudioTab, "Loop / Spam")
        AddToggle(AudioTab, { Title = "Loop", Default = false, Callback = function(v)
            audioLoop = v
            if v then task.spawn(function() while audioLoop do
                if selAudioID then audioServer(selAudioID); task.spawn(function() audioClient(selAudioID) end) end
                task.wait(0.5)
            end end) end
        end })
        AddToggle(AudioTab, { Title = "Estourar Ouvido", Default = false, Callback = function(v)
            audioSpam = v
            if v then
                local id = selAudioID or 6314880174
                task.spawn(function() while audioSpam do audioServer(id); task.spawn(function() audioClient(id) end); task.wait(0.05) end end)
            end
        end })
        AddButton(AudioTab, { Title = "⏹ Parar Áudio", Callback = function()
            audioLoop = false; audioSpam = false
            local f = workspace:FindFirstChild("Audio all client")
            if f then for _, s in ipairs(f:GetChildren()) do if s:IsA("Sound") then pcall(function() s:Stop(); s:Destroy() end) end end end
        end })
    end
    step(67, "Aba Áudios.")

    -- ===== ABA: TROLL PLAYERS =====
    local TrollTab = CreateTab("Troll Players", "skull")
    if TrollTab then
        AddSection(TrollTab, "Selecionar Jogador")

        local trollDropdown
        trollDropdown = TrollTab:AddDropdown({
            Name = "Jogador", Title = "Jogador",
            Values = getPlayerList(), Options = getPlayerList(),
            Default = nil, Multi = false,
            Callback = function(v)
                selectedPlayerName = extractValue(v)
                log("Alvo selecionado:", tostring(selectedPlayerName))
            end
        })
        registerPlayerDropdown(trollDropdown)

        AddButton(TrollTab, { Title = "🔄 Atualizar Lista", Callback = function()
            updateAllPlayerDropdowns()
            local n = #getPlayerList()
            log("Lista atualizada:", n, "jogadores")
        end })

        AddButton(TrollTab, { Title = "🎯 Mirar no primeiro player", Callback = function()
            local list = getPlayerList()
            if #list > 0 then
                selectedPlayerName = list[1]
                log("Mirando em:", selectedPlayerName)
            else
                log("Nenhum jogador disponível")
            end
        end })

        AddSection(TrollTab, "Ações")
        AddButton(TrollTab, { Title = "TP até Player", Callback = function()
            if not selectedPlayerName then return end
            local tp = Players:FindFirstChild(selectedPlayerName)
            local mc = LocalPlayer.Character; local mh = mc and mc:FindFirstChild("HumanoidRootPart")
            local th = tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart")
            if mh and th then mh.CFrame = th.CFrame end
        end })
        AddToggle(TrollTab, { Title = "Spectar Player", Default = false, Callback = function(v)
            if v and selectedPlayerName then
                local tp = Players:FindFirstChild(selectedPlayerName)
                local h = tp and tp.Character and tp.Character:FindFirstChildOfClass("Humanoid")
                if h then workspace.CurrentCamera.CameraSubject = h end
            else
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if h then workspace.CurrentCamera.CameraSubject = h end
            end
        end })
        AddSection(TrollTab, "Métodos de Kill")
        AddButton(TrollTab, { Title = "💀 Matar Player", Callback = function() if selectedPlayerName and methodKill == "Couch" then KillPlayerCouch() end end })
        AddButton(TrollTab, { Title = "🪑 Puxar Player", Callback = function() if selectedPlayerName and methodKill == "Couch" then BringPlayerCouch() end end })
        AddButton(TrollTab, { Title = "🏠 House Ban Kill", Callback = houseBanKill })
        AddSection(TrollTab, "Fling")
        AddButton(TrollTab, { Title = "Fling Ball", Callback = function() local t = Players:FindFirstChild(selectedPlayerName); if t then FlingBall(t) end end })
        AddButton(TrollTab, { Title = "Auto Fling All", Callback = function()
            for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LocalPlayer then pcall(FlingBall, pl); task.wait(0.5) end end
        end })
    end
    step(73, "Aba Troll Players.")

    -- ===== ABA: TROLLS =====
    local TrollsTab = CreateTab("Trolls", "zap")
    if TrollsTab then
        AddSection(TrollsTab, "Black Hole")
        AddButton(TrollsTab, { Title = "Black Hole", Callback = function()
            local WS = workspace
            local angle, radius = 1, 10
            local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = c:WaitForChild("HumanoidRootPart")
            local F = Instance.new("Folder", WS)
            local P = Instance.new("Part", F)
            local A = Instance.new("Attachment", P)
            P.Anchored, P.CanCollide, P.Transparency = true, false, 1
            task.spawn(function()
                while P.Parent do
                    angle = angle + math.rad(2)
                    A.WorldCFrame = hrp.CFrame * CFrame.new(math.cos(angle)*radius, 0, math.sin(angle)*radius)
                    for _, v in next, WS:GetDescendants() do
                        if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and v.Name ~= "Handle" then
                            v.CanCollide = false
                            if not v:FindFirstChild("AP") then
                                local AP = Instance.new("AlignPosition", v); AP.Name = "AP"
                                local a2 = Instance.new("Attachment", v)
                                AP.MaxForce = math.huge; AP.Attachment0 = a2; AP.Attachment1 = A
                            end
                        end
                    end
                    RunService.RenderStepped:Wait()
                end
            end)
        end })
        AddSection(TrollsTab, "Invisível")
        AddButton(TrollsTab, { Title = "Ficar Invisível", Callback = function()
            local rem = RS:FindFirstChild("Remotes"); if not rem then return end
            pcall(function()
                rem:WaitForChild("ChangeCharacterBody"):InvokeServer({[1]={[1]=102344834840946,[2]=70400527171038,[3]=0,[4]=0,[5]=0,[6]=0}})
                rem:WaitForChild("Wear"):InvokeServer(111858803548721)
            end)
        end })
    end
    step(78, "Aba Trolls.")

    -- ===== ABA: PROTECTIONS =====
    local ProtectionsTab = CreateTab("Protections", "shield")
    task.spawn(function()
        while true do
            local wc = workspace:FindFirstChild("WorkspaceCom")
            if wc then
                if protections.Canoe then
                    local f = wc:FindFirstChild("001_CanoeStorage")
                    if f then for _, c in ipairs(f:GetChildren()) do
                        local own = c:FindFirstChild("Owner")
                        if not own or own.Value ~= LocalPlayer then c:Destroy() end
                    end end
                end
                if protections.Jet then
                    local ap = wc:FindFirstChild("001_Airport")
                    if ap then
                        local hg = ap:FindFirstChild("AirportHanger")
                        if hg then
                            local js = hg:FindFirstChild("001_JetStorage")
                            if js then
                                local jf = js:FindFirstChild("JetAirport")
                                if jf then for _, j in ipairs(jf:GetChildren()) do if j.Name ~= LocalPlayer.Name then j:Destroy() end end end
                            end
                        end
                    end
                end
                if protections.Ball then
                    local bf = wc:FindFirstChild("001_SoccerBalls")
                    if bf then for _, b in ipairs(bf:GetChildren()) do b:Destroy() end end
                end
            end
            task.wait(0.2)
        end
    end)
    if ProtectionsTab then
        AddSection(ProtectionsTab, "Anti Fling")
        AddToggle(ProtectionsTab, { Title = "Anti Canoe Fling", Default = false, Callback = function(v) protections.Canoe = v end })
        AddToggle(ProtectionsTab, { Title = "Anti Jet Fling", Default = false, Callback = function(v) protections.Jet = v end })
        AddToggle(ProtectionsTab, { Title = "Anti Ball Fling", Default = false, Callback = function(v) protections.Ball = v end })
        AddSection(ProtectionsTab, "Anti Sit")
        local antiSitConns = {}
        AddToggle(ProtectionsTab, { Title = "Anti Sit", Default = false, Callback = function(v)
            protections.Sit = v
            if v then
                local function prevent(h)
                    if h then
                        h:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                        table.insert(antiSitConns, h.StateChanged:Connect(function(_, ns)
                            if ns == Enum.HumanoidStateType.Seated then h:ChangeState(Enum.HumanoidStateType.GettingUp) end
                        end))
                    end
                end
                if LocalPlayer.Character then prevent(LocalPlayer.Character:FindFirstChildOfClass("Humanoid")) end
                table.insert(antiSitConns, LocalPlayer.CharacterAdded:Connect(function(c) prevent(c:WaitForChild("Humanoid")) end))
            else
                for _, c in ipairs(antiSitConns) do c:Disconnect() end
                antiSitConns = {}
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if h then h:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end
            end
        end })
    end
    step(82, "Aba Protections.")

    -- ===== ABA: AVATAR =====
    local AvatarTab = CreateTab("Avatar", "user")
    local TargetAvatar
    if AvatarTab then
        AddSection(AvatarTab, "Copiar Skin")
        local avatarDropdown
        avatarDropdown = AvatarTab:AddDropdown({
            Name = "Selecionar Jogador", Title = "Selecionar Jogador",
            Values = getPlayerList(), Options = getPlayerList(),
            Multi = false,
            Callback = function(v) TargetAvatar = extractValue(v) end
        })
        registerPlayerDropdown(avatarDropdown)

        AddButton(AvatarTab, { Title = "Copiar Avatar", Callback = function()
            if not TargetAvatar then return end
            local TP = Players:FindFirstChild(TargetAvatar)
            if not (TP and TP.Character) then return end
            local TH = TP.Character:FindFirstChildOfClass("Humanoid"); if not TH then return end
            local Remotes = RS:WaitForChild("Remotes")
            local PD = TH:GetAppliedDescription()
            pcall(function() Remotes.ChangeCharacterBody:InvokeServer({[1]=PD.Torso,[2]=PD.RightArm,[3]=PD.LeftArm,[4]=PD.RightLeg,[5]=PD.LeftLeg,[6]=PD.Head}) end)
            task.wait(0.5)
            if tonumber(PD.Shirt) then pcall(function() Remotes.Wear:InvokeServer(tonumber(PD.Shirt)) end); task.wait(0.3) end
            if tonumber(PD.Pants) then pcall(function() Remotes.Wear:InvokeServer(tonumber(PD.Pants)) end); task.wait(0.3) end
            if tonumber(PD.Face)  then pcall(function() Remotes.Wear:InvokeServer(tonumber(PD.Face))  end); task.wait(0.3) end
            for _, v in ipairs(PD:GetAccessories(true)) do
                if v.AssetId and tonumber(v.AssetId) then pcall(function() Remotes.Wear:InvokeServer(tonumber(v.AssetId)) end); task.wait(0.3) end
            end
        end })
    end
    step(85, "Aba Avatar.")

    -- ===== ABA: CARRO =====
    local CarTab = CreateTab("Carro", "car")
    local Speed, Turbo = 50, 50
    if CarTab then
        AddSection(CarTab, "Preparar Carro")
        AddButton(CarTab, { Title = "1️⃣ Pegar Carro", Callback = function()
            local c = LocalPlayer.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(1118.81, 75.998, -1138.61) end
            task.wait(0.5)
            fireRE("1Ca1r","PickingCar","SchoolBus"); task.wait(0.5)
        end })
        AddSection(CarTab, "Speed & Turbo")
        AddInput(CarTab, { Title = "Speed", Placeholder = "50", Callback = function(v) local n=tonumber(extractValue(v)); if n then Speed=n end end })
        AddInput(CarTab, { Title = "Turbo", Placeholder = "50", Callback = function(v) local n=tonumber(extractValue(v)); if n then Turbo=n end end })
        AddButton(CarTab, { Title = "Aplicar Speed/Turbo", Callback = function()
            local v = workspace:FindFirstChild("Vehicles")
            local car = v and v:FindFirstChild(LocalPlayer.Name.."Car")
            if car then
                local body = car:FindFirstChild("Body") and car.Body:FindFirstChild("VehicleSeat")
                if body then body.TopSpeed.Value = Speed; body.Turbo.Value = Turbo end
            end
        end })
        AddButton(CarTab, { Title = "Remove All Cars", Callback = function() fireRE("1Ca1r","DeleteAllVehicles") end })
    end
    step(88, "Aba Carro.")

    -- ===== ABA: CASAS =====
    local HouseTab = CreateTab("Casas", "home")
    local SelectHouse, isUnbanActive = nil, false
    if HouseTab then
        local function getHouseList()
            local t = {}
            local L = workspace:FindFirstChild("001_Lots")
            if L then for _, H in ipairs(L:GetChildren()) do
                if H.Name ~= "For Sale" and H:IsA("Model") then table.insert(t, H.Name) end
            end end
            return t
        end
        AddSection(HouseTab, "Selecionar / TP")
        AddDropdown(HouseTab, { Title = "Casa", Values = getHouseList(), Callback = function(v) SelectHouse = extractValue(v) end })
        AddButton(HouseTab, { Title = "TP para Casa", Callback = function()
            local L = workspace:FindFirstChild("001_Lots"); if not L then return end
            local H = L:FindFirstChild(tostring(SelectHouse))
            local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if H and hrp then hrp.CFrame = CFrame.new(H:GetPivot().Position) end
        end })
        AddSection(HouseTab, "Auto Unban")
        AddToggle(HouseTab, { Title = "Auto Unban", Default = false, Callback = function(v)
            isUnbanActive = v
            if v then task.spawn(function()
                while isUnbanActive do
                    pcall(function()
                        local L = workspace:FindFirstChild("001_Lots")
                        if L then for _, x in pairs(L:GetDescendants()) do
                            if x.Name:match("^BannedBlock%d+$") then x:Destroy() end
                        end end
                    end)
                    task.wait(1)
                end
            end) end
        end })
    end
    step(90, "Aba Casas.")

    -- ===== ABA: CRIANÇA =====
    local ChildTab = CreateTab("Criança", "baby")
    local chasingplayer = nil
    if ChildTab then
        AddSection(ChildTab, "Child")
        local childDropdown
        childDropdown = ChildTab:AddDropdown({
            Name = "Selecionar Player", Title = "Selecionar Player",
            Values = getPlayerList(), Options = getPlayerList(),
            Multi = false,
            Callback = function(v) chasingplayer = extractValue(v) end
        })
        registerPlayerDropdown(childDropdown)

        AddButton(ChildTab, { Title = "Enviar Criança", Callback = function()
            if not chasingplayer then return end
            fireRE("1Bab1yFollo1w","CharacterFollowSpawnPlayer","BabyBoy"); task.wait(0.2)
            if workspace:FindFirstChild(chasingplayer) and workspace:FindFirstChild(LocalPlayer.Name) and workspace[LocalPlayer.Name]:FindFirstChild("FollowCharacter") then
                workspace[LocalPlayer.Name].FollowCharacter.Parent = workspace[chasingplayer]
            end
        end })
        AddButton(ChildTab, { Title = "Retornar Criança", Callback = function() fireRE("1Bab1yFollo1w","DeleteFollowCharacter") end })
    end
    step(92, "Aba Criança.")

    -- ===== ABA: LOCAL PLAYER =====
    local LPTab = CreateTab("Local Player", "user")
    local chatText, chatSpam = "", false
    if LPTab then
        AddSection(LPTab, "Velocidade e Pulo")
        AddInput(LPTab, { Title = "Velocidade", Placeholder = "16", Callback = function(v)
            local s = tonumber(extractValue(v)); local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid"); if s and h then h.WalkSpeed = s end
        end })
        AddInput(LPTab, { Title = "Pulo", Placeholder = "50", Callback = function(v)
            local j = tonumber(extractValue(v)); local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid"); if j and h then h.JumpPower = j end
        end })
        AddButton(LPTab, { Title = "Reset Tudo", Callback = function()
            local c = LocalPlayer.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = 16; h.JumpPower = 50 end
            workspace.Gravity = 196.2
        end })
        AddButton(LPTab, { Title = "🔄 Forçar atualização de listas", Callback = function()
            updateAllPlayerDropdowns()
            log("Todas as listas foram atualizadas")
        end })
        AddSection(LPTab, "Spam Chat")
        AddInput(LPTab, { Title = "Texto", Placeholder = "Digite", Callback = function(v) chatText = extractValue(v) or "" end })
        AddButton(LPTab, { Title = "Enviar", Callback = function()
            if chatText ~= "" then
                local ev = RS:FindFirstChild("DefaultChatSystemChatEvents")
                if ev and ev:FindFirstChild("SayMessageRequest") then pcall(function() ev.SayMessageRequest:FireServer(chatText, "All") end) end
            end
        end })
        AddToggle(LPTab, { Title = "Spam Chat", Default = false, Callback = function(v)
            chatSpam = v
            if v then task.spawn(function()
                while chatSpam do
                    if chatText ~= "" then
                        local ev = RS:FindFirstChild("DefaultChatSystemChatEvents")
                        if ev and ev:FindFirstChild("SayMessageRequest") then pcall(function() ev.SayMessageRequest:FireServer(chatText, "All") end) end
                    end
                    task.wait(1)
                end
            end) end
        end })
    end
    step(94, "Aba Local Player.")

    -- ===== ABA: TELEPORTES =====
    local TpTab = CreateTab("Teleportes", "map-pin")
    local locais = {
        {"Aos Bastidores", CFrame.new(192, 4, 272)}, {"Ao Centro Urbano", CFrame.new(136, 4, 117)},
        {"À Área do Crime", CFrame.new(-119, -28, 235)}, {"À Casa Deserta", CFrame.new(986, 4, 63)},
        {"Ao Portal da Agência", CFrame.new(672, 4, -296)}, {"Ao Esconderijo", CFrame.new(505, -75, 143)},
        {"À Escola", CFrame.new(-312, 4, 211)}, {"Ao Café Brook", CFrame.new(161, 8, 52)},
        {"Ao Ponto Inicial", CFrame.new(-26, 4, -23)}, {"Ao Hospital", CFrame.new(-309, 4, 71)},
        {"À Base da Agência", CFrame.new(179, 4, -464)}, {"Ao Banco Principal", CFrame.new(2.28, 4.65, 254.58)},
        {"À Loja de Roupas", CFrame.new(-46.15, 4.65, 253.20)}, {"À Praça dos Hotéis", CFrame.new(182, 4, 150)},
        {"À Ilha Isolada", CFrame.new(-1925, 23, 127)},
    }
    if TpTab then
        AddSection(TpTab, "Locais")
        for _, l in ipairs(locais) do
            AddButton(TpTab, { Title = l[1], Callback = function()
                local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = l[2] end
            end })
        end
    end
    step(96, "Aba Teleportes.")

    -- ===== ABA: ITENS =====
    local ToolsTab = CreateTab("Itens", "backpack")
    if ToolsTab then
        AddSection(ToolsTab, "Controle")
        AddButton(ToolsTab, { Title = "Clear All Tools", Callback = function() fireRE("1Clea1rTool1s","ClearAllTools") end })
        AddButton(ToolsTab, { Title = "Equipar Todos", Callback = function()
            local c = LocalPlayer.Character
            if c and LocalPlayer.Backpack then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do if tool:IsA("Tool") then tool.Parent = c end end
            end
        end })
    end
    step(97, "Aba Itens.")

    -- ===== ABA: LAG =====
    local LagTab = CreateTab("Lag Server", "bomb")
    if LagTab then
        AddSection(LagTab, "Lags")
        AddToggle(LagTab, { Title = "Lag com Ônibus", Default = false, Callback = function(v)
            if v then task.spawn(function()
                while v do
                    pcall(function()
                        local c = LocalPlayer.Character
                        local hrp = c and c:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = CFrame.new(1118.81, 75.998, -1138.61) end
                        fireRE("1Ca1r","PickingCar","SchoolBus")
                    end)
                    task.wait(0)
                end
            end) end
        end })
    end
    step(98, "Aba Lag.")

    -- ===== ABA: SHADERS =====
    local ShadersTab = CreateTab("Shaders", "server")
    if ShadersTab then
        AddSection(ShadersTab, "Client-Sided")
        AddButton(ShadersTab, { Title = "Enable Shaders", Callback = function()
            local model = workspace:FindFirstChild("Model")
            if model then
                local function setMat(obj)
                    for _, c in pairs(obj:GetChildren()) do
                        if c:IsA("BasePart") then c.Material = Enum.Material.Basalt
                        elseif c:IsA("Model") or c:IsA("Folder") then setMat(c) end
                    end
                end
                if model:FindFirstChild("001_SnowStreet") then setMat(model["001_SnowStreet"]) end
                if model:FindFirstChild("Street") then
                    for _, o in pairs(model.Street:GetDescendants()) do if o:IsA("BasePart") then o.Material = Enum.Material.Basalt end end
                end
            end
        end })
    end
    step(99, "Aba Shaders.")

    -- ===== ABA: UNIVERSAIS =====
    local UniTab = CreateTab("Universais", "globe")
    local universais = {
        {"lyra hub","https://raw.githubusercontent.com/kayrus999/Lyrapainel/refs/heads/main/Lyrabrookhaven"},
        {"ShiftLock","https://pastebin.com/raw/N2tiHgyv"},
        {"fe danças","https://api.emote.rest/raw/legacy.lua"},
        {"InfiniteYield","https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
        {"TP Tool","https://raw.githubusercontent.com/err0r129/KptHadesBlair/main/Bao.lua"},
        {"Fly Gui","https://scriptblox.com/raw/Universal-Script-Fly-v3-7412"},
        {"fe sus","https://pastebin.com/raw/FWwdST5Y"},
        {"Telekinesis","https://raw.githubusercontent.com/SAZXHUB/Control-update/main/README.md"},
    }
    if UniTab then
        AddSection(UniTab, "Scripts Universais")
        for _, u in ipairs(universais) do
            AddButton(UniTab, { Title = u[1], Callback = function() pcall(function() loadstring(game:HttpGet(u[2], true))() end) end })
        end
    end

    step(100, "Pronto!")
    task.wait(0.1)
    finishLoading()
    log("hub pronto — loading fechado")

    if InfoTab then pcall(function() Window:SelectTab(InfoTab) end) end
    log("v2 mobile carregado — lista com auto-refresh ativa")
end)
