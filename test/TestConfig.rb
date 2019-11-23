require "#{__dir__}/../frontend/lib/Aspicere/ruby/Aspicere";
include Aspicere;
# - prestorage: AuthPrim, ValidPrim, AuthChild, ValidChild, AuthComp, ValidComp, ...
#     - hAuth, oObj [Merklet|Primitive], sValue [oObj.oValue.to_s]
# - storage: FormatPrim, FormatChild, FormatComp, Compression, Encryption
#     - oObj [Merklet|Primitive]
# - poststorage: Index, Publish, ...
#     - sClusterId, sRepoId, sVersionId, sCommitId, oObj, sObjId, sObjQPath, sObjPath
# - presentation: Display, Unit, ...
#     - hAuth, oObj [Merklet|Primitive], sValue [oObj.oValue.to_s]

hFilters = {
    'prestorage.AuthPrim.Alias.Allan'     => lambda { |hParams| hParams[:hAuth][:hAlias][:bCreate] },
    'prestorage.ValidPrim.Noop.Arial'     => lambda { |hParams| true },
    'prestorage.ValidPrim.Coords.America' => lambda { |hParams| (hParams[:sValue] =~ /^\d+,\d+$/) != nil; },
    'prestorage.ValidPrim.Alias.Alba'     => lambda { |hParams| (hParams[:sValue] =~ /^[A-Z]\w*$/) != nil; },
    'prestorage.ValidPrim.Name.Alice'     => lambda { |hParams| (hParams[:sValue] =~ /^[A-Z][a-zA-Z\s]*$/) != nil; },
    'prestorage.ValidPrim.PassAlp.Aurora' => lambda { |hParams| (hParams[:sValue] =~ /[A-Za-z]/) != nil; },
    'prestorage.ValidPrim.PassNum.Atena'  => lambda { |hParams| (hParams[:sValue] =~ /\d/) != nil; },
    'prestorage.ValidPrim.PassHyp.Amin'   => lambda { |hParams| (hParams[:sValue] =~ /-/) != nil; },
    'prestorage.ValidPrim.Url.Andrew'     => lambda { |hParams| (hParams[:sValue] =~ /^http:\/\/\w+:\d+\/\w+$/) != nil; },
    'prestorage.ValidPrim.Tags.Ava'       => lambda { |hParams| (hParams[:sValue] =~ /^[\w,]+$/) != nil; },
    'prestorage.AuthChild.Denom.Angus'    => lambda { |hParams| true },
    'prestorage.ValidChild.Denom.Asia'    => lambda { |hParams| true },
    'prestorage.AuthComp.Author.Archie'   => lambda { |hParams| hParams[:hAuth][:bCanCreateAuthors] },
    'prestorage.AuthComp.Author.Bali'     => lambda { |hParams| hParams[:hAuth][:bCanCreateAuthors] && hParams[:hAuth][:sName] == 'root' },
    'prestorage.AuthComp.Desig.Arnold'    => lambda { |hParams| hParams[:hAuth][:bCanAddDesignation] },
    'prestorage.AuthComp.Posit.Arla'      => lambda { |hParams| hParams[:hAuth][:bCanAddLocation] },
    'prestorage.ValidComp.Noop.Aries'     => lambda { |hParams| true },
    'storage.FormatPrim.CoordsPad.Ali'    => lambda { |hParams| true },
    'storage.FormatChild.Denom.Anti'      => lambda { |hParams| true },
    'storage.FormatComp.Denom.Anti'       => lambda { |hParams| true },
    'poststorage.Publish.Author.Arpa'     => lambda { |hParams| true },
    'presentation.Unit.Meter.Alex'        => lambda { |hParams| 'm' },
};
bDebug = true;

oFolder = Folder.new;
oFolder.store_init('store_02.db', true);
oFolder.repo_init('/Sweden/Stockholm/2019-11', 'Bob', '2018-01-01T12:00:01.123', 'GUI');

oEditor = Editor.new;
oEditor.folder_init(oFolder);
oEditor.auth_init(
    sName: 'root',
    bCanCreateAuthors: true,
    bCanAddLocation: true,
    bCanAddDesignation: true,
    hAlias: {bCreate: true}
);
oEditor.factory_init('Schema_Aleph_Config.yaml', 'Author_Aldo.yaml', hFilters, bDebug);
oEditor.factory_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
# create the document in the RAM of the application
puts('> A) User Bob creates the event with two places and stores it ...');
# create the author merklet (root) and add data to it
oAuthorDoc = oEditor.init_doc;  exit unless oAuthorDoc;
oLocatDoc1 = oEditor.merklet('Posit.Alacran'); exit unless oLocatDoc1;
oLocatDoc1 = oEditor.add_data(oLocatDoc1, [{Coords: '123,456'}]); exit unless oLocatDoc1;
oDenomDoc1 = oEditor.merklet('Desig.Albania'); exit unless oDenomDoc1;
oDenomDoc1 = oEditor.add_data(oDenomDoc1, [{Title: 'Manager'}]); exit unless oDenomDoc1;
oAuthorDoc = oEditor.add_data(oAuthorDoc, [{
    Alias: 'AndyW',
    Name: 'Andy Warhol',
    Pass: 'a-1sdf',
    Image: 'http://localhost:2345/Warhol',
    Status: 'Deleted',
    Tags: 'painter,wellknown'}]); exit unless oAuthorDoc;
oAuthorDoc = oEditor.add_data(oAuthorDoc, [{
    Locat: oLocatDoc1,
    Tags: 'AndyW',
    Denom: oDenomDoc1,
}, {
    Tags: 'excentric,american',
    Denom: oEditor.add_data(oEditor.merklet('Desig.Albania'), [{
        Title: 'Developer',
    }])
}]); exit unless oAuthorDoc;
oFolder.binder_dump if bDebug;

oMaster = oEditor.init_master_version; exit unless oMaster;
oFolder.store_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob modifies location through integration and saves a new commit ...');
oLocatDoc1 = oEditor.update_data(oLocatDoc1, [{Coords: ['111,222']}]); exit unless oLocatDoc1;
oFolder.binder_dump if bDebug;
oMaster = oEditor.add_commit('Corrected location', oMaster, 'Bob', 'I-1'); exit unless oMaster;
oFolder.store_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob modifies specific tag through GUI and saves a new commit and a snapshot ...');
oAuthorDoc = oEditor.update_data(oAuthorDoc, [{Tags: ['NotAlive','AndyW']}]); exit unless oAuthorDoc;
oFolder.binder_dump if bDebug;
oMaster = oEditor.add_commit('Corrected tags', oMaster, 'Bob', 'GUI'); exit unless oMaster;
oFolder.store_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob creates a snapshot before inviting user Sue ...');
oSnapshot = oEditor.add_snapshot(oMaster, 'Invitation snapshot', 'Snapshot before inviting user Sue'); exit unless oSnapshot;
oFolder.store_dump if bDebug;

puts('*' * 100); # ******************************************************************************************
puts('> User Sue creates a version and deletes tags ...');
oDraft = oEditor.add_version('Sue_draft', oMaster.sCommitId, 'Sue', 'GUI', 'My sandbox playground!'); exit unless oDraft;
#oAuthorDoc = oEditor.get_doc(oDraft);
oAuthorDoc = oEditor.delete_data(oAuthorDoc, [{Tags: 'NotAlive'}]); exit unless oAuthorDoc;
oAuthorDoc = oEditor.delete_data(oAuthorDoc, [{Tags: nil}]); exit unless oAuthorDoc;
oFolder.binder_dump if bDebug;
oDraft = oEditor.add_commit('Removed tags', oDraft, 'Sue', 'GUI'); exit unless oDraft;
oFolder.store_dump if bDebug;

oFolder.store_close;
puts('> Done!');
