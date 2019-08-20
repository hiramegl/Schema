#!/usr/bin/env ruby

require 'rubygems';
require 'webrick';

class DocServer

    PORT = 23433;

    def initialize
        puts("File: #{__FILE__}");
        puts("Pwd: #{Dir.pwd}");
        sRoot = __dir__;

        # ext js servlets ----------------------------------------

        @oWebServer = WEBrick::HTTPServer.new(
            :DocumentRoot => "#{sRoot}/Doc/ext-6.2.0", # Samples docs
            :Port         => PORT);

        @oWebServer.mount(
            '/docs',
            WEBrick::HTTPServlet::FileHandler,
            "#{sRoot}/Doc/ext-6.2.0-docs"); # Api docs

        # exit handlers ------------------------------------------

        trap('INT')  {
            @oWebServer.shutdown;
            exit if Object.const_defined?(:Ocra);
        };
        trap('TERM') {
            @oWebServer.shutdown;
            exit if Object.const_defined?(:Ocra);
        };

        @oWebServer.start;
    end

end # class DocServer

DocServer.new;

