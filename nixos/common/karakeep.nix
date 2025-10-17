{
  myEnv,
  myLib,
  secrets,
  config,
  pkgs,
  lib,
  ...
}:
{
  services.karakeep = {
    enable = true;
    package = pkgs.lts.karakeep;
    meilisearch.enable = true;
    extraEnvironment = {
      PORT = "19876";
      DISABLE_SIGNUPS = "true";
      OPENAI_API_KEY = secrets.openai.apiKey;
      INFERENCE_TEXT_MODEL = "gpt-5";
      INFERENCE_IMAGE_MODEL = "gpt-5";
      NEXTAUTH_URL = "http://${secrets.nodes.homeServer.localIp}";
      # NEXTAUTH_URL = "http://0:0:0:0";
      DISABLE_NEW_RELEASE_CHECK = "true";
      INFERENCE_ENABLE_AUTO_TAGGING = "false";
      INFERENCE_ENABLE_AUTO_SUMMARIZATION = "false";
      INFERENCE_CONTEXT_LENGTH = "32768";
    };
  };
}
