defmodule PAPBackendWeb.UserView do
  use PAPBackendWeb, :view
  alias PAPBackendWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end

  def render("sign_in.json", %{user: user}) do
    %{data:
    %{user:
      %{id: user.id, email: user.email}}}
  end

  def render("sign_out.json", %{user: user}) do
    %{data:
      %{email: user.email, msg: "Signed out"}}
  end
end