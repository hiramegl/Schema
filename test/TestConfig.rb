require "#{__dir__}/../frontend/lib/Aspicere/ruby/Aspicere";
include Aspicere;

hFilters = {
    'pre/Auth/Group/Archie'    => lambda { |oVal| true },
    'pre/Auth/Group/Balalaika' => lambda { |oVal| true },
    'pre/Valid/Noop/Noop'      => lambda { |oVal| true },
    'pre/Valid/Coords/America' => lambda { |oVal| (oVal.to_s =~ /^\d+,\d+$/) != nil; },
    'pre/Valid/Alias/Alba'     => lambda { |oVal| (oVal.to_s =~ /^[A-Z]\w*$/) != nil; },
    'pre/Valid/Name/Alice'     => lambda { |oVal| (oVal.to_s =~ /^[A-Z][a-zA-Z\s]*$/) != nil; },
    'pre/Valid/PassAlp/Aurora' => lambda { |oVal| (oVal.to_s =~ /[A-Za-z]/) != nil; },
    'pre/Valid/PassNum/Atena'  => lambda { |oVal| (oVal.to_s =~ /\d/) != nil; },
    'pre/Valid/PassHyp/Amin'   => lambda { |oVal| (oVal.to_s =~ /-/) != nil; },
    'pre/Valid/Url/Andrew'     => lambda { |oVal| (oVal.to_s =~ /^http:\/\/\w+:\d+\/\w+$/) != nil; },
    'pre/Valid/Tags/Ava'       => lambda { |oVal| (oVal.to_s =~ /^[\w,]+$/) != nil; },
    'pres/Unit/Hour/Alex'      => lambda { |oVal| true },
};

puts('*' * 100); # ******************************************************************************************
# create the repository in the RAM of the application
puts('>>>> A) User Bob creates the event with two places and stores it ...')
oRepo = Repository.new('Bob', '2018-01-01T12:00:01.123', 'GUI');
oRepo.factory_init('Schema_Aleph_Config.yaml', 'Author_Aldo.yaml', hFilters, true);
oRepo.factory_dump;

# create the author merklet (root) and add data to it
oAuthor1 = oRepo.create_main('Author/Arthur');  exit unless oAuthor1;
oLocat1  = oRepo.merklet('Posit/Alacran'); exit unless oLocat1;
oLocat1  = oRepo.add_data(oLocat1, [{Coords: '123,456'}]); exit unless oLocat1;
oDenom1  = oRepo.merklet('Desig/Albania'); exit unless oDenom1;
oDenom1  = oRepo.add_data(oDenom1, [{Title: 'Manager'}]); exit unless oDenom1;
oAuthor1 = oRepo.add_data(oAuthor1, [{
    Alias: 'AndyW',
    Name: 'Andy Warhol',
    Pass: 'a-1sdf',
    Image: 'http://localhost:2345/Warhol',
    Status: 'Deleted',
    Tags: 'painter,wellknown'}]); exit unless oAuthor1;
oAuthor1 = oRepo.add_data(oAuthor1, [{
    Locat: oLocat1,
    Tags: 'AndyW',
    Denom: oDenom1,
}, {
    Tags: 'excentric,american',
    Denom: oRepo.add_data(oRepo.merklet('Desig/Albania'), [{
        Title: 'Developer',
    }])
}]); exit unless oAuthor1;
oRepo.root_dump;

# store repository
oRepo.store_init('store_02.db', true);
oMaster = oRepo.persist; exit unless oMaster;
oRepo.store_dump;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob modifies location through integration and saves a new commit ...');
oLocat1 = oRepo.update_data(oLocat1, [{Coords: ['111,222']}]); exit unless oLocat1;
oRepo.root_dump;
oMaster = oRepo.add_commit('Corrected status', oMaster, 'Bob', 'I-1'); exit unless oMaster;
oRepo.store_dump;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob modifies specific tag through GUI and saves a new commit and a snapshot ...');
oAuthor1 = oRepo.update_data(oAuthor1, [{Tags: ['NotAlive','AndyW']}]); exit unless oAuthor1;
oRepo.root_dump;
oMaster = oRepo.add_commit('Corrected location', oMaster, 'Bob', 'GUI'); exit unless oMaster;
oRepo.store_dump;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob creates a snapshot before inviting user Sue ...');
oSnapshot = oRepo.add_snapshot(oMaster, 'Invitation snapshot', 'Snapshot before inviting user Sue'); exit unless oSnapshot;
oRepo.store_dump;

oRepo.store_close;
puts('> Done!');
