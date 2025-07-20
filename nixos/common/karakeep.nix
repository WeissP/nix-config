{
  myEnv,
  myLib,
  secrets,
  pkgs,
  lib,
  ...
}:
{
  services.karakeep = {
    enable = true;
    package = pkgs.lts.karakeep;
    extraEnvironment = {
      PORT = "19876";
      DISABLE_SIGNUPS = "true";
      OPENAI_API_KEY = secrets.openai.apiKey;
      INFERENCE_TEXT_MODEL = "gpt-4.1";
      INFERENCE_IMAGE_MODEL = "gpt-4.1";
      NEXTAUTH_URL = "http://${secrets.nodes.homeServer.localIp}";
      DISABLE_NEW_RELEASE_CHECK = "true";
      INFERENCE_ENABLE_AUTO_SUMMARIZATION = "true";
      INFERENCE_CONTEXT_LENGTH = "32768";
    };
  };
}
