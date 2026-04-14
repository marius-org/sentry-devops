#!/bin/bash

# Log Rotation Script
# Retains logs for the last 5 days, archives and compresses older logs
# Designed to be idempotent and handle edge cases

LOG_FILE="/var/log/application.log"
ARCHIVE_DIR="/var/log/archive"
RETENTION_DAYS=5
DATE=$(date +%Y%m%d)
SCRIPT_NAME=$(basename "$0")

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$SCRIPT_NAME] $1"
}

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    log "WARNING: Log file $LOG_FILE not found. Nothing to rotate."
    exit 0
fi

# Check permissions
if [ ! -r "$LOG_FILE" ]; then
    log "ERROR: No read permission on $LOG_FILE"
    exit 1
fi

# Create archive directory if it doesn't exist
if [ ! -d "$ARCHIVE_DIR" ]; then
    log "Creating archive directory $ARCHIVE_DIR"
    mkdir -p "$ARCHIVE_DIR"
    if [ $? -ne 0 ]; then
        log "ERROR: Failed to create archive directory $ARCHIVE_DIR"
        exit 1
    fi
fi

# Archive current log file with date stamp (idempotent check)
ARCHIVE_FILE="$ARCHIVE_DIR/application.log.$DATE"

if [ ! -f "${ARCHIVE_FILE}.gz" ]; then
    log "Archiving current log to $ARCHIVE_FILE"
    cp "$LOG_FILE" "$ARCHIVE_FILE"

    # Compress the archive
    gzip "$ARCHIVE_FILE"
    if [ $? -ne 0 ]; then
        log "ERROR: Failed to compress archive"
        exit 1
    fi
    log "Log archived and compressed to ${ARCHIVE_FILE}.gz"

    # Truncate the active log file without interrupting the writer
    cat /dev/null > "$LOG_FILE"
    log "Active log file truncated"
else
    log "Archive for today already exists. Skipping archival."
fi

# Delete archives older than retention period
log "Cleaning up archives older than $RETENTION_DAYS days"
find "$ARCHIVE_DIR" -name "application.log.*.gz" -mtime +$RETENTION_DAYS -delete
if [ $? -eq 0 ]; then
    log "Cleanup completed successfully"
else
    log "ERROR: Cleanup failed"
    exit 1
fi

log "Log rotation completed successfully"
exit 0