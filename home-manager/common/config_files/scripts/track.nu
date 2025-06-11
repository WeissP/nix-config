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
 
export def main [...activities: string@"nu-complete activities", --date: datetime@"nu-complete activity_date"] {
 let file_path = $env.ACTIVITY_TRACKER_FILE
 let content = open-json $file_path
 let activity_date = $date | default (date now)
 
 do (insert-activities $activities $activity_date) $content
 | inspect 
 | to json
 | save --force $file_path
}
