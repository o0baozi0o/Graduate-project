using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;


public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      
        
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
      
  
        //GridView1.DataSource = null;
       

        DataView dv = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);

        if(dv.Count == 0)
        {
            Response.Write("<script>alert('无纪录!')</script>");
            return;
        }

       // BoundField bcc = new BoundField();
       // bcc.DataField = "姓名";
       // bcc.HeaderText = "姓名";
       // bcc.SortExpression = "姓名";
       // GridView1.Columns.Add(bcc);

        DataTable dt = new DataTable();
        DateTime i = new DateTime ();
        DateTime endday = new DateTime();
 

    
       
        if (TextBox1.Text=="")
        {i= DateTime.Parse("2013/09/01"); }
        else
        { i = DateTime.Parse(TextBox1.Text); }
        if (TextBox2.Text == "")
        {endday = DateTime.Parse("2015/06/30"); }
        else
        {endday = DateTime.Parse(TextBox2.Text); }

       

        dt.Columns.Add("姓名", System.Type.GetType("System.String"));

        dt.Columns.Add("总工时", System.Type.GetType("System.String"));

        for (; i < endday; i = i.AddDays(1))
        {
            string t = i.ToString("yyyy/MM/dd");
            dt.Columns.Add(t, System.Type.GetType("System.String"));


          //  BoundField bc = new BoundField();
          //  bc.DataField = t;
           // bc.HeaderText = t;
           // bc.SortExpression = t;
           // GridView1.Columns.Add(bc);

        }

        int he = 0;
   

        int y = 0; int x = 0;
        string s;
        DataRow drr = dt.NewRow();
        drr[0] = dv[0][0].ToString();
        s = dv[0][5].ToString();

        if (s != "") //如果一次都没来过会出现空行
        {
            if (dv[0][6].ToString() == "0")
            { drr[s] = "1"; he = 1; }
            else
            { drr[s] = dv[0][6].ToString(); he = (int)(dv[0][6]); }
        }



     
        dt.Rows.Add(drr);

        

        for (x = 1; x < ((dv.Count) - 1); x++)
        {
           
            if (dv[x][0].ToString() == dv[x - 1][0].ToString())
            {
                s = dv[x][5].ToString();
                if(s != "")
                { 
                if (dv[x][6].ToString() =="0")
                { dt.Rows[y][s] = "1"; he = he + 1; }
                else
                { dt.Rows[y][s] = dv[x][6].ToString();
                he = he + (int)(dv[x][6]);
                }
                }

                
            }
            else
            {
                dt.Rows[y]["总工时"] = he;
                he = 0;

                DataRow dr = dt.NewRow();
                y++;
                dr[0] = dv[x][0].ToString();
                s = dv[x][5].ToString();

                if (s != "") //如果一次都没来过会出现空行
                {
                    if (dv[x][6].ToString() == "0")
                    { dr[s] = "1"; he = he + 1; }
                    else
                    {
                        dr[s] = dv[x][6].ToString();
                        he = he + (int)(dv[x][6]);
                    }

                }
               

                dt.Rows.Add(dr);
            }

            
        }
        dt.Rows[y]["总工时"] = he;

        GridView1.DataSource = dt;
        GridView1.DataBind();
    }
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}