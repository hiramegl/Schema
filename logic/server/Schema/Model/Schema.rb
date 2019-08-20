require "#{__dir__}/TableBase";

module Schema

    class SchemaElement < TableBase

        TABLE = 'SchemaElements';
        CONFIG = {
            Id:                  'INTEGER PRIMARY KEY',
            SchemaVersionId:     'INTEGER', # pointer to the schema version
            Kind:                'TEXT',    # set element kind: Schema, Auth, Valid, Unit, Enum
            SetElementId:        'INTEGER', # pointer to the set element id
            SetElementVersionId: 'INTEGER', # pointer to the set element version id
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class SchemaElement

    class Component < TableBase

        TABLE = 'Components';
        CONFIG = {
            Id:              'INTEGER PRIMARY KEY',
            SchemaVersionId: 'INTEGER',
            Class:           'TEXT', # will never ever change after is defined the first time!
            Name:            'TEXT', # it can change whenever is required
            Doc:             'TEXT',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class Component

    class ComponentVersion < TableBase

        TABLE = 'ComponentVersions';
        CONFIG = {
            Id:     'INTEGER PRIMARY KEY',
            CompId: 'INTEGER',
            Name:   'TEXT',
            Doc:    'TEXT',
            Auth:   'TEXT',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class ComponentVersion

    class Primitive < TableBase

        TABLE = 'Primitives';
        CONFIG = {
            Id:       'INTEGER PRIMARY KEY',
            ParentId: 'INTEGER', # parent component version id
            Class:    'TEXT',    # string, number, bool
            Version:  'TEXT',    # v_1.0
            Name:     'TEXT',
            Doc:      'TEXT',
            Nullable: 'INTEGER',
            Valid:    'TEXT',
            Unit:     'TEXT',
            Enum:     'TEXT',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class Primitive

    class Child < TableBase

        TABLE = 'Children';
        CONFIG = {
            Id:       'INTEGER PRIMARY KEY',
            ParentId: 'INTEGER', # parent component version id
            Comp:     'STRING',  # component name
            Array:    'INTEGER',
            Nullable: 'INTEGER',
        };
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

    end # class Child

end # module Schema

