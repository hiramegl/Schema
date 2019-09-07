Ext.define('Schema.Common.Store.TreeGridStore', {
    extend: 'Ext.data.TreeStore',
    autoDestroy: false,
    loadUrl: function (_sUrl) {
        this.getProxy().setUrl(_sUrl);
        this.load();
    },
});
