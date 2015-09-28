defmodule CKAN.Client do
  use GenServer
  alias Poison, as: JSON

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
    start_link(%{:server=>server <> "/api/3/action/",
                 :key=>api_key})
  end

  def start_link(args\\%{}) do
    GenServer.start_link(__MODULE__, args)
  end

  ######################################################################
  # Generate functions to call
  ######################################################################
  for {method, name, args} <- functions do
    def unquote(name)(pid, args) do
      GenServer.call(pid, {unquote(method), unquote(name), args})
    end
  end

  defp keywords_to_querystring(keywords) do
    qs = keywords
    |> Enum.map(fn {k,v}->
        "#{k}=#{v}"
       end)
    |> Enum.join("&")

    case String.length(qs) do
      0 -> ""
      q -> "?" <> qs
    end
  end

  ######################################################################
  # Genserver callbacks ..
  ######################################################################
  def init(state) do
    {:ok, state}
  end


  def handle_call({:get, function, args}, _from, state) do
    qs = keywords_to_querystring(args)
    response = case state.key do
      nil ->
        HTTPotion.get state.server <> to_string(function) <> qs
      k ->
        HTTPotion.get state.server <> to_string(function) <> qs, [headers: ["authorization": k]]
    end
    {:ok, result} = JSON.decode(response.body, keys: :atoms)
    {:reply, result, state}
  end

  def handle_call({:post, function, args}, _from, state) do
    IO.inspect args
    IO.inspect function
    {:reply, "POST Result", state}
  end

end