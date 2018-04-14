defmodule AsciinemaWeb.LayoutView do
  use AsciinemaWeb, :view
  import AsciinemaWeb.UserView, only: [avatar_url: 1]

  def page_title(conn) do
    case conn.assigns[:page_title] do
      nil -> "KubeTube on ICP - Share your terminal sessions, the right way"
      title -> title <> " - KubeTube" # TODO return safe string here?
    end
  end
end
