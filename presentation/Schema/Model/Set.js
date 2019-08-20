Ext.define('Schema.Model.Set', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'Id'  , type: 'int'},
        {name: 'Name', type: 'string'},
        {name: 'Doc' , type: 'string'},
    ],
});
