-- AnonmyUI V2 (Adicionado Dropdown e Keybind)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local AnonmyUI = {}

local function Create(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props) do inst[prop] = val end
    return inst
end

local Theme = {
    Accent = Color3.fromRGB(0, 255, 200),
    Background = Color3.fromRGB(20, 20, 25),
    Topbar = Color3.fromRGB(25, 25, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(30, 30, 35),
    Stroke = Color3.fromRGB(45, 45, 50)
}

local UIReferences = { Accents = {}, Backgrounds = {}, Strokes = {} }

function AnonmyUI:CreateWindow(config)
    local ScreenGui = Create("ScreenGui", { Name = "AnonmyUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    local Main = Create("Frame", { Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, -250, 0.5, -175), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = ScreenGui })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })
    local MainStroke = Create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Main })
    table.insert(UIReferences.Strokes, MainStroke)

    local Topbar = Create("Frame", { Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Topbar })
    Create("Frame", { Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Topbar })
    
    local Title = Create("TextLabel", { Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = config.Name or "AnonmyUI", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = Topbar })
    table.insert(UIReferences.Accents, Title)

    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local TabContainer = Create("Frame", { Size = UDim2.new(0, 130, 1, -45), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = TabContainer })
    Create("UIListLayout", { Padding = UDim.new(0, 5), Parent = TabContainer })

    local ContentContainer = Create("Frame", { Size = UDim2.new(1, -150, 1, -45), Position = UDim2.new(0, 145, 0, 40), BackgroundTransparency = 1, Parent = Main })

    local WindowAPI = {}

    function WindowAPI:CreateTab(name)
        local TabBtn = Create("TextButton", { Size = UDim2.new(1, -10, 0, 30), BackgroundColor3 = Theme.Element, Text = name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = TabContainer })
        Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = TabBtn })

        local Page = Create("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Stroke, Visible = false, Parent = ContentContainer })
        Create("UIListLayout", { Padding = UDim.new(0, 5), Parent = Page })
        Create("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), Parent = Page })

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
            local ToggleFrame = Create("TextButton", { Size = UDim2.new(1, -5, 0, 30), BackgroundColor3 = Theme.Element, Text = "", Parent = Page })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ToggleFrame })
            Create("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame })
            local Status = Create("TextLabel", { Size = UDim2.new(0, 30, 0, 20), Position = UDim2.new(1, -35, 0, 5), BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(100, 100, 100), Text = state and "ON" or "OFF", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 10, Parent = ToggleFrame })
            Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = Status })
            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                Status.Text = state and "ON" or "OFF"
                Status.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(100, 100, 100)
                if callback then callback(state) end
            end)
        end

        function TabAPI:CreateButton(text, callback)
            local Btn = Create("TextButton", { Size = UDim2.new(1, -5, 0, 30), BackgroundColor3 = Theme.Element, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = Page })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })
            Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
        end

        function TabAPI:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 40), BackgroundColor3 = Theme.Element, Parent = Page })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = SliderFrame })
            Create("TextLabel", { Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = SliderFrame })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -45, 0, 0), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, Parent = SliderFrame })
            local Track = Create("Frame", { Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 1, -10), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Parent = SliderFrame })
            local Fill = Create("Frame", { Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = Track })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
            
            local dragging = false
            Track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
                    local clamped = math.clamp(rel, 0, 1)
                    local val = math.floor(min + (max - min) * clamped)
                    Fill.Size = UDim2.new(clamped, 0, 1, 0)
                    ValueLabel.Text = tostring(val)
                    if callback then callback(val) end
                end
            end)
        end

        function TabAPI:CreateDropdown(text, options, default, multiSelect, callback)
            local selected = default or (multiSelect and {} or options[1])
            local DropdownFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 30), BackgroundColor3 = Theme.Element, Parent = Page })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = DropdownFrame })
            Create("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = DropdownFrame })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(1, -85, 0, 0), BackgroundTransparency = 1, Text = tostring(selected), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, Parent = DropdownFrame })
            
            local ListFrame = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 5), BackgroundColor3 = Theme.Topbar, Visible = false, Parent = DropdownFrame })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ListFrame })
            Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = ListFrame })
            Create("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2), Parent = ListFrame })

            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = DropdownFrame })
            Btn.MouseButton1Click:Connect(function()
                ListFrame.Visible = not ListFrame.Visible
                DropdownFrame.Size = ListFrame.Visible and UDim2.new(1, -5, 0, 30 + (#options * 25) + 5) or UDim2.new(1, -5, 0, 30)
            end)

            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", { Size = UDim2.new(1, -4, 0, 23), BackgroundColor3 = Theme.Element, Text = opt, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 11, Parent = ListFrame })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = OptBtn })
                OptBtn.MouseButton1Click:Connect(function()
                    if multiSelect then
                        local idx = table.find(selected, opt)
                        if idx then table.remove(selected, idx) else table.insert(selected, opt) end
                        ValueLabel.Text = #selected > 0 and tostring(selected) or "Vazio"
                    else
                        selected = opt
                        ValueLabel.Text = tostring(selected)
                        ListFrame.Visible = false
                        DropdownFrame.Size = UDim2.new(1, -5, 0, 30)
                    end
                    if callback then callback(selected) end
                end)
            end
        end

        function TabAPI:CreateKeybind(text, default, callback)
            local currentKey = default or Enum.KeyCode.Unknown
            local KeyFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 30), BackgroundColor3 = Theme.Element, Parent = Page })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyFrame })
            Create("TextLabel", { Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = KeyFrame })
            local KeyLabel = Create("TextLabel", { Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -45, 0, 5), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Text = currentKey.Name, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 10, Parent = KeyFrame })
            Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = KeyLabel })
            
            local waiting = false
            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = KeyFrame })
            Btn.MouseButton1Click:Connect(function()
                waiting = true
                KeyLabel.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if waiting then
                    waiting = false
                    currentKey = input.KeyCode
                    KeyLabel.Text = currentKey.Name
                    if callback then callback(currentKey) end
                elseif input.KeyCode == currentKey then
                    if callback then callback(currentKey, true) end
                end
            end)
        end

        return TabAPI
    end

    -- ==========================================
    -- SISTEMA DE CONFIGURAÇÕES
    -- ==========================================
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
        if neonEnabled then
            MainStroke.Color = Theme.Accent
            MainStroke.Thickness = 2
            MainStroke.Transparency = 0
        end
    end

    ConfigTab:CreateToggle("Modo Neon (Borda)", false, function(state)
        neonEnabled = state
        if state then
            MainStroke.Color = Theme.Accent
            MainStroke.Thickness = 2
            MainStroke.Transparency = 0
        else
            MainStroke.Color = Theme.Stroke
            MainStroke.Thickness = 1
        end
    end)
    ConfigTab:CreateSlider("Cor Vermelha (R)", 0, 255, 0, function(val) currentRGB.R = val UpdateThemeColor() end)
    ConfigTab:CreateSlider("Cor Verde (G)", 0, 255, 200, function(val) currentRGB.G = val UpdateThemeColor() end)
    ConfigTab:CreateSlider("Cor Azul (B)", 0, 255, 200, function(val) currentRGB.B = val UpdateThemeColor() end)
    ConfigTab:CreateSlider("Transparência da Janela", 0, 1, 0, function(val) Main.BackgroundTransparency = val Topbar.BackgroundTransparency = val end)
    
    local keybindBtn = ConfigTab:CreateButton("Abrir/Fechar Menu: K")
    local waitingForKey = false
    keybindBtn.MouseButton1Click:Connect(function()
        waitingForKey = true
        keybindBtn.Text = "Pressione uma tecla..."
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if waitingForKey then
            waitingForKey = false
            toggleKeybind = input.KeyCode
            keybindBtn.Text = "Abrir/Fechar Menu: " .. input.KeyCode.Name
        elseif input.KeyCode == toggleKeybind then
            Main.Visible = not Main.Visible
        end
    end)

    return WindowAPI
end

return AnonmyUI
