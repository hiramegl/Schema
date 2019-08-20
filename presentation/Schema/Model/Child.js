Ext.define('Schema.Model.Child', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'Id'      , type: 'int'},
        {name: 'ParentId', type: 'int'},
        {name: 'Comp'    , type: 'string'},
        {name: 'Array'   , type: 'boolean'},
        {name: 'Nullable', type: 'boolean'},
    ],
});
