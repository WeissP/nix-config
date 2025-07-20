def open-json [file: path] {
   open $file --raw | from json | default {}
}

def "nu-complete activities" [] {
   open-json $env.ACTIVITY_TRACKER_FILE | columns 
}

def format-date [d: datetime] {
   $d | format date '%Y-%m-%d'
}

def gen_date_completion [d: datetime, name: string] {
  {value: $d, description: $name }
}

def "nu-complete activity_date" [] {
   let today = date now
   let gen_desc = {|d, name| $"($name) \(format $d)" }
    {
        options: {
            case_sensitive: false,
            sort: false,
        },
        completions: [
          (gen_date_completion ($today - 1day) "yesteday")
          (gen_date_completion ($today - 2day) "Today - 2day")
          (gen_date_completion $today "today")
        ]
    }
}

def insert-activity [activity: string, activity_date: datetime] {
   {|content|
   $content 
   | upsert $activity { $in | default [] | append (format-date $activity_date)}
   }
}
 
def insert-activities [activities: list<string>, activity_date: datetime] {
   {|content|
   $activities
   | reduce --fold $content {|act, res| do (insert-activity $act $activity_date) $res }
   }
}

def gen-report [content: record, start_date: datetime, end_date: datetime] {
    let num_days = (($end_date - $start_date) / 1day | into int)
    let dates_in_range = (0..$num_days | each {|i| $start_date + ($i * 1day)})

    let activities_in_range = $content
        | columns
        | where {|activity_name|
            let dates_for_activity = ($content | get $activity_name)
            $dates_for_activity | any {|d|
                let activity_date = ($d | into datetime)
                $activity_date >= $start_date and $activity_date <= $end_date
            }
        }

    if ($activities_in_range | is-empty) {
        return []
    }

    let activity_table = $activities_in_range | wrap activity

    let date_tables = $dates_in_range | each {|d|
        let full_date_str = (format-date $d)
        let col_header = ($d | format date '%d')
        let markers = $activities_in_range | each {|activity_name|
            let activity_dates = ($content | get $activity_name)
            if ($full_date_str in $activity_dates) { "✔" } else { "" }
        }
        $markers | wrap $col_header
    }

    if ($date_tables | is-empty) {
        return $activity_table
    }

    let merged_date_table = $date_tables | reduce {|item, acc| $acc | merge $item }

    $activity_table | merge $merged_date_table
}

export def view [--start-date: datetime, --end-date: datetime, --duration: duration] {
    let file_path = $env.ACTIVITY_TRACKER_FILE
    let content = open-json $file_path

    let end_date = if ($duration | is-not-empty) {
        (date now)
    } else {
        $end_date | default (date now)
    }

    let start_date = if ($duration | is-not-empty) {
        $end_date - $duration
    } else {
        $start_date | default ($end_date - 6day)
    }

    gen-report $content $start_date $end_date
}

export def main [...activities: string@"nu-complete activities", --date: datetime@"nu-complete activity_date", --yesterday] {
 let file_path = $env.ACTIVITY_TRACKER_FILE
 let content = open-json $file_path
 let activity_date = if $yesterday {
    (date now) - 1day
 } else {
    $date | default (date now)
 }
 
 do (insert-activities $activities $activity_date) $content
 | to json
 | save --force $file_path
 | view --duration 10day
}
