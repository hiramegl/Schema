#!/usr/bin/env ruby

require 'rubygems';
require 'webrick/websocket'; # gem install webrick-websocket

require "#{__dir__}/Schema/Servlet";

class AppServer

    PORT = 23431;

    def initialize
        puts("File: #{__FILE__}");
        puts("Pwd: #{Dir.pwd}");

        # application servlets -----------------------------------

        @oWebServer = WEBrick::Websocket::HTTPServer.new(
            :Port            => PORT,
            :DocumentRoot    => "#{File.dirname(__FILE__)}/../../presentation",
            :RequestTimeout  => 500);

        @oWebServer.mount('/app.api', Schema::SchemaServlet);
        @oWebServer.mount('/app.ws' , Schema::WebSocketServlet);

        # exit handlers ------------------------------------------

        trap('INT')  { @oWebServer.shutdown; };
        trap('TERM') { @oWebServer.shutdown; };

        @oWebServer.start;
    end

end # class AppServer

AppServer.new;

