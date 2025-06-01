{
  pkgs,
  lib,
  secrets,
  ...
}:
(pkgs.writers.writeNuBin "notify" ''
  const topics = ${secrets.ntfy.topicRecordInNu}
  # Sends a notification via ntfy.
  def main [
      topic_alias: string, # The alias for the ntfy topic
      msg: string, # The message content to send
      --title(-t): string, # title for the notification. Defaults to title-cased topic_alias
      --priority(-p): int = 3 # Optional priority for the notification (1-5, default: 3)
  ] {
      (^${pkgs.ntfy-sh}/bin/ntfy publish 
          -p $priority 
          -t ($title | default ($topic_alias | str title-case)) 
          ($topics | get $topic_alias) 
          $msg)
  }
'')
