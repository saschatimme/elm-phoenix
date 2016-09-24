ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ElmPhoenix.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ElmPhoenix.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ElmPhoenix.Repo)

