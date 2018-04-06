defmodule AsciinemaWeb.LoginController do
  use AsciinemaWeb, :controller
  alias Asciinema.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"login" => %{"email" => email_or_username}}) do
    email_or_username = String.trim(email_or_username)

    myurl = Accounts.send_login_email(email_or_username)
    case myurl do
      {:ok, _url} ->
        if String.to_existing_atom(System.get_env("AIRGAP")) do
          conn
          |> put_flash(:info, Enum.join(["AirGap Mode Detected! Please Click <a href=\"", elem(myurl,1),"\">Here</a> to complete the login process"],""))
          |> redirect(to: Enum.join([System.get_env("RAILS_RELATIVE_URL_ROOT"), (login_path(conn, :sent))],""))
        else
          conn
          |> redirect(to: Enum.join([System.get_env("RAILS_RELATIVE_URL_ROOT"), (login_path(conn, :sent))],""))
        end
      {:error, :user_not_found} ->
        render(conn, "new.html", error: "No user found for given username.")
      {:error, :email_invalid} ->
        render(conn, "new.html", error: "This doesn't look like a correct email address.")
      {:error, :email_missing} ->
        if String.to_existing_atom(System.get_env("AIRGAP")) do
          conn
          |> put_flash(:error, Enum.join(["AirGap Mode Detected! Email address is missing. Please Click <a href=\"", elem(myurl,1),"\">Here</a> to complete the login process"],""))
          |> redirect(to: Enum.join([System.get_env("RAILS_RELATIVE_URL_ROOT"), (login_path(conn, :sent))],""))
        else
          conn
          |> redirect(to: Enum.join([System.get_env("RAILS_RELATIVE_URL_ROOT"), (login_path(conn, :sent))],""))
        end
    end
  end

  def sent(conn, _params) do
    render(conn, "sent.html")
  end
end
