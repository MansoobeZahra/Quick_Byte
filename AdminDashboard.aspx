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
                    <img src="assets/logo.png" alt="QuickByte Logo" />
                    QuickByte
                </a>
                <ul class="nav-menu">
                    <li><a href="Default.aspx">Home</a></li>
                    <% If User.Identity.IsAuthenticated Then %>
                        <% If Session("Role")="Customer" Then %>
                            <li><a href="Search.aspx">Search</a></li>
                            <li><a href="Orders.aspx">My Orders</a></li>
                        <% ElseIf Session("Role")="RestaurantManager" Then %>
                            <li><a href="Menu.aspx">Manage Menu</a></li>
                            <li><a href="Orders.aspx">Orders</a></li>
                        <% ElseIf Session("Role")="Rider" Then %>
                            <li><a href="RiderDashboard.aspx">Dashboard</a></li>
                        <% ElseIf Session("Role")="Admin" Or Session("Role")="PlatformManager" Then %>
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

        <div class="container">
            <div class="page-header">
                <img src="assets/logo.png" alt="QuickByte Logo" class="hero-logo" />
                <h1>Business Segmentation & Unified Management Dashboard</h1>
                <p>Network-wide analytics utilizing all database entities and attributes</p>
            </div>

            <!-- Add Restaurant -->
            <div class="panel">
                <h2>Register New Restaurant Partner</h2>
                <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap:15px;">
                    <div class="form-group" style="margin:0;">
                        <label>Restaurant Name</label>
                        <asp:TextBox ID="txtNewRestName" runat="server" placeholder="Name" CssClass="form-input"></asp:TextBox>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Manager Email</label>
                        <asp:TextBox ID="txtNewRestEmail" runat="server" placeholder="email@example.com" CssClass="form-input"></asp:TextBox>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Phone</label>
                        <asp:TextBox ID="txtNewRestPhone" runat="server" placeholder="03001234567" CssClass="form-input"></asp:TextBox>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>City</label>
                        <asp:DropDownList ID="ddlNewRestRegion" runat="server" CssClass="form-input">
                            <asp:ListItem Value="" Text="Select City"></asp:ListItem>
                            <asp:ListItem Value="Karachi" Text="Karachi"></asp:ListItem>
                            <asp:ListItem Value="Lahore" Text="Lahore"></asp:ListItem>
                            <asp:ListItem Value="Islamabad" Text="Islamabad"></asp:ListItem>
                            <asp:ListItem Value="Rawalpindi" Text="Rawalpindi"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Street Address</label>
                        <asp:TextBox ID="txtNewRestAddress" runat="server" placeholder="Address" CssClass="form-input"></asp:TextBox>
                    </div>
                    <div class="form-group" style="margin:0; display:flex; align-items:flex-end;">
                        <asp:Button ID="btnAddRestaurant" runat="server" Text="Register Restaurant"
                            CssClass="btn" style="width:100%;" OnClick="btnAddRestaurant_Click" />
                    </div>
                </div>
                <asp:Label ID="lblAdminMessage" runat="server" ForeColor="Green" Visible="false"
                    style="display:block; margin-top:12px; font-weight:bold;"></asp:Label>
            </div>

            <!-- Customer Segmentation -->
            <div class="panel">
                <h2>Customer Accounts & Segmentation</h2>
                <asp:GridView ID="gvCustomerSegments" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="CustomerID" HeaderText="ID" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="PhoneNumber" HeaderText="Phone" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                        <asp:BoundField DataField="TotalOrders" HeaderText="Orders" />
                        <asp:BoundField DataField="TotalSpent" HeaderText="Total Spent" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Segment">
                            <ItemTemplate>
                                <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedAt" HeaderText="Registered" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No customer data available.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Restaurant Revenue -->
            <div class="panel">
                <h2>Restaurant Revenue &amp; Account Status</h2>
                <asp:GridView ID="gvRestaurants" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None" DataKeyNames="RestaurantID"
                    OnRowCommand="gvRestaurants_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="RestaurantID" HeaderText="ID" />
                        <asp:BoundField DataField="Name" HeaderText="Restaurant" />
                        <asp:BoundField DataField="Street" HeaderText="Street Address" />
                        <asp:BoundField DataField="ContactNumber" HeaderText="Phone" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                        <asp:BoundField DataField="Segment" HeaderText="Segment" />
                        <asp:BoundField DataField="OrderCount" HeaderText="Orders" />
                        <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <b style="color:#f8be2c;"><%# Eval("AvgRating", "{0:F1}") %> / 5</b>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# If(Convert.ToBoolean(Eval("IsActive")), "status-active", "status-disabled") %>'>
                                    <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Disabled") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="LastRevenueReset" HeaderText="Last Reset" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnToggleRest" runat="server"
                                    Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>'
                                    CommandName="ToggleStatus" CommandArgument='<%# Eval("RestaurantID") %>'
                                    CssClass="btn-view" />
                                <asp:Button ID="btnResetRest" runat="server" Text="Reset Revenue"
                                    CommandName="ResetRevenue" CommandArgument='<%# Eval("RestaurantID") %>'
                                    CssClass="btn-reset"
                                    OnClientClick="return confirm('Reset revenue for this restaurant?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No restaurant data available.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Rider Earnings -->
            <div class="panel">
                <h2>Rider Earnings &amp; Dispatch Status</h2>
                <asp:GridView ID="gvRiders" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None" DataKeyNames="RiderID"
                    OnRowCommand="gvRiders_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="RiderID" HeaderText="ID" />
                        <asp:BoundField DataField="Name" HeaderText="Rider" />
                        <asp:BoundField DataField="ContactNumber" HeaderText="Phone" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                        <asp:BoundField DataField="Segment" HeaderText="Segment" />
                        <asp:BoundField DataField="Deliveries" HeaderText="Deliveries" />
                        <asp:BoundField DataField="Revenue" HeaderText="Earnings" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <b style="color:#f8be2c;"><%# Eval("AvgRating", "{0:F1}") %> / 5</b>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Available">
                            <ItemTemplate>
                                <span class='<%# "badge " & If(Convert.ToBoolean(Eval("Availability")), "badge-available", "badge-offline") %>'>
                                    <%# If(Convert.ToBoolean(Eval("Availability")), "Available", "Offline") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Account">
                            <ItemTemplate>
                                <span class='<%# If(Convert.ToBoolean(Eval("IsActive")), "status-active", "status-disabled") %>'>
                                    <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Disabled") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="LastRevenueReset" HeaderText="Last Reset" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnToggleRider" runat="server"
                                    Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>'
                                    CommandName="ToggleStatus" CommandArgument='<%# Eval("RiderID") %>'
                                    CssClass="btn-view" />
                                <asp:Button ID="btnResetRider" runat="server" Text="Reset"
                                    CommandName="ResetRevenue" CommandArgument='<%# Eval("RiderID") %>'
                                    CssClass="btn-reset"
                                    OnClientClick="return confirm('Reset earnings for this rider?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No rider data available.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Platform Managers -->
            <div class="panel">
                <h2>Platform Managers (Administrative Staff)</h2>
                <asp:GridView ID="gvPlatformManagers" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ManagerID" HeaderText="Manager ID" />
                        <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                        <asp:BoundField DataField="Department" HeaderText="Department" />
                        <asp:TemplateField HeaderText="Segment">
                            <ItemTemplate>
                                <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No Platform Managers registered.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- RBAC User Accounts -->
            <div class="panel">
                <h2>Security &amp; RBAC Login Credentials</h2>
                <asp:GridView ID="gvUserLogins" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="UserID" HeaderText="User ID" />
                        <asp:BoundField DataField="Email" HeaderText="Login Email" />
                        <asp:BoundField DataField="Role" HeaderText="Security Role" />
                        <asp:BoundField DataField="ReferenceID" HeaderText="Entity Ref ID" />
                        <asp:BoundField DataField="Region" HeaderText="Assigned City" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No user login accounts created.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Recent Orders -->
            <div class="panel">
                <h2>Logistics &amp; Recent Orders</h2>
                <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                        <asp:BoundField DataField="RestaurantName" HeaderText="Restaurant" />
                        <asp:BoundField DataField="RiderName" HeaderText="Assigned Rider" />
                        <asp:BoundField DataField="OrderDate" HeaderText="Order Timestamp" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="Status" HeaderText="Delivery Status" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No orders placed in the system.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Payments -->
            <div class="panel">
                <h2>Financial Transactions &amp; Payments</h2>
                <asp:GridView ID="gvRecentPayments" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="PaymentID" HeaderText="Payment ID" />
                        <asp:BoundField DataField="OrderID" HeaderText="Associated Order ID" />
                        <asp:BoundField DataField="Method" HeaderText="Payment Method" />
                        <asp:BoundField DataField="Amount" HeaderText="Transaction Value" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="PaymentDate" HeaderText="Transaction Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No transactions captured.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Customer Audit Logs -->
            <div class="panel">
                <h2>Security Deletion Audit Log (Triggers Log)</h2>
                <asp:GridView ID="gvCustomerAuditLog" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="LogID" HeaderText="Audit Log ID" />
                        <asp:BoundField DataField="CustomerID" HeaderText="Former Customer ID" />
                        <asp:BoundField DataField="Email" HeaderText="Former Customer Email" />
                        <asp:BoundField DataField="DeletedAt" HeaderText="Deletion Timestamp" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No customer accounts deleted (Audit trail clean).</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Feedback -->
            <div class="panel">
                <h2>Stakeholder Ratings &amp; Reviews</h2>
                <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="FeedbackID" HeaderText="Feedback ID" />
                        <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                        <asp:BoundField DataField="TargetName" HeaderText="Rated Entity" />
                        <asp:BoundField DataField="TargetType" HeaderText="Entity Role" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <span class='<%# GetRatingClass(Eval("Rating")) %>'>
                                    <%# Eval("Rating") %> / 5
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Comment" HeaderText="Review Comments" />
                        <asp:BoundField DataField="Reviewer" HeaderText="Reviewer Name" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                        <asp:BoundField DataField="CreatedAt" HeaderText="Date Submitted" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No reviews submitted yet.</div>
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
