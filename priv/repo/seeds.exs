# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Aliancer.Repo.insert!(%Aliancer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

## Create admin users

now = DateTime.utc_now() |> DateTime.truncate(:second)

String.split(System.get_env("ALIANCER_ADMIN_EMAILS"), ";")
|> Enum.each(fn email ->
  %Aliancer.Accounts.User{
    email: email,
    hashed_password: Bcrypt.hash_pwd_salt(System.get_env("ALIANCER_ADMIN_PASSWORD")),
    confirmed_at: now,
    is_admin: true
  }
  |> Aliancer.Repo.insert(
    on_conflict: [set: [is_admin: true, updated_at: DateTime.utc_now()]],
    conflict_target: :email
  )
end)
