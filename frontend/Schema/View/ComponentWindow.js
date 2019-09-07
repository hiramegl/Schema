Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.ComponentWindow', {
    extend: 'Ext.window.Window',
    width: 350,
    height: 360,
    bodyPadding: 5,
    layout: {
        type: 'vbox',
        align: 'stretch',
    },
    bind: 'Component {Record.Class}', // title of the window
    items: [{
        xtype: 'form',
        frame: false,
        header: false,
        bodyPadding: 0,
        defaults: {
            anchor: '100%',
            labelAlign: 'right',
            labelWidth: 60,
        },
        items: [{
            xtype: 'hiddenfield',
            name: 'Type',
            bind: 'Component',
        }, {
            xtype: 'textfield',
            name: 'Id',
            fieldLabel: 'Id',
            readOnly: true,
            bind: '{Record.Id}',
        }, {
            xtype: 'textfield',
            name: 'SchemaVersionId',
            fieldLabel: 'SchemaVersionId',
            readOnly: true,
            bind: '{Record.SchemaVersionId}',
        }, {
            xtype: 'textfield',
            name: 'Class',
            fieldLabel: 'Class',
            bind: '{Record.Class}',
            selectOnFocus: true,
            listeners: {
                afterrender: function(_oTextField) {
                    _oTextField.focus(false, 0);
                }
            },
        }, {
            xtype: 'textfield',
            name: 'Name',
            fieldLabel: 'Name',
            bind: '{Record.Name}',
            selectOnFocus: true,
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
            formBind: true,
            listeners: { click: saveButtonClickHandler },
        }, {
            text: 'Cancel',
            listeners: { click: cancelButtonClickHandler },
        }],
    }],
});

