module Lwes
  class Emitter
    DEFAULT_SOCIKET_OPTIONS = {
      :address_family => Socket::AF_INET,
      :host           => "127.0.0.1",
      :port           => 12345
    }
    
    attr_accessor :socket_options, :socket

    def initialize(options={})
      self.socket_options = DEFAULT_SOCIKET_OPTIONS.merge(options)
      self.socket = UDPSocket.new(socket_options[:address_family])
      socket.connect(socket_options[:host], socket_options[:port])
    end

    def emit(event)
      buffer = StringIO.new
      event.write(buffer)
      buffer.rewind
      socket.write(buffer.read)
    end
    
  end
end