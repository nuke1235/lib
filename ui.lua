local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local env = (getgenv or function() return _G end)()
local Library = { Options = {}, Toggles = {}, Unloaded = false }
local Menu = {}
Menu.__index = Menu
local Container = {}
Container.__index = Container
local Control = {}
Control.__index = Control
local Tab = {}
Tab.__index = function(_, key) return Tab[key] or Container[key] end

local function child(parent, name)
    local result = parent:WaitForChild(name, 10)
    assert(result, "Missing UI object: " .. name)
    return result
end

local function nativeBackground(root, names, fallback)
    local object = root
    for _, name in ipairs(names) do
        object = object and object:FindFirstChild(name)
    end
    if object and object:IsA("GuiObject") then
        local ok, color, transparency = pcall(function()
            return object:GetStyled("BackgroundColor3"), object:GetStyled("BackgroundTransparency")
        end)
        if ok then return color, transparency end
    end
    return fallback, 0
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
    assert(not self.Destroyed, "Menu is unloaded")
    assert(tab.Menu == self, "Tab belongs to another menu")
    if self.ActiveTab == tab then return end
    self:ClosePopup()
    self:_endDrag()
    self:_cancelCapture()
    self.Tooltip.Visible = false
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
    self:ClosePopup()
    self:_endDrag()
    self:_cancelCapture()
    self.Tooltip.Visible = false
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
    assert(not self.Destroyed, "Menu is unloaded")
    assert(type(title) == "string" and title ~= "", "Tab title must be a non-empty string")
    assert(not self.Tabs[title], "Duplicate tab title: " .. title)
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
        Content = content, Controls = {}, RootTab = nil,
    }, Tab)
    tab.RootTab = tab
    table.insert(self.TabList, tab)
    self.Tabs[title] = tab
    self:_connect(header.Activated, function() self:SelectTab(tab) end)
    self:_resizeTabs()
    return tab
end

function Tab:Select()
    self.Menu:SelectTab(self)
end

function Menu:Unload()
    if self.Destroyed then return end
    self:ReturnToNative(nil, true)
    self:_cancelAnimation()
    self.Destroyed = true
    self.Library.Unloaded = true
    self.PopupGui:Destroy()
    for _, event in ipairs(self.Events) do event:Destroy() end
    for _, callback in ipairs(self.UnloadCallbacks) do
        local ok, message = xpcall(callback, debug.traceback)
        if not ok then warn(message) end
    end
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
    local inner = nativePage:FindFirstChild("PageViewInnerFrame")
    local surfaceColor, surfaceTransparency = nativeBackground(inner,
        { "Captures", "CapturesPage", "CapturesGallery" }, Color3.fromRGB(18, 18, 21))
    local buttonColor, buttonTransparency = nativeBackground(inner,
        { "peoplepage", "FocusRoot", "PeopleReactView", "PeopleHeader", "CoreButtonRow", "inviteFriends" }, Color3.fromRGB(32, 34, 39))
    local template = child(tabBar, "HelpTab")
    assert(template:FindFirstChild("TabLabel"), "Unsupported tab header layout")
    if env.CurrentUITestTab and type(env.CurrentUITestTab.Cleanup) == "function" then
        env.CurrentUITestTab.Cleanup()
    end
    if env.NativeMenuInstance then env.NativeMenuInstance:Unload() end
    table.clear(self.Options)
    table.clear(self.Toggles)
    self.Unloaded = false
    local library = self
    local self = setmetatable({
        Tabs = {}, TabList = {}, NativeTabs = {}, Connections = {}, Tweens = {}, Generation = 0,
        TabBar = tabBar, Clipper = clipper, NativePage = nativePage,
        NativePosition = nativePage.Position, Template = template,
        Shield = settingsShield, Destroyed = false, Animating = false, MaxNativeOrder = 0,
        AnimationEnabled = options.AnimationEnabled ~= false,
        AnimationDuration = math.max(0, tonumber(options.AnimationDuration) or 0.1),
        ContentAlignment = options.ContentAlignment or Enum.VerticalAlignment.Top,
        Library = library, Options = library.Options, Toggles = library.Toggles,
        Events = {}, UnloadCallbacks = {}, PopupConnections = {}, Keybinds = {},
        SurfaceColor = surfaceColor, SurfaceTransparency = surfaceTransparency,
        ButtonColor = buttonColor, ButtonTransparency = buttonTransparency,
        ConfigFolder = options.ConfigFolder or "configs", Accent = options.Accent or Color3.fromRGB(85, 135, 255),
    }, Menu)
    for _, header in ipairs(tabBar:GetChildren()) do
        if header:IsA("GuiButton") then
            table.insert(self.NativeTabs, { Header = header, Size = header.Size })
            self.MaxNativeOrder = math.max(self.MaxNativeOrder, header.LayoutOrder)
        end
    end
    assert(#self.NativeTabs > 0, "No native tabs found")
    self:_initOverlay(robloxGui)
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
    library.Menu = self
    return self
end

local function invoke(callback, ...)
    if not callback then return end
    local ok, message = xpcall(callback, debug.traceback, ...)
    if not ok then warn(message) end
end

local function same(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then return a == b end
    for key, value in pairs(a) do if b[key] ~= value then return false end end
    for key, value in pairs(b) do if a[key] ~= value then return false end end
    return true
end

local function copy(value)
    return type(value) == "table" and table.clone(value) or value
end

local function screenPosition(object)
    local screen = object:FindFirstAncestorWhichIsA("ScreenGui")
    return object.AbsolutePosition + ((screen and not screen.IgnoreGuiInset) and GuiService:GetGuiInset() or Vector2.zero)
end

local function pointer(input)
    if input and input.UserInputType == Enum.UserInputType.Touch then
        return Vector2.new(input.Position.X, input.Position.Y)
    end
    return UserInputService:GetMouseLocation()
end

local function text(menu, parent, properties)
    local defaults = {
        Name = "Text", BackgroundTransparency = 1, BorderSizePixel = 0,
        FontFace = menu.Template.TabLabel.Title.FontFace, TextColor3 = Color3.new(1, 1, 1),
        TextSize = 17, Text = "", TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
    }
    for key, value in pairs(properties or {}) do defaults[key] = value end
    return create("TextLabel", defaults, parent)
end

local function button(menu, parent, properties)
    local defaults = {
        Name = "Button", BackgroundColor3 = menu.ButtonColor, BackgroundTransparency = menu.ButtonTransparency, BorderSizePixel = 0,
        FontFace = menu.Template.TabLabel.Title.FontFace, TextColor3 = Color3.new(1, 1, 1),
        TextSize = 16, Text = "", AutoButtonColor = true, ZIndex = 12,
    }
    for key, value in pairs(properties or {}) do defaults[key] = value end
    local result = create("TextButton", defaults, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, result)
    create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(208, 217, 251), Transparency = 0.88 }, result)
    return result
end

local function inputBox(menu, parent, properties)
    local defaults = {
        Name = "Input", BackgroundColor3 = menu.SurfaceColor, BackgroundTransparency = menu.SurfaceTransparency, BorderSizePixel = 0,
        FontFace = menu.Template.TabLabel.Title.FontFace, TextColor3 = Color3.new(1, 1, 1),
        PlaceholderColor3 = Color3.fromRGB(145, 150, 160), TextSize = 16, Text = "",
        ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
    }
    for key, value in pairs(properties or {}) do defaults[key] = value end
    local result = create("TextBox", defaults, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, result)
    if defaults.BackgroundTransparency < 1 then
        create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(208, 217, 251), Transparency = 0.88 }, result)
    end
    create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, result)
    return result
end

function Menu:_event()
    local event = Instance.new("BindableEvent")
    table.insert(self.Events, event)
    return event
end

function Menu:_popupConnect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(self.PopupConnections, connection)
    return connection
end

function Menu:ClosePopup()
    if self.Popup and self.Drag then self:_endDrag() end
    for _, connection in ipairs(self.PopupConnections) do connection:Disconnect() end
    self.PopupConnections = {}
    if self.Popup then
        local popup = self.Popup
        self.Popup = nil
        popup.Frame:Destroy()
        if popup.Close then popup.Close() end
    end
    if self.Outside then self.Outside.Visible = false end
end

function Menu:_positionPopup()
    local popup = self.Popup
    if not popup then return end
    local anchor = popup.Owner.Main
    if not anchor.Parent then self:ClosePopup() return end
    local ancestor = anchor
    while ancestor and ancestor ~= CoreGui do
        if ancestor:IsA("GuiObject") and not ancestor.Visible then self:ClosePopup() return end
        if ancestor:IsA("ScreenGui") and not ancestor.Enabled then self:ClosePopup() return end
        ancestor = ancestor.Parent
    end
    local position = screenPosition(anchor)
    local size = self.Overlay.AbsoluteSize
    local width, height = popup.Frame.Size.X.Offset, popup.Frame.Size.Y.Offset
    local x = math.clamp(position.X + anchor.AbsoluteSize.X - width, 8, math.max(8, size.X - width - 8))
    local y = position.Y + anchor.AbsoluteSize.Y + 6
    if y + height > size.Y - 8 then y = position.Y - height - 6 end
    popup.Frame.Position = UDim2.fromOffset(x, math.clamp(y, 8, math.max(8, size.Y - height - 8)))
end

function Menu:_openPopup(owner, size, close)
    self:ClosePopup()
    self.Tooltip.Visible = false
    local frame = create("Frame", {
        Name = "Popup", Size = UDim2.fromOffset(size.X, size.Y),
        BackgroundColor3 = self.SurfaceColor, BackgroundTransparency = self.SurfaceTransparency, BorderSizePixel = 0, ZIndex = 100,
    }, self.Overlay)
    create("UICorner", { CornerRadius = UDim.new(0, 8) }, frame)
    create("UIStroke", { Color = Color3.fromRGB(208, 217, 251), Transparency = 0.88 }, frame)
    self.Popup = { Owner = owner, Frame = frame, Close = close }
    self.Outside.Visible = true
    self:_positionPopup()
    return frame
end

function Menu:_endDrag()
    local drag = self.Drag
    self.Drag = nil
    if drag then
        if drag.Scroll and drag.Scroll.Parent then drag.Scroll.ScrollingEnabled = drag.ScrollingEnabled end
        if drag.Finish then drag.Finish() end
    end
end

function Menu:_beginDrag(control, input, update, finish)
    if control:_isDisabled() then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    self:_endDrag()
    local scroll = control.Container.RootTab.Content
    self.Drag = { Input = input, Update = update, Finish = finish,
        Scroll = scroll, ScrollingEnabled = scroll.ScrollingEnabled }
    scroll.ScrollingEnabled = false
    update(pointer(input))
end

function Menu:_cancelCapture()
    if self.CapturingKey then
        local control = self.CapturingKey
        self.CapturingKey = nil
        control:_render()
    end
end

function Menu:_initOverlay(robloxGui)
    self.PopupGui = create("ScreenGui", {
        Name = "Overlay", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = robloxGui.DisplayOrder + 10, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)
    self.Overlay = create("Frame", {
        Name = "Overlay", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    }, self.PopupGui)
    self.Outside = create("TextButton", {
        Name = "Outside", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "", Visible = false, ZIndex = 90,
    }, self.Overlay)
    self:_connect(self.Outside.Activated, function() self:ClosePopup() self:_endDrag() end)
    self.Tooltip = create("Frame", {
        Name = "Tooltip", Size = UDim2.new(0, 260, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = self.SurfaceColor, BackgroundTransparency = self.SurfaceTransparency, BorderSizePixel = 0, Visible = false, ZIndex = 200,
    }, self.Overlay)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, self.Tooltip)
    self.TooltipLabel = text(self, self.Tooltip, {
        Size = UDim2.new(1, -20, 0, 0), Position = UDim2.fromOffset(10, 8),
        AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, TextSize = 14, ZIndex = 201,
    })
    create("UIPadding", { PaddingBottom = UDim.new(0, 8) }, self.Tooltip)
    self.NotificationHolder = create("Frame", {
        Name = "Notifications", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -20, 0, 78),
        Size = UDim2.new(0, 300, 1, -100), BackgroundTransparency = 1, ZIndex = 210,
    }, self.Overlay)
    create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, self.NotificationHolder)
    self:_connect(RunService.RenderStepped, function()
        if self.Popup then self:_positionPopup() end
    end)
    self:_connect(UserInputService.InputChanged, function(input)
        if self.Drag then
            local drag = self.Drag
            if input == drag.Input or (drag.Input.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseMovement) then drag.Update(pointer(input)) end
        end
        if self.Tooltip.Visible then self:_moveTooltip() end
    end)
    self:_connect(UserInputService.InputBegan, function(input, processed)
        if self.CapturingKey then
            local control = self.CapturingKey
            if input.KeyCode == Enum.KeyCode.Escape then self:_cancelCapture() return end
            local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
            if key == Enum.KeyCode.Backspace then key = nil end
            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                self.CapturingKey = nil
                control:SetValue({ key or "None", control.Mode })
            end
            return
        end
        if input.KeyCode == Enum.KeyCode.Escape then self:ClosePopup() end
        if UserInputService:GetFocusedTextBox() then return end
        for _, control in ipairs(self.Keybinds) do control:_keyBegan(input, processed) end
    end)
    self:_connect(UserInputService.InputEnded, function(input)
        if self.Drag and (input == self.Drag.Input or input.UserInputType == Enum.UserInputType.MouseButton1) then self:_endDrag() end
        for _, control in ipairs(self.Keybinds) do control:_keyEnded(input) end
    end)
    self:_connect(UserInputService.WindowFocusReleased, function()
        self:_endDrag()
        self:_cancelCapture()
        for _, control in ipairs(self.Keybinds) do
            if control.Mode == "Hold" and control.State then control:_setState(false) end
        end
    end)
end

function Menu:_moveTooltip()
    local position = UserInputService:GetMouseLocation() + Vector2.new(16, 16)
    local size, view = self.Tooltip.AbsoluteSize, self.Overlay.AbsoluteSize
    self.Tooltip.Position = UDim2.fromOffset(
        math.clamp(position.X, 8, math.max(8, view.X - size.X - 8)),
        math.clamp(position.Y, 8, math.max(8, view.Y - size.Y - 8)))
end

function Menu:_tooltip(control, object)
    self:_connect(object.MouseEnter, function()
        local value = control:_isDisabled() and control.Settings.DisabledTooltip or control.Settings.Tooltip
        if value and value ~= "" and not self.Popup and self.Shield.Visible then
            self.TooltipLabel.Text = value
            self.Tooltip.Visible = true
            self:_moveTooltip()
        end
    end)
    self:_connect(object.MouseLeave, function() self.Tooltip.Visible = false end)
end

function Menu:Notify(value, duration)
    if self.Destroyed then return end
    local options = type(value) == "table" and value or { Text = tostring(value), Duration = duration }
    local frame = create("Frame", {
        Name = "Notification", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = self.SurfaceColor, BackgroundTransparency = self.SurfaceTransparency, BorderSizePixel = 0, ZIndex = 210,
    }, self.NotificationHolder)
    create("UICorner", { CornerRadius = UDim.new(0, 8) }, frame)
    create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12) }, frame)
    create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
    if options.Title and options.Title ~= "" then
        text(self, frame, { Text = options.Title, Size = UDim2.new(1, 0, 0, 22), LayoutOrder = 1, ZIndex = 211 })
    end
    text(self, frame, { Text = options.Text or "", Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, TextSize = 15, LayoutOrder = 2, ZIndex = 211 })
    task.delay(options.Duration or 3, function() if frame.Parent then frame:Destroy() end end)
    return frame
end

function Control:_isDisabled()
    return self.Disabled or (self.Root and self.Root ~= self and self.Root.Disabled)
end

function Control:_emit()
    if not self.Menu.Destroyed then self.Changed:Fire(copy(self.Value), self.Transparency) end
end

function Control:OnChanged(callback)
    self.Menu:_connect(self.Changed.Event, function(...) invoke(callback, ...) end)
    return self
end

function Control:SetValue(value, silent)
    assert(not self.Menu.Destroyed, "Menu is unloaded")
    value = self:Normalize(value)
    local changed = not same(self.Value, value)
    self.Value = copy(value)
    self:_render()
    if changed and not silent then self:_emit() end
    return self
end

function Control:SetDisabled(value)
    self.Disabled = value == true
    self:_render()
    if self.Label then self.Label.TextTransparency = self:_isDisabled() and 0.5 or 0 end
    for _, control in ipairs(self.Addons or {}) do control:_render() end
    if self.Menu.Popup and self.Menu.Popup.Owner:_isDisabled() then self.Menu:ClosePopup() end
    return self
end

function Control:SetVisible(value)
    if self.Root ~= self then self.Main.Visible = value == true else self.Row.Visible = value == true end
    self.Root:_layout()
    if not value and self.Menu.Popup and self.Menu.Popup.Owner.Row == self.Row then self.Menu:ClosePopup() end
    return self
end

function Control:SetText(value)
    if self.Label then self.Label.Text = tostring(value) end
    return self
end

function Control:_layout()
    local offset = 0
    for index = #self.Addons, 1, -1 do
        local addon = self.Addons[index]
        if addon.Main.Visible then
            addon.Main.AnchorPoint = Vector2.new(1, 0.5)
            addon.Main.Position = UDim2.new(1, -offset, 0.5, 0)
            addon.Main.Size = UDim2.fromOffset(addon.Width, 32)
            offset = offset + addon.Width + 8
        end
    end
    local width = self.Row.AbsoluteSize.X
    if self.Type == "Button" then
        self.Host.Size = UDim2.fromScale(1, 1)
    elseif self.Type ~= "Label" or #self.Addons > 0 then
        local minimum = self.Type == "Toggle" and 52 or self.Type == "Checkbox" and 28 or 60
        local ratio = math.max(0.5, math.min(0.78, (minimum + offset) / math.max(1, width)))
        self.Host.Size = UDim2.new(ratio, 0, 1, 0)
        if self.Label then self.Label.Size = UDim2.new(1 - ratio, -8, 1, 0) end
    end
    self.Main.Size = UDim2.new(1, -offset, 0, self.MainHeight)
end

function Menu:_control(container, id, settings, kind, height, root, width)
    assert(not self.Destroyed, "Menu is unloaded")
    settings = settings or {}
    local registry = (kind == "Toggle" or kind == "Checkbox") and self.Toggles or self.Options
    if id then
        assert(type(id) == "string" and id ~= "", "Control ID must be a non-empty string")
        assert(not self.Options[id] and not self.Toggles[id], "Duplicate control ID: " .. id)
    end
    local control = setmetatable({ Menu = self, Container = container, ID = id, Type = kind,
        Settings = settings, Disabled = settings.Disabled == true, Addons = {}, MainHeight = height - 8,
        Width = width, Changed = self:_event() }, Control)
    if root then
        control.Root, control.Row, control.Host = root.Root, root.Row, root.Host
        table.insert(root.Root.Addons, control)
    else
        control.Root = control
        control.Row = create("Frame", {
            Name = id or settings.Name or (kind .. "_" .. (#container.Controls + 1)), Size = UDim2.new(1, 0, 0, height), BackgroundTransparency = 1,
            LayoutOrder = #container.Controls + 1, Visible = settings.Visible ~= false, ZIndex = 11,
        }, container.Content)
        control.Label = text(self, control.Row, { Text = settings.Text or "", Size = UDim2.new(0.48, -8, 1, 0),
            TextWrapped = true, TextSize = 16, TextColor3 = settings.Risky and Color3.fromRGB(255, 120, 120) or Color3.new(1, 1, 1) })
        control.Host = create("Frame", { Name = "Value", AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5), Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 12 }, control.Row)
        table.insert(container.Controls, control)
        self:_connect(control.Row:GetPropertyChangedSignal("AbsoluteSize"), function() control:_layout() end)
    end
    control.Main = create("Frame", { Name = root and (kind .. "_Addon_" .. #control.Root.Addons) or kind,
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, height - 8), Visible = settings.Visible ~= false,
        ZIndex = 12 }, control.Host)
    control.Root:_layout()
    if id then registry[id] = control end
    if kind == "KeyPicker" then
        if settings.ChangedCallback then control:OnChanged(settings.ChangedCallback) end
    elseif kind ~= "Button" and settings.Callback then control:OnChanged(settings.Callback) end
    self:_tooltip(control, root and control.Main or control.Row)
    return control
end

function Menu:SetAnimationEnabled(value) self.AnimationEnabled = value == true end
function Menu:SetAnimationDuration(value) self.AnimationDuration = math.max(0, tonumber(value) or 0.1) end
function Menu:OnUnload(callback) table.insert(self.UnloadCallbacks, callback) return self end

function Container:_addButton(settings, root)
    settings = settings or {}
    local control = self.Menu:_control(self, nil, settings, "Button", 44, root, 110)
    if not root then
        control.Label.Visible = false
        control.Host.Size = UDim2.fromScale(1, 1)
    end
    control.Button = button(self.Menu, control.Main, { Name = settings.Name or "Button",
        Text = settings.Text or "Button", Size = UDim2.fromScale(1, 1) })
    function control:_render()
        self.Button.Active = not self:_isDisabled()
        self.Button.AutoButtonColor = not self:_isDisabled()
        self.Button.TextTransparency = self:_isDisabled() and 0.5 or 0
    end
    function control:SetText(value)
        settings.Text = tostring(value)
        self.Button.Text = settings.Text
        return self
    end
    control.Clicked, control.ClickCount = self.Menu:_event(), 0
    function control:OnClick(callback)
        self.Menu:_connect(self.Clicked.Event, function() invoke(callback) end)
        return self
    end
    local callback = settings.Func or settings.Callback
    if callback then control:OnClick(callback) end
    self.Menu:_connect(control.Button.Activated, function()
        if control:_isDisabled() then return end
        if settings.DoubleClick and (not control.LastClick or os.clock() - control.LastClick > 0.4) then
            control.LastClick = os.clock()
            control.Button.Text = "Click again"
            task.delay(0.4, function()
                if not control.Menu.Destroyed and control.Button.Parent and control.LastClick then
                    control.Button.Text = settings.Text or "Button"
                    control.LastClick = nil
                end
            end)
            return
        end
        control.LastClick = nil
        control.Button.Text = settings.Text or "Button"
        control.ClickCount = control.ClickCount + 1
        control.Clicked:Fire()
    end)
    control:_render()
    return control
end

function Container:AddButton(settings, callback)
    if type(settings) == "string" then settings = { Text = settings, Func = callback } end
    return self:_addButton(settings)
end

function Control:AddButton(settings)
    return self.Container:_addButton(settings, self.Root)
end

function Container:_addToggle(id, settings, checkbox)
    local control = self.Menu:_control(self, id, settings, checkbox and "Checkbox" or "Toggle", 44)
    local target = button(self.Menu, control.Main, { Name = "Toggle", Text = "", AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(checkbox and 28 or 52, 28) })
    local indicator
    if checkbox then
        indicator = text(self.Menu, target, { Text = "✓", TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.fromScale(1, 1), TextSize = 20, ZIndex = 13 })
    else
        indicator = create("Frame", { Name = "Knob", Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromOffset(4, 4), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 13 }, target)
        create("UICorner", { CornerRadius = UDim.new(1, 0) }, indicator)
    end
    control.Button, control.Indicator = target, indicator
    function control:Normalize(value) return value == true end
    function control:_render()
        local disabled = self:_isDisabled()
        target.BackgroundColor3 = self.Value and self.Menu.Accent or self.Menu.ButtonColor
        target.BackgroundTransparency = disabled and 0.5 or (self.Value and 0 or self.Menu.ButtonTransparency)
        target.Active = not disabled
        if checkbox then indicator.Visible = self.Value == true
        else indicator.Position = UDim2.fromOffset(self.Value and 28 or 4, 4) end
    end
    control:SetValue(settings.Default == true, true)
    self.Menu:_connect(target.Activated, function() if not control:_isDisabled() then control:SetValue(not control.Value) end end)
    return control
end

function Container:AddToggle(id, settings) return self:_addToggle(id, settings or {}, false) end
function Container:AddCheckbox(id, settings) return self:_addToggle(id, settings or {}, true) end

function Container:AddSlider(id, settings)
    settings = settings or {}
    local control = self.Menu:_control(self, id, settings, "Slider", 64)
    control.Min, control.Max = settings.Min or 0, settings.Max or 100
    assert(control.Max > control.Min, "Slider Max must be greater than Min")
    control.Rounding = math.clamp(math.floor(settings.Rounding or 0), 0, 6)
    local track = create("TextButton", { Name = "Track", Text = "", AutoButtonColor = false,
        Position = UDim2.new(0, 0, 1, -20), Size = UDim2.new(1, 0, 0, 16),
        BackgroundColor3 = self.Menu.ButtonColor, BackgroundTransparency = self.Menu.ButtonTransparency, BorderSizePixel = 0, ZIndex = 12 }, control.Main)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, track)
    local fill = create("Frame", { Name = "Fill", Size = UDim2.fromScale(0, 1), BackgroundColor3 = self.Menu.Accent,
        BorderSizePixel = 0, ZIndex = 13 }, track)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)
    local knob = create("Frame", { Name = "Knob", AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromScale(0, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 14 }, track)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)
    local valueBox = inputBox(self.Menu, control.Main, { Name = "Number", BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28), TextXAlignment = Enum.TextXAlignment.Right })
    control.Track, control.Input, control.Fill, control.Knob = track, valueBox, fill, knob
    function control:Normalize(value)
        value = tonumber(value)
        assert(value and value == value and math.abs(value) < math.huge, "Invalid slider value")
        local factor = 10 ^ self.Rounding
        return math.clamp(math.floor(value * factor + 0.5) / factor, self.Min, self.Max)
    end
    function control:_render()
        local fraction = ((self.Value or self.Min) - self.Min) / (self.Max - self.Min)
        fill.Size = UDim2.fromScale(fraction, 1)
        fill.BackgroundColor3 = self.Menu.Accent
        knob.Position = UDim2.fromScale(fraction, 0.5)
        local disabled = self:_isDisabled()
        valueBox.TextEditable, track.Active = not disabled, not disabled
        valueBox.TextTransparency = disabled and 0.5 or 0
        fill.BackgroundTransparency = disabled and 0.5 or 0
        if not valueBox:IsFocused() then
            valueBox.Text = tostring(self.Value) .. (settings.Suffix or "")
        end
    end
    function control:SetMinMax(minimum, maximum)
        assert(maximum > minimum, "Slider Max must be greater than Min")
        self.Min, self.Max = minimum, maximum
        return self:SetValue(self.Value)
    end
    control:SetValue(settings.Default or control.Min, true)
    self.Menu:_connect(valueBox.Focused, function() valueBox.Text = tostring(control.Value) end)
    self.Menu:_connect(valueBox.FocusLost, function()
        local value = tonumber(valueBox.Text)
        if value then control:SetValue(value) end
        control:_render()
    end)
    self.Menu:_connect(track.InputBegan, function(input)
        self.Menu:_beginDrag(control, input, function(position)
            local fraction = math.clamp((position.X - screenPosition(track).X) / math.max(1, track.AbsoluteSize.X), 0, 1)
            control:SetValue(control.Min + fraction * (control.Max - control.Min))
        end)
    end)
    self.Menu:_connect(track.SelectionGained, function() control.Focused = true end)
    self.Menu:_connect(track.SelectionLost, function() control.Focused = false end)
    self.Menu:_connect(UserInputService.InputBegan, function(input)
        if not control.Focused or control:_isDisabled() or UserInputService:GetFocusedTextBox() then return end
        local delta = (input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.DPadLeft) and -1
            or ((input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.DPadRight) and 1 or nil)
        if delta then control:SetValue(control.Value + delta / (10 ^ control.Rounding)) end
    end)
    return control
end

function Container:AddInput(id, settings)
    settings = settings or {}
    local control = self.Menu:_control(self, id, settings, "Input", settings.MultiLine and 88 or 44)
    local box = inputBox(self.Menu, control.Main, { Name = "Input", Size = UDim2.fromScale(1, 1),
        PlaceholderText = settings.Placeholder or "", MultiLine = settings.MultiLine == true,
        TextWrapped = settings.MultiLine == true, TextYAlignment = settings.MultiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center })
    control.Input = box
    function control:Normalize(value)
        local result = tostring(value or "")
        if settings.MaxLength then result = string.sub(result, 1, settings.MaxLength) end
        if settings.Numeric then
            local number = tonumber(result)
            assert(number and number == number and math.abs(number) < math.huge, "Input must be numeric")
            result = tostring(number)
        end
        return result
    end
    function control:_render()
        box.TextEditable = not self:_isDisabled()
        box.TextTransparency = self:_isDisabled() and 0.5 or 0
        if box.Text ~= self.Value then self.Rendering = true box.Text = self.Value or "" self.Rendering = false end
    end
    control:SetValue(settings.Default or (settings.Numeric and "0" or ""), true)
    local function commit()
        if control.Rendering or control:_isDisabled() then return end
        local ok, value = pcall(control.Normalize, control, box.Text)
        if ok then control:SetValue(value) elseif not box:IsFocused() then control:_render() end
    end
    self.Menu:_connect(box:GetPropertyChangedSignal("Text"), function()
        if settings.Finished ~= true then commit() end
    end)
    self.Menu:_connect(box.FocusLost, commit)
    return control
end

function Container:AddLabel(value, settings, id)
    if type(settings) == "table" then id, value, settings = value, settings.Text or "", settings
    else settings = { Text = value } end
    local control = self.Menu:_control(self, id, settings, "Label", 36)
    control.Host.Visible = false
    control.Label.Size = UDim2.fromScale(1, 1)
    control.Label.Text = tostring(value or "")
    control.Label.RichText = settings.RichText == true
    function control:_render() self.Label.TextTransparency = self:_isDisabled() and 0.5 or 0 end
    function control:SetText(newText)
        self.Label.Text = tostring(newText)
        task.defer(function()
            if self.Row.Parent then self.Row.Size = UDim2.new(1, 0, 0, math.max(36, self.Label.TextBounds.Y + 8)) end
        end)
        return self
    end
    self.Menu:_connect(control.Label:GetPropertyChangedSignal("TextBounds"), function()
        control.Row.Size = UDim2.new(1, 0, 0, math.max(36, control.Label.TextBounds.Y + 8))
    end)
    control:_render()
    return control
end

function Container:AddParagraph(title, content)
    local label = self:AddLabel("<b>" .. tostring(title) .. "</b>\n" .. tostring(content))
    label.Label.RichText = true
    return label
end

function Container:AddDivider()
    local frame = create("Frame", { Name = "Divider", Size = UDim2.new(1, 0, 0, 12),
        BackgroundTransparency = 1, LayoutOrder = #self.Controls + 1, ZIndex = 11 }, self.Content)
    create("Frame", { Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.fromRGB(96, 103, 116), BackgroundTransparency = 0.55,
        BorderSizePixel = 0, ZIndex = 12 }, frame)
    table.insert(self.Controls, frame)
    return frame
end

function Container:AddDropdown(id, settings)
    settings = settings or {}
    local control = self.Menu:_control(self, id, settings, "Dropdown", 44)
    control.Multi, control.Searchable = settings.Multi == true, settings.Searchable == true
    control.Values, control.Entries = {}, {}
    control.Button = button(self.Menu, control.Main, { Name = "Dropdown", Text = "", Size = UDim2.fromScale(1, 1),
        TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left })
    create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 20) }, control.Button)
    text(self.Menu, control.Button, { Text = "⌄", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(18, 24), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 13 })
    function control:_allowed(key)
        for _, entry in ipairs(self.Entries) do if entry.Key == key then return true end end
        return false
    end
    function control:Normalize(value)
        if self.Multi then
            local result = {}
            if type(value) == "table" then
                for key, enabled in pairs(value) do
                    if self:_allowed(key) and enabled == true then result[key] = true
                    elseif self:_allowed(enabled) then result[enabled] = true end
                end
            end
            return result
        end
        if self:_allowed(value) then return value end
        if type(value) == "number" and self.Entries[value] then return self.Entries[value].Key end
        if settings.AllowNull == false and self.Entries[1] then return self.Entries[1].Key end
        return nil
    end
    function control:_render()
        local labels = {}
        for _, entry in ipairs(self.Entries) do
            if self.Multi and self.Value and self.Value[entry.Key] or (not self.Multi and self.Value == entry.Key) then
                table.insert(labels, entry.Label)
            end
        end
        self.Button.Text = #labels > 0 and table.concat(labels, ", ") or (settings.Placeholder or "Select")
        self.Button.Active = not self:_isDisabled()
        self.Button.TextTransparency = self:_isDisabled() and 0.5 or 0
        for key, item in pairs(self.Items or {}) do
            local chosen = self.Multi and self.Value and self.Value[key] or (not self.Multi and self.Value == key)
            item.Button.BackgroundColor3 = chosen and self.Menu.Accent or self.Menu.SurfaceColor
            item.Button.BackgroundTransparency = chosen and 0 or self.Menu.SurfaceTransparency
        end
    end
    function control:SetValues(values)
        assert(type(values) == "table", "Dropdown Values must be a table")
        self.Values, self.Entries = table.clone(values), {}
        if #values > 0 then
            for _, value in ipairs(values) do table.insert(self.Entries, { Key = value, Label = tostring(value) }) end
        else
            for key, label in pairs(values) do table.insert(self.Entries, { Key = key, Label = tostring(label) }) end
            table.sort(self.Entries, function(a, b) return a.Label < b.Label end)
        end
        if settings.DisplayFormat then
            for _, entry in ipairs(self.Entries) do entry.Label = tostring(settings.DisplayFormat(entry.Key)) end
        end
        if self.Menu.Popup and self.Menu.Popup.Owner == self then self.Menu:ClosePopup() end
        self:SetValue(self.Value, self.Initializing)
        return self
    end
    function control:Open()
        if self:_isDisabled() then return end
        if self.Menu.Popup and self.Menu.Popup.Owner == self then self.Menu:ClosePopup() return end
        local count = math.min(#self.Entries, settings.MaxVisibleDropdownItems or 7)
        local searchHeight = self.Searchable and 38 or 0
        local frame = self.Menu:_openPopup(self, Vector2.new(math.max(180, math.min(320, self.Main.AbsoluteSize.X)),
            math.max(48, count * 34 + searchHeight + 16)), function() self.Items = nil end)
        local search
        if self.Searchable then search = inputBox(self.Menu, frame, { Name = "Search", PlaceholderText = "Search",
            Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 30), ZIndex = 101 }) end
        local list = create("ScrollingFrame", { Name = "Values", Position = UDim2.fromOffset(8, 8 + searchHeight),
            Size = UDim2.new(1, -16, 1, -16 - searchHeight), BackgroundTransparency = 1, BorderSizePixel = 0,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ZIndex = 101 }, frame)
        create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, list)
        self.Items = {}
        for index, entry in ipairs(self.Entries) do
            local disabled = settings.DisabledValues and (settings.DisabledValues[entry.Key] == true
                or table.find(settings.DisabledValues, entry.Key) ~= nil)
            local item = button(self.Menu, list, { Name = "Item_" .. index, Text = entry.Label,
                Size = UDim2.new(1, -4, 0, 30), LayoutOrder = index, ZIndex = 102,
                TextTransparency = disabled and 0.55 or 0, TextTruncate = Enum.TextTruncate.AtEnd })
            self.Items[entry.Key] = { Button = item, Label = entry.Label }
            self.Menu:_popupConnect(item.Activated, function()
                if disabled then return end
                if self.Multi then
                    local values = table.clone(self.Value or {})
                    values[entry.Key] = not values[entry.Key] or nil
                    self:SetValue(values)
                else self:SetValue(entry.Key) self.Menu:ClosePopup() end
            end)
        end
        if search then
            self.Menu:_popupConnect(search:GetPropertyChangedSignal("Text"), function()
                local query = string.lower(search.Text)
                for _, item in pairs(self.Items or {}) do
                    item.Button.Visible = string.find(string.lower(item.Label), query, 1, true) ~= nil
                end
                list.CanvasPosition = Vector2.zero
            end)
        end
        self:_render()
    end
    control.Initializing = true
    control:SetValues(settings.Values or {})
    control:SetValue(settings.Default, true)
    control.Initializing = false
    self.Menu:_connect(control.Button.Activated, function() control:Open() end)
    return control
end

local function keyEnum(value)
    if typeof(value) == "EnumItem" then return value end
    if value == nil or value == "None" or value == "NONE" then return nil end
    local mouse = { MB1 = Enum.UserInputType.MouseButton1, MB2 = Enum.UserInputType.MouseButton2, MB3 = Enum.UserInputType.MouseButton3 }
    return mouse[value] or Enum.KeyCode[tostring(value)]
end

local function keyName(value)
    if not value then return "None" end
    local mouse = { [Enum.UserInputType.MouseButton1] = "MB1", [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3" }
    return mouse[value] or value.Name
end

function Container:_addKeyPicker(id, settings, root)
    settings = settings or {}
    local control = self.Menu:_control(self, id, settings, "KeyPicker", 40, root, 90)
    control.Button = button(self.Menu, control.Main, { Name = "KeyPicker", Size = UDim2.fromScale(1, 1), Text = "None" })
    control.Mode, control.State, control.Modifiers = settings.Mode or "Toggle", false, settings.Modifiers or {}
    control.Pressed = self.Menu:_event()
    function control:_render()
        self.Button.Text = self.Menu.CapturingKey == self and "..." or self.Value or "None"
        self.Button.Active = not self:_isDisabled()
        self.Button.TextTransparency = self:_isDisabled() and 0.5 or 0
    end
    function control:SetValue(value, silent)
        local mode, modifiers = self.Mode, self.Modifiers
        if type(value) == "table" then
            mode = value.Mode or value[2] or mode
            modifiers = value.Modifiers or modifiers
            value = value.Key or value[1]
        end
        assert(mode == "Toggle" or mode == "Hold" or mode == "Press" or mode == "Always", "Invalid keybind mode")
        local key = keyEnum(value)
        assert(key or value == nil or value == "None" or value == "NONE", "Invalid keybind")
        local name = keyName(key)
        local changed = self.Value ~= name or self.Mode ~= mode or not same(self.Modifiers, modifiers)
        self.Value, self.Key, self.Mode, self.Modifiers = name, key, mode, table.clone(modifiers)
        self.State = mode == "Always" or (settings.SyncToggleState and self.Root ~= self and self.Root.Value == true)
        self:_render()
        if changed and not silent then self:_emit() end
        return self
    end
    function control:GetState() return self.State end
    function control:OnClick(callback)
        self.Menu:_connect(self.Pressed.Event, function(state) invoke(callback, state) end)
        return self
    end
    function control:_setState(value)
        if self.State == value then return end
        self.State = value
        if settings.SyncToggleState and (self.Root.Type == "Toggle" or self.Root.Type == "Checkbox") then self.Root:SetValue(value) end
        self.Pressed:Fire(value)
    end
    function control:_keyBegan(input, processed)
        if self:_isDisabled() or (processed and not settings.IgnoreProcessed) or not self.Key then return end
        if input.KeyCode ~= self.Key and input.UserInputType ~= self.Key then return end
        for _, modifier in ipairs(self.Modifiers) do
            local key = keyEnum(modifier)
            if not key or key.EnumType ~= Enum.KeyCode or not UserInputService:IsKeyDown(key) then return end
        end
        if self.Mode == "Toggle" then self:_setState(not self.State)
        elseif self.Mode == "Hold" then self:_setState(true)
        elseif self.Mode == "Press" then self.State = true self.Pressed:Fire(true) self.State = false end
    end
    function control:_keyEnded(input)
        if self.Mode == "Hold" and self.State and (input.KeyCode == self.Key or input.UserInputType == self.Key) then self:_setState(false) end
    end
    if settings.Callback then control:OnClick(settings.Callback) end
    if root then
        root.Host.Visible = true
        if root.Label then root.Label.Size = UDim2.new(0.48, -8, 1, 0) end
    end
    control:SetValue(settings.Default or "None", true)
    if settings.SyncToggleState and root and (root.Type == "Toggle" or root.Type == "Checkbox") then
        control.State = root.Value
        root:OnChanged(function(value) control.State = value end)
    end
    self.Menu:_connect(control.Button.Activated, function()
        if control:_isDisabled() then return end
        self.Menu:ClosePopup()
        self.Menu:_cancelCapture()
        self.Menu.CapturingKey = control
        control:_render()
    end)
    self.Menu:_connect(control.Button.MouseButton2Click, function()
        if control:_isDisabled() then return end
        self.Menu:_cancelCapture()
        local modes = settings.Modes or { "Toggle", "Hold", "Press", "Always" }
        local frame = self.Menu:_openPopup(control, Vector2.new(160, #modes * 34 + 16))
        for index, mode in ipairs(modes) do
            local item = button(self.Menu, frame, { Text = mode, Size = UDim2.new(1, -16, 0, 30),
                Position = UDim2.fromOffset(8, 8 + (index - 1) * 34), ZIndex = 101 })
            self.Menu:_popupConnect(item.Activated, function()
                control:SetValue({ control.Value, mode })
                self.Menu:ClosePopup()
            end)
        end
    end)
    table.insert(self.Menu.Keybinds, control)
    return control
end

function Container:AddKeyPicker(id, settings) return self:_addKeyPicker(id, settings) end
function Control:AddKeyPicker(id, settings) return self.Container:_addKeyPicker(id, settings, self.Root) end

function Container:_addColorPicker(id, settings, root)
    settings = settings or {}
    local control = self.Menu:_control(self, id, settings, "ColorPicker", 40, root, 36)
    control.Transparency = tonumber(settings.Transparency) or 0
    control.HasTransparency = settings.Transparency ~= nil
    control.HSV = { 0, 1, 1 }
    control.Button = button(self.Menu, control.Main, { Name = "ColorPicker", Text = "", AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(34, 28) })
    function control:_render()
        self.Button.BackgroundColor3 = self.Value or Color3.new(1, 1, 1)
        self.Button.BackgroundTransparency = self:_isDisabled() and 0.6 or self.Transparency
        self.Button.Active = not self:_isDisabled()
        if self.RefreshPopup then self.RefreshPopup() end
    end
    function control:SetValueRGB(value, transparency, silent)
        if type(value) == "string" then value = Color3.fromHex(value:gsub("#", "")) end
        assert(typeof(value) == "Color3", "Color must be a Color3")
        transparency = math.clamp(tonumber(transparency) or self.Transparency, 0, 1)
        local changed = self.Value ~= value or self.Transparency ~= transparency
        local h, s, v = value:ToHSV()
        if s == 0 then h = self.HSV[1] end
        self.HSV, self.Value, self.Transparency = { h, s, v }, value, transparency
        self:_render()
        if changed and not silent then self:_emit() end
        return self
    end
    function control:SetValue(value, silent) return self:SetValueRGB(value, nil, silent) end
    function control:SetValueHSV(value)
        local h, s, v = math.clamp(value[1], 0, 1), math.clamp(value[2], 0, 1), math.clamp(value[3], 0, 1)
        local color = Color3.fromHSV(h, s, v)
        local changed = color ~= self.Value
        self.HSV, self.Value = { h, s, v }, color
        self:_render()
        if changed then self:_emit() end
        return self
    end
    function control:Open()
        if self:_isDisabled() then return end
        if self.Menu.Popup and self.Menu.Popup.Owner == self then self.Menu:ClosePopup() return end
        local frame = self.Menu:_openPopup(self, Vector2.new(288, self.HasTransparency and 330 or 280),
            function() self.RefreshPopup = nil end)
        local sv = create("TextButton", { Name = "SV", Text = "", AutoButtonColor = false, Position = UDim2.fromOffset(12, 12),
            Size = UDim2.fromOffset(232, 156), BorderSizePixel = 0, ZIndex = 101 }, frame)
        local white = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0, ZIndex = 102 }, sv)
        create("UIGradient", { Transparency = NumberSequence.new(0, 1) }, white)
        local black = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0, ZIndex = 103 }, sv)
        create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }, black)
        local marker = create("Frame", { Size = UDim2.fromOffset(8, 8), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 104 }, sv)
        create("UICorner", { CornerRadius = UDim.new(1, 0) }, marker)
        create("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2 }, marker)
        local hue = create("TextButton", { Name = "Hue", Text = "", AutoButtonColor = false, Position = UDim2.fromOffset(254, 12),
            Size = UDim2.fromOffset(20, 156), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 101 }, frame)
        local colors = {}
        for index = 0, 6 do table.insert(colors, ColorSequenceKeypoint.new(index / 6, Color3.fromHSV(index / 6, 1, 1))) end
        create("UIGradient", { Rotation = 90, Color = ColorSequence.new(colors) }, hue)
        local hueMarker = create("Frame", { Size = UDim2.new(1, 4, 0, 3), Position = UDim2.fromOffset(-2, 0),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 102 }, hue)
        local hexBox = inputBox(self.Menu, frame, { Name = "Hex", Position = UDim2.fromOffset(12, 180),
            Size = UDim2.fromOffset(262, 32), PlaceholderText = "#FFFFFF", ZIndex = 101 })
        local boxes = {}
        for index, channel in ipairs({ "R", "G", "B" }) do
            text(self.Menu, frame, { Text = channel, Position = UDim2.fromOffset(12 + (index - 1) * 90, 220),
                Size = UDim2.fromOffset(20, 30), TextSize = 14, ZIndex = 101 })
            boxes[index] = inputBox(self.Menu, frame, { Name = channel, Position = UDim2.fromOffset(34 + (index - 1) * 90, 220),
                Size = UDim2.fromOffset(60, 30), TextSize = 14, ZIndex = 101 })
        end
        local alpha, alphaLabel, alphaFill
        if self.HasTransparency then
            alphaLabel = text(self.Menu, frame, { Position = UDim2.fromOffset(12, 264),
                Size = UDim2.fromOffset(262, 20), TextSize = 14, ZIndex = 101 })
            alpha = create("TextButton", { Name = "Transparency", Text = "", Position = UDim2.fromOffset(12, 294),
                Size = UDim2.fromOffset(262, 12), BackgroundColor3 = self.Menu.ButtonColor,
                BackgroundTransparency = self.Menu.ButtonTransparency,
                BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 101 }, frame)
            alphaFill = create("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = self.Menu.Accent,
                BorderSizePixel = 0, ZIndex = 102 }, alpha)
        end
        self.RefreshPopup = function()
            if not frame.Parent then return end
            local h, s, v = table.unpack(self.HSV)
            sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            marker.Position = UDim2.fromScale(s, 1 - v)
            hueMarker.Position = UDim2.new(0, -2, h, -1)
            if not hexBox:IsFocused() then hexBox.Text = "#" .. self.Value:ToHex():upper() end
            local values = { self.Value.R, self.Value.G, self.Value.B }
            for index, box in ipairs(boxes) do
                if not box:IsFocused() then box.Text = tostring(math.floor(values[index] * 255 + 0.5)) end
            end
            if alpha then
                alphaFill.Size = UDim2.fromScale(self.Transparency, 1)
                alphaLabel.Text = "Transparency " .. math.floor(self.Transparency * 100 + 0.5) .. "%"
            end
        end
        self.Menu:_popupConnect(sv.InputBegan, function(input)
            self.Menu:_beginDrag(self, input, function(position)
                local origin = screenPosition(sv)
                self:SetValueHSV({ self.HSV[1], math.clamp((position.X - origin.X) / sv.AbsoluteSize.X, 0, 1),
                    1 - math.clamp((position.Y - origin.Y) / sv.AbsoluteSize.Y, 0, 1) })
            end)
        end)
        self.Menu:_popupConnect(hue.InputBegan, function(input)
            self.Menu:_beginDrag(self, input, function(position)
                self:SetValueHSV({ math.clamp((position.Y - screenPosition(hue).Y) / hue.AbsoluteSize.Y, 0, 1), self.HSV[2], self.HSV[3] })
            end)
        end)
        if alpha then self.Menu:_popupConnect(alpha.InputBegan, function(input)
            self.Menu:_beginDrag(self, input, function(position)
                self:SetValueRGB(self.Value, math.clamp((position.X - screenPosition(alpha).X) / alpha.AbsoluteSize.X, 0, 1))
            end)
        end) end
        self.Menu:_popupConnect(hexBox.FocusLost, function()
            local value = hexBox.Text:gsub("#", "")
            if #value == 6 and value:match("^%x+$") then self:SetValueRGB(Color3.fromHex(value)) end
            self.RefreshPopup()
        end)
        for _, box in ipairs(boxes) do self.Menu:_popupConnect(box.FocusLost, function()
            local values = {}
            for index, item in ipairs(boxes) do values[index] = tonumber(item.Text) end
            if values[1] and values[2] and values[3] then
                self:SetValueRGB(Color3.fromRGB(math.clamp(values[1], 0, 255), math.clamp(values[2], 0, 255), math.clamp(values[3], 0, 255)))
            end
            self.RefreshPopup()
        end) end
        self.RefreshPopup()
    end
    if root then
        root.Host.Visible = true
        if root.Label then root.Label.Size = UDim2.new(0.48, -8, 1, 0) end
    end
    control:SetValueRGB(settings.Default or Color3.new(1, 1, 1), settings.Transparency, true)
    self.Menu:_connect(control.Button.Activated, function() control:Open() end)
    return control
end

function Container:AddColorPicker(id, settings) return self:_addColorPicker(id, settings) end
function Control:AddColorPicker(id, settings) return self.Container:_addColorPicker(id, settings, self.Root) end

local function flow(parent, name, padding)
    local frame = create("Frame", { Name = name, Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 11 }, parent)
    local layout = create("UIListLayout", { Padding = UDim.new(0, padding or 8),
        SortOrder = Enum.SortOrder.LayoutOrder }, frame)
    return frame, layout
end

function Tab:_column(side)
    if not self.Columns then
        local frame = create("Frame", { Name = "Columns", Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1, LayoutOrder = #self.Controls + 1, ZIndex = 11 }, self.Content)
        table.insert(self.Controls, frame)
        local left, leftLayout = flow(frame, "Left", 12)
        local right, rightLayout = flow(frame, "Right", 12)
        self.Columns = { Frame = frame, Left = left, Right = right }
        local function resize()
            local stacked = frame.AbsoluteSize.X < 540
            left.Size, right.Size = UDim2.new(stacked and 1 or 0.5, stacked and 0 or -6, 0, 0),
                UDim2.new(stacked and 1 or 0.5, stacked and 0 or -6, 0, 0)
            left.Position = UDim2.new()
            right.Position = stacked and UDim2.fromOffset(0, leftLayout.AbsoluteContentSize.Y + 12) or UDim2.new(0.5, 6, 0, 0)
            frame.Size = UDim2.new(1, 0, 0, stacked and leftLayout.AbsoluteContentSize.Y + rightLayout.AbsoluteContentSize.Y + 12
                or math.max(leftLayout.AbsoluteContentSize.Y, rightLayout.AbsoluteContentSize.Y))
        end
        self.Menu:_connect(leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"), resize)
        self.Menu:_connect(rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"), resize)
        self.Menu:_connect(frame:GetPropertyChangedSignal("AbsoluteSize"), resize)
        task.defer(resize)
    end
    return self.Columns[side]
end

local function group(tab, parent, title, description)
    local frame = create("Frame", { Name = "Group", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = tab.Menu.SurfaceColor, BackgroundTransparency = tab.Menu.SurfaceTransparency, BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(), ZIndex = 11 }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 8) }, frame)
    create("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10) }, frame)
    create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
    if title and title ~= "" then text(tab.Menu, frame, { Text = title, Size = UDim2.new(1, 0, 0, 28), LayoutOrder = 0, TextSize = 18 }) end
    if description and description ~= "" then text(tab.Menu, frame, { Text = description, Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, TextSize = 14, TextTransparency = 0.3, LayoutOrder = 1 }) end
    local content = flow(frame, "Content", 4)
    content.LayoutOrder = 2
    return setmetatable({ Menu = tab.Menu, RootTab = tab, Content = content, Frame = frame, Controls = {} }, Container)
end

function Tab:AddGroupbox(settings)
    if type(settings) == "string" then settings = { Name = settings } end
    settings = settings or {}
    local side = string.lower(settings.Side or "Left") == "right" and "Right" or "Left"
    return group(self, self:_column(side), settings.Name, settings.Description)
end

function Tab:AddLeftGroupbox(title) return self:AddGroupbox({ Side = "Left", Name = title }) end
function Tab:AddRightGroupbox(title) return self:AddGroupbox({ Side = "Right", Name = title }) end

function Container:SetVisible(value)
    self.Frame.Visible = value == true
    if not value and self.Menu.Popup and self.Menu.Popup.Owner.Row:IsDescendantOf(self.Frame) then self.Menu:ClosePopup() end
    return self
end

function Container:AddDependencyBox()
    local content = flow(self.Content, "Dependency", 4)
    content.LayoutOrder = #self.Controls + 1
    table.insert(self.Controls, content)
    local box = setmetatable({ Menu = self.Menu, RootTab = self.RootTab, Content = content, Frame = content, Controls = {} }, Container)
    function box:SetupDependencies(dependencies)
        local function update()
            local visible = true
            for _, item in ipairs(dependencies) do
                if item[1].Value ~= item[2] then visible = false break end
            end
            self.Frame.Visible = visible
            if not visible and self.Menu.Popup and self.Menu.Popup.Owner.Row:IsDescendantOf(self.Frame) then self.Menu:ClosePopup() end
        end
        for _, item in ipairs(dependencies) do item[1]:OnChanged(update) end
        update()
        return self
    end
    return box
end

function Tab:_addTabbox(side)
    local parent = self:_column(side)
    local frame = create("Frame", { Name = "Tabbox", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = self.Menu.SurfaceColor, BackgroundTransparency = self.Menu.SurfaceTransparency, BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(), ZIndex = 11 }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 8) }, frame)
    create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10) }, frame)
    create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
    local headers = create("Frame", { Name = "Tabs", Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1, LayoutOrder = 0, ZIndex = 12 }, frame)
    local body = flow(frame, "Body", 0)
    body.LayoutOrder = 1
    local box = { Menu = self.Menu, RootTab = self, Frame = frame, Tabs = {}, TabList = {} }
    function box:AddTab(title)
        assert(not self.Tabs[title], "Duplicate subtab title")
        local index = #self.TabList + 1
        local header = button(self.Menu, headers, { Name = "Subtab_" .. index, Text = title, TextSize = 15 })
        local content = flow(body, "Subtab_" .. index, 4)
        content.Visible = index == 1
        local subtab = setmetatable({ Menu = self.Menu, RootTab = self.RootTab, Frame = content,
            Content = content, Header = header, Controls = {} }, Container)
        function subtab:Select()
            self.Menu:ClosePopup()
            for _, item in ipairs(box.TabList) do
                item.Frame.Visible = item == self
                item.Header.BackgroundColor3 = item == self and self.Menu.Accent or self.Menu.SurfaceColor
                item.Header.BackgroundTransparency = item == self and 0 or self.Menu.SurfaceTransparency
            end
            box.ActiveTab = self
        end
        self.Menu:_connect(header.Activated, function() subtab:Select() end)
        self.Tabs[title] = subtab
        table.insert(self.TabList, subtab)
        for position, item in ipairs(self.TabList) do
            item.Header.Position = UDim2.new((position - 1) / #self.TabList, 0, 0, 0)
            item.Header.Size = UDim2.new(1 / #self.TabList, -4, 1, 0)
        end
        if index == 1 then subtab:Select() end
        return subtab
    end
    return box
end

function Tab:AddLeftTabbox() return self:_addTabbox("Left") end
function Tab:AddRightTabbox() return self:_addTabbox("Right") end

function Menu:GetConfig()
    local values = {}
    local function add(registry)
        for id, control in pairs(registry) do
            if not control.Settings.IgnoreConfig and control.Type ~= "Label" then
                local item = { Type = control.Type, Value = copy(control.Value) }
                if control.Type == "ColorPicker" then
                    item.Value, item.Transparency = control.Value:ToHex(), control.Transparency
                elseif control.Type == "KeyPicker" then
                    item.Mode, item.Modifiers = control.Mode, {}
                    for _, modifier in ipairs(control.Modifiers) do table.insert(item.Modifiers, keyName(keyEnum(modifier))) end
                end
                values[id] = item
            end
        end
    end
    add(self.Options) add(self.Toggles)
    return HttpService:JSONEncode({ Values = values })
end

function Menu:LoadConfig(source)
    local ok, config = pcall(HttpService.JSONDecode, HttpService, source)
    if not ok or type(config) ~= "table" or type(config.Values) ~= "table" then return false, "Invalid configuration file" end
    for id, item in pairs(config.Values) do
        local control = self.Options[id] or self.Toggles[id]
        if control and type(item) == "table" and item.Type == control.Type and not control.Settings.IgnoreConfig then
            local success, message = pcall(function()
                if control.Type == "ColorPicker" then control:SetValueRGB(item.Value, item.Transparency)
                elseif control.Type == "KeyPicker" then control:SetValue({ item.Value, item.Mode, Modifiers = item.Modifiers })
                else control:SetValue(item.Value) end
            end)
            if not success then return false, id .. ": " .. tostring(message) end
        end
    end
    return true
end

function Menu:_configPath(name)
    assert(type(name) == "string" and #name > 0 and #name <= 128 and name ~= "." and name ~= ".."
        and not name:find('[\\/:*?"<>|%c]') and not name:match("[%. ]$"), "Invalid config name")
    assert(type(self.ConfigFolder) == "string" and self.ConfigFolder:match("^[%w_%-]+$"), "Invalid config folder")
    return self.ConfigFolder .. "/" .. name .. ".json"
end

function Menu:SaveConfig(name)
    local path = self:_configPath(name)
    assert(writefile and isfolder and makefolder, "File functions are unavailable")
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
    writefile(path, self:GetConfig())
    return true
end

function Menu:LoadConfigFile(name)
    local path = self:_configPath(name)
    assert(readfile and isfile, "File functions are unavailable")
    if not isfile(path) then return false, "Configuration file not found" end
    return self:LoadConfig(readfile(path))
end

function Menu:SetAccent(color)
    assert(typeof(color) == "Color3", "Accent must be a Color3")
    self.Accent = color
    for _, registry in ipairs({ self.Options, self.Toggles }) do
        for _, control in pairs(registry) do if control._render then control:_render() end end
    end
end

function Library:Notify(value, duration) if self.Menu then return self.Menu:Notify(value, duration) end end
function Library:OnUnload(callback) if self.Menu then self.Menu:OnUnload(callback) end end
Library.CreateWindow = Library.CreateMenu
function Library:Unload()
    if env.NativeMenuInstance then env.NativeMenuInstance:Unload() end
end
return Library
