-- AnonmyUI V13 (Toggle Fix e Ordem das Abas)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
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
        local success, err = pcall(function() inst[prop] = val end)
        if not success then warn("AnonmyUI Error setting " .. prop .. ": " .. err) end
    end
    return inst
end

local function CreateListLayout(parent, pad)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, pad)
    layout.Parent = parent
    return layout
end

local function CreatePadding(parent, l, r, t, b)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, l); pad.PaddingRight = UDim.new(0, r)
    pad.PaddingTop = UDim.new(0, t); pad.PaddingBottom = UDim.new(0, b)
    pad.Parent = parent
    return pad
end

local function AddHover(btn)
    local hoverTween = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, hoverTween, {BackgroundColor3 = Theme.ElementHover}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, hoverTween, {BackgroundColor3 = Theme.Element}):Play() end)
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

    local Shadow = Create("ImageLabel", {
        Name = "Shadow", AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 530, 0, 380),
        Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1, Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(30, 30, 30, 30), Parent = ScreenGui, ZIndex = 0
    })

    local Main = Create("Frame", { Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, -250, 0.5, -175), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = ScreenGui, ClipsDescendants = true })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    local MainStroke = Create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Main })
    table.insert(UIReferences.Strokes, MainStroke)

    local Topbar = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Topbar })
    Create("Frame", { Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 1, -15), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Topbar })
    
    local Title = Create("TextLabel", { Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = config.Name or "AnonmyUI", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = Topbar })
    table.insert(UIReferences.Accents, Title)

    local dragging, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Main.Position = newPos
        Shadow.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 250, newPos.Y.Scale, newPos.Y.Offset + 175)
    end
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then updateDrag(input) end
    end)

    Main.Size = UDim2.new(0, 500, 0, 0); Shadow.ImageTransparency = 1; Main.Visible = true; Shadow.Visible = true
    TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 350)}):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()

    -- TabContainer agora tem SortOrder = LayoutOrder para garantir a posição
    local TabContainer = Create("ScrollingFrame", { Size = UDim2.new(0, 140, 1, -50), Position = UDim2.new(0, 10, 0, 45), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2 })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabContainer })
    local tabListLayout = CreateListLayout(TabContainer, 5)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder -- Força a usar a ordem que definirmos
    CreatePadding(TabContainer, 0, 0, 5, 0)

    local ContentContainer = Create("Frame", { Size = UDim2.new(1, -160, 1, -50), Position = UDim2.new(0, 150, 0, 45), BackgroundTransparency = 1, Parent = Main, ZIndex = 2, ClipsDescendants = true })

    local WindowAPI = {}
    WindowAPI.Flags = {}
    WindowAPI.Elements = {}
    local CEnabled = config.ConfigurationSaving and config.ConfigurationSaving.Enabled or false
    local CFolder = "AnonmyUI_Configs"
    local CFileName = (config.ConfigurationSaving and config.ConfigurationSaving.FileName) or "config1"

    function WindowAPI:SaveConfiguration()
        if not CEnabled or not writefile then return end
        if not isfolder(CFolder) then makefolder(CFolder) end
        local data = {}
        for flag, val in pairs(self.Flags) do data[flag] = val end
        writefile(CFolder.."/"..CFileName..".json", HttpService:JSONEncode(data))
    end

    function WindowAPI:LoadConfiguration()
        if not CEnabled or not isfile or not readfile then return end
        local path = CFolder.."/"..CFileName..".json"
        if not isfile(path) then return end
        local success, result = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if not success or type(result) ~= "table" then return end
        for flag, val in pairs(result) do
            if self.Elements[flag] then self.Elements[flag]:Set(val, true) end
        end
    end

    -- Adicionado parâmetro "order" para definir a posição da aba
    function WindowAPI:CreateTab(name, order)
        local TabBtn = Create("TextButton", { Size = UDim2.new(1, -10, 0, 30), BackgroundColor3 = Theme.Element, Text = name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, Parent = TabContainer, AutoButtonColor = false, Visible = true, ZIndex = 3, LayoutOrder = order or 0 })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabBtn }); AddHover(TabBtn)
        local Page = Create("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Visible = false, Parent = ContentContainer, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3, ClipsDescendants = true })
        CreateListLayout(Page, 8); CreatePadding(Page, 5, 5, 5, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") and child.Visible then
                    TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, -30, 0, 0)}):Play()
                    task.delay(0.2, function() child.Visible = false; child.Position = UDim2.new(0, 0, 0, 0) end)
                end
            end
            if Page.Visible then return end
            Page.Position = UDim2.new(0, 30, 0, 0); Page.Visible = true
            TweenService:Create(Page, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end)
        if not ContentContainer:FindFirstChild("ScrollingFrame") then Page.Visible = true end

        local TabAPI = {}

        function TabAPI:CreateSection(text)
            local SectionFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 25), BackgroundTransparency = 1, Parent = Page, ZIndex = 3 })
            CreateListLayout(SectionFrame, 2)
            local Label = Create("TextLabel", { Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = SectionFrame, ZIndex = 4 })
            local Divider = Create("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = SectionFrame, ZIndex = 4 })
            table.insert(UIReferences.Accents, Label)
        end

        function TabAPI:CreateInput(text, default, placeholder, callback, flag)
            local InputFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = InputFrame }); AddHover(InputFrame)
            Create("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = InputFrame, ZIndex = 4 })
            local Box = Create("Frame", { Size = UDim2.new(0, 80, 0, 25), Position = UDim2.new(1, -85, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Parent = InputFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Box })
            local TextBox = Create("TextBox", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = default or "", PlaceholderText = placeholder or "Digite...", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, Parent = Box, ZIndex = 5, ClearTextOnFocus = false })
            table.insert(UIReferences.Accents, TextBox)

            local InputObj = {
                Set = function(newVal, skipCallback)
                    TextBox.Text = newVal
                    if flag then WindowAPI.Flags[flag] = newVal end
                    if callback and not skipCallback then callback(newVal) end
                end
            }
            TextBox.FocusLost:Connect(function()
                if flag then WindowAPI.Flags[flag] = TextBox.Text end
                if callback then callback(TextBox.Text) end
            end)
            if flag then WindowAPI.Elements[flag] = InputObj; WindowAPI.Flags[flag] = default or "" end
            return InputObj
        end

        -- Lógica do Toggle Corrigida (Garante o liga/desliga)
        function TabAPI:CreateToggle(text, default, callback, flag)
            local state = default or false
            local ToggleFrame = Create("TextButton", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Text = "", Parent = Page, AutoButtonColor = false, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleFrame }); AddHover(ToggleFrame)
            local Title = Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame, ZIndex = 4 })
            local Track = Create("Frame", { Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 50), Parent = ToggleFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            local Knob = Create("Frame", { Size = UDim2.new(0, 16, 0, 16), Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = Track, ZIndex = 5 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
            
            local function applyVisual()
                local targetColor = state and Theme.Accent or Color3.fromRGB(50, 50, 50)
                local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                TweenService:Create(Track, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
            end

            local ToggleObj = {
                Set = function(newVal, skipCallback)
                    state = newVal
                    applyVisual()
                    if flag then WindowAPI.Flags[flag] = state end
                    if callback and not skipCallback then 
                        local ok, err = pcall(callback, state)
                        if not ok then warn("AnonmyUI | Toggle Callback Error:", err) end
                    end
                end
            }
            
            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                ToggleObj:Set(state)
            end)
            
            if flag then WindowAPI.Elements[flag] = ToggleObj; WindowAPI.Flags[flag] = state end
            return ToggleObj
        end

        function TabAPI:CreateButton(text, callback)
            local Btn = Create("TextButton", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, Parent = Page, AutoButtonColor = false, ZIndex = 3 })
            local Stroke = Create("UIStroke", { Color = Theme.Stroke, Transparency = 0, Parent = Btn })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn }); AddHover(Btn)
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {BackgroundColor3 = Theme.ElementHover}):Play()
                RunCallback(Btn, Stroke, Btn, text, callback)
                task.delay(0.2, function() TweenService:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundColor3 = Theme.Element}):Play() end)
            end)
            return Btn
        end

        function TabAPI:CreateSlider(text, min, max, increment, default, callback, flag)
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
            local dragTweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            local SliderObj = {
                Set = function(newVal, skipCallback)
                    newVal = math.clamp(newVal, min, max)
                    local rel = (newVal - min) / (max - min)
                    TweenService:Create(Fill, dragTweenInfo, {Size = UDim2.new(rel, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, dragTweenInfo, {Position = UDim2.new(rel, -7, 0.5, -7)}):Play()
                    ValueLabel.Text = tostring(newVal)
                    if flag then WindowAPI.Flags[flag] = newVal end
                    if callback and not skipCallback then callback(newVal) end
                end
            }
            
            local function update(input)
                local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local raw = min + (max - min) * rel
                local val = math.floor(raw / increment + 0.5) * (increment * 10000000) / 10000000
                SliderObj.Set(val)
            end
            Track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
            if flag then WindowAPI.Elements[flag] = SliderObj; WindowAPI.Flags[flag] = default end
            return SliderObj
        end

        function TabAPI:CreateDropdown(text, options, default, multiSelect, callback, flag)
            local selected = default or (multiSelect and {} or options[1])
            local DropdownFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropdownFrame })
            Create("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = DropdownFrame, ZIndex = 4 })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(1, -90, 0, 0), BackgroundTransparency = 1, Text = tostring(selected), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = DropdownFrame, ZIndex = 4 })
            local ListFrame = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 5), BackgroundColor3 = Theme.Topbar, Visible = false, ZIndex = 10, Parent = DropdownFrame })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ListFrame })
            CreateListLayout(ListFrame, 2); CreatePadding(ListFrame, 0, 0, 2, 2)
            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = DropdownFrame, ZIndex = 5 })
            
            local DropdownObj = {
                Set = function(newVal, skipCallback)
                    selected = newVal
                    if multiSelect then
                        if #selected == 0 then ValueLabel.Text = "None"
                        elseif #selected == 1 then ValueLabel.Text = selected[1]
                        else ValueLabel.Text = "Various" end
                    else ValueLabel.Text = tostring(selected) end
                    if flag then WindowAPI.Flags[flag] = selected end
                    if callback and not skipCallback then callback(selected) end
                end
            }
            
            local function toggleList()
                ListFrame.Visible = not ListFrame.Visible
                local targetSize = ListFrame.Visible and UDim2.new(1, -5, 0, 35 + (#options * 30) + 5) or UDim2.new(1, -5, 0, 35)
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = targetSize}):Play()
            end
            Btn.MouseButton1Click:Connect(toggleList)

            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", { Size = UDim2.new(1, -4, 0, 28), BackgroundColor3 = Theme.Element, Text = opt, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Parent = ListFrame, ZIndex = 11 })
                Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = OptBtn }); AddHover(OptBtn)
                OptBtn.MouseButton1Click:Connect(function()
                    if multiSelect then
                        local idx = table.find(selected, opt)
                        if idx then table.remove(selected, idx) else table.insert(selected, opt) end
                        DropdownObj.Set(selected)
                    else
                        DropdownObj.Set(opt); toggleList()
                    end
                end)
            end
            if flag then WindowAPI.Elements[flag] = DropdownObj; WindowAPI.Flags[flag] = selected end
            return DropdownObj
        end

        function TabAPI:CreateKeybind(text, default, holdToInteract, callback)
            local currentKey = default or Enum.KeyCode.Unknown
            local KeyFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyFrame })
            Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = KeyFrame, ZIndex = 4 })
            local KeyLabel = Create("TextLabel", { Size = UDim2.new(0, 45, 0, 25), Position = UDim2.new(1, -50, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Text = currentKey.Name, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, Parent = KeyFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyLabel })
            local waiting = false; local holding = false
            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = KeyFrame, AutoButtonColor = false, ZIndex = 5 })
            AddHover(KeyFrame)
            Btn.MouseButton1Click:Connect(function() waiting = not waiting; KeyLabel.Text = waiting and "..." or currentKey.Name end)
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                local isTyping = gameProcessed and UserInputService:GetFocusedTextBox() ~= nil
                if isTyping and not waiting then return end 
                if waiting then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then return end
                    if input.KeyCode == Enum.KeyCode.Escape then waiting = false; KeyLabel.Text = currentKey.Name return end
                    waiting = false; currentKey = input.KeyCode; KeyLabel.Text = currentKey.Name
                    if callback then callback(currentKey) end
                elseif input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
                    if not isTyping then
                        holding = true
                        if not holdToInteract then if callback then callback(true) end
                        else task.spawn(function() while holding do if callback then callback(true) end RunService.RenderStepped:Wait() end end) end
                    end
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == currentKey and holding then holding = false; if holdToInteract and callback then callback(false) end end
            end)
        end

        return TabAPI
    end

    -- Config Tab criada com LayoutOrder 1000 para ficar sempre por último
    local ConfigTab = WindowAPI:CreateTab("Config UI", 1000)
    local neonEnabled = false
    local currentRGB = {R = 0, G = 255, B = 200}

    local function UpdateThemeColor()
        Theme.Accent = Color3.fromRGB(currentRGB.R, currentRGB.G, currentRGB.B)
        for _, obj in ipairs(UIReferences.Accents) do
            if obj:IsA("TextLabel") then obj.TextColor3 = Theme.Accent
            elseif obj:IsA("Frame") then obj.BackgroundColor3 = Theme.Accent end
        end
        if neonEnabled then MainStroke.Color = Theme.Accent; MainStroke.Thickness = 2; MainStroke.Transparency = 0 end
    end

    ConfigTab:CreateToggle("Modo Neon (Borda)", false, function(state)
        neonEnabled = state
        if state then MainStroke.Color = Theme.Accent; MainStroke.Thickness = 2; MainStroke.Transparency = 0
        else MainStroke.Color = Theme.Stroke; MainStroke.Thickness = 1 end
    end)
    ConfigTab:CreateSlider("Cor Vermelha (R)", 0, 255, 1, 0, function(val) currentRGB.R = val; UpdateThemeColor() end)
    ConfigTab:CreateSlider("Cor Verde (G)", 0, 255, 1, 200, function(val) currentRGB.G = val; UpdateThemeColor() end)
    ConfigTab:CreateSlider("Cor Azul (B)", 0, 255, 1, 200, function(val) currentRGB.B = val; UpdateThemeColor() end)
    ConfigTab:CreateSlider("Transparência da Janela", 0, 1, 0.01, 0, function(val) Main.BackgroundTransparency = val; Topbar.BackgroundTransparency = val end)
    
    ConfigTab:CreateButton("Salvar Configuração", function() WindowAPI:SaveConfiguration() print("Config Salva!") end)
    ConfigTab:CreateButton("Carregar Configuração", function() WindowAPI:LoadConfiguration() print("Config Carregada!") end)

    ConfigTab:CreateKeybind("Abrir/Fechar Menu", Enum.KeyCode.K, false, function(state)
        if state == true then Main.Visible = not Main.Visible end
    end)

    WindowAPI:LoadConfiguration()

    return WindowAPI
end

return AnonmyUI
