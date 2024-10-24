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
  services.weiss.private-gpt = {
    enable = true;
    package = pkgs.pinnedUnstables."2024-09-08".private-gpt;
    # stateDir = "${homeDir}/.config/private-gpt/state";
    settings = {
      # ui = {
      #   enabled = true;
      #   default_mode = "RAG";
      # };
      azopenai = { };
      data = {
        local_data_folder = "/var/lib/private-gpt";
      };
      embedding = {
        mode = "openai";
      };
      llm = {
        mode = "openai";
        tokenizer = "";
      };
      openai = {
        api_key = secrets.openai.apiKey;
        model = "gpt-4o";
        embedding_api_key = secrets.openai.apiKey;
      };
      qdrant = {
        path = "/var/lib/private-gpt/vectorstore/qdrant";
      };
      vectorstore = {
        database = "qdrant";
      };
    };
  };
}
