# Simple Lua Chat Server

A minimal command-line multiplayer chat room system built with Lua for beginners.

## 📖 User Manual

### Getting Started - Step by Step Guide

#### Step 1: Starting the Chat Server
Before anyone can chat, you need to start the server:

```bash
# Method 1: Using npm (recommended for beginners)
npm start

# Method 2: Direct Lua command
lua5.3 server.lua

# Method 3: Using Docker (if you have Docker installed)
npm run docker:up
```

You should see:
```
Chat server initialized!
Default room 'general' created
Chat server started on localhost:8888
Waiting for connections...
```

#### Step 2: Connecting as a Client
Open a new terminal window and start a client:

```bash
# Method 1: Using npm
npm run client

# Method 2: Direct Lua command
lua5.3 client.lua
```

You should see:
```
=== Simple Chat Client ===
Connecting to server...
Connected to chat server!
Welcome to Simple Chat Server!
Type 'register <username> <password>' or 'login <username> <password>'
```

#### Step 3: Creating Your Account
First time users need to register:

```
register alice mypassword123
```

You should see:
```
SUCCESS: Account created! You can now login.
```

#### Step 4: Logging In
Now login with your credentials:

```
login alice mypassword123
```

You should see:
```
SUCCESS: Logged in successfully!
Welcome alice! You're in the 'general' room.
Type /help for commands or just type to chat!
[general] Server: alice joined the chat
```

#### Step 5: Start Chatting!
Just type any message and press Enter:

```
Hello everyone! This is my first message!
```

You'll see:
```
[general] alice: Hello everyone! This is my first message!
```

### 🎮 Complete Command Reference

#### Authentication Commands (use before logging in)
- `register <username> <password>` - Create a new account
- `login <username> <password>` - Login to your account

#### Chat Commands (use after logging in)
- `/join <roomname>` - Join or create a chat room
  - Example: `/join study-group`
- `/users` - List all users in your current room
- `/stats` - Show room statistics (user count, message count)
- `/leaderboard` - Show top 10 most active chatters
- `/help` - Show all available commands
- `/quit` - Exit the chat

#### Regular Messaging
- Just type your message and press Enter to chat with everyone in your room

### 💡 Usage Examples

#### Example 1: Basic Chat Session
```
# Terminal 1 - Start server
npm start

# Terminal 2 - First user
npm run client
register bob password123
login bob password123
Hello everyone!
/users
/stats

# Terminal 3 - Second user  
npm run client
register alice secret456
login alice secret456
Hi Bob! How are you?
/join homework-help
Anyone need help with math?

# Back to Terminal 2
/join homework-help
I need help with calculus!
```

#### Example 2: Creating Study Groups
```
# Create a study group room
/join cs101-study

# Invite friends to join the same room
# They use: /join cs101-study

# Check who's in your study group
/users

# See how active your study group is
/stats
```

#### Example 3: Checking Your Ranking
```
# See who are the most active chatters
/leaderboard

# Example output:
=== LEADERBOARD ===
1. alice (45 messages)
2. bob (32 messages)
3. charlie (28 messages)
```

### 🚀 Multiple Users Setup

To test with multiple users on the same computer:

1. **Start the server** (Terminal 1):
   ```bash
   npm start
   ```

2. **Open multiple client terminals** (Terminal 2, 3, 4, etc.):
   ```bash
   # Terminal 2
   npm run client
   register user1 pass1
   login user1 pass1
   
   # Terminal 3  
   npm run client
   register user2 pass2
   login user2 pass2
   
   # Terminal 4
   npm run client  
   register user3 pass3
   login user3 pass3
   ```

3. **Start chatting** - messages from one terminal will appear in all others!

### 🔧 Troubleshooting Common Issues

#### "Connection refused" Error
```bash
# Make sure server is running first
npm start
# Then in another terminal:
npm run client
```

#### "Command not found: lua" Error
```bash
# Install Lua first:
# Ubuntu/Debian:
sudo apt-get install lua5.3 lua-socket

# MacOS:
brew install lua luarocks
luarocks install luasocket
```

#### "Module not found" Error
```bash
# Install luasocket:
luarocks install luasocket
```

#### Forgot Your Password
Unfortunately, there's no password recovery yet. You'll need to:
1. Stop the server
2. Delete the `users.txt` file
3. Restart the server
4. Register again with a new password

### 🎯 Tips for Beginners

1. **Always start the server first** before connecting clients
2. **Use simple passwords** for testing (this is just for learning!)
3. **Try multiple terminals** to simulate different users
4. **Use `/help`** if you forget commands
5. **Check `/stats`** to see room activity
6. **Join different rooms** to organize conversations
7. **Use the leaderboard** to see who's most active

### 🏆 Fun Challenges

1. **Race to the Top**: See who can get to #1 on the leaderboard
2. **Room Creator**: Create the most popular chat room
3. **Helper**: Help new users learn the commands
4. **Conversation Starter**: Start interesting discussions in different rooms

---

## Features

- **Multi-user chat rooms**: Create and join different chat rooms
- **Real-time messaging**: Chat with multiple users simultaneously  
- **User authentication**: Register and login system with password hashing
- **Room statistics**: View active users and message counts
- **Leaderboard**: Track most active chatters
- **Persistent storage**: Chat history and user data stored in files
- **Docker support**: Fully containerized with Docker Compose
- **CI/CD Pipeline**: Automated testing and deployment with GitHub Actions

## Quick Start

### Prerequisites
- Lua 5.3 or higher
- luasocket library
- Docker (for containerized deployment)

### Running Locally

1. **Install Lua and dependencies**:
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install lua5.3 lua-socket
   
   # On MacOS with Homebrew
   brew install lua luarocks
   luarocks install luasocket
   ```

2. **Start the server**:
   ```bash
   lua5.3 server.lua
   ```

3. **Start a client** (in another terminal):
   ```bash
   lua5.3 client.lua
   ```

### Using Docker

1. **Build and run with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

2. **Connect using a client**:
   ```bash
   lua5.3 client.lua
   ```

## How to Use

### First Time Setup
1. Run the client: `lua5.3 client.lua`
2. Register a new account: `register myusername mypassword`
3. Login: `login myusername mypassword`
4. Start chatting!

### Available Commands
- `/join <roomname>` - Join or create a chat room
- `/users` - List users in current room
- `/stats` - Show room statistics
- `/leaderboard` - Show top 10 active chatters
- `/help` - Show all commands
- `/quit` - Exit the chat

### Example Session
```
=== Simple Chat Client ===
Connecting to server...
Connected to chat server!
Welcome to Simple Chat Server!
Type 'register <username> <password>' or 'login <username> <password>'

register alice mypassword
SUCCESS: Account created! You can now login.

login alice mypassword
SUCCESS: Logged in successfully!
Welcome alice! You're in the 'general' room.
Type /help for commands or just type to chat!

Hello everyone!
[general] alice: Hello everyone!

/join study-group
Joined room: study-group
[study-group] Server: alice joined the room

Anyone studying for the exam?
[study-group] alice: Anyone studying for the exam?
```

## Project Structure

```
├── server.lua          # Main chat server
├── client.lua          # Chat client
├── simple_json.lua     # Basic JSON-like utilities
├── Dockerfile          # Docker configuration
├── docker-compose.yml  # Docker Compose setup
├── deploy.sh           # Deployment script
├── .github/
│   └── workflows/
│       └── ci-cd.yml   # GitHub Actions CI/CD
├── data/               # Persistent data directory
└── users.txt           # User authentication data
```

## Technical Details

### Server Architecture
- **Socket-based**: Uses Lua's socket library for TCP connections
- **Coroutine threading**: Handles multiple clients with Lua coroutines
- **File-based storage**: Simple text files for data persistence
- **Room system**: Users can create and join different chat rooms

### Security Features
- **Password hashing**: Simple hash function for password storage
- **Authentication required**: Must login before accessing chat
- **Session management**: Tracks authenticated users

### Data Storage
- **users.txt**: Stores username:password_hash pairs
- **Room data**: In-memory storage with file backup
- **Message history**: Stored per room with timestamps

## Deployment

### Manual Deployment
```bash
# Pull latest code
git pull origin main

# Run deployment script
chmod +x deploy.sh
./deploy.sh
```

### CI/CD Pipeline
The project includes a GitHub Actions workflow that:
1. Builds Docker images on every push
2. Runs basic tests
3. Pushes images to Docker Hub
4. Deploys to staging/production

Set up these secrets in your GitHub repository:
- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub password

## Troubleshooting

### Common Issues

1. **"Connection refused"**
   - Make sure the server is running
   - Check if port 8888 is available

2. **"Module not found"**
   - Install luasocket: `luarocks install luasocket`

3. **Docker issues**
   - Ensure Docker is running
   - Try: `docker-compose down && docker-compose up --build`

### Logs
```bash
# View Docker logs
docker-compose logs -f

# View server logs
tail -f server.log
```

## Contributing

This is a educational project for beginners. Feel free to:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

This project is for educational purposes. Feel free to use and modify as needed.

## Learning Resources

- [Lua Programming Guide](https://www.lua.org/pil/)
- [Socket Programming in Lua](https://w3.impa.br/~diego/software/luasocket/)
- [Docker Basics](https://docs.docker.com/get-started/)
- [GitHub Actions](https://docs.github.com/en/actions)