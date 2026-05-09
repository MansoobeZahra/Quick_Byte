<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDashboard.aspx.vb" Inherits="AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - QUICK byte</title>
    <link rel="stylesheet" href="index.css">
    <style>
        .dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px; }
        .stat-card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-top: 4px solid #ba1010; }
        .stat-card h2 { color: #ba1010; margin-bottom: 15px; font-size: 1.2rem; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .admin-table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }
        .admin-table th { background: #fcf8ec; text-align: left; padding: 10px; border-bottom: 2px solid #ba1010; }
        .admin-table td { padding: 10px; border-bottom: 1px solid #eee; }
        .segment-premium { color: gold; font-weight: bold; }
        .segment-regular { color: #555; }
        .segment-bulk { color: #ba1010; font-weight: bold; }
        .full-width { grid-column: 1 / -1; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <div class="nav-container">
                <a href="Default.aspx" class="nav-logo">
                    <img src="assets/logo.png" alt="QuickByte Logo" style="height:40px;" />
                    QuickByte Admin
                </a>
                <ul class="nav-menu">
                    <li><a href="Default.aspx">Home</a></li>
                    <% If User.Identity.IsAuthenticated Then %>
                        <% If Session("Role") = "Customer" Then %>
                            <li><a href="Search.aspx">Search</a></li>
                            <li><a href="Orders.aspx">My Orders</a></li>
                        <% ElseIf Session("Role") = "RestaurantManager" Then %>
                            <li><a href="Menu.aspx">Manage Menu</a></li>
                            <li><a href="Orders.aspx">Orders</a></li>
                        <% ElseIf Session("Role") = "Rider" Then %>
                            <li><a href="RiderDashboard.aspx">Dashboard</a></li>
                        <% ElseIf Session("Role") = "Admin" Or Session("Role") = "PlatformManager" Then %>
                            <li><a href="Search.aspx">Search</a></li>
                            <li><a href="Orders.aspx">All Orders</a></li>
                            <li><a href="AdminDashboard.aspx">Segmentation Dashboard</a></li>
                        <% End If %>
                        <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                        <li class="user-welcome"><b><%= Session("Role") %>: <%= User.Identity.Name %></b></li>
                    <% Else %>
                        <li><a href="Register.aspx">Register</a></li>
                        <li><a href="Login.aspx">Login</a></li>
                        <li><a href="Search.aspx">Search</a></li>
                    <% End If %>
                </ul>
            </div>
        </nav>

        <div class="container" style="max-width: 1200px;">
            <header style="text-align: center; margin-bottom: 30px;">
                <h1 style="color: #ba1010;">Business Segmentation Dashboard</h1>
                <p>Real-time analytics and stakeholder management</p>
            </header>

            <div class="dashboard-grid">
                <!-- Customers Segmentation -->
                <div class="stat-card full-width">
                    <h2>Customer Segmentation (Premium & Bulk Buyers)</h2>
                    <asp:GridView ID="gvCustomerSegments" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                            <asp:BoundField DataField="TotalOrders" HeaderText="Total Orders" />
                            <asp:BoundField DataField="TotalSpent" HeaderText="Total Spent" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="AvgItemsPerOrder" HeaderText="Avg Items/Order" DataFormatString="{0:F1}" />
                            <asp:TemplateField HeaderText="Segment">
                                <ItemTemplate>
                                    <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Restaurants Performance & Segmentation -->
                <div class="stat-card">
                    <h2>Restaurant Performance & Segmentation</h2>
                    <asp:GridView ID="gvRestaurants" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
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

                <!-- Riders Activity & Segmentation -->
                <div class="stat-card">
                    <h2>Rider Activity & Segmentation</h2>
                    <asp:GridView ID="gvRiders" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
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
                <div class="stat-card full-width">
                    <h2>Platform Managers (Administrative Users)</h2>
                    <asp:GridView ID="gvPlatformManagers" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="FullName" HeaderText="Name" />
                            <asp:BoundField DataField="Department" HeaderText="Department" />
                            <asp:BoundField DataField="Segment" HeaderText="Access Level" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 QUICK byte Admin - Internal Use Only</p>
        </footer>
    </form>
</body>
</html>
