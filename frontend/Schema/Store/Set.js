Ext.define('Schema.Store.Set', {
    extend: 'Ext.data.TreeStore',
    model: Ext.create('Schema.Model.Set'),
    proxy: Ext.create('Schema.Common.Store.Proxy', {
        url: '/app.api?cmd=tree',
        extraParams: { Type: 'Set' },
    }),
});
