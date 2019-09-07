require 'json';
require 'webrick';
require 'webrick/websocket'; # gem install webrick-websocket

require "#{__dir__}/SchemaHandler";

include WEBrick;

module Schema

    class SchemaServlet < HTTPServlet::AbstractServlet

        def initialize(_oServer, *_aOptions)
            super;

            # parse options when necessary
        end

        # AbstractServlet methods

        def do_GET(_oReq, _oRsp)
            sCmd = _oReq.query['cmd'];

            puts('> req query: ' + _oReq.query.inspect);
            puts("> GET cmd: #{sCmd}");

            sMethod = "get_#{sCmd}"
            oApp = SchemaHandler.new(_oReq.query);

            if (oApp.supports?(sMethod))
                puts("> processing with '#{sMethod}'");
                _oRsp.body = oApp.reply(sMethod);
            else
                puts("> method '#{sMethod}' not found");
                _oRsp.body = oApp.error("invalid command GET '#{sCmd}'");
            end

            raise HTTPStatus::OK;
        end

        def do_POST(_oReq, _oRsp)
            sCmd = _oReq.unparsed_uri.match(/cmd=(\w+)/).captures[0];
            puts("> POST cmd: #{sCmd}");
            puts('> req query: ' + _oReq.query.inspect);

            sMethod = "post_#{sCmd}"
            oApp = SchemaHandler.new(_oReq.query);

            if (oApp.supports?(sMethod))
                puts("> processing with '#{sMethod}'");
                _oRsp.body = oApp.reply(sMethod);
            else
                puts("> method '#{sMethod}' not found");
                _oRsp.body = oApp.error("invalid command POST '#{sCmd}'");
            end

            raise HTTPStatus::OK;
        end

    end # class SchemaServlet

    class WebSocketServlet < WEBrick::Websocket::Servlet

        @@aClients = [];

        def initialize(_oServer, *_aOptions)
            super;
            # parse options if necessary
        end

        # Websocket servlet methods (api)

        def select_protocol(_aAvailable)
            # method optional, if missing, it will always select first protocol.
            # Will only be called if client actually requests a protocol
            _aAvailable.include?('myprotocol') ? 'myprotocol' : nil
        end

        def socket_open(_oSocket)
            @@aClients << _oSocket;
            puts('----> New socket opened');
            post_num_clients;
        end

        def socket_close(_oSocket)
            @@aClients.delete(_oSocket);
            puts('----> Socket gone.');
            post_num_clients;
        end

        def socket_text(_oSocket, _sText)
            puts("----> Rx: #{_sText}");
        end

        # auxiliary methods

        def post_num_clients
            @@aClients.each { |oSocket|
                oSocket.puts("Clients: #{@@aClients.length}");
            }
        end

    end # class WebSocketServlet

end # module Schema

