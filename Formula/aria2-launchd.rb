class Aria2Launchd < Formula
  desc "A launchd script for Aria2"
  homepage "https://github.com/sunteya/homebrew-extra"
  url "https://github.com/sunteya/homebrew-extra/raw/master/LICENSE"
  version "20180705"
  sha256 "c261c6ff1c575bab03ba336315e00c7123bcf833d935dcbeed41807f747650b3"

  depends_on "aria2"

  def install
    raise "You must add a #{aria2_conf.basename} file in #{aria2_conf.dirname} folder" unless aria2_conf.exist?

    IO.write name, <<~EOF
      #!/bin/bash

      aria2_conf=$HOME/.aria2/aria2.conf

      if [[ ! -f "$aria2_conf" ]]; then
        echo "Can not found aria2 config in $aria2_conf"
        exit 1
      fi

      exec #{HOMEBREW_PREFIX}/opt/aria2/bin/aria2c --conf-path=$aria2_conf "$@"
    EOF

    system "chmod +x #{name}"
    bin.install name
  end

  def aria2_conf
    home = Pathname.new(`eval echo ~$USER`.chomp)
    home/".aria2/aria2.conf"
  end

  plist_options :manual => "aria2-launched"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin/name}</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
    </plist>
  EOS
  end
end
