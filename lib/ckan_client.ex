defmodule CKAN.Client do
  alias Poison, as: JSON

  defstruct [
    server: "", key: ""
  ]

  functions = [
    {:get, :package_show, []},
    {:get, :package_list, []},
    {:get, :organization_show, []},
    {:get, :organization_list, []},
    {:get, :group_show, []},
    {:get, :group_list, []},
    {:get, :resource_show, []},
    {:get, :resource_view_show, []},
    {:get, :resource_view_list, []},
    {:get, :resource_status_show, []},
    {:get, :revision_show, []},
    {:get, :group_package_show, []},
    {:get, :tag_show, []},
    {:get, :tag_list, []},
    {:get, :user_show, []},
    {:get, :user_list, []},
    {:get, :package_search, []},

    # Requires an authed user
    {:get, :organization_list_for_user, []},

    {:post, :package_create, %{}}
  ]

  def new(server, api_key \\ nil) do
    %__MODULE__{:server=>server <> "/api/3/action/", :key=>api_key}
  end

  def close(pid) do
  end


  ######################################################################
  # Generate functions to call
  ######################################################################
  for {method, name, args} <- functions do
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

  def process(client, {:get, function, args}) do
    qs = keywords_to_querystring(args)
    response = HTTPotion.get client.server <> to_string(function) <> qs, [timeout: 10_000,
                                                                         headers: get_headers_from_state(client)]
    {:ok, result} = JSON.decode(response.body, keys: :atoms)
    result
  end

  def process(client, {:post, function, args}) do
    headers = get_headers_from_state(client)
    host = client.server <> function

    response = HTTPotion.post host, [body: JSON.encode!(args), headers: headers, timeout: 10_000]
    {:ok, result} = JSON.decode(response.body, keys: :atoms)
    result
  end

  defp get_headers_from_state(client) do
    headers = case client.key do
      nil -> []
      k -> ["Authorization": k]
    end

  end

end