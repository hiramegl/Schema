require "#{__dir__}/../frontend/lib/Aspicere/ruby/Aspicere";
include Aspicere;

hFilters = {
    'prestorage/ValidPrim/Noop/Arial'     => lambda { |hParams| true },
    'prestorage/ValidPrim/Coords/America' => lambda { |hParams| (hParams[:sValue] =~ /^\d+,\d+$/) != nil; },
    'prestorage/ValidPrim/Alias/Alba'     => lambda { |hParams| (hParams[:sValue] =~ /^[A-Z]\w*$/) != nil; },
    'prestorage/ValidPrim/Name/Alice'     => lambda { |hParams| (hParams[:sValue] =~ /^[A-Z][a-zA-Z\s]*$/) != nil; },
    'prestorage/ValidPrim/PassAlp/Aurora' => lambda { |hParams| (hParams[:sValue] =~ /[A-Za-z]/) != nil; },
    'prestorage/ValidPrim/PassNum/Atena'  => lambda { |hParams| (hParams[:sValue] =~ /\d/) != nil; },
    'prestorage/ValidPrim/PassHyp/Amin'   => lambda { |hParams| (hParams[:sValue] =~ /-/) != nil; },
    'prestorage/ValidPrim/Url/Andrew'     => lambda { |hParams| (hParams[:sValue] =~ /^http:\/\/\w+:\d+\/\w+$/) != nil; },
    'prestorage/ValidPrim/Tags/Ava'       => lambda { |hParams| (hParams[:sValue] =~ /^[\w,]+$/) != nil; },

    'prestorage/AuthComp/Author/Archie'   => lambda { |hParams| hParams[:hAuth][:bCanCreateAuthors] },
    'prestorage/AuthComp/Author/Bali'     => lambda { |hParams| hParams[:hAuth][:bCanCreateAuthors] && hParams[:hAuth][:sName] == 'root' },
    'prestorage/AuthComp/Desig/Arnold'    => lambda { |hParams| hParams[:hAuth][:bCanAddDesignation] },
    'prestorage/AuthComp/Posit/Arla'      => lambda { |hParams| hParams[:hAuth][:bCanAddLocation] },

    'prestorage/ValidChild/Denom/Asia'    => lambda { |hParams| puts "about to validate denominations"; true },
    'prestorage/ValidComp/Noop/Aries'     => lambda { |hParams| true },

    'storage/FormatPrim/CoordsPad/Ali'    => lambda { |hParams| puts "about to format coords: " + hParams.to_yaml },
    'storage/FormatChild/Denom/Anti'      => lambda { |hParams| puts "about to format denom: " + hParams.to_yaml },

    'poststorage/Publish/Author/Arpa'     => lambda { |hParams| puts "about to publish event for author: " + hParams.to_yaml },

    'presentation/Unit/Meter/Alex'        => lambda { |hParams| true },
};
bDebug = true;

puts('*' * 100); # ******************************************************************************************
# create the repository in the RAM of the application
puts('> A) User Bob creates the event with two places and stores it ...');
oRepo = Repository.new('Bob', '2018-01-01T12:00:01.123', 'GUI');
oRepo.auth_init(
    sName: 'root',
    bCanCreateAuthors: true,
    bCanAddLocation: true,
    bCanAddDesignation: true,
);
oRepo.factory_init('Schema_Aleph_Config.yaml', 'Author_Aldo.yaml', hFilters, bDebug);
oRepo.factory_dump if bDebug;

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
oRepo.root_dump if bDebug;

# store repository
oRepo.store_init('store_02.db', true);
oMaster = oRepo.persist; exit unless oMaster;
oRepo.store_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob modifies location through integration and saves a new commit ...');
oLocat1 = oRepo.update_data(oLocat1, [{Coords: ['111,222']}]); exit unless oLocat1;
oRepo.root_dump if bDebug;
oMaster = oRepo.add_commit('Corrected location', oMaster, 'Bob', 'I-1'); exit unless oMaster;
oRepo.store_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob modifies specific tag through GUI and saves a new commit and a snapshot ...');
oAuthor1 = oRepo.update_data(oAuthor1, [{Tags: ['NotAlive','AndyW']}]); exit unless oAuthor1;
oRepo.root_dump if bDebug;
oMaster = oRepo.add_commit('Corrected tags', oMaster, 'Bob', 'GUI'); exit unless oMaster;
oRepo.store_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob creates a snapshot before inviting user Sue ...');
oSnapshot = oRepo.add_snapshot(oMaster, 'Invitation snapshot', 'Snapshot before inviting user Sue'); exit unless oSnapshot;

oRepo.store_dump;
oRepo.store_close;
puts('> Done!');
