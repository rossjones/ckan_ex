defmodule CKANTest.Update do
  use ExUnit.Case
  alias CKAN.Client, as: Client
  doctest CKAN

  setup_all do
    host = System.get_env("CKAN_TEST_HOST")
    key = System.get_env("CKAN_TEST_KEY")

    {:ok, client: Client.new(host),
          auth_client: Client.new(host, key)}
  end

  test "we can create and then update, then delete a package", context do
    # Find the user details and then find their organization
    r = Client.organization_list_for_user context[:client], []
    assert r.result == []

    r = Client.organization_list_for_user context[:auth_client], []
    name = hd(r.result).name
    pkg_name = "ckanclienttester_11"

    pkg = %{
      :name => pkg_name, :notes => "A test dataset",
      :organization => name
    }
    r = Client.package_create context[:auth_client], pkg
    assert r.success
    assert r.result.name == pkg_name

    pkg = Map.update!(r.result, :notes, fn _-> "A Test Dataset" end)
    r = Client.package_update context[:auth_client], pkg
    assert r.success
    assert r.result.notes == "A Test Dataset"

    r = Client.package_delete context[:auth_client], id: pkg_name
    assert r.success
  end

end