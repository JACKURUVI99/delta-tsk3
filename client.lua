-- Simple Chat Client in Lua
-- For beginners - connects to chat server

local socket = require("socket")

-- Client configuration
local HOST = "localhost"
local PORT = 8888

-- Connect to server
local function connect_to_server()
    local client = socket.connect(HOST, PORT)
    if not client then
        print("Failed to connect to server at " .. HOST .. ":" .. PORT)
        return nil
    end
    
    print("Connected to chat server!")
    return client
end

-- Handle receiving messages from server
local function receive_messages(client)
    while true do
        local message = client:receive()
        if not message then
            print("Connection lost!")
            break
        end
        print(message)
    end
end

-- Handle sending messages to server
local function send_messages(client)
    while true do
        local input = io.read()
        if not input then break end
        
        local success = client:send(input .. "\n")
        if not success then
            print("Failed to send message!")
            break
        end
        
        if input == "/quit" then
            break
        end
    end
end

-- Main client function
local function start_client()
    print("=== Simple Chat Client ===")
    print("Connecting to server...")
    
    local client = connect_to_server()
    if not client then
        return
    end
    
    print("Connection established!")
    print("You can start typing. Type /quit to exit.")
    print("----------------------------------------")
    
    -- Simple approach: alternate between receiving and sending
    -- In a real application, you'd use proper threading
    
    local receive_co = coroutine.create(function()
        receive_messages(client)
    end)
    
    local send_co = coroutine.create(function()
        send_messages(client)
    end)
    
    -- Simple event loop
    while true do
        local recv_status = coroutine.resume(receive_co)
        local send_status = coroutine.resume(send_co)
        
        if not recv_status or not send_status then
            break
        end
        
        socket.sleep(0.1) -- Small delay to prevent CPU spinning
    end
    
    client:close()
    print("Disconnected from server.")
end

-- Start the client
start_client()