-- AnonmyUI V19 (Final Library)
-- Biblioteca de UI 100% autoral e nativa
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

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

local function CreateGradient(parent, c1, c2)
    local grad = Instance.new("UIGradient"); grad.Rotation = 90; grad.Color = ColorSequence.new(c1, c2); grad.Parent = parent
end

local function CreateListLayout(parent, pad)
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, pad); layout.Parent = parent; return layout
end

local function CreatePadding(parent, l, r, t, b)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, l); pad.PaddingRight = UDim.new(0, r)
    pad.PaddingTop = UDim.new(0, t); pad.PaddingBottom = UDim.new(0, b); pad.Parent = parent; return pad
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

    local TooltipFrame = Create("TextLabel", { Name = "Tooltip", BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Gotham, TextSize = 12, Visible = false, ZIndex = 2000, Parent = ScreenGui, AutomaticSize = Enum.AutomaticSize.XY })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = TooltipFrame })
    Create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = TooltipFrame })

    local function AttachTooltip(element, text)
        if not text then return end
        element.MouseEnter:Connect(function() TooltipFrame.Text = text; TooltipFrame.Visible = true; TooltipFrame.Size = UDim2.new(0, 0, 0, 0) end)
        element.MouseLeave:Connect(function() TooltipFrame.Visible = false end)
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and TooltipFrame.Visible then
                local mousePos = UserInputService:GetMouseLocation()
                TooltipFrame.Position = UDim2.new(0, mousePos.X + 15, 0, mousePos.Y - 30)
            end
        end)
    end

    local ToastContainer = Create("Frame", { Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, -310, 0, 10), BackgroundTransparency = 1, Parent = ScreenGui, ZIndex = 1000 })
    CreateListLayout(ToastContainer, 10).VerticalAlignment = Enum.VerticalAlignment.Bottom

    local Shadow = Create("ImageLabel", { Name = "Shadow", AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 530, 0, 380), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(30, 30, 30, 30), Parent = ScreenGui, ZIndex = 0 })

    local Main = Create("Frame", { Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = ScreenGui, ClipsDescendants = true })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    CreateGradient(Main, Color3.fromRGB(25, 25, 30), Theme.Background)
    local MainStroke = Create("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Main })
    table.insert(UIReferences.Strokes, MainStroke)

    local Topbar = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Topbar })
    Create("Frame", { Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 1, -15), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Topbar })
    CreateGradient(Topbar, Color3.fromRGB(30, 30, 35), Color3.fromRGB(22, 22, 27))
    
    local Title = Create("TextLabel", { Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = config.Name or "AnonmyUI", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = Topbar })
    table.insert(UIReferences.Accents, Title)

    local dragging, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Main.Position = newPos; Shadow.Position = newPos
    end
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then updateDrag(input) end end)

    local isAnimating = false; local uiVisible = true
    local function toggleUI(show)
        if isAnimating then return end; isAnimating = true
        if show then
            Main.Visible = true; Shadow.Visible = true
            Main.Size = UDim2.new(0, 0, 0, 0); Main.BackgroundTransparency = 1; Shadow.ImageTransparency = 1
            local tInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            TweenService:Create(Main, tInfo, {Size = UDim2.new(0, 500, 0, 350), BackgroundTransparency = 0}):Play()
            TweenService:Create(Shadow, tInfo, {ImageTransparency = 0.5}):Play()
            task.delay(tInfo.Time, function() isAnimating = false end)
        else
            local tInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
            TweenService:Create(Main, tInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(Shadow, tInfo, {ImageTransparency = 1}):Play()
            task.delay(tInfo.Time, function() Main.Visible = false; Shadow.Visible = false; isAnimating = false end)
        end
    end

    local TabContainer = Create("ScrollingFrame", { Size = UDim2.new(0, 140, 1, -50), Position = UDim2.new(0, 10, 0, 45), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Main, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, ScrollBarBackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,0,0) })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabContainer })
    local tabListLayout = CreateListLayout(TabContainer, 5); tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CreatePadding(TabContainer, 0, 0, 5, 0)

    local ContentContainer = Create("Frame", { Size = UDim2.new(1, -160, 1, -50), Position = UDim2.new(0, 150, 0, 45), BackgroundTransparency = 1, Parent = Main, ZIndex = 2, ClipsDescendants = true })

    local WindowAPI = {}
    WindowAPI.Flags = {}; WindowAPI.Elements = {}; WindowAPI.Connections = {}; WindowAPI.Unloaded = false
    local CEnabled = config.ConfigurationSaving and config.ConfigurationSaving.Enabled or false
    local CFolder = "AnonmyUI_Configs"
    local CFileName = (config.ConfigurationSaving and config.ConfigurationSaving.FileName) or "config1"

    local function setupAntiAfk(state)
        if state then
            WindowAPI.AntiAfkConn = Players.LocalPlayer.Idled:Connect(function()
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton(Vector2.new(1, 1), workspace.CurrentCamera.CFrame)
                end)
            end)
        else
            if WindowAPI.AntiAfkConn then WindowAPI.AntiAfkConn:Disconnect(); WindowAPI.AntiAfkConn = nil end
        end
    end

    function WindowAPI:Unload()
        if self.Unloaded then return end
        self.Unloaded = true
        setupAntiAfk(false)
        for _, conn in ipairs(self.Connections) do pcall(function() conn:Disconnect() end) end
        ScreenGui:Destroy()
    end

    function WindowAPI:Notify(title, content, duration)
        duration = duration or 5
        local Toast = Create("Frame", { Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = Theme.Background, ClipsDescendants = true, Parent = ToastContainer, ZIndex = 1001, Position = UDim2.new(1, 0, 0, 0) })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Toast })
        Create("UIStroke", { Color = Theme.Accent, Transparency = 0.5, Parent = Toast })
        Create("UIListLayout", { Padding = UDim.new(0, 5), Parent = Toast })
        Create("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), Parent = Toast })
        local TitleLabel = Create("TextLabel", { Text = title, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = Toast })
        local ContentLabel = Create("TextLabel", { Text = content, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, Parent = Toast })
        table.insert(UIReferences.Accents, TitleLabel)
        Toast.Position = UDim2.new(1, 0, 0, 0)
        TweenService:Create(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(duration, function()
            local t = TweenService:Create(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)})
            t:Play(); t.Completed:Wait(); Toast:Destroy()
        end)
    end

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

    function WindowAPI:CreateTab(name, order)
        local TabBtn = Create("TextButton", { Size = UDim2.new(1, -10, 0, 30), BackgroundColor3 = Theme.Element, Text = name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, Parent = TabContainer, AutoButtonColor = false, Visible = true, ZIndex = 3, LayoutOrder = order or 0 })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabBtn }); AddHover(TabBtn)
        local Page = Create("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = ContentContainer, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3, ClipsDescendants = true, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, ScrollBarBackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,0,0) })
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
        local PageElements = {}

        function TabAPI:CreateSearchBar(placeholder)
            local SearchBox = Create("Frame", { Size = UDim2.new(1, -5, 0, 30), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Parent = Page, ZIndex = 3, LayoutOrder = 0 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SearchBox })
            local Input = Create("TextBox", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = placeholder or "Buscar...", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, Parent = SearchBox, ZIndex = 5, ClearTextOnFocus = false })
            table.insert(UIReferences.Accents, Input)
            Input:GetPropertyChangedSignal("Text"):Connect(function()
                local search = string.lower(Input.Text)
                for _, elem in ipairs(PageElements) do
                    elem.Visible = string.find(string.lower(elem.Name), search) ~= nil
                end
            end)
            return SearchBox
        end

        function TabAPI:CreateSection(text)
            local SectionFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 25), BackgroundTransparency = 1, Parent = Page, ZIndex = 3, Name = text })
            CreateListLayout(SectionFrame, 2)
            local Label = Create("TextLabel", { Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = SectionFrame, ZIndex = 4 })
            local Divider = Create("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = SectionFrame, ZIndex = 4 })
            table.insert(UIReferences.Accents, Label)
        end

        function TabAPI:CreateParagraph(title, content)
            local Frame = Create("Frame", { Size = UDim2.new(1, -5, 0, 60), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, AutomaticSize = Enum.AutomaticSize.Y, Name = title })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Frame })
            CreateListLayout(Frame, 5); CreatePadding(Frame, 12, 12, 8, 8)
            local TitleLabel = Create("TextLabel", { Text = title, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame, ZIndex = 4 })
            local ContentLabel = Create("TextLabel", { Text = content, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Top, Parent = Frame, ZIndex = 4 })
            table.insert(UIReferences.Accents, TitleLabel)
        end

        function TabAPI:CreateProgressBar(text, tooltip)
            local Frame = Create("Frame", { Size = UDim2.new(1, -5, 0, 45), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Frame })
            AttachTooltip(Frame, tooltip)
            Create("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame, ZIndex = 4 })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -45, 0, 0), BackgroundTransparency = 1, Text = "0%", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, Parent = Frame, ZIndex = 4 })
            local Track = Create("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 1, -15), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Parent = Frame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            local Fill = Create("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = Track, ZIndex = 5 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
            local ProgressObj = { Set = function(self, val) val = math.clamp(val, 0, 100); ValueLabel.Text = tostring(val) .. "%"; TweenService:Create(Fill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(val/100, 0, 1, 0)}):Play() end }
            table.insert(PageElements, Frame)
            return ProgressObj
        end

        function TabAPI:CreateCopyButton(text, value, tooltip)
            local Frame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Frame }); AddHover(Frame); AttachTooltip(Frame, tooltip)
            Create("TextLabel", { Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame, ZIndex = 4 })
            local Box = Create("Frame", { Size = UDim2.new(0, 60, 0, 25), Position = UDim2.new(1, -130, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Parent = Frame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Box })
            Create("TextLabel", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = value, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, Parent = Box, ZIndex = 5 })
            local Btn = Create("TextButton", { Size = UDim2.new(0, 60, 0, 25), Position = UDim2.new(1, -65, 0.5, -12.5), BackgroundColor3 = Theme.Accent, Text = "Copiar", TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 11, Parent = Frame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })
            Btn.MouseButton1Click:Connect(function()
                if setclipboard then setclipboard(value); WindowAPI:Notify("Copiado!", "O texto foi copiado.", 3) else WindowAPI:Notify("Erro", "Sem suporte.", 3) end
            end)
            table.insert(PageElements, Frame)
        end

        function TabAPI:CreateColorPicker(text, defaultColor, callback, flag, tooltip)
            local CPFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CPFrame }); AddHover(CPFrame); AttachTooltip(CPFrame, tooltip)
            Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = CPFrame, ZIndex = 4 })
            local ColorPreview = Create("Frame", { Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = defaultColor, Parent = CPFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ColorPreview })
            local h, s, v = defaultColor:ToHSV()
            local open = false
            
            local Panel = Create("Frame", { Size = UDim2.new(0, 150, 0, 120), Position = UDim2.new(0, 0, 1, 5), BackgroundColor3 = Theme.Background, Visible = false, Parent = CPFrame, ZIndex = 20 })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Panel })
            Create("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), Parent = Panel })
            local SVBox = Create("Frame", { Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = Color3.fromHSV(h, 1, 1), Parent = Panel, ZIndex = 21 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = SVBox })
            local WhiteGrad = Create("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)), Transparency = NumberSequence.new(0, 1), Parent = SVBox })
            local BlackGrad = Create("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)), Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = SVBox })
            
            local HueBar = Create("Frame", { Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Color3.fromRGB(255,255,255), Parent = Panel, ZIndex = 21 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = HueBar })
            local Rainbow = Create("UIGradient", { Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))}), Parent = HueBar })

            local function updateColor()
                local c = Color3.fromHSV(h, s, v)
                ColorPreview.BackgroundColor3 = c
                SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                if flag then WindowAPI.Flags[flag] = c end
                if callback then callback(c) end
            end

            local draggingSV, draggingHue = false, false
            local c1 = SVBox.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true; local relX = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1); local relY = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1); s = relX; v = 1 - relY; updateColor() end end)
            local c2 = UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = false; draggingHue = false end end)
            local c3 = UserInputService.InputChanged:Connect(function(input)
                if draggingSV and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relX = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1); local relY = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                    s = relX; v = 1 - relY; updateColor()
                elseif draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                    h = relX; updateColor()
                end
            end)
            table.insert(WindowAPI.Connections, c1); table.insert(WindowAPI.Connections, c2); table.insert(WindowAPI.Connections, c3)
            local c4 = HueBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true; local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1); h = relX; updateColor() end end)
            
            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = CPFrame, ZIndex = 5 })
            Btn.MouseButton1Click:Connect(function()
                open = not open
                Panel.Visible = open
                TweenService:Create(CPFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Size = open and UDim2.new(1, -5, 0, 160) or UDim2.new(1, -5, 0, 35)}):Play()
            end)
            
            local ColorObj = { Set = function(self, val, skip) h, s, v = val:ToHSV(); updateColor() end }
            if flag then WindowAPI.Elements[flag] = ColorObj; WindowAPI.Flags[flag] = defaultColor end
            table.insert(PageElements, CPFrame)
            return ColorObj
        end

        function TabAPI:CreateInput(text, default, placeholder, callback, flag, tooltip)
            local InputFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = InputFrame }); AddHover(InputFrame); AttachTooltip(InputFrame, tooltip)
            Create("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = InputFrame, ZIndex = 4 })
            local Box = Create("Frame", { Size = UDim2.new(0, 80, 0, 25), Position = UDim2.new(1, -85, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Parent = InputFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Box })
            local TextBox = Create("TextBox", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = default or "", PlaceholderText = placeholder or "Digite...", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, Parent = Box, ZIndex = 5, ClearTextOnFocus = false })
            table.insert(UIReferences.Accents, TextBox)
            local InputObj = { Set = function(self, newVal, skipCallback) TextBox.Text = newVal; if flag then WindowAPI.Flags[flag] = newVal end; if callback and not skipCallback then callback(newVal) end end }
            TextBox.FocusLost:Connect(function() if flag then WindowAPI.Flags[flag] = TextBox.Text end; if callback then callback(TextBox.Text) end end)
            if flag then WindowAPI.Elements[flag] = InputObj; WindowAPI.Flags[flag] = default or "" end
            table.insert(PageElements, InputFrame)
            return InputObj
        end

        function TabAPI:CreateToggle(text, default, callback, flag, tooltip)
            local state = default or false
            local origSize = UDim2.new(1, -5, 0, 35)
            local ToggleFrame = Create("TextButton", { Size = origSize, BackgroundColor3 = Theme.Element, Text = "", Parent = Page, AutoButtonColor = false, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleFrame }); AddHover(ToggleFrame); AttachTooltip(ToggleFrame, tooltip)
            local Title = Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame, ZIndex = 4 })
            local Track = Create("Frame", { Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = Color3.fromRGB(50, 50, 50), Parent = ToggleFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            local Knob = Create("Frame", { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = Track, ZIndex = 5 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
            local function updateVisual()
                local targetColor = state and Theme.Accent or Color3.fromRGB(50, 50, 50)
                local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                TweenService:Create(Track, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
            end
            local function setState(self, newVal, skipCallback)
                if state == newVal then return end
                state = newVal; updateVisual()
                if flag then WindowAPI.Flags[flag] = state end
                if callback and not skipCallback then local ok, err = pcall(callback, state); if not ok then warn("AnonmyUI | Toggle Callback Error:", err) end end
            end
            Track.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 50)
            Knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local ToggleObj = { Set = setState }
            if flag then WindowAPI.Elements[flag] = ToggleObj; WindowAPI.Flags[flag] = state end
            ToggleFrame.MouseButton1Click:Connect(function()
                TweenService:Create(ToggleFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 30)}):Play()
                task.delay(0.1, function() TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {Size = origSize}):Play() end)
                ToggleObj:Set(not state)
            end)
            table.insert(PageElements, ToggleFrame)
            return ToggleObj
        end

        function TabAPI:CreateButton(text, callback, tooltip)
            local origSize = UDim2.new(1, -5, 0, 35)
            local Btn = Create("TextButton", { Size = origSize, BackgroundColor3 = Theme.Element, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, Parent = Page, AutoButtonColor = false, ZIndex = 3, Name = text })
            local Stroke = Create("UIStroke", { Color = Theme.Stroke, Transparency = 0, Parent = Btn })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn }); AddHover(Btn); AttachTooltip(Btn, tooltip)
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 30)}):Play()
                task.delay(0.1, function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {Size = origSize}):Play()
                    RunCallback(Btn, Stroke, Btn, text, callback)
                end)
                task.delay(0.2, function() TweenService:Create(Btn, TweenInfo.new(0.4), {BackgroundColor3 = Theme.Element}):Play() end)
            end)
            table.insert(PageElements, Btn)
            return Btn
        end

        function TabAPI:CreateSlider(text, min, max, increment, default, callback, flag, tooltip)
            local SliderFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 45), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SliderFrame }); AttachTooltip(SliderFrame, tooltip)
            Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = SliderFrame, ZIndex = 4 })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(1, -55, 0, 0), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, Parent = SliderFrame, ZIndex = 4 })
            local Track = Create("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 1, -15), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Parent = SliderFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
            local Fill = Create("Frame", { Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = Track, ZIndex = 5 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
            local Knob = Create("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((default - min) / (max - min), -4, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = Track, ZIndex = 6 })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
            local dragging = false; local dragTweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local SliderObj = {
                Set = function(self, newVal, skipCallback)
                    newVal = math.clamp(newVal, min, max); local rel = (newVal - min) / (max - min)
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
                SliderObj:Set(val)
            end
            Track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(input) end end)
            local c1 = UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            local c2 = UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
            table.insert(WindowAPI.Connections, c1); table.insert(WindowAPI.Connections, c2)
            if flag then WindowAPI.Elements[flag] = SliderObj; WindowAPI.Flags[flag] = default end
            table.insert(PageElements, SliderFrame)
            return SliderObj
        end

        function TabAPI:CreateDropdown(text, options, default, multiSelect, callback, flag, tooltip)
            local selected = default or (multiSelect and {} or options[1])
            local DropdownFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropdownFrame }); AttachTooltip(DropdownFrame, tooltip)
            Create("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = DropdownFrame, ZIndex = 4 })
            local ValueLabel = Create("TextLabel", { Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(1, -90, 0, 0), BackgroundTransparency = 1, Text = tostring(selected), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = DropdownFrame, ZIndex = 4 })
            local ListFrame = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 5), BackgroundColor3 = Theme.Topbar, Visible = false, ZIndex = 10, Parent = DropdownFrame })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ListFrame })
            CreateListLayout(ListFrame, 2); CreatePadding(ListFrame, 0, 0, 2, 2)
            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = DropdownFrame, ZIndex = 5 })
            local DropdownObj = {
                Set = function(self, newVal, skipCallback)
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
                    if multiSelect then local idx = table.find(selected, opt); if idx then table.remove(selected, idx) else table.insert(selected, opt) end; DropdownObj:Set(selected)
                    else DropdownObj:Set(opt); toggleList() end
                end)
            end
            if flag then WindowAPI.Elements[flag] = DropdownObj; WindowAPI.Flags[flag] = selected end
            table.insert(PageElements, DropdownFrame)
            return DropdownObj
        end

        function TabAPI:CreateKeybind(text, default, holdToInteract, callback, tooltip)
            local currentKey = default or Enum.KeyCode.Unknown
            local KeyFrame = Create("Frame", { Size = UDim2.new(1, -5, 0, 35), BackgroundColor3 = Theme.Element, Parent = Page, ZIndex = 3, Name = text })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyFrame }); AttachTooltip(KeyFrame, tooltip)
            Create("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = KeyFrame, ZIndex = 4 })
            local KeyLabel = Create("TextLabel", { Size = UDim2.new(0, 45, 0, 25), Position = UDim2.new(1, -50, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Text = currentKey.Name, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, Parent = KeyFrame, ZIndex = 4 })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyLabel })
            local waiting = false; local holding = false
            local Btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = KeyFrame, AutoButtonColor = false, ZIndex = 5 })
            AddHover(KeyFrame)
            Btn.MouseButton1Click:Connect(function() waiting = not waiting; KeyLabel.Text = waiting and "..." or currentKey.Name end)
            local c1 = UserInputService.InputBegan:Connect(function(input, gameProcessed)
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
            local c2 = UserInputService.InputEnded:Connect(function(input) if input.KeyCode == currentKey and holding then holding = false; if holdToInteract and callback then callback(false) end end end)
            table.insert(WindowAPI.Connections, c1); table.insert(WindowAPI.Connections, c2)
            table.insert(PageElements, KeyFrame)
        end

        return TabAPI
    end

    local ConfigTab = WindowAPI:CreateTab("Config UI", 1000)
    local neonEnabled = false; local currentRGB = {R = 0, G = 255, B = 200}
    local function UpdateThemeColor()
        Theme.Accent = Color3.fromRGB(currentRGB.R, currentRGB.G, currentRGB.B)
        for _, obj in ipairs(UIReferences.Accents) do
            if obj:IsA("TextLabel") then obj.TextColor3 = Theme.Accent
            elseif obj:IsA("Frame") then obj.BackgroundColor3 = Theme.Accent end
        end
        if neonEnabled then MainStroke.Color = Theme.Accent; MainStroke.Thickness = 2; MainStroke.Transparency = 0 end
    end

    ConfigTab:CreateToggle("Anti-AFK", true, function(state) setupAntiAfk(state) end, "AntiAfkFlag", "Impede o Roblox de te kickar por inatividade")
    ConfigTab:CreateToggle("Modo Neon (Borda)", false, function(state) neonEnabled = state; if state then MainStroke.Color = Theme.Accent; MainStroke.Thickness = 2; MainStroke.Transparency = 0 else MainStroke.Color = Theme.Stroke; MainStroke.Thickness = 1 end end, "NeonFlag", "Ativa uma borda brilhante na janela")
    ConfigTab:CreateSlider("Cor Vermelha (R)", 0, 255, 1, 0, function(val) currentRGB.R = val; UpdateThemeColor() end, "RFlag", "Controla a cor vermelha do tema")
    ConfigTab:CreateSlider("Cor Verde (G)", 0, 255, 1, 200, function(val) currentRGB.G = val; UpdateThemeColor() end, "GFlag", "Controla a cor verde do tema")
    ConfigTab:CreateSlider("Cor Azul (B)", 0, 255, 1, 200, function(val) currentRGB.B = val; UpdateThemeColor() end, "BFlag", "Controla a cor azul do tema")
    ConfigTab:CreateColorPicker("Cor da UI", Color3.fromRGB(0, 255, 200), function(c) currentRGB.R = math.floor(c.R * 255); currentRGB.G = math.floor(c.G * 255); currentRGB.B = math.floor(c.B * 255); UpdateThemeColor() end, "UIColorFlag", "Seletor visual de cores HSV")
    ConfigTab:CreateSlider("Transparência da Janela", 0, 1, 0.01, 0, function(val) Main.BackgroundTransparency = val; Topbar.BackgroundTransparency = val end, "TransparencyFlag")
    ConfigTab:CreateButton("Salvar Configuração", function() WindowAPI:SaveConfiguration(); WindowAPI:Notify("Salvo!", "Suas configurações foram salvas.", 3) end, "Salva as configurações no seu PC")
    ConfigTab:CreateButton("Carregar Configuração", function() WindowAPI:LoadConfiguration(); WindowAPI:Notify("Carregado!", "Suas configurações foram carregadas.", 3) end, "Carrega o arquivo salvo")
    ConfigTab:CreateKeybind("Abrir/Fechar Menu", Enum.KeyCode.K, false, function(state) if state == true then uiVisible = not uiVisible; toggleUI(uiVisible) end end, "Fecha a UI (Efeito Buraco Negro)")
    ConfigTab:CreateButton("Fechar Script (Unload)", function() WindowAPI:Unload() end, "Destroi a UI e limpa toda a memoria do script")

    setupAntiAfk(true)
    toggleUI(true)
    return WindowAPI
end

return AnonmyUI
