Ext.require('Schema.Common.Handlers.Menus');

Ext.define('Schema.View.SetsPanel', {
    extend: 'Ext.tree.Panel',
    plugins: 'gridfilters',

    store: Ext.create('Schema.Store.Set'),
    emptyText: 'No sets added yet',
    header: false,

    rootVisible: false,
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
        'set_selected',
        'set_version_selected',
    ],

    listeners: {
        itemclick: function(_oTreeView, _oRecord, _oItemElement, _nIndex, _oEvent, _oOptions) {
            var oTree      = _oTreeView.findParentByType('treepanel');
            var bIsSetNode = (_oRecord.isLeaf() == false);
            var nId        = _oRecord.data.Id;

            if (bIsSetNode)
                oTree.fireEvent('set_selected', { SetId: nId });
            else
                oTree.fireEvent('set_version_selected', { SetVersionId: nId });
        },
        rowcontextmenu: function(_oTreeView, _oRecord, _oTrElement, _nRowIndex, _oEvent, _oOptions) {
            _oEvent.preventDefault(); // no native ctx menu

            var oTree      = _oTreeView.findParentByType('treepanel');
            var bIsSetNode = _oRecord.data.parentId == 'root';

            if (bIsSetNode) {
                // Set commands *******************************************

                new Ext.menu.Menu({
                    floating: true,
                    Config: { Record: _oRecord, Cont: oTree },
                    items: [{
                        text: 'Edit set',
                        iconCls: 'x-fa fa-edit',
                        Config: {
                            Type: 'Set', Cmd: 'update',
                            RecordBuilder: function (_oData) { return _oData; },
                        },
                        handler: operateObjectHandler,
                    }, {
                        text: 'Delete set',
                        iconCls: 'x-fa fa-minus-square',
                        Config: { Type: 'Set' },
                        handler: deleteObjectHandler,
                    }, '-', {
                        text: 'Add set version',
                        iconCls: 'x-fa fa-plus-square',
                        Config: {
                            Type: 'SetVersion', Cmd: 'create',
                            RecordBuilder: function (_oData) {
                                return { Id: 0, SetId: _oData.Id, Name: 'New set version', Doc: 'Doc' };
                            },
                        },
                        handler: operateObjectHandler,
                    }]
                }).showAt(_oEvent.getXY());

            } else {
                // Set Version commands ***********************************

                new Ext.menu.Menu({
                    floating: true,
                    Config: { Record: _oRecord, Cont: oTree },
                    items: [{
                        text: 'Edit set version',
                        iconCls: 'x-fa fa-edit',
                        Config: {
                            Type: 'SetVersion', Cmd: 'update',
                            RecordBuilder: function (_oData) { return _oData; },
                        },
                        handler: operateObjectHandler
                    }, {
                        text: 'Delete set version',
                        iconCls: 'x-fa fa-minus-square',
                        Config: { Type: 'SetVersion' },
                        handler: deleteObjectHandler,
                    }, {
                        text: 'Upgrade set version',
                        iconCls: 'x-fa fa-caret-up',
                        Config: {
                            Type: 'SetVersion', Cmd: 'upgrade',
                            RecordBuilder: function (_oData) { return _oData; },
                        },
                        handler: operateObjectHandler
                    }, '-', {
                        text: (oTree.State == 1) ? 'Collapse' : 'Expand',
                        iconCls: (oTree.State == 1) ? 'x-fa fa-folder' : 'x-fa fa-folder-open',
                        handler: collapseExpandTree
                    }],
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
                    text: 'Add set',
                    iconCls: 'x-fa fa-plus-square',
                    Config: {
                        Type: 'Set', Cmd: 'create',
                        RecordBuilder: function (_oData) {
                            return { Id: 0, Name: 'New set', Doc: 'Doc' };
                        }
                    },
                    handler: operateObjectHandler,
                }, '-', {
                    text: (oTree.State == 1) ? 'Collapse' : 'Expand',
                    iconCls: (oTree.State == 1) ? 'x-fa fa-folder' : 'x-fa fa-folder-open',
                    handler: collapseExpandTree
                }, {
                    text: 'Refresh',
                    iconCls: 'x-fa fa-spinner',
                    handler: refreshCont
                }]
            }).showAt(_oEvent.getXY());
        },
    },
});

