# CKAN_Ex

ckan_ex is a library used for communicating with the [CKAN](http://ckan.org) API.  It currently only supports version 3 of the API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ckan to your list of dependencies in `mix.exs`:

        def deps do
          [{:ckan, "~> 0.0.1"}]
        end

  2. Ensure ckan is started before your application:

        def application do
          [applications: [:ckan]]
        end

## Tests

To run the tests you will need to set three environment variables:

```bash
export CKAN_TEST_HOST=http://demo.ckan.org
export CKAN_TEST_KEY=your-api-key
```

Set them and then run ```mix test```.

## Usage

API actions are exposed as functions on the CKAN.Client, and will return the entire API response as a map.

```elixir 

  alias CKAN.Client
  client = Client.new("http://demo.ckan/org")
  result = Client.package_show client, id: "package_name"
	
```
