using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using DevExpress.Web.Data;
using DevExpress.Web;

public partial class _Default : System.Web.UI.Page {
    protected List<GridDataItem> GridData {
        get {
            var key = "34FAA431-CF79-4869-9488-93F6AAE81263";
            if(!IsPostBack || Session[key] == null)
                Session[key] = Enumerable.Range(0, 8).Select(i => new GridDataItem {
                    ID = i,
                    C1 = i % 2,
                    C2 = i * 0.5 % 3,
                    C3 = "C3 " + i,
                    C4 = i % 2 == 0,
                    C5 = new DateTime(2013 + i, 12, 16)
                }).ToList();
            return (List<GridDataItem>)Session[key];
        }
    }
    protected void Page_Load(object sender, EventArgs e) {
        Grid.DataSource = GridData;
        Grid.DataBind();
        
    }
    protected void Grid_RowInserting(object sender, ASPxDataInsertingEventArgs e) {
        InsertNewItem(e.NewValues);
        CancelEditing(e);
    }
    protected void Grid_RowUpdating(object sender, ASPxDataUpdatingEventArgs e) {
        UpdateItem(e.Keys, e.NewValues);
        CancelEditing(e);
    }
    protected void Grid_RowDeleting(object sender, ASPxDataDeletingEventArgs e) {
        DeleteItem(e.Keys, e.Values);
        CancelEditing(e);
    }

    protected void Grid_BatchUpdate(object sender, ASPxDataBatchUpdateEventArgs e) {
        if(!BatchUpdateCheckBox.Checked)
            return;
        
       
        foreach(var args in e.InsertValues){
            InsertNewItem(args.NewValues);
      
        }        
        foreach(var args in e.UpdateValues)
            UpdateItem(args.Keys, args.NewValues);
        foreach(var args in e.DeleteValues)
            DeleteItem(args.Keys, args.Values);

        e.Handled = true;
    }
    protected GridDataItem InsertNewItem(OrderedDictionary newValues) {
        var item = new GridDataItem() { ID = GridData.Count };
        LoadNewValues(item, newValues);
        GridData.Add(item);
        return item;
    }
    protected GridDataItem UpdateItem(OrderedDictionary keys, OrderedDictionary newValues) {
        var id = Convert.ToInt32(keys["ID"]);
        var item = GridData.First(i => i.ID == id);
        LoadNewValues(item, newValues);
        return item;
    }
    protected GridDataItem DeleteItem(OrderedDictionary keys, OrderedDictionary values) {
        var id = Convert.ToInt32(keys["ID"]);
        var item = GridData.First(i => i.ID == id);
        GridData.Remove(item);
        return item;
    }
    protected void LoadNewValues(GridDataItem item, OrderedDictionary values) {
        item.C1 = Convert.ToInt32(values["C1"]);
        item.C2 = Convert.ToDouble(values["C2"]);
        item.C3 = Convert.ToString(values["C3"]);
        item.C4 = Convert.ToBoolean(values["C4"]);
        item.C5 = Convert.ToDateTime(values["C5"]);
    }
    protected void CancelEditing(CancelEventArgs e) {
        e.Cancel = true;
        Grid.CancelEdit();
    }
    public class GridDataItem {
        public int ID { get; set; }
        public int C1 { get; set; }
        public double C2 { get; set; }
        public string C3 { get; set; }
        public bool C4 { get; set; }
        public DateTime C5 { get; set; }
    }


    protected void rbl_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbl.SelectedIndex == 0)
            Grid.SettingsEditing.BatchEditSettings.EditMode = GridViewBatchEditMode.Cell;
        else
            Grid.SettingsEditing.BatchEditSettings.EditMode = GridViewBatchEditMode.Row;
    }
}