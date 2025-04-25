# UtilityBelt-PS

A growing collection of tools, scripts, and modules to simplify IT support, automation, and system management tasks.

This repo is built to scale: each component lives in its own folder with a dedicated README and a clean separation of concerns.

## 📁 Modules

### [PowerShell Toolkit](./utilityprocs)

A reusable PowerShell module designed to support IT automation and diagnostics with clean logging, graceful exits, and data import helpers.

Includes:

- `Write-Log` – structured logging with timestamps and formatting
- `Exit-Nicely` – graceful script termination with final log output
- `Read-Ref` – reads and logs data from CSV reference files
- `Set-Path` – sets a scoped, timestamped log path based on script location

📖 [View full documentation](./utilityprocs/README.md)



## 🧭 Roadmap

- [x] Modular PowerShell release
- [ ] Automate jumplists for consistency between devices
- [ ] Clear OneNote cache
- [ ] Check event logs for the UPS's last test date

## 👤 Author

**Christopher "Rowdy" Yates**  
IT Support Specialist • Chaos Administrator • Aspiring Automation Wrangler
> "Support is chaos, but the logs shouldn't be."
