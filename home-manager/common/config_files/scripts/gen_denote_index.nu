const MEILI_HOST = "http://192.168.2.33:7700"
const INDEX_NAME = "notes"
const INDEX_UID = $INDEX_NAME
const ROOT_DIR = "/home/weiss/Documents/notes-export/notes"

def is_denote [name: string] {
  $name =~ '\d{8}T\d{6}'
}

def is_sync_conflict [name: string] {
  $name | str contains "sync-conflict"
}

def parse_denote [name: string] {
 let path_parsed = $name | path parse
 let regex = '^(?<timestamp>\d{8}T\d{6})(?:==(?<sig>.+))?--(?<title>.+?)(?:__(?<keywords>\w+))?$'
 $path_parsed.stem | parse --regex $regex | first
}

def meili_doc [p: path] {
 let path_parsed = $p | path parse
 let regex = '^(?<timestamp>\d{8}T\d{6})(?:==(?<sig>.+))?--(?<title>.+?)(?:__(?<keywords>\w+))?$'
 let parsed =  $path_parsed.stem | parse --regex $regex | first
 {
   path: ($p | path relative-to $ROOT_DIR)
   id: $parsed.timestamp
   sig: $parsed.sig 
   title: ($parsed.title | str replace --all "-" " " ) 
   keywords: ($parsed.keywords | default "" | split row "_")  
 }
}

def update_meili_index [] {
ls -f ...(glob $"($ROOT_DIR)/**/*.html")
| get name
| where {(is_denote $in) and not (is_sync_conflict $in)}
| each {meili_doc $in}
| to json
| http post $"($MEILI_HOST)/indexes/($INDEX_UID)/documents?primaryKey=id" 
}

export def main [] {
 update_meili_index
}
 
export def meili_get_all_docs [] {
 http post $"($MEILI_HOST)/indexes/($INDEX_UID)/documents/fetch" --content-type application/json {limit: 99999}
}

export def meili_index_setting [] {
 http put $"($MEILI_HOST)/indexes/($INDEX_UID)/settings/filterable-attributes" --content-type application/json [ "id", "sig", "title", "keywords" ]
}
