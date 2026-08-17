-- AnonmyUI V8 (Bug do Padding Corrigido)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local AnonmyUI = {}

local Theme = {
    Accent = Color3.fromRGB(0, 255, 200),
    Background = Color3.fromRGB(20, 20, 25),
    Topbar = Color3.fromRGB(25, 25, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(30, 30, 35),
    ElementHover = Color3.fromRGB(40, 40, 45),
    Stroke = Color3.fromRGB(45, 45, 50),
    Error = Color3.fromRGB(85, 0, 0)
}

local UIReferences = { Accents = {}, Backgrounds = {}, Strokes = {} }

local function Create(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props) do
        local success, err = pcall(function()
            inst[prop] = val
        end)
        if not success then warn("AnonmyUI Error setting " .. prop .. ": " .. err) end
    end
    return inst
end

-- Função isolada para ListLayout (Evita o bug de UDim/UDim2)
local function CreateListLayout(parent, pad)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, pad)
    layout.Parent = parent
    return layout
end

-- Função isolada para Padding
local function CreatePadding(parent, left, right, top, bottom)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, left)
    pad.PaddingRight = UDim.new(0, right)
    pad.PaddingTop = UDim.new(0, top)
    pad.PaddingBottom = UDim.new(0, bottom)
    pad.Parent = parent
    return pad
end

local function AddHover(btn)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Theme.ElementHover}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Theme.Element}):Play() end)
end

local function RunCallback(element, stroke, titleObj, origText, callback, ...)
    local args = {...}
    task.spawn(function()
        local success, err = pcall(function() callback(table.unpack(args)) end)
        if not success then
            TweenService:Create(element, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Theme.Error}):Play()
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.6), {Transparency = 1}):Play() end
            if titleObj then titleObj.Text = "Callback Error" end
            warn("AnonmyUI | Error: " .. tostring(err))
            task.wait(0.5)
            if titleObj then titleObj.Text = origText end
            TweenService:Create(element, TweenInfo.new(0.6), {BackgroundColor3 = Theme.Element}):Play()
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.6), {Transparency = 0}):Play() end
        end
    end)
end

function AnonmyUI:CreateWindow(config)
    local ScreenGui = Create("ScreenGui", { Name = "AnonmyUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    local Main = Create("Frame", { Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, -250, 0.5, -175), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = ScreenGui })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    local MainStroke = Create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Main })
    table.insert(UIReferences.Strokes, MainStroke)

    local Topbar = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Topbar })
    Create("Frame", { Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 1, -15), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Topbar })
    
    local Title = Create("TextLabel", { Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = config.Name or "AnonmyUI", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = Topbar })
    table.insert(UIReferences.Accents, Title)

    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local TabContainer = Create("ScrollingFrame", { 
        Size = UDim2.new(0, 140, 1, -50), Position = UDim2.new(0, 10, 0, 45), 
        BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main, 
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), 
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabContainer })
    CreateListLayout(TabContainer, 5)
    CreatePadding(TabContainer, 0, 0, 5, 0)

    local ContentContainer = Create("Frame", { Size = UDim2.new(1, -160, 1, -50), Position = UDim2.new(0, 150, 0, 45), BackgroundTransparency = 1, Parent = Main, ZIndex = 2 })

    local WindowAPI = {}

    function WindowAPI:CreateTab(name)
        local TabBtn = Create("TextButton", { 
            Size = UDim2.new(1, -10, 0, 30), BackgroundColor3 = Theme.Element, Text = name, 
            TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, Parent = TabContainer, 
            AutoButtonColor = false, Visible = true, ZIndex = 3 
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabBtn })
        AddHover(TabBtn)

        local Page = Create("ScrollingFrame", { 
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, 
            ScrollBarImageColor3 = Theme.Stroke, Visible = false, Parent = ContentContainer, 
            AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0), ZIndex = 3
        })
        CreateListLayout(Page, 8)
        CreatePadding(Page, 5, 5, 5, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            Page.Visible = true
        end)

        if not ContentContainer:FindFirstChild("ScrollingFrame") then Page.Visible = true end

        local TabAPI = {}

        function TabAPI:CreateToggle(text, default, callback)
            local state = default or false
            local ToggleFrame = Create("TextButton", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Text = "", Parent = Page, AutoButtonColor = false, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleFrame })
            AddHover(ToggleFrame)
            
            local Title = Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame, ZIndex = 4 })
            local Track = Create("Frame", { Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 50), Parent = ToggleFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            local Knob = Create("Frame", { Size = UDim2.new(0, 16, 0, 16), Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = Track, ZIndex = 5 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })

            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                RunCallback(ToggleFrame, nil, Title, text, callback, state)
            end)
        end

        function TabAPI:CreateButton(text, callback)
            local Btn = Create("TextButton", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, Parent = Page, AutoButtonColor = false, ZIndex = 3 })
            local Stroke = Create("UIStroke", { Color = Theme.Stroke, Transparency = 0, Parent = Btn })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })
            AddHover(Btn)
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Theme.ElementHover}):Play()
                RunCallback(Btn, Stroke, Btn, text, callback)
                task.delay(0.2, function() TweenService:Create(Btn, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Theme.Element}):Play() end)
            end)
        end

        function TabAPI:CreateSlider(text, min, max, increment, default, callback)
            local SliderFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 45), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SliderFrame })
            Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = SliderFrame, ZIndex = 4 })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(1, -55, 0, 0), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, Parent = SliderFrame, ZIndex = 4 })
            
            local Track = Create("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 1, -15), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Parent = SliderFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            local Fill = Create("Frame", { Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = Track, ZIndex = 5 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
            local Knob = Create("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((default - min) / (max - min), -4, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = Track, ZIndex = 6 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })

            local dragging = false
            local function update(input)
                local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local raw = min + (max - min) * rel
                local val = math.floor(raw / increment + 0.5) * (increment * 10000000) / 10000000
                val = math.clamp(val, min, max)
                
                Fill.Size = UDim2.new(rel, 0, 1, 0)
                Knob.Position = UDim2.new(rel, -7, 0.5, -7)
                ValueLabel.Text = tostring(val)
                callback(val)
            end

            Track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
        end

        function TabAPI:CreateDropdown(text, options, default, multiSelect, callback)
            local selected = default or (multiSelect and {} or options[1])
            local DropdownFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropdownFrame })
            Create("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = DropdownFrame, ZIndex = 4 })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(1, -90, 0, 0), BackgroundTransparency = 1, Text = tostring(selected), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = DropdownFrame, ZIndex = 4 })
            
            local ListFrame = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 5), BackgroundColor3 = Theme.Topbar, Visible = false, ZIndex = 10, Parent = DropdownFrame })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ListFrame })
            CreateListLayout(ListFrame, 2)
            CreatePadding(ListFrame, 0, 0, 2, 2)

            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = DropdownFrame, ZIndex = 5 })
            Btn.MouseButton1Click:Connect(function()
                ListFrame.Visible = not ListFrame.Visible
                DropdownFrame.Size = ListFrame.Visible and UDim2.new(1, -5, 0, 35 + (#options * 30) + 5) or UDim2.new(1, -5, 0, 35)
            end)

            local function updateText()
                if multiSelect then
                    if #selected == 0 then ValueLabel.Text = "None"
                    elseif #selected == 1 then ValueLabel.Text = selected[1]
                    else ValueLabel.Text = "Various" end
                else
                    ValueLabel.Text = tostring(selected)
                end
            end
            updateText()

            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", { Size = UDim2.new(1, -4, 0, 28), BackgroundColor3 = Theme.Element, Text = opt, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = ListFrame, ZIndex = 11 })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = OptBtn })
                AddHover(OptBtn)
                OptBtn.MouseButton1Click:Connect(function()
                    if multiSelect then
                        local idx = table.find(selected, opt)
                        if idx then table.remove(selected, idx) else table.insert(selected, opt) end
                        updateText()
                    else
                        selected = opt
                        updateText()
                        ListFrame.Visible = false
                        DropdownFrame.Size = UDim2.new(1, -5, 0, 35)
                    end
                    callback(selected)
                end)
            end
        end

        function TabAPI:CreateKeybind(text, default, holdToInteract, callback)
            local currentKey = default or Enum.KeyCode.Unknown
            local KeyFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyFrame })
            Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = KeyFrame, ZIndex = 4 })
            
            local KeyLabel = Create("TextLabel", { Size = UDim2.new(0, 45, 0, 25), Position = UDim2.new(1, -50, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Text = currentKey.Name, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, Parent = KeyFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyLabel })
            
            local waiting = false
            local holding = false
            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = KeyFrame, AutoButtonColor = false, ZIndex = 5 })
            AddHover(KeyFrame)
            
            Btn.MouseButton1Click:Connect(function()
                waiting = not waiting
                KeyLabel.Text = waiting and "..." or currentKey.Name
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                local isTyping = gameProcessed and UserInputService:GetFocusedTextBox() ~= nil
                if isTyping and not waiting then return end 
                
                if waiting then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then return end
                    if input.KeyCode == Enum.KeyCode.Escape then waiting = false KeyLabel.Text = currentKey.Name return end

                    waiting = false
                    currentKey = input.KeyCode
                    KeyLabel.Text = currentKey.Name
                    callback(currentKey)
                elseif input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
                    if not isTyping then
                        holding = true
                        if not holdToInteract then
                            callback(true)
                        else
                            task.spawn(function()
                                while holding do
                                    callback(true)
                                    RunService.RenderStepped:Wait()
                                end
                            end)
                        end
                    end
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == currentKey and holding then
                    holding = false
                    if holdToInteract then callback(false) end
                end
            end)
        end

        return TabAPI
    end

    -- CONFIG TAB
    local ConfigTab = WindowAPI:CreateTab("Config UI")
    local neonEnabled = false
    local currentRGB = {R = 0, G = 255, B = 200}
    local toggleKeybind = Enum.KeyCode.K

    local function UpdateThemeColor()
        Theme.Accent = Color3.fromRGB(currentRGB.R, currentRGB.G, currentRGB.B)
        for _, obj in ipairs(UIReferences.Accents) do
            if obj:IsA("TextLabel") then obj.TextColor3 = Theme.Accent
            elseif obj:IsA("Frame") then obj.BackgroundColor3 = Theme.Accent end
        end
        if neonEnabled then MainStroke.Color = Theme.Accent MainStroke.Thickness = 2 MainStroke.Transparency = 0 end
    end

    ConfigTab:CreateToggle("Modo Neon (Borda)", false, function(state)
        neonEnabled = state
        if state then MainStroke.Color = Theme.Accent MainStroke.Thickness = 2 MainStroke.Transparency = 0
        else MainStroke.Color = Theme.Stroke MainStroke.Thickness = 1 end
    end)
    ConfigTab:CreateSlider("Cor Vermelha (R)", 0, 255, 1, 0, function(val) currentRGB.R = val UpdateThemeColor() end)
    ConfigTab:CreateSlider("Cor Verde (G)", 0, 255, 1, 200, function(val) currentRGB.G = val UpdateThemeColor() end)
    ConfigTab:CreateSlider("Cor Azul (B)", 0, 255, 1, 200, function(val) currentRGB.B = val UpdateThemeColor() end)
    ConfigTab:CreateSlider("Transparência da Janela", 0, 1, 0.01, 0, function(val) Main.BackgroundTransparency = val Topbar.BackgroundTransparency = val end)
    
    local keybindBtn = ConfigTab:CreateButton("Abrir/Fechar Menu: K")
    local waitingForKey = false
    keybindBtn.MouseButton1Click:Connect(function() waitingForKey = true keybindBtn.Text = "Pressione uma tecla..." end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        local isTyping = gameProcessed and UserInputService:GetFocusedTextBox() ~= nil
        if isTyping and not waitingForKey then return end
        
        if waitingForKey then
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then return end
            if input.KeyCode == Enum.KeyCode.Escape then waitingForKey = false keybindBtn.Text = "Abrir/Fechar Menu: " .. toggleKeybind.Name return end
            
            waitingForKey = false
            toggleKeybind = input.KeyCode
            keybindBtn.Text = "Abrir/Fechar Menu: " .. toggleKeybind.Name
        elseif input.KeyCode == toggleKeybind then
            if not isTyping then Main.Visible = not Main.Visible end
        end
    end)

    return WindowAPI
end

return AnonmyUI
