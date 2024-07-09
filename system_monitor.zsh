#!/bin/zsh

# Function to get CPU usage
get_cpu_usage() {
    local cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3 + $5}')
    echo "CPU Usage: $cpu_usage%"
}

# Function to get Memory usage
get_memory_usage() {
    local mem_used=$(vm_stat | grep 'Pages active' | awk '{print $3}' | sed 's/\.//')
    local mem_free=$(vm_stat | grep 'Pages free' | awk '{print $3}' | sed 's/\.//')
    local mem_total=$(vm_stat | grep 'Pages wired down' | awk '{print $4}' | sed 's/\.//')
    mem_total=$((mem_total + mem_used + mem_free))
    local mem_usage=$(echo "scale=2; ($mem_used + $mem_total)*4/1024/1024" | bc)
    echo "Memory Usage: $(($mem_used*4/1024)) MB / $((($mem_used + $mem_total)*4/1024)) MB ($mem_usage%)"
}

# Function to get Disk usage
get_disk_usage() {
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}')
    echo "Disk Usage: $disk_usage"
}

# Function to get Network activity
get_network_activity() {
    local net_activity=$(netstat -ib | awk '/en0/{print "In: " $7/1024 " KB, Out: " $10/1024 " KB"}')
    echo "Network Activity: $net_activity"
}

# Main monitoring function
monitor_system() {
    echo "System Monitoring Report"
    echo "-------------------------"
    get_cpu_usage
    get_memory_usage
    get_disk_usage
    get_network_activity
    echo "-------------------------"
}

# Run the monitoring function
monitor_system
