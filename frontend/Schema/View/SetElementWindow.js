Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.SetElementWindow', {
    extend: 'Ext.window.Window',
    width: 350,
    height: 365,
    bodyPadding: 5,
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    bind: 'Set element: {Record.Name}', // title of the window
    items: [{
        xtype: 'form',
        frame: false,
        header: false,
        bodyPadding: 0,
        defaults: {
            anchor: '100%',
            labelAlign: 'right',
            labelWidth: 50
        },
        items: [{
            xtype: 'hiddenfield',
            name: 'Type',
            bind: 'SetElement'
        }, {
            xtype: 'textfield',
            name: 'Id',
            fieldLabel: 'Id',
            readOnly: true,
            bind: '{Record.Id}'
        }, {
            xtype: 'textfield',
            name: 'SetVersionId',
            fieldLabel: 'SetVersionId',
            readOnly: true,
            bind: '{Record.SetVersionId}'
        }, {
            xtype: 'textfield',
            name: 'Kind',
            fieldLabel: 'Kind',
            readOnly: true,
            bind: '{Record.Kind}'
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
