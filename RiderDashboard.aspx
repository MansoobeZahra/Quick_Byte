<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RiderDashboard.aspx.vb" Inherits="RiderDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rider Dashboard - QUICK byte</title>
    <link rel="stylesheet" href="rider-dashboard.css">
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <div class="nav-container">
                <a href="Default.aspx" class="nav-logo">
                    <img src="assets/logo.png" alt="QuickByte Logo" style="height:40px;" />
                    QuickByte
                </a>
                <ul class="nav-menu">
                    <li><a href="Default.aspx">Home</a></li>
                    <li><a href="Orders.aspx">Orders</a></li>
                    <li><a href="RiderDashboard.aspx" class="active">Rider Portal</a></li>
                    <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                </ul>
            </div>
        </nav>
        <div class="container">
            <div class="dashboard-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>Rider Portal</h1>
                <p class="subtitle">Manage your deliveries</p>

                <div class="rider-info">
                    <h2>Your Information</h2>
                    <asp:Literal ID="litRiderInfo" runat="server"></asp:Literal>
                    <div class="info-row">
                        <span class="label">Status:</span>
                        <span class="value">
                            <label class="toggle-label">
                                <asp:CheckBox ID="chkAvailability" runat="server" AutoPostBack="true" OnCheckedChanged="chkAvailability_CheckedChanged" />
                                <asp:Label ID="lblStatusText" runat="server"></asp:Label>
                            </label>
                        </span>
                    </div>
                </div>

                <div class="assigned-orders">
                    <h2>Assigned Deliveries</h2>
                    <asp:GridView ID="gvAssignedOrders" runat="server" AutoGenerateColumns="False" CssClass="orders-table" GridLines="None" DataKeyNames="OrderID">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                            <asp:BoundField DataField="CustomerInfo" HeaderText="Customer" HtmlEncode="false" />
                            <asp:BoundField DataField="RestaurantInfo" HeaderText="Restaurant" HtmlEncode="false" />
                            <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="status-select">
                                        <asp:ListItem Value="Preparing" Text="Preparing"></asp:ListItem>
                                        <asp:ListItem Value="Picked Up" Text="Picked Up"></asp:ListItem>
                                        <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
                                        <asp:ListItem Value="Cancelled" Text="Cancelled"></asp:ListItem>
                                    </asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn-update" OnClick="btnUpdate_Click" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="no-results">No deliveries assigned to you right now.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <div class="delivery-history">
                    <h2>Your Delivery History</h2>
                    <asp:GridView ID="gvDeliveryHistory" runat="server" AutoGenerateColumns="False" CssClass="history-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                            <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                            <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <footer>
            <p>&copy; 2026 QUICK byte - Taste the speed</p>
        </footer>
    </form>
</body>
</html>
