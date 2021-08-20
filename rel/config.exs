~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"iUTs*(SSYQDZ7D(qz^/q=E_@J.{s!M*NUhJQmZZG~d.n=:UP9ARPNl102foae1=A"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"`z=fl.]$q@OFVi}vU|myPE>Jko>7]}j1!bL[iq/n;:(xT*(*6~R%|V3/CKe~8.go"
  set vm_args: "rel/vm.args"
end

release :resuelveb do
  set version: current_version(:resuelveb)
  set applications: [
    :runtime_tools
  ]
end
