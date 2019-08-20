Ext.require('Schema.Common.Handlers.Menus');

Ext.define('Schema.View.SetElementsPanel', {
    extend: 'Ext.tree.Panel',
    plugins: 'gridfilters',

    store: Ext.create('Schema.Store.SetElement'),
    emptyText: 'No set version selected',
    rootVisible: false,

    header: true, title: 'Set elements',
    frame: false,

    State: 1, // expanded state

    columns:[{
        xtype: 'treecolumn',
        text: 'Name',
        dataIndex: 'Name',
        sortable: true,
        flex: 2,
    }, {
        text: 'Doc',
        dataIndex: 'Doc',
        sortable: true,
        flex: 3,
    }],

    bubbleEvents: [
        'set_element_selected',
        'schema_version_selected',
    ],

    listeners: {
        itemclick: function(_oTreeView, _oRecord, _oItemElement, _nIndex, _oEvent, _oOptions) {
            var oTree = _oTreeView.findParentByType('treepanel');
            var oData = _oRecord.data;

            var bIsSchemaVersion = (oData.Kind == 'Schema' && oData.SetElementId != undefined);

            if (bIsSchemaVersion)
                oTree.fireEvent('schema_version_selected', { SchemaVersionId: oData.Id });
            else
                oTree.fireEvent('set_element_selected', { Id: oData.Id });
        },
        rowcontextmenu: function(_oTreeView, _oRecord, _oTrElement, _nRowIndex, _oEvent, _oOptions) {
            _oEvent.preventDefault(); // no native ctx menu

            var oTree         = _oTreeView.findParentByType('treepanel');
            var sSetVersionId = _oRecord.data.SetVersionId;
            var bIsRootNode   = _oRecord.data.parentId == 'root';
            var sKindName     = _oRecord.data.KindName;

            if (bIsRootNode) {
                new Ext.menu.Menu({
                    floating: true,
                    Config: { Record: _oRecord, Cont: oTree },
                    items: [{
                        text: 'Add ' + sKindName,
                        iconCls: 'x-fa fa-plus-square',
                        Config: {
                            Type: 'SetElement',
                            SetVersionId: sSetVersionId,
                            Cmd: 'create',
                            RecordBuilder: function (_oData) {
                                return {
                                    Id: 0,
                                    SetVersionId: _oData.SetVersionId,
                                    Kind: _oData.Kind,
                                    Name: 'New ' + _oData.Name,
                                    Doc: 'Doc'
                                };
                            },
                        },
                        handler: operateObjectHandler,
                    }]
                }).showAt(_oEvent.getXY());
                return;
            }

            var bIsSetElementNode = _oRecord.data.SetVersionId != undefined;
            if (bIsSetElementNode) {
                var sSetElementId = _oRecord.data.Id;
                new Ext.menu.Menu({
                    floating: true,
                    Config: { Record: _oRecord, Cont: oTree },
                    items: [{
                        text: 'Edit ' + sKindName,
                        iconCls: 'x-fa fa-edit',
                        Config: {
                            Type: 'SetElement',
                            SetVersionId: sSetVersionId,
                            Cmd: 'update',
                            RecordBuilder: function (_oData) { return _oData; },
                        },
                        handler: operateObjectHandler,
                    }, {
                        text: 'Delete ' + sKindName,
                        iconCls: 'x-fa fa-minus-square',
                        Config: { Type: 'SetElement' },
                        handler: deleteObjectHandler
                    }, '-', {
                        text: 'Add ' + sKindName + ' version',
                        iconCls: 'x-fa fa-plus-square',
                        Config: {
                            Type: 'SetElementVersion',
                            SetElementId: sSetElementId,
                            Cmd: 'create',
                            RecordBuilder: function (_oData) {
                                return {
                                    Id: 0,
                                    SetElementId: _oData.Id,
                                    Name:   'New ' + _oData.Name + ' version',
                                    Doc:    'Doc',
                                    Config: '',
                                };
                            },
                        },
                        handler: operateObjectHandler,
                    }]
                }).showAt(_oEvent.getXY());
                return;
            }

            var sSetElementVersionId = _oRecord.data.Id;
            new Ext.menu.Menu({
                floating: true,
                Config: { Record: _oRecord, Cont: oTree },
                items: [{
                    text: 'Edit ' + sKindName + ' version',
                    iconCls: 'x-fa fa-edit',
                    Config: {
                        Type: 'SetElementVersion',
                        SetElementVersionId: sSetElementVersionId,
                        Cmd: 'update',
                        RecordBuilder: function (_oData) { return _oData; },
                    },
                    handler: operateObjectHandler,
                },{
                    text: 'Delete ' + sKindName + ' version',
                    iconCls: 'x-fa fa-minus-square',
                    Config: { Type: 'SetElementVersion' },
                    handler: deleteObjectHandler
                },{
                    text: 'Upgrade ' + sKindName + ' version',
                    iconCls: 'x-fa fa-caret-up',
                    Config: {
                        Type: 'SetElementVersion',
                        SetElementVersionId: sSetElementVersionId,
                        Cmd: 'upgrade',
                        RecordBuilder: function (_oData) { return _oData; },
                    },
                    handler: operateObjectHandler,
                }, '-', {
                    text: (oTree.State == 1) ? 'Collapse' : 'Expand',
                    iconCls: (oTree.State == 1) ? 'x-fa fa-folder' : 'x-fa fa-folder-open',
                    handler: collapseExpandTree
                }],
            }).showAt(_oEvent.getXY());
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

    // public event handlers

    loadSet: function(_nSetId) {
        this.getStore().loadSet(_nSetId);
    },
    loadSetVersion: function(_nSetVersionId) {
        this.getStore().loadSetVersion(_nSetVersionId);
    },
});
