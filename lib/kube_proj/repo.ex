defmodule KubeProj.Repo do
  use Ecto.Repo,
    otp_app: :kube_proj,
    adapter: Ecto.Adapters.Postgres
end
