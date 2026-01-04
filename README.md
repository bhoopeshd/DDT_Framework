# Robot Framework Data-Driven Testing (DDT) Framework

A **scalable, production-ready** automation framework built with Robot Framework, implementing clean separation of concerns through a 3-layer architecture.

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        TEST LAYER                                │
│                    (TestSuite.robot)                             │
│         Data-driven tests using Test Template + DataDriver       │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   STEP DEFINITION LAYER                          │
│               (Step_Definitions.robot)                           │
│         High-level keywords consuming SeleniumLibrary            │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌───────────────────────────┴─────────────────────────────────────┐
│                                                                   │
│  ┌─────────────────────┐           ┌─────────────────────────┐   │
│  │    UI MAP LAYER     │           │      DATA LAYER         │   │
│  │   (Locators.py)     │           │   (TestData.xlsx)       │   │
│  │  Python variables   │           │  Excel data source      │   │
│  └─────────────────────┘           └─────────────────────────┘   │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
DDT_Framework/
├── Data/
│   └── TestData.xlsx              # Test data for DataDriver (Excel)
│
├── Resources/
│   ├── Locators/
│   │   └── Locators.py            # UI element locators (Python)
│   │
│   └── Keywords/
│       └── Step_Definitions.robot  # High-level reusable keywords
│
├── Tests/
│   └── TestSuite.robot            # Test suite with DataDriver config
│
├── Results/                       # Test execution outputs (auto-created)
│
├── requirements.txt               # Python dependencies
└── README.md                      # This file
```

---

## 🚀 Quick Start

### 1. Prerequisites

- **Python 3.8+** installed
- **Chrome browser** (or modify for Firefox/Edge)
- **Git** (optional, for version control)

### 2. Installation

```powershell
# Clone or navigate to the framework directory
cd DDT_Framework

# Create virtual environment (recommended)
python -m venv venv
.\venv\Scripts\Activate.ps1   # Windows PowerShell
# source venv/bin/activate    # Linux/Mac

# Install dependencies
pip install -r requirements.txt
```

### 3. Run Tests

```powershell
# Run all tests with default output directory
robot --outputdir Results Tests/TestSuite.robot

# Run with verbose logging
robot --loglevel DEBUG --outputdir Results Tests/TestSuite.robot

# Run specific test by name pattern
robot --test "*Python*" --outputdir Results Tests/TestSuite.robot
```

---

## 📊 Excel Data File Format

The DataDriver library reads test data from `Data/TestData.xlsx`. The Excel file **must** follow this format:

### Required Structure

| test_name | url | search_term | expected_result |
|-----------|-----|-------------|-----------------|
| Google Search Python | https://www.google.com | Robot Framework Python | Robot Framework |
| Google Search Java | https://www.google.com | Selenium Java Tutorial | Selenium |
| Google Search Automation | https://www.google.com | Test Automation Best Practices | Automation |

### Column Header Rules

> ⚠️ **IMPORTANT**: Column headers must match keyword argument names!

1. **Case-insensitive**: `URL`, `url`, `Url` all work
2. **Underscores vs Spaces**: Use underscores in headers (`test_name` not `test name`)
3. **First column**: Should be a unique test identifier (used in test name)
4. **Order matters**: Columns should match the order of arguments in your template keyword

### Template Keyword Signature

```robot
Execute Search Test Case
    [Arguments]    ${url}    ${search_term}    ${expected_result}
```

The Excel columns map directly to these arguments:
- Column B (`url`) → `${url}`
- Column C (`search_term`) → `${search_term}`
- Column D (`expected_result`) → `${expected_result}`

---

## 🔧 Customization Guide

### Adding New Locators

Edit `Resources/Locators/Locators.py`:

```python
# Add new page locators
MY_NEW_BUTTON = "id=new-button"
MY_NEW_INPUT = "css=input.new-input"

# Or use dynamic locator functions
def get_menu_item(item_name):
    return f"xpath=//nav//a[text()='{item_name}']"
```

### Adding New Keywords

Edit `Resources/Keywords/Step_Definitions.robot`:

```robot
*** Keywords ***
My New Keyword
    [Documentation]    Description of what this keyword does
    [Arguments]    ${arg1}    ${arg2}
    [Tags]    custom
    # Implementation here
    Log    Executing with ${arg1} and ${arg2}
```

### Adding New Test Data

1. Open `Data/TestData.xlsx`
2. Add new rows with test data
3. Each row becomes a new test case automatically

---

## 📋 Test Execution Options

### Basic Commands

```powershell
# Standard execution
robot --outputdir Results Tests/TestSuite.robot

# With specific browser
robot --variable BROWSER:firefox --outputdir Results Tests/TestSuite.robot

# Skip specific tests
robot --exclude skip --outputdir Results Tests/TestSuite.robot

# Run with screenshots on pass
robot --loglevel DEBUG --outputdir Results Tests/TestSuite.robot
```

### Parallel Execution (with Pabot)

```powershell
# Install pabot
pip install robotframework-pabot

# Run tests in parallel
pabot --processes 4 --outputdir Results Tests/TestSuite.robot
```

### CI/CD Integration (GitHub Actions Example)

```yaml
name: Robot Framework Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
          
      - name: Install dependencies
        run: pip install -r requirements.txt
        
      - name: Run tests
        run: robot --outputdir Results Tests/TestSuite.robot
        
      - name: Upload results
        uses: actions/upload-artifact@v3
        with:
          name: robot-results
          path: Results/
```

---

## 📁 Test Results

After execution, the `Results/` directory contains:

| File | Description |
|------|-------------|
| `output.xml` | Raw test results in XML format |
| `log.html` | Detailed execution log with screenshots |
| `report.html` | Summary report with statistics |
| `*.png` | Screenshots captured during test execution |

---

## 🛠️ Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| `WebDriverException` | Install/update ChromeDriver: `pip install webdriver-manager` |
| `DataDriver file not found` | Check relative path in TestSuite.robot Settings |
| `Variable not found` | Ensure Locators.py is imported correctly |
| `Element not found` | Increase timeout or check locator validity |

### Debug Mode

```powershell
# Run with maximum logging
robot --loglevel TRACE --outputdir Results Tests/TestSuite.robot

# Run single test interactively
robot --test "Search Test: Google Search Python" --outputdir Results Tests/
```

---

## 📚 Best Practices

1. **Locator Strategy**: Prefer `id` > `name` > `css` > `xpath`
2. **Keyword Naming**: Use descriptive, action-oriented names
3. **Error Handling**: Use TRY/EXCEPT for graceful failures
4. **Documentation**: Add `[Documentation]` to all keywords
5. **Tagging**: Use `[Tags]` for test organization and filtering
6. **Screenshots**: Capture on failure for debugging

---

## 📄 License

This framework is provided as-is for educational and professional use.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

---

**Happy Testing! 🚀**
