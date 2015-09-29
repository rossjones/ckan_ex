defmodule CKANTest.Update do
  use ExUnit.Case
  alias CKAN.Client, as: Client
  doctest CKAN

  setup_all do
    host = System.get_env("CKAN_TEST_HOST")
    key = System.get_env("CKAN_TEST_KEY")

    {:ok, client: Client.new(host), auth_client: Client.new(host, key)}
  end

  test "we can create and then update a package", context do
    # Find the user details and then find their organization
    r = Client.organization_list_for_user context[:client], []
    assert r.result == []

    r = Client.organization_list_for_user context[:auth_client], []
    name = hd(r.result).name
    IO.inspect name
  end

end