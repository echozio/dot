local function key_of(target)
    local window = target.window
    return window and tostring(window.stable_id) or ("target:" .. target.index)
end

local function halve(box)
    if box.w > box.h then
        local w = box.w / 2
        return { x = box.x, y = box.y, w = w, h = box.h }, { x = box.x + w, y = box.y, w = w, h = box.h }
    end
    local h = box.h / 2
    return { x = box.x, y = box.y, w = box.w, h = h }, { x = box.x, y = box.y + h, w = box.w, h = h }
end

local function slotted(classes, slots)
    local rank = {}
    for i, class in ipairs(classes) do
        rank[class] = i
    end

    local parent = {}
    local slot = {}
    local opened = {}

    return {
        recalculate = function(ctx)
            local targets, listed, focus = {}, {}, {}
            for _, target in ipairs(ctx.targets) do
                local key = key_of(target)
                local window = target.window
                targets[key] = target
                listed[key] = window and rank[window.class]
                focus[key] = window and window.focus_history_id or -1
            end

            local seen = {}
            local previous = nil
            for _, key in ipairs(opened) do
                seen[key] = true
                if targets[key] and focus[key] >= 0 and (not previous or focus[key] < focus[previous]) then
                    previous = key
                end
            end

            local kept = {}
            for _, key in ipairs(opened) do
                if targets[key] and not listed[key] then
                    local above, lost = parent[key], nil
                    while above and not targets[above] do
                        lost, above = above, parent[above]
                    end
                    parent[key] = above
                    if not above and lost then
                        slot[key] = slot[lost]
                    end
                    table.insert(kept, key)
                end
            end
            for _, target in ipairs(ctx.targets) do
                local key = key_of(target)
                if not listed[key] and not seen[key] then
                    parent[key] = previous
                    table.insert(kept, key)
                end
            end

            local roots = {}
            for _, target in ipairs(ctx.targets) do
                local key = key_of(target)
                if listed[key] then
                    slot[key] = listed[key]
                    table.insert(roots, key)
                end
            end
            for _, key in ipairs(kept) do
                if not parent[key] then
                    table.insert(roots, key)
                end
            end
            table.sort(roots, function(a, b)
                local sa, sb = slot[a] or math.huge, slot[b] or math.huge
                if sa ~= sb then
                    return sa < sb
                end
                if (listed[a] ~= nil) ~= (listed[b] ~= nil) then
                    return listed[a] ~= nil
                end
                return targets[a].index < targets[b].index
            end)

            for key in pairs(parent) do
                if not targets[key] then
                    parent[key] = nil
                end
            end
            for key in pairs(slot) do
                if not targets[key] then
                    slot[key] = nil
                end
            end

            opened = {}
            for _, target in ipairs(ctx.targets) do
                local key = key_of(target)
                if listed[key] then
                    table.insert(opened, key)
                end
            end
            for _, key in ipairs(kept) do
                table.insert(opened, key)
            end

            local function place(key, box)
                for _, child in ipairs(kept) do
                    if parent[child] == key then
                        local rest
                        box, rest = halve(box)
                        place(child, rest)
                    end
                end
                targets[key]:place(box)
            end

            for i, box in ipairs(slots(ctx, #roots)) do
                place(roots[i], box)
            end
        end,
    }
end

local function columns(ctx, n)
    local boxes = {}
    for i = 1, n do
        boxes[i] = ctx:column(i, n)
    end
    return boxes
end

local function half_and_columns(ctx, n)
    if n <= 1 then
        return { ctx.area }
    end

    local rest = ctx:split(ctx.area, "right", 0.5)
    local boxes = { ctx:split(ctx.area, "left", 0.5) }
    for i = 2, n do
        boxes[i] = {
            x = rest.x + rest.w * (i - 2) / (n - 1),
            y = rest.y,
            w = rest.w / (n - 1),
            h = rest.h,
        }
    end
    return boxes
end

hl.layout.register("inbox", slotted({ "aerc", "nom", "glirc" }, half_and_columns))
hl.layout.register("comms", slotted({ "spotify", "com.slack.Slack", "discord", "signal" }, columns))
