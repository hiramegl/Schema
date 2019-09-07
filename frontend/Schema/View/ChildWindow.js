Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.ChildWindow', {
    extend: 'Ext.window.Window',
    width: 320,
    height: 320,
    bodyPadding: 5,
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    bind: 'Child: {Record.Comp}', // title of the window
    items: [{
        xtype: 'form',
        header: false,
        bodyPadding: 5,
        defaults: {
            anchor: '100%',
            labelAlign: 'right',
            labelWidth: 60,
        },
        items: [{
            xtype: 'hiddenfield',
            name: 'Type',
            bind: 'Child'
        }, {
            xtype: 'textfield',
            name: 'Id',
            fieldLabel: 'Id',
            readOnly: true,
            bind: '{Record.Id}'
        }, {
            xtype: 'textfield',
            name: 'ParentId',
            fieldLabel: 'ParentId',
            readOnly: true,
            bind: '{Record.ParentId}'
        }, {
            xtype: 'combobox',
            name: 'Comp',
            fieldLabel: 'Comp',
            bind: '{Record.Comp}',
            selectOnFocus: true,
            valueField: 'Name',
            displayField: 'Name',
            editable: false,
            forceSelection: true,
            allowBlank: false,
            Config: {Kind: 'Comp'},
            store: Ext.create('Schema.Common.Store.ComboBox'),
            listeners: {
                afterrender: comboboxAfterrenderHandler,
            },
        }, {
            xtype: 'checkbox',
            name: 'Array',
            fieldLabel: 'Array',
            bind: '{Record.Array}',
            inputValue: 1,
            uncheckedValue: 0,
        }, {
            xtype: 'checkbox',
            name: 'Nullable',
            fieldLabel: 'Nullable',
            bind: '{Record.Nullable}',
            inputValue: 1,
            uncheckedValue: 0,
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
