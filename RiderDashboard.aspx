<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RiderDashboard.aspx.vb" Inherits="RiderDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rider Dashboard - QUICK byte</title>
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <div class="nav-container">
                <a href="Default.aspx" class="nav-logo">
                    <img src="assets/logo.png" alt="QuickByte Logo" />
                    QuickByte
                </a>
                <ul class="nav-menu">
                    <li><a href="Default.aspx">Home</a></li>
                    <li><a href="RiderDashboard.aspx">Dashboard</a></li>
                    <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                    <li class="user-welcome"><%= User.Identity.Name %></li>
                </ul>
            </div>
        </nav>

        <div class="container">
            <div class="page-header">
                <h1>Rider Dashboard</h1>
                <p>Manage your deliveries and availability status</p>
            </div>

            <!-- Profile Panel -->
            <div class="panel">
                <h2>Profile &amp; Status</h2>
                <div class="info-row">
                    <span class="label">Region:</span>
                    <asp:Label ID="lblRegion" runat="server" Font-Bold="true"></asp:Label>
                </div>
                <div class="info-row">
                    <span class="label">Availability:</span>
                    <label class="checkbox-label">
                        <asp:CheckBox ID="chkAvailability" runat="server" AutoPostBack="true"
                            OnCheckedChanged="chkAvailability_CheckedChanged" />
                        <asp:Label ID="lblStatusText" runat="server"></asp:Label>
                    </label>
                </div>
            </div>

            <!-- Available Orders -->
            <div class="panel">
                <h2>Available Orders in <asp:Label ID="lblRegionTitle" runat="server"></asp:Label></h2>
                <asp:GridView ID="gvAvailableOrders" runat="server" AutoGenerateColumns="False"
                    CssClass="orders-table" GridLines="None" DataKeyNames="OrderID"
                    OnRowCommand="gvAvailableOrders_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                        <asp:BoundField DataField="RestaurantName" HeaderText="Restaurant" />
                        <asp:BoundField DataField="Items" HeaderText="Items" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnPickOrder" runat="server" Text="Pick Up"
                                    CommandName="PickOrder" CommandArgument='<%# Eval("OrderID") %>'
                                    CssClass="btn-view" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No orders available in your region right now.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Active Deliveries -->
            <div class="panel">
                <h2>Active Deliveries</h2>
                <asp:GridView ID="gvAssignedOrders" runat="server" AutoGenerateColumns="False"
                    CssClass="orders-table" GridLines="None" DataKeyNames="OrderID">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                        <asp:BoundField DataField="CustomerInfo" HeaderText="Customer" HtmlEncode="false" />
                        <asp:BoundField DataField="RestaurantInfo" HeaderText="Restaurant" HtmlEncode="false" />
                        <asp:TemplateField HeaderText="Update Status">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlStatus" runat="server" style="padding:5px; border:1px solid #ccc;">
                                    <asp:ListItem Value="Assigned">Assigned</asp:ListItem>
                                    <asp:ListItem Value="Picked Up">Picked Up</asp:ListItem>
                                    <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnUpdate" runat="server" Text="Update"
                                    CssClass="btn-view" OnClick="btnUpdate_Click" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No active deliveries assigned.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Delivery History -->
            <div class="panel">
                <h2>Completed Deliveries</h2>
                <asp:GridView ID="gvDeliveryHistory" runat="server" AutoGenerateColumns="False"
                    CssClass="history-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                        <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No completed deliveries yet.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 QUICK byte | Taste the speed</p>
            <p>Internet Application Development &mdash; Mansoob-e-Zahra</p>
        </footer>
    </form>
</body>
</html>
