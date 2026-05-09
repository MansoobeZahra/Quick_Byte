<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDashboard.aspx.vb" Inherits="AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - QUICK byte</title>
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <a href="Default.aspx">QuickByte Admin</a> |
            <a href="Orders.aspx">All Orders</a> |
            <a href="AdminDashboard.aspx">Dashboard</a> |
            <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
        </nav>

        <div class="container">
            <h1>Business Segmentation Dashboard</h1>
            <p>Real-time analytics and stakeholder management</p>

            <!-- Customers Segmentation -->
            <div class="stat-card">
                <h2>Customer Segmentation</h2>
                <asp:GridView ID="gvCustomerSegments" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="TotalOrders" HeaderText="Orders" />
                        <asp:BoundField DataField="TotalSpent" HeaderText="Spent" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="AvgItemsPerOrder" HeaderText="Avg Items" DataFormatString="{0:F1}" />
                        <asp:TemplateField HeaderText="Segment">
                            <ItemTemplate>
                                <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Restaurants Performance -->
            <div class="stat-card">
                <h2>Restaurant Performance</h2>
                <asp:GridView ID="gvRestaurants" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Restaurant" />
                        <asp:BoundField DataField="OrderCount" HeaderText="Orders" />
                        <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Segment">
                            <ItemTemplate>
                                <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Riders Activity -->
            <div class="stat-card">
                <h2>Rider Activity</h2>
                <asp:GridView ID="gvRiders" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Rider" />
                        <asp:BoundField DataField="Deliveries" HeaderText="Deliveries" />
                        <asp:TemplateField HeaderText="Availability">
                            <ItemTemplate>
                                <%# If(Convert.ToBoolean(Eval("Availability")), "Available", "Offline") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Segment">
                            <ItemTemplate>
                                <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Platform Managers -->
            <div class="stat-card">
                <h2>Platform Managers</h2>
                <asp:GridView ID="gvPlatformManagers" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="FullName" HeaderText="Name" />
                        <asp:BoundField DataField="Department" HeaderText="Department" />
                        <asp:BoundField DataField="Segment" HeaderText="Access" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 QUICK byte Admin</p>
        </footer>
    </form>
</body>
</html>
