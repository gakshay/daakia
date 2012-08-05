module Excon
  class SSLSocket < Socket

    # backwards compatability for things lacking connect_nonblock
    unless OpenSSL::SSL::SSLSocket.public_method_defined?(:connect_nonblock)

      undef_method :connect
      def connect
        @socket = TCPSocket.new(@params[:host], @params[:port])
      end

    end

    # backwards compatability for things lacking read_nonblock
    unless OpenSSL::SSL::SSLSocket.public_method_defined?(:read_nonblock)

      undef_method :read
      def_delegators(:@socket, :read, :read)

    end

    # backwards compatability for things lacking write_nonblock
    unless OpenSSL::SSL::SSLSocket.public_method_defined?(:write_nonblock)

      undef_method :write
      def_delegators(:@socket, :write, :write)

    end

    def initialize(params = {}, proxy = nil)
      super

      # create ssl context
      ssl_context = OpenSSL::SSL::SSLContext.new

      if params[:ssl_verify_peer]
        # turn verification on
        ssl_context.verify_mode = OpenSSL::SSL::VERIFY_PEER

        if params[:ssl_ca_path]
          ssl_context.ca_path = params[:ssl_ca_path]
        elsif params[:ssl_ca_file]
          ssl_context.ca_file = params[:ssl_ca_file]
        else
          # use default cert store
          store = OpenSSL::X509::Store.new
          store.set_default_paths
          ssl_context.cert_store = store
        end
      else
        # turn verification off
        ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      if @params.has_key?(:client_cert) && @params.has_key?(:client_key)
        ssl_context.cert = OpenSSL::X509::Certificate.new(File.read(@params[:client_cert]))
        ssl_context.key = OpenSSL::PKey::RSA.new(File.read(@params[:client_key]))
      end

      @socket = OpenSSL::SSL::SSLSocket.new(@socket, ssl_context)
      @socket.sync_close = true

      if @proxy
        request = 'CONNECT ' << @params[:host] << ':' << @params[:port] << Excon::HTTP_1_1
        request << 'Host: ' << @params[:host] << ':' << @params[:port] << Excon::CR_NL

        if @proxy[:password] || @proxy[:user]
          auth = ['' << @proxy[:user].to_s << ':' << @proxy[:password].to_s].pack('m').delete(Excon::CR_NL)
          request << "Proxy-Authorization: Basic " << auth << Excon::CR_NL
        end

        request << Excon::CR_NL

        # write out the proxy setup request
        @socket.write(request)

        # eat the proxy's connection response
        Excon::Response.parse(@socket, {})
      end

      # connect the new OpenSSL::SSL::SSLSocket
      @socket.connect

      # Server Name Indication (SNI) RFC 3546
      if @socket.respond_to?(:hostname=)
        @socket.hostname = @params[:host]
      end

      # verify connection
      if params[:ssl_verify_peer]
        @socket.post_connection_check(@params[:host])
      end

      @socket
    end

  end
end
