<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDashboard.aspx.vb" Inherits="AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f0f0f0;">
    <form id="form1" runat="server">
        <div style="background-color: #336699; padding: 10px; color: white;">
            <h1>QuickByte Admin Dashboard</h1>
            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Default.aspx" ForeColor="White">Home</asp:HyperLink>
            &nbsp;|&nbsp;
            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Orders.aspx" ForeColor="White">All Orders</asp:HyperLink>
            &nbsp;|&nbsp;
            <asp:LinkButton ID="lnkLogout" runat="server" ForeColor="White" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
            <br />
            <strong>Welcome Admin: </strong><%= User.Identity.Name %>
        </div>
        <br />

        <div style="padding: 20px;">
            <h2 style="color: #336699;">Business Segmentation Dashboard</h2>
            <hr />
            
            <h3>Register New Restaurant Partner</h3>
            <table style="width: 50%; border: 1px solid black; background-color: white; padding: 10px;">
                <tr>
                    <td>Restaurant Name:</td>
                    <td><asp:TextBox ID="txtNewRestName" runat="server" Width="200px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Manager Email:</td>
                    <td><asp:TextBox ID="txtNewRestEmail" runat="server" Width="200px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><asp:TextBox ID="txtNewRestPhone" runat="server" Width="200px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>City:</td>
                    <td>
                        <asp:DropDownList ID="ddlNewRestRegion" runat="server" Width="205px">
                            <asp:ListItem Value="" Text="-- Select City --"></asp:ListItem>
                            <asp:ListItem Value="Karachi" Text="Karachi"></asp:ListItem>
                            <asp:ListItem Value="Lahore" Text="Lahore"></asp:ListItem>
                            <asp:ListItem Value="Islamabad" Text="Islamabad"></asp:ListItem>
                            <asp:ListItem Value="Rawalpindi" Text="Rawalpindi"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>Street Address:</td>
                    <td><asp:TextBox ID="txtNewRestAddress" runat="server" Width="200px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:Button ID="btnAddRestaurant" runat="server" Text="Register Restaurant" OnClick="btnAddRestaurant_Click" BackColor="#336699" ForeColor="White" />
                    </td>
                </tr>
            </table>
            <asp:Label ID="lblAdminMessage" runat="server" ForeColor="Green" Visible="false" Font-Bold="True"></asp:Label>
            <br /><br />

            <h3 style="color: #336699;">Customer Segmentation</h3>
            <asp:GridView ID="gvCustomerSegments" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Width="80%">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                    <asp:BoundField DataField="Region" HeaderText="City" />
                    <asp:BoundField DataField="TotalOrders" HeaderText="Orders" />
                    <asp:BoundField DataField="TotalSpent" HeaderText="Total Spent" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="Segment" HeaderText="Segment" />
                </Columns>
                <EmptyDataTemplate>
                    <span style="color: red;">No customer data available.</span>
                </EmptyDataTemplate>
                <HeaderStyle BackColor="#336699" Font-Bold="True" ForeColor="White" />
                <RowStyle BackColor="#EFF3FB" />
            </asp:GridView>
            <br />

            <h3 style="color: #336699;">Restaurant Revenue & Account Status</h3>
            <asp:GridView ID="gvRestaurants" runat="server" AutoGenerateColumns="False" DataKeyNames="RestaurantID" OnRowCommand="gvRestaurants_RowCommand" CellPadding="4" ForeColor="#333333" GridLines="None" Width="90%">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Restaurant" />
                    <asp:BoundField DataField="Region" HeaderText="City" />
                    <asp:BoundField DataField="OrderCount" HeaderText="Orders" />
                    <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="AvgRating" HeaderText="Rating" DataFormatString="{0:F1}" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Disabled") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnToggleRest" runat="server" Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>' CommandName="ToggleStatus" CommandArgument='<%# Eval("RestaurantID") %>' BackColor="LightGray" />
                            <asp:Button ID="btnResetRest" runat="server" Text="Reset Revenue" CommandName="ResetRevenue" CommandArgument='<%# Eval("RestaurantID") %>' OnClientClick="return confirm('Reset revenue for this restaurant?');" BackColor="LightCoral" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <span style="color: red;">No restaurant data available.</span>
                </EmptyDataTemplate>
                <HeaderStyle BackColor="#336699" Font-Bold="True" ForeColor="White" />
                <RowStyle BackColor="#EFF3FB" />
            </asp:GridView>
            <br />

            <h3 style="color: #336699;">Rider Earnings & Dispatch Status</h3>
            <asp:GridView ID="gvRiders" runat="server" AutoGenerateColumns="False" DataKeyNames="RiderID" OnRowCommand="gvRiders_RowCommand" CellPadding="4" ForeColor="#333333" GridLines="None" Width="90%">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Rider" />
                    <asp:BoundField DataField="Region" HeaderText="City" />
                    <asp:BoundField DataField="Deliveries" HeaderText="Deliveries" />
                    <asp:BoundField DataField="Revenue" HeaderText="Earnings" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="AvgRating" HeaderText="Rating" DataFormatString="{0:F1}" />
                    <asp:TemplateField HeaderText="Available">
                        <ItemTemplate>
                            <%# If(Convert.ToBoolean(Eval("Availability")), "Yes", "No") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Account">
                        <ItemTemplate>
                            <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Disabled") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnToggleRider" runat="server" Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>' CommandName="ToggleStatus" CommandArgument='<%# Eval("RiderID") %>' BackColor="LightGray" />
                            <asp:Button ID="btnResetRider" runat="server" Text="Reset" CommandName="ResetRevenue" CommandArgument='<%# Eval("RiderID") %>' OnClientClick="return confirm('Reset earnings for this rider?');" BackColor="LightCoral" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <span style="color: red;">No rider data available.</span>
                </EmptyDataTemplate>
                <HeaderStyle BackColor="#336699" Font-Bold="True" ForeColor="White" />
                <RowStyle BackColor="#EFF3FB" />
            </asp:GridView>
            <br />

            <h3 style="color: #336699;">Stakeholder Ratings & Reviews</h3>
            <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Width="80%">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:BoundField DataField="TargetName" HeaderText="Rated" />
                    <asp:BoundField DataField="TargetType" HeaderText="Role" />
                    <asp:BoundField DataField="Rating" HeaderText="Rating" />
                    <asp:BoundField DataField="Comment" HeaderText="Comment" />
                    <asp:BoundField DataField="Reviewer" HeaderText="Reviewer" />
                    <asp:BoundField DataField="Region" HeaderText="City" />
                </Columns>
                <EmptyDataTemplate>
                    <span style="color: red;">No reviews submitted yet.</span>
                </EmptyDataTemplate>
                <HeaderStyle BackColor="#336699" Font-Bold="True" ForeColor="White" />
                <RowStyle BackColor="#EFF3FB" />
            </asp:GridView>
        </div>
        <hr />
        <div style="text-align: center; color: gray;">
            &copy; 2026 QUICK byte - Taste the speed<br />
            Internet application development<br />
            Mansoob-e-Zahra
        </div>
    </form>
</body>
</html>
