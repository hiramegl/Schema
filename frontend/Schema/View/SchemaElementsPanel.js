Ext.require('Schema.Common.Handlers.Menus');

Ext.define('Schema.View.SchemaElementsPanel', {
    extend: 'Ext.tree.Panel',
    plugins: 'gridfilters',

    store: Ext.create('Schema.Store.SchemaElement'),
    emptyText: 'No schema version selected',
    title: 'Schema elements',
    header: true,

    rootVisible: false,
    frame: false,

    State: 1, // expanded state

    columns:[{
        xtype: 'treecolumn',
        text: 'Name',
        dataIndex: 'Name',
        sortable: true,
        flex: 2
    }, {
        text: 'Version',
        dataIndex: 'Version',
        sortable: true,
        flex: 3
    }],

    bubbleEvents: [
        'schema_element_selected',
        'schema_element_version_selected',
    ],

    listeners: {
        itemclick: function(_oTreeView, _oRecord, _oItemElement, _nIndex, _oEvent, _oOptions) {
            var oTree = _oTreeView.findParentByType('treepanel');
            var oData = _oRecord.data;
        },
        rowcontextmenu: function(_oTreeView, _oRecord, _oTrElement, _nRowIndex, _oEvent, _oOptions) {
            _oEvent.preventDefault(); // no native ctx menu

            var oTree            = _oTreeView.findParentByType('treepanel');
            var oData            = _oRecord.data;
            var sSchemaVersionId = oData.SchemaVersionId;
            var bIsRootNode      = oData.parentId == 'root';
            var sKind            = oData.Kind;
            var sKindName        = oData.KindName;
            var sName            = oData.Name;
            var nSetVersionId    = oData.SetVersionId;
            var nCompVersionId   = undefined;
            var sType            = (sKind == 'Comp') ? 'Component' : 'SchemaElement';

            if (bIsRootNode) {
                new Ext.menu.Menu({
                    floating: true,
                    Config: { Record: _oRecord, Cont: oTree },
                    items: [{
                        text: 'Add ' + sKindName,
                        iconCls: 'x-fa fa-plus-square',
                        Config: {
                            Type: sType,
                            Cmd: 'create',
                            Kind: sKind,
                            SetVersionId: nSetVersionId,
                            RecordBuilder: function (_oData) {
                                return (sKind == 'Comp') ? {
                                    Id: 0,
                                    SchemaVersionId: _oData.SchemaVersionId,
                                    Class: 'New class',
                                    Name: 'New class name',
                                    Doc: 'Doc',
                                } : {
                                    Id: 0,
                                    SchemaVersionId: _oData.SchemaVersionId,
                                    Kind: _oData.Kind,
                                    SetElementId: 0,
                                    SetElementVersionId: 0,
                                };
                            },
                        },
                        handler: operateObjectHandler,
                    }],
                }).showAt(_oEvent.getXY());
            } else {
                var bIsCompVersion = (oData.CompId != undefined);

                if (bIsCompVersion) {
                    // is a component version row!
                    sKindName      = 'Component Version';
                    sType          = 'ComponentVersion';
                    nCompVersionId = oData.Id;
                }
                // else // is a component row!

                var aItems = [{
                    text: 'Edit ' + sKindName + ' ' + sName,
                    iconCls: 'x-fa fa-edit',
                    Config: {
                        Type: sType,
                        Cmd: 'update',
                        Kind: sKind,
                        SetVersionId: nSetVersionId,
                        SchemaVersionId: sSchemaVersionId,
                        CompVersionId: nCompVersionId,
                        RecordBuilder: function (_oData) { return _oData; },
                    },
                    handler: operateObjectHandler,
                }, {
                    text: 'Delete ' + sKindName + ' ' + sName,
                    iconCls: 'x-fa fa-minus-square',
                    Config: { Type: sType },
                    handler: deleteObjectHandler
                }];

                if (!bIsCompVersion && sKind == 'Comp') {
                    aItems.push('-');
                    aItems.push({
                        text: 'Add Component version',
                        iconCls: 'x-fa fa-plus-square',
                        Config: {
                            Type: 'ComponentVersion',
                            Cmd: 'create',
                            SchemaVersionId: sSchemaVersionId,
                            RecordBuilder: function (_oData) {
                                return {
                                    Id: 0,
                                    CompId: _oData.Id,
                                    Name: 'New Component version',
                                    Doc: 'Doc',
                                    Auth: '',
                                };
                            },
                        },
                        handler: operateObjectHandler,
                    });
                }

                aItems.push('-');
                aItems.push({
                    text: (oTree.State == 1) ? 'Collapse' : 'Expand',
                    iconCls: (oTree.State == 1) ? 'x-fa fa-folder' : 'x-fa fa-folder-open',
                    handler: collapseExpandTree
                });

                new Ext.menu.Menu({
                    floating: true,
                    Config: { Record: _oRecord, Cont: oTree },
                    items: aItems,
                }).showAt(_oEvent.getXY());
            }
        },
        containercontextmenu: function(_oView, _oEvent, _oOptions) {
            _oEvent.preventDefault(); // no native ctx menu
            var oTree = _oView.up();

            new Ext.menu.Menu({
                floating: true,
                Config: { Cont: oTree },
                items: [{
                    text: (oTree.State == 1) ?
                        'Collapse' : 'Expand',
                    iconCls: (oTree.State == 1) ?
                        'x-fa fa-folder' : 'x-fa fa-folder-open',
                    handler: collapseExpandTree
                }, {
                    text: 'Refresh',
                    iconCls: 'x-fa fa-spinner',
                    handler: refreshCont
                }]
            }).showAt(_oEvent.getXY());
        },
    },

    // public methods

    clear: function() {
        this.getStore().clear();
    },
    loadSchemaVersion: function(_nSchemaVersionId) {
        this.getStore().loadSchemaVersion(_nSchemaVersionId);
    },
    onRecordChanged: function(_oEvent) {
        if (_oEvent.Type == 'component_version_changed')
            this.getStore().load();
    },
});
