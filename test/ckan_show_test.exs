defmodule CKANTest.Show do
  use ExUnit.Case
  alias CKAN.Client, as: Client
  doctest CKAN

  setup_all do
    host = System.get_env("CKAN_TEST_HOST")
    key = System.get_env("CKAN_TEST_KEY")

    {:ok, client} = CKAN.Client.new(host)
    {:ok, auth_client} = CKAN.Client.new(host, key)
    {:ok, client: client, auth_client: auth_client}
  end

  test "we can fail to show packages", context do
    r = Client.package_show context[:client], id: "___"
    assert r.success == false
  end

  test "we can send bad data to show packages", context do
    r = Client.package_show context[:client], wombles: "are cool"
    assert r.success == false
    assert r.error.__type == "Validation Error"
    assert r.error.name_or_id == ["Missing value"]
  end

  test "we can show packages", context do
    r = Client.package_list context[:client], []
    to_fetch = hd r.result

    r = Client.package_show context[:client], id: to_fetch
    assert r.result.name == to_fetch

    # May fail on a dataset with no resources .. :(
    to_fetch = hd(r.result.resources).id
    r = Client.resource_show context[:client], id: to_fetch
    assert r.result.id == to_fetch
  end

  test "we can show organizations", context do
    r = Client.organization_list context[:client], []
    to_fetch = hd r.result

    r = Client.organization_show context[:client], id: to_fetch
    assert r.result.name == to_fetch
  end

  test "we can show groups", context do
    r = Client.group_list context[:client], []
    to_fetch = hd r.result

    r = Client.group_show context[:client], id: to_fetch
    assert r.result.name == to_fetch
  end
end
