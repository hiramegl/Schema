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
            begin
                oDb = SQLite3::Database.new(@sDbFile);
                puts("@ #{_sQuery}");
                aObjs = oDb.execute(_sQuery).collect { |aRow|
                    @oType.format_row(aRow);
                }
                return success(aObjs);
            rescue SQLite3::Exception => oException
                return error("respond_list: #{oException.to_s}");
            ensure
                oDb.close if oDb;
            end
        end

        # returns a json array object on success or a json failure object on error
        def respond_obj(_sQuery)
            begin
                oDb = SQLite3::Database.new(@sDbFile);
                puts("@ #{_sQuery}");
                oDb.execute(_sQuery).each { |aRow|
                     return success(@oType.format_row(aRow)); # return the first object
                }
            rescue SQLite3::Exception => oException
                return error("respond_obj: #{oException.to_s}");
            ensure
                oDb.close if oDb;
            end
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
            begin
                oDb = SQLite3::Database.new(@sDbFile);

                sQuery = @oType.select;
                puts("@ Type: #{sQuery}");
                aSets = oDb.execute(sQuery).collect { |aRow|
                    @oType.format_row(aRow);
                }

                # iterate through the set and find the versions
                aSets.each { |hSet|
                    nSetId = hSet[:Id];
                    sQuery = SetVersion.select_where({ SetId: nSetId });

                    puts("@ Version: #{sQuery}");
                    aVersions = oDb.execute(sQuery).collect { |aRow|
                        hSetVersion = SetVersion.format_row(aRow);
                        hSetVersion[:leaf] = true;
                        hSetVersion;
                    }

                    if (aVersions.empty?)
                        hSet[:leaf] = true;
                    else
                        hSet[:expanded] = true;
                        hSet[:children] = aVersions;
                    end
                }

                return success_tree(aSets);
            rescue SQLite3::Exception => oException
                return error("respond_set_tree: #{oException.to_s}");
            ensure
                oDb.close if oDb;
            end
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

            sQuery = SetElement.select_where({
                SetVersionId: _sSetVersionId,
                Kind:         _sSetElementKind,
            });
            puts("@ SetElement: #{sQuery}");
            aSetElementNodes = @oDb.execute(sQuery).collect { |aRow|
                hSetElementNode            = SetElement.format_row(aRow);
                hSetElementNode[:KindName] = _sFullKindName;
                hSetElementNode;
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

            sQuery = SetElementVersion.select_where({
                SetElementId: _sSetElementId
            });
            puts("@ SetElementVersion: #{sQuery}");
            aSetElementVersionNodes = @oDb.execute(sQuery).collect { |aRow|
                hSetElementVersionNode = SetElementVersion.format_row(aRow);
                hSetElementVersionNode[:Kind]     = _sSetElementKind;
                hSetElementVersionNode[:KindName] = _sFullKindName;
                hSetElementVersionNode[:leaf]     = true;
                hSetElementVersionNode;
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
                    hSchemaElementKindNode[:Version]  = "Num: #{aSchemaElementNodes.length}";
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
            sQuery = SchemaElement.select_where({
                SchemaVersionId: _sSchemaVersionId,
                Kind:            _sSchemaElementKind,
            });
            puts("@ SchemaElement: #{sQuery}");
            aSchemaElementNodes = @oDb.execute(sQuery).collect { |aRow|
                SchemaElement.format_row(aRow);
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
            sQuery = SetElement.select_obj({'Id' => _nSetElementId});
            puts("@ SetElement: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                return SetElement.format_row(aRow); # execute only the first row
            }
            return {};
        end

        def get_set_element_version(_nSetElementVersionId)
            sQuery = SetElementVersion.select_obj({'Id' => _nSetElementVersionId});
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
                hSchemaComponentNode[:Version]  = "Num: #{aSchemaComponentNodes.length}";
                hSchemaComponentNode[:children] = aSchemaComponentNodes;
                hSchemaComponentNode[:expanded] = true;
            end

            return hSchemaComponentNode;
        end

        def select_schema_components(_sSchemaVersionId)
            sQuery = Component.select_where({SchemaVersionId: _sSchemaVersionId});
            puts("@ Component: #{sQuery}");
            aSchemaComponentNodes = @oDb.execute(sQuery).collect { |aRow|
                hSchemaComponentNode            = Component.format_row(aRow);
                hSchemaComponentNode[:Kind]     = 'Comp';
                hSchemaComponentNode[:KindName] = 'Component';
                hSchemaComponentNode;
            }

            aSchemaComponentNodes.each { |hSchemaComponentNode|
                aComponentVersionNodes = select_component_versions(
                    hSchemaComponentNode[:Id], _sSchemaVersionId);

                hSchemaComponentNode[:Version] = hSchemaComponentNode[:Doc];
                if (aComponentVersionNodes.empty?)
                    hSchemaComponentNode[:leaf] = true;
                else
                    hSchemaComponentNode[:children] = aComponentVersionNodes;
                    hSchemaComponentNode[:expanded] = true;
                end
            }
            return aSchemaComponentNodes;
        end

        def select_component_versions(
            _nSchemaComponentId,
            _sSchemaVersionId)
            sQuery = ComponentVersion.select_where({CompId: _nSchemaComponentId});
            puts("@ ComponentVersion: #{sQuery}");
            aComponentVersionNodes = @oDb.execute(sQuery).collect { |aRow|
                hComponentVersionNode = ComponentVersion.format_row(aRow);
                hComponentVersionNode[:SchemaVersionId] = _sSchemaVersionId;
                hComponentVersionNode[:Kind]     = 'Comp';
                hComponentVersionNode[:KindName] = 'Component';
                hComponentVersionNode[:Version]  = hComponentVersionNode[:Doc];
                hComponentVersionNode[:leaf]     = true;
                hComponentVersionNode;
            }
            return aComponentVersionNodes;
        end

        # returns a json object on success or a json failure object on error
        def respond_query
            sQuery = @hParams['Query'];

            case sQuery
                when 'SchemaElementsBySchemaVersionId' then return respond_schema_elements_by_schema_version_id;
                when 'RenderSchemaVersion' then return respond_render_schema_version;
                when 'Versions' then return respond_versions;
                when 'NetVis' then return respond_net_vis;
                else return error("No implementation for query '#{sQuery}'");
            end
        end

        def respond_schema_elements_by_schema_version_id
            sSchemaVersionId = @hParams['SchemaVersionId'];
            @oDb = SQLite3::Database.new(@sDbFile);

            if (@hParams['Kind'] == 'Comp')
                return success(
                    get_schema_components_by_schema_versionId(
                        @hParams['SchemaVersionId']));
            end

            aSchemaElementNodes = [];
            sQuery = SchemaElement.select(@hParams);
            puts("@ SchemaElement: #{sQuery}");
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

        def get_schema_components_by_schema_versionId(_nSchemaVersionId);
            sQuery = Component.select_where({SchemaVersionId: _nSchemaVersionId});
            puts("@ Component: #{sQuery}");
            aSchemaComponents = @oDb.execute(sQuery).collect { |aRow|
                Component.format_row(aRow);
            }

            aSchemaComponentNodes = []; # result variable
            aSchemaComponents.each { |hSchemaComponent|
                nSchemaComponentId = hSchemaComponent[:Id];
                aComponentVersions = select_component_versions(
                    nSchemaComponentId, _nSchemaVersionId);
                aComponentVersions.each { |hComponentVersion|
                    sName = "#{hSchemaComponent[:Class]}/#{hComponentVersion[:Name]}";
                    aSchemaComponentNodes << { Name: sName, Value: sName, };
                }
            }

            # attach the components of the referred schemas
            sQuery = SchemaElement.select_where({
                SchemaVersionId: _nSchemaVersionId,
                Kind:            'Schema',
            });
            puts("@ SchemaElement: #{sQuery}");
            aSchemaSchemas = @oDb.execute(sQuery).collect { |aRow|
                SchemaElement.format_row(aRow);
            }
            aSchemaSchemas.each { |hSchema|
                aSchemaComponentNodes.concat(
                    get_schema_components_by_schema_versionId(
                        hSchema[:SetElementVersionId]));
            }

            return aSchemaComponentNodes;
        end

        def respond_render_schema_version
            sSchemaVersionId = @hParams['SchemaVersionId'];
            @oDb = SQLite3::Database.new(@sDbFile);
            @sNs = "- !ruby/object:Aspicere::";

            # schema header ****************************************************
            hSchemaVersion = get_set_element_version(sSchemaVersionId);
            hSchema        = get_set_element(hSchemaVersion[:SetElementId]);

            aSchemaRows = ["--#{@sNs}Schema"];
            aSchemaRows << "sClass: #{hSchema[:Name]}";
            aSchemaRows << "sDoc: #{hSchema[:Doc]}";
            aSchemaRows << "sVersion: #{hSchemaVersion[:Name]}";
            aSchemaRows << "sVersionDoc: #{hSchemaVersion[:Doc]}";

            # schema elements **************************************************
            @@hSetElementKinds.each { |sSchemaElementKind, sFullKindName|
                sQuery = SchemaElement.select_where({
                    SchemaVersionId: sSchemaVersionId,
                    Kind:            sSchemaElementKind,
                });
                puts("@ SchemaElement: #{sQuery}");
                aSchemaElements = [];
                @oDb.execute(sQuery).each { |aRow|
                    aSchemaElements << SchemaElement.format_row(aRow);
                }
                aSchemaRows << "a#{sFullKindName}s:";
                aSchemaElements.each { |hSchemaElement|
                    aSchemaRows << "#{@sNs}#{sFullKindName}";
                    hSetElement        = get_set_element(hSchemaElement[:SetElementId]);
                    hSetElementVersion = get_set_element_version(hSchemaElement[:SetElementVersionId]);
                    aSchemaRows << "  sClass: #{hSetElement[:Name]}";
                    aSchemaRows << "  sDoc: #{hSetElement[:Doc]}";
                    aSchemaRows << "  sVersion: #{hSetElementVersion[:Name]}";
                    aSchemaRows << "  sVersionDoc: #{hSetElementVersion[:Doc]}";
                    aSchemaRows << "  sConfig: #{hSetElementVersion[:Config]}";
                }
            }

            # schema components ************************************************
            sQuery = Component.select_where({SchemaVersionId: sSchemaVersionId,});
            puts("@ Component: #{sQuery}");
            aSchemaComponents = @oDb.execute(sQuery).collect { |aRow|
                Component.format_row(aRow);
            }
            return success(aSchemaRows.join("\n")) if aSchemaComponents.empty?;

            aSchemaRows << 'aComponents:';
            aSchemaComponents.each { |hSchemaComponent|
                # iterate through the component versions
                sQuery = ComponentVersion.select_where({CompId: hSchemaComponent[:Id]});
                puts("@ ComponentVersion: #{sQuery}");
                aComponentVersions = @oDb.execute(sQuery).collect { |aRow|
                    ComponentVersion.format_row(aRow);
                }
                aComponentVersions.each { |hSchemaComponentVersion|
                    aSchemaRows << "#{@sNs}Component";
                    aSchemaRows << "  sClass: #{hSchemaComponent[:Class]}";
                    aSchemaRows << "  sName: #{hSchemaComponent[:Name]}";
                    aSchemaRows << "  sDoc: #{hSchemaComponent[:Doc]}";
                    aSchemaRows << "  sVersion: #{hSchemaComponentVersion[:Name]}";
                    aSchemaRows << "  sVersionDoc: #{hSchemaComponentVersion[:Doc]}";
                    aSchemaRows << "  sAuthorz: #{hSchemaComponentVersion[:Auth]}";

                    # component primitives *************************************
                    aSchemaRows << '  aPrimitives:';
                    sQuery = Primitive.select_where({ParentId: hSchemaComponentVersion[:Id]});
                    puts("@ Primitive: #{sQuery}")
                    aPrimitives = @oDb.execute(sQuery).collect { |aRow|
                        hPrimitive = Primitive.format_row(aRow);
                        aSchemaRows << "  #{@sNs}Primitive";
                        aSchemaRows << "    sClass: #{hPrimitive[:Class]}";
                        aSchemaRows << "    sVersion: #{hPrimitive[:Version]}";
                        aSchemaRows << "    sName: #{hPrimitive[:Name]}";
                        aSchemaRows << "    sDoc: #{hPrimitive[:Doc]}";
                        aSchemaRows << "    bNullable: #{hPrimitive[:Nullable] == 1}";
                        aSchemaRows << "    sValidation: #{hPrimitive[:Valid]}";
                        aSchemaRows << "    sUnit: #{hPrimitive[:Unit]}";
                        aSchemaRows << "    sEnumeration: #{hPrimitive[:Enum]}";
                    }

                    # component children ***************************************
                    aSchemaRows << '  aChildren:';
                    sQuery = Child.select_where({ParentId: hSchemaComponentVersion[:Id]});
                    puts("@ Child: #{sQuery}")
                    aChildren = @oDb.execute(sQuery).collect { |aRow|
                        hChild = Child.format_row(aRow);
                        aSchemaRows << "  #{@sNs}Child";
                        aSchemaRows << "    sClassId: #{hChild[:Comp]}";
                        aSchemaRows << "    bArray: #{hChild[:Array] == 1}";
                        aSchemaRows << "    bNullable: #{hChild[:Nullable] == 1}";
                    }
                }
            }

            return success(aSchemaRows.join("\n"));
        end

        def respond_versions
            @oDb = SQLite3::Database.new(@sDbFile);
            aVersions = [];
            [SetVersion, SetElementVersion, ComponentVersion].each { |oClass|
                sQuery =  oClass.select;
                @oDb.execute(oClass.select).each { |aRow|
                    hObj = oClass.format_row(aRow);
                    aVersions << {
                        Type: oClass.to_s,
                        Id: hObj[:Id],
                        Name: hObj[:Name],
                    };
                }
            }

            return success(aVersions);
        end

        def respond_net_vis
            sType = @hParams['Type'];
            case sType
                when 'SetVersion' then return respond_set_version_net_vis;
                when 'SchemaVersion' then return respond_schema_version_net_vis;
                else return error("No implementation for net vis '#{sType}'");
            end
        end

        def get_set(_nSetId)
            sQuery = Set.select_obj({'Id' => _nSetId});
            puts("@ Set: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                return Set.format_row(aRow); # execute only the first row
            }
            return {};
        end

        def get_set_version(_nSetVersionId)
            sQuery = SetVersion.select_obj({'Id' => _nSetVersionId});
            puts("@ SetVersion: #{sQuery}");
            @oDb.execute(sQuery).each { |aRow|
                return SetVersion.format_row(aRow); # execute only the first row
            }
            return {};
        end

        def respond_set_version_net_vis
            sSetVersionId = @hParams['SetVersionId'];

            aNodes = [];
            aEdges = [];
            hNodes = {};

            @oDb = SQLite3::Database.new(@sDbFile);

            # root node
            hSetVersion = get_set_version(sSetVersionId);
            hSet        = get_set(hSetVersion[:SetId]);
            aNodes << {
                id: "SetVersion_#{sSetVersionId}",
                label: "#{hSet[:Name]}/#{hSetVersion[:Name]}",
                title: hSetVersion[:Doc],
                group: 'set_version',
                shape: 'image',
                image: "./images/icons/Set.png",
            };

            @@hSetElementKinds.each { |sSetElementKind, sFullKindName|
                # set element kind node
                hNodes[sSetElementKind] = [];
                aNodes << {
                    id: "#{sSetElementKind}_0",
                    label: sFullKindName,
                    title: sFullKindName,
                    group: sSetElementKind,
                    shape: 'box',
                };

                aEdges << {
                    from: "SetVersion_#{sSetVersionId}",
                    to:   "#{sSetElementKind}_0",
                };

                # set element nodes
                sQuery = SetElement.select_where({
                    SetVersionId: sSetVersionId,
                    Kind:         sSetElementKind,
                });
                puts("@ SetElement: #{sQuery}");
                aSetElements = @oDb.execute(sQuery).collect { |aRow|
                    SetElement.format_row(aRow);
                }
                aSetElements.each { |hSetElement|
                    hNodes[sSetElementKind] << hSetElement[:Id];
                    aNodes << {
                        id: "#{sSetElementKind}_#{hSetElement[:Id]}",
                        label: hSetElement[:Name],
                        title: hSetElement[:Doc],
                        group: sSetElementKind,
                        shape: 'image',
                        image: "./images/icons/#{sSetElementKind}.png",
                    };
                }
            }

            # edges from root node to set element nodes
            hNodes.each { |sSetElementKind, aNodes|
                aNodes.each { |nIdx|
                    aEdges << {
                        from: "#{sSetElementKind}_0",
                        to:   "#{sSetElementKind}_#{nIdx}",
                    };
                }
            }

            return success({nodes: aNodes, edges: aEdges});
        end

    end # class SchemaHandler

end # module Schema
