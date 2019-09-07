Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.SchemaElementWindow', {
    extend: 'Ext.window.Window',
    width: 350,
    height: 310,
    bodyPadding: 5,
    layout: {
        type: 'vbox',
        align: 'stretch',
    },
    title: 'Schema Element', // title of the window
    items: [{
        xtype: 'form',
        frame: false,
        header: false,
        pollForChanges: true, // poll to validate form fields
        pollInterval: 500,    // poll every 1/2 second
        bodyPadding: 0,
        defaults: {
            anchor: '100%',
            labelAlign: 'right',
            labelWidth: 130,
        },
        items: [{
            xtype: 'hiddenfield',
            name: 'Type',
            bind: 'SchemaElement',
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
            name: 'Kind',
            fieldLabel: 'Kind',
            readOnly: true,
            bind: '{Record.Kind}',
        }, {
            xtype: 'combobox',
            name: 'SetElementId',
            fieldLabel: 'SetElement',
            bind: '{Record.SetElementId}',
            valueField: 'Id',      // value field from the store
            displayField: 'Name',  // name  field from the store
            editable: false,       // do not allow to edit the text
            forceSelection: true,  // force item selection and not free-text
            validateOnChange: true,// validate on change
            vtype: 'alphanum',     // validation type: alpha-numeric
            allowBlank: false,     // do not allow blank selection
            store: Ext.create('Ext.data.Store', {
                proxy: {
                    type: 'ajax',
                    url: '/app.api?cmd=list',
                    actionMethods: {read: 'POST'},
                    reader: {type: 'json', root: 'data'},
                },
                fields: [
                    {name: 'Id', type: 'string'},
                    {name: 'Name', type: 'string'},
                ],
                autoLoad: false,
            }),
            listeners: {
                afterrender: function(_oComboBox) {
                    _oComboBox.focus(false, 0);
                    var hConfig = _oComboBox.findParentByType('window').Config;
                    var oStore  = _oComboBox.getStore();

                    oStore.getProxy().setExtraParams({
                        Type: 'SetElement',
                        Where: 'Kind,SetVersionId',
                        Kind: hConfig.Kind,
                        SetVersionId: hConfig.SetVersionId,
                    });
                    oStore.load();
                },
                change: function(_oComboBox, _oNewValue, _oOldValue, _oOptions) {
                    var oSetElementVersionIdCombobox = _oComboBox.nextSibling();
                    var oStore = oSetElementVersionIdCombobox.getStore();
                    oStore.getProxy().setExtraParams({
                        Type: 'SetElementVersion',
                        Where: 'SetElementId',
                        SetElementId: _oNewValue,
                    });
                    oStore.load();
                },
            },
        }, {
            xtype: 'combobox',
            name: 'SetElementVersionId',
            fieldLabel: 'SetElementVersionId',
            bind: '{Record.SetElementVersionId}',
            valueField: 'Id',
            displayField: 'Name',
            forceSelection: true,
            editable: false,
            validateOnChange: true,
            vtype: 'alphanum',
            allowBlank: false,
            store: Ext.create('Ext.data.Store', {
                proxy: {
                    type: 'ajax',
                    url: '/app.api?cmd=list',
                    actionMethods: {read: 'POST'},
                    reader: {type: 'json', root: 'data'},
                },
                fields: [
                    {name: 'Id', type: 'string'},
                    {name: 'Name', type: 'string'},
                ],
                autoLoad: false,
            }),
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
