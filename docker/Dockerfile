# Hinge Automation Docker Container
FROM python:3.13-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV UV_CACHE_DIR=/tmp/uv-cache

# Install system dependencies including ADB
RUN apt-get update && apt-get install -y \
    # ADB and Android tools
    android-tools-adb \
    android-tools-fastboot \
    # System utilities
    curl \
    wget \
    git \
    # OpenCV dependencies
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgthread-2.0-0 \
    libgtk-3-0 \
    # USB access
    udev \
    # Build tools for Python packages
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create app directory first
WORKDIR /app

# Copy project files
COPY app/ /app/

# Create images directory for screenshots
RUN mkdir -p /app/images

# Install uv and dependencies in a single RUN command to preserve environment
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    export PATH="/root/.local/bin:$PATH" && \
    /root/.local/bin/uv sync --frozen

# Add uv to PATH for runtime
ENV PATH="/root/.local/bin:$PATH"

# Create entrypoint script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Start ADB server\n\
echo "🔌 Starting ADB server..."\n\
adb start-server\n\
\n\
# Wait for device connection\n\
echo "⏳ Waiting for device connection..."\n\
timeout=30\n\
counter=0\n\
while [ $counter -lt $timeout ]; do\n\
    if adb devices | grep -q "device$"; then\n\
        echo "✅ Device connected!"\n\
        adb devices\n\
        break\n\
    fi\n\
    echo "Waiting for device... ($counter/$timeout)"\n\
    sleep 1\n\
    counter=$((counter + 1))\n\
done\n\
\n\
if [ $counter -eq $timeout ]; then\n\
    echo "❌ No device found after $timeout seconds"\n\
    echo "💡 Make sure your Android device is:"\n\
    echo "   - Connected via USB"\n\
    echo "   - Has USB debugging enabled"\n\
    echo "   - Has authorized this computer"\n\
    exit 1\n\
fi\n\
\n\
# Execute the main command\n\
exec "$@"\n' > /entrypoint.sh && chmod +x /entrypoint.sh

# Set up USB device access
RUN echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="*", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/51-android.rules

# Expose ADB port
EXPOSE 5037

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["uv", "run", "python", "main_agent.py", "--verbose"]
