#!/usr/bin/env ruby

aRequirePatterns = [/^\s*require\s+['"](\S+?)['"];\s*#\s*(gem\s+install\s+.*)?/];

# check the necessary gems to install
hInstalls = {};
puts("> Reading scripts ...");
Dir.glob('./logic/**/*.rb') { |sScriptPath|
    puts(" - #{sScriptPath}");
    sScriptText = File.read(sScriptPath);
    aRequirePatterns.each { |reRequirePattern|
        sScriptText.scan(reRequirePattern) {
            sGem     = $1;
            sInstall = $2; # gem install command

            # include it in the hash of gems to install
            hInstalls[sInstall] = [] unless hInstalls[sInstall];
            hInstalls[sInstall] << sGem.downcase;
        }
    }
}

puts("\n> List of required gems:");
hInstalls.each { |sInstall, aGems|
    puts("- #{sInstall}, for gem: '#{aGems.uniq.join(',')}'");
}

print("\nInstall gems? [y/n]: ");
sAnswer = STDIN.gets.strip.downcase;
if (sAnswer == 'y')
    hInstalls.each_key { |sInstall|
        puts('-' * 100);
        puts("> Executing: #{sInstall}");
        puts(%x(#{sInstall}));
        puts('=' * 100);
    }
end

puts("* Done!");

