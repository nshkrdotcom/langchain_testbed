# gemini_explorer/config/config.exs

import Config


#config :langchain_testbed,
#  mode: :non_interactive

config :langchain,
  google_ai_key: System.fetch_env!("GOOGLE_API_KEY")
