Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.PrimitiveWindow', {
    extend: 'Ext.window.Window',
    width: 400,
    height: 580,
    bodyPadding: 5,
    layout: {
        type: 'vbox',
        align: 'stretch',
    },
    bind: 'Primitive: {Record.Name}', // title of the window
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
            bind: 'Primitive',
        }, {
            xtype: 'textfield',
            name: 'Id',
            fieldLabel: 'Id',
            readOnly: true,
            bind: '{Record.Id}',
        }, {
            xtype: 'textfield',
            name: 'ParentId',
            fieldLabel: 'ParentId',
            readOnly: true,
            bind: '{Record.ParentId}',
        }, {
            xtype: 'combobox',
            name: 'Class',
            fieldLabel: 'Class',
            bind: '{Record.Class}',
            selectOnFocus: true,
            valueField: 'Name',
            displayField: 'Name',
            editable: false,
            forceSelection: true,
            allowBlank: false,
            store: Ext.create('Ext.data.Store', {
                fields: ['Name'],
                data : [
                    {'Name':'string'},
                    {'Name':'number'},
                    {'Name':'bool'},
                ],
            }),
            listeners: {
                afterrender: function(_oComboBox) {
                    _oComboBox.focus(false, 0);
                }
            },
        }, {
            xtype: 'textfield',
            name: 'Version',
            fieldLabel: 'Version',
            readOnly: true,
            bind: '{Record.Version}',
            selectOnFocus: true,
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
        }, {
            xtype: 'checkbox',
            name: 'Nullable',
            fieldLabel: 'Nullable',
            bind: '{Record.Nullable}',
            inputValue: 1,
            uncheckedValue: 0,
        }, {
            xtype: 'combobox',
            name: 'Valid',
            fieldLabel: 'Valid',
            bind: '{Record.Valid}',
            valueField: 'Value',    // value field from the store
            displayField: 'Name',   // name  field from the store
            editable: false,        // do not allow to edit the text
            validateOnChange: true, // validate on change
            vtype: 'version',       // validation type: alpha-numeric
            Config: {Kind: 'Valid'},
            store: Ext.create('Schema.Common.Store.ComboBox'),
            listeners: {
                afterrender: comboboxAfterrenderHandler,
            },
        }, {
            xtype: 'combobox',
            name: 'Unit',
            fieldLabel: 'Unit',
            bind: '{Record.Unit}',
            valueField: 'Value',
            displayField: 'Name',
            editable: false,
            validateOnChange: true,
            vtype: 'version',
            Config: {Kind: 'Unit'},
            store: Ext.create('Schema.Common.Store.ComboBox'),
            listeners: {
                afterrender: comboboxAfterrenderHandler,
            },
        }, {
            xtype: 'combobox',
            name: 'Enum',
            fieldLabel: 'Enum',
            bind: '{Record.Enum}',
            valueField: 'Value',
            displayField: 'Name',
            editable: false,
            validateOnChange: true,
            vtype: 'version',
            Config: {Kind: 'Enum'},
            store: Ext.create('Schema.Common.Store.ComboBox'),
            listeners: {
                afterrender: comboboxAfterrenderHandler,
            },
        }],
        buttons: [{
            text: 'Save',
            listeners: { click: saveButtonClickHandler },
        }, {
            text: 'Cancel',
            listeners: { click: cancelButtonClickHandler },
        }],
    }],
});
