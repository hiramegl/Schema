// event handlers for menu items

// adding, updating or upgrading object ********************

function operateObjectHandler(_oMenuItem) {
    var oCont   = _oMenuItem.parentMenu.Config.Cont; // Container: treepanel or gridpanel
    var oRecord = _oMenuItem.parentMenu.Config.Record;
    var oData   = (oRecord != undefined) ? oRecord.data : null;

    var sCmd     = _oMenuItem.Config.Cmd;
    var fBuilder = _oMenuItem.Config.RecordBuilder;
    var sType    = 'Schema.View.' + _oMenuItem.Config.Type + 'Window';

    if (_oMenuItem.Config.WindowType != undefined)
        sType = 'Schema.View.' + _oMenuItem.Config.WindowType;

    Ext.create(sType, {
        Cmd:  sCmd,
        Config: _oMenuItem.Config,
        viewModel: {
            data: { Record: fBuilder(oData) }
        },
        listeners: {
            close: function(_oPanel, _oOptions) {
                if (this.Refresh == true)
                    oCont.getStore().load();
            },
            record_changed: function(_oEvent) {
                oCont.onRecordChanged(_oEvent);
            },
        },
    }).show();
}

// deleting object *****************************************

function deleteObjectHandler(_oMenuItem) {
    var sName = _oMenuItem.parentMenu.Config.Record.data.Name;
    var hCtxt  = {
        Type: _oMenuItem.Config.Type,
        Cont: _oMenuItem.parentMenu.Config.Cont,
        Data: _oMenuItem.parentMenu.Config.Record.data
    };

    Ext.Msg.confirm(
        'Delete "' + sName + '"',
        'Do you really want to delete "' + sName + '"?',
        function (_sRes) {
            if (_sRes != 'yes')
                return;

            var oCont = this.Cont;
            Ext.Ajax.request({
                url: '/app.api?cmd=delete',
                method: 'POST',
                params: {
                    Type: this.Type,
                    Id: this.Data.Id,
                },
                success: function(_oResponse, _oOptions) {
                    oCont.getStore().load();
                    //Ext.Msg.alert('Success', 'Successful deletion');
                    //var oRsp = Ext.JSON.decode(_oResponse.responseText);
                }
            });
        },
        hCtxt);
}

// collapse / expand tree **********************************

function collapseExpandTree(_oMenuItem) {
    var oTree = _oMenuItem.parentMenu.Config.Cont;
    if (oTree.State == 0) {
        oTree.expandAll();
        oTree.State = 1; // expanded state
    } else {
        oTree.collapseAll();
        oTree.State = 0; // collapsed state
    }
}

// refresh container ***************************************

function refreshCont(_oMenuItem) {
    var oCont = _oMenuItem.parentMenu.Config.Cont;
    oCont.getStore().load();
}
