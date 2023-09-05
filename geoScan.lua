local tArgs = { ... }

local radius = 16

local block = tArgs[1]

local defualt = true
local autoScan = false
local mineMode = false

if not block or tArgs[1] == "help" or tArgs[1] == "h" or tArgs[1] == "-h" then
    print(
        "Usage: geoScan <block(s)> [auto|mine]\n auto: Automatically scan every second\n mine: Show the best vein to mine and where\n defualt: Show all matching blocks in radius\n You can use multiple blocks by seperating them with a comma\n Example: geoScan iron,diamond auto")
    return
end

if tArgs[2] == "auto" then
    autoScan = true
    defualt = false
elseif tArgs[2] == "mine" then
    mineMode = true
    defualt = false
end

local searchBlocks = {}

if block:find(",") then
    searchBlocks = {}
    for b in block:gmatch("([^,]+)") do
        table.insert(searchBlocks, b)
    end
end

function DistanceBetween(block1, block2)
    local dx = block1.x - block2.x
    local dy = block1.y - block2.y
    local dz = block1.z - block2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function DetectVains(blocks)
    local vains = {}
    local checked = {}

    local function BFS(block)
        local queue = { block }
        local vein = {}
        local visited = { [block] = true }

        while #queue > 0 do
            local current_block = table.remove(queue, 1)
            table.insert(vein, current_block)

            for _, other_block in ipairs(blocks) do
                if not checked[other_block] and not visited[other_block] and DistanceBetween(current_block, other_block) <= 2 then
                    visited[other_block] = true
                    table.insert(queue, other_block)
                end
            end
        end

        for _, v in ipairs(vein) do
            checked[v] = true
        end

        return vein
    end

    for _, block_data in ipairs(blocks) do
        if not checked[block_data] then
            local vein = BFS(block_data)
            if #vein > 1 then
                local veinInfo = {
                    position = vein[1], -- Starting position of the vein
                    size = #vein,
                    name = block_data.name
                }
                table.insert(vains, veinInfo)
            end
        end
    end

    return vains
end

local geoscanner = peripheral.wrap("back")

if not geoscanner then
    print("No geoscanner found!")
    return
end

while true do
    local scan = geoscanner.scan(radius)

    if scan then
        local count = 0
        -- Store the blocks in a table
        local blocks = {}

        for i, block_data in ipairs(scan) do
            if searchBlocks then
                for _, b in ipairs(searchBlocks) do
                    if block_data.name:find(b) then
                        table.insert(blocks, block_data)
                        count = count + 1
                    end
                end
            else
                if block_data.name:find(block) then
                    -- Get only part of the name after the colon
                    -- print(block_data.name:match(":(.+)"), block_data.x, block_data.y, block_data.z)
                    -- Store the block in the table
                    table.insert(blocks, block_data)
                    count = count + 1
                end
            end
        end

        if autoScan or defualt then
            -- Sort the table by the distance from the block calculat using pythagoras theorem
            table.sort(blocks, function(a, b)
                return math.sqrt(a.x ^ 2 + a.y ^ 2 + a.z ^ 2) > math.sqrt(b.x ^ 2 + b.y ^ 2 + b.z ^ 2)
            end)

            for i, block_data in ipairs(blocks) do
                print(block_data.name:match(":(.+)"), "\n", "X:", block_data.x, "Y:", block_data.y, "Z:", block_data.z)
            end

            if count == 0 then
                print("No " .. block .. " found!")
            else
                print(count .. " " .. block .. " found!")
            end
        elseif mineMode then
            local vains = DetectVains(blocks)

            -- for i, vein in ipairs(vains) do
            --     print("Vein of " ..
            --         block ..
            --         " found at X:" ..
            --         vein.position.x .. " Y:" .. vein.position.y .. " Z:" .. vein.position.z .. " Size: " .. vein.size)
            -- end

            -- Find best vain by size divdided by distance
            local bestVein = {
                position = { x = 999, y = 999, z = 999 },
                size = 0
            }

            local score = 0

            for i, vein in ipairs(vains) do
                local distance = math.sqrt(vein.position.x ^ 2 + vein.position.y ^ 2 + vein.position.z ^ 2)
                score = vein.size / distance
                if score > bestVein.size / math.sqrt(bestVein.position.x ^ 2 + bestVein.position.y ^ 2 + bestVein.position.z ^ 2) then
                    bestVein = vein
                end
            end

            if bestVein.size == 0 then
                print("No vein for " .. bestVein.name:match(":(.+)") .. " found in search radius " .. radius .. "!")
            else
                print("Best vein of " ..
                    bestVein.name:match(":(.+)") ..
                    " found at X:" ..
                    bestVein.position.x ..
                    " Y:" .. bestVein.position.y .. " Z:" .. bestVein.position.z .. " Size: " .. bestVein.size)
            end
        end
    end

    if autoScan or mineMode then
        sleep(1)
    else
        break
    end
end
