Ext.define('Ext.ux.VisView', {
    extend: 'Ext.Component',
    alias: 'widget.visview',
    config: {},
    bubbleEvents: [
        'node_selected',
        'edge_selected',
    ],
    onRender: function() {
        this.callParent(arguments);
        if (window.vis == null) {
            this.update('Error: No vis library loaded');
            return;
        }

        this.load(
            [{id: 1, label: this.ClearLabel, shape: 'box'}],
            []
        );
    },

    load: function (_aNodes, _aEdges) {
        var hData = {
            nodes: new vis.DataSet(_aNodes),
            edges: new vis.DataSet(_aEdges)
        };
        var hOptions = {
            autoResize: true,
            interaction: { hover: true, },
        };

        var oComp = this;
        var oContainer = this.el.dom;
        var oNetwork = new vis.Network(oContainer, hData, hOptions);
        setTimeout(function(){ oNetwork.fit(); }, 1000);

        oNetwork.on("click", function (params) {
            var oNode = this.getNodeAt(params.pointer.DOM);
            if (oNode != undefined) {
                oComp.fireEvent('node_selected', {node: oNode});
                return;
            }

            var oEdge = this.getEdgeAt(params.pointer.DOM);
            if (oEdge != undefined)
                oComp.fireEvent('edge_selected', {edge: oEdge});
        });
    },
});

/*
        var oNodes = new vis.DataSet([
            {id: 1, label: 'Node 1'},
            {id: 2, label: 'Node 2'},
            {id: 3, label: 'Node 3'},
            {id: 4, label: 'Node 4'},
        ]);
        var oEdges = new vis.DataSet([
            {from: 1, to: 2},
            {from: 1, to: 3},
            {from: 1, to: 4},
            {from: 2, to: 2},
        ]);

        var oContainer = this.el.dom;
        var hData = {
            nodes: oNodes,
            edges: oEdges
        };
        var hOptions = {
            autoResize: true,
            interaction: {
                hover: true,
            },
        };

        var oComp = this;
        var oNetwork = new vis.Network(oContainer, hData, hOptions);
        setTimeout(function(){ oNetwork.fit(); }, 1000);

*/
