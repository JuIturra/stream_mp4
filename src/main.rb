# frozen_string_literal: true

require 'webrick'

server = WEBrick::HTTPServer.new(Port: 8085)

server.mount_proc '/stream' do |_req, res|
  video_path = "#{__dir__}/sisoi.mp4"

  command = "ffmpeg -re -i #{video_path} -c:v libx264 -c:a aac -f mpegts -"

  IO.popen(command, 'r') do |ffmpeg|
    res.body = ffmpeg.read
    res['Content-Type'] = 'video/mp2t'
  end
end

trap 'INT' do server.shutdown end

server.start
