# How to Clone Repository on Cloud Mac

## 🚀 Quick Steps

### Step 1: Connect to Your Cloud Mac

**Via VNC (Visual Desktop):**
1. Open VNC Viewer (download from https://www.realvnc.com/en/connect/download/viewer/)
2. Enter your Mac's IP address
3. Enter username and password
4. You'll see the Mac desktop

**Via SSH (Command Line):**
```bash
ssh username@mac-ip-address
```

---

### Step 2: Open Terminal on Cloud Mac

**If using VNC:**
- Click the Terminal icon in Dock, OR
- Press `Cmd + Space` → type "Terminal" → Enter

**If using SSH:**
- You're already in Terminal!

---

### Step 3: Navigate to Where You Want the Project

```bash
# Go to Desktop (recommended for easy access)
cd ~/Desktop

# OR go to Documents
cd ~/Documents

# OR create a Projects folder
mkdir ~/Projects
cd ~/Projects
```

---

### Step 4: Clone the Repository

```bash
git clone https://github.com/enea250705/invoice_app.git
```

**What this does:**
- Downloads all your code from GitHub
- Creates a folder called `invoice_app`
- Contains all your project files

---

### Step 5: Enter the Project Folder

```bash
cd invoice_app
```

---

### Step 6: Verify Files Are There

```bash
ls -la
```

You should see:
- `LedgerNest/` folder
- `LedgerNest.xcodeproj/` folder
- `README.md`
- Other documentation files

---

### Step 7: Open in Xcode

**Option A: Command Line**
```bash
open LedgerNest.xcodeproj
```

**Option B: Finder**
1. Open Finder
2. Navigate to `invoice_app` folder
3. Double-click `LedgerNest.xcodeproj`

---

### Step 8: Build and Run

**In Xcode:**
1. Wait for Xcode to index files (may take a minute)
2. Select a simulator (top bar):
   - Click device selector
   - Choose "iPhone 15" or any iPhone
3. Click the **Play button (▶️)** or press `Cmd + R`
4. App builds and launches in simulator!

---

## 📋 Complete Command Sequence

Copy and paste this entire block:

```bash
# Navigate to Desktop
cd ~/Desktop

# Clone repository
git clone https://github.com/enea250705/invoice_app.git

# Enter project folder
cd invoice_app

# Open in Xcode
open LedgerNest.xcodeproj
```

That's it! Xcode will open automatically.

---

## 🔄 Getting Updates Later

When you push changes from Windows, get them on Mac:

```bash
# Navigate to project folder
cd ~/Desktop/invoice_app

# Pull latest changes
git pull

# Xcode will detect changes automatically
# Just click Play again to test
```

---

## ⚠️ First Time Setup (If Needed)

### If Xcode is Not Installed:

```bash
# Check if Xcode is installed
xcodebuild -version

# If not installed, download from App Store or:
# Install command line tools first
xcode-select --install
```

### Accept Xcode License (First Time):

```bash
sudo xcodebuild -license accept
```

### Install Command Line Tools (If Needed):

```bash
xcode-select --install
```

---

## 🎯 Troubleshooting

### "Command not found: git"
```bash
# Install Xcode command line tools
xcode-select --install
```

### "Permission denied"
```bash
# Make sure you have write permissions
# Try cloning to a different location:
cd ~/Documents
git clone https://github.com/enea250705/invoice_app.git
```

### "Repository not found"
- Make sure the repository is public, OR
- You're logged into GitHub on the Mac:
```bash
# Configure git credentials
git config --global user.name "enea250705"
git config --global user.email "your-email@example.com"
```

### Xcode Won't Open
```bash
# Try opening from Applications folder
open /Applications/Xcode.app

# Or check if Xcode is installed
ls /Applications/ | grep -i xcode
```

---

## 📱 Testing the App

Once Xcode opens:

1. **Select Simulator:**
   - Top toolbar → Device selector
   - Choose "iPhone 15" or "iPhone 15 Pro"

2. **Build:**
   - Click Play (▶️) button
   - Or press `Cmd + R`
   - Wait for build to complete

3. **Run:**
   - Simulator opens automatically
   - App launches
   - Test all features!

4. **Stop:**
   - Click Stop (⏹️) button
   - Or press `Cmd + .`

---

## 💡 Pro Tips

### Quick Navigation
```bash
# Create alias for quick access
echo 'alias invoice="cd ~/Desktop/invoice_app"' >> ~/.zshrc
source ~/.zshrc

# Now just type:
invoice
```

### Check Git Status
```bash
cd ~/Desktop/invoice_app
git status
```

### See Recent Changes
```bash
git log --oneline -5
```

### Switch to Different Branch (if you create one)
```bash
git branch -a  # See all branches
git checkout branch-name  # Switch branch
```

---

## ✅ Success Checklist

- [ ] Connected to cloud Mac
- [ ] Opened Terminal
- [ ] Cloned repository: `git clone https://github.com/enea250705/invoice_app.git`
- [ ] Entered folder: `cd invoice_app`
- [ ] Opened Xcode: `open LedgerNest.xcodeproj`
- [ ] Selected simulator
- [ ] Clicked Play (▶️)
- [ ] App launched successfully! 🎉

---

## 🎬 Example Session

```bash
# You're on cloud Mac now...

klaud@mac-cloud:~$ cd ~/Desktop
klaud@mac-cloud:~/Desktop$ git clone https://github.com/enea250705/invoice_app.git
Cloning into 'invoice_app'...
remote: Enumerating objects: 44, done.
remote: Counting objects: 100% (44/44), done.
remote: Compressing objects: 100% (40/40), done.
remote: Total 44 (delta 2), reused 44 (delta 2), pack-reused 0
Receiving objects: 100% (44/44), 36.45 KiB | 2.50 MiB/s, done.
Resolving deltas: 100% (2/2), done.

klaud@mac-cloud:~/Desktop$ cd invoice_app
klaud@mac-cloud:~/Desktop/invoice_app$ ls
LedgerNest/          LedgerNest.xcodeproj/  README.md  ...

klaud@mac-cloud:~/Desktop/invoice_app$ open LedgerNest.xcodeproj
# Xcode opens! 🎉
```

That's it! You're ready to test! 🚀

