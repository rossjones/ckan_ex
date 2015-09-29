defmodule CKAN.Client do
  @moduledoc """
  This module is the client that can be used for accessing a remote
  CKAN instance.

  New clients should be created by calling ```new``` with the URL
  of the server, and an optional API key.
  """
  alias Poison, as: JSON

  defstruct [
    server: "", key: ""
  ]

  functions = [
    {:get, :package_show, [], "Shows a package"},
    {:get, :package_list, [], "Returns the names of all of the known packages"},
    {:get, :organization_show, [], "Shows organization details"},
    {:get, :organization_list, [], "Lists the names of the known organizations"},
    {:get, :group_show, [], "Shows group details"},
    {:get, :group_list, [], "Lists the names of the known groups"},
    {:get, :resource_show, [], ""},
    {:get, :resource_view_show, [], ""},
    {:get, :resource_view_list, [], ""},
    {:get, :resource_status_show, [], ""},
    {:get, :revision_show, [], ""},
    {:get, :group_package_show, [], ""},
    {:get, :tag_show, [], ""},
    {:get, :tag_list, [], ""},
    {:get, :user_show, [], ""},
    {:get, :user_list, [], ""},
    {:get, :package_search, [], ""},

    # Requires an authed user
    {:get, :organization_list_for_user, [], ""},

    {:post, :package_create, %{}, ""},
    {:post, :package_update, %{}, ""},
    {:post, :package_delete, [], ""},
  ]

  def new(server, api_key \\ nil) do
    %__MODULE__{:server=>server <> "/api/3/action/", :key=>api_key}
  end


  ######################################################################
  # Generate functions to call
  ######################################################################
  for {method, name, args, description} <- functions do
    @doc """
      "#{description}"
    """
    def unquote(name)(client, args) do
      process(client, {unquote(method), unquote(to_string(name)), args})
    end
  end

  defp keywords_to_querystring(keywords) do
    qs = keywords
    |> Enum.map(fn {k,v}->
        "#{to_string(k)}=#{v}"
       end)
    |> Enum.join("&")

    case String.length(qs) do
      0 -> ""
      _ -> "?" <> qs
    end
  end

  defp process(client, {:get, function, args}) do
    qs = keywords_to_querystring(args)
    response = HTTPotion.get client.server <> to_string(function) <> qs, [timeout: 10_000,
                                                                         headers: get_headers_from_state(client)]
    {:ok, result} = JSON.decode(response.body, keys: :atoms)
    result
  end

  defp process(client, {:post, function, args}) when is_map(args) do
    headers = get_headers_from_state(client)
    host = client.server <> function

    response = HTTPotion.post host, [body: JSON.encode!(args), headers: headers, timeout: 10_000]
    {:ok, result} = JSON.decode(response.body, keys: :atoms)
    result
  end

  defp process(client, {:post, function, args})  do
    new_args = args |> Enum.into(%{})
    process(client, {:post, function, new_args})
  end


  defp get_headers_from_state(client) do
    case client.key do
      nil -> ["Content-type": "application/json"]
      k -> ["Authorization": k, "Content-type": "application/json"]
    end
  end

end