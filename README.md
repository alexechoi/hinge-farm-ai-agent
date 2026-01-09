# 🤖 Hinge Farmer AI Agent

An intelligent Hinge bot that uses **Google Gemini AI**, **LangGraph**, **Computer Vision**, and **ADB** to automatically analyze profiles, make smart decisions, and send personalized comments.

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/6ff7a85b-aaa4-4ea1-baef-50c7be5528db" />

## 🚀 Quick Start

```bash
# Clone and setup
git clone https://github.com/alexechoi/hinge-automation.git
cd hinge-automation/app/

# Install dependencies
uv sync

# Configure API key
echo "GEMINI_API_KEY=your-key-here" > .env

# Run
uv run python main_agent.py
```

**Requirements:**

- Android phone with Hinge installed
- [ADB](https://developer.android.com/studio/releases/platform-tools) installed
- [Gemini API key](https://aistudio.google.com/)

**Device Setup:**

1. Go to **Settings → About phone** → tap **Build number** 7 times to enable Developer Options
2. Go to **Settings → Developer options** → enable **USB debugging**
3. Connect your phone via USB and authorize your computer when prompted

**Tips:**

- Disable screen timeout on your device
- Open Hinge before starting the agent
- Enable Do Not Disturb to avoid interruptions

## ⚠️ Limitations & Disclaimer

- The free Gemini API key has a low rate limit that may not be sufficient
- Automation can be unreliable with UI changes or unexpected app states
- **For educational and research purposes only** — use at your own risk

## 📜 License

MIT License
