Ext.define('Schema.Store.SetElement', {
    extend: 'Ext.data.TreeStore',
    model: Ext.create('Schema.Model.SetElement'),
    proxy: Ext.create('Schema.Common.Store.Proxy', {
        url: '/app.api?cmd=tree',
        extraParams: {
            Type: 'SetElement',
            SetVersionId: 0,
        },
    }),

    // public event handlers

    loadSet: function(_nSetId) {
        this.getProxy().
            setUrl('/app.api?cmd=tree').
            setExtraParams({
                Type: 'SetElement',
                SetVersionId: 0,
            });
        this.load();
    },
    loadSetVersion: function(_nSetVersionId) {
        this.getProxy().
            setUrl('/app.api?cmd=tree').
            setExtraParams({
                Type: 'SetElement',
                SetVersionId: _nSetVersionId,
            });
        this.load();
    },
});
