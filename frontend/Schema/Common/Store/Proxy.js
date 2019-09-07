Ext.define('Schema.Common.Store.Proxy', {
    extend: 'Ext.data.proxy.Ajax',
    actionMethods: {
        create:  'POST',
        read:    'POST',
        update:  'POST',
        destroy: 'POST'
    },
    listeners: {
        exception: function (_oProxy, _oReq, _oOperation, _oOpts) {
            Ext.Msg.alert('Error', _oReq.responseText);
        }
    },
});

