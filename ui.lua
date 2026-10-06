local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local env = (getgenv or function() return _G end)()
local Library = { Version = "1.0.0" }
local Menu = {}
Menu.__index = Menu
local Tab = {}
Tab.__index = Tab

local function child(parent, name)
    local result = parent:WaitForChild(name, 10)
    assert(result, "NativeMenu: missing " .. name .. "; the Roblox menu layout may have changed")
    return result
end

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties) do object[property] = value end
    object.Parent = parent
    return object
end

local function selected(header, value)
    local selection = header:FindFirstChild("TabSelection")
    if selection then selection.Visible = value end
    local label = header:FindFirstChild("TabLabel")
    if label then
        for _, item in ipairs(label:GetChildren()) do
            if item:IsA("TextLabel") then item.TextTransparency = value and 0 or 0.5 end
        end
    end
end

function Menu:_connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(self.Connections, connection)
    return connection
end

function Menu:_cancelAnimation()
    self.Generation = self.Generation + 1
    for _, entry in ipairs(self.Tweens) do
        entry.Connection:Disconnect()
        entry.Tween:Cancel()
    end
    self.Tweens = {}
    self.Animating = false
end

function Menu:_tween(object, properties, direction, completed, duration)
    if not self.AnimationEnabled or self.AnimationDuration == 0 then
        for property, value in pairs(properties) do object[property] = value end
        if completed then completed() end
        return
    end
    local generation = self.Generation
    local tween = TweenService:Create(object,
        TweenInfo.new(duration or self.AnimationDuration, Enum.EasingStyle.Quad, direction), properties)
    local entry = { Tween = tween }
    entry.Connection = tween.Completed:Connect(function(status)
        entry.Connection:Disconnect()
        local index = table.find(self.Tweens, entry)
        if index then table.remove(self.Tweens, index) end
        if status == Enum.PlaybackState.Completed and generation == self.Generation and not self.Destroyed then
            if completed then completed() end
        end
    end)
    table.insert(self.Tweens, entry)
    tween:Play()
end

function Menu:_reducedMotion()
    local ok, value = pcall(function()
        return UserSettings():GetService("UserGameSettings").ReducedMotion
    end)
    return ok and value == true
end

function Menu:_resizeTabs()
    if self.Destroyed then return end
    local count = #self.NativeTabs + #self.TabList
    local size = UDim2.new(1 / count, 0, 1, 0)
    for _, entry in ipairs(self.NativeTabs) do
        if entry.Header.Size ~= size then entry.Header.Size = size end
    end
    for _, tab in ipairs(self.TabList) do tab.Header.Size = size end
end

function Menu:_hideOtherPages(first, second)
    for _, tab in ipairs(self.TabList) do
        if tab ~= first and tab ~= second then
            tab.Page.Visible = false
            tab.Page.Position = UDim2.new()
            tab.Page.GroupTransparency = 0
        end
    end
end

function Menu:_nativeSelection()
    for _, entry in ipairs(self.NativeTabs) do
        local selection = entry.Header:FindFirstChild("TabSelection")
        if selection and selection.Visible then return entry.Header end
    end
    return self.LastNativeHeader or self.NativeTabs[1].Header
end

function Menu:SelectTab(tab)
    assert(not self.Destroyed, "NativeMenu: this menu was unloaded")
    assert(tab.Menu == self, "NativeMenu: tab belongs to another menu")
    if self.ActiveTab == tab then return end
    local outgoing = self.ActiveTab
    if not outgoing then self.LastNativeHeader = self:_nativeSelection() end
    self:_cancelAnimation()
    self:_hideOtherPages(outgoing, tab)
    self.ActiveTab = tab
    self.Animating = self.AnimationEnabled and self.AnimationDuration > 0
    local direction = (not outgoing or tab.Index > outgoing.Index) and 1 or -1
    for _, entry in ipairs(self.NativeTabs) do selected(entry.Header, false) end
    for _, item in ipairs(self.TabList) do selected(item.Header, item == tab) end
    local reduced = self:_reducedMotion()
    local function finish() self.Animating = false end

    tab.Page.Visible = true
    tab.Page.GroupTransparency = reduced and 1 or 0
    tab.Page.Position = reduced and UDim2.new() or UDim2.fromScale(direction, 0)
    if outgoing then
        if reduced then
            self:_tween(outgoing.Page, { GroupTransparency = 1 }, Enum.EasingDirection.Out,
                function() outgoing.Page.Visible = false end, 0.25)
        else
            self:_tween(outgoing.Page, { Position = UDim2.fromScale(-direction, 0) }, Enum.EasingDirection.Out,
                function() outgoing.Page.Visible = false end)
        end
    elseif self.NativePage.Visible then
        if reduced then
            self.NativePage.Visible = false
        else
            local target = self.NativePosition + UDim2.fromScale(-1, 0)
            self:_tween(self.NativePage, { Position = target }, Enum.EasingDirection.Out, function()
                self.NativePage.Visible = false
                self.NativePage.Position = self.NativePosition
            end)
        end
    end
    if reduced then
        self:_tween(tab.Page, { GroupTransparency = 0 }, Enum.EasingDirection.In, finish, 0.25)
    else
        self:_tween(tab.Page, { Position = UDim2.new() }, Enum.EasingDirection.In, finish)
    end
end

function Menu:ReturnToNative(header, immediate)
    if self.Destroyed then return end
    header = header or (not self.ActiveTab and self:_nativeSelection()) or self.LastNativeHeader or self.NativeTabs[1].Header
    self.LastNativeHeader = header
    local outgoing = self.ActiveTab
    if not outgoing and not immediate then return end
    self:_cancelAnimation()
    self:_hideOtherPages(outgoing, nil)
    self.ActiveTab = nil
    for _, tab in ipairs(self.TabList) do selected(tab.Header, false) end
    for _, entry in ipairs(self.NativeTabs) do selected(entry.Header, entry.Header == header) end
    self.NativePage.Visible = true
    self.NativePage.Position = self.NativePosition
    if immediate or not outgoing then
        self:_hideOtherPages(nil, nil)
        return
    end
    self.Animating = self.AnimationEnabled and self.AnimationDuration > 0
    if self:_reducedMotion() then
        self:_tween(outgoing.Page, { GroupTransparency = 1 }, Enum.EasingDirection.Out, function()
            outgoing.Page.Visible = false
            self.Animating = false
        end, 0.25)
    else
        self.NativePage.Position = self.NativePosition + UDim2.fromScale(-1, 0)
        self:_tween(self.NativePage, { Position = self.NativePosition }, Enum.EasingDirection.In,
            function() self.Animating = false end)
        self:_tween(outgoing.Page, { Position = UDim2.fromScale(1, 0) }, Enum.EasingDirection.Out,
            function() outgoing.Page.Visible = false end)
    end
end

function Menu:AddTab(title, icon)
    assert(not self.Destroyed, "NativeMenu: this menu was unloaded")
    assert(type(title) == "string" and title ~= "", "NativeMenu: tab title must be a non-empty string")
    local index = #self.TabList + 1
    local header = self.Template:Clone()
    header.Name = "NativeMenuTab_" .. index
    header:SetAttribute("NativeMenuOwned", true)
    header.LayoutOrder = self.MaxNativeOrder + index
    header.TabLabel.Title.Text = title
    header.TabLabel.Icon.Visible = icon ~= nil and icon ~= ""
    if icon then header.TabLabel.Icon.Text = icon end
    selected(header, false)
    header.Parent = self.TabBar
    local page = create("CanvasGroup", {
        Name = "NativeMenuPage_" .. index, Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 10,
    }, self.Clipper)
    local content = create("ScrollingFrame", {
        Name = "Content", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4, ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180), ZIndex = 10,
    }, page)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
    }, content)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = self.ContentAlignment, Padding = UDim.new(0, 8),
    }, content)
    local tab = setmetatable({
        Menu = self, Index = index, Title = title, Header = header, Page = page,
        Content = content, Controls = {},
    }, Tab)
    table.insert(self.TabList, tab)
    self.Tabs[title] = tab
    self:_connect(header.Activated, function() self:SelectTab(tab) end)
    self:_resizeTabs()
    return tab
end

function Tab:Select()
    self.Menu:SelectTab(self)
end

function Tab:AddButton(options)
    assert(not self.Menu.Destroyed, "NativeMenu: this menu was unloaded")
    if type(options) == "string" then options = { Text = options } end
    options = options or {}
    local callback = options.Func or options.Callback or function() end
    assert(type(callback) == "function", "NativeMenu: button Func must be a function")
    local row = create("Frame", {
        Name = "ButtonRow", Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1,
        LayoutOrder = #self.Controls + 1, Visible = options.Visible ~= false, ZIndex = 11,
    }, self.Content)
    local button = create("TextButton", {
        Name = options.Name or "Button", AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0.45, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(45, 48, 55), BorderSizePixel = 0,
        Text = options.Text or "Button", TextColor3 = Color3.new(1, 1, 1), TextSize = 19,
        FontFace = self.Menu.Template.TabLabel.Title.FontFace, AutoButtonColor = true, ZIndex = 12,
    }, row)
    create("UISizeConstraint", { MinSize = Vector2.new(100, 48), MaxSize = Vector2.new(260, 48) }, button)
    create("UICorner", { CornerRadius = UDim.new(0, 8) }, button)
    create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(130, 134, 144), Transparency = 0.45, Thickness = 1 }, button)
    local control = { Button = button, Row = row, Disabled = false, ClickCount = 0 }
    function control:SetDisabled(value)
        self.Disabled = value == true
        button.Active = not self.Disabled
        button.AutoButtonColor = not self.Disabled
        button.TextTransparency = self.Disabled and 0.5 or 0
    end
    function control:SetText(text) button.Text = tostring(text) end
    function control:SetVisible(value) row.Visible = value == true end
    control:SetDisabled(options.Disabled == true)
    self.Menu:_connect(button.Activated, function()
        if control.Disabled then return end
        control.ClickCount = control.ClickCount + 1
        local ok, message = xpcall(callback, debug.traceback)
        if not ok then warn("[NativeMenu] Button callback: " .. tostring(message)) end
    end)
    table.insert(self.Controls, control)
    return control
end

function Tab:AddLabel(text)
    assert(not self.Menu.Destroyed, "NativeMenu: this menu was unloaded")
    local label = create("TextLabel", {
        Name = "Label", Size = UDim2.new(1, 0, 0, 32), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Text = tostring(text), TextWrapped = true,
        TextColor3 = Color3.new(1, 1, 1), TextSize = 19,
        FontFace = self.Menu.Template.TabLabel.Title.FontFace,
        LayoutOrder = #self.Controls + 1, ZIndex = 11,
    }, self.Content)
    table.insert(self.Controls, label)
    return label
end

function Menu:Unload()
    if self.Destroyed then return end
    self:ReturnToNative(nil, true)
    self:_cancelAnimation()
    self.Destroyed = true
    for _, connection in ipairs(self.Connections) do connection:Disconnect() end
    local focus = GuiService.SelectedCoreObject
    for _, tab in ipairs(self.TabList) do
        if focus and (focus == tab.Header or focus:IsDescendantOf(tab.Page)) then
            GuiService.SelectedCoreObject = nil
        end
        tab.Header:Destroy()
        tab.Page:Destroy()
    end
    for _, entry in ipairs(self.NativeTabs) do
        if entry.Header.Parent then entry.Header.Size = entry.Size end
    end
    self.NativePage.Position = self.NativePosition
    self.Connections = {}
    if env.NativeMenuInstance == self then env.NativeMenuInstance = nil end
end

function Library:CreateMenu(options)
    options = options or {}

    local robloxGui = child(CoreGui, "RobloxGui")
    local shield = child(robloxGui, "SettingsClippingShield")
    local settingsShield = child(shield, "SettingsShield")
    local page = child(child(settingsShield, "MenuContainer"), "Page")
    local tabBar = child(child(child(page, "HubBar"), "TabHeaderContainer"), "HubBarContainer")
    local clipper = child(page, "PageViewClipper")
    local nativePage = child(clipper, "PageView")
    local template = child(tabBar, "HelpTab")
    assert(template:FindFirstChild("TabLabel"), "NativeMenu: unsupported tab header layout")
    if env.CurrentUITestTab and type(env.CurrentUITestTab.Cleanup) == "function" then
        env.CurrentUITestTab.Cleanup()
    end
    if env.NativeMenuInstance then env.NativeMenuInstance:Unload() end
    local self = setmetatable({
        Tabs = {}, TabList = {}, NativeTabs = {}, Connections = {}, Tweens = {}, Generation = 0,
        TabBar = tabBar, Clipper = clipper, NativePage = nativePage,
        NativePosition = nativePage.Position, Template = template,
        Shield = settingsShield, Destroyed = false, Animating = false, MaxNativeOrder = 0,
        AnimationEnabled = options.AnimationEnabled ~= false,
        AnimationDuration = math.max(0, tonumber(options.AnimationDuration) or 0.1),
        ContentAlignment = options.ContentAlignment or Enum.VerticalAlignment.Top,
    }, Menu)
    for _, header in ipairs(tabBar:GetChildren()) do
        if header:IsA("GuiButton") then
            table.insert(self.NativeTabs, { Header = header, Size = header.Size })
            self.MaxNativeOrder = math.max(self.MaxNativeOrder, header.LayoutOrder)
        end
    end
    assert(#self.NativeTabs > 0, "NativeMenu: no native tabs found")
    self.LastNativeHeader = self:_nativeSelection()
    for _, entry in ipairs(self.NativeTabs) do
        local function nativeClicked()
            self.LastNativeHeader = entry.Header
            if self.ActiveTab then self:ReturnToNative(entry.Header) end
        end
        self:_connect(entry.Header.Activated, nativeClicked)
        self:_connect(entry.Header.MouseButton1Click, nativeClicked)
        local selection = entry.Header:FindFirstChild("TabSelection")
        if selection then
            self:_connect(selection:GetPropertyChangedSignal("Visible"), function()
                if selection.Visible then
                    self.LastNativeHeader = entry.Header
                    if self.ActiveTab then self:ReturnToNative(entry.Header) end
                end
            end)
        end
        self:_connect(entry.Header:GetPropertyChangedSignal("Size"), function() self:_resizeTabs() end)
    end
    local function resetWhenClosed()
        if not shield.Visible or not settingsShield.Visible or not robloxGui.Enabled then
            self:ReturnToNative(nil, true)
        end
    end
    self:_connect(shield:GetPropertyChangedSignal("Visible"), resetWhenClosed)
    self:_connect(settingsShield:GetPropertyChangedSignal("Visible"), resetWhenClosed)
    self:_connect(robloxGui:GetPropertyChangedSignal("Enabled"), resetWhenClosed)
    env.NativeMenuInstance = self
    return self
end

Library.CreateWindow = Library.CreateMenu
function Library:Unload()
    if env.NativeMenuInstance then env.NativeMenuInstance:Unload() end
end
return Library
