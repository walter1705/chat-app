defmodule CLI.Main do
  @moduledoc """
  Principal comunication module between the user and the app external API.
  """

  alias CLI.{Parser}

  def main(args) do
    args
    |> Parser.parse_args()
  end

end
