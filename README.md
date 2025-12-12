# VM Health Check Script

A comprehensive Bash script to monitor and report on critical VM (Virtual Machine) health parameters in real-time.

## Features

✅ **CPU Usage Monitoring** - Track processor utilization  
✅ **Memory Usage Tracking** - Monitor RAM consumption  
✅ **Disk Space Analysis** - Check filesystem utilization  
✅ **System Uptime** - Display time since last reboot  
✅ **Load Average** - Monitor system load across time intervals  
✅ **Color-Coded Status** - Visual indicators (Green/Yellow/Red)  
✅ **Detailed Explanations** - Educational mode for understanding metrics  
✅ **Clean Formatting** - Professional, readable output  

## Quick Start

### 1. Clone or Download the Repository

```bash
git clone https://github.com/yourusername/ai-task-health.git
cd ai-task-health
```

### 2. Make the Script Executable

```bash
chmod +x scripts/healthcheck.sh
```

### 3. Run the Health Check

```bash
# Display current health status
./scripts/healthcheck.sh

# Display detailed parameter explanations
./scripts/healthcheck.sh explain
```

## Usage

### Basic Health Check

```bash
./scripts/healthcheck.sh
```

**Output Example:**
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
    (1m, 5m, 15m average - system has 4 cores)

Status Legend:
  ✓ Green  : Healthy
  ⚠ Yellow : Warning
  ✗ Red    : Critical

═══════════════════════════════════════════════════════════════

For detailed explanations, run: ./healthcheck.sh explain
```

### Explanation Mode

```bash
./scripts/healthcheck.sh explain
```

This displays comprehensive explanations of each health parameter:
- What each metric means
- How to interpret the values
- Action items when thresholds are exceeded
- Detailed examples for understanding load average

## Health Parameters Reference

### 1. **CPU Usage**
- **Healthy**: 0-30%
- **Moderate**: 30-70%
- **Warning**: 70-90%
- **Critical**: 90-100%

### 2. **Memory Usage**
- **Healthy**: 0-50%
- **Moderate**: 50-80%
- **Warning**: 80-95%
- **Critical**: 95-100%

### 3. **Disk Space**
- **Safe**: 0-70%
- **Warning**: 70-85%
- **Critical**: 85-95%
- **Emergency**: 95-100%

### 4. **System Uptime**
- Less frequent reboots indicate stability
- Watch for unexpected downtime
- Consider periodic reboots for security patches

### 5. **Load Average**
- Displayed as (1m, 5m, 15m) averages
- **Normal**: Load ≤ Number of CPU cores
- **Overloaded**: Load > Number of CPU cores
- Compare against system's core count

## Status Indicators

The script uses color-coded status symbols:

| Symbol | Color  | Meaning        |
|--------|--------|----------------|
| ✓      | Green  | Healthy        |
| ⚠      | Yellow | Warning        |
| ✗      | Red    | Critical       |
| ?      | Blue   | Unknown/Info   |

## Requirements

- **Bash 4.0+** - Most Linux distributions come with this
- **Linux System** - Script reads from `/proc` filesystem (Linux-specific)
- **Standard Utilities**:
  - `awk` - Text processing
  - `grep` - Pattern matching
  - `bc` - Basic calculator
  - `df` - Disk usage
  - `hostname` - System name
  - `date` - Current time

## Installation Methods

### Method 1: Clone from GitHub
```bash
git clone https://github.com/yourusername/ai-task-health.git
cd ai-task-health
chmod +x scripts/healthcheck.sh
```

### Method 2: Download Standalone Script
```bash
curl -O https://raw.githubusercontent.com/yourusername/ai-task-health/main/scripts/healthcheck.sh
chmod +x healthcheck.sh
```

### Method 3: Install to System Path (Optional)
```bash
sudo cp scripts/healthcheck.sh /usr/local/bin/healthcheck
sudo chmod +x /usr/local/bin/healthcheck

# Now you can run from anywhere:
healthcheck
healthcheck explain
```

## Scheduling Regular Checks

### Using Cron for Periodic Monitoring

```bash
# Edit crontab
crontab -e

# Add one of these lines:

# Run every hour
0 * * * * /path/to/scripts/healthcheck.sh > /var/log/healthcheck.log

# Run every 30 minutes
*/30 * * * * /path/to/scripts/healthcheck.sh >> /var/log/healthcheck.log

# Run daily at 6 AM
0 6 * * * /path/to/scripts/healthcheck.sh > /var/log/healthcheck.log
```

### Using Systemd Timer (Alternative)

Create `/etc/systemd/system/healthcheck.timer`:
```ini
[Unit]
Description=VM Health Check Timer
Requires=healthcheck.service

[Timer]
OnBootSec=15min
OnUnitActiveSec=30min
Persistent=true

[Install]
WantedBy=timers.target
```

## Troubleshooting

### Issue: Permission Denied
```bash
chmod +x scripts/healthcheck.sh
```

### Issue: Command Not Found
```bash
# Use relative path:
./scripts/healthcheck.sh

# Or add to PATH:
export PATH=$PATH:$(pwd)/scripts
healthcheck.sh
```

### Issue: Missing bc Command
```bash
# Ubuntu/Debian
sudo apt-get install bc

# RHEL/CentOS
sudo yum install bc
```

### Issue: Some Metrics Show "N/A"
- Ensure running on Linux (script uses `/proc` filesystem)
- Check file permissions for `/proc/` access
- Some restricted environments may not allow reading `/proc` files

## Project Structure

```
ai-task-health/
├── scripts/
│   └── healthcheck.sh          # Main health check script
├── docs/
│   └── EXPLANATION.md          # Detailed parameter explanations
├── README.md                   # This file
├── .gitignore                  # Git ignore rules
├── LICENSE                     # MIT License
└── CHANGELOG.md                # Version history
```

## Examples

### Check system health every 5 minutes
```bash
while true; do
    clear
    ./scripts/healthcheck.sh
    sleep 300
done
```

### Log health checks with timestamps
```bash
while true; do
    echo "=== Check at $(date) ===" >> health.log
    ./scripts/healthcheck.sh >> health.log 2>&1
    sleep 600
done
```

### Alert when metrics exceed thresholds
```bash
#!/bin/bash
# Custom alert script
./scripts/healthcheck.sh | grep -i "critical" && \
    echo "ALERT: Critical health issues detected!" | \
    mail -s "VM Health Alert" admin@example.com
```

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages (`git commit -am 'Add feature'`)
6. Push to the branch (`git push origin feature/improvement`)
7. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

## Support

For issues, questions, or suggestions:
- Open an [Issue](https://github.com/yourusername/ai-task-health/issues)
- Check [Discussions](https://github.com/yourusername/ai-task-health/discussions)
- Review [Documentation](docs/)

## Author

Created as part of DevOps and system administration practices for monitoring VM health.

---

**Last Updated**: December 2025  
**Version**: 1.0.0  
**Status**: Active Development
