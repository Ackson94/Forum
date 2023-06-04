defmodule ProbaseWeb.NotifyView do
    use ProbaseWeb, :view

    def username_color(user, username_colors) do
    end
  
    def font_weight(user, current_user) do
      if user.email == current_user.email do
        "bold"
      else
        "normal"
      end
    end
  
    def elipses(true), do: "..."
    def elipses(false), do: nil
end
  