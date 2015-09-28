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

## Usage

API actions are exposed as functions on the CKAN.Client, and you should call them with ..

```elixir 

	client = CKAN.Client.new("http://demo.ckan/org")
	result = CKAN.Client.package_show client, id: "package_name"
	
```