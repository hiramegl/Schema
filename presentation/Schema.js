Ext.Loader.setConfig ({
    enabled: true ,
    paths: {
        'Ext.ux.WebSocket'       : 'lib/ext.ux.websocket/WebSocket.js' ,
        'Ext.ux.WebSocketManager': 'lib/ext.ux.websocket/WebSocketManager.js',
        'Ext.ux.VisView'         : 'lib/ext.ux.vis/VisView.js',
    }
});

Ext.application({
    name: 'Schema for Aspicere',
    launch: function() {
        Ext.create('Ext.container.Viewport', {
            layout: 'border',
            items: [{
                xtype: 'panel',
                region: 'west',
                split: true,
                title: 'Sets',
                minWidth: 400,
                width: 400,
                collapsible: true,
                layout: {
                    type: 'vbox',
                    pack: 'start',
                    align: 'stretch',
                },
                items: [
                    Ext.create('Schema.View.SetsPanel', {
                        flex: 1,
                    }),
                    Ext.create('Schema.View.SetElementsPanel', {
                        id: 'pnlSetElements',
                        flex: 3,
                    }),
                ],
            }, Ext.create('Schema.View.VisPanel', {
                id: 'pnlVis',
                region: 'center',
                split: true,
            }), Ext.create('Schema.View.SchemaElementsPanel', {
                id: 'pnlSchemaElements',
                region: 'east',
                split: true,
                minWidth: 400,
                width: 400,
            })],

            listeners: {
                set_selected: function(_oEvent) {
                    Ext.getCmp('pnlSetElements').loadSet(_oEvent.SetId);
                    Ext.getCmp('pnlSchemaElements').clear();
                    Ext.getCmp('pnlVis').clear();
                },
                set_version_selected: function(_oEvent) {
                    Ext.getCmp('pnlSetElements').loadSetVersion(_oEvent.SetVersionId);
                    Ext.getCmp('pnlSchemaElements').clear();
                    Ext.getCmp('pnlVis').loadSetVersion(_oEvent.SetVersionId);
                },
                set_element_selected: function(_oEvent) {
                    Ext.getCmp('pnlSchemaElements').clear();
                    Ext.getCmp('pnlVis').clear();
                },
                schema_version_selected: function(_oEvent) {
                    Ext.getCmp('pnlSchemaElements').loadSchemaVersion(_oEvent.SchemaVersionId);
                    Ext.getCmp('pnlVis').loadSchemaVersion(_oEvent.SchemaVersionId);
                },
            },
        });
    }
});

