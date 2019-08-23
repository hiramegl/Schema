Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.SchemaVersionRenderWindow', {
    extend: 'Ext.window.Window',
    width: 1000,
    height: 800,
    bodyPadding: 5,
    layout: {
        type: 'vbox',
        align: 'stretch',
    },
    bind: 'Schema: {Record.Name}', // title of the window
    items: [{
        xtype: 'form',
        header: false,
        bodyPadding: 5,
        defaults: {
            anchor: '100%',
            labelAlign: 'right',
            labelWidth: 30,
        },
        items: [{
            xtype: 'textarea',
            id: 'txaYaml',
            name: 'Yaml',
            fieldLabel: 'Yaml',
            height: 680,
            selectOnFocus: true,
            listeners: {
                afterrender: function (_oTextArea, _oOptions) {
                    var oWindow = _oTextArea.findParentByType('window');
                    var nSchemaVersionId = oWindow.Config.SetElementVersionId;

                    Ext.Ajax.request({
                        url: '/app.api?cmd=query',
                        method: 'POST',
                        params: {
                            Type: 'SetElementVersion',
                            Query: 'RenderSchemaVersion',
                            SchemaVersionId: nSchemaVersionId,
                        },
                        success: function(_oResponse, _oOptions) {
                            var oResp = Ext.JSON.decode(_oResponse.responseText);
                            _oTextArea.setValue(oResp.data);
                        },
                    });
                },
            },
        }],
        buttons: [{
            text: 'Cancel',
            listeners: { click: cancelButtonClickHandler },
        }],
    }],
});
