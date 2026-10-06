    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat

    getgenv().library = {
        directory = "ui",
        folders = {
            "/fonts",
            "/configs",
            "/themes",
        },
        flags = {},
        config_flags = {},
        connections = {},   
        notifications = {notifs = {}},
        keybinds = {},
        sections = {},
        searchables = {},
        search_text = "",
        current_open; 
    }

    local themes = {
        names = {"Red", "Graphite", "Arctic", "Ember", "Mint", "Rose"},

        preset = {
            accent = rgb(255, 70, 70),
            background = rgb(12, 10, 10),
            surface = rgb(20, 17, 17),
            card = rgb(24, 19, 19),
            card_inner = rgb(17, 14, 14),
            border = rgb(72, 48, 48),
            window_transparency = 0.1,
            panel_transparency = 0.12,
            card_transparency = 0.1,
        }, 

        presets = {
            Red = {accent = rgb(255, 70, 70), background = rgb(12, 10, 10), surface = rgb(20, 17, 17), card = rgb(24, 19, 19), card_inner = rgb(17, 14, 14), border = rgb(72, 48, 48), window_transparency = 0.1, panel_transparency = 0.12, card_transparency = 0.1},
            Graphite = {accent = rgb(125, 146, 255), background = rgb(10, 11, 14), surface = rgb(17, 18, 23), card = rgb(21, 22, 29), card_inner = rgb(16, 17, 22), border = rgb(52, 55, 70), window_transparency = 0.24, panel_transparency = 0.28, card_transparency = 0.24},
            Arctic = {accent = rgb(105, 205, 255), background = rgb(8, 12, 15), surface = rgb(14, 21, 26), card = rgb(18, 27, 33), card_inner = rgb(13, 19, 24), border = rgb(46, 69, 80), window_transparency = 0.25, panel_transparency = 0.3, card_transparency = 0.25},
            Ember = {accent = rgb(255, 150, 85), background = rgb(15, 10, 8), surface = rgb(24, 17, 14), card = rgb(30, 20, 16), card_inner = rgb(21, 15, 13), border = rgb(78, 52, 41), window_transparency = 0.23, panel_transparency = 0.28, card_transparency = 0.23},
            Mint = {accent = rgb(80, 220, 165), background = rgb(8, 13, 11), surface = rgb(14, 23, 20), card = rgb(17, 28, 24), card_inner = rgb(12, 20, 17), border = rgb(43, 72, 62), window_transparency = 0.25, panel_transparency = 0.3, card_transparency = 0.24},
            Rose = {accent = rgb(255, 110, 155), background = rgb(15, 9, 12), surface = rgb(24, 15, 19), card = rgb(30, 18, 24), card_inner = rgb(21, 13, 17), border = rgb(78, 48, 60), window_transparency = 0.24, panel_transparency = 0.29, card_transparency = 0.24},
        },

        utility = {
            accent = {
                BackgroundColor3 = {}, 	
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {},
                Color = {},
            },
            background = {
                BackgroundColor3 = {},
            },
            surface = {
                BackgroundColor3 = {},
            },
            card = {
                BackgroundColor3 = {},
            },
            card_inner = {
                BackgroundColor3 = {},
            },
            border = {
                BackgroundColor3 = {},
                Color = {},
            },
            window_transparency = {},
            panel_transparency = {},
            card_transparency = {},
        }
    }

    library.current_theme = "Red"

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }
        
    library.__index = library

    for _, path in next, library.folders do 
        makefolder(library.directory .. path)
    end

    local flags = library.flags 
    local config_flags = library.config_flags
    local notifications = library.notifications 
    library.Flags = flags
    library.ConfigFlags = config_flags

    local fonts = {}; do
        function Register_Font(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }

            writefile(Name .. ".font", http_service:JSONEncode(Data))

            return getcustomasset(Name .. ".font");
        end
        
        local Medium = Register_Font("Medium", 200, "Normal", {
            Id = "Medium.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
        })

        local SemiBold = Register_Font("SemiBold", 200, "Normal", {
            Id = "SemiBold.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
        })

        fonts = {
            small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end

        function library:tween(obj, properties, easing_style, time)
            library.active_tweens = library.active_tweens or setmetatable({}, {__mode = "k"})

            local object_tweens = library.active_tweens[obj]
            if not object_tweens then
                object_tweens = {}
                library.active_tweens[obj] = object_tweens
            end

            local tweened_properties = {}

            for property in properties do
                tweened_properties[#tweened_properties + 1] = property

                local active_tween = object_tweens[property]
                if active_tween then
                    pcall(function()
                        active_tween:Cancel()
                    end)
                end
            end

            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties)

            for _, property in tweened_properties do
                object_tweens[property] = tween
            end

            local connection
            connection = tween.Completed:Connect(function()
                for _, property in tweened_properties do
                    if object_tweens[property] == tween then
                        object_tweens[property] = nil
                    end
                end

                if connection then
                    connection:Disconnect()
                end
            end)

            tween:Play()

            return tween
        end

        function library:resizify(frame) 
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1 
            Frame.Text = ""

            local resizing = false 
            local start_size 
            local start 
            local og_size = frame.Size  

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            Frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            og_size.X.Offset,
                            viewport_x
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            og_size.Y.Offset,
                            viewport_y
                        )
                    )

                    library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
                end
            end)
        end 

        function fag(tbl)
            local Size = 0
            
            for _ in tbl do
                Size = Size + 1
            end
        
            return Size
        end
        
        function library:next_flag()
            local index = fag(library.flags) + 1;
            local str = string.format("flagnumber%s", index)
            
            return str;
        end 

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame)
            local dragging = false 
            local start_size = frame.Position
            local start 

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if frame.Position.X.Scale ~= 0 or frame.Position.Y.Scale ~= 0 then
                        frame.Position = dim2(0, frame.AbsolutePosition.X, 0, frame.AbsolutePosition.Y)
                    end

                    dragging = true
                    start = input.Position
                    start_size = frame.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_position = dim2(
                        0,
                        clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            0,
                            viewport_x - frame.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            0,
                            viewport_y - frame.Size.Y.Offset
                        )
                    )

                    library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
                    library:close_element()
                end
            end)
        end 

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end
            
            if #values == 4 then              
                return table.unpack(values)
            else 
                return
            end
        end
        
        function library:convert_enum(enum)
            local enum_parts = {}
        
            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end

            if #enum_parts == 1 then
                return Enum.KeyCode[enum_parts[1]] or Enum.UserInputType[enum_parts[1]]
            end
        
            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]
                if enum_item == nil then
                    return
                end
        
                enum_table = enum_item
            end
        
            return enum_table
        end

        local config_holder;
        function library:update_config_list() 
            if not config_holder then 
                return 
            end
            
            local list = {}
            
            for idx, file in listfiles(library.directory .. "/configs") do
                local name = file:match("[^/\\]+$") or file
                if name:sub(-4) == ".cfg" then
                    list[#list + 1] = name:gsub("%.cfg$", "")
                end
            end

            config_holder.refresh_options(list)
        end 

        function library:get_config()
            local Config = {}
            
            for _, v in next, flags do
                if type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end 
            
            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json) 
            local decoded, config = pcall(function()
                return http_service:JSONDecode(config_json)
            end)

            if not decoded or type(config) ~= "table" then
                notifications:create_notification({name = "Configs", info = "Failed to parse config."})
                return
            end
            
            for _, v in config do 
                local function_set = library.config_flags[_]
                
                if _ == "config_name_list" then 
                    continue 
                end

                if function_set then 
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                    elseif type(v) == "table" and v["active"] then 
                        function_set(v)
                    else
                        function_set(v)
                    end
                end 
            end 
        end 
        
        function library:round(number, float) 
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end 

        function library:apply_theme(instance, theme, property) 
            if not themes.utility[theme] or not themes.utility[theme][property] then
                return
            end

            insert(themes.utility[theme][property], instance)
        end

        function library:update_theme(theme, color)
            if not themes.utility[theme] or typeof(color) ~= "Color3" then
                return
            end

            local old_color = themes.preset[theme]
            themes.preset[theme] = color

            local function is_theme_color(value)
                if typeof(value) ~= "Color3" or typeof(old_color) ~= "Color3" then
                    return true
                end

                return abs(value.R - old_color.R) < 0.01 and abs(value.G - old_color.G) < 0.01 and abs(value.B - old_color.B) < 0.01
            end

            for property, objects in themes.utility[theme] do 
                for _, object in objects do 
                    if object and object.Parent and is_theme_color(object[property]) then
                        object[property] = color
                    end
                end 
            end 
        end 

        function library:apply_transparency(instance, theme, property, offset)
            property = property or "BackgroundTransparency"
            offset = offset or 0

            if not themes.utility[theme] then
                return
            end

            insert(themes.utility[theme], {
                instance = instance,
                property = property,
                offset = offset,
            })

            instance[property] = clamp((themes.preset[theme] or 0) + offset, 0, 1)
        end

        function library:update_transparency(theme, value)
            if not themes.utility[theme] then
                return
            end

            local transparency = clamp(tonumber(value) or themes.preset[theme] or 0, 0, 0.65)
            themes.preset[theme] = transparency

            for _, data in themes.utility[theme] do
                local object = data.instance
                local property = data.property or "BackgroundTransparency"

                if object and object.Parent then
                    library:tween(object, {[property] = clamp(transparency + (data.offset or 0), 0, 1)}, Enum.EasingStyle.Quad, 0.18)
                end
            end
        end

        function library:fade_attribute_name(property)
            return "NukeFade_" .. property
        end

        function library:remember_fade_properties(object)
            local properties = {}

            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                properties[#properties + 1] = "TextTransparency"
                properties[#properties + 1] = "TextStrokeTransparency"
            end

            if object:IsA("ImageLabel") or object:IsA("ImageButton") then
                properties[#properties + 1] = "ImageTransparency"
            end

            if object:IsA("ScrollingFrame") then
                properties[#properties + 1] = "ScrollBarImageTransparency"
            end

            if object:IsA("UIStroke") then
                properties[#properties + 1] = "Transparency"
            end

            for _, property in properties do
                local ok, value = pcall(function()
                    return object[property]
                end)

                if ok and type(value) == "number" then
                    pcall(function()
                        object:SetAttribute(library:fade_attribute_name(property), value)
                    end)
                end
            end
        end

        function library:get_fade_targets(root)
            local targets = {}

            local function add_target(object, property)
                local ok, value = pcall(function()
                    return object[property]
                end)

                if ok and type(value) == "number" then
                    local saved = nil
                    pcall(function()
                        saved = object:GetAttribute(library:fade_attribute_name(property))
                    end)

                    if type(saved) ~= "number" then
                        saved = value
                    end

                    insert(targets, {
                        object = object,
                        property = property,
                        value = saved,
                    })
                end
            end

            for _, object in root:GetDescendants() do
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    add_target(object, "TextTransparency")
                    add_target(object, "TextStrokeTransparency")
                end

                if object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    add_target(object, "ImageTransparency")
                end

                if object:IsA("ScrollingFrame") then
                    add_target(object, "ScrollBarImageTransparency")
                end

                if object:IsA("UIStroke") then
                    add_target(object, "Transparency")
                end
            end

            return targets
        end

        function library:fade_tree(root, visible, duration)
            if not root then
                return
            end

            local targets = library:get_fade_targets(root)

            for _, target in targets do
                local object = target.object
                local property = target.property

                if object and object.Parent then
                    if visible then
                        object[property] = 1
                    end

                    library:tween(object, {[property] = visible and target.value or 1}, Enum.EasingStyle.Quart, duration or 0.28)
                end
            end
        end

        function library:set_fade_tree(root, value)
            if not root then
                return
            end

            local targets = library:get_fade_targets(root)

            for _, target in targets do
                local object = target.object
                local property = target.property

                if object and object.Parent then
                    local object_tweens = library.active_tweens and library.active_tweens[object]
                    local active_tween = object_tweens and object_tweens[property]
                    if active_tween then
                        pcall(function()
                            active_tween:Cancel()
                        end)
                        object_tweens[property] = nil
                    end

                    object[property] = value
                end
            end
        end

        function library:apply_card_transparency(instance, property, offset)
            library:apply_transparency(instance, "card_transparency", property, offset)
        end

        function library:update_card_transparency(value)
            library:update_transparency("card_transparency", value)
        end

        function library:get_theme_preset(name)
            if name == "Nuke" then
                name = "Red"
            end

            return themes.presets[name]
        end

        function library:apply_theme_preset(name)
            if name == "Nuke" then
                name = "Red"
            end

            local preset = library:get_theme_preset(name)

            if not preset then
                return
            end

            library.current_theme = name

            local color_flags = {
                accent = "theme_accent_color",
                background = "theme_background_color",
                surface = "theme_surface_color",
                card = "theme_card_color",
                card_inner = "theme_card_inner_color",
                border = "theme_border_color",
            }

            for _, theme in {"accent", "background", "surface", "card", "card_inner", "border"} do
                if preset[theme] then
                    local setter = config_flags[color_flags[theme]]
                    if setter then
                        setter(preset[theme])
                    else
                        library:update_theme(theme, preset[theme])
                    end
                end
            end

            local transparency_flags = {
                window_transparency = "window_transparency",
                panel_transparency = "panel_transparency",
                card_transparency = "card_transparency",
            }

            for _, theme in {"window_transparency", "panel_transparency", "card_transparency"} do
                if preset[theme] then
                    local setter = config_flags[transparency_flags[theme]]
                    if setter then
                        setter(preset[theme])
                    else
                        library:update_transparency(theme, preset[theme])
                    end
                end
            end
        end

        function library:get_theme_config()
            local config = {}

            for _, theme in {"accent", "background", "surface", "card", "card_inner", "border"} do
                local color = themes.preset[theme]
                if typeof(color) == "Color3" then
                    config[theme] = color:ToHex()
                end
            end

            for _, theme in {"window_transparency", "panel_transparency", "card_transparency"} do
                config[theme] = themes.preset[theme]
            end

            return http_service:JSONEncode(config)
        end

        function library:load_theme_config(theme_json)
            local decoded, config = pcall(function()
                return http_service:JSONDecode(theme_json)
            end)

            if not decoded or type(config) ~= "table" then
                notifications:create_notification({name = "Themes", info = "Failed to parse theme."})
                return
            end

            for _, theme in {"accent", "background", "surface", "card", "card_inner", "border"} do
                if type(config[theme]) == "string" then
                    local color = hex(config[theme]:gsub("#", ""))
                    local setter = config_flags[({
                        accent = "theme_accent_color",
                        background = "theme_background_color",
                        surface = "theme_surface_color",
                        card = "theme_card_color",
                        card_inner = "theme_card_inner_color",
                        border = "theme_border_color",
                    })[theme]]

                    if setter then
                        setter(color)
                    else
                        library:update_theme(theme, color)
                    end
                end
            end

            for _, theme in {"window_transparency", "panel_transparency", "card_transparency"} do
                if config[theme] ~= nil then
                    local setter = config_flags[theme]
                    if setter then
                        setter(config[theme])
                    else
                        library:update_transparency(theme, config[theme])
                    end
                end
            end
        end

        function library:normalize_search_text(text)
            return string.lower(tostring(text or ""))
        end

        function library:register_searchable(path, text)
            if type(path) ~= "table" then
                return
            end

            library.searchables = library.searchables or {}
            path.search_text = library:normalize_search_text(text)

            local target = path.items and (path.items[ "motion_holder" ] or path.items[ "outline" ])
            if typeof(target) == "Instance" and target:IsA("GuiObject") then
                path.search_size = target.Size
            end

            insert(library.searchables, path)
        end

        function library:append_search_text(path, text)
            if type(path) ~= "table" or text == nil then
                return
            end

            local normalized = library:normalize_search_text(text)

            if normalized ~= "" then
                path.search_text = tostring(path.search_text or "") .. " " .. normalized

                if library.search_text and library.search_text ~= "" then
                    library:refresh_search()
                end
            end
        end

        function library:refresh_search()
            local query = library:normalize_search_text(library.search_text)
            local terms = {}

            for term in string.gmatch(query, "%S+") do
                insert(terms, term)
            end

            for _, path in library.searchables or {} do
                local target = path.items and (path.items[ "motion_holder" ] or path.items[ "outline" ])
                local outline = path.items and path.items[ "outline" ]

                if typeof(target) == "Instance" and target:IsA("GuiObject") then
                    path.search_size = path.search_size or target.Size

                    local text = path.search_text or ""
                    local visible = true

                    for _, term in terms do
                        if not string.find(text, term, 1, true) then
                            visible = false
                            break
                        end
                    end

                    target.Visible = visible
                    target.Size = visible and path.search_size or dim2(1, 0, 0, 0)

                    if typeof(outline) == "Instance" and outline:IsA("GuiObject") then
                        outline.Visible = visible
                    end
                end
            end
        end

        function library:set_search(text)
            library.search_text = tostring(text or "")
            library:refresh_search()
        end

        function library:tooltip(target, text)
            if not target or not text or text == "" then
                return
            end

            local function ensure()
                if library.tooltip_items then
                    return library.tooltip_items
                end

                local holder = library:create("Frame", {
                    Parent = library.items;
                    Name = "\0";
                    Visible = false;
                    BackgroundColor3 = rgb(18, 18, 18);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    ZIndex = 200;
                })

                library:create("UICorner", {
                    Parent = holder;
                    CornerRadius = dim(0, 6);
                })

                library:create("UIStroke", {
                    Parent = holder;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = rgb(55, 55, 55);
                })

                library:create("UIPadding", {
                    Parent = holder;
                    PaddingTop = dim(0, 7);
                    PaddingBottom = dim(0, 7);
                    PaddingLeft = dim(0, 9);
                    PaddingRight = dim(0, 9);
                })

                local label = library:create("TextLabel", {
                    Parent = holder;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    FontFace = fonts.small;
                    TextSize = 14;
                    TextWrapped = true;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextColor3 = rgb(220, 220, 220);
                    Size = dim2(0, 220, 0, 0);
                    Text = "";
                    ZIndex = 201;
                })

                library.tooltip_items = {
                    holder = holder,
                    label = label,
                }

                return library.tooltip_items
            end

            local function move(x, y)
                local tip = ensure()
                tip.holder.Position = dim_offset(x + 14, y + 12)
            end

            target.MouseEnter:Connect(function()
                local tip = ensure()
                tip.label.Text = text
                tip.holder.Visible = true
            end)

            target.MouseMoved:Connect(move)

            target.MouseLeave:Connect(function()
                local tip = ensure()
                tip.holder.Visible = false
            end)
        end 

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)
            
            insert(library.connections, connection)

            return connection 
        end

        function library:close_element(new_path) 
            local open_element = library.current_open

            if open_element and new_path ~= open_element then
                open_element.set_visible(false)
                open_element.open = false;
            end 

            if new_path ~= open_element then 
                library.current_open = new_path or nil;
            end
        end 

        function library:create(instance, options)
            local ins = Instance.new(instance) 

            for prop, value in options do 
                ins[prop] = value
            end

            library:remember_fade_properties(ins)
            
            return ins 
        end

        function library:format_key(key)
            if type(key) == "table" then
                key = key.Key or key.key or key.Value or key.value or key[1]
            end

            if type(key) == "string" and key:upper() == "NONE" then
                return "None"
            end

            if not key or key == "NONE" then
                return "None"
            end

            return keys[key] or tostring(key):gsub("^Enum%.KeyCode%.", ""):gsub("^Enum%.UserInputType%.", "")
        end

        function library:create_keybind_frame()
            if library.keybind_frame and library.keybind_frame.Parent then
                return library.keybind_frame
            end

            if not library.items then
                return
            end

            local frame = library:create("Frame", {
                Parent = library.items;
                Name = "\0";
                Visible = false;
                AnchorPoint = vec2(0, 0.5);
                Position = dim2(0, 10, 0.5, 0);
                Size = dim2(0, 248, 0, 48);
                AutomaticSize = Enum.AutomaticSize.Y;
                BorderSizePixel = 0;
                BackgroundColor3 = themes.preset.surface;
                BackgroundTransparency = 0.12;
                ZIndex = 180;
            })
            library:apply_theme(frame, "surface", "BackgroundColor3")
            library:apply_transparency(frame, "panel_transparency", "BackgroundTransparency", -0.04)

            library:create("UICorner", {
                Parent = frame;
                CornerRadius = dim(0, 4);
            })

            local stroke = library:create("UIStroke", {
                Parent = frame;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = themes.preset.border;
                Transparency = 0.16;
            })
            library:apply_theme(stroke, "border", "Color")

            library:create("UIListLayout", {
                Parent = frame;
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = dim(0, 1);
            })

            library:create("UIPadding", {
                Parent = frame;
                PaddingTop = dim(0, 5);
                PaddingBottom = dim(0, 6);
                PaddingLeft = dim(0, 7);
                PaddingRight = dim(0, 7);
            })

            local title = library:create("TextLabel", {
                Parent = frame;
                Name = "\0";
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = dim2(1, 0, 0, 17);
                FontFace = fonts.font;
                Text = "Keybinds";
                TextSize = 14;
                TextColor3 = rgb(245, 245, 245);
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 181;
            })

            local holder = library:create("Frame", {
                Parent = frame;
                Name = "\0";
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = dim2(1, 0, 0, 18);
                AutomaticSize = Enum.AutomaticSize.Y;
                ZIndex = 181;
            })

            library:create("UIListLayout", {
                Parent = holder;
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = dim(0, 1);
            })

            library.keybind_frame = frame
            library.KeybindFrame = frame
            library.keybind_holder = holder
            library.KeybindContainer = holder
            library:draggify(frame)
            library:refresh_keybind_list()

            return frame
        end

        function library:set_keybind_frame_visible(visible)
            local frame = library:create_keybind_frame()
            visible = visible == true
            library.keybind_frame_visible = visible
            flags["keybind_list_visible"] = visible
            flags["ShowKeybindList"] = visible

            if frame then
                frame.Visible = visible
            end
        end

        function library:refresh_keybind_list()
            local holder = library.keybind_holder
            if not holder then
                return
            end

            for _, child in holder:GetChildren() do
                if child:IsA("GuiObject") then
                    child:Destroy()
                end
            end

            local count = 0
            local width = 210

            for _, bind in library.keybinds do
                local key_text = bind and library:format_key(bind.key)
                if bind and bind.show_in_list ~= false and key_text and key_text ~= "None" then
                    count += 1

                    local active = bind.mode == "Always" or bind.active == true
                    local text = string.format("[%s] %s (%s)", key_text, bind.name or bind.flag or "Keybind", bind.mode or "Toggle")
                    width = max(width, min(320, 24 + (#text * 7)))

                    local label = library:create("TextLabel", {
                        Parent = holder;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        Size = dim2(1, 0, 0, 17);
                        FontFace = fonts.small;
                        Text = text;
                        TextSize = 13;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        TextColor3 = active and themes.preset.accent or rgb(225, 225, 225);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        ZIndex = 181;
                    })
                    if active then
                        library:apply_theme(label, "accent", "TextColor3")
                    end
                end
            end

            if count == 0 then
                library:create("TextLabel", {
                    Parent = holder;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Size = dim2(1, 0, 0, 17);
                    FontFace = fonts.small;
                    Text = "No keybinds";
                    TextSize = 13;
                    TextColor3 = rgb(145, 145, 145);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 181;
                })
                count = 1
            end

            holder.Size = dim2(1, 0, 0, count * 18)
            if library.keybind_frame then
                library:tween(library.keybind_frame, {Size = dim2(0, width, 0, 28 + count * 18)}, Enum.EasingStyle.Quart, 0.18)
            end
        end

        function library:create_watermark()
            if library.watermark_frame and library.watermark_frame.Parent then
                return library.watermark_frame
            end

            if not library.items then
                return
            end

            local frame = library:create("Frame", {
                Parent = library.items;
                Name = "\0";
                Visible = false;
                Position = dim2(0, 10, 0, 58);
                Size = dim2(0, 0, 0, 0);
                AutomaticSize = Enum.AutomaticSize.XY;
                BorderSizePixel = 0;
                BackgroundColor3 = themes.preset.surface;
                BackgroundTransparency = clamp(themes.preset.panel_transparency - 0.04, 0, 1);
                ZIndex = 175;
            })
            library:apply_theme(frame, "surface", "BackgroundColor3")
            library:apply_transparency(frame, "panel_transparency", "BackgroundTransparency", -0.04)

            library:create("UICorner", {
                Parent = frame;
                CornerRadius = dim(0, 4);
            })

            local stroke = library:create("UIStroke", {
                Parent = frame;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = themes.preset.border;
                Transparency = 0.18;
            })
            library:apply_theme(stroke, "border", "Color")

            library:create("UIPadding", {
                Parent = frame;
                PaddingTop = dim(0, 5);
                PaddingBottom = dim(0, 5);
                PaddingLeft = dim(0, 8);
                PaddingRight = dim(0, 8);
            })

            library:create("UIListLayout", {
                Parent = frame;
                FillDirection = Enum.FillDirection.Horizontal;
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                Padding = dim(0, 7);
            })

            local function create_segment(text, color)
                return library:create("TextLabel", {
                    Parent = frame;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Size = dim2(0, 0, 0, 16);
                    AutomaticSize = Enum.AutomaticSize.X;
                    FontFace = fonts.small;
                    Text = text;
                    TextSize = 13;
                    TextColor3 = color or rgb(245, 245, 245);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 176;
                })
            end

            local default_title = tostring(library.watermark_title or (library.current_window and library.current_window.name) or "")
            local label = create_segment(default_title, rgb(245, 245, 245))
            local sep1 = create_segment("|", rgb(110, 110, 110))
            local fps_label = create_segment("0fps", themes.preset.accent)
            local sep2 = create_segment("|", rgb(110, 110, 110))
            local ping_label = create_segment("0ms", rgb(210, 210, 210))
            library:apply_theme(fps_label, "accent", "TextColor3")
            label.Visible = default_title ~= ""
            sep1.Visible = default_title ~= ""

            library.watermark_frame = frame
            library.Watermark = frame
            library.watermark_label = label
            library.watermark_sep1 = sep1
            library.watermark_fps_label = fps_label
            library.watermark_ping_label = ping_label
            library.WatermarkText = label
            library:draggify(frame)

            if not library.watermark_stats_connection then
                local frame_count = 0
                local last_update = os.clock()

                local function read_ping()
                    local value

                    pcall(function()
                        value = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                    end)

                    if type(value) ~= "number" then
                        pcall(function()
                            value = stats.PerformanceStats.Ping:GetValue()
                        end)
                    end

                    return floor(tonumber(value) or 0)
                end

                library.watermark_stats_connection = library:connection(run.RenderStepped, function()
                    frame_count += 1

                    local now = os.clock()
                    local elapsed = now - last_update

                    if elapsed < 0.5 then
                        return
                    end

                    local fps = floor((frame_count / elapsed) + 0.5)
                    frame_count = 0
                    last_update = now

                    if library.watermark_fps_label then
                        library.watermark_fps_label.Text = tostring(fps) .. "fps"
                    end

                    if library.watermark_ping_label then
                        library.watermark_ping_label.Text = tostring(read_ping()) .. "ms"
                    end
                end)
            end

            return frame
        end

        function library:set_watermark(text)
            local frame = library:create_watermark()
            if not frame then
                return
            end

            local current_window = library.current_window
            library.watermark_title = tostring(text or (current_window and current_window.name) or "")
            library.watermark_label.Text = library.watermark_title
            library.watermark_label.Visible = library.watermark_title ~= ""
            if library.watermark_sep1 then
                library.watermark_sep1.Visible = library.watermark_title ~= ""
            end
            flags["watermark_visible"] = true
            flags["ShowWatermark"] = true
            frame.Visible = true
            return frame
        end

        function library:set_watermark_visible(visible)
            local frame = library:create_watermark()
            visible = visible == true
            flags["watermark_visible"] = visible
            flags["ShowWatermark"] = visible

            if visible and library.watermark_label then
                local current_window = library.current_window
                library.watermark_title = tostring(library.watermark_title or (current_window and current_window.name) or "")
                library.watermark_label.Text = library.watermark_title
                library.watermark_label.Visible = library.watermark_title ~= ""
                if library.watermark_sep1 then
                    library.watermark_sep1.Visible = library.watermark_title ~= ""
                end
            end

            if frame then
                frame.Visible = visible
            end
        end

        function library:animate_visible_sections()
            if library.current_window and library.current_window.menu_open == false then
                return
            end

            local index = 0

            for _, section in library.sections do
                local outline = section.items and section.items[ "outline" ]
                if outline and outline.Parent and library.items and outline:IsDescendantOf(library.items) and outline.Visible then
                    index += 1
                    if section.animate_in then
                        section.animate_in(index)
                    end
                end
            end
        end

        function library:option(options, keys, fallback)
            if not options then
                return fallback
            end

            for _, key in keys do
                local value = options[key]
                if value ~= nil then
                    return value
                end
            end

            return fallback
        end

        function library:safe_callback(callback, ...)
            if type(callback) ~= "function" then
                return false
            end

            local ok, result = pcall(callback, ...)
            if not ok then
                warn("[Nuke UI] callback error:", result)
            end

            return ok, result
        end

        function library:SafeCallback(callback, ...)
            return library:safe_callback(callback, ...)
        end

        function library:SetVisibility(visible)
            if type(self) ~= "table" or type(self.items) ~= "table" then
                return
            end

            local roots = {
                "toggle",
                "toggle_object",
                "slider_object",
                "dropdown_object",
                "label",
                "label_element",
                "keybind_element",
                "button_element",
                "textbox",
                "colorpicker",
                "settings",
                "list",
                "outline",
                "dropdown_holder",
            }

            for _, key in roots do
                local item = self.items[key]
                if typeof(item) == "Instance" and item:IsA("GuiObject") then
                    item.Visible = visible
                end
            end

            if visible == false and self.open ~= nil and self.set_visible then
                self.open = false
                self.set_visible(false)
            end
        end

        library.SetVisible = library.SetVisibility

        function library:OnUnload(callback)
            library.on_unload = callback
        end

        function library:notify(options, lifetime)
            local payload
            if type(options) == "table" then
                payload = {
                    name = options.name or options.Name or options.title or options.Title or "Notification",
                    info = options.info or options.Info or options.content or options.Content or options.text or options.Text or "",
                    lifetime = options.lifetime or options.Lifetime or options.duration or options.Duration or lifetime or 2.2,
                }
            else
                payload = {
                    name = "Notification",
                    info = tostring(options or ""),
                    lifetime = lifetime or 2.2,
                }
            end

            return notifications:create_notification(payload)
        end

        function library:unload_menu() 
            if library.unloaded then
                return
            end

            library.unloaded = true
            library:safe_callback(library.on_unload)

            if library[ "items" ] then 
                library[ "items" ]:Destroy()
            end

            if library[ "other" ] then 
                library[ "other" ]:Destroy()
            end 
            
            for index, connection in library.connections do 
                connection:Disconnect() 
                library.connections[index] = nil 
            end
        end 

        library.Unload = library.unload_menu
        library.Destroy = library.unload_menu
        library.Notify = library.notify

        function library:window(properties)
            properties = properties or {}

            local cfg = { 
                suffix = properties.suffix or properties.Suffix or "";
                name = tostring(properties.name or properties.Name or properties.title or properties.Title or properties.window_name or properties.WindowName or "");
                game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "";
                size = properties.size or properties.Size or dim2(0, 700, 0, 565);
                menu_key = properties.menuKey or properties.menu_key or properties.MenuKey or Enum.KeyCode.Insert;
                ui_scale = clamp(tonumber(properties.scale or properties.Scale or properties.uiScale or properties.UIScale) or 1, 0.5, 2);
                menu_open = true;
                selected_tab;
                items = {};

                tween;
            }

            library.current_window = cfg
            library.CurrentWindow = cfg
            
            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });
            
            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            library[ "cache" ] = library:create( "Frame" , {
                Parent = library[ "other" ];
                Name = "\0";
                Visible = false;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = dim2(0, 0, 0, 0);
            });

            library:create_keybind_frame()
            library:create_watermark()

            local items = cfg.items; do
                items[ "main" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = cfg.size;
                    Name = "\0";
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    ClipsDescendants = true;
                    BackgroundTransparency = 1;
                    BackgroundColor3 = themes.preset.background
                }); items[ "main" ].Position = dim2(0, items[ "main" ].AbsolutePosition.X, 0, items[ "main" ].AbsolutePosition.Y)
                library:apply_theme(items[ "main" ], "background", "BackgroundColor3")
                library:apply_transparency(items[ "main" ], "window_transparency")

                items[ "main_scale" ] = library:create( "UIScale" , {
                    Parent = items[ "main" ];
                    Scale = cfg.ui_scale * 0.96;
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "main" ];
                    CornerRadius = dim(0, 10)
                });
                
                items[ "main_stroke" ] = library:create( "UIStroke" , {
                    Color = themes.preset.border;
                    Parent = items[ "main" ];
                    Transparency = 0.2;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }); library:apply_theme(items[ "main_stroke" ], "border", "Color")
                
                items[ "side_frame" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 140, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.background
                });
                library:apply_theme(items[ "side_frame" ], "background", "BackgroundColor3")
                
                items[ "side_line" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "side_frame" ];
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.border;
                    BackgroundTransparency = 0.35;
                }); library:apply_theme(items[ "side_line" ], "border", "BackgroundColor3")
                
                items[ "button_holder" ] = library:create( "ScrollingFrame" , {
                    Active = true;
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    ClipsDescendants = true;
                    Position = dim2(0, 0, 0, 112);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, -180);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255);
                    CanvasSize = dim2(0, 0, 0, 0);
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollingDirection = Enum.ScrollingDirection.Y;
                    ScrollBarImageColor3 = themes.preset.accent;
                    ScrollBarImageTransparency = 0.15;
                    ScrollBarThickness = 0;
                }); cfg.button_holder = items[ "button_holder" ]; library:apply_theme(items[ "button_holder" ], "accent", "ScrollBarImageColor3")
                
                items[ "button_holder_layout" ] = library:create( "UIListLayout" , {
                    Parent = items[ "button_holder" ];
                    Padding = dim(0, 8);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 10);
                    PaddingBottom = dim(0, 16);
                    Parent = items[ "button_holder" ];
                    PaddingRight = dim(0, 10);
                    PaddingLeft = dim(0, 8)
                });

                local function update_tab_scrollbar()
                    if not items[ "button_holder" ] or not items[ "button_holder_layout" ] then
                        return
                    end

                    local should_scroll = items[ "button_holder_layout" ].AbsoluteContentSize.Y > items[ "button_holder" ].AbsoluteSize.Y
                    items[ "button_holder" ].ScrollBarThickness = should_scroll and 3 or 0
                end

                library:connection(items[ "button_holder_layout" ]:GetPropertyChangedSignal("AbsoluteContentSize"), update_tab_scrollbar)
                library:connection(items[ "button_holder" ]:GetPropertyChangedSignal("AbsoluteSize"), update_tab_scrollbar)
                task.defer(update_tab_scrollbar)

                local accent = themes.preset.accent
                items[ "title_accent" ] = library:create( "Frame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Visible = false;
                    Position = dim2(0, 12, 0, 19);
                    Size = dim2(0, 3, 0, 24);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent;
                }); library:apply_theme(items[ "title_accent" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = items[ "title_accent" ];
                    CornerRadius = dim(0, 999)
                });

                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Text = cfg.name ~= "" and (cfg.name .. cfg.suffix) or "";
                    BackgroundTransparency = 1;
                    Visible = cfg.name ~= "";
                    Position = dim2(0, 24, 0, 6);
                    Size = dim2(1, -28, 0, 48);
                    TextColor3 = rgb(245, 245, 245);
                    BorderSizePixel = 0;
                    RichText = false;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextScaled = true;
                    TextTruncate = Enum.TextTruncate.None;
                    TextSize = 22;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create("UITextSizeConstraint", {
                    Parent = items[ "title" ];
                    MaxTextSize = 22;
                    MinTextSize = 8;
                });

                items[ "search_holder" ] = library:create( "Frame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Position = dim2(0, 10, 0, 62);
                    Size = dim2(1, -20, 0, 34);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.surface;
                    BackgroundTransparency = themes.preset.panel_transparency;
                });
                library:apply_theme(items[ "search_holder" ], "surface", "BackgroundColor3")
                library:apply_transparency(items[ "search_holder" ], "panel_transparency")

                library:create( "UICorner" , {
                    Parent = items[ "search_holder" ];
                    CornerRadius = dim(0, 8)
                });

                items[ "search_stroke" ] = library:create( "UIStroke" , {
                    Parent = items[ "search_holder" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = themes.preset.border;
                    Transparency = 0.25;
                }); library:apply_theme(items[ "search_stroke" ], "border", "Color")

                items[ "search_accent" ] = library:create( "Frame" , {
                    Parent = items[ "search_holder" ];
                    Name = "\0";
                    Visible = false;
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 9, 0.5, 0);
                    Size = dim2(0, 2, 0, 14);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent;
                    BackgroundTransparency = 0.15;
                }); library:apply_theme(items[ "search_accent" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = items[ "search_accent" ];
                    CornerRadius = dim(0, 999)
                });

                items[ "search_box" ] = library:create( "TextBox" , {
                    Parent = items[ "search_holder" ];
                    Name = "\0";
                    Position = dim2(0, 18, 0, 0);
                    Size = dim2(1, -18, 1, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    ClearTextOnFocus = false;
                    FontFace = fonts.small;
                    PlaceholderText = "Search";
                    PlaceholderColor3 = rgb(105, 105, 112);
                    Text = "";
                    TextColor3 = rgb(230, 230, 230);
                    TextSize = 14;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextYAlignment = Enum.TextYAlignment.Center;
                });

                library:connection(items[ "search_box" ]:GetPropertyChangedSignal("Text"), function()
                    library:set_search(items[ "search_box" ].Text)
                end)

                local thumbnail = ""
                pcall(function()
                    thumbnail = players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                end)

                items[ "profile" ] = library:create( "Frame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    AnchorPoint = vec2(0, 1);
                    Position = dim2(0, 10, 1, -12);
                    Size = dim2(1, -20, 0, 54);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.surface;
                    BackgroundTransparency = themes.preset.panel_transparency;
                });
                library:apply_theme(items[ "profile" ], "surface", "BackgroundColor3")
                library:apply_transparency(items[ "profile" ], "panel_transparency")

                library:create( "UICorner" , {
                    Parent = items[ "profile" ];
                    CornerRadius = dim(0, 8)
                });

                items[ "profile_stroke" ] = library:create( "UIStroke" , {
                    Parent = items[ "profile" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = themes.preset.border;
                    Transparency = 0.28;
                }); library:apply_theme(items[ "profile_stroke" ], "border", "Color")

                items[ "profile_avatar" ] = library:create( "ImageLabel" , {
                    Parent = items[ "profile" ];
                    Name = "\0";
                    BackgroundColor3 = rgb(28, 28, 28);
                    BorderSizePixel = 0;
                    Position = dim2(0, 8, 0.5, -17);
                    Size = dim2(0, 34, 0, 34);
                    Image = thumbnail;
                    ScaleType = Enum.ScaleType.Crop;
                });

                library:create( "UICorner" , {
                    Parent = items[ "profile_avatar" ];
                    CornerRadius = dim(0, 999)
                });

                items[ "profile_name" ] = library:create( "TextLabel" , {
                    Parent = items[ "profile" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = dim2(0, 48, 0, 10);
                    Size = dim2(1, -56, 0, 16);
                    FontFace = fonts.font;
                    Text = lp.DisplayName ~= "" and lp.DisplayName or lp.Name;
                    TextColor3 = rgb(242, 242, 242);
                    TextScaled = true;
                    TextSize = 13;
                    TextTruncate = Enum.TextTruncate.None;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                library:create("UITextSizeConstraint", {
                    Parent = items[ "profile_name" ];
                    MaxTextSize = 13;
                    MinTextSize = 8;
                });

                items[ "profile_user" ] = library:create( "TextLabel" , {
                    Parent = items[ "profile" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = dim2(0, 48, 0, 27);
                    Size = dim2(1, -56, 0, 14);
                    FontFace = fonts.small;
                    Text = "@" .. lp.Name;
                    TextColor3 = rgb(120, 120, 120);
                    TextScaled = true;
                    TextSize = 12;
                    TextTruncate = Enum.TextTruncate.None;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });

                library:create("UITextSizeConstraint", {
                    Parent = items[ "profile_user" ];
                    MaxTextSize = 12;
                    MinTextSize = 7;
                });
                
                items[ "multi_holder" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 140, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -140, 0, 56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.multi_holder = items[ "multi_holder" ];
                
                items[ "multi_line" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "multi_holder" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.border;
                    BackgroundTransparency = 0.35;
                }); library:apply_theme(items[ "multi_line" ], "border", "BackgroundColor3")
                
                items[ "global_fade" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 140, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -140, 1, -56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.background;
                    ZIndex = 2;
                }); library:apply_theme(items[ "global_fade" ], "background", "BackgroundColor3")                

                items[ "info" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "main" ];
                    Name = "\0";
                    Visible = false;
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.surface;
                    BackgroundTransparency = themes.preset.panel_transparency;
                }); library:apply_theme(items[ "info" ], "surface", "BackgroundColor3")
                    library:apply_transparency(items[ "info" ], "panel_transparency")
                
                library:create( "UICorner" , {
                    Parent = items[ "info" ];
                    CornerRadius = dim(0, 10)
                });
                
                items[ "grey_fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "info" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.surface;
                    BackgroundTransparency = themes.preset.panel_transparency;
                }); library:apply_theme(items[ "grey_fill" ], "surface", "BackgroundColor3")
                    library:apply_transparency(items[ "grey_fill" ], "panel_transparency")
                
                items[ "game" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    Parent = items[ "info" ];
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 10, 0.5, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); 
                
                items[ "other_info" ] = library:create( "TextLabel" , {
                    Parent = items[ "info" ];
                    RichText = true;
                    Name = "\0";
                    TextColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, -10, 0.5, -1);
                    AnchorPoint = vec2(0, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    FontFace = fonts.font;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "other_info" ], "accent", "TextColor3");        
            end 

            do
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end 

            local function normalize_menu_key(key)
                if type(key) == "table" then
                    key = key.Key or key.key or key.Value or key.value or key[1]
                end

                if type(key) == "string" then
                    local upper_key = key:upper()
                    if upper_key == "NONE" or upper_key == "ESCAPE" then
                        return
                    elseif upper_key == "MB1" then
                        return Enum.UserInputType.MouseButton1
                    elseif upper_key == "MB2" then
                        return Enum.UserInputType.MouseButton2
                    elseif upper_key == "MB3" then
                        return Enum.UserInputType.MouseButton3
                    end

                    key = library:convert_enum(key) or key
                end

                if key == "NONE" or key == Enum.KeyCode.Escape then
                    return
                end

                return key
            end

            local function current_menu_key()
                local env = (getgenv and getgenv()) or _G
                local key

                key = normalize_menu_key(flags["MenuKeybind"])
                if key then
                    cfg.menu_key = key
                    return key
                end

                key = normalize_menu_key(library.ToggleKeybind)
                if key then
                    cfg.menu_key = key
                    return key
                end

                if env and type(env.Options) == "table" then
                    key = normalize_menu_key(env.Options.MenuKeybind or env.Options.menu_bind)
                    if key then
                        cfg.menu_key = key
                        return key
                    end
                end

                key = normalize_menu_key(flags["menu_bind"])
                if key then
                    cfg.menu_key = key
                    return key
                end

                key = normalize_menu_key(cfg.menu_key)
                if key then
                    cfg.menu_key = key
                end

                return key
            end

            local function menu_key_matches(input)
                local key = current_menu_key()

                if not key then
                    return false
                end

                if typeof(key) == "EnumItem" then
                    return input.KeyCode == key or input.UserInputType == key
                end

                local key_name = tostring(key):gsub("^Enum%.KeyCode%.", ""):gsub("^Enum%.UserInputType%.", "")
                return input.KeyCode.Name == key_name or input.UserInputType.Name == key_name
            end

            function cfg.set_menu_key(key)
                key = normalize_menu_key(key)

                if key then
                    cfg.menu_key = key
                end
            end

            function cfg.set_ui_scale(value)
                cfg.ui_scale = clamp(tonumber(value) or 1, 0.5, 2)

                if items[ "main_scale" ] then
                    library:tween(items[ "main_scale" ], {Scale = cfg.ui_scale}, Enum.EasingStyle.Quart, 0.18)
                end
            end

            cfg.SetUIScale = cfg.set_ui_scale
            cfg.SetScale = cfg.set_ui_scale

            function cfg.set_title(name, suffix)
                if name ~= nil then
                    cfg.name = tostring(name)
                end

                if suffix ~= nil then
                    cfg.suffix = tostring(suffix)
                end

                if items[ "title" ] then
                    items[ "title" ].Text = cfg.name ~= "" and (cfg.name .. cfg.suffix) or ""
                    items[ "title" ].Visible = cfg.name ~= ""
                end

                if library.watermark_frame and library.watermark_frame.Visible and library.watermark_label then
                    library.watermark_title = cfg.name
                    library.watermark_label.Text = library.watermark_title
                    library.watermark_label.Visible = library.watermark_title ~= ""
                    if library.watermark_sep1 then
                        library.watermark_sep1.Visible = library.watermark_title ~= ""
                    end
                end
            end

            cfg.SetTitle = cfg.set_title
            cfg.SetName = cfg.set_title

            function cfg.toggle_menu(bool) 
                bool = bool ~= false
                cfg.menu_open = bool
                cfg.fade_id = (cfg.fade_id or 0) + 1
                local fade_id = cfg.fade_id

                if bool then
                    library[ "items" ].Enabled = true
                    items[ "main" ].Visible = true
                    local base_position = cfg.closed_position or items[ "main" ].Position
                    items[ "main" ].Position = base_position + dim2(0, 0, 0, 14)
                    items[ "main" ].BackgroundTransparency = 0.54
                    items[ "main_scale" ].Scale = cfg.ui_scale
                    if items[ "global_fade" ] then
                        library:tween(items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Linear, 0.01)
                    end

                    library:fade_tree(items[ "main" ], true, 0.3)
                    library:tween(items[ "main" ], {BackgroundTransparency = themes.preset.window_transparency}, Enum.EasingStyle.Quart, 0.24)
                    library:tween(items[ "main" ], {Position = base_position}, Enum.EasingStyle.Quart, 0.3)
                    task.delay(0.08, function()
                        if cfg.fade_id == fade_id and cfg.menu_open then
                            library:animate_visible_sections()
                        end
                    end)
                    return
                end

                library:close_element()
                cfg.closed_position = items[ "main" ].Position
                library:fade_tree(items[ "main" ], false, 0.24)
                library:tween(items[ "main" ], {BackgroundTransparency = 0.54, Position = cfg.closed_position + dim2(0, 0, 0, 10)}, Enum.EasingStyle.Quart, 0.24)

                task.delay(0.24, function()
                    if cfg.fade_id == fade_id and not cfg.menu_open and library[ "items" ] then
                        items[ "main" ].Visible = false
                        items[ "main" ].BackgroundTransparency = themes.preset.window_transparency
                        items[ "main_scale" ].Scale = cfg.ui_scale
                        items[ "main" ].Position = cfg.closed_position or items[ "main" ].Position
                        if items[ "global_fade" ] then
                            items[ "global_fade" ].BackgroundTransparency = 1
                        end
                    end
                end)
            end 

            library:connection(uis.InputBegan, function(input, game_event)
                if game_event then
                    return
                end

                if menu_key_matches(input) then
                    cfg.toggle_menu(not cfg.menu_open)
                end
            end)

            task.defer(function()
                if items[ "main" ] and items[ "main" ].Parent and cfg.menu_open then
                    cfg.fade_id = (cfg.fade_id or 0) + 1
                    local fade_id = cfg.fade_id
                    local base_position = items[ "main" ].Position
                    items[ "main" ].Position = base_position + dim2(0, 0, 0, 14)
                    if items[ "global_fade" ] then
                        items[ "global_fade" ].BackgroundTransparency = 1
                    end
                    library:fade_tree(items[ "main" ], true, 0.34)
                    library:tween(items[ "main" ], {BackgroundTransparency = themes.preset.window_transparency}, Enum.EasingStyle.Quart, 0.28)
                    library:tween(items[ "main" ], {Position = base_position}, Enum.EasingStyle.Quart, 0.34)
                    items[ "main_scale" ].Scale = cfg.ui_scale
                    task.delay(0.08, function()
                        if cfg.fade_id == fade_id and cfg.menu_open then
                            library:animate_visible_sections()
                        end
                    end)
                end
            end)
                
            return setmetatable(cfg, library)
        end 

        function library:tab(properties)
            local cfg = {
                name = properties.name or properties.Name or "visuals"; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";
                group = properties.group or properties.Group;
                
                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {};
                current_multi; 
                
                items = {};
            } 

            if cfg.group ~= false then
                local group_name = cfg.group
                if not group_name then
                    local lower_name = string.lower(cfg.name)
                    group_name = (string.find(lower_name, "setting") or string.find(lower_name, "config")) and "Settings" or "General"
                end

                self.__tab_groups = self.__tab_groups or {}
                if group_name and not self.__tab_groups[group_name] and self.seperator then
                    self:seperator({name = group_name})
                    self.__tab_groups[group_name] = true
                end
            end

            local items = cfg.items; do 
                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    Name = "\0";
                    Visible = false;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 140, 0, 56);
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -160, 1, -76);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                    items[ "button" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "button_holder" ];
                        AutoButtonColor = false;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 38);
                        BorderSizePixel = 0;
                        TextSize = 15;
                        BackgroundColor3 = themes.preset.surface
                    }); library:apply_theme(items[ "button" ], "surface", "BackgroundColor3")
                    
                    items[ "icon" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "button" ];
                        AnchorPoint = vec2(0, 0.5);
                        Image = "http://www.roblox.com/asset/?id=6034767608";
                        BackgroundTransparency = 1;
                        Visible = false;
                        Position = dim2(0, 10, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 22, 0, 22);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "button" ];
                        Name = "\0";
                        Size = dim2(0, 0, 1, 0);
                        Position = dim2(0, 10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "button" ];
                        CornerRadius = dim(0, 7)
                    });

                    items[ "active_line" ] = library:create( "Frame" , {
                        Parent = items[ "button" ];
                        Name = "\0";
                        AnchorPoint = vec2(0, 0.5);
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 2, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        BackgroundColor3 = themes.preset.accent;
                    }); library:apply_theme(items[ "active_line" ], "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = items[ "active_line" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(48, 48, 48);
                        Parent = items[ "button" ];
                        Enabled = false;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    });

                    items[ "multi_section_button_holder" ] = library:create( "Frame" , {
                        Parent = library.cache;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "multi_section_button_holder" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingTop = dim(0, 8);
                        PaddingBottom = dim(0, 7);
                        Parent = items[ "multi_section_button_holder" ];
                        PaddingRight = dim(0, 7);
                        PaddingLeft = dim(0, 7)
                    });                        

                    for _, section in cfg.tabs do
                        local data = {items = {}} 

                        local multi_items = data.items; do 

                                multi_items[ "button" ] = library:create( "TextButton" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(255, 255, 255);
                                    BorderColor3 = rgb(0, 0, 0);
                                    AutoButtonColor = false;
                                    Text = "";
                                    Parent = items[ "multi_section_button_holder" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 0, 34);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.X;
                                    TextSize = 14;
                                    BackgroundColor3 = themes.preset.surface
                                }); library:apply_theme(multi_items[ "button" ], "surface", "BackgroundColor3")
                                
                                multi_items[ "name" ] = library:create( "TextLabel" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(92, 92, 92);
                                    BorderColor3 = rgb(0, 0, 0);
                                    Text = section;
                                    Parent = multi_items[ "button" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 1, 0);
                                    Position = dim2(0, 24, 0, 0);
                                    BackgroundTransparency = 1;
                                    TextXAlignment = Enum.TextXAlignment.Left;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.XY;
                                    TextSize = 14;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });
                                
                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "name" ];
                                    PaddingRight = dim(0, 5);
                                    PaddingLeft = dim(0, 5)
                                });
                                
                                multi_items[ "accent" ] = library:create( "Frame" , {
                                    BorderColor3 = rgb(0, 0, 0);
                                    AnchorPoint = vec2(0, 0.5);
                                    Parent = multi_items[ "button" ];
                                    BackgroundTransparency = 1;
                                    Position = dim2(0, 8, 0.5, 0);
                                    Name = "\0";
                                    Size = dim2(0, 3, 0, 0);
                                    BorderSizePixel = 0;
                                    BackgroundColor3 = themes.preset.accent
                                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");
                                
                                library:create( "UICorner" , {
                                    Parent = multi_items[ "accent" ];
                                    CornerRadius = dim(0, 999)
                                });
                                
                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "button" ];
                                    PaddingRight = dim(0, 10);
                                    PaddingLeft = dim(0, 8)
                                });
                                
                                library:create( "UICorner" , {
                                    Parent = multi_items[ "button" ];
                                    CornerRadius = dim(0, 7)
                                }); 

                                multi_items[ "tab" ] = library:create( "ScrollingFrame" , {
                                    Parent = library.cache;
                                    BackgroundTransparency = 1;
                                    Name = "\0";
                                    BorderColor3 = rgb(0, 0, 0);
                                    Size = dim2(1, -20, 1, -20);
                                    BorderSizePixel = 0;
                                    Visible = false;
                                    ClipsDescendants = true;
                                    Active = true;
                                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                                    CanvasSize = dim2(0, 0, 0, 0);
                                    ScrollBarThickness = 3;
                                    ScrollBarImageColor3 = themes.preset.accent;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                }); library:apply_theme(multi_items[ "tab" ], "accent", "ScrollBarImageColor3")
                                
                                library:create( "UIListLayout" , {
                                    FillDirection = Enum.FillDirection.Vertical;
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                                    Parent = multi_items[ "tab" ];
                                    Padding = dim(0, 7);
                                    SortOrder = Enum.SortOrder.LayoutOrder;
                                });
                                
                                library:create( "UIPadding" , {
                                    PaddingTop = dim(0, 7);
                                    PaddingBottom = dim(0, 7);
                                    Parent = multi_items[ "tab" ];
                                    PaddingRight = dim(0, 7);
                                    PaddingLeft = dim(0, 7)
                                });

                        end

                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]
                        
						function data.open_page()
							local page = cfg.current_multi; 

                            if page == data then
                                library:close_element()
                                return
                            end
                            
                            if page and page.text ~= data.text then 
                                self.items[ "global_fade" ].BackgroundTransparency = 0.18
                                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quart, 0.34)
                                
                                page.page.Position = dim2(0, 0, 0, 14)
                                page.page.Size = dim2(1, -20, 1, -34)
                            end

                            if page then
                                library:tween(page.text, {TextColor3 = rgb(92, 92, 92)})
                                library:tween(page.accent, {BackgroundTransparency = 1, Size = dim2(0, 3, 0, 0)}, Enum.EasingStyle.Quart, 0.24)
                                library:tween(page.button, {BackgroundTransparency = 1})

                                page.page.Visible = false
                                page.page.Parent = library[ "cache" ] 
                            end 
                            
                            library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                            library:tween(data.accent, {BackgroundTransparency = 0, Size = dim2(0, 3, 0, 18)}, Enum.EasingStyle.Quart, 0.28)
                            library:tween(data.button, {BackgroundTransparency = 0})
                            data.page.Size = dim2(1, -20, 1, -38)
                            data.page.Position = dim2(0, 0, 0, 18)
                            library:tween(data.page, {Size = dim2(1, -20, 1, -20), Position = dim2(0, 0, 0, 0)}, Enum.EasingStyle.Quart, 0.34)

                            data.page.Visible = true
                            data.page.Parent = items["tab_holder"]

                            cfg.current_multi = data
                            task.delay(0.03, function()
                                library:animate_visible_sections()
                            end)

                            library:close_element()
						end

						multi_items[ "button" ].MouseButton1Down:Connect(function()
							data.open_page() 
						end)

						cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
                    end 

                    cfg.pages[1].open_page()

            end 

            function cfg.open_tab() 
                local selected_tab = self.selected_tab

                if selected_tab and selected_tab[ 4 ] == items[ "tab_holder" ] then
                    library:close_element()
                    return
                end
                
                    if selected_tab then 
                        if selected_tab[ 4 ] ~= items[ "tab_holder" ] then 
                        self.items[ "global_fade" ].BackgroundTransparency = 0.18
                        
                        library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quart, 0.34)
                        selected_tab[ 4 ].Position = dim2(0, 140, 0, 70)
                        selected_tab[ 4 ].Size = dim2(1, -140, 1, -70)
                    end

                    library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1, Size = dim2(1, 0, 0, 38)}, Enum.EasingStyle.Quart, 0.22)
                    library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(120, 120, 120)})
                    library:tween(selected_tab[ 3 ], {TextColor3 = rgb(130, 130, 130), TextSize = 14, Position = dim2(0, 10, 0, 0)}, Enum.EasingStyle.Quart, 0.22)
                    if selected_tab[ 6 ] then
                        library:tween(selected_tab[ 6 ], {BackgroundTransparency = 1})
                        library:tween(selected_tab[ 6 ], {Size = dim2(0, 2, 0, 0)}, Enum.EasingStyle.Quart, 0.28)
                    end

                    selected_tab[ 4 ].Visible = false
                    selected_tab[ 4 ].Parent = library[ "cache" ]
                    selected_tab[ 5 ].Visible = false
                    selected_tab[ 5 ].Parent = library[ "cache" ]
                end

                library:tween(items[ "button" ], {BackgroundTransparency = 0.15, Size = dim2(1, 0, 0, 42)}, Enum.EasingStyle.Back, 0.28)
                library:tween(items[ "icon" ], {ImageColor3 = rgb(255, 255, 255)})
                library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255), TextSize = 15, Position = dim2(0, 14, 0, 0)}, Enum.EasingStyle.Quart, 0.24)
                library:tween(items[ "active_line" ], {BackgroundTransparency = 0, Size = dim2(0, 2, 1, -12)}, Enum.EasingStyle.Quart, 0.32)
                items[ "tab_holder" ].Size = dim2(1, -140, 1, -74)
                items[ "tab_holder" ].Position = dim2(0, 140, 0, 74)
                library:tween(items[ "tab_holder" ], {Size = dim2(1, -140, 1, -56), Position = dim2(0, 140, 0, 56)}, Enum.EasingStyle.Quart, 0.34)
                
                items[ "tab_holder" ].Visible = true 
                items[ "tab_holder" ].Parent = self.items[ "main" ]
                items[ "multi_section_button_holder" ].Visible = true 
                items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

                self.selected_tab = {
                    items[ "button" ];
                    items[ "icon" ];
                    items[ "name" ];
                    items[ "tab_holder" ];
                    items[ "multi_section_button_holder" ];
                    items[ "active_line" ];
                }

                library.current_tab_name = cfg.name
                task.delay(0.03, function()
                    library:animate_visible_sections()
                end)

                library:close_element()
            end

            items[ "button" ].MouseButton1Down:Connect(function()
                cfg.open_tab()
            end)
            
            if not self.selected_tab then 
                cfg.open_tab(true) 
            end

            return table.unpack(cfg.pages)
        end

        function library:seperator(properties)
            local cfg = {items = {}, name = properties.Name or properties.name or "General"}

            local items = cfg.items do 
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = self.items[ "button_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 40, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0; 
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 13;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end;    

            return setmetatable(cfg, library)
        end 

            function library:column(properties) 
                local cfg = {items = {}, size = properties.size or 1}

                local items = cfg.items; do     
                    items[ "column" ] = library:create( "Frame" , {
                        Parent = self[ "parent" ] or self.items["tab_parent"];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 10);
                        Parent = items[ "column" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "column" ];
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Padding = dim(0, 10);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                end 

                return setmetatable(cfg, library)
            end 

            function library:sub_tab(properties) 
                local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

                local items = cfg.items; do 
                    items[ "tab_parent" ] = library:create( "Frame" , {
                        Parent = self.items[ "tab" ];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        AutomaticSize = Enum.AutomaticSize.Y;
                        ClipsDescendants = false;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalAlignment = Enum.VerticalAlignment.Top;
                        Parent = items[ "tab_parent" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end

                return setmetatable(cfg, library)
            end 

        function library:section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section"; 
                side = properties.side or properties.Side or "left";
                default = library:option(properties, {"default", "Default"}, false);
                size = properties.size or properties.Size or self.size or 0.5; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = library:option(properties, {"fading", "Fading"}, false);
                items = {};
            };
            
            local items = cfg.items; do 
                items[ "motion_holder" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = self.items[ "column" ];
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Size = dim2(1, 0, 0, 42);
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "motion_holder" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 42);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    BackgroundTransparency = themes.preset.card_transparency;
                    BackgroundColor3 = themes.preset.card
                }); library:apply_theme(items[ "outline" ], "card", "BackgroundColor3")

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "outline_stroke" ] = library:create( "UIStroke" , {
                    Parent = items[ "outline" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = themes.preset.border;
                    Transparency = 0.32;
                }); library:apply_theme(items[ "outline_stroke" ], "border", "Color")

                library:apply_card_transparency(items[ "outline" ], "BackgroundTransparency", 0)
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 0, 40);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    BackgroundTransparency = clamp(themes.preset.card_transparency + 0.04, 0, 1);
                    BackgroundColor3 = themes.preset.card_inner
                }); library:apply_theme(items[ "inline" ], "card_inner", "BackgroundColor3")
                
                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });

                library:apply_card_transparency(items[ "inline" ], "BackgroundTransparency", 0.04)
                
                items[ "scrolling" ] = library:create( "Frame" , {
                    Parent = items[ "inline" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 35);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "elements_layout" ] = library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 35);
                    BorderSizePixel = 0;
                    TextSize = 16;
                    BackgroundTransparency = clamp(themes.preset.card_transparency + 0.06, 0, 1);
                    BackgroundColor3 = themes.preset.card
                }); library:apply_theme(items[ "button" ], "card", "BackgroundColor3")

                library:apply_card_transparency(items[ "button" ], "BackgroundTransparency", 0.06)
                
                library:create( "UIStroke" , {
                    Color = rgb(48, 48, 48);
                    Parent = items[ "button" ];
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "Icon" ] = library:create( "ImageLabel" , {
                    ImageColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "button" ];
                    AnchorPoint = vec2(0, 0.5);
                    Image = cfg.icon;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 22, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");
                
                items[ "section_title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 40, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "button" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(56, 56, 56)
                });
                
                if cfg.fading_toggle then 
                    items[ "toggle" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(1, 0.5);
                        Parent = items[ "button" ];
                        Name = "\0";
                        Position = dim2(1, -9, 0.5, 0);
                        Size = dim2(0, 36, 0, 18);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(58, 58, 58)
                    });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    items[ "toggle_outline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(50, 50, 50)
                    });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_outline" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "toggle_outline" ]
                    });
                    
                    items[ "toggle_circle" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_outline" ];
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(86, 86, 86)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_circle" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 7)
                    });
                
                    items[ "fade" ] = library:create( "Frame" , {
                        Parent = items[ "outline" ];
                        BackgroundTransparency = 0.800000011920929;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "fade" ];
                        CornerRadius = dim(0, 7)
                    });
                end 
            end;

            local function update_section_size()
                local content_height = 0

                if items[ "elements_layout" ] then
                    content_height = items[ "elements_layout" ].AbsoluteContentSize.Y
                end

                local body_height = max(32, content_height + 35)
                local total_height = body_height + 38

                items[ "scrolling" ].Size = dim2(1, 0, 0, body_height)
                items[ "inline" ].Size = dim2(1, -2, 0, total_height)
                local section_size = dim2(1, 0, 0, total_height + 2)
                items[ "motion_holder" ].Size = section_size
                items[ "outline" ].Size = section_size

                if cfg.search_size then
                    cfg.search_size = section_size
                end
            end

            if items[ "elements_layout" ] then
                library:connection(items[ "elements_layout" ]:GetPropertyChangedSignal("AbsoluteContentSize"), update_section_size)
            end

            task.defer(update_section_size)

            function cfg.animate_in(order)
                local outline = items[ "outline" ]
                if not outline or not outline.Parent then
                    return
                end

                local base_position = cfg.motion_base_position or dim2(0, 0, 0, 0)
                local delay_time = ((order or 1) - 1) * 0.045
                local current_window = library.current_window
                local window_fade_id = current_window and current_window.fade_id
                cfg.animate_id = (cfg.animate_id or 0) + 1
                local animate_id = cfg.animate_id

                cfg.motion_base_position = base_position
                library:set_fade_tree(outline, 1)
                outline.Position = base_position + dim2(0, 0, 0, 18)
                outline.BackgroundTransparency = 1
                items[ "inline" ].BackgroundTransparency = 1
                items[ "button" ].BackgroundTransparency = 1

                task.delay(delay_time, function()
                    local active_window = library.current_window
                    if cfg.animate_id ~= animate_id or not outline.Parent or (active_window and active_window.menu_open == false) or (active_window and window_fade_id and active_window.fade_id ~= window_fade_id) then
                        return
                    end

                    library:fade_tree(outline, true, 0.4)
                    library:tween(outline, {Position = base_position, BackgroundTransparency = clamp(themes.preset.card_transparency, 0, 1)}, Enum.EasingStyle.Quart, 0.4)
                    library:tween(items[ "inline" ], {BackgroundTransparency = clamp(themes.preset.card_transparency + 0.04, 0, 1)}, Enum.EasingStyle.Quart, 0.4)
                    library:tween(items[ "button" ], {BackgroundTransparency = clamp(themes.preset.card_transparency + 0.06, 0, 1)}, Enum.EasingStyle.Quart, 0.4)

                    task.delay(0.42, function()
                        if cfg.animate_id == animate_id then
                            cfg.motion_base_position = nil
                        end
                    end)
                end)
            end

            insert(library.sections, cfg)

            if cfg.fading_toggle then
                items[ "button" ].MouseButton1Click:Connect(function()
                    cfg.default = not cfg.default 
                    cfg.toggle_section(cfg.default) 
                end)

                function cfg.toggle_section(bool)
                    library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 58)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 86), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
                end 
            end 

            library:register_searchable(cfg, cfg.name)
            library:refresh_search()

            return setmetatable(cfg, library)
        end  

        function library:toggle(options) 
            local toggle_type = library:option(options, {"type", "Type"}, nil)
            local cfg = {
                enabled = library:option(options, {"enabled", "Enabled"}, nil),
                name = library:option(options, {"name", "Name"}, "Toggle"),
                info = library:option(options, {"info", "Info", "description", "Description"}, nil),
                flag = library:option(options, {"flag", "Flag"}, nil) or library:next_flag(),
                
                type = toggle_type and string.lower(toggle_type) or "checkbox";

                default = library:option(options, {"default", "Default"}, false),
                folding = library:option(options, {"folding", "Folding"}, false), 
                callback = library:option(options, {"callback", "Callback"}, function() end),

                items = {};
                seperator = library:option(options, {"seperator", "Seperator", "separator", "Separator"}, false);
            }

            if cfg.enabled == nil then
                cfg.enabled = cfg.default
            end

            library:append_search_text(self, cfg.name)
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "toggle" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if false and cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "toggle" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                    if cfg.type == "checkbox" then 
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AutoButtonColor = false;
                            AnchorPoint = vec2(1, 0);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            Size = dim2(0, 16, 0, 16);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = cfg.default and themes.preset.accent or rgb(67, 67, 67)
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 4)
                        });
                        
                        items[ "outline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = cfg.default and themes.preset.accent or rgb(20, 20, 20)
                        }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");
                        
                        items[ "tick" ] = library:create( "ImageLabel" , {
                            ImageTransparency = cfg.default and 0 or 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Image = "rbxassetid://111862698467575";
                            ImageColor3 = rgb(8, 8, 8);
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 0);
                            Parent = items[ "outline" ];
                            Rotation = cfg.default and 0 or 45;
                            Size = dim2(1, 2, 1, 2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255);
                            ZIndex = 1;
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "outline" ];
                            CornerRadius = dim(0, 4)
                        });
                        
                        library:create( "UIGradient" , {
                            Enabled = false;
                            Parent = items[ "outline" ];
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
                        });  
                    else 
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AnchorPoint = vec2(1, 0.5);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, -9, 0.5, 0);
                            Size = dim2(0, 36, 0, 18);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = cfg.default and themes.preset.accent or rgb(58, 58, 58)
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 999)
                        });
                        
                        items[ "inline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = cfg.default and themes.preset.accent or rgb(50, 50, 50)
                        }); library:apply_theme(items[ "inline" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "inline" ];
                            CornerRadius = dim(0, 999)
                        });
                        
                        library:create( "UIGradient" , {
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                            Parent = items[ "inline" ]
                        });
                        
                        items[ "circle" ] = library:create( "Frame" , {
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Position = cfg.default and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 12, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = cfg.default and rgb(255, 255, 255) or rgb(86, 86, 86)
                        });
                        
                        library:create( "UICorner" , {
                            Parent = items[ "circle" ];
                            CornerRadius = dim(0, 999)
                        });                        
                    end 

            end;
            
            function cfg.set(bool)
                bool = bool == true
                cfg.enabled = bool

                if cfg.type == "checkbox" then 
                    items[ "tick" ]:SetAttribute(library:fade_attribute_name("ImageTransparency"), bool and 0 or 1)
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 67)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(20, 20, 20)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 58)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 86), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end

                flags[cfg.flag] = bool
                library:safe_callback(cfg.callback, bool)

                if cfg.folding then 
                    elements.Visible = bool
                end
            end 
            
            local function toggle_clicked()
                if cfg.toggle_debounce then
                    return
                end

                cfg.toggle_debounce = true
                cfg.set(not cfg.enabled)

                task.delay(0.05, function()
                    cfg.toggle_debounce = false
                end)
            end

            items[ "toggle" ].MouseButton1Click:Connect(toggle_clicked)
            items[ "toggle_button" ].MouseButton1Click:Connect(toggle_clicked)
            
            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(56, 56, 56)
                });
            end

            library:tooltip(items[ "toggle" ], cfg.info)
            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 
        
        function library:slider(options) 
            local cfg = {
                name = library:option(options, {"name", "Name"}, nil),
                suffix = library:option(options, {"suffix", "Suffix"}, ""),
                flag = library:option(options, {"flag", "Flag"}, nil) or library:next_flag(),
                callback = library:option(options, {"callback", "Callback"}, function() end), 
                info = library:option(options, {"info", "Info", "description", "Description"}, nil); 

                min = library:option(options, {"min", "Min", "minimum", "Minimum"}, 0),
                max = library:option(options, {"max", "Max", "maximum", "Maximum"}, 100),
                intervals = library:option(options, {"interval", "Interval", "decimal", "Decimal"}, 1),
                default = library:option(options, {"default", "Default"}, 10),
                value = library:option(options, {"default", "Default"}, 10), 
                seperator = library:option(options, {"seperator", "Seperator", "separator", "Separator"}, true);

                dragging = false,
                items = {}
            } 

            library:append_search_text(self, cfg.name)
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                if false and cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 37);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 23);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 4);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 33)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "slider" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "slider" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 0, 4);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");
                
                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "circle" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0.5, 0.5);
                    Parent = items[ "fill" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(244, 244, 244)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "circle" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4)
                });
                
                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "50%";
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 6, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "value" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end 

            function cfg.set(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 0, 2)}, Enum.EasingStyle.Linear, 0.05)
                items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

                flags[cfg.flag] = cfg.value
                library:safe_callback(cfg.callback, flags[cfg.flag])
            end

            items[ "slider" ].MouseButton1Down:Connect(function()
                cfg.dragging = true 
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
            end)

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                    local size_x = (input.Position.X - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X
                    local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(value)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    cfg.dragging = false
                    library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2) 
                end 
            end)

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(56, 56, 56)
                });
            end 

            library:tooltip(items[ "slider_object" ], cfg.info)
            cfg.set(cfg.default)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:dropdown(options)
            local visible_options = tonumber(library:option(options, {"max_visible_options", "MaxVisibleOptions", "visible_options", "VisibleOptions", "max_options", "MaxOptions"}, 6)) or 6
            local max_dropdown_height = tonumber(library:option(options, {"max_height", "MaxHeight", "dropdown_height", "DropdownHeight"}, nil))

            local cfg = {
                name = library:option(options, {"name", "Name"}, nil);
                info = library:option(options, {"info", "Info", "description", "Description"}, nil);
                flag = library:option(options, {"flag", "Flag"}, nil) or library:next_flag();
                options = library:option(options, {"items", "Items", "options", "Options", "values", "Values"}, {""});
                callback = library:option(options, {"callback", "Callback"}, function() end);
                multi = library:option(options, {"multi", "Multi"}, false);
                scrolling = library:option(options, {"scrolling", "Scrolling"}, false);

                width = library:option(options, {"width", "Width"}, 130);

                open = false;
                option_instances = {};
                multi_items = {};
                ignore = library:option(options, {"ignore", "Ignore"}, false);
                max_visible_options = clamp(floor(visible_options + 0.5), 1, 12);
                max_dropdown_height = max_dropdown_height and clamp(max_dropdown_height, 40, 320) or nil;
                content_y_size = 0;
                items = {};
                y_size;
                seperator = library:option(options, {"seperator", "Seperator", "separator", "Separator"}, true);
            }   

            local default = library:option(options, {"default", "Default"}, nil)
            cfg.default = default ~= nil and default or (cfg.multi and {cfg.options[1]}) or cfg.options[1] or "None"
            library:append_search_text(self, cfg.name)
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 

                    items[ "dropdown_object" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "Dropdown";
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    if false and cfg.info then 
                        items[ "info" ] = library:create( "TextLabel" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(130, 130, 130);
                            BorderColor3 = rgb(0, 0, 0);
                            TextWrapped = true;
                            Text = cfg.info;
                            Parent = items[ "dropdown_object" ];
                            Name = "\0";
                            Position = dim2(0, 5, 0, 17);
                            Size = dim2(1, -10, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 16;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                    end 

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    items[ "dropdown" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, cfg.width, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 33)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "dropdown" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "sub_text" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(86, 86, 86);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "awdawdawdawdawdawdawdaw";
                        Parent = items[ "dropdown" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "sub_text" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "indicator" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(86, 86, 86);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://101025591575185";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -5, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "items" ];
                        Name = "\0";
                        Visible = false;
                        ClipsDescendants = true;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });
                    
                    items[ "outline" ] = library:create( "ScrollingFrame" , {
                        Active = true;
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 33);
                        CanvasSize = dim2(0, 0, 0, 0);
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarImageColor3 = themes.preset.accent;
                        ScrollBarImageTransparency = 0.15;
                        ScrollBarThickness = 0;
                        ScrollingDirection = Enum.ScrollingDirection.Y;
                        ScrollingEnabled = false;
                        ZIndex = 10;
                    }); library:apply_theme(items[ "outline" ], "accent", "ScrollBarImageColor3");
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });
                    
                    items[ "dropdown_layout" ] = library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });

            end 

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 10;
                }); library:apply_theme(button, "accent", "TextColor3");
                
                library:create( "UIPadding" , {
                    Parent = button;
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                return button
            end
            
            function cfg.set_visible(bool)
                local a = bool and cfg.y_size or 0
                local position_y = items[ "dropdown" ].AbsolutePosition.Y + 80
                cfg.visibility_id = (cfg.visibility_id or 0) + 1
                local visibility_id = cfg.visibility_id

                if bool then
                    items[ "dropdown_holder" ].Visible = true
                    items[ "outline" ].CanvasPosition = vec2(0, 0)

                    local current_camera = ws.CurrentCamera or camera
                    local viewport_y = current_camera and current_camera.ViewportSize.Y or 720
                    local bottom_limit = viewport_y - 12
                    local screen_height_limit = max(40, viewport_y - 24)

                    if a > screen_height_limit then
                        a = screen_height_limit
                    end

                    local should_scroll = cfg.content_y_size > a
                    items[ "outline" ].ScrollingEnabled = should_scroll
                    items[ "outline" ].ScrollBarThickness = should_scroll and 3 or 0

                    if position_y + a > bottom_limit then
                        local above_y = items[ "dropdown" ].AbsolutePosition.Y + 60 - a
                        position_y = above_y >= 12 and above_y or max(12, bottom_limit - a)
                    end
                else
                    items[ "outline" ].ScrollingEnabled = false
                    items[ "outline" ].ScrollBarThickness = 0
                end

                library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, a)})

                items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X, 0, position_y)
                if not bool then
                    task.delay(0.25, function()
                        if cfg.visibility_id == visibility_id and not cfg.open and items[ "dropdown_holder" ] then
                            items[ "dropdown_holder" ].Visible = false
                        end
                    end)
                end

                if not (self.sanity and library.current_open == self) then 
                    library:close_element(cfg)
                end
            end
            
            function cfg.set(value)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do 
                    if option.Text == value or (isTable and find(value, option.Text)) then 
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = themes.preset.accent
                    else
                        option.TextColor3 = rgb(72, 72, 73)
                    end
                end

                items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
                flags[cfg.flag] = isTable and selected or selected[1]
                
                library:safe_callback(cfg.callback, flags[cfg.flag]) 
            end
            
            function cfg.refresh_options(list)
                list = list or {}
                cfg.y_size = 0
                cfg.content_y_size = 0

                for _, option in cfg.option_instances do 
                    option:Destroy() 
                end
                
                cfg.option_instances = {} 

                for _, option in list do 
                    local button = cfg.render_option(option)
                    local button_height = button.AbsoluteSize.Y

                    if button_height <= 0 then
                        button_height = 16
                    end

                    local row_height = button_height + 6
                    cfg.content_y_size += row_height

                    if #cfg.option_instances < cfg.max_visible_options then
                        cfg.y_size += row_height
                    end

                    insert(cfg.option_instances, button)
                    
                    button.MouseButton1Down:Connect(function()
                        if cfg.multi then 
                            local selected_index = find(cfg.multi_items, button.Text)
                            
                            if selected_index then 
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end
                            
                            cfg.set(cfg.multi_items) 				
                        else 
                            cfg.set_visible(false)
                            cfg.open = false 
                            
                            cfg.set(button.Text)
                        end
                    end)
                end

                if cfg.max_dropdown_height then
                    cfg.y_size = min(cfg.y_size, cfg.max_dropdown_height)
                end

                cfg.y_size = min(cfg.y_size, cfg.content_y_size)
                items[ "outline" ].CanvasSize = dim2(0, 0, 0, cfg.content_y_size)
                items[ "outline" ].ScrollingEnabled = cfg.content_y_size > cfg.y_size
                items[ "outline" ].ScrollBarThickness = cfg.content_y_size > cfg.y_size and 3 or 0

                if cfg.open then
                    cfg.set_visible(true)
                end
            end

            items[ "dropdown" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open 
                
                cfg.set_visible(cfg.open)
            end)

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(56, 56, 56)
                });
            end 

            flags[cfg.flag] = {} 
            config_flags[cfg.flag] = cfg.set
            
            cfg.refresh_options(cfg.options)
            library:tooltip(items[ "dropdown_object" ], cfg.info)
            cfg.set(cfg.default)
                
            return setmetatable(cfg, library)
        end

        function library:label(options)
            local cfg = {
                enabled = library:option(options, {"enabled", "Enabled"}, nil),
                name = library:option(options, {"name", "Name", "text", "Text"}, "Toggle"),
                seperator = library:option(options, {"seperator", "Seperator", "separator", "Separator"}, false);
                info = library:option(options, {"info", "Info", "description", "Description"}, nil); 

                items = {};
            }

            library:append_search_text(self, cfg.name)
            local items = cfg.items; do 
                items[ "label" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "label" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if false and cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "label" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "label" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                
            end 

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(56, 56, 56)
                });
            end 

            library:tooltip(items[ "label" ], cfg.info)
            
            function cfg.set_text(text)
                cfg.name = tostring(text or "")
                items[ "name" ].Text = cfg.name
            end

            function cfg:SetText(text)
                cfg.set_text(text)
            end

            cfg.Set = cfg.SetText

            return setmetatable(cfg, library)
        end

        function library:paragraph(options)
            options = options or {}

            local title = library:option(options, {"title", "Title", "name", "Name"}, "Paragraph")
            local content = library:option(options, {"content", "Content", "text", "Text"}, "")
            local text = tostring(title or "")

            if content and tostring(content) ~= "" then
                text ..= "\n" .. tostring(content)
            end

            local cfg = self:label({
                name = text,
                info = library:option(options, {"info", "Info", "description", "Description"}, nil),
                seperator = library:option(options, {"seperator", "Seperator", "separator", "Separator"}, false),
            })

            cfg.items[ "name" ].TextWrapped = true
            cfg.items[ "name" ].Size = dim2(1, -10, 0, 0)

            function cfg:Set(options_or_text)
                if type(options_or_text) == "table" then
                    local new_title = library:option(options_or_text, {"title", "Title", "name", "Name"}, title)
                    local new_content = library:option(options_or_text, {"content", "Content", "text", "Text"}, content)
                    local new_text = tostring(new_title or "")
                    title = new_title
                    content = new_content

                    if new_content and tostring(new_content) ~= "" then
                        new_text ..= "\n" .. tostring(new_content)
                    end

                    cfg.set_text(new_text)
                    return
                end

                cfg.set_text(options_or_text)
            end

            return cfg
        end

        library.Paragraph = library.paragraph

        function library:colorpicker(options) 
            local cfg = {
                name = library:option(options, {"name", "Name"}, "Color"), 
                flag = library:option(options, {"flag", "Flag"}, nil) or library:next_flag(),
                info = library:option(options, {"info", "Info", "description", "Description"}, nil),

                color = library:option(options, {"color", "Color", "default", "Default"}, color(1, 1, 1)),
                alpha = library:option(options, {"alpha", "Alpha"}, nil) and 1 - library:option(options, {"alpha", "Alpha"}, nil) or 0,
                
                open = false, 
                callback = library:option(options, {"callback", "Callback"}, function() end),
                items = {};

                seperator = library:option(options, {"seperator", "Seperator", "separator", "Separator"}, false);
            }

            local dragging_sat = false 
            local dragging_hue = false 
            local dragging_alpha = false 

            local h, s, v = cfg.color:ToHSV() 
            local a = cfg.alpha 

            library:append_search_text(self, cfg.name)
            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local label; 
            if not self.items.right_components then 
                label = self:label({name = cfg.name, seperator = cfg.seperator})
            end

            local items = cfg.items; do 

                    items[ "colorpicker" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = label and label.items.right_components or self.items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = cfg.color
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = cfg.color
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "colorpicker_inline" ]
                    });         

                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(22, 22, 22)
                    });

                    items[ "colorpicker_fade" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        BackgroundTransparency = 0;
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 100;
                        BackgroundColor3 = rgb(22, 22, 22)
                    });
                    
                    items[ "colorpicker_components" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(20, 20, 20)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_components" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "saturation_holder" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 7, 0, 7);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -14, 1, -80);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });
                    
                    items[ "sat" ] = library:create( "TextButton" , {
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "sat" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });
                    
                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "saturation_holder" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "val" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "saturation_holder" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "satvalpicker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 1);
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Position = dim2(0, 0, 4, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "satvalpicker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "satvalpicker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });
                    
                    items[ "hue_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -64);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        AutoButtonColor = false;
                        Text = "";
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = items[ "hue_gradient" ]
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "hue_gradient" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "hue_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "hue_gradient" ];
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "hue_picker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "hue_picker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });
                    
                    items[ "alpha_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -46);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 22);
                        AutoButtonColor = false;
                        Text = "";
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_gradient" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "alpha_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "alpha_gradient" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_picker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Parent = items[ "alpha_picker" ]
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Parent = items[ "alpha_gradient" ]
                    });
                    
                    items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "alpha_gradient" ];
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 6, 0, 6);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))};
                        Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)};
                        Parent = items[ "alpha_indicator" ]
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_indicator" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "colorpicker_components" ];
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))}
                    });

                    items[ "input" ] = library:create( "TextBox" , {
                        FontFace = fonts.font;
                        AnchorPoint = vec2(1, 1);
                        Text = "";
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        BorderSizePixel = 0;
                        PlaceholderColor3 = rgb(255, 255, 255);
                        CursorPosition = -1;
                        ClearTextOnFocus = false;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255);
                        TextColor3 = rgb(72, 72, 72);
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(1, -8, 1, -11);
                        Size = dim2(1, -16, 0, 18);
                        BackgroundColor3 = rgb(33, 33, 33)
                    }); 
                    
                    library:create( "UICorner" , {
                        Parent = items[ "input" ];
                        CornerRadius = dim(0, 3)
                    });
                    
                    items[ "UICorenr" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });

            end;

            function cfg.set_visible(bool)
                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
                items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)})
                
                if not (self.sanity and library.current_open == self and self.open) then 
                    library:close_element(cfg)
                end
            end

            function cfg.set(color, alpha)
                if type(color) == "boolean" then 
                    return
                end 

                if color then 
                    h, s, v = color:ToHSV()
                end
                
                if alpha ~= nil then 
                    a = alpha
                end 
                
                local Color = hsv(h, s, v)

                library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

                items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))};
                
                items[ "colorpicker" ].BackgroundColor3 = Color
                items[ "colorpicker_inline" ].BackgroundColor3 = Color
                items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

                items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
                items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
                items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a 
                }
                
                local color = items[ "colorpicker" ].BackgroundColor3
                items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
                items[ "input" ].Text ..= library:round(1 - a, 0.01)
                
                library:safe_callback(cfg.callback, Color, a)
            end
            
            function cfg.update_color() 
                local mouse = uis:GetMouseLocation() 
                local offset = vec2(mouse.X, mouse.Y - gui_offset) 

                if dragging_sat then	
                    s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
                end

                cfg.set()
            end

            items[ "colorpicker" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open 

                cfg.set_visible(cfg.open)            
            end)

            library:connection(uis.InputChanged, function(input)
                if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                    cfg.update_color() 
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false
                end
            end)    

            items[ "alpha_gradient" ].MouseButton1Down:Connect(function()
                dragging_alpha = true 
                cfg.update_color()
            end)
            
            items[ "hue_gradient" ].MouseButton1Down:Connect(function()
                dragging_hue = true 
                cfg.update_color()
            end)
            
            items[ "sat" ].MouseButton1Down:Connect(function()
                dragging_sat = true  
                cfg.update_color()
            end)

            items[ "input" ].FocusLost:Connect(function()
                local text = items[ "input" ].Text
                local r, g, b, a = library:convert(text)
                
                if r and g and b and a then 
                    cfg.set(rgb(r, g, b), 1 - a)
                end 
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)
            
            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set
            library:tooltip(label and label.items.label or items[ "colorpicker" ], cfg.info)

            return setmetatable(cfg, library)
        end 

        function library:textbox(options) 
            local cfg = {
                name = library:option(options, {"name", "Name"}, "TextBox"),
                info = library:option(options, {"info", "Info", "description", "Description"}, nil),
                placeholder = library:option(options, {"placeholder", "Placeholder", "placeholdertext", "PlaceholderText", "holder", "Holder", "holdertext", "HolderText"}, "type here..."),
                default = library:option(options, {"default", "Default"}, ""),
                flag = library:option(options, {"flag", "Flag"}, nil) or library:next_flag(),
                callback = library:option(options, {"callback", "Callback"}, function() end),
                visible = library:option(options, {"visible", "Visible"}, true),
                items = {};
            }

            library:append_search_text(self, cfg.name)
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = -1;
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    Visible = cfg.visible;
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 19);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    PlaceholderColor3 = rgb(255, 255, 255);
                    CursorPosition = -1;
                    ClearTextOnFocus = false;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    TextColor3 = rgb(72, 72, 72);
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 30);
                    BackgroundColor3 = rgb(33, 33, 33)
                }); 

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });                
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4);
                    PaddingRight = dim(0, 4)
                });
            end 
            
            function cfg.set(text) 
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                library:safe_callback(cfg.callback, text)
            end 
            
            items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.set(items[ "input" ].Text) 
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)
                
            if cfg.default then 
                cfg.set(cfg.default) 
            end

            config_flags[cfg.flag] = cfg.set
            library:tooltip(items[ "textbox" ], cfg.info)

            return setmetatable(cfg, library)
        end

        function library:keybind(options) 
            local default = library:option(options, {"default", "Default"}, nil)
            local key = library:option(options, {"key", "Key"}, nil)
            local active = library:option(options, {"active", "Active"}, nil)
            local no_ui = library:option(options, {"no_ui", "NoUI"}, false)

            if key == nil and default ~= nil and type(default) ~= "boolean" then
                key = default
            end

            if active == nil and type(default) == "boolean" then
                active = default
            end

            local cfg = {
                flag = library:option(options, {"flag", "Flag"}, nil) or library:next_flag(),
                callback = library:option(options, {"callback", "Callback"}, function() end),
                name = library:option(options, {"name", "Name"}, nil), 
                info = library:option(options, {"info", "Info", "description", "Description"}, nil),
                ignore_key = library:option(options, {"ignore", "Ignore"}, false), 
                target = library:option(options, {"target", "Target", "window", "Window", "menu_window", "MenuWindow"}, nil),
                show_in_list = library:option(options, {"show_in_list", "ShowInList", "keybind_list", "KeybindList"}, not no_ui),

                key = key, 
                mode = library:option(options, {"mode", "Mode"}, "Toggle"),
                active = active or false, 

                open = false,
                binding = nil, 

                hold_instances = {},
                items = {};
            }

            library:append_search_text(self, cfg.name)
            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key, 
                active = cfg.active
            }

            if cfg.show_in_list and cfg.flag ~= "menu_bind" and cfg.flag ~= "MenuKeybind" then
                insert(library.keybinds, cfg)
                library:refresh_keybind_list()
            end

            local items = cfg.items; do 

                    items[ "keybind_element" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    items[ "keybind_holder" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "right_components" ];
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Size = dim2(0, 0, 0, 16);
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 33)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "keybind_holder" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "key" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(86, 86, 86);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "LSHIFT";
                        Parent = items[ "keybind_holder" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "key" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });                                  

                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library.items;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "inline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown" ];
                        Size = dim2(1, 0, 1, 0);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(20, 20, 20)
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "inline" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "inline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "inline" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    local options = {"Hold", "Toggle", "Always"}
                    
                    cfg.y_size = 20
                    for _, option in options do                        
                        local name = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(72, 72, 73);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Size = dim2(0, 0, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 14;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.hold_instances[option] = name
                        library:apply_theme(name, "accent", "TextColor3")
                        
                        cfg.y_size += name.AbsoluteSize.Y

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        name.MouseButton1Click:Connect(function()
                            cfg.set(option)

                            cfg.set_visible(false)

                            cfg.open = false
                        end)
                    end

            end 
            
            function cfg.modify_mode_color(path)
                for _, v in cfg.hold_instances do 
                    v.TextColor3 = rgb(72, 72, 72)
                end 

                cfg.hold_instances[path].TextColor3 = themes.preset.accent
            end

            function cfg.set_mode(mode) 
                cfg.mode = mode 

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                flags[cfg.flag]["mode"] = mode
                cfg.modify_mode_color(mode)
            end 

            function cfg.set(input)
                if type(input) == "boolean" then 
                    cfg.active = input

                    if cfg.mode == "Always" then 
                        cfg.active = true
                    end
                elseif tostring(input):find("Enum") then 
                    input = input.Name == "Escape" and "NONE" or input
                    
                    cfg.key = input or "NONE"	
                elseif find({"Toggle", "Hold", "Always"}, input) then 
                    if input == "Always" then 
                        cfg.active = true 
                    end 

                    cfg.mode = input
                    cfg.set_mode(cfg.mode) 
                elseif type(input) == "table" then 
                    input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                    cfg.key = input.key or "NONE"
                    cfg.mode = input.mode or "Toggle"

                    if input.active then
                        cfg.active = input.active
                    end

                    cfg.set_mode(cfg.mode) 
                end 

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
                
                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key, 
                    active = cfg.active
                }

                local menu_target = cfg.target
                if not menu_target and cfg.flag == "menu_bind" then
                    menu_target = library.current_window
                end

                if menu_target and menu_target.set_menu_key then
                    menu_target.set_menu_key(cfg.key)
                end

                library:refresh_keybind_list()
                library:safe_callback(cfg.callback, cfg.active)
            end

            function cfg.set_visible(bool)
                local size = bool and cfg.y_size or 0
                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
            end
        
            items[ "keybind_holder" ].MouseButton1Down:Connect(function()
                task.wait()
                items[ "key" ].Text = "..."	

                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)  
                    cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    
                    cfg.binding:Disconnect() 
                    cfg.binding = nil
                end)
            end)

            items[ "keybind_holder" ].MouseButton2Down:Connect(function()
                cfg.open = not cfg.open 

                cfg.set_visible(cfg.open)
            end)

            library:connection(uis.InputBegan, function(input, game_event) 
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == cfg.key then 
                        if cfg.mode == "Toggle" then 
                            cfg.active = not cfg.active
                            cfg.set(cfg.active)
                        elseif cfg.mode == "Hold" then 
                            cfg.set(true)
                        end
                    end
                end
            end)    

            library:connection(uis.InputEnded, function(input, game_event) 
                if game_event then 
                    return 
                end 

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
    
                if selected_key == cfg.key then
                    if cfg.mode == "Hold" then 
                        cfg.set(false)
                    end
                end
            end)
            
            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})           
            config_flags[cfg.flag] = cfg.set
            library:tooltip(items[ "keybind_element" ], cfg.info)

            return setmetatable(cfg, library)
        end

        library.Keybind = library.keybind

        function library:button(options) 
            local cfg = {
                name = library:option(options, {"name", "Name"}, "TextBox"),
                info = library:option(options, {"info", "Info", "description", "Description"}, nil),
                callback = library:option(options, {"callback", "Callback"}, function() end),
                items = {};
            }
            
            library:append_search_text(self, cfg.name)
            local items = cfg.items; do 
                items[ "button_element" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Position = dim2(1, -4, 0, 0);
                    Size = dim2(1, -8, 0, 30);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 33)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 3)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "TextColor3");                            
            end 

            items[ "button" ].MouseButton1Click:Connect(function()
                library:safe_callback(cfg.callback)

                items[ "name" ].TextColor3 = themes.preset.accent 
                library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            library:tooltip(items[ "button" ], cfg.info)
            
            return setmetatable(cfg, library)
        end 

        function library:settings(options)  
            local cfg = {
                open = false; 
                items = {}; 
                sanity = true;
            }

            local items = cfg.items; do 
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Visible = true;
                    Parent = library[ "items" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(22, 22, 22)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(20, 20, 20)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "fade" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "tick" ] = library:create( "ImageButton" , {
                    Image = "rbxassetid://128797200442698";
                    Name = "\0";
                    AutoButtonColor = false;
                    Parent = self.items[ "right_components" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 16, 0, 16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });                
            end 

            function cfg.set_visible(bool)                 
                library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
                items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X, items[ "tick" ].AbsolutePosition.Y + 90)
                library:close_element(cfg)
            end
            
            items[ "tick" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            return setmetatable(cfg, library)
        end 

        function library:list(properties) 
            local cfg = {
                items = {};
                options = library:option(properties, {"options", "Options", "items", "Items", "values", "Values"}, {"1", "2", "3"});
                flag = library:option(properties, {"flag", "Flag"}, nil) or library:next_flag();    
                callback = library:option(properties, {"callback", "Callback"}, function() end);
                data_store = {};        
                current_element;
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end 

            function cfg.refresh_options(options_to_refresh)
                for _,option in cfg.data_store do 
                    option:Destroy()
                end

                for _, option_data in options_to_refresh do
                    local button = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "list" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 33)
                    }); cfg.data_store[#cfg.data_store + 1] = button;

                    local name = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option_data;
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });     

                    button.MouseButton1Click:Connect(function()
                        local current = cfg.current_element 
                        if current and current ~= name then 
                            library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                        end

                        flags[cfg.flag] = option_data
                        library:safe_callback(cfg.callback, option_data)
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end)

                    name.MouseEnter:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                    end)

                    name.MouseLeave:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                    end)
                end
            end

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end 

        function library:init_config(window) 
            local main = window:tab({name = "UI Settings", tabs = {"Main"}, group = "Settings"})
            
            local menu_column = main:column({size = 0.5})
            local menu_section = menu_column:section({name = "Menu", size = 0.25, default = true, icon = "rbxassetid://6034767608"})
            local theme_section = menu_column:section({name = "Themes", size = 0.65, default = true, icon = "rbxassetid://6031763426"})

            local config_column = main:column({size = 0.5})
            local config_section = config_column:section({name = "Configuration", size = 1, default = true, icon = "rbxassetid://6031280882"})
            config_holder = config_section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) end, flag = "config_name_list"}); library:update_config_list()

            local function selected_config_name()
                local text_name = flags["config_name_text"]
                if type(text_name) == "string" then
                    text_name = text_name:gsub("^%s+", ""):gsub("%s+$", "")
                end

                local name = type(text_name) == "string" and text_name ~= "" and text_name or flags["config_name_list"]
                if type(name) ~= "string" or name == "" then
                    return
                end

                return name:gsub("%.cfg$", "")
            end

            local function config_path(name)
                return library.directory .. "/configs/" .. name .. ".cfg"
            end

            local function autoload_path()
                return library.directory .. "/configs/autoload.txt"
            end

            local function get_autoload_name()
                if isfile and isfile(autoload_path()) then
                    local name = readfile(autoload_path())
                    if type(name) == "string" then
                        name = name:gsub("^%s+", ""):gsub("%s+$", "")
                    end

                    if name and name ~= "" then
                        return name:gsub("%.cfg$", "")
                    end
                end
            end

            local autoload_label
            local function update_autoload_label()
                if autoload_label and autoload_label.SetText then
                    autoload_label:SetText("Current autoload config: " .. (get_autoload_name() or "none"))
                end
            end

            local custom_theme_holder
            local function custom_theme_path(name)
                return library.directory .. "/themes/" .. name .. ".json"
            end

            local function selected_theme_name()
                local text_name = flags["custom_theme_name"]
                if type(text_name) == "string" then
                    text_name = text_name:gsub("^%s+", ""):gsub("%s+$", "")
                end

                local name = type(text_name) == "string" and text_name ~= "" and text_name or flags["custom_theme_list"]
                if type(name) ~= "string" or name == "" or name == "None" then
                    return
                end

                return name:gsub("%.json$", "")
            end

            local function refresh_custom_theme_list()
                local list = {}

                if listfiles then
                    local ok, files = pcall(listfiles, library.directory .. "/themes")
                    if ok and type(files) == "table" then
                        for _, file in files do
                            local name = tostring(file):gsub("\\", "/"):match("([^/]+)%.json$")
                            if name then
                                insert(list, name)
                            end
                        end
                    end
                end

                table.sort(list, function(a, b)
                    return a:lower() < b:lower()
                end)

                return list
            end

            local function update_custom_theme_list()
                if custom_theme_holder and custom_theme_holder.refresh_options then
                    custom_theme_holder.refresh_options(refresh_custom_theme_list())
                end
            end

            menu_section:button({name = "Unload", callback = function()
                library:unload_menu()
            end})
            menu_section:keybind({name = "Menu bind", info = "Sets the key used to show or hide the UI.", flag = "menu_bind", key = window.menu_key or Enum.KeyCode.Insert, mode = "Toggle", target = window, callback = function()
                local bind = flags["menu_bind"]
                if window.set_menu_key and type(bind) == "table" then
                    window.set_menu_key(bind.key)
                end
            end, default = false})
            menu_section:toggle({name = "Open keybind menu", info = "Shows the floating keybind menu.", flag = "keybind_list_visible", default = false, callback = function(value)
                library:set_keybind_frame_visible(value)
            end})
            menu_section:toggle({name = "Watermark", info = "Shows title, FPS, and ping.", flag = "watermark_visible", default = false, callback = function(value)
                if value then
                    library:set_watermark(window.name or "Ui")
                else
                    library:set_watermark_visible(false)
                end
            end})
            local ui_scale_default = tostring(math.floor((window.ui_scale or 1) * 100 + 0.5)) .. "%"
            menu_section:dropdown({name = "UI Scale", info = "Scales the menu from 50% to 200%.", flag = "ui_scale", options = {"50%", "75%", "100%", "125%", "150%", "175%", "200%"}, default = ui_scale_default, callback = function(value)
                if window.set_ui_scale then
                    window.set_ui_scale((tonumber(tostring(value):match("%d+")) or 100) / 100)
                end
            end})

            config_section:textbox({name = "Config name", flag = "config_name_text"})
            config_section:button({name = "Create Config", callback = function()
                local name = selected_config_name()
                if not name then
                    notifications:create_notification({name = "Configs", info = "Enter or select a config name."})
                    return
                end

                writefile(config_path(name), library:get_config())
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Saved config:\n" .. name})
            end}) 
            config_section:button({name = "Load Config", callback = function()
                local name = selected_config_name()
                if not name or not isfile(config_path(name)) then
                    notifications:create_notification({name = "Configs", info = "Config not found."})
                    return
                end

                library:load_config(readfile(config_path(name)))
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Loaded config:\n" .. name})
            end})
            config_section:button({name = "Overwrite Config", callback = function()
                local name = selected_config_name()
                if not name then
                    notifications:create_notification({name = "Configs", info = "Enter or select a config name."})
                    return
                end

                writefile(config_path(name), library:get_config())
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Overwrote config:\n" .. name})
            end})
            config_section:button({name = "Refresh List", callback = function()
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Config list refreshed."})
            end})
            config_section:button({name = "Set As Autoload", callback = function()
                local name = selected_config_name()
                if not name or not isfile(config_path(name)) then
                    notifications:create_notification({name = "Configs", info = "Save or select a config first."})
                    return
                end

                writefile(autoload_path(), name)
                update_autoload_label()
                notifications:create_notification({name = "Configs", info = "Autoload config:\n" .. name})
            end})
            config_section:button({name = "Load Autoload", callback = function()
                local name = get_autoload_name()
                if not name or not isfile(config_path(name)) then
                    notifications:create_notification({name = "Configs", info = "No autoload config found."})
                    return
                end

                library:load_config(readfile(config_path(name)))
                notifications:create_notification({name = "Configs", info = "Loaded autoload:\n" .. name})
            end})
            autoload_label = config_section:label({name = "Current autoload config: none"})
            update_autoload_label()

            theme_section:dropdown({name = "Theme Preset", info = "Applies a built-in theme preset.", flag = "theme_preset", options = themes.names, default = library.current_theme or "Red", callback = function(theme_name)
                library:apply_theme_preset(theme_name)
            end})
            theme_section:colorpicker({name = "Accent Color", info = "Changes the menu accent color.", flag = "theme_accent_color", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})
            theme_section:colorpicker({name = "Background Color", info = "Changes the main window background.", flag = "theme_background_color", callback = function(color, alpha) library:update_theme("background", color) end, color = themes.preset.background})
            theme_section:colorpicker({name = "Surface Color", info = "Changes side panels and search/profile surfaces.", flag = "theme_surface_color", callback = function(color, alpha) library:update_theme("surface", color) end, color = themes.preset.surface})
            theme_section:colorpicker({name = "Card Color", info = "Changes section/card color.", flag = "theme_card_color", callback = function(color, alpha) library:update_theme("card", color) end, color = themes.preset.card})
            theme_section:colorpicker({name = "Card Inner Color", info = "Changes section inner/body color.", flag = "theme_card_inner_color", callback = function(color, alpha) library:update_theme("card_inner", color) end, color = themes.preset.card_inner})
            theme_section:colorpicker({name = "Border Color", info = "Changes outlines and divider colors.", flag = "theme_border_color", callback = function(color, alpha) library:update_theme("border", color) end, color = themes.preset.border})
            theme_section:slider({name = "Window Transparency", info = "Controls full window transparency.", flag = "window_transparency", min = 0, max = 0.55, interval = 0.01, default = themes.preset.window_transparency, callback = function(value)
                library:update_transparency("window_transparency", value)
            end})
            theme_section:slider({name = "Panel Transparency", info = "Controls search/profile/info panel transparency.", flag = "panel_transparency", min = 0, max = 0.55, interval = 0.01, default = themes.preset.panel_transparency, callback = function(value)
                library:update_transparency("panel_transparency", value)
            end})
            theme_section:slider({name = "Card Transparency", info = "Controls section/card transparency.", flag = "card_transparency", min = 0, max = 0.55, interval = 0.01, default = themes.preset.card_transparency, callback = function(value)
                library:update_transparency("card_transparency", value)
            end})
            theme_section:textbox({name = "Custom Theme Name", flag = "custom_theme_name"})
            custom_theme_holder = theme_section:dropdown({name = "Custom Themes", flag = "custom_theme_list", options = refresh_custom_theme_list(), default = nil, callback = function(theme_name) end})
            theme_section:button({name = "Save Theme", callback = function()
                local name = selected_theme_name()
                if not name then
                    notifications:create_notification({name = "Themes", info = "Enter a custom theme name."})
                    return
                end
                if not writefile then
                    notifications:create_notification({name = "Themes", info = "File saving is not available."})
                    return
                end

                writefile(custom_theme_path(name), library:get_theme_config())
                update_custom_theme_list()
                notifications:create_notification({name = "Themes", info = "Saved theme:\n" .. name})
            end})
            theme_section:button({name = "Load Theme", callback = function()
                local name = selected_theme_name()
                if not name or not isfile or not readfile or not isfile(custom_theme_path(name)) then
                    notifications:create_notification({name = "Themes", info = "Theme not found."})
                    return
                end

                library:load_theme_config(readfile(custom_theme_path(name)))
                notifications:create_notification({name = "Themes", info = "Loaded theme:\n" .. name})
            end})
            theme_section:button({name = "Refresh Theme List", callback = function()
                update_custom_theme_list()
                notifications:create_notification({name = "Themes", info = "Theme list refreshed."})
            end})
        end

        function notifications:refresh_notifs() 
            local offset = (library.watermark_frame and library.watermark_frame.Visible) and 94 or 12

            for i, v in notifications.notifs do
                if v and v.Parent then
                    local Position = vec2(12, offset)
                    library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quart, 0.18)
                    offset += (v.AbsoluteSize.Y + 6)
                else
                    notifications.notifs[i] = nil
                end
            end

            return offset
        end
        
        function notifications:fade(path, is_fading)
            local fading = is_fading and 1 or 0 
            
            library:tween(path, {BackgroundTransparency = is_fading and 1 or 0.1}, Enum.EasingStyle.Quad, 0.16)

            for _, instance in path:GetDescendants() do 
                if not instance:IsA("GuiObject") then 
                    if instance:IsA("UIStroke") then
                        library:tween(instance, {Transparency = is_fading and 1 or 0.18}, Enum.EasingStyle.Quad, 0.16)
                    end
        
                    continue
                end 
        
                if instance:IsA("TextLabel") then
                    library:tween(instance, {TextTransparency = fading}, Enum.EasingStyle.Quad, 0.16)
                elseif instance:IsA("Frame") then
                    local target = is_fading and 1 or instance.BackgroundTransparency
                    if not is_fading and target >= 1 then
                        target = 0.18
                    end

                    library:tween(instance, {BackgroundTransparency = target}, Enum.EasingStyle.Quad, 0.16)
                end
            end
        end 
        
        function notifications:create_notification(options)
            local cfg = {
                name = options.name or "This is a title!";
                info = options.info or "This is extra info!";
                lifetime = options.lifetime or 2.2;
                items = {};
                outline;
            }

            local items = cfg.items; do 
                items[ "notification" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = dim2(0, 236, 0, 52);
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    Position = dim_offset(-260, 12);
                    BackgroundColor3 = themes.preset.surface;
                    ZIndex = 190;
                }); library:apply_theme(items[ "notification" ], "surface", "BackgroundColor3")
                
                items[ "stroke" ] = library:create( "UIStroke" , {
                    Color = themes.preset.border;
                    Parent = items[ "notification" ];
                    Transparency = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }); library:apply_theme(items[ "stroke" ], "border", "Color")
                
                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "notification" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 7, 0, 6);
                    BorderSizePixel = 0;
                    Size = dim2(1, -14, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 191;
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "notification" ];
                    CornerRadius = dim(0, 3)
                });
                
                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.info;
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 9, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = true;
                    Size = dim2(1, -18, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 191;
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 17);
                    PaddingRight = dim(0, 8);
                    Parent = items[ "info" ]
                });
                
                items[ "bar" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 8, 1, -6);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 3);
                    BackgroundTransparency = 0.08;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent;
                    ZIndex = 191;
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "bar" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    PaddingRight = dim(0, 8);
                    Parent = items[ "notification" ]
                });
            end
            
            local index = #notifications.notifs + 1
            notifications.notifs[index] = items[ "notification" ]

            local offset = notifications:refresh_notifs()

            items[ "notification" ].Position = dim_offset(-260, offset)

            notifications:fade(items[ "notification" ], false)
            library:tween(items[ "notification" ], {Position = dim_offset(12, offset)}, Enum.EasingStyle.Quart, 0.2)
            library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 3)}, Enum.EasingStyle.Linear, cfg.lifetime)

            task.spawn(function()
                task.wait(cfg.lifetime)
                
                for i, notification in notifications.notifs do
                    if notification == items[ "notification" ] then
                        remove(notifications.notifs, i)
                        break
                    end
                end
                
                notifications:fade(items[ "notification" ], true)
                library:tween(items[ "notification" ], {Position = dim_offset(-260, items[ "notification" ].Position.Y.Offset)}, Enum.EasingStyle.Quart, 0.2)
                
                notifications:refresh_notifs()

                task.wait(0.22)
        
                items[ "notification" ]:Destroy() 
            end)
        end

        function library:esp_preview(properties)
            properties = properties or {}

            local cfg = {
                name = properties.name or properties.Name or "Bacon Preview",
                player = properties.player or properties.Player or "bacon_target",
                position = properties.position or properties.Position or dim2(1, -430, 0, 86),
                size = properties.size or properties.Size or dim_offset(390, 500),
                visible = properties.visible == true,
                health = properties.health or properties.Health or 76,
                flag = properties.flag or properties.Flag or "esp",
                enabled = properties.enabled ~= false and properties.Enabled ~= false,
                settings = properties.settings or properties.Settings,
                tab_visible = string.find(string.lower(library.current_tab_name or ""), "visual") ~= nil,
                part_defaults = {},
                skeleton_rods = {},
                model_rotation = properties.rotation or properties.Rotation or 0,
                rotating_model = false,
                items = {},
            }

            local items = cfg.items

            items["main"] = library:create("Frame", {
                Parent = library.items;
                Name = "\0";
                Visible = false;
                AnchorPoint = vec2(0, 0);
                Position = cfg.position;
                Size = cfg.size;
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(12, 12, 12);
            })

            library:create("UICorner", {
                Parent = items["main"];
                CornerRadius = dim(0, 8);
            })

            library:create("UIStroke", {
                Parent = items["main"];
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = rgb(52, 52, 52);
            })

            items["header"] = library:create("Frame", {
                Parent = items["main"];
                Name = "\0";
                Active = true;
                Size = dim2(1, 0, 0, 48);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(18, 18, 18);
            })

            library:create("UICorner", {
                Parent = items["header"];
                CornerRadius = dim(0, 8);
            })

            items["title"] = library:create("TextLabel", {
                Parent = items["header"];
                Name = "\0";
                Text = cfg.name;
                FontFace = fonts.font;
                TextSize = 14;
                TextColor3 = rgb(245, 245, 245);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = dim_offset(14, 0);
                Size = dim2(1, -28, 1, 0);
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            items["stage"] = library:create("Frame", {
                Parent = items["main"];
                Name = "\0";
                Position = dim_offset(16, 64);
                Size = dim2(1, -32, 0, 370);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(6, 6, 6);
            })

            library:create("UICorner", {
                Parent = items["stage"];
                CornerRadius = dim(0, 7);
            })

            library:create("UIStroke", {
                Parent = items["stage"];
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = rgb(42, 42, 42);
            })

            items["name"] = library:create("TextLabel", {
                Parent = items["stage"];
                Name = "\0";
                Text = cfg.player;
                FontFace = fonts.font;
                TextSize = 13;
                TextColor3 = themes.preset.accent;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = dim2(0.5, -100, 0, 14);
                Size = dim_offset(200, 20);
                TextXAlignment = Enum.TextXAlignment.Center;
                ZIndex = 5;
            }); library:apply_theme(items["name"], "accent", "TextColor3")

            items["distance"] = library:create("TextLabel", {
                Parent = items["stage"];
                Name = "\0";
                Text = "72m";
                FontFace = fonts.font;
                TextSize = 12;
                TextColor3 = rgb(145, 145, 145);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = dim2(0.5, -100, 1, -30);
                Size = dim_offset(200, 20);
                TextXAlignment = Enum.TextXAlignment.Center;
                ZIndex = 5;
            })

            items["box"] = library:create("Frame", {
                Parent = items["stage"];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = dim2(0.5, -95, 0, 42);
                Size = dim_offset(190, 315);
                BorderSizePixel = 0;
                ZIndex = 4;
            })

            items["box_stroke"] = library:create("UIStroke", {
                Parent = items["box"];
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = themes.preset.accent;
            }); library:apply_theme(items["box_stroke"], "accent", "Color")

            items["health_back"] = library:create("Frame", {
                Parent = items["stage"];
                Name = "\0";
                Position = dim2(0.5, -118, 0, 42);
                Size = dim_offset(6, 315);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(25, 25, 25);
                ZIndex = 4;
            })

            library:create("UICorner", {
                Parent = items["health_back"];
                CornerRadius = dim(0, 999);
            })

            items["health"] = library:create("Frame", {
                Parent = items["health_back"];
                Name = "\0";
                AnchorPoint = vec2(0, 1);
                Position = dim2(0, 0, 1, 0);
                Size = dim2(1, 0, cfg.health / 100, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = themes.preset.accent;
                ZIndex = 5;
            }); library:apply_theme(items["health"], "accent", "BackgroundColor3")

            library:create("UICorner", {
                Parent = items["health"];
                CornerRadius = dim(0, 999);
            })

            items["tracer"] = library:create("Frame", {
                Parent = items["stage"];
                Name = "\0";
                AnchorPoint = vec2(0.5, 1);
                Position = dim2(0.5, 0, 1, -1);
                Size = dim_offset(2, 76);
                BorderSizePixel = 0;
                BackgroundColor3 = themes.preset.accent;
                ZIndex = 4;
            }); library:apply_theme(items["tracer"], "accent", "BackgroundColor3")

            items["viewport"] = library:create("ViewportFrame", {
                Parent = items["stage"];
                Name = "\0";
                Active = true;
                Position = dim2(0.5, -145, 0, 28);
                Size = dim_offset(290, 342);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Ambient = rgb(255, 255, 255);
                LightColor = rgb(255, 255, 255);
                LightDirection = vec3(-0.5, -1, -0.3);
                ZIndex = 2;
            })

            items["world"] = Instance.new("WorldModel")
            items["world"].Parent = items["viewport"]

            items["camera"] = Instance.new("Camera")
            items["camera"].CFrame = CFrame.lookAt(vec3(0, 2.2, 7), vec3(0, 2.2, 0))
            items["camera"].Parent = items["viewport"]
            items["viewport"].CurrentCamera = items["camera"]

            local skeleton_segments = {
                {{"Head"}, {"NeckRigAttachment"}, {"UpperTorso", "Torso"}, {"NeckRigAttachment"}},
                {{"UpperTorso", "Torso"}, {"WaistRigAttachment"}, {"LowerTorso", "Torso"}, {"WaistRigAttachment"}},
                {{"UpperTorso", "Torso"}, {"LeftShoulderRigAttachment"}, {"LeftUpperArm", "Left Arm"}, {"LeftShoulderRigAttachment"}},
                {{"LeftUpperArm", "Left Arm"}, {"LeftElbowRigAttachment"}, {"LeftLowerArm", "Left Arm"}, {"LeftElbowRigAttachment"}},
                {{"LeftLowerArm", "Left Arm"}, {"LeftWristRigAttachment"}, {"LeftHand", "Left Arm"}, {"LeftWristRigAttachment"}},
                {{"UpperTorso", "Torso"}, {"RightShoulderRigAttachment"}, {"RightUpperArm", "Right Arm"}, {"RightShoulderRigAttachment"}},
                {{"RightUpperArm", "Right Arm"}, {"RightElbowRigAttachment"}, {"RightLowerArm", "Right Arm"}, {"RightElbowRigAttachment"}},
                {{"RightLowerArm", "Right Arm"}, {"RightWristRigAttachment"}, {"RightHand", "Right Arm"}, {"RightWristRigAttachment"}},
                {{"LowerTorso", "Torso"}, {"LeftHipRigAttachment"}, {"LeftUpperLeg", "Left Leg"}, {"LeftHipRigAttachment"}},
                {{"LeftUpperLeg", "Left Leg"}, {"LeftKneeRigAttachment"}, {"LeftLowerLeg", "Left Leg"}, {"LeftKneeRigAttachment"}},
                {{"LeftLowerLeg", "Left Leg"}, {"LeftAnkleRigAttachment"}, {"LeftFoot", "Left Leg"}, {"LeftAnkleRigAttachment"}},
                {{"LowerTorso", "Torso"}, {"RightHipRigAttachment"}, {"RightUpperLeg", "Right Leg"}, {"RightHipRigAttachment"}},
                {{"RightUpperLeg", "Right Leg"}, {"RightKneeRigAttachment"}, {"RightLowerLeg", "Right Leg"}, {"RightKneeRigAttachment"}},
                {{"RightLowerLeg", "Right Leg"}, {"RightAnkleRigAttachment"}, {"RightFoot", "Right Leg"}, {"RightAnkleRigAttachment"}},
            }

            local function get_body_part(names)
                if not items["model"] then
                    return
                end

                if type(names) ~= "table" then
                    names = {names}
                end

                for _, part_name in names do
                    local part = items["model"]:FindFirstChild(part_name, true)
                    if part and part:IsA("BasePart") then
                        return part
                    end
                end
            end

            local function get_rig_point(part_names, attachment_names)
                local part = get_body_part(part_names)
                if not part then
                    return
                end

                if attachment_names then
                    for _, attachment_name in attachment_names do
                        local attachment = part:FindFirstChild(attachment_name)
                        if attachment and attachment:IsA("Attachment") then
                            return attachment.WorldPosition
                        end
                    end
                end

                return part.Position
            end

            local function get_skeleton_line(index)
                if cfg.skeleton_rods[index] then
                    return cfg.skeleton_rods[index]
                end

                local outline = library:create("Frame", {
                    Parent = items["stage"];
                    Name = "\0";
                    AnchorPoint = vec2(0.5, 0.5);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0);
                    Visible = false;
                    ZIndex = 29;
                })

                local line = library:create("Frame", {
                    Parent = items["stage"];
                    Name = "\0";
                    AnchorPoint = vec2(0.5, 0.5);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent;
                    Visible = false;
                    ZIndex = 30;
                })

                cfg.skeleton_rods[index] = {
                    outline = outline,
                    line = line,
                }

                return cfg.skeleton_rods[index]
            end

            local function get_head_dot()
                if cfg.head_dot then
                    return cfg.head_dot
                end

                local outline = library:create("Frame", {
                    Parent = items["stage"];
                    Name = "\0";
                    AnchorPoint = vec2(0.5, 0.5);
                    Size = dim_offset(11, 11);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0);
                    Visible = false;
                    ZIndex = 31;
                })

                library:create("UICorner", {
                    Parent = outline;
                    CornerRadius = dim(0, 999);
                })

                local dot = library:create("Frame", {
                    Parent = items["stage"];
                    Name = "\0";
                    AnchorPoint = vec2(0.5, 0.5);
                    Size = dim_offset(7, 7);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent;
                    Visible = false;
                    ZIndex = 32;
                })

                library:create("UICorner", {
                    Parent = dot;
                    CornerRadius = dim(0, 999);
                })

                cfg.head_dot_stroke = library:create("UIStroke", {
                    Parent = dot;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = themes.preset.accent;
                    Thickness = 2;
                    Enabled = false;
                })

                cfg.head_dot_outline = outline
                cfg.head_dot = dot
                return dot
            end

            local function project_target(target)
                if not target then
                    return nil, false
                end

                local viewport_size = items["viewport"].AbsoluteSize
                if viewport_size.X <= 0 or viewport_size.Y <= 0 then
                    return nil, false
                end

                local position = typeof(target) == "Vector3" and target or target.Position
                local object_space = items["camera"].CFrame:PointToObjectSpace(position)
                local depth = -object_space.Z
                if depth <= 0 then
                    return nil, false
                end

                local fov = rad(items["camera"].FieldOfView)
                local focal = viewport_size.Y / (2 * math.tan(fov / 2))
                local x = viewport_size.X / 2 + (object_space.X / depth) * focal
                local y = viewport_size.Y / 2 - (object_space.Y / depth) * focal

                if x < -20 or x > viewport_size.X + 20 or y < -20 or y > viewport_size.Y + 20 then
                    return nil, false
                end

                return vec2(x, y), true
            end

            local function project_part(part)
                return project_target(part)
            end

            local function viewport_to_stage(point)
                local offset = items["viewport"].AbsolutePosition - items["stage"].AbsolutePosition
                return point + vec2(offset.X, offset.Y)
            end

            local function update_head_dot(accent, visible, style)
                local dot = get_head_dot()
                local outline = cfg.head_dot_outline
                local stroke = cfg.head_dot_stroke
                local head = get_body_part({"Head"})
                local point, on_screen = project_part(head)
                local radius = clamp(style.size or 3, 1, 30)
                local diameter = radius * 2
                local outline_thickness = clamp(style.outline_thickness or 2, 1, 12)
                local filled = style.filled ~= false

                if visible and point and on_screen then
                    point = viewport_to_stage(point)
                    if outline then
                        outline.Size = dim_offset(diameter + (outline_thickness * 2), diameter + (outline_thickness * 2))
                        outline.BackgroundColor3 = style.outline_color or rgb(0, 0, 0)
                        outline.Position = dim_offset(point.X, point.Y)
                        outline.Visible = style.outline == true and filled
                    end

                    if stroke then
                        stroke.Color = accent
                        stroke.Thickness = outline_thickness
                        stroke.Enabled = not filled
                    end

                    dot.BackgroundColor3 = accent
                    dot.BackgroundTransparency = filled and 0 or 1
                    dot.Position = dim_offset(point.X, point.Y)
                    dot.Size = dim_offset(diameter, diameter)
                    dot.Visible = true
                else
                    if outline then
                        outline.Visible = false
                    end
                    if stroke then
                        stroke.Enabled = false
                    end
                    dot.Visible = false
                end
            end

            local function set_preview_line(rod, from_point, to_point, accent, thickness, outline_enabled, outline_color, outline_thickness)
                local line = rod.line
                local outline = rod.outline

                if not from_point or not to_point then
                    if outline then
                        outline.Visible = false
                    end
                    line.Visible = false
                    return
                end

                local delta = to_point - from_point
                local length = delta.Magnitude
                if length <= 2 then
                    if outline then
                        outline.Visible = false
                    end
                    line.Visible = false
                    return
                end

                thickness = clamp(thickness or 1, 1, 12)
                outline_thickness = clamp(outline_thickness or 2, 1, 12)
                local rotation = math.deg(math.atan(delta.Y, delta.X))

                if outline then
                    outline.BackgroundColor3 = outline_color or rgb(0, 0, 0)
                    outline.Position = dim_offset((from_point.X + to_point.X) / 2, (from_point.Y + to_point.Y) / 2)
                    outline.Size = dim_offset(length, thickness + (outline_thickness * 2))
                    outline.Rotation = rotation
                    outline.Visible = outline_enabled == true
                end

                line.BackgroundColor3 = accent
                line.Position = dim_offset((from_point.X + to_point.X) / 2, (from_point.Y + to_point.Y) / 2)
                line.Size = dim_offset(length, thickness)
                line.Rotation = rotation
                line.Visible = true
            end

            local function update_skeleton(accent, visible, style)
                for index, segment in skeleton_segments do
                    local rod = get_skeleton_line(index)
                    local from_point, from_visible = project_target(get_rig_point(segment[1], segment[2]))
                    local to_point, to_visible = project_target(get_rig_point(segment[3], segment[4]))
                    local thickness = clamp(style.thickness or 2, 1, 12)
                    local outline_thickness = clamp(style.outline_thickness or 2, 1, 12)

                    if visible and from_point and to_point and from_visible and to_visible then
                        from_point = viewport_to_stage(from_point)
                        to_point = viewport_to_stage(to_point)
                        set_preview_line(rod, from_point, to_point, accent, thickness, style.outline, style.outline_color, outline_thickness)
                    else
                        set_preview_line(rod, nil, nil, accent, thickness, false, style.outline_color, outline_thickness)
                    end
                end
            end

            local function update_snapline(accent, visible, style)
                local rod = get_skeleton_line(120)
                if not visible then
                    set_preview_line(rod, nil, nil, accent, style.thickness, false, style.outline_color, style.outline_thickness)
                    return
                end

                local from
                local stage_size = items["stage"].AbsoluteSize
                if style.mode == "Top" then
                    from = vec2(stage_size.X / 2, 0)
                elseif style.mode == "Center" then
                    from = vec2(stage_size.X / 2, stage_size.Y / 2)
                else
                    from = vec2(stage_size.X / 2, stage_size.Y)
                end

                local target, target_visible = project_target(get_rig_point({"LowerTorso", "Torso", "HumanoidRootPart"}))
                if target and target_visible then
                    target = viewport_to_stage(target)
                end

                set_preview_line(rod, from, target, accent, style.thickness, style.outline, style.outline_color, style.outline_thickness)
            end

            local function update_look_direction(accent, visible, style)
                local main = get_skeleton_line(101)
                local arrow_a = get_skeleton_line(102)
                local arrow_b = get_skeleton_line(103)
                local head = get_body_part({"Head"})

                if not visible or not head then
                    set_preview_line(main, nil, nil, accent, style.thickness, false, style.outline_color, style.outline_thickness)
                    set_preview_line(arrow_a, nil, nil, accent, style.thickness, false, style.outline_color, style.outline_thickness)
                    set_preview_line(arrow_b, nil, nil, accent, style.thickness, false, style.outline_color, style.outline_thickness)
                    return
                end

                local from, from_visible = project_target(head.Position)
                local to, to_visible = project_target(head.Position + head.CFrame.LookVector * (style.length or 5))
                if from and to and from_visible and to_visible then
                    from = viewport_to_stage(from)
                    to = viewport_to_stage(to)
                    set_preview_line(main, from, to, accent, style.thickness, style.outline, style.outline_color, style.outline_thickness)

                    local direction = to - from
                    if direction.Magnitude > 0 then
                        direction = direction.Unit
                        local normal = vec2(-direction.Y, direction.X)
                        local arrow_length = 18
                        local arrow_width = 8
                        set_preview_line(arrow_a, to, to - direction * arrow_length + normal * arrow_width, accent, style.thickness, style.outline, style.outline_color, style.outline_thickness)
                        set_preview_line(arrow_b, to, to - direction * arrow_length - normal * arrow_width, accent, style.thickness, style.outline, style.outline_color, style.outline_thickness)
                    end
                else
                    set_preview_line(main, nil, nil, accent, style.thickness, false, style.outline_color, style.outline_thickness)
                    set_preview_line(arrow_a, nil, nil, accent, style.thickness, false, style.outline_color, style.outline_thickness)
                    set_preview_line(arrow_b, nil, nil, accent, style.thickness, false, style.outline_color, style.outline_thickness)
                end
            end

            local function clean_model(model)
                for _, object in model:GetDescendants() do
                    if object:IsA("Script") or object:IsA("LocalScript") then
                        object:Destroy()
                    elseif object:IsA("BasePart") then
                        cfg.part_defaults[object] = {
                            Color = object.Color,
                            Material = object.Material,
                            Transparency = object.Transparency,
                        }

                        object.Anchored = true
                        object.CanCollide = false
                        object.CastShadow = false
                    end
                end
            end

            local function place_model(model)
                if items["model"] then
                    items["model"]:Destroy()
                end

                items["model"] = model
                items["model"].Parent = items["world"]
                cfg.part_defaults = {}
                clean_model(items["model"])

                items["model"]:PivotTo(cfr(0, 0, 0) * angle(0, rad(180), 0))

                local box_cframe, box_size = items["model"]:GetBoundingBox()
                local model_center = box_cframe.Position
                local target_center = vec3(0, 2.35, 0)
                items["model"]:PivotTo(cfr(target_center - model_center) * items["model"]:GetPivot())
                cfg.model_base_cframe = items["model"]:GetPivot()
                cfg.model_rotation = cfg.model_rotation or 0

                local camera_distance = math.max(4.35, box_size.Y * 1.08, box_size.X * 1.55)
                local look_y = target_center.Y
                items["camera"].CFrame = CFrame.lookAt(vec3(0, look_y, camera_distance), vec3(0, look_y, 0))

                local humanoid = items["model"]:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                end
            end

            local function load_character_model()
                local requested_user_id = properties.user_id or properties.UserId or (lp and lp.UserId)
                local model

                if requested_user_id then
                    local direct_ok, direct_model = pcall(function()
                        return players:CreateHumanoidModelFromUserId(requested_user_id)
                    end)

                    if direct_ok and direct_model then
                        model = direct_model
                    end
                end

                if not model and requested_user_id then
                    local ok, description = pcall(function()
                        return players:GetHumanoidDescriptionFromUserId(requested_user_id)
                    end)

                    if ok and description then
                        local made_ok, made_model = pcall(function()
                            return players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
                        end)

                        if made_ok and made_model then
                            model = made_model
                        end
                    end
                end

                if not model and lp and lp.Character then
                    local clone_ok, clone = pcall(function()
                        local old_archivable = lp.Character.Archivable
                        lp.Character.Archivable = true
                        local character_clone = lp.Character:Clone()
                        lp.Character.Archivable = old_archivable

                        return character_clone
                    end)

                    if clone_ok and clone then
                        model = clone
                    end
                end

                if not model then
                    local fallback_ok, fallback = pcall(function()
                        return players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
                    end)

                    if fallback_ok then
                        model = fallback
                    end
                end

                if model then
                    place_model(model)
                end
            end

            load_character_model()

            items["footer"] = library:create("TextLabel", {
                Parent = items["main"];
                Name = "\0";
                Text = "ESP disabled";
                FontFace = fonts.font;
                TextSize = 13;
                TextColor3 = rgb(145, 145, 145);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = dim_offset(16, 448);
                Size = dim2(1, -28, 0, 18);
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            local function apply_model_rotation()
                if items["model"] and cfg.model_base_cframe then
                    items["model"]:PivotTo(cfg.model_base_cframe * angle(0, cfg.model_rotation, 0))
                end
            end

            items["viewport"].InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    cfg.rotating_model = true
                    cfg.rotate_start = input.Position.X
                    cfg.rotate_origin = cfg.model_rotation
                end
            end)

            library:connection(uis.InputChanged, function(input)
                if cfg.rotating_model and input.UserInputType == Enum.UserInputType.MouseMovement then
                    cfg.model_rotation = cfg.rotate_origin + ((input.Position.X - cfg.rotate_start) * 0.012)
                    apply_model_rotation()
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    cfg.rotating_model = false
                end
            end)

            local function drag_panel(handle, target)
                local dragging = false
                local start_position
                local start_input

                handle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if target.Position.X.Scale ~= 0 or target.Position.Y.Scale ~= 0 then
                            target.Position = dim2(0, target.AbsolutePosition.X, 0, target.AbsolutePosition.Y)
                        end

                        dragging = true
                        start_position = target.Position
                        start_input = input.Position
                    end
                end)

                handle.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                library:connection(uis.InputChanged, function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local viewport_x = camera.ViewportSize.X
                        local viewport_y = camera.ViewportSize.Y

                        target.Position = dim2(
                            0,
                            clamp(start_position.X.Offset + (input.Position.X - start_input.X), 0, viewport_x - target.Size.X.Offset),
                            0,
                            clamp(start_position.Y.Offset + (input.Position.Y - start_input.Y), 0, viewport_y - target.Size.Y.Offset)
                        )
                    end
                end)
            end

            drag_panel(items["header"], items["main"])

            function cfg.flag_enabled()
                local lower_flag = string.lower(cfg.flag)
                local upper_flag = string.upper(cfg.flag)
                return flags[cfg.flag] == true or flags[lower_flag] == true or flags[upper_flag] == true
            end

            function cfg.refresh_visible()
                items["main"].Visible = cfg.enabled and cfg.tab_visible and cfg.flag_enabled()
            end

            function cfg.set_visible(bool)
                cfg.enabled = bool
                cfg.refresh_visible()
            end

            function cfg.set_tab_visible(bool)
                cfg.tab_visible = bool
                cfg.refresh_visible()
            end

            cfg.refresh_visible()

            function cfg.update()
                local settings = cfg.settings
                local function pick_setting(name, fallback)
                    if settings and settings[name] ~= nil then
                        return settings[name]
                    end

                    return fallback
                end

                local function pick_color(name, fallback)
                    local value = settings and settings[name]

                    if typeof(value) == "Color3" then
                        return value
                    end

                    return fallback
                end

                local esp = cfg.flag_enabled()
                local box = esp and pick_setting("BoxEnabled", flags["box"] ~= false or flags["esp_box"] == true)
                local name = esp and pick_setting("NameEnabled", flags["name"] ~= false or flags["esp_name"] == true)
                local health = esp and pick_setting("HealthBarEnabled", flags["health_bar"] ~= false or flags["healthbar"] ~= false or flags["esp_health"] == true)
                local distance = esp and pick_setting("DistanceEnabled", flags["distance"] == true or flags["esp_distance"] == true)
                local tracer = esp and pick_setting("SnaplineEnabled", flags["tracers"] == true or flags["tracer"] == true or flags["esp_snaplines"] == true)
                local skeleton = esp and pick_setting("SkeletonEnabled", flags["skeleton"] == true or flags["esp_skeleton"] == true)
                local head_dot = esp and pick_setting("HeadDotEnabled", flags["head_dot"] == true or flags["headdot"] == true or flags["esp_head_dot"] == true)
                local look_direction = esp and pick_setting("LookDirectionEnabled", flags["look_direction"] == true or flags["esp_look_direction"] == true)
                local chams = esp and pick_setting("HighlightEnabled", flags["enemy_chams"] == true or flags["chams"] == true or flags["esp_highlight"] == true)
                local accent = themes.preset.accent
                local color_flag = flags["enemy_color"]

                if typeof(color_flag) == "Color3" then
                    accent = color_flag
                elseif type(color_flag) == "table" and typeof(color_flag.Color) == "Color3" then
                    accent = color_flag.Color
                end

                local box_color = pick_color("BoxColor", accent)
                local name_color = pick_color("NameColor", accent)
                local health_color = pick_color("HealthColor", accent)
                local distance_color = pick_color("DistanceColor", accent)
                local tracer_color = pick_color("SnaplineColor", accent)
                local skeleton_color = pick_color("SkeletonColor", accent)
                local head_dot_color = pick_color("HeadDotColor", accent)
                local look_direction_color = pick_color("LookDirectionColor", accent)
                local chams_color = pick_color("HighlightFillColor", accent)
                local box_thickness = clamp(pick_setting("BoxThickness", 1), 1, 12)
                local skeleton_style = {
                    thickness = pick_setting("SkeletonThickness", 2),
                    outline = pick_setting("SkeletonOutlineEnabled", true),
                    outline_color = pick_color("SkeletonOutlineColor", rgb(0, 0, 0)),
                    outline_thickness = pick_setting("OutlineThickness", 2),
                }
                local snapline_style = {
                    mode = pick_setting("SnaplineMode", "Bottom"),
                    thickness = pick_setting("SnaplineThickness", 1),
                    outline = pick_setting("SnaplineOutlineEnabled", true),
                    outline_color = pick_color("SnaplineOutlineColor", rgb(0, 0, 0)),
                    outline_thickness = pick_setting("OutlineThickness", 2),
                }
                local look_direction_style = {
                    length = pick_setting("LookDirectionLength", 5),
                    thickness = pick_setting("LookDirectionThickness", 1),
                    outline = pick_setting("LookDirectionOutlineEnabled", true),
                    outline_color = pick_color("LookDirectionOutlineColor", rgb(0, 0, 0)),
                    outline_thickness = pick_setting("OutlineThickness", 2),
                }
                local head_dot_style = {
                    size = pick_setting("HeadDotSize", 3),
                    filled = pick_setting("HeadDotFilled", true),
                    outline = pick_setting("HeadDotOutlineEnabled", true),
                    outline_color = pick_color("HeadDotOutlineColor", rgb(0, 0, 0)),
                    outline_thickness = pick_setting("OutlineThickness", 2),
                }

                items["box"].Visible = box
                items["name"].Visible = name
                items["health_back"].Visible = health
                items["distance"].Visible = distance
                items["tracer"].Visible = false
                items["footer"].Text = esp and "ESP preview active" or "ESP disabled"

                items["box_stroke"].Color = box_color
                items["box_stroke"].Thickness = box_thickness
                items["health"].BackgroundColor3 = health_color
                items["tracer"].BackgroundColor3 = tracer_color
                items["name"].TextColor3 = name_color
                items["distance"].TextColor3 = distance_color

                if items["model"] then
                    if cfg.model_base_cframe then
                        apply_model_rotation()
                    end

                    for _, object in items["model"]:GetDescendants() do
                        if object:IsA("BasePart") then
                            if chams then
                                object.Color = chams_color
                                object.Material = Enum.Material.ForceField
                                object.Transparency = 0.08
                            else
                                local defaults = cfg.part_defaults[object]
                                if defaults then
                                    object.Color = defaults.Color
                                    object.Material = defaults.Material
                                    object.Transparency = defaults.Transparency
                                else
                                    object.Material = Enum.Material.Plastic
                                    object.Transparency = 0
                                end
                            end
                        end
                    end
                end

                update_skeleton(skeleton_color, skeleton, skeleton_style)
                update_head_dot(head_dot_color, head_dot, head_dot_style)
                update_snapline(tracer_color, tracer, snapline_style)
                update_look_direction(look_direction_color, look_direction, look_direction_style)
            end

            library:connection(run.RenderStepped, function()
                cfg.refresh_visible()

                if items["main"].Visible then
                    cfg.update()
                end
            end)

            cfg.update()
            library.esp_preview_window = cfg
            return setmetatable(cfg, library)
        end

library.Window = library.window
library.Tab = library.tab
library.Seperator = library.seperator
library.Separator = library.seperator
library.Column = library.column
library.SubTab = library.sub_tab
library.Section = library.section
library.Toggle = library.toggle
library.Slider = library.slider
library.Dropdown = library.dropdown
library.Label = library.label
library.Colorpicker = library.colorpicker
library.ColorPicker = library.colorpicker
library.Textbox = library.textbox
library.TextBox = library.textbox
library.Keybind = library.keybind
library.KeyBind = library.keybind
library.Button = library.button
library.Settings = library.settings
library.List = library.list
library.InitConfig = library.init_config
library.ApplyThemePreset = library.apply_theme_preset
library.GetThemePreset = library.get_theme_preset
library.UpdateTheme = library.update_theme
library.UpdateTransparency = library.update_transparency
library.UpdateCardTransparency = library.update_card_transparency
library.GetThemeConfig = library.get_theme_config
library.LoadThemeConfig = library.load_theme_config
library.SetSearch = library.set_search
library.SetKeybindFrameVisibility = library.set_keybind_frame_visible
library.ShowKeybinds = library.set_keybind_frame_visible
library.RefreshKeybindList = library.refresh_keybind_list
library.SetWatermark = library.set_watermark
library.SetWatermarkVisibility = library.set_watermark_visible
library.EspPreview = library.esp_preview
library.ESPPreview = library.esp_preview

return library
