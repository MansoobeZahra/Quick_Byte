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

            <!-- Admin Only: Add Restaurant -->
            <div class="stat-card full-width" style="margin-bottom: 20px;">
                <h2>Add New Restaurant</h2>
                <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap: 15px; padding: 10px;">
                    <asp:TextBox ID="txtNewRestName" runat="server" placeholder="Restaurant Name" CssClass="form-input"></asp:TextBox>
                    <asp:TextBox ID="txtNewRestEmail" runat="server" placeholder="Email" CssClass="form-input"></asp:TextBox>
                    <asp:TextBox ID="txtNewRestPhone" runat="server" placeholder="Phone" CssClass="form-input"></asp:TextBox>
                    <asp:DropDownList ID="ddlNewRestRegion" runat="server" CssClass="form-input">
                        <asp:ListItem Value="" Text="Select Region"></asp:ListItem>
                        <asp:ListItem Value="Karachi" Text="Karachi"></asp:ListItem>
                        <asp:ListItem Value="Lahore" Text="Lahore"></asp:ListItem>
                        <asp:ListItem Value="Islamabad" Text="Islamabad"></asp:ListItem>
                        <asp:ListItem Value="Rawalpindi" Text="Rawalpindi"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:TextBox ID="txtNewRestAddress" runat="server" placeholder="Street Address" CssClass="form-input"></asp:TextBox>
                    <asp:Button ID="btnAddRestaurant" runat="server" Text="Add Restaurant" CssClass="btn-add" OnClick="btnAddRestaurant_Click" />
                </div>
                <asp:Label ID="lblAdminMessage" runat="server" ForeColor="Green" Visible="false"></asp:Label>
            </div>

            <div class="dashboard-grid">
                <!-- Customers Segmentation -->
                <div class="stat-card full-width">
                    <h2>Customer Segmentation & Region</h2>
                    <asp:GridView ID="gvCustomerSegments" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                            <asp:BoundField DataField="Region" HeaderText="Region" />
                            <asp:BoundField DataField="TotalOrders" HeaderText="Orders" />
                            <asp:BoundField DataField="TotalSpent" HeaderText="Total Spent" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Segment">
                                <ItemTemplate>
                                    <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Restaurants Performance -->
                <div class="stat-card full-width">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <h2>Restaurant Performance & Revenue</h2>
                        <asp:Button ID="btnResetRestRevenue" runat="server" Text="Reset All Revenue" CssClass="btn-reset" OnClick="btnResetRestRevenue_Click" OnClientClick="return confirm('Reset all restaurant revenue till today?');" />
                    </div>
                    <asp:GridView ID="gvRestaurants" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None" DataKeyNames="RestaurantID" OnRowCommand="gvRestaurants_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Restaurant" />
                            <asp:BoundField DataField="Region" HeaderText="Region" />
                            <asp:BoundField DataField="CustomerCount" HeaderText="Unique Customers" />
                            <asp:BoundField DataField="OrderCount" HeaderText="Total Orders" />
                            <asp:BoundField DataField="Revenue" HeaderText="Revenue (Since Reset)" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span style='<%# If(Convert.ToBoolean(Eval("IsActive")), "color:green;", "color:red;") %>'>
                                        <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Disabled") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnToggleRest" runat="server" Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>' 
                                        CommandName="ToggleStatus" CommandArgument='<%# Eval("RestaurantID") %>' CssClass="btn-action" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Riders Activity -->
                <div class="stat-card full-width">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <h2>Rider Activity & Revenue</h2>
                        <asp:Button ID="btnResetRiderRevenue" runat="server" Text="Reset All Revenue" CssClass="btn-reset" OnClick="btnResetRiderRevenue_Click" OnClientClick="return confirm('Reset all rider revenue till today?');" />
                    </div>
                    <asp:GridView ID="gvRiders" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None" DataKeyNames="RiderID" OnRowCommand="gvRiders_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Rider" />
                            <asp:BoundField DataField="Region" HeaderText="Region" />
                            <asp:BoundField DataField="Deliveries" HeaderText="Deliveries" />
                            <asp:BoundField DataField="Revenue" HeaderText="Earnings" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Availability">
                                <ItemTemplate>
                                    <span class='badge' style='<%# If(Convert.ToBoolean(Eval("Availability")), "background:#d4edda;color:#155724;", "background:#f8d7da;color:#721c24;") %>'>
                                        <%# If(Convert.ToBoolean(Eval("Availability")), "Available", "Offline") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span style='<%# If(Convert.ToBoolean(Eval("IsActive")), "color:green;", "color:red;") %>'>
                                        <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Disabled") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnToggleRider" runat="server" Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>' 
                                        CommandName="ToggleStatus" CommandArgument='<%# Eval("RiderID") %>' CssClass="btn-action" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Stakeholder Feedback -->
                <div class="stat-card full-width" style="border-top: 2px solid #ba1010; margin-top: 20px;">
                    <h2 style="color:#ba1010;">Stakeholder Ratings & Reviews</h2>
                    <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="TargetName" HeaderText="Rated Entity" />
                            <asp:BoundField DataField="TargetType" HeaderText="Role" />
                            <asp:TemplateField HeaderText="Rating">
                                <ItemTemplate>
                                    <span class="badge" style='<%# If(Convert.ToInt32(Eval("Rating")) >= 4, "background:#d4edda;color:#155724;", "background:#fff3cd;color:#856404;") %>'>
                                        <%# Eval("Rating") %> / 5 ⭐
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Comment" HeaderText="Review Comment" />
                            <asp:BoundField DataField="Reviewer" HeaderText="By" />
                            <asp:BoundField DataField="Region" HeaderText="City" />
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="no-results">No feedback submitted yet.</div>
                        </EmptyDataTemplate>
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
