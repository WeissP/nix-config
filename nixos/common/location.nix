{
  lib,
  myEnv,
  ...
}:
with myEnv;
lib.mkMerge [
  {
    time.timeZone =
      if location == "china" then
        "Asia/Shanghai"
      else if location == "japan" then
        "Japan"
      else
        "Europe/Berlin";
  }
]
