defmodule CKANTest do
  use ExUnit.Case
  doctest CKAN

  test "the truth" do
    {:ok, client} = CKAN.Client.new("http://demo.ckan.org")
    r = CKAN.Client.package_show client, id: "spatialsearchtest"
    assert r.result.name == "spatialsearchtest"
  end
end
