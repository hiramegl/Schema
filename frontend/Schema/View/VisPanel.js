var sClearLabel = 'No Set/Schema version selected';

Ext.define('Schema.View.VisPanel', {
    extend: 'Ext.panel.Panel',
    title: 'Map',
    ClearLabel: sClearLabel,
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    items: [
        Ext.create('Ext.ux.VisView', {
            id: 'viewVis',
            ClearLabel: sClearLabel,
            flex: 1,
        }),
    ],
    listeners: {
        node_selected: function(_oEvent) {
            console.log('> Node: ' + _oEvent.node);
        },
        edge_selected: function(_oEvent) {
            console.log('> Edge: ' + _oEvent.edge);
        },
    },
    clear: function () {
        Ext.getCmp('viewVis').load(
            [{id: 1, label: this.ClearLabel, shape: 'box'}],
            []
        );
    },
    loadSetVersion: function (_nSetVersionId) {
        Ext.Ajax.request({
            url: '/app.api?cmd=query',
            method: 'POST',
            params: {
                Type: 'SetVersion',
                Query: 'NetVis',
                SetVersionId: _nSetVersionId,
            },
            success: function(_oResponse, _oOptions) {
                var oResp = Ext.JSON.decode(_oResponse.responseText);
                if (oResp.success) {
                    Ext.getCmp('viewVis').load(
                        oResp.data.nodes,
                        oResp.data.edges);
                }
            }
        });
    },
    loadSchemaVersion: function (_nSchemaVersionId) {
    },
});

/*
var sSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="80">' +
    '<rect x="0" y="0" width="100%" height="100%" fill="#7890A7" stroke-width="10" stroke="#555555" ></rect>' +
    '<foreignObject x="15" y="10" width="100%" height="100%">' +
    '<div xmlns="http://www.w3.org/1999/xhtml" style="font-size:40px">' +
    '<span style="color:white; text-shadow:0 0 20px #000000; align:center;">' + _hItem.Name + '</span>' +
    '</div>' +
    '</foreignObject>' +
    '</svg>';
var sUrl = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(sSvg);
*/
