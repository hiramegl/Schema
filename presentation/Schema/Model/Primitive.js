Ext.define('Schema.Model.Primitive', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'Id'      , type: 'int'},
        {name: 'ParentId', type: 'int'},
        {name: 'Class'   , type: 'string'},
        {name: 'Version' , type: 'string'},
        {name: 'Doc'     , type: 'string'},
        {name: 'Name'    , type: 'string'},
        {name: 'Version' , type: 'string'},
        {name: 'Nullable', type: 'boolean'},
        {name: 'Valid'   , type: 'string'},
        {name: 'Unit'    , type: 'string'},
        {name: 'Enum'    , type: 'string'},
    ],
});
