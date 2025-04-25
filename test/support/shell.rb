class Shell
  attr_reader :session

  def self.run(command:, session: nil, **opts)
    shell = new(session: (session || "tbtest#{Random.rand(1000)}"))
    shell.start(command: command, **opts)
    sleep 0.05
    yield shell
  ensure
    shell.kill
  end

  def initialize(session:)
    @session = session
  end

  def start(command:, **opts)
    height = opts[:height] || 10
    width = opts[:width] || 120

    `tmux new-session -d -x #{width} -y #{height} -s #{session} "#{command}"`
  end

  def send_keys(keys)
    `tmux send-keys -t #{session} "#{keys}"`
  end

  def screenshot(out: nil)
    `tmux capture-pane -t #{session} -e`
    if out
      `tmux show-buffer > #{out}`
    else
      `tmux show-buffer`
    end
  end

  def kill
    `tmux kill-session -t #{session}`
  end
end