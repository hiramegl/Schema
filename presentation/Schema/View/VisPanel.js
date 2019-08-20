Ext.define('Schema.View.VisPanel', {
    extend: 'Ext.panel.Panel',
    title: 'Dependencies',
    ClearLabel: 'No Set or Schema version selected',
    items: [
        Ext.create('Ext.ux.VisView', {
            id: 'viewVis',
            ClearLabel: 'No Set or Schema version selected',
        })
    ],
    listeners: {
        node_selected: function(_oEvent) {
            alert('> Node: ' + _oEvent.node);
        },
        edge_selected: function(_oEvent) {
            alert('> Edge: ' + _oEvent.edge);
        },
    },
    clear: function () {
        Ext.getCmp('viewVis').load(
            [{id: 1, label: this.ClearLabel}],
            []
        );
    },
    loadSetVersion: function (_nSetVersionId) {
        Ext.Ajax.request({
            url: '/app.api?cmd=list',
            method: 'POST',
            params: {
                Type: 'SetElement',
                Where: 'Kind,SetVersionId',
                Kind: 'Schema',
                SetVersionId: _nSetVersionId,
            },
            success: function(_oResponse, _oOptions) {
                var oResp = Ext.JSON.decode(_oResponse.responseText);
                if (oResp.success) {
                    aNodes = [];
                    oResp.data.forEach(function (_hItem, _nIndex) {
                        aNodes.push({
                            id: _hItem.Id,
                            label: _hItem.Name,
                        })
                    });
                    aEdges = [];
                    Ext.getCmp('viewVis').load(aNodes, aEdges);
                }
            }
        });
    },
    loadSchemaVersion: function (_nSchemaVersionId) {
    },
});
