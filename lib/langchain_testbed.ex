defmodule LangchainTestbed do
  alias LangChain.ChatModels.ChatGoogleAI
  alias LangChain.Chains.LLMChain
  alias LangChain.Message
  #alias LangChain.ChatModels.ChatGoogleAI.GenerationConfig

  def start(_type, _args) do
    run()
    {:ok, self()}
  end

  def run do
    IO.puts("Starting Gemini Explorer with JSON output test...")

#{:ok, generation_config} = LangChain.ChatModels.ChatGoogleAI.new(%{
#      generation_config: %{
#        response_mime_type: "application/json",
#        response_schema: %{
#          "type" => "object",
#          "properties" => %{
#            "foo" => %{"type" => "string"}
#          }
#        }
#      }
#    })




    # Create a GenerationConfig with responseMimeType set to application/json
#    {:ok, generation_config} = GenerationConfig.new(%{
#      response_mime_type: "application/json",
#      response_schema: %{
#        "type" => "object",
#        "properties" => %{
#          "foo" => %{"type" => "string"}
#        }
#      }
#    })
#    generation_config = %{
#      response_mime_type: "application/json",
#      response_schema: %{"properties" => %{"foo" => %{"type" => "string"}}, "type" => "object"}
#    }
    generation_config = %{
      responseMineType: "application/json",
      responseSchema: %{
        "type" => "object",
        "properties" => %{
          "foo" => %{"type" => "string"}
        }
      }
    }

    # Add a callback to receive streaming deltas
    streaming_handler = %{
      on_llm_new_delta: fn _model, delta ->
        IO.write("STREAM_DELTA: #{delta.content}")
      end,
      on_llm_new_message: fn _model, message ->
        IO.inspect(message, label: "MESSAGE COMPLETED")
      end
    }

    llm = ChatGoogleAI.new!(%{
      model: "gemini-2.0-flash-exp",
      temperature: 0.9,
      stream: true,
      callbacks: [streaming_handler],
      generation_config: generation_config
    })

    chain =
      LLMChain.new!(%{llm: llm})
      |> LLMChain.add_message(
        Message.new_user!(
          "You are a helpful AI that responds only in JSON. Return the JSON object per the noted format {'foo': 'bar'} but tell a story with an elaborate json response that conforms to your outpute requirement"
        )
      )

    case LLMChain.run(chain) do
      {:ok, result_chain} ->
        IO.puts("Successfully generated content")

        case result_chain.last_message.content do
          content when is_binary(content) ->
            IO.puts("Generated content: #{content}")

          _ ->
            IO.puts("Unexpected content type")
        end

      {:error, _chain, %LangChain.LangChainError{message: message}} ->
        IO.puts("Error generating content: #{message}")
    end

    :timer.sleep(:infinity)
  end
end
