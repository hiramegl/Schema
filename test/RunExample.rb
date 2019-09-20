require "#{__dir__}/../frontend/lib/Aspicere/ruby/Aspicere";

module Gighub
    module AuthorizationsRegister
        @@hAuthorizations = { 'CreatorAuthorGroup/Apple' => lambda { |sString| return true; }, };
        def self.authorization_exists(_sName); (@@hAuthorizations[_sName] != nil); end
        def self.is_valid(_sAuthorization, _oValue); @@hAuthorizations[_sAuthorization].call(_oValue); end
    end # module AuthorizationsRegister
    module ValidationsRegister
        @@hValidations = {
            'NameValidation/Arkin'    => lambda { |sString| return sString.length > 3 && sString.length <= 100; },
            'AddressValidation/Avaya' => lambda { |sString| return sString.length > 5 && sString.length <= 100; },
            'TimeValidation/Aaron'    => lambda { |nNumber| return nNumber > 0 && nNumber <= (24 * 30); },
            'AreaValidation/Alvin'    => lambda { |nNumber| return nNumber > 0 && nNumber <= 100000; },
            'AmountValidation/Alina'  => lambda { |nNumber| return nNumber > 0 && nNumber <= 100000; },
        };
        def self.validation_exists(_sName); (@@hValidations[_sName] != nil); end
        def self.is_valid(_sValidation, _oValue); @@hValidations[_sValidation].call(_oValue); end
    end # module ValidationsRegister
    module UnitsRegister
        @@hUnits = {
            'SquareMeters/Asana' => lambda { 'm2'; },
            'Hours/Alfie'        => lambda { 'h'; },
        };
        def self.units_exists(_sName); (@@hUnits[_sName] != nil); end
        def self.get_string(_sUnits); @@hUnits[_sUnits].call(); end
    end # module AuthorizationsRegister
end # module Gighub
$hRegisters = {
    'Authorizations' => Gighub::AuthorizationsRegister,
    'Validations'    => Gighub::ValidationsRegister,
    'Units'          => Gighub::UnitsRegister,
};

oFactory = Aspicere::Factory.load(
    'Event_Aruba.yml',
    $hRegisters
);
exit unless oFactory;

puts('*' * 100); # ******************************************************************************************
# create the repository in the RAM of the application
puts('>>>> A) User Bob creates the event with two places and stores it ...')
oRepo1  = Aspicere::Repository.new('Bob', '2018-01-01T12:00:01.123', 'GUI');
sRepoId = oRepo1.to_hash;
oRoot1  = oRepo1.oRoot;

# create the event and add it to root merklet
oEvnt1 = oFactory.merklet('Event/Allen', { Name: 'Summerburst 2019', Address: 'Ullevigatan 1' });  exit unless oEvnt1;
oRoot1.add_child(oEvnt1);

# create first place and add it to the event
oPlac1 = oFactory.merklet('Place/Atlas', { Name: 'Ullevi Arena', Time: 96.0, Area: 5500 }); exit unless oPlac1;
oEvnt1 = oFactory.add_child_to(oEvnt1, oPlac1);                                             exit unless oEvnt1;
oItem1 = oFactory.merklet('Item/Archi', { Name: 'Perform', Part: 'Tiesto', Amount: 2 });    exit unless oItem1;
oPlac1 = oFactory.add_child_to(oPlac1, oItem1);                                             exit unless oPlac1;
oItem2 = oFactory.merklet('Item/Archi', { Name: 'Mount', Part: 'Bygg AB', Amount: 8 });     exit unless oItem2;
oPlac1 = oFactory.add_child_to(oPlac1, oItem2);                                             exit unless oPlac1;

# create second place and add it to the event
oPlac2 = oFactory.merklet('Place/Atlas', { Name: 'Gamla Ullevi', Time: 72.0, Area: 1000 }); exit unless oPlac2;
oEvnt1 = oFactory.add_child_to(oEvnt1, oPlac2);                                             exit unless oEvnt1;
oItem3 = oFactory.merklet('Item/Archi', { Name: 'Perform', Part: 'Deadmau5', Amount: 1 });  exit unless oItem3;
oPlac2 = oFactory.add_child_to(oPlac2, oItem3);                                             exit unless oPlac2;
oItem4 = oFactory.merklet('Item/Archi', { Name: 'Perform', Part: 'Alok', Amount: 1 });      exit unless oItem4;
oPlac2 = oFactory.add_child_to(oPlac2, oItem4);                                             exit unless oPlac2;
oItem5 = oFactory.merklet('Item/Archi', { Name: 'Mount', Part: 'Bygg AB', Amount: 10 });    exit unless oItem5;
oPlac2 = oFactory.add_child_to(oPlac2, oItem5);                                             exit unless oPlac2;

puts('Objects tree:');
oRoot1.dump;

# connect to the persistance layer tier (e.g. the store)
oStore = Aspicere::Store.new('store_01.db');

# init repository, add creation commit and add master version
oMaster = oRepo1.init(oStore); exit unless oMaster;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob modifies one item through integration and saves a new commit ...');
oItem5  = oFactory.update_attributes_for(oItem5, { Amount: 8.5 });              exit unless oItem5;
oMaster = oRepo1.add_commit(oStore, 'Corrected amount', oMaster, 'Bob', 'I-1'); exit unless oMaster;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob adds a new place through GUI and saves a new commit ...');
oPlac3 = oFactory.merklet('Place/Atlas', { Name: 'Scandinavium', Time: 48, Area: 1000 });  exit unless oPlac3;
oEvnt1 = oFactory.add_child_to(oEvnt1, oPlac3);                                            exit unless oEvnt1;
oItem6 = oFactory.merklet('Item/Archi', { Name: 'Perform', Part: 'Hardwell', Amount: 2 }); exit unless oItem6;
oPlac3 = oFactory.add_child_to(oPlac3, oItem6);                                            exit unless oPlac1;

oMaster = oRepo1.add_commit(oStore, 'Adding bedroom', oMaster, 'Bob', 'GUI'); exit unless oMaster;

puts('*' * 100); # ******************************************************************************************
puts('> User Bob creates a snapshot before inviting user Sue ...');
oSnapshot = oRepo1.add_snapshot(
    oStore,
    oMaster,
    'Invitation snapshot',
    'Snapshot before inviting user Sue'); exit unless oSnapshot;

oStore.dump;
oStore.close;
