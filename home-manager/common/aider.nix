{
  pkgs,
  myEnv,
  myLib,
  lib,
  secrets,
  ...
}:
with myEnv;
{
  home.file = {
    "${homeDir}/.config/aider/aider.conf.yml".source = ./config_files/aider/aider.conf.yml;
    "${homeDir}/.config/aider/aider.model.settings.yml".source =
      ./config_files/aider/aider.model.settings.yml;
    # "${homeDir}/.config/aider/aider.env".text = ''
    #   OPENAI_API_KEY=${secrets.openai.apiKey}
    #   DEEPSEEK_API_KEY=${secrets.deepseek.apiKey}
    #   ANTHROPIC_API_KEY=${secrets.anthropic.apiKey}
    # '';
  };
}
