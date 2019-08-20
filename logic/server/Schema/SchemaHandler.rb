require 'yaml';
require 'sqlite3'; # gem install sqlite3

require "#{__dir__}/ReqHandler";
require "#{__dir__}/Model/Set";
require "#{__dir__}/Model/Schema";

module Schema

    class SchemaHandler < ReqHandler

        MODULE  = 'Schema';
        DB_FILE = 'Schema.db';

        def initialize(_hParams)
            super(_hParams);

            @sDataPath = "#{__dir__}/../Data";

            # folder where the system database is found
            @sDbFile = "#{@sDataPath}/#{DB_FILE}";
        end

        # http://localhost:23431/app.api?debug=true&cmd=init
        def get_init; init_db; end

        # http://localhost:23431/app.api?debug=true&cmd=list
        def post_list; assure('Type') { list_obj; } end

        # http://localhost:23431/app.api?debug=true&cmd=tree
        def post_tree; assure('Type') { tree_obj; } end

        # http://localhost:23431/app.api?debug=true&cmd=select
        def post_select; assure('Type', 'Id') { select_obj; } end

        # http://localhost:23431/app.api?debug=true&cmd=query
        def post_query; assure('Type', 'Query') { query_obj; } end

        # http://localhost:23431/app.api?debug=true&cmd=create
        def post_create; assure('Type') { create_obj; } end

        # http://localhost:23431/app.api?debug=true&cmd=update
        def post_update; assure('Type', 'Id') { update_obj; } end

        # http://localhost:23431/app.api?debug=true&cmd=delete
        def post_delete; assure('Type', 'Id') { delete_obj; } end

    private # **********************************************

        def init_db
            File.delete(@sDbFile) if File.exists?(@sDbFile);

            aSeed = [
                [Set              , {'Id'=>'1','Name'=>'Gighub', 'Doc'=>'Events project'}],
                [SetVersion       , {'Id'=>'1','SetId'=>'1', 'Name'=>'Allan', 'Doc'=>'First version'}],

                [SetElement       , {'Id'=>'1','SetVersionId'=>'1','Kind'=>'Schema','Name'=>'Author'  ,'Doc'=>'Schema for author'}],
                [SetElement       , {'Id'=>'2','SetVersionId'=>'1','Kind'=>'Auth'  ,'Name'=>'Group'   ,'Doc'=>'Group authorization'}],
                [SetElement       , {'Id'=>'3','SetVersionId'=>'1','Kind'=>'Valid' ,'Name'=>'Alias'   ,'Doc'=>'Author aliases'}],
                [SetElement       , {'Id'=>'4','SetVersionId'=>'1','Kind'=>'Valid' ,'Name'=>'Name'    ,'Doc'=>'Author names'}],
                [SetElement       , {'Id'=>'5','SetVersionId'=>'1','Kind'=>'Valid' ,'Name'=>'Password','Doc'=>'Login password'}],
                [SetElement       , {'Id'=>'6','SetVersionId'=>'1','Kind'=>'Valid' ,'Name'=>'Url'     ,'Doc'=>'Images url'}],
                [SetElement       , {'Id'=>'7','SetVersionId'=>'1','Kind'=>'Valid' ,'Name'=>'Tags'    ,'Doc'=>'Tags'}],
                [SetElement       , {'Id'=>'8','SetVersionId'=>'1','Kind'=>'Unit'  ,'Name'=>'Hour'    ,'Doc'=>'Unit for time spans'}],
                [SetElement       , {'Id'=>'9','SetVersionId'=>'1','Kind'=>'Enum'  ,'Name'=>'Status'  ,'Doc'=>'Author status in the system'}],

                [SetElementVersion, {'Id'=>'1','SetElementId'=>'1','Name'=>'Aldo'  ,'Doc'=>'Basic Author schema','Config'=>''}],
                [SetElementVersion, {'Id'=>'2','SetElementId'=>'2','Name'=>'Archie','Doc'=>'Authors in same group','Config'=>''}],
                [SetElementVersion, {'Id'=>'3','SetElementId'=>'3','Name'=>'Alba'  ,'Doc'=>'Alphanum aliases','Config'=>''}],
                [SetElementVersion, {'Id'=>'4','SetElementId'=>'4','Name'=>'Alice' ,'Doc'=>'Alpha and spaces in names','Config'=>''}],
                [SetElementVersion, {'Id'=>'5','SetElementId'=>'5','Name'=>'Atena' ,'Doc'=>'Secure password','Config'=>''}],
                [SetElementVersion, {'Id'=>'6','SetElementId'=>'6','Name'=>'Andrew','Doc'=>'Simple url','Config'=>''}],
                [SetElementVersion, {'Id'=>'7','SetElementId'=>'7','Name'=>'Ava'   ,'Doc'=>'Alphanum, commas and spaces','Config'=>''}],
                [SetElementVersion, {'Id'=>'8','SetElementId'=>'8','Name'=>'Alex'  ,'Doc'=>'Hour time unit','Config'=>''}],
                [SetElementVersion, {'Id'=>'9','SetElementId'=>'9','Name'=>'Ambar' ,'Doc'=>'First version','Config'=>'Active: "Can use system", Inactive: "Cannot use system temporarily", Deleted: "Not available anymore"'}],

                [SchemaElement    , {'Id'=>'1','SchemaVersionId'=>'1','Kind'=>'Auth' ,'SetElementId'=>'2','SetElementVersionId'=>'2'}],
                [SchemaElement    , {'Id'=>'2','SchemaVersionId'=>'1','Kind'=>'Valid','SetElementId'=>'3','SetElementVersionId'=>'3'}],
                [SchemaElement    , {'Id'=>'3','SchemaVersionId'=>'1','Kind'=>'Valid','SetElementId'=>'4','SetElementVersionId'=>'4'}],
                [SchemaElement    , {'Id'=>'4','SchemaVersionId'=>'1','Kind'=>'Valid','SetElementId'=>'5','SetElementVersionId'=>'5'}],
                [SchemaElement    , {'Id'=>'5','SchemaVersionId'=>'1','Kind'=>'Valid','SetElementId'=>'6','SetElementVersionId'=>'6'}],
                [SchemaElement    , {'Id'=>'6','SchemaVersionId'=>'1','Kind'=>'Valid','SetElementId'=>'7','SetElementVersionId'=>'7'}],
                [SchemaElement    , {'Id'=>'7','SchemaVersionId'=>'1','Kind'=>'Unit' ,'SetElementId'=>'8','SetElementVersionId'=>'8'}],
                [SchemaElement    , {'Id'=>'8','SchemaVersionId'=>'1','Kind'=>'Enum' ,'SetElementId'=>'9','SetElementVersionId'=>'9'}],

                [Component        , {'Id'=>'1','SchemaVersionId'=>'1','Class'=>'Author','Name'=>'Auhor','Doc'=>'Author component'}],
                [ComponentVersion , {'Id'=>'1','CompId'=>'1','Name'=>'Arthur','Doc'=>'1st version','Auth'=>'Group/Archie'}],

                [Primitive        , {'Id'=>'1','ParentId'=>'1','Class'=>'string','Version'=>'v_1.0','Name'=>'Alias'   ,'Doc'=>'Alias for login' ,'Nullable'=>'false','Valid'=>'Alias/Alba'    ,'Unit'=>'','Enum'=>''}],
                [Primitive        , {'Id'=>'2','ParentId'=>'1','Class'=>'string','Version'=>'v_1.0','Name'=>'Name'    ,'Doc'=>'Name and surname','Nullable'=>'false','Valid'=>'Name/Alice'    ,'Unit'=>'','Enum'=>''}],
                [Primitive        , {'Id'=>'3','ParentId'=>'1','Class'=>'string','Version'=>'v_1.0','Name'=>'Password','Doc'=>'Uncrypted psswd' ,'Nullable'=>'false','Valid'=>'Password/Atena','Unit'=>'','Enum'=>''}],
                [Primitive        , {'Id'=>'4','ParentId'=>'1','Class'=>'string','Version'=>'v_1.0','Name'=>'Image'   ,'Doc'=>'Url user image'  ,'Nullable'=>'true' ,'Valid'=>'Url/Andrew'    ,'Unit'=>'','Enum'=>''}],
                [Primitive        , {'Id'=>'5','ParentId'=>'1','Class'=>'string','Version'=>'v_1.0','Name'=>'Status'  ,'Doc'=>'Author status'   ,'Nullable'=>'false','Valid'=>''              ,'Unit'=>'','Enum'=>'Status/Ambar'}],
                [Primitive        , {'Id'=>'6','ParentId'=>'1','Class'=>'string','Version'=>'v_1.0','Name'=>'Tags'    ,'Doc'=>'Search tags'     ,'Nullable'=>'true' ,'Valid'=>'Tags/Ava'      ,'Unit'=>'','Enum'=>''}],
            ];

            aQueries = [];
            aTypes = [Set,SetVersion,SetElement,SetElementVersion,SchemaElement,Component,ComponentVersion,Primitive,Child];
            aTypes.each { |oType|
                aQueries << oType.get_drop_query;
                aQueries << oType.get_create_query;
            }
            aSeed.each { |hSeed|
                aQueries << hSeed[0].insert_obj(hSeed[1]);
            }
            return respond_msg(aQueries){ 'init_db: ok' };
        end

        def list_obj
            assure_type_exists {
                respond_list(@oType.select(@hParams));
            }
        end

        def tree_obj
            assure_type_exists { respond_tree };
        end

        def select_obj
            assure_type_exists {
                respond_obj(@oType.select_obj(@hParams));
            }
        end

        def query_obj
            assure_type_exists { respond_query };
        end

        def create_obj
            assure_type_exists {
                respond_msg([@oType.insert_obj(@hParams)]) { |oDb|
                    oDb.last_insert_row_id; # created object id
                }
            }
        end

        def update_obj
            assure_type_exists {
                respond_msg([@oType.update_obj(@hParams)]) { |oDb|
                    @hParams['Id']; # updated object id
                }
            }
        end

        def delete_obj
            assure_type_exists {
                respond_msg([@oType.delete_obj(@hParams)]) { |oDb|
                    @hParams['Id']; # deleted object id
                }
            }
        end

        # worker methods ***********************************

        # returns nil on success or a json failure object on error
        def parse_type(_sType)
            begin
                @oType = Object.const_get(MODULE).const_get(_sType);
            rescue
                return error("Undefined type: '#{_sType}'");
            end

            return nil; # no problems!
        end

        def assure_type_exists
            oError = parse_type(@hParams['Type'])
            return oError if oError;

            yield(@oType);
        end

        # returns a json message object on success or a json failure object on error
        def respond_msg(_aQueries)
            begin
                oDb = SQLite3::Database.new(@sDbFile);
                _aQueries.each { |sQuery|
                    puts("@ #{sQuery}");
                    oDb.execute(sQuery);
                }
                sMsg = yield(oDb);
            rescue SQLite3::Exception => oException
                return error("respond_msg: #{oException.to_s}");
            ensure
                oDb.close if oDb;
            end

            return success(sMsg);
        end

        # returns a json array object on success or a json failure object on error
        def respond_list(_sQuery)
            aObjs = [];
            begin
                oDb = SQLite3::Database.new(@sDbFile);
                puts("@ #{_sQuery}");
                oDb.execute(_sQuery).each { |aRow|
                    aObjs << @oType.format_row(aRow);
                }
            rescue SQLite3::Exception => oException
                return error("respond_list: #{oException.to_s}");
            ensure
                oDb.close if oDb;
            end

            return success(aObjs);
        end

        # returns a json array object on success or a json failure object on error
        def respond_obj(_sQuery)
            hObj = nil;
            begin
                oDb = SQLite3::Database.new(@sDbFile);
                puts("@ #{_sQuery}");
                oDb.execute(_sQuery).each { |aRow|
                    hObj = @oType.format_row(aRow);
                    break; # execute only the first row
                }
            rescue SQLite3::Exception => oException
                return error("respond_obj: #{oException.to_s}");
            ensure
                oDb.close if oDb;
            end

            return success(hObj);
        end

        # returns a json tree object on success or a json failure object on error
        def respond_tree
            sType = @hParams['Type'];

            case sType
                when 'Set' then return respond_set_tree;
                when 'SetElement' then return assure('SetVersionId') { respond_set_element_tree };
                when 'SchemaElement' then return assure('SchemaVersionId') { respond_schema_element_tree };
                else return error("No tree implementation for type '#{sType}'");
            end
        end

        def respond_set_tree
            aSets = [];
            begin
                oDb = SQLite3::Database.new(@sDbFile);

                sQuery = @oType.select;
                puts("@ Type: #{sQuery}");
                oDb.execute(sQuery).each { |aRow|
                    aSets << @oType.format_row(aRow);
                }

                # iterate through the set and find the versions
                aSets.each { |hSet|
                    aVersions = [];
                    nSetId    = hSet[:Id];
                    sQuery    = SetVersion.select_where({ SetId: nSetId });

                    puts("@ Version: #{sQuery}");
                    oDb.execute(sQuery).each { |aRow|
                        hSetVersion = SetVersion.format_row(aRow);
                        hSetVersion[:leaf] = true;
                        aVersions << hSetVersion;
                    }

                    if (aVersions.empty?)
                        hSet[:leaf] = true;
                    else
                        hSet[:expanded] = true;
                        hSet[:children] = aVersions;
                    end
                }

            rescue SQLite3::Exception => oException
                return error("respond_set_tree: #{oException.to_s}");
            ensure
                oDb.close if oDb;
            end

            return success_tree(aSets);
        end

        @@hSetElementKinds = {
            Schema: 'Schema',
            Auth:   'Authorization',
            Valid:  'Validation',
            Unit:   'Unit',
            Enum:   'Enumeration',
        };

        def respond_set_element_tree # ***************************************************
            sSetVersionId = @hParams['SetVersionId'];
            return success_tree([]) if (sSetVersionId == '0');

            @oDb = SQLite3::Database.new(@sDbFile);
            aSetElementTreeNodes = [];
            @@hSetElementKinds.each { |sSetElementKind, sFullKindName|
                hSetElementKindNode = {
                    SetVersionId: sSetVersionId,
                    Kind: sSetElementKind,
                    Name: sFullKindName + 's', # plural
                    KindName: sFullKindName,
                };

                # search for set elements that belong to the
                # specified set element kind and set version
                aSetElementNodes = select_set_elements(
                    sSetVersionId, sSetElementKind, sFullKindName);

                if (aSetElementNodes.empty?)
                    hSetElementKindNode[:leaf] = true;
                else
                    hSetElementKindNode[:Doc]      = aSetElementNodes.length;
                    hSetElementKindNode[:children] = aSetElementNodes;
                    hSetElementKindNode[:expanded] = true;
                end

                aSetElementTreeNodes << hSetElementKindNode;
            }
            return success_tree(aSetElementTreeNodes);
        end

        def select_set_elements(
            _sSetVersionId,
            _sSetElementKind,
            _sFullKindName)

            aSetElementNodes = [];
            sQuery = SetElement.select_where({
                SetVersionId: _sSetVersionId,
                Kind:         _sSetElementKind,
            });
            puts("@ SetElement: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                hSetElementNode            = SetElement.format_row(aRow);
                hSetElementNode[:KindName] = _sFullKindName;
                aSetElementNodes << hSetElementNode;
            }

            aSetElementNodes.each { |hSetElementNode|
                # search for set element versions that belong to the set element
                aSetElementVersionNodes = select_set_element_versions(
                    hSetElementNode[:Id], _sSetElementKind, _sFullKindName);

                if (aSetElementVersionNodes.empty?)
                    hSetElementNode[:leaf] = true;
                else
                    hSetElementNode[:children] = aSetElementVersionNodes;
                    hSetElementNode[:expanded] = true;
                end
            }

            return aSetElementNodes;
        end

        def select_set_element_versions(
            _sSetElementId,
            _sSetElementKind,
            _sFullKindName)

            aSetElementVersionNodes = [];
            sQuery = SetElementVersion.select_where({
                SetElementId: _sSetElementId
            });
            puts("@ SetElementVersion: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                hSetElementVersionNode = SetElementVersion.format_row(aRow);
                hSetElementVersionNode[:Kind]     = _sSetElementKind;
                hSetElementVersionNode[:KindName] = _sFullKindName;
                hSetElementVersionNode[:leaf]     = true;
                aSetElementVersionNodes << hSetElementVersionNode;
            }
            return aSetElementVersionNodes;
        end

        def respond_schema_element_tree # ************************************************
            sSchemaVersionId = @hParams['SchemaVersionId'];
            return success_tree([]) if (sSchemaVersionId == '0');

            @oDb = SQLite3::Database.new(@sDbFile);

            # find out set version id for current schema version id
            nSetElementId = get_set_element_version(sSchemaVersionId)[:SetElementId];
            nSetVersionId = get_set_element(nSetElementId)[:SetVersionId];

            aSchemaElementTreeNodes = [];
            @@hSetElementKinds.each { |sSchemaElementKind, sFullKindName|
                hSchemaElementKindNode = {
                    SchemaVersionId: sSchemaVersionId,
                    Kind: sSchemaElementKind,
                    Name: sFullKindName + 's', # plural
                    KindName: sFullKindName,
                    SetVersionId: nSetVersionId,
                };

                aSchemaElementNodes = select_schema_elements(
                    sSchemaVersionId, sSchemaElementKind, sFullKindName, nSetVersionId);

                if (aSchemaElementNodes.empty?)
                    hSchemaElementKindNode[:leaf] = true;
                else
                    hSchemaElementKindNode[:Version]  = aSchemaElementNodes.length;
                    hSchemaElementKindNode[:children] = aSchemaElementNodes;
                    hSchemaElementKindNode[:expanded] = true;
                end

                aSchemaElementTreeNodes << hSchemaElementKindNode;
            }

            aSchemaElementTreeNodes << get_schema_component_nodes(sSchemaVersionId);

            return success_tree(aSchemaElementTreeNodes);
        end

        def select_schema_elements(
            _sSchemaVersionId,
            _sSchemaElementKind,
            _sFullKindName,
            _nSetVersionId)

            # search for Schema elements that belong to the
            # Schema element kind and Schema version
            aSchemaElementNodes = [];
            sQuery = SchemaElement.select_where({
                SchemaVersionId: _sSchemaVersionId,
                Kind:            _sSchemaElementKind,
            });
            puts("@ SchemaElement: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                hSchemaElementNode = SchemaElement.format_row(aRow);
                aSchemaElementNodes << hSchemaElementNode;
            }

            aSchemaElementNodes.each { |hSchemaElementNode|
                nSetElementId        = hSchemaElementNode[:SetElementId];
                nSetElementVersionId = hSchemaElementNode[:SetElementVersionId];

                hSchemaElementNode[:Name]         = get_set_element(nSetElementId)[:Name];
                hSchemaElementNode[:Version]      = get_set_element_version(nSetElementVersionId)[:Name];
                hSchemaElementNode[:KindName]     = _sFullKindName;
                hSchemaElementNode[:SetVersionId] = _nSetVersionId;
                hSchemaElementNode[:leaf]         = true;
            }

            return aSchemaElementNodes;
        end

        def get_set_element(_nSetElementId)
            sQuery = SetElement.select_obj({
                'Id' => _nSetElementId
            });
            puts("@ SetElement: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                return SetElement.format_row(aRow); # execute only the first row
            }
            return {};
        end

        def get_set_element_version(_nSetElementVersionId)
            sQuery = SetElementVersion.select_obj({
                'Id' => _nSetElementVersionId
            });
            puts("@ SetElementVersion: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                return SetElementVersion.format_row(aRow); # execute only the first row
            }
            return {};
        end

        def get_schema_component_nodes(_sSchemaVersionId)
            hSchemaComponentNode = {
                SchemaVersionId: _sSchemaVersionId,
                Kind: 'Comp',
                Name: 'Components',
                KindName: 'Component',
            };

            aSchemaComponentNodes = select_schema_components(_sSchemaVersionId);

            if (aSchemaComponentNodes.empty?)
                hSchemaComponentNode[:leaf] = true;
            else
                hSchemaComponentNode[:Version]  = aSchemaComponentNodes.length;
                hSchemaComponentNode[:children] = aSchemaComponentNodes;
                hSchemaComponentNode[:expanded] = true;
            end

            return hSchemaComponentNode;
        end

        def select_schema_components(_sSchemaVersionId)
            aSchemaComponentNodes = [];
            sQuery = Component.select_where({
                SchemaVersionId: _sSchemaVersionId,
            });
            puts("@ Component: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                hSchemaComponentNode            = Component.format_row(aRow);
                hSchemaComponentNode[:Kind]     = 'Comp';
                hSchemaComponentNode[:KindName] = 'Component';
                aSchemaComponentNodes << hSchemaComponentNode;
            }

            aSchemaComponentNodes.each { |hSchemaComponentNode|
                aComponentVersionNodes = select_component_versions(
                    hSchemaComponentNode[:Id], _sSchemaVersionId);

                if (aComponentVersionNodes.empty?)
                    hSchemaComponentNode[:leaf] = true;
                else
                    hSchemaComponentNode[:children] = aComponentVersionNodes;
                    hSchemaComponentNode[:expanded] = true;
                end
            }
        end

        def select_component_versions(
            _nSchemaComponentId,
            _sSchemaVersionId)

            aComponentVersionNodes = [];
            sQuery = ComponentVersion.select_where({
                CompId: _nSchemaComponentId
            });
            puts("@ ComponentVersion: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                hComponentVersionNode = ComponentVersion.format_row(aRow);
                hComponentVersionNode[:SchemaVersionId] = _sSchemaVersionId;
                hComponentVersionNode[:Kind]            = 'Comp';
                hComponentVersionNode[:KindName]        = 'Component';
                hComponentVersionNode[:leaf]            = true;
                aComponentVersionNodes << hComponentVersionNode;
            }
            return aComponentVersionNodes;
        end

        # returns a json object on success or a json failure object on error
        def respond_query
            sQuery = @hParams['Query'];

            case sQuery
                when 'SchemaElementsBySchemaVersionId' then return respond_schema_elements_by_schema_version_id;
                else return error("No implementation for query '#{sQuery}'");
            end
        end

        def respond_schema_elements_by_schema_version_id
            sSchemaVersionId = @hParams['SchemaVersionId'];
            @oDb = SQLite3::Database.new(@sDbFile);

            if (@hParams['Kind'] == 'Comp')
                return respond_schema_components_by_schema_versionId;
            end

            aSchemaElementNodes = [];
            sQuery = SchemaElement.select(@hParams);
            @oDb.execute(sQuery).each { |aRow|
                aSchemaElementNodes << SchemaElement.format_row(aRow);
            }

            aSchemaElementNodes.each { |hSchemaElementNode|
                hSetElement        = get_set_element(hSchemaElementNode[:SetElementId]);
                hSetElementVersion = get_set_element_version(hSchemaElementNode[:SetElementVersionId]);
                sSetElementName    = hSetElement[:Name];
                sSetElementVersion = hSetElementVersion[:Name];
                hSchemaElementNode[:Name] = "#{sSetElementName}/#{sSetElementVersion}";
                hSchemaElementNode[:Value] = "#{sSetElementName}/#{sSetElementVersion}";
            }
            aSchemaElementNodes << { Name: '-', Value: '' };


            return success(aSchemaElementNodes);
        end

        def respond_schema_components_by_schema_versionId
            nSchemaVersionId  = @hParams['SchemaVersionId']
            aSchemaComponents = []; # auxiliar array variable
            sQuery = Component.select_where({
                SchemaVersionId: nSchemaVersionId,
            });
            puts("@ Component: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                aSchemaComponents << Component.format_row(aRow);
            }

            aSchemaComponentNodes = []; # result variable
            aSchemaComponents.each { |hSchemaComponent|
                nSchemaComponentId = hSchemaComponent[:Id];
                aComponentVersions = select_component_versions(nSchemaComponentId, nSchemaVersionId);
                aComponentVersions.each { |hComponentVersion|
                    sName = "#{hSchemaComponent[:Class]}/#{hComponentVersion[:Name]}";
                    aSchemaComponentNodes << {
                        Name: sName,
                        Value: sName,
                    };
                }
            }

            return success(aSchemaComponentNodes);
        end

    end # class SchemaHandler

end # module Schema
