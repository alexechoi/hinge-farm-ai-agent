#!/bin/bash

# Hinge Automation Docker Runner Script
# This script provides an easy way to run the Hinge automation with Docker

set -e

echo "🤖 Hinge Automation Docker Runner"
echo "=================================="

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "📋 Please create a .env file with your Gemini API key:"
    echo "   cp docker/env.example .env"
    echo "   # Then edit .env and add your GEMINI_API_KEY"
    exit 1
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running!"
    echo "📋 Please start Docker Desktop and try again"
    exit 1
fi

# Check for ADB device connection (optional check)
echo "🔍 Checking for connected Android devices..."
if command -v adb >/dev/null 2>&1; then
    if adb devices | grep -q "device$"; then
        echo "✅ Android device detected"
    else
        echo "⚠️  No Android devices detected (this is okay if device is connected)"
        echo "💡 Make sure USB debugging is enabled and device is authorized"
    fi
else
    echo "📱 ADB not found on host (device check will happen in container)"
fi

# Parse command line arguments for different modes
case "${1:-default}" in
    "test")
        echo "🧪 Running test mode..."
        docker-compose run --rm hinge-automation uv run python test_gemini_agent.py
        ;;
    "debug")
        echo "🐛 Starting interactive debug session..."
        docker-compose run --rm hinge-automation /bin/bash
        ;;
    "fast")
        PROFILES=${2:-5}
        echo "🚀 Running fast mode with $PROFILES profiles..."
        docker-compose run --rm hinge-automation uv run python main_agent.py --config fast --profiles $PROFILES --verbose
        ;;
    "conservative")
        PROFILES=${2:-3}
        echo "🐢 Running conservative mode with $PROFILES profiles..."
        docker-compose run --rm hinge-automation uv run python main_agent.py --config conservative --profiles $PROFILES --verbose
        ;;
    "build")
        echo "🏗️  Building Docker image..."
        docker-compose build
        ;;
    "logs")
        echo "📋 Showing container logs..."
        docker-compose logs -f hinge-automation
        ;;
    "clean")
        echo "🧹 Cleaning up Docker containers and images..."
        docker-compose down
        docker system prune -f
        ;;
    "default")
        PROFILES=${2:-10}
        echo "🎯 Running default automation with $PROFILES profiles..."
        docker-compose run --rm hinge-automation uv run python main_agent.py --profiles $PROFILES --verbose
        ;;
    *)
        echo "📖 Usage: $0 [mode] [profiles]"
        echo ""
        echo "Available modes:"
        echo "  default [N]     - Run automation with N profiles (default: 10)"
        echo "  test           - Test setup and connections"
        echo "  debug          - Interactive debugging session"
        echo "  fast [N]       - Fast mode with N profiles (default: 5)"
        echo "  conservative [N] - Conservative mode with N profiles (default: 3)"
        echo "  build          - Build Docker image"
        echo "  logs           - Show container logs"
        echo "  clean          - Clean up containers and images"
        echo ""
        echo "Examples:"
        echo "  $0 test                    # Test setup"
        echo "  $0 default 20             # Run with 20 profiles"
        echo "  $0 fast 10                # Fast mode with 10 profiles"
        echo "  $0 conservative           # Conservative mode (3 profiles)"
        exit 1
        ;;
esac

echo "✅ Done!"
