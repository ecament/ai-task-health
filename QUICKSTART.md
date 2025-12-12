# Quick Start Guide

Get up and running with the VM Health Check script in 2 minutes!

## Installation

### 1. Clone or Download

```bash
# Clone from GitHub
git clone https://github.com/yourusername/ai-task-health.git
cd ai-task-health

# Or download the script directly
wget https://raw.githubusercontent.com/yourusername/ai-task-health/main/scripts/healthcheck.sh
chmod +x healthcheck.sh
```

### 2. Make Executable

```bash
chmod +x scripts/healthcheck.sh
```

## Basic Usage

### Run Health Check

```bash
./scripts/healthcheck.sh
```

**Output:**
```
═══════════════════════════════════════════════════════════════
  VM HEALTH CHECK REPORT
═══════════════════════════════════════════════════════════════

System Information:
  Hostname      : myserver
  CPU Cores     : 4
  Current Time  : 2025-12-11 14:23:45

Health Parameters:

  ✓ CPU Usage         : 45.2%
  ✓ Memory Usage      : 62.5%
  ✓ Disk Usage        : 78%
  System Uptime     : 45d 3h 22m
  ✓ Load Average      : 1.23, 1.45, 1.67
```

### Get Detailed Explanations

```bash
./scripts/healthcheck.sh explain
```

Shows comprehensive explanations of each parameter with:
- What the metric means
- How to interpret values
- Action items when thresholds are exceeded
- Practical examples

## Common Use Cases

### Monitor Every 5 Minutes

```bash
while true; do
    clear
    ./scripts/healthcheck.sh
    sleep 300
done
```

### Log Health Checks

```bash
./scripts/healthcheck.sh >> healthcheck.log
```

### Check Specific Metric

```bash
# Extract just CPU usage from output
./scripts/healthcheck.sh | grep "CPU Usage"
```

### Schedule with Cron

```bash
# Run hourly
0 * * * * /path/to/scripts/healthcheck.sh >> /var/log/healthcheck.log

# Run every 30 minutes
*/30 * * * * /path/to/scripts/healthcheck.sh >> /var/log/healthcheck.log
```

## Understanding the Output

### Status Indicators

| Symbol | Meaning |
|--------|---------|
| ✓ Green | Healthy - All good |
| ⚠ Yellow | Warning - Approaching limits |
| ✗ Red | Critical - Action needed |

### Quick Reference

- **CPU Usage**: 0-70% is healthy
- **Memory**: 0-80% is healthy
- **Disk**: 0-85% is safe
- **Load**: Should be ≤ number of CPU cores

## Troubleshooting

### Permission Denied

```bash
chmod +x scripts/healthcheck.sh
```

### Command Not Found

```bash
# Use full path
/home/user/ai-task-health/scripts/healthcheck.sh

# Or add to PATH
export PATH=$PATH:$(pwd)/scripts
```

### Metrics Show N/A

- Must run on Linux system (uses `/proc` filesystem)
- Some metrics may not be available in restricted environments

## Next Steps

1. **Read Full Documentation**: See [README.md](README.md)
2. **Learn About Metrics**: Check [docs/EXPLANATION.md](docs/EXPLANATION.md)
3. **Run Tests**: `bash scripts/test.sh`
4. **Customize**: Edit thresholds in the script as needed
5. **Automate**: Set up cron jobs or systemd timers for periodic checks

## File Structure

```
ai-task-health/
├── scripts/
│   ├── healthcheck.sh      ← Main script
│   └── test.sh             ← Test script
├── docs/
│   └── EXPLANATION.md      ← Detailed parameter guide
├── README.md               ← Full documentation
├── QUICKSTART.md           ← This file
├── CHANGELOG.md            ← Version history
├── LICENSE                 ← MIT License
└── .gitignore             ← Git ignore rules
```

## Support

- 📖 See [README.md](README.md) for detailed documentation
- 📚 Read [docs/EXPLANATION.md](docs/EXPLANATION.md) for metric explanations
- 🐛 Report issues on GitHub Issues
- 💬 Ask questions in Discussions

---

**Need help?** Run `./scripts/healthcheck.sh explain` to learn about each metric!

**Version**: 1.0.0  
**Last Updated**: December 2025
