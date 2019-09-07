Ext.require('Schema.Common.Handlers.Buttons');

Ext.define('Schema.View.ComponentVersionWindow', {
    extend: 'Ext.window.Window',
    width: 1300,
    height: 700,
    bodyPadding: 5,
    layout: 'border',
    bind: 'Component version: {Record.Name}', // title of the window

    bubbleEvents: [
        'record_changed',
    ],

    items: [{
        xtype: 'panel',
        region: 'west',
        split: true,
        collapsible: true,
        header: false,
        minWidth: 400,
        width: 400,
        layout: {
            type: 'vbox',
            pack: 'start',
            align: 'stretch',
        },
        items: [{
            xtype: 'form',
            region: 'north',
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
                bind: 'ComponentVersion'
            }, {
                xtype: 'textfield',
                name: 'Id',
                id: 'txfComponentVersionId',
                fieldLabel: 'Id',
                readOnly: true,
                bind: '{Record.Id}'
            }, {
                xtype: 'textfield',
                name: 'CompId',
                fieldLabel: 'CompId',
                readOnly: true,
                bind: '{Record.CompId}'
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
                xtype: 'combobox',
                name: 'Auth',
                fieldLabel: 'Auth',
                bind: '{Record.Auth}',
                valueField: 'Name',    // value field from the store
                displayField: 'Name',  // name  field from the store
                editable: false,       // do not allow to edit the text
                forceSelection: true,  // force item selection and not free-text
                //validateOnChange: true,// validate on change
                //vtype: 'alphanum',     // validation type: alpha-numeric
                allowBlank: false,     // do not allow blank selection
                Config: {Kind: 'Auth'},
                store: Ext.create('Schema.Common.Store.ComboBox'),
                listeners: {
                    afterrender: comboboxAfterrenderHandler,
                },
            }],
            buttons: [{
                text: 'Save',
                listeners: {
                    click: function (_oButton) {
                        var oForm = this.up('form').getForm();
                        if (oForm.isValid() == false) return;
                        oForm.submit({
                            url: '/app.api?cmd=' + this.up('window').Cmd,
                            success: function(_oForm, _oAction) {
                                var nId      = _oAction.result.data;
                                var oWindow  = _oForm.owner.up('window');

                                // update id textfield with new value
                                Ext.getCmp('txfComponentVersionId').setValue(nId);

                                // update record id so that the primitives and children can use it
                                oWindow.updateViewModel();
                                oWindow.Config.CompVersionId = nId;

                                // if we were in create mode then change to update mode
                                oWindow.Cmd = 'update';

                                // dispatch an event to update the schema elements panel
                                oWindow.dispatchComponentVersionChange();
                            },
                            failure: function(_oForm, _oAction) {
                                Ext.Msg.alert('Error', _oAction.result.msg);
                            }
                        });
                    }
                },
            }],
        }, {
            xtype: 'grid',

            store: Ext.create('Schema.Store.Child'),
            emptyText: 'No Children Components added yet',

            header: false,
            frame: false,
            flex: 1,

            columns: [
                { text: 'Id',       flex: 1, sortable: true, dataIndex: 'Id',       },
                { text: 'ParentId', flex: 1, sortable: true, dataIndex: 'ParentId', },
                { text: 'Comp',     flex: 3, sortable: true, dataIndex: 'Comp',     },
                { text: 'Array',    flex: 1, sortable: true, dataIndex: 'Array',    },
                { text: 'Nullable', flex: 1, sortable: true, dataIndex: 'Nullable', },
            ],
            listeners: {
                afterrender: function(_oGridPanel) {
                    var hConfig = _oGridPanel.findParentByType('window').Config;
                    this.getStore().loadComponentVersion(hConfig.CompVersionId);
                },
                rowcontextmenu: function(_oGridView, _oRecord, _oTrElement, _nRowIndex, _oEvent, _oOptions) {
                    _oEvent.preventDefault(); // no native ctx menu

                    var oWindow   = _oGridView.findParentByType('window');
                    var oGrid     = _oGridView.findParentByType('gridpanel');
                    var oData     = _oRecord.data;
                    var nParentId = oData['ParentId'];
                    oData.Name    = oData.Comp;

                    new Ext.menu.Menu({
                        floating: true,
                        Config: { Record: _oRecord, Cont: oGrid },
                        items: [{
                            text: 'Edit Child',
                            iconCls: 'x-fa fa-edit',
                            Config: {
                                Type: 'Child',
                                Cmd: 'update',
                                ParentId: nParentId,
                                SchemaVersionId: oWindow.Config.SchemaVersionId,
                                RecordBuilder: function (_oData) { return _oData; },
                            },
                            handler: operateObjectHandler,
                        }, {
                            text: 'Delete Child',
                            iconCls: 'x-fa fa-minus-square',
                            Config: { Type: 'Child' },
                            handler: deleteObjectHandler
                        }],
                    }).showAt(_oEvent.getXY());
                },
                containercontextmenu: function(_oView, _oEvent, _oOptions) {
                    _oEvent.preventDefault(); // no native ctx menu

                    var oGrid   = _oView.up();
                    var oWindow = _oView.findParentByType('window');

                    var sSchemaVersionId = oWindow.Config.SchemaVersionId;
                    var nParentId        = oWindow.Config.CompVersionId;
                    var oRecord          = { data: { ParentId: nParentId } };

                    new Ext.menu.Menu({
                        floating: true,
                        Config: { Cont: oGrid, Record: oRecord },
                        items: [{
                            text: 'Add Child',
                            iconCls: 'x-fa fa-plus-square',
                            Config: {
                                Type: 'Child',
                                Cmd: 'create',
                                ParentId: nParentId,
                                SchemaVersionId: sSchemaVersionId,
                                RecordBuilder: function (_oData) {
                                    return {
                                        Id: 0,
                                        ParentId: _oData.ParentId,
                                        Comp: 'class',
                                        'Array': false,
                                        Nullable: false,
                                    };
                                },
                            },
                            handler: operateObjectHandler,
                        }, '-', {
                            text: 'Refresh',
                            iconCls: 'x-fa fa-spinner',
                            handler: refreshCont,
                        }]
                    }).showAt(_oEvent.getXY());
                },
            },
        }],
    }, {
        region: 'center',
        xtype: 'grid',

        store: Ext.create('Schema.Store.Primitive'),
        emptyText: 'No Primitives added yet',

        header: false,
        frame: false,

        columns: [
            { text: 'Id',       flex: 1, sortable: true, dataIndex: 'Id',       },
            { text: 'Name',     flex: 2, sortable: true, dataIndex: 'Name',     },
            { text: 'Class',    flex: 1, sortable: true, dataIndex: 'Class',    },
            { text: 'Version',  flex: 1, sortable: true, dataIndex: 'Version',  },
            { text: 'Doc',      flex: 3, sortable: true, dataIndex: 'Doc',      },
            { text: 'Nullable', flex: 1, sortable: true, dataIndex: 'Nullable', },
            { text: 'Valid',    flex: 1, sortable: true, dataIndex: 'Valid',    },
            { text: 'Unit',     flex: 1, sortable: true, dataIndex: 'Unit',     },
            { text: 'Enum',     flex: 1, sortable: true, dataIndex: 'Enum',     },
        ],

        listeners: {
            afterrender: function(_oGridPanel) {
                var hConfig = _oGridPanel.findParentByType('window').Config;
                this.getStore().loadComponentVersion(hConfig.CompVersionId);
            },
            rowcontextmenu: function(_oGridView, _oRecord, _oTrElement, _nRowIndex, _oEvent, _oOptions) {
                _oEvent.preventDefault(); // no native ctx menu

                var oWindow   = _oGridView.findParentByType('window');
                var oGrid     = _oGridView.findParentByType('gridpanel');
                var oData     = _oRecord.data;
                var nParentId = _oRecord.data['ParentId'];

                new Ext.menu.Menu({
                    floating: true,
                    Config: { Record: _oRecord, Cont: oGrid },
                    items: [{
                        text: 'Edit Primitive',
                        iconCls: 'x-fa fa-edit',
                        Config: {
                            Type: 'Primitive',
                            Cmd: 'update',
                            ParentId: nParentId,
                            SchemaVersionId: oWindow.Config.SchemaVersionId,
                            RecordBuilder: function (_oData) { return _oData; },
                        },
                        handler: operateObjectHandler,
                    }, {
                        text: 'Delete Primitive',
                        iconCls: 'x-fa fa-minus-square',
                        Config: { Type: 'Primitive' },
                        handler: deleteObjectHandler
                    }],
                }).showAt(_oEvent.getXY());
            },
            containercontextmenu: function(_oView, _oEvent, _oOptions) {
                _oEvent.preventDefault(); // no native ctx menu

                var oGrid   = _oView.up();
                var oWindow = _oView.findParentByType('window');

                var sSchemaVersionId = oWindow.Config.SchemaVersionId;
                var nParentId        = oWindow.Config.CompVersionId;
                var oRecord          = { data: { ParentId: nParentId } };

                new Ext.menu.Menu({
                    floating: true,
                    Config: { Cont: oGrid, Record: oRecord },
                    items: [{
                        text: 'Add Primitive',
                        iconCls: 'x-fa fa-plus-square',
                        Config: {
                            Type: 'Primitive',
                            Cmd: 'create',
                            ParentId: nParentId,
                            SchemaVersionId: sSchemaVersionId,
                            RecordBuilder: function (_oData) {
                                return {
                                    Id: 0,
                                    ParentId: _oData.ParentId,
                                    Class: 'New class',
                                    Version: 'v_1.0',
                                    Name: 'New class name',
                                    Doc: 'Doc',
                                    Nullable: false,
                                    Valid: '',
                                    Unit: '',
                                    Enum: '',
                                };
                            },
                        },
                        handler: operateObjectHandler,
                    }, '-', {
                        text: 'Refresh',
                        iconCls: 'x-fa fa-spinner',
                        handler: refreshCont,
                    }]
                }).showAt(_oEvent.getXY());
            },
        },
    }],

    // public methods

    dispatchComponentVersionChange: function() {
        this.fireEvent('record_changed', {Type: 'component_version_changed'});
    },
});
