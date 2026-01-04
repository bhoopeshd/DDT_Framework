# Framework Architecture

Data-Driven Framework with Smart Keywords and Clean Architecture.

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      TEST SUITE                                  │
│                   Tests/TestSuite.robot                          │
│                                                                  │
│  TC_01 Valid Login Test                                          │
│      Execute Login Test    TC_01     ← Just pass TestID!        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SMART KEYWORDS                                │
│               Keywords/Keywords.robot                            │
│                                                                  │
│  Execute Login Test                                              │
│      ${data} = Load Data For Test Case    ${TestID}              │
│      Open Browser And Navigate    ${URL}  ← From Global_Config   │
│      Perform Login    ${data}[username]   ← From Excel           │
└─────────────────────────────────────────────────────────────────┘
                    │                   │
        ┌───────────┘                   └───────────┐
        ▼                                           ▼
┌───────────────────────┐               ┌───────────────────────┐
│   GLOBAL_CONFIG       │               │     DATA MANAGER      │
│ Config/Global_Config  │               │ DataManager/          │
│                       │               │   DataManager.robot   │
│ • ${URL}              │               │                       │
│ • ${BROWSER}          │               │ • Load Data For TC    │
│ • ${WAIT_TIME}        │               │ • Write Result        │
│ • ${DELAY}            │               │                       │
│                       │               │         │             │
│ (Environment Config)  │               │         ▼             │
└───────────────────────┘               │ ┌─────────────────┐   │
                                        │ │ TestData.xlsx   │   │
                                        │ │                 │   │
                                        │ │ • username      │   │
                                        │ │ • password      │   │
                                        │ │ • expected_error│   │
                                        │ │ • Result ←WRITE │   │
                                        │ └─────────────────┘   │
                                        └───────────────────────┘
```

---

## 📁 Directory Structure

```
DDT_Framework/
│
├── Data/
│   └── TestData.xlsx           # Test data (read) + Results (write)
│
├── Resources/
│   ├── Config/
│   │   └── Global_Config.robot # URL, Browser, Timing (Environment)
│   │
│   ├── DataManager/
│   │   └── DataManager.robot   # Excel read/write operations
│   │
│   ├── Locators/
│   │   └── Locators.robot      # All UI locators
│   │
│   └── Keywords/
│       ├── Step_Definitions.robot  # Master import
│       └── Keywords.robot          # All keywords
│
├── Tests/
│   └── TestSuite.robot         # Clean test cases
│
└── Results/                    # Reports, logs, screenshots
```

---

## 🔧 Key Design Principles

### 1. Configuration Separation

| Source | Contains |
|--------|----------|
| **Global_Config.robot** | URL, Browser, Wait Time, Delay |
| **TestData.xlsx** | username, password, expected values |

### 2. Smart Keywords Pattern

**Before (Complex):**
```robot
TC_01 Valid Login Test
    ${data}=    Load Data For Test Case    TC_01
    Open Browser And Navigate    ${data}[url]
    Perform Login    ${data}[username]    ${data}[password]
    Verify Login Success
```

**After (Clean):**
```robot
TC_01 Valid Login Test
    Execute Login Test    TC_01
```

### 3. Data Flow

1. **Test calls smart keyword** with just `${TestID}`
2. **Keyword loads data** from Excel internally
3. **URL/Browser** comes from `Global_Config`
4. **Test data** comes from Excel
5. **Result** is written back to Excel

---

## 📊 Excel Format

| TestID | url | username | password | expected_error | expected_title | Result |
|--------|-----|----------|----------|----------------|----------------|--------|
| TC_01 | (not used) | tomsmith | SuperSecret! | | The Internet | PASS |
| TC_02 | (not used) | invalid | invalid | Your username is invalid! | | FAIL |

> **Note:** URL is in Global_Config, not Excel. Excel only has test-specific data.

---

## 🏷️ Tags

| Tag | Purpose |
|-----|---------|
| `smoke` | Quick validation tests |
| `regression` | Full regression tests |
| `login` | Login functionality |
| `positive` | Positive scenarios |
| `negative` | Negative scenarios |

---

## ✅ Benefits

1. **Clean Tests** - Just TestID, no parameters
2. **Smart Keywords** - Handle data internally
3. **Centralized Config** - Environment in one place
4. **Excel Integration** - Read data, write results
5. **Pure Robot Framework** - No Python code
