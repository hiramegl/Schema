Ext.define('Schema.Common.Store.ComboBox', {
    extend: 'Ext.data.Store',
    proxy: {
        type: 'ajax',
        url: '/app.api?cmd=query',
        actionMethods: {read: 'POST'},
        reader: {type: 'json', root: 'data'},
    },
    fields: [
        {name: 'Name' , type: 'string'},
        {name: 'Value', type: 'string'},
    ],
    autoLoad: false,
});
