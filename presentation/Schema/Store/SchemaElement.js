Ext.define('Schema.Store.SchemaElement', {
    extend: 'Ext.data.TreeStore',
    model: Ext.create('Schema.Model.SchemaElement'),
    proxy: Ext.create('Schema.Common.Store.Proxy', {
        url: '/app.api?cmd=tree',
        extraParams: {
            Type: 'SchemaElement',
            SchemaVersionId: 0,
        },
    }),

    // public event handlers

    clear: function() {
        this.getProxy().
            setUrl('/app.api?cmd=tree').
            setExtraParams({
                Type: 'SchemaElement',
                SchemaVersionId: 0,
            });
        this.load();
    },
    loadSchemaVersion: function(_nSchemaVersionId) {
        this.getProxy().
            setUrl('/app.api?cmd=tree').
            setExtraParams({
                Type: 'SchemaElement',
                SchemaVersionId: _nSchemaVersionId,
            });
        this.load();
    },
});
