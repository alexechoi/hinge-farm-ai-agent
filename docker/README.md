# 🐳 Docker Setup for Hinge Automation

This directory contains Docker configuration files to run the Hinge Automation agent in a containerized environment with full USB/ADB device access.

## 🚀 Quick Start

### Prerequisites

1. **Docker & Docker Compose** installed on your host machine
2. **Android device** with USB debugging enabled
3. **Google Gemini API key** from [Google AI Studio](https://aistudio.google.com/)
4. **USB cable** to connect your Android device

### Setup Steps

1. **Clone and navigate to the project:**
   ```bash
   git clone https://github.com/alexechoi/hinge-automation.git
   cd hinge-automation
   ```

2. **Create environment file:**
   ```bash
   cp docker/env.example .env
   # Edit .env and add your GEMINI_API_KEY
   ```

3. **Connect your Android device:**
   ```bash
   # Enable USB debugging on your device
   # Connect via USB cable
   # Authorize computer when prompted
   
   # Verify connection (optional, requires ADB on host)
   adb devices
   ```

4. **Build and run with Docker Compose:**
   ```bash
   # Build and start the container
   docker-compose up --build
   
   # Or run in background
   docker-compose up -d --build
   ```

## 📱 Device Setup Requirements

### Android Device Configuration
- **Developer Options** enabled
- **USB Debugging** enabled  
- **Computer authorized** for debugging
- **Hinge app** installed and logged in
- **Screen timeout** disabled (recommended)
- **Do Not Disturb** enabled (recommended)

### USB Connection
The Docker setup requires direct USB access to communicate with your Android device through ADB.

## 🔧 Configuration Options

### Environment Variables
```bash
# Required
GEMINI_API_KEY=your-api-key-here

# Optional
DEVICE_IP=127.0.0.1  # Default ADB IP
DEBUG=true           # Enable verbose logging
```

### Docker Compose Commands

```bash
# Different automation modes
docker-compose run hinge-automation uv run python main_agent.py --profiles 20
docker-compose run hinge-automation uv run python main_agent.py --config fast
docker-compose run hinge-automation uv run python main_agent.py --config conservative

# Test setup
docker-compose run hinge-automation uv run python test_gemini_agent.py

# Interactive debugging
docker-compose run hinge-automation /bin/bash
```

### Custom Configuration
Edit `docker-compose.yml` to modify the default command or uncomment alternative commands:

```yaml
# Fast mode with 5 profiles
command: ["uv", "run", "python", "main_agent.py", "--config", "fast", "--profiles", "5"]

# Test mode
command: ["uv", "run", "python", "test_gemini_agent.py"]

# Interactive shell
command: ["/bin/bash"]
```

## 🔍 Troubleshooting

### Device Connection Issues

1. **Check USB connection:**
   ```bash
   # From host machine (if ADB installed)
   adb devices
   
   # From inside container
   docker-compose exec hinge-automation adb devices
   ```

2. **Device not detected:**
   - Ensure USB debugging is enabled
   - Try different USB cable/port
   - Revoke and re-authorize USB debugging
   - Check device is unlocked during connection

3. **Permission errors:**
   ```bash
   # Restart container with fresh USB detection
   docker-compose down
   docker-compose up
   ```

### Container Issues

```bash
# View container logs
docker-compose logs hinge-automation

# Debug inside container
docker-compose exec hinge-automation /bin/bash

# Rebuild container after changes
docker-compose down
docker-compose up --build
```

### ADB Server Issues

```bash
# Reset ADB server inside container
docker-compose exec hinge-automation adb kill-server
docker-compose exec hinge-automation adb start-server

# Use separate ADB server (optional)
docker-compose --profile adb-only up adb-server
```

## 🏗️ Development Mode

For active development, mount your local code:

```yaml
# In docker-compose.yml, volumes section already includes:
volumes:
  - ./app:/app  # Live code updates
  - ./app/images:/app/images  # Screenshot persistence
```

This allows you to edit code on your host machine and see changes immediately in the container.

## 📊 Monitoring

### Screenshot Access
Screenshots are saved to `./app/images/` and are accessible from your host machine for debugging.

### Generated Comments
Comment history is saved to `./app/generated_comments.json` and persists between container runs.

### Logs
```bash
# Follow live logs
docker-compose logs -f hinge-automation

# View specific timestamps
docker-compose logs --since="2024-01-01T10:00:00" hinge-automation
```

## 🚦 Alternative ADB Setup

If you prefer to run ADB server separately:

```bash
# Start standalone ADB server
docker-compose --profile adb-only up adb-server

# Connect your main container to it
# (Modify docker-compose.yml to use network connectivity instead of USB passthrough)
```

## 📝 Notes

- **USB Passthrough**: The container needs privileged access to USB devices
- **Network Mode**: Uses host networking for optimal ADB connectivity  
- **Security**: Only use on trusted networks due to privileged container mode
- **Performance**: Container includes all necessary dependencies for computer vision and AI analysis

## 🔗 Useful Commands

```bash
# Quick test run
docker-compose run --rm hinge-automation uv run python test_gemini_agent.py

# Conservative 3-profile run
docker-compose run --rm hinge-automation uv run python main_agent.py --config conservative --profiles 3

# Interactive debugging session
docker-compose run --rm hinge-automation /bin/bash

# Clean up
docker-compose down
docker system prune  # Remove unused containers/images
```
