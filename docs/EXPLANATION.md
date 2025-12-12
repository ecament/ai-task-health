# VM Health Check Script - Detailed Explanations

This document provides in-depth information about each health parameter monitored by the healthcheck.sh script.

## Table of Contents

1. [CPU Usage](#cpu-usage)
2. [Memory Usage](#memory-usage)
3. [Disk Space Usage](#disk-space-usage)
4. [System Uptime](#system-uptime)
5. [Load Average](#load-average)
6. [Thresholds and Alerts](#thresholds-and-alerts)
7. [Troubleshooting Guide](#troubleshooting-guide)

---

## CPU Usage

### What It Measures

CPU (Central Processing Unit) usage represents the percentage of the processor's computational capacity that is currently being utilized.

### Understanding the Metric

- **0-30%**: Idle to light usage. The system has significant CPU resources available for additional tasks.
- **30-70%**: Normal operational range. The system is handling regular workloads efficiently.
- **70-90%**: Heavy usage. The system is under significant load but still handling tasks.
- **90-100%**: Critical usage. The system is at or near maximum capacity, which can cause slowdowns.

### Why It Matters

- High CPU usage can indicate:
  - Runaway processes or infinite loops
  - Insufficient system resources for the application
  - Need for optimization or scaling
  - Possible security issues (malicious processes)

### What to Do

**When CPU usage is high (70%+):**
1. Identify which processes are consuming CPU:
   ```bash
   top -n 1 | head -20
   ps aux --sort=-%cpu | head -10
   ```

2. Analyze the process:
   - Is it expected to be running?
   - Is it critical to operations?
   - Can it be optimized or terminated?

3. Take action:
   - Kill unnecessary processes
   - Restart problematic applications
   - Increase system capacity
   - Optimize application code or configuration

### Example Interpretation

```
CPU Usage: 85%
- Status: ⚠ Warning
- Action: Monitor closely, investigate if sustained
- Likely causes: Batch processing, compilation, video encoding
```

---

## Memory Usage

### What It Measures

Memory (RAM) usage represents the percentage of available system memory (RAM) that is currently in use.

### Understanding the Metric

- **0-50%**: Healthy. The system has ample available memory.
- **50-80%**: Moderate. The system is using memory efficiently with room to spare.
- **80-95%**: High. The system is approaching memory constraints.
- **95-100%**: Critical. The system may experience performance degradation or crashes.

### Why It Matters

- Memory is crucial for:
  - Application performance
  - System stability
  - Preventing out-of-memory (OOM) errors
  - Swap usage (slower disk-based memory)

### Key Concepts

**Virtual Memory (Swap)**
- When RAM is full, the OS uses disk space (swap) as backup
- Swap is much slower than RAM (disk I/O vs RAM speeds)
- High swap usage indicates memory pressure

**Memory Types in /proc/meminfo**
- **MemTotal**: Total available RAM
- **MemAvailable**: Estimated available memory for new processes
- **MemFree**: Unused RAM
- **Cached**: Memory used for file cache (can be freed if needed)

### What to Do

**When memory usage is high (80%+):**
1. Check for memory leaks:
   ```bash
   free -h
   ps aux --sort=-%mem | head -10
   ```

2. Monitor swap usage:
   ```bash
   swapon -s
   cat /proc/swaps
   vmstat 1 5
   ```

3. Take action:
   - Identify and stop non-essential services
   - Increase available RAM
   - Optimize application memory usage
   - Configure memory limits for containers/services
   - Clear caches (caution: may impact performance)

### Example Interpretation

```
Memory Usage: 92%
- Status: ✗ Critical
- Action: Immediate attention required
- Likely causes: Unbounded application growth, memory leak
- Impact: System may crash or become unresponsive
```

---

## Disk Space Usage

### What It Measures

Disk space usage represents the percentage of storage capacity on the root filesystem (/) that is currently in use.

### Understanding the Metric

- **0-70%**: Safe zone. Adequate free space available.
- **70-85%**: Warning zone. Monitor closely and plan cleanup.
- **85-95%**: Critical zone. Urgently free up space.
- **95-100%**: Emergency. System may fail to operate.

### Why It Matters

- Adequate disk space is essential for:
  - Application operation and logging
  - Temporary file creation
  - System stability
  - Database operations
  - Cache storage

### Common Space Consumers

1. **Log Files**: `/var/log/` - Can grow rapidly
2. **Temporary Files**: `/tmp/`, `/var/tmp/` - Often forgotten
3. **Database Data**: Application-specific directories
4. **Package Managers**: Old packages and caches
5. **Old Backups**: Archived data taking up space

### What to Do

**When disk usage is high (85%+):**

1. Identify large files and directories:
   ```bash
   du -sh /* | sort -rh
   du -sh /var/log/* | sort -rh
   find / -type f -size +1G 2>/dev/null
   ```

2. Clean up log files:
   ```bash
   # Safely truncate old logs
   find /var/log -name "*.log" -type f -mtime +30 -delete
   # Or use logrotate
   ```

3. Remove temporary files:
   ```bash
   rm -rf /tmp/*
   rm -rf /var/tmp/*
   ```

4. Clean package manager cache:
   ```bash
   # Ubuntu/Debian
   apt-get clean
   apt-get autoclean
   
   # RHEL/CentOS
   yum clean all
   ```

5. Long-term solutions:
   - Set up log rotation with logrotate
   - Archive old data to external storage
   - Expand disk capacity
   - Configure disk quotas for users/applications

### Example Interpretation

```
Disk Usage: 78%
- Status: ⚠ Warning
- Action: Plan cleanup, do not ignore
- Typical free space: ~22GB (assuming 100GB partition)
- Recommendation: Clean up within next 2 weeks
```

---

## System Uptime

### What It Measures

System uptime represents the duration of time since the system was last rebooted, displayed as days, hours, and minutes.

### Understanding the Metric

- **< 1 day**: Recently booted or rebooted system
- **1-30 days**: Normal operational period
- **30+ days**: Long-running system with good stability
- **Sudden drops**: Indicates unexpected reboots or crashes

### Why It Matters

- Uptime indicates:
  - System stability and reliability
  - Unexpected crashes or failures
  - Success of recent updates or maintenance
  - Potential for stale states in long-running services

### Interpreting Uptime

**High Uptime (30+ days)**
- ✓ Positive: System is stable
- ⚠ Note: May have pending security updates
- ⚠ Note: Applications may have stale state
- Recommendation: Schedule periodic maintenance reboots

**Low Uptime (< 1 day)**
- Typical after planned maintenance or updates
- Check if it was intentional or an unexpected crash
- Review system logs for error messages

### What to Do

**Monitor Uptime Trends:**
```bash
# View current uptime
uptime

# View system logs for crashes (systemd systems)
journalctl -b -p err

# View older boot history
journalctl --list-boots

# Check /var/log/syslog for issues
tail -f /var/log/syslog
```

**Plan Maintenance Windows:**
- If uptime exceeds 60 days, consider scheduling a reboot
- Apply security patches periodically
- Updates sometimes require reboots
- Plan reboots during low-usage windows

### Example Interpretation

```
System Uptime: 45d 3h 22m
- Status: Normal, healthy
- Last reboot: ~45 days ago
- Recommendation: Schedule maintenance within next 30 days
```

---

## Load Average

### What It Measures

Load average represents the average number of processes that are either:
1. Currently using the CPU
2. Waiting in the queue to use the CPU

Reported as three values: 1-minute, 5-minute, and 15-minute averages.

### Understanding the Metric

The interpretation depends on your system's number of CPU cores.

**Single-Core System (1 core):**
- Load 0.5: Using 50% of CPU capacity
- Load 1.0: Using 100% of CPU capacity (at capacity)
- Load 2.0: 2 processes waiting (overloaded)

**Multi-Core System (4 cores):**
- Load 2.0: Using 50% of CPU capacity (2 of 4 cores)
- Load 4.0: Using 100% of CPU capacity (all 4 cores busy)
- Load 8.0: 4 processes waiting in queue (overloaded)

### Quick Reference Formula

```
System Status = Load Average / Number of CPU Cores

Load / Cores = 0.5   → System using 50% of CPU capacity
Load / Cores = 1.0   → System at maximum capacity
Load / Cores > 1.0   → System overloaded, processes waiting
```

### Interpreting the Three Averages

- **1-minute average**: Current load status
- **5-minute average**: Recent trend
- **15-minute average**: Historical trend

**Example: Load values 2.0, 1.5, 1.0 on 4-core system**
- 1-min: 2.0 / 4 = 0.5 (50% usage, processes added)
- 5-min: 1.5 / 4 = 0.375 (37.5% usage, load decreasing)
- 15-min: 1.0 / 4 = 0.25 (25% usage, longer-term stable)

This shows: Load is increasing (1-min > 15-min), attention needed.

### Why It Matters

- Load indicates:
  - CPU utilization and bottlenecks
  - Overall system capacity
  - I/O bound vs CPU bound issues
  - Process queuing and scheduling

### Key Differences from CPU Usage

| Aspect | CPU Usage | Load Average |
|--------|-----------|--------------|
| Measures | % of processor busy | Processes in queue |
| Impact | Low = idle | Low = no queuing |
| High values | CPU-bound work | Anything keeping CPU busy |
| Disk I/O | Low CPU usage possible | Can increase load |
| Best for | Instant usage | Sustained trends |

### What to Do

**When load is high:**

1. Correlate with CPU usage:
   ```bash
   # If load high but CPU low: Likely I/O bound
   # If both load and CPU high: CPU bound
   top
   iostat 1 5
   ```

2. Identify process consuming resources:
   ```bash
   ps aux --sort=-%cpu
   ps aux --sort=-%mem
   ```

3. Check for I/O issues:
   ```bash
   # Monitor disk I/O
   iostat -x 1 5
   iotop
   
   # Check for disk errors
   dmesg | grep -i error
   ```

4. Trends to watch:
   - Increasing load over time
   - Load spike at specific hours (scheduled tasks)
   - Load remaining high across all three intervals

### Example Interpretation

```
Load Average: 2.45, 2.10, 1.80 (4-core system)
- 1-minute: 2.45 / 4 = 0.61 (61% capacity)
- 5-minute: 2.10 / 4 = 0.525 (52.5% capacity)
- 15-minute: 1.80 / 4 = 0.45 (45% capacity)
- Trend: Increasing load, but within limits
- Status: ✓ Healthy
- Observation: System utilization gradually increasing
```

---

## Thresholds and Alerts

### Default Thresholds in healthcheck.sh

| Parameter | Green (✓) | Yellow (⚠) | Red (✗) |
|-----------|-----------|-----------|---------|
| CPU Usage | 0-70% | 70-90% | 90-100% |
| Memory | 0-80% | 80-95% | 95-100% |
| Disk Space | 0-85% | 85-95% | 95-100% |
| Load Average | < cores | < 2×cores | > 2×cores |

### Customizing Thresholds

To modify thresholds, edit the `healthcheck.sh` script:

```bash
# Find the status color function and adjust values:
get_status_color() {
    local value=$1
    local warning_threshold=$2     # Customize this
    local critical_threshold=$3    # And this
    ...
}
```

---

## Troubleshooting Guide

### Metrics Show "N/A"

**Cause**: Missing `/proc` files or insufficient permissions

**Solution**:
```bash
# Verify /proc is accessible
ls -la /proc/cpuinfo /proc/meminfo /proc/loadavg

# Check permissions
cat /proc/loadavg  # Should work without sudo
```

### Load Average Interpretation Confusion

**Remember**: Divide by core count!
```bash
# Get core count
nproc
# or
grep -c "^processor" /proc/cpuinfo

# Then divide load by this number
```

### Disk Usage Shows Unexpected Values

**Cause**: Different filesystems or mount points

**Check**:
```bash
df -h          # View all filesystems
df -h /        # Specific to root
du -sh /       # Disk usage of /
```

### High Load but Low CPU Usage

**Cause**: I/O wait or contention

**Diagnose**:
```bash
# Show I/O wait %
top
vmstat 1 5     # Look at 'wa' column

# Identify busy processes
iotop
ps aux
```

### Memory Keeps Growing

**Cause**: Memory leak or unbounded cache

**Investigate**:
```bash
# Monitor memory growth
watch -n 1 'free -h'

# Find processes using memory
ps aux --sort=-%mem | head -10

# Check for leaks
valgrind <process>
```

---

## Additional Resources

- [Linux Documentation Project - Proc Filesystem](https://tldp.org/LDP/Linux-Users-Guide/html/procs.html)
- [Understanding Load Average](https://scoutapm.com/blog/understanding-load-average)
- [Linux Memory Management](https://www.kernel.org/doc/html/latest/admin-guide/mm/)
- [iostat Manual](https://linux.die.net/man/1/iostat)

---

**Last Updated**: December 2025  
**Script Version**: 1.0.0
