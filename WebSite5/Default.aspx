<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>
            人员签到表</h1>
        <p>
            请选择姓名<asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource3" DataTextField="Name" DataValueField="Name">
            </asp:DropDownList>
        </p>
        <p>
            开始日期<asp:TextBox ID="TextBox3" runat="server" Height="30px" Width="180px"></asp:TextBox>
        &nbsp;&nbsp;&nbsp; 格式为XXXX/XX/XX</p>
        <p>
            结束日期<asp:TextBox ID="TextBox4" runat="server" Height="30px" Width="180px"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="Button2" runat="server" Text="查询" Height="50px" Width="150px" />
            <asp:GridView ID="GridView2" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" Height="400px" Width="940px">
                <Columns>
                    <asp:BoundField DataField="姓名" HeaderText="姓名" SortExpression="姓名" />
                    <asp:BoundField DataField="USERID" HeaderText="编号" SortExpression="USERID" >
                    <ItemStyle Width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SENSORID" HeaderText="实验室号" SortExpression="SENSORID" >
                    <ItemStyle Width="100px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CHECKINTIME" DataFormatString="{0:t}" HeaderText="签到时间" ReadOnly="True" SortExpression="CHECKINTIME" >
                    <ItemStyle Width="110px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CHECKOUTTIME" DataFormatString="{0:t}" HeaderText="签退时间" ReadOnly="True" SortExpression="CHECKOUTTIME" >
                    <ItemStyle Width="110px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="日期" HeaderText="日期" ReadOnly="True" SortExpression="日期" >
                    <ItemStyle Width="140px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="工时【小时】" HeaderText="工时【小时】" ReadOnly="True" SortExpression="工时【小时】" >
                    <ItemStyle Width="150px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="工时【分钟】" HeaderText="工时【分钟】" ReadOnly="True" SortExpression="工时【分钟】" >
                    <ItemStyle Width="150px" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ZKTimeConnectionString %>" SelectCommand="SELECT 
USERINFO.Name AS 姓名
,a.*
/*如果需要提取日期和当天工作时间*/
,CONVERT(varchar(100), DATEADD(hh,-2,a.CHECKINTIME), 111) AS 日期
,DATEDIFF(mi,a.CHECKINTIME,a.CHECKOUTTIME)/60 AS &quot;工时【小时】&quot;
,DATEDIFF(mi,a.CHECKINTIME,a.CHECKOUTTIME) AS &quot;工时【分钟】&quot;
/**/
 FROM(
SELECT CHECKINOUT.USERID,CHECKINOUT.SENSORID
,MIN(CHECKTIME) CHECKINTIME 
,MAX(CHECKTIME) CHECKOUTTIME 
FROM  CHECKINOUT
WHERE [CHECKINOUT].[CHECKTIME]&gt;=DATEADD(hh,2,@DateBegin) AND [CHECKINOUT].[CHECKTIME]&lt;=DATEADD(hh,2,@DateEnd)
GROUP BY CHECKINOUT.USERID,CHECKINOUT.SENSORID, CONVERT(date, DATEADD(hh,-2,CHECKTIME))) a
,USERINFO
WHERE a.USERID = USERINFO.USERID AND ([Name] = @Name)
order by USERINFO.Name,CONVERT(varchar(100), DATEADD(hh,-2,a.CHECKINTIME), 111)">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBox3" DefaultValue="2013/09/01" 
                        Name="DateBegin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TextBox4" DefaultValue="2015/06/30" 
                        Name="DateEnd" PropertyName="Text" />
                    <asp:ControlParameter ControlID="DropDownList1" DefaultValue="周璇"
                         Name="Name" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ZKTimeConnectionString %>" SelectCommand="SELECT * FROM [USERINFO] WHERE (([Name] NOT LIKE '%' + @Name + '%') AND ([Name] NOT LIKE '%' + @Name2 + '%') AND ([Name] NOT LIKE '%' + @Name3 + '%') AND ([Name] NOT LIKE '%' + @Name4 + '%') AND ([Name] NOT LIKE '%' + @Name5 + '%'))">
                <SelectParameters>
                    <asp:Parameter DefaultValue="陈俊延" Name="Name" Type="String" />
                    <asp:Parameter DefaultValue="李峭" Name="Name2" Type="String" />
                    <asp:Parameter DefaultValue="王老师" Name="Name3" Type="String" />
                    <asp:Parameter DefaultValue="熊老师" Name="Name4" Type="String" />
                    <asp:Parameter DefaultValue="何峰" Name="Name5" />
                </SelectParameters>
            </asp:SqlDataSource>
        </p>
        <p>
            &nbsp;</p>
        <h1>
            工时统计表</h1>
        <p>
            开始日期<asp:TextBox ID="TextBox1" runat="server" Height="30px" Width="180px"></asp:TextBox>
        &nbsp;&nbsp;&nbsp; 格式为XXXX/XX/XX</p>
        <p>
            截止日期<asp:TextBox ID="TextBox2" runat="server" Height="30px" Width="180px"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="查询" Height="50px" Width="150px" />
            <asp:GridView ID="GridView1" runat="server" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" Height="202px" Width="264px">
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ZKTimeConnectionString %>" SelectCommand="
SELECT 
USERINFO.Name AS 姓名
,USERINFO.USERID
,a.SENSORID
,a.CHECKINTIME
,a.CHECKOUTTIME
/*如果需要提取日期和当天工作时间*/
,CONVERT(varchar(100), DATEADD(hh,-2,a.CHECKINTIME), 111) AS 日期
,DATEDIFF(mi,a.CHECKINTIME,a.CHECKOUTTIME)/60 AS &quot;工时【小时】&quot;
,DATEDIFF(mi,a.CHECKINTIME,a.CHECKOUTTIME) AS &quot;工时【分钟】&quot;
/**/
 FROM USERINFO left join (
SELECT CHECKINOUT.USERID,CHECKINOUT.SENSORID
,MIN(CHECKTIME) CHECKINTIME 
,MAX(CHECKTIME) CHECKOUTTIME 
FROM  CHECKINOUT
WHERE [CHECKINOUT].[CHECKTIME]&gt;=DATEADD(hh,2,@DateBegin) AND [CHECKINOUT].[CHECKTIME]&lt;=DATEADD(hh,2,@DateEnd)
GROUP BY CHECKINOUT.USERID,CHECKINOUT.SENSORID, CONVERT(date, DATEADD(hh,-2,CHECKTIME))) a
on a.USERID = USERINFO.USERID 
where USERINFO.ATT = 1
order by USERINFO.Name,CONVERT(varchar(100), DATEADD(hh,-2,a.CHECKINTIME), 111)">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBox1" DefaultValue="2013/09/01" Name="DateBegin" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TextBox2" DefaultValue="2015/06/30" Name="DateEnd" PropertyName="Text" />
                </SelectParameters>
            </asp:SqlDataSource>
            </p>
    </div>

    </asp:Content>
