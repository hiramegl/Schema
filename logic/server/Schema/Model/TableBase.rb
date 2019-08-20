module Schema

    class TableBase

        # **********************************************************************

        TABLE  = "TableName";
        CONFIG = {};
        def self.table;  return TABLE;  end
        def self.config; return CONFIG; end

        # class methods ********************************************************

        def self.get_drop_query
            return "DROP TABLE IF EXISTS #{self.table}";
        end

        def self.get_create_query
            sCols = self.config.collect {|zName, sConfig| "#{zName} #{sConfig}"}.join(',');
            return "CREATE TABLE IF NOT EXISTS #{self.table} (#{sCols})"
        end

        def self.insert_obj(_hParams)
            aFields = []; aValues = [];
            self.config.each_key { |zName|
                sName  = zName.to_s;
                sValue = _hParams[sName].to_s.gsub("'", "''");
                next if (sName == 'Id' && sValue.to_i == 0);

                aFields << sName;
                aValues << "'#{sValue}'";
            }
            return "INSERT INTO #{self.table} (#{aFields.join(',')}) VALUES(#{aValues.join(',')})";
        end

        def self.select(_hParams = nil)
            if (_hParams && _hParams['Where'] != nil)
                # select specific objects
                hWhere = {};
                _hParams['Where'].split(',').each { |sCol|
                    hWhere[sCol] = _hParams[sCol];
                }
                return self.select_where(hWhere);
            end

            # select all objects
            return "SELECT * FROM #{self.table} ORDER BY Id";
        end

        def self.select_obj(_hParams)
            return "SELECT * FROM #{self.table} WHERE Id = '#{_hParams['Id']}'";
        end

        def self.select_where(_hWhere)
            sWhere = _hWhere.collect{ |sKey, sValue| "#{sKey} = '#{sValue}'" }.join(' AND ');
            return "SELECT * FROM #{self.table} WHERE #{sWhere}";
        end

        def self.update_obj(_hParams)
            aCols = [];
            self.config.each_key { |zName|
                next if (zName == :Id);
                aCols << "#{zName}='#{_hParams[zName.to_s]}'";
            }
            sCols = aCols.join(',');

            return "UPDATE #{self.table} SET #{sCols} WHERE Id = '#{_hParams['Id']}'";
        end

        def self.delete_obj(_hParams)
            return "DELETE FROM #{self.table} WHERE Id = '#{_hParams['Id']}'";
        end

        def self.format_row(_aRow)
            nIdx = 0;
            hRow = {};
            self.config.each_key { |zName|
                hRow[zName] = _aRow[nIdx];
                nIdx += 1;
            }

            return hRow;
        end

    end # class TableBase

end # module Schema

