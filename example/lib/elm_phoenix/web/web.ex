defmodule ElmPhoenix.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use ElmPhoenix.Web, :controller
      use ElmPhoenix.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ElmPhoenix.Web
      import Plug.Conn
      import ElmPhoenix.Web.Router.Helpers
      import ElmPhoenix.Web.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/elm_phoenix/web/templates",
                        namespace: ElmPhoenix.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import ElmPhoenix.Web.Router.Helpers
      import ElmPhoenix.Web.ErrorHelpers
      import ElmPhoenix.Web.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ElmPhoenix.Web.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
