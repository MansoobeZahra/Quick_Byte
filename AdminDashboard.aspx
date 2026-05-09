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
            <div class="nav-container">
                <a href="Default.aspx" class="nav-logo">
                    <img src="assets/logo.png" alt="QuickByte Logo" style="height:40px;" /> QuickByte
                </a>
                <ul class="nav-menu">
                    <li><a href="Default.aspx">Home</a></li>
                    <% If User.Identity.IsAuthenticated Then %>
                        <li class="role-badge"><%= Session("Role") %></li>
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
                            <li><a href="AdminDashboard.aspx">Admin Dashboard</a></li>
                        <% End If %>
                        <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                    <% Else %>
                        <li><a href="Register.aspx">Register</a></li>
                        <li><a href="Login.aspx">Login</a></li>
                        <li><a href="Search.aspx">Search</a></li>
                    <% End If %>
                </ul>
            </div>
        </nav>

        <div class="container">
            <header style="text-align: center; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 10px;">
                <h1>Business Segmentation Dashboard</h1>
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
