defmodule Kukumo do
  @moduledoc """
  """
  def base_path(), do: Application.get_env(:kukumo, :features, "test/features/")
  def global_tags(), do: Application.get_env(:kukumo, :global_tags, []) |> List.wrap()
end
