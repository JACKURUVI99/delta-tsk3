-- Simple Chat Server in Lua
-- For beginners - handles multiple clients with basic threading

local socket = require("socket")
local json = require("json") -- We'll implement a simple JSON-like parser

-- Server configuration
local HOST = "localhost"
local PORT = 8888

-- Global variables (simple approach for beginners)
local clients = {}  -- List of connected clients
local rooms = {}    -- Chat rooms data
local users = {}    -- User authentication data
local user_stats = {} -- User statistics for leaderboard

-- Simple file operations for data persistence
local function save_to_file(filename, data)
    local file = io.open(filename, "w")
    if file then
        file:write(data)
        file:close()
        return true
    end
    return false
end

local function load_from_file(filename)
    local file = io.open(filename, "r")
    if file then
        local data = file:read("*all")
        file:close()
        return data
    end
    return nil
end

-- Simple hash function (since we can't use complex libraries)
local function simple_hash(password)
    local hash = 0
    for i = 1, #password do
        hash = hash + string.byte(password, i) * i
    end
    return tostring(hash)
end

-- Initialize server data
local function init_server()
    -- Create default room
    rooms["general"] = {
        name = "general",
        users = {},
        messages = {},
        is_private = false,
        message_count = 0
    }
    
    -- Load existing users if any
    local user_data = load_from_file("users.txt")
    if user_data then
        for line in user_data:gmatch("[^\r\n]+") do
            local username, password_hash = line:match("([^:]+):([^:]+)")
            if username and password_hash then
                users[username] = password_hash
                user_stats[username] = {messages = 0, login_time = 0}
            end
        end
    end
    
    print("Chat server initialized!")
    print("Default room 'general' created")
end

-- Save user data to file
local function save_users()
    local data = ""
    for username, password_hash in pairs(users) do
        data = data .. username .. ":" .. password_hash .. "\n"
    end
    save_to_file("users.txt", data)
end

-- Broadcast message to all users in a room
local function broadcast_to_room(room_name, message, sender)
    if not rooms[room_name] then return end
    
    local full_message = "[" .. room_name .. "] " .. (sender or "Server") .. ": " .. message .. "\n"
    
    for _, client_info in pairs(clients) do
        if client_info.room == room_name and client_info.socket then
            client_info.socket:send(full_message)
        end
    end
    
    -- Save message to room history
    table.insert(rooms[room_name].messages, {
        sender = sender or "Server",
        message = message,
        timestamp = os.time()
    })
    
    -- Update statistics
    if sender and user_stats[sender] then
        user_stats[sender].messages = user_stats[sender].messages + 1
    end
    
    rooms[room_name].message_count = rooms[room_name].message_count + 1
end

-- Handle user registration
local function register_user(client_socket, username, password)
    if users[username] then
        client_socket:send("ERROR: Username already exists!\n")
        return false
    end
    
    users[username] = simple_hash(password)
    user_stats[username] = {messages = 0, login_time = os.time()}
    save_users()
    
    client_socket:send("SUCCESS: Account created! You can now login.\n")
    return true
end

-- Handle user login
local function login_user(client_socket, username, password)
    if not users[username] then
        client_socket:send("ERROR: Username not found!\n")
        return false
    end
    
    if users[username] ~= simple_hash(password) then
        client_socket:send("ERROR: Wrong password!\n")
        return false
    end
    
    client_socket:send("SUCCESS: Logged in successfully!\n")
    return true
end

-- Handle client commands
local function handle_command(client_info, command)
    local cmd_parts = {}
    for word in command:gmatch("%S+") do
        table.insert(cmd_parts, word)
    end
    
    local cmd = cmd_parts[1]
    
    if cmd == "/join" and cmd_parts[2] then
        local room_name = cmd_parts[2]
        
        -- Remove from current room
        if client_info.room and rooms[client_info.room] then
            for i, user in ipairs(rooms[client_info.room].users) do
                if user == client_info.username then
                    table.remove(rooms[client_info.room].users, i)
                    break
                end
            end
        end
        
        -- Create room if it doesn't exist
        if not rooms[room_name] then
            rooms[room_name] = {
                name = room_name,
                users = {},
                messages = {},
                is_private = false,
                message_count = 0
            }
        end
        
        -- Join new room
        client_info.room = room_name
        table.insert(rooms[room_name].users, client_info.username)
        
        client_info.socket:send("Joined room: " .. room_name .. "\n")
        broadcast_to_room(room_name, client_info.username .. " joined the room")
        
    elseif cmd == "/users" then
        if client_info.room and rooms[client_info.room] then
            local user_list = "Users in " .. client_info.room .. ": "
            for _, user in ipairs(rooms[client_info.room].users) do
                user_list = user_list .. user .. " "
            end
            client_info.socket:send(user_list .. "\n")
        end
        
    elseif cmd == "/stats" then
        if client_info.room and rooms[client_info.room] then
            local stats = "Room Stats - Users: " .. #rooms[client_info.room].users .. 
                         ", Messages: " .. rooms[client_info.room].message_count .. "\n"
            client_info.socket:send(stats)
        end
        
    elseif cmd == "/leaderboard" then
        local leaderboard = "=== LEADERBOARD ===\n"
        local sorted_users = {}
        
        for username, stats in pairs(user_stats) do
            table.insert(sorted_users, {username = username, messages = stats.messages})
        end
        
        table.sort(sorted_users, function(a, b) return a.messages > b.messages end)
        
        for i, user in ipairs(sorted_users) do
            if i <= 10 then -- Top 10
                leaderboard = leaderboard .. i .. ". " .. user.username .. 
                             " (" .. user.messages .. " messages)\n"
            end
        end
        
        client_info.socket:send(leaderboard)
        
    elseif cmd == "/help" then
        local help = "Commands:\n" ..
                    "/join <room> - Join a room\n" ..
                    "/users - List users in current room\n" ..
                    "/stats - Show room statistics\n" ..
                    "/leaderboard - Show top chatters\n" ..
                    "/help - Show this help\n" ..
                    "/quit - Leave the chat\n"
        client_info.socket:send(help)
        
    elseif cmd == "/quit" then
        return false -- Signal to disconnect
        
    else
        client_info.socket:send("Unknown command. Type /help for available commands.\n")
    end
    
    return true
end

-- Handle individual client connection
local function handle_client(client_socket)
    local client_info = {
        socket = client_socket,
        username = nil,
        room = nil,
        authenticated = false
    }
    
    client_socket:send("Welcome to Simple Chat Server!\n")
    client_socket:send("Type 'register <username> <password>' or 'login <username> <password>'\n")
    
    -- Authentication loop
    while not client_info.authenticated do
        local line = client_socket:receive()
        if not line then break end
        
        line = line:gsub("\r", ""):gsub("\n", "")
        local parts = {}
        for word in line:gmatch("%S+") do
            table.insert(parts, word)
        end
        
        if parts[1] == "register" and parts[2] and parts[3] then
            if register_user(client_socket, parts[2], parts[3]) then
                -- Registration successful, continue to login
            end
        elseif parts[1] == "login" and parts[2] and parts[3] then
            if login_user(client_socket, parts[2], parts[3]) then
                client_info.username = parts[2]
                client_info.authenticated = true
                client_info.room = "general"
                
                -- Add to clients list
                table.insert(clients, client_info)
                
                -- Join general room
                table.insert(rooms["general"].users, client_info.username)
                
                client_socket:send("Welcome " .. client_info.username .. "! You're in the 'general' room.\n")
                client_socket:send("Type /help for commands or just type to chat!\n")
                
                broadcast_to_room("general", client_info.username .. " joined the chat")
            end
        else
            client_socket:send("Please use: register <username> <password> or login <username> <password>\n")
        end
    end
    
    -- Main chat loop
    while client_info.authenticated do
        local line = client_socket:receive()
        if not line then break end
        
        line = line:gsub("\r", ""):gsub("\n", "")
        
        if line:sub(1, 1) == "/" then
            -- Handle command
            if not handle_command(client_info, line) then
                break -- User wants to quit
            end
        else
            -- Regular message
            if client_info.room then
                broadcast_to_room(client_info.room, line, client_info.username)
            end
        end
    end
    
    -- Clean up when client disconnects
    if client_info.room and rooms[client_info.room] then
        for i, user in ipairs(rooms[client_info.room].users) do
            if user == client_info.username then
                table.remove(rooms[client_info.room].users, i)
                break
            end
        end
        if client_info.username then
            broadcast_to_room(client_info.room, client_info.username .. " left the chat")
        end
    end
    
    -- Remove from clients list
    for i, client in ipairs(clients) do
        if client == client_info then
            table.remove(clients, i)
            break
        end
    end
    
    client_socket:close()
end

-- Main server function
local function start_server()
    init_server()
    
    local server = socket.bind(HOST, PORT)
    if not server then
        print("Failed to bind to " .. HOST .. ":" .. PORT)
        return
    end
    
    print("Chat server started on " .. HOST .. ":" .. PORT)
    print("Waiting for connections...")
    
    while true do
        local client = server:accept()
        if client then
            print("New client connected")
            
            -- Simple threading using coroutines (Lua's way)
            local co = coroutine.create(function()
                handle_client(client)
            end)
            
            coroutine.resume(co)
        end
    end
end

-- Start the server
start_server()