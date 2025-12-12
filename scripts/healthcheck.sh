#!/bin/bash

# VM Health Check Script
# This script checks CPU usage, memory usage, disk space, system uptime, and load average
# Usage: ./healthcheck.sh [explain]

set -o pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display explanations of health parameters
explain_parameters() {
    cat << EOF
${BLUE}═══════════════════════════════════════════════════════════════${NC}
${BLUE}  VM HEALTH CHECK PARAMETERS - DETAILED EXPLANATIONS${NC}
${BLUE}═══════════════════════════════════════════════════════════════${NC}

${GREEN}1. CPU USAGE${NC}
   ${YELLOW}Definition:${NC} Percentage of CPU processing capacity currently in use.
   
   ${YELLOW}How to interpret:${NC}
   • 0-30%     : Low usage - System has plenty of CPU resources available
   • 30-70%    : Moderate usage - System is operating normally
   • 70-90%    : High usage - System is under moderate load
   • 90-100%   : Critical - System is near full capacity
   
   ${YELLOW}What to do:${NC}
   • If consistently high, identify resource-hungry processes
   • Consider scaling up or optimizing applications
   • Check for runaway processes or infinite loops

${GREEN}2. MEMORY USAGE${NC}
   ${YELLOW}Definition:${NC} Percentage of RAM currently allocated and in use.
   
   ${YELLOW}How to interpret:${NC}
   • 0-50%     : Healthy - Plenty of available RAM
   • 50-80%    : Moderate - System is using memory efficiently
   • 80-95%    : High - Consider freeing up memory
   • 95-100%   : Critical - System may experience slowdowns or crashes
   
   ${YELLOW}What to do:${NC}
   • Monitor swap usage to detect memory pressure
   • Kill unnecessary processes consuming memory
   • Increase RAM capacity if consistently high

${GREEN}3. DISK SPACE USAGE${NC}
   ${YELLOW}Definition:${NC} Percentage of disk capacity used across all mounted filesystems.
   
   ${YELLOW}How to interpret:${NC}
   • 0-70%     : Safe - Adequate free space available
   • 70-85%    : Warning - Monitor disk usage closely
   • 85-95%    : Critical - Urgently free up space
   • 95-100%   : Emergency - System may fail to operate
   
   ${YELLOW}What to do:${NC}
   • Delete old logs or temporary files
   • Archive old data to external storage
   • Expand disk capacity if frequently near capacity
   • Clean up unused packages and applications

${GREEN}4. SYSTEM UPTIME${NC}
   ${YELLOW}Definition:${NC} Time elapsed since the system was last rebooted.
   
   ${YELLOW}How to interpret:${NC}
   • < 1 day   : Recently started/rebooted
   • 1-30 days : Normal operation period
   • 30+ days  : Long-running system
   • Sudden drops : Indicates unexpected reboots or crashes
   
   ${YELLOW}What to do:${NC}
   • Track unexpected downtime for troubleshooting
   • Plan maintenance windows for updates
   • High uptime may mean missing important security patches
   • Consider periodic reboots for system stability

${GREEN}5. LOAD AVERAGE${NC}
   ${YELLOW}Definition:${NC} Average number of processes waiting for CPU (over 1, 5, and 15 minutes).
   
   ${YELLOW}How to interpret:${NC}
   • Load < CPU cores : System can handle current processes
   • Load = CPU cores : System is at capacity
   • Load > CPU cores : System is overloaded, processes waiting
   
   Example: For a 4-core system:
   • Load 2.0  : Using 50% of CPU capacity
   • Load 4.0  : Using 100% of CPU capacity (at capacity)
   • Load 8.0  : Overloaded, 4.0 processes waiting in queue
   
   ${YELLOW}What to do:${NC}
   • Check 1-minute average for immediate status
   • Compare with 5 and 15-minute averages for trends
   • High load with low CPU usage suggests disk I/O issues

${BLUE}═══════════════════════════════════════════════════════════════${NC}

${YELLOW}THRESHOLDS SUMMARY:${NC}

Status Colors Used in Output:
  ${GREEN}✓ GREEN${NC}   : Healthy - Parameter within normal range
  ${YELLOW}⚠ YELLOW${NC}  : Warning - Parameter approaching threshold
  ${RED}✗ RED${NC}     : Critical - Parameter exceeds safe limits

EOF
}

# Function to get CPU usage
get_cpu_usage() {
    local cpu_usage
    # Get CPU usage from /proc/stat (average across all cores)
    cpu_usage=$(awk '/^cpu / {
        user=$2; nice=$3; system=$4; idle=$5;
        total=user+nice+system+idle;
        printf "%.1f", (100 * (total-idle) / total)
    }' /proc/stat 2>/dev/null)
    
    echo "${cpu_usage:-N/A}"
}

# Function to get memory usage
get_memory_usage() {
    local mem_usage
    # Get memory usage from /proc/meminfo
    mem_usage=$(awk '/^MemTotal:/ {total=$2} /^MemAvailable:/ {avail=$2} 
        END {printf "%.1f", (100 * (total-avail) / total)}' /proc/meminfo 2>/dev/null)
    
    echo "${mem_usage:-N/A}"
}

# Function to get disk space usage
get_disk_usage() {
    local disk_usage
    # Get disk usage for root filesystem
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    echo "${disk_usage:-N/A}"
}

# Function to get system uptime
get_system_uptime() {
    local uptime_seconds
    local days hours minutes
    
    uptime_seconds=$(awk '{print int($1)}' /proc/uptime 2>/dev/null)
    
    if [ -z "$uptime_seconds" ]; then
        echo "N/A"
        return
    fi
    
    days=$((uptime_seconds / 86400))
    hours=$(((uptime_seconds % 86400) / 3600))
    minutes=$(((uptime_seconds % 3600) / 60))
    
    echo "${days}d ${hours}h ${minutes}m"
}

# Function to get load average
get_load_average() {
    local load_avg
    load_avg=$(awk '{printf "%.2f, %.2f, %.2f", $1, $2, $3}' /proc/loadavg 2>/dev/null)
    
    echo "${load_avg:-N/A}"
}

# Function to get CPU core count
get_cpu_cores() {
    local cores
    cores=$(grep -c "^processor" /proc/cpuinfo 2>/dev/null)
    echo "${cores:-N/A}"
}

# Function to determine status color based on threshold
get_status_color() {
    local value=$1
    local warning_threshold=$2
    local critical_threshold=$3
    
    # Check if value is a number
    if ! [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        echo -e "${BLUE}?"
        return
    fi
    
    # Compare values
    if (( $(echo "$value >= $critical_threshold" | bc -l) )); then
        echo -e "${RED}✗"
    elif (( $(echo "$value >= $warning_threshold" | bc -l) )); then
        echo -e "${YELLOW}⚠"
    else
        echo -e "${GREEN}✓"
    fi
}

# Function to display health check results
display_health_check() {
    local cpu_usage=$(get_cpu_usage)
    local mem_usage=$(get_memory_usage)
    local disk_usage=$(get_disk_usage)
    local uptime=$(get_system_uptime)
    local load_avg=$(get_load_average)
    local cpu_cores=$(get_cpu_cores)
    
    local cpu_status=$(get_status_color "$cpu_usage" 70 90)
    local mem_status=$(get_status_color "$mem_usage" 80 95)
    local disk_status=$(get_status_color "$disk_usage" 85 95)
    local load_1=$(echo "$load_avg" | cut -d',' -f1)
    local load_status=$(get_status_color "$load_1" "$cpu_cores" "$((cpu_cores * 2))")
    
    cat << EOF
${BLUE}═══════════════════════════════════════════════════════════════${NC}
${BLUE}  VM HEALTH CHECK REPORT${NC}
${BLUE}═══════════════════════════════════════════════════════════════${NC}

${BLUE}System Information:${NC}
  Hostname      : $(hostname 2>/dev/null || echo "N/A")
  CPU Cores     : $cpu_cores
  Current Time  : $(date '+%Y-%m-%d %H:%M:%S')

${BLUE}Health Parameters:${NC}

  ${cpu_status} CPU Usage         : ${cpu_usage}%
  ${mem_status} Memory Usage      : ${mem_usage}%
  ${disk_status} Disk Usage        : ${disk_usage}%
  System Uptime     : $uptime
  ${load_status} Load Average      : $load_avg
    (1m, 5m, 15m average - system has $cpu_cores cores)

${BLUE}Status Legend:${NC}
  ${GREEN}✓${NC} Green  : Healthy
  ${YELLOW}⚠${NC} Yellow : Warning
  ${RED}✗${NC} Red    : Critical

${BLUE}═══════════════════════════════════════════════════════════════${NC}

For detailed explanations, run: ${YELLOW}./healthcheck.sh explain${NC}

EOF
}

# Main script logic
main() {
    # Check if help/explain argument is provided
    case "${1,,}" in
        explain|--explain|-e|help|--help|-h)
            explain_parameters
            ;;
        "")
            # No arguments - show health check
            display_health_check
            ;;
        *)
            echo -e "${RED}Error: Unknown argument '$1'${NC}"
            echo "Usage: $0 [explain]"
            echo ""
            echo "Examples:"
            echo "  $0           # Display health check report"
            echo "  $0 explain   # Display detailed parameter explanations"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
