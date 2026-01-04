# Run Guide

## 📋 Installation

```powershell
cd DDT_Framework
pip install -r requirements.txt
```

---

## 🚀 Run Tests

```powershell
# Run all tests
robot --outputdir Results Tests/TestSuite.robot

# Run specific test
robot --test "TC_01*" --outputdir Results Tests/

# Run by tag
robot --include smoke --outputdir Results Tests/
```

---

## ⏱️ Timing Configuration

The framework uses 4 timing configurations in `Global_Config.robot`:

| Variable | Default | Purpose | Used In |
|----------|---------|---------|---------|
| `${WAIT_TIME}` | 10s | Element wait timeout | Fluent wait, element visibility |
| `${DELAY}` | 500ms | UI stabilization, retry interval | After clicks, fluent wait retry |
| `${IMPLICIT_WAIT}` | 5s | Selenium implicit wait | Browser initialization |
| `${PAGE_LOAD_TIMEOUT}` | 30s | Page load timeout | JS Wait For Page Load |

### 🛡️ Browser Noise Suppression (`BROWSER_LOG_LEVEL`)

We use the `--log-level` flag to suppress internal browser warnings/errors that clutter the terminal.

| Level | Description | Recommended For |
|-------|-------------|-----------------|
| `0` | Default | Debugging browser crashes |
| `1` | Info | General investigation |
| `2` | Warning | Standard development |
| `3` | **Error (Recommended)** | **Standard execution (Hides noise)** |

**Example Override:**
```powershell
# Show all browser logs for debugging
robot --variable BROWSER_LOG_LEVEL:0 --outputdir Results Tests/
```

### Override Timing

```powershell
# Increase wait time for slow environments
robot --variable WAIT_TIME:20s --outputdir Results Tests/

# Faster execution (quick environments)
robot --variable WAIT_TIME:5s --variable DELAY:200ms --outputdir Results Tests/

# Slow page loads
robot --variable PAGE_LOAD_TIMEOUT:60s --outputdir Results Tests/
```

### How Fluent Wait Works

```
Fluent Wait For Element    ${locator}
│
├── Retry every ${DELAY} (500ms)
├── Until element visible or ${WAIT_TIME} (10s) expires
└── Never fails immediately - keeps retrying
```

---

## ⚙️ Browser Configuration

```powershell
# Chrome (default)
robot --outputdir Results Tests/

# Firefox
robot --variable BROWSER:firefox --outputdir Results Tests/

# Edge
robot --variable BROWSER:edge --outputdir Results Tests/

# Headless mode (via CLI flag)
robot --variable HEADLESS:True --outputdir Results Tests/

# Incognito / InPrivate mode (via CLI flag)
robot --variable INCOGNITO:True --outputdir Results Tests/

# Combine options (Headless + Incognito)
robot --variable HEADLESS:True --variable INCOGNITO:True --outputdir Results Tests/
```

### 📢 Console Monitoring

The framework echoes major test steps to the terminal for live monitoring:

```text
🚀 Launching application (edge)...
✅ Browser launched successfully.
📍 STEP 1: Loading data from Excel
📍 STEP 2: Entering User Credentials
👤 Entering credentials for: tosmith
📍 STEP 3: Clicking Login Button
🖱️ Clicking login button...
```

---

## 🌐 URL Configuration

```powershell
# Staging environment
robot --variable URL:https://staging.example.com/login --outputdir Results Tests/

# Production
robot --variable URL:https://prod.example.com/login --outputdir Results Tests/
```

---

## 🏷️ Tag Execution

```powershell
robot --include smoke --outputdir Results Tests/
robot --include regression --outputdir Results Tests/
robot --include login --outputdir Results Tests/
robot --exclude negative --outputdir Results Tests/
```

---

## 📊 Keyword Categories

### Fluent Wait Keywords
- `Fluent Wait For Element` - Waits with retry
- `Fluent Click Element` - Clicks with retry
- `Fluent Input Text` - Inputs with retry

### JavaScript Executor Keywords
- `JS Click Element` - Click via JS
- `JS Input Text` - Input via JS
- `JS Get Text` - Get text via JS
- `JS Scroll To Element` - Scroll via JS
- `JS Highlight Element` - Debug highlighting
- `JS Wait For Page Load` - Wait for document.readyState
- `JS Wait For Ajax` - Wait for jQuery.active

### Data Keywords
- `Load Test Data` - Loads Excel data for TestID
- `Write Data To Excel` - Writes runtime data to Excel

---

## 📊 Viewing Reports & Logs

After execution, all results are stored in the `Results/` directory.

### 1. Detailed Execution Log (`log.html`)
Open `Results/log.html` in any web browser. This is your primary debugging tool.
- **Step Logs**: Look for the `════════` separators to find the high-level steps.
- **Screenshots**: Screenshots are embedded directly next to the failed step.
- **Traceability**: Every keyword is expandable to see exactly what happened and when.

### 2. Executive Summary (`report.html`)
Open `Results/report.html` for a high-level view of pass/fail statistics, tags, and suite duration. Great for sharing with stakeholders.

### 3. Data Persistence (`TestData.xlsx`)
Open `Data/TestData.xlsx` to see the **Result** column updated in real-time.
- **Runtime Data**: Column 8 (Execution_Time) is updated during the test run to show the exact timestamp of execution.

### 4. Console Summary
The terminal provides a live, high-level summary of tests as they run, including the final pass/fail count and paths to the generated reports.
