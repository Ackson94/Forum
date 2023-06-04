defmodule Probase.Workers.Jobs do
  alias Probase.Notify
  def get_pending_status(), do: Notify.get_pending_status()
end
