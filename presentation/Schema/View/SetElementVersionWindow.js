Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.SetElementVersionWindow', {
    extend: 'Ext.window.Window',
    width: 350,
    height: 410,
    bodyPadding: 5,
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    bind: 'Set element version: {Record.Name}', // title of the window
    items: [{
        xtype: 'form',
        frame: false,
        header: false,
        bodyPadding: 0,
        defaults: {
            anchor: '100%',
            labelAlign: 'right',
            labelWidth: 80
        },
        items: [{
            xtype: 'hiddenfield',
            name: 'Type',
            bind: 'SetElementVersion'
        }, {
            xtype: 'textfield',
            name: 'Id',
            fieldLabel: 'Id',
            readOnly: true,
            bind: '{Record.Id}'
        }, {
            xtype: 'textfield',
            name: 'SetElementId',
            fieldLabel: 'SetElementId',
            readOnly: true,
            bind: '{Record.SetElementId}'
        }, {
            xtype: 'textfield',
            name: 'Name',
            fieldLabel: 'Name',
            bind: '{Record.Name}',
            selectOnFocus: true,
            listeners: {
                afterrender: function(_oTextField) {
                    _oTextField.focus(false, 0);
                }
            },
        }, {
            xtype: 'textarea',
            name: 'Doc',
            fieldLabel: 'Doc',
            height: 60,
            bind: '{Record.Doc}',
            selectOnFocus: true,
        }, {
            xtype: 'textarea',
            name: 'Config',
            fieldLabel: 'Config',
            height: 60,
            bind: '{Record.Config}',
            selectOnFocus: true,
        }],
        buttons: [{
            text: 'Save',
            listeners: { click: saveButtonClickHandler }
        }, {
            text: 'Cancel',
            listeners: { click: cancelButtonClickHandler }
        }],
    }],
});
