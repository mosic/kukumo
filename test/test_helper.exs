Logger.configure_backend(:console, colors: [enabled: false])
ExUnit.start(trace: "--trace" in System.argv())

# Beam files compiled on demand
path = Path.expand("../tmp/beams", __DIR__)
File.rm_rf!(path)
File.mkdir_p!(path)
Code.prepend_path(path)

defmodule KukumoTestHelper do
  import ExUnit.CaptureIO

  def run(filters \\ [], cases \\ [])

  def run(filters, module) do
    add_module = &ExUnit.Server.add_async_module/1
    load_module = &ExUnit.Server.modules_loaded/0

    Enum.each(module, add_module)
    load_module.()

    opts =
      ExUnit.configuration()
      |> Keyword.merge(filters)
      |> Keyword.merge(colors: [enabled: false])

    output = capture_io(fn -> Process.put(:capture_result, ExUnit.Runner.run(opts, nil)) end)
    {Process.get(:capture_result), output}
  end
end
