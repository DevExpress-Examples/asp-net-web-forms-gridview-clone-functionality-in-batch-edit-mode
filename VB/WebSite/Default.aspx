<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ASPxGridView - How to implement copy functionality in Batch Edit mode</title>
    <script type="text/javascript">
        var index;
        var copyFlag;
        function OnCustomButtonClick(s, e) {
            if (e.buttonID == "CopyButton") {
                index = e.visibleIndex;
                copyFlag = true;
                s.AddNewRow();
            }
        }
        function OnStartEdit(s, e) {
            if (copyFlag) {
                copyFlag = false;
                for (var i = 0; i < s.GetColumnsCount() ; i++) {
                    var column = s.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(rbl.GetSelectedIndex(), e, column, s);
                }
            }
        }
        function ProcessCells(selectedIndex, e, column, s) {
            var isCellEditMode = selectedIndex == 0;
            var cellValue = s.batchEditApi.GetCellValue(index, column.fieldName);

            if(isCellEditMode) {
                if(column.fieldName == e.focusedColumn.fieldName)
                    e.rowValues[column.index].value = cellValue;
                else
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, cellValue);
            } else {
                e.rowValues[column.index].value = cellValue;
            }
        }
    </script>
</head>
<body>
    <form id="frmMain" runat="server">

        <dx:ASPxCheckBox ID="BatchUpdateCheckBox" runat="server" Checked="true" Text="Handle BatchUpdate event"
            AutoPostBack="true" />
        <dx:ASPxRadioButtonList runat="server" ID="rbl" AutoPostBack="true" OnSelectedIndexChanged="rbl_SelectedIndexChanged" ClientInstanceName="rbl">
            <Items>
                <dx:ListEditItem Text="Cell" Value="Cell" Selected="true" />
                <dx:ListEditItem Text="Row" Value="Row" />
            </Items>
        </dx:ASPxRadioButtonList>
        <dx:ASPxGridView ID="Grid" runat="server" ClientInstanceName="grid" KeyFieldName="ID" OnBatchUpdate="Grid_BatchUpdate"
            OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting">
            <SettingsEditing>
            </SettingsEditing>
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="true">
                    <CustomButtons>
                        <dx:GridViewCommandColumnCustomButton ID="CopyButton" Text="Copy"></dx:GridViewCommandColumnCustomButton>
                    </CustomButtons>
                </dx:GridViewCommandColumn>
                <dx:GridViewDataTextColumn FieldName="C1">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataSpinEditColumn FieldName="C2">
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataColumn FieldName="C3">
                </dx:GridViewDataColumn>
                <dx:GridViewDataCheckColumn FieldName="C4">
                </dx:GridViewDataCheckColumn>
                <dx:GridViewDataDateColumn FieldName="C5">
                </dx:GridViewDataDateColumn>
            </Columns>
            <SettingsEditing Mode="Batch" />
            <ClientSideEvents BatchEditStartEditing="OnStartEdit" CustomButtonClick="OnCustomButtonClick" />
        </dx:ASPxGridView>
    </form>
</body>
</html>