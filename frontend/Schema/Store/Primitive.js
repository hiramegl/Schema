Ext.define('Schema.Store.Primitive', {
    extend: 'Ext.data.Store',
    model: Ext.create('Schema.Model.Primitive'),
    proxy: Ext.create('Schema.Common.Store.Proxy', {
        url: '/app.api?cmd=list',
        reader: {type: 'json', root: 'data'},
    }),
    autoLoad: false,

    loadComponentVersion: function(_nCompVersionId) {
        this.getProxy().
            setUrl('/app.api?cmd=list').
            setExtraParams({
                Type: 'Primitive',
                Where: 'ParentId',
                ParentId: _nCompVersionId,
            });
        this.load();
    },
});
