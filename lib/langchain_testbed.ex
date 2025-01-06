defmodule LangchainTestbed do
  alias LangChain.ChatModels.ChatGoogleAI
  alias LangChain.Chains.LLMChain
  alias LangChain.Chains.DataExtractionChain
  alias LangChain.Message
  alias LangChain.LangChainError
  #alias LangChain.ChatModels.ChatGoogleAI.GenerationConfig

  def start(_type, _args) do
    run()
    {:ok, self()}
  end

  def run do




    # Add a callback to receive streaming deltas
    streaming_handler = %{
      on_llm_new_delta: fn _model, delta ->
        IO.write("STREAM_DELTA: #{delta.content}")
      end,
      on_llm_new_message: fn _model, message ->
        IO.inspect(message, label: "MESSAGE COMPLETED")
      end
    }




    schema_parameters = %{
      type: "object",
      properties: %{
        person_name: %{type: "string"},
        person_age: %{type: "number"},
        person_hair_color: %{type: "string"},
        dog_name: %{type: "string"},
        dog_breed: %{type: "string"}
      },
      required: []
    }

    generationConfig = %{
      #response_mime_type: "application/json",
      #response_schema: schema_parameters
    }

    chat = ChatGoogleAI.new!(%{
      model: "gemini-2.0-flash-exp",
      temperature: 2,
      #stream: true,
      #callbacks: [streaming_handler],
      generation_config: generationConfig
    })



    # Model setup
    #{:ok, chat} = ChatGoogleAI.new(%{temperature: 0})

    # run the chain on the text information
    data_prompt =
      "Alex is 5 feet tall. Claudia is 4 feet taller than Alex and jumps higher than him.
      Claudia is a brunette and Alex is blonde. Alex's dog Frosty is a labrador and likes to play hide and seek."


    case DataExtractionChain.run(chat, schema_parameters, data_prompt) do
      {:ok, result} ->
        IO.puts("Data extraction successful!")
        IO.inspect(result, label: "RESULT: ")
        result

      {:error, %LangChainError{message: reason}} ->
        IO.puts("Error during data extraction: #{reason}")
        nil
    end
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
    # generationConfig = %{
    #   # response_mime_type: "application/json",
    #   # response_schema: %{
    #   #   "type" => "object",
    #   #   "properties" => %{
    #   #     "foo" => %{"type" => "string"}
    #   #   }
    #   # }
    # }

    # llm = ChatGoogleAI.new!(%{
    #   model: "gemini-2.0-flash-exp",
    #   temperature: 1.1,
    #   # stream: true,
    #   #callbacks: [streaming_handler],
    #   generation_config: generationConfig
    # })

    # chain =
    #   LLMChain.new!(%{llm: chat})
    #   |> LLMChain.add_message(
    #     Message.new_user!(
    #       "You are a helpful AI that responds with an elaborate story that conforms to your outpute requirement"
    #     )
    #   )

    # case LLMChain.run(chain) do
    #   {:ok, result_chain} ->
    #     IO.puts("Successfully generated content")

    #     case result_chain.last_message.content do
    #       content when is_binary(content) ->
    #         IO.puts("Generated content: #{content}")
    #       content  ->
    #         IO.inspect(content, label: "content")
    #     end

    #   {:error, _chain, %LangChain.LangChainError{message: message}} ->
    #     IO.puts("Error generating content: #{message}")
    # end

    # #:timer.sleep(:infinity)



















  end
end
