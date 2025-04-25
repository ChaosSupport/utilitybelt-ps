# utilityprocs

A small set of functions that I reuse heavily.

## 🧰 What's Included

- ✍️ Easy-to-use logging system (`Write-Log`)
- 🧼 Graceful error exits with style (`Exit-Nicely`)
- 📖 Reference file importer with logging and error handling (`Read-Ref`)
- 🗂️ Auto-generated log path setup (`Set-Path`)
- ...and more coming soon

## 🚀 How to Use

1. **Import the module**  
   Clone or download this repo, then in PowerShell:

   ```powershell
   Import-Module .\utilitybelt.psm1
   ```

2. **Run a function**  
   ```powershell
   Set-Path
   Write-Log $LogFile 2 3 "We did a thing."
   ```

3. **Get help**  
   Use PowerShell’s built-in help system:

   ```powershell
   Get-Help Write-Log -Full
   ```

## 📦 Why It Exists

Because the world has enough half-baked scripts with no logs or graceful exits. This is for people who fix problems **and** look good doing it.

## 🗺️ Roadmap

- [x] Modular .psm1 file
- [x] Comment-based help for each function
- [ ] Add parameter validation across all utilities
- [ ] Add function tests
- [ ] Publish to PowerShell Gallery

## 👤 Author

**Christopher "Rowdy" Yates**  
IT Support Specialist • Chaos Administrator • Aspiring Automation Wrangler
> "Support is chaos, but the logs shouldn't be."