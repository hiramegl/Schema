// event handlers for windows buttons

function saveButtonClickHandler(_oButton) {
    var oForm = this.up('form').getForm();
    if (oForm.isValid() == false) return;

    sCmd = this.up('window').Cmd;

    oForm.submit({
        url: '/app.api?cmd=' + sCmd,
        success: function(_oForm, _oAction) {
            var oRes = _oAction.result;
            _oForm.owner.up('window').Refresh = true;
            _oForm.owner.up('window').close();
        },
        failure: function(_oForm, _oAction) {
            Ext.Msg.alert('Error', _oAction.result.msg);
            _oForm.owner.up('window').Refresh = false;
        }
    });
}

function cancelButtonClickHandler(_oButton) {
    this.up('window').Refresh = false;
    this.up('window').close();
}

// combobox handlers

function comboboxAfterrenderHandler(_oComboBox) {
    var hConfig = _oComboBox.findParentByType('window').Config;
    var oStore  = _oComboBox.getStore();
    var sKind   = _oComboBox.Config.Kind;

    oStore.getProxy().setExtraParams({
        Type: 'SchemaElement',
        Query: 'SchemaElementsBySchemaVersionId',
        Where: 'Kind,SchemaVersionId',
        Kind: _oComboBox.Config.Kind,
        SchemaVersionId: hConfig.SchemaVersionId,
    });
    oStore.load();
}

// validations

Ext.define('Override.form.field.VTypes', {
    override: 'Ext.form.field.VTypes',

    // vtype validation function
    version: function(_sValue) {
        return this.reVersion.test(_sValue);
    },

    // RegExp for the value to be tested against within the validation function
    reVersion: /^\w+\/\w+$|^-$/i,

    // vtype Text property: The error text to display when the validation function returns false
    timeText: 'Not a valid version. Format: element_name/version_name".',

    // vtype Mask property: The keystroke filter mask
    timeMask: /[\w\/]/i,
});
