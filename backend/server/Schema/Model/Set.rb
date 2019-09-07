require "#{__dir__}/TableBase";

module Schema

    class Set < TableBase

        TABLE = 'Sets';
        CONFIG = {
            Id:   'INTEGER PRIMARY KEY',
            Name: 'TEXT',
            Doc:  'TEXT',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class Set

    class SetVersion < TableBase

        TABLE = 'SetVersions';
        CONFIG = {
            Id:    'INTEGER PRIMARY KEY',
            SetId: 'INTEGER',
            Name:  'TEXT',
            Doc:   'TEXT',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class SetVersion

    class SetElement < TableBase

        TABLE = 'SetElements';
        CONFIG = {
            Id:           'INTEGER PRIMARY KEY',
            SetVersionId: 'INTEGER',
            Kind:         'TEXT', # set element kind: Schema, Auth, Valid, Unit, Enum
            Name:         'TEXT',
            Doc:          'TEXT',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class SetElement

    class SetElementVersion < TableBase

        TABLE = 'SetElementVersions';
        CONFIG = {
            Id:           'INTEGER PRIMARY KEY',
            SetElementId: 'INTEGER',
            Name:         'TEXT',
            Doc:          'TEXT',
            Config:       'TEXT',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class SetElementVersion

end # module Schema
