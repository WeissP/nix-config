const LOG_LEVEL = {
    "CRITICAL": 50,
    "ERROR": 40,
    "WARNING": 30,
    "INFO": 20,
    "DEBUG": 10
}

const LOG_PREFIX = {
    "CRITICAL": "CRT",
    "ERROR": "ERR",
    "WARNING": "WRN",
    "INFO": "INF",
    "DEBUG": "DBG"
}

# File Logging Module
#
# This module provides utilities for logging messages to a file.
#
# Environment Variables:
# - NU_LOG_FILE: Path to the default log file. Set with `log-file set-log-file <path>`.
# - NU_FILE_LOG_LEVEL: Minimum log level to record (CRITICAL, ERROR, WARNING, INFO, DEBUG, or corresponding integer). Set with `log-file set-level <level>`.
# - NU_LOGFILE_FORMAT: Format string for log messages. Default: "%DATE%|%LEVEL%|%MSG%"
# - NU_LOG_DATE_FORMAT: Format string for dates in logs. Default: "%Y-%m-%dT%H:%M:%S%.3f"
#
# Log Formatting Placeholders:
# - %MSG%: The message to be logged.
# - %DATE%: Timestamp of the log entry.
# - %LEVEL%: String prefix for the log level (e.g., "INFO", "ERR").
#
# Example usage:
#   use logfile.nu
#   logfile set-log-file "my_app.log"
#   logfile set-level INFO
#   logfile info "Application started"

export-env { 
    $env.NU_LOGFILE_FORMAT = $env.NU_LOGFILE_FORMAT? | default "%DATE%|%LEVEL%|%MSG%"
    $env.NU_LOG_DATE_FORMAT = $env.NU_LOG_DATE_FORMAT? | default "%Y-%m-%dT%H:%M:%S%.3f"
    # NU_FILE_LOG_LEVEL is managed by set-level
    # NU_LOG_FILE is managed by set-log-file
}

const LOG_TYPES = {
    "CRITICAL": {
        "level": $LOG_LEVEL.CRITICAL,
        "prefix": $LOG_PREFIX.CRITICAL
    },
    "ERROR": {
        "level": $LOG_LEVEL.ERROR,
        "prefix": $LOG_PREFIX.ERROR
    },
    "WARNING": {
        "level": $LOG_LEVEL.WARNING,
        "prefix": $LOG_PREFIX.WARNING
    },
    "INFO": {
        "level": $LOG_LEVEL.INFO,
        "prefix": $LOG_PREFIX.INFO
    },
    "DEBUG": {
        "level": $LOG_LEVEL.DEBUG,
        "prefix": $LOG_PREFIX.DEBUG
    }
}

def parse-string-level [
    level_str: string # The string representation of the log level
] {
    let level_str_upper = ($level_str | str upcase)

    if $level_str_upper in [$LOG_PREFIX.CRITICAL "CRIT" "CRITICAL"] {
        $LOG_LEVEL.CRITICAL
    } else if $level_str_upper in [$LOG_PREFIX.ERROR "ERROR"] {
        $LOG_LEVEL.ERROR
    } else if $level_str_upper in [$LOG_PREFIX.WARNING "WARN" "WARNING"] {
        $LOG_LEVEL.WARNING
    } else if $level_str_upper in [$LOG_PREFIX.DEBUG "DEBUG"] {
        $LOG_LEVEL.DEBUG
    } else {
        $LOG_LEVEL.INFO # Default to INFO for unrecognized strings
    }
}

def parse-int-level [
    level_int: int, # The integer representation of the log level
] {
    if $level_int >= $LOG_LEVEL.CRITICAL {
        $LOG_PREFIX.CRITICAL
    } else if $level_int >= $LOG_LEVEL.ERROR {
        $LOG_PREFIX.ERROR
    } else if $level_int >= $LOG_LEVEL.WARNING {
        $LOG_PREFIX.WARNING
    } else if $level_int >= $LOG_LEVEL.INFO {
        $LOG_PREFIX.INFO
    } else {
        $LOG_PREFIX.DEBUG
    }
}

def current-log-level [] {
    let env_level = ($env.NU_FILE_LOG_LEVEL? | default $LOG_LEVEL.INFO)

    try {
        $env_level | into int
    } catch {
        parse-string-level $env_level
    }
}

def now [] {
    date now | format date $env.NU_LOG_DATE_FORMAT
}

def log-level-deduction-error [
    type: string, # Type of deduction error (e.g., "log level prefix")
    span: record<start: int, end: int>, # Span of the problematic log_level argument
    log_level_val: int # The problematic log level value
] {
    error make {
        msg: $"Cannot deduce ($type) for given log level: ($log_level_val)."
        label: {
            text: ([
                 "Invalid log level for automatic deduction."
                $"        Available log levels for deduction in LOG_LEVEL:"
                 ($LOG_LEVEL | to text | lines | each {|it| $"            ($it)" } | to text)
            ] | str join "\n")
            span: $span
        }
    }
}

def _do_log [
    message: string,        # The log message
    log_level_int: int,     # The integer level of this message
    prefix_str: string,     # The prefix string for the level (e.g., "INF", "I")
    format_str: string,     # The log format string
    output_file_path: string # The path to the log file
] {
    if (current-log-level) > $log_level_int {
        return # Don't log if current level is higher than message level
    }

    let formatted_message = (
        $format_str
            | str replace --all "%MSG%" $message
            | str replace --all "%DATE%" (now)
            | str replace --all "%LEVEL%" $prefix_str
    )

    mkdir ($output_file_path | path dirname)
    # Append to file, ensuring a newline
    $"($formatted_message)\n" | save --append $output_file_path
}

# Change logging file
export def --env set-log-file [file: string] {
    $env.NU_LOG_FILE = $file
}

export def main [] {}

export def get_log_file [file?: string] {
   match $file {
   null => (if ("NU_LOG_FILE" in $env) {
             $env.NU_LOG_FILE
             } else {
             (error make --unspanned {msg: "NU_LOG_FILE is unset"})
             })
   _ => $file
  }
}

# Log a critical message to a file
export def critical [
    message: string, # The message to log
    --format (-f): string # Custom format string for this log entry
    --file (-o): string # Specific file to log this entry to (overrides NU_LOG_FILE)
] {
    let log_details = $LOG_TYPES.CRITICAL
    let prefix = $log_details.prefix
    let format = $format | default $env.NU_LOGFILE_FORMAT
    let output_file = get_log_file $file

    _do_log $message $log_details.level $prefix $format $output_file
}

# Log an error message to a file
export def error [
    message: string, # The message to log
    --format (-f): string # Custom format string
    --file (-o): string # Specific file to log to
] {
    let log_details = $LOG_TYPES.ERROR
    let prefix = $log_details.prefix
    let format = $format | default $env.NU_LOGFILE_FORMAT
    let output_file = get_log_file $file

    _do_log $message $log_details.level $prefix $format $output_file
}

# Log a warning message to a file
export def warning [
    message: string, # The message to log
    --format (-f): string # Custom format string
    --file (-o): string # Specific file to log to
] {
    let log_details = $LOG_TYPES.WARNING
    let prefix = $log_details.prefix
    let format = $format | default $env.NU_LOGFILE_FORMAT
    let output_file = get_log_file $file

    _do_log $message $log_details.level $prefix $format $output_file
}

# Log an info message to a file
export def info [
    message: string, # The message to log
    --format (-f): string # Custom format string
    --file (-o): string # Specific file to log to
] {
    let log_details = $LOG_TYPES.INFO
    let prefix = $log_details.prefix
    let format = $format | default $env.NU_LOGFILE_FORMAT
    let output_file = get_log_file $file

    _do_log $message $log_details.level $prefix $format $output_file
}

# Log a debug message to a file
export def debug [
    message: string, # The message to log
    --format (-f): string # Custom format string
    --file (-o): string # Specific file to log to
] {
    let log_details = $LOG_TYPES.DEBUG
    let prefix = $log_details.prefix
    let format = $format | default $env.NU_LOGFILE_FORMAT
    let output_file = get_log_file $file

    _do_log $message $log_details.level $prefix $format $output_file
}

# Log a message with a specific format and verbosity level to a file
export def custom-log [
    message: string, # The message to log
    format_str: string, # Custom format string (see module help for placeholders)
    log_level_int: int, # Integer log level (must be one of LOG_LEVEL values for correct prefix deduction if -p is not used)
    --level-prefix (-p): string # Custom string for the %LEVEL% placeholder
    --file (-o): string # Specific file to log to
] {
    let output_file = get_log_file $file

    let prefix = if ($level_prefix | is-empty) {
        # Deduce prefix if not provided
        let valid_levels_for_deduction = ($LOG_LEVEL | values)
        if ($log_level_int not-in $valid_levels_for_deduction) {
            log-level-deduction-error "log level prefix" (metadata $log_level_int).span $log_level_int
        }
        parse-int-level $log_level_int # Default to long prefix for custom levels
    } else {
        $level_prefix
    }

    _do_log $message $log_level_int $prefix $format_str $output_file
}

def "nu-complete log-level" [] {
    $LOG_LEVEL | transpose description value 
}
 
# Change logging level
export def --env set-level [level: string@"nu-complete log-level"] {
    # Keep it as a string so it can be passed to child processes
    $env.NU_FILE_LOG_LEVEL = parse-string-level $level 
}

