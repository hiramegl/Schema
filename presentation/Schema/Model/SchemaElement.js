Ext.define('Schema.Model.SchemaElement', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'Id'     , type: 'int'},
        {name: 'Name'   , type: 'string'},
        {name: 'Version', type: 'string'},
    ],
});
