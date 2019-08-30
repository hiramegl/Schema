#!/usr/bin/ruby

# ruby libraries
require 'Filewatcher'; # gem install filewatcher

class AppRunner

    def initialize
        @bMacOs = (RUBY_PLATFORM =~ /darwin/) != nil;
        sCmd    = @bMacOs ? 'xterm -geometry 200x60 -iconic -e' : 'start /min cmd /c'
        sSend   = @bMacOs ? '&' : '2>&1';

        # app server
        @sAppSrvExe = "#{__dir__}/server/AppServer.rb";
        @sWatchDir  = "#{__dir__}/server/Schema";
        @sAppSrvCmd = "#{sCmd} \"ruby #{@sAppSrvExe}\" #{sSend}";

        # doc server
        @sDocSrvExe = "#{File.dirname(__FILE__)}/server/DocServer.rb";
        @sDocSrvCmd = "#{sCmd} \"ruby #{@sDocSrvExe}\" #{sSend}";
    end

    def run
        # navigate in chrome to the application
        sAppUrl = 'http://localhost:23431/index.html';

        if (@bMacOs)
            sChromeCmd = "open -a \"Google Chrome\" #{sAppUrl}";
        else
            sChromeExe = 'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe';
            sChromeCmd = "start \"\" \"#{sChromeExe}\" \"#{sAppUrl}\" --new-window"; # the empty quotations after 'start' is to prevent launching firefox instead of chrome
        end

        puts(sChromeCmd);
        system(sChromeCmd);

        # start web servers (documentation and application)
        start_process(@sDocSrvCmd);
        start_process(@sAppSrvCmd);

        # use file watcher to monitor file/directory changes and restart
        # the application web server every time we detect a change
        puts('#' * 100);
        puts("> Watching for changes in '#{@sWatchDir}' ...");

        Filewatcher.new(@sWatchDir).watch { |sPath|
            puts('=' * 100);
            puts(" > File changed: '#{sPath}'");

            stop_process;
            start_process(@sAppSrvCmd);
        }
    end

    def start_process(sCommandLine)
        puts('*' * 100);
        puts("> Starting process [#{sCommandLine}] ...");
        system(sCommandLine);
    end

    def stop_process
        puts('-' * 100);
        sProcessList = @bMacOs ?
            `ps -A -o 'user args pid' | grep xterm` :
            `wmic process where "name='cmd.exe'" get ProcessID, CommandLine`;
        sFilename = File.basename(@sAppSrvExe);
        sProcessList =~ /#{sFilename}"?\s+(\d+)/;
        sPid = $1;

        unless sPid
            puts("Error: cannot kill process '#{sFilename}'. Process found: #{sProcessList}");
            return;
        end
        sKillResult = `taskkill /PID #{sPid}`;
        puts(sKillResult);
    end

end # class AppRunner

AppRunner.new.run;

