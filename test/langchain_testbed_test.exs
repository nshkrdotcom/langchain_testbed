defmodule LangchainTestbedTest do
  use ExUnit.Case
  doctest LangchainTestbed

  test "greets the world" do
    assert LangchainTestbed.hello() == :world
  end
end
