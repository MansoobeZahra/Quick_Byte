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
                    <li><a href="Orders.aspx">All Orders</a></li>
                    <li><a href="AdminDashboard.aspx">Segmentation</a></li>
                    <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                    <li class="user-welcome">Admin: <%= User.Identity.Name %></li>
                </ul>
            </div>
        </nav>

        <div class="container">
            <div class="page-header">
                <h1>Business Segmentation Dashboard</h1>
                <p>Network-wide analytics for customers, restaurants, and riders</p>
            </div>

            <!-- Add Restaurant -->
            <div class="panel">
                <h2>Register New Restaurant Partner</h2>
                <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap:15px;">
                    <div class="form-group" style="margin:0;">
                        <label>Restaurant Name</label>
                        <asp:TextBox ID="txtNewRestName" runat="server" placeholder="Name"></asp:TextBox>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Manager Email</label>
                        <asp:TextBox ID="txtNewRestEmail" runat="server" placeholder="email@example.com"></asp:TextBox>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Phone</label>
                        <asp:TextBox ID="txtNewRestPhone" runat="server" placeholder="03001234567"></asp:TextBox>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>City</label>
                        <asp:DropDownList ID="ddlNewRestRegion" runat="server">
                            <asp:ListItem Value="" Text="Select City"></asp:ListItem>
                            <asp:ListItem Value="Karachi" Text="Karachi"></asp:ListItem>
                            <asp:ListItem Value="Lahore" Text="Lahore"></asp:ListItem>
                            <asp:ListItem Value="Islamabad" Text="Islamabad"></asp:ListItem>
                            <asp:ListItem Value="Rawalpindi" Text="Rawalpindi"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Street Address</label>
                        <asp:TextBox ID="txtNewRestAddress" runat="server" placeholder="Address"></asp:TextBox>
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
                <h2>Customer Segmentation</h2>
                <asp:GridView ID="gvCustomerSegments" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                        <asp:BoundField DataField="TotalOrders" HeaderText="Orders" />
                        <asp:BoundField DataField="TotalSpent" HeaderText="Total Spent" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Segment">
                            <ItemTemplate>
                                <span class='<%# GetSegmentClass(Eval("Segment")) %>'><%# Eval("Segment") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
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
                        <asp:BoundField DataField="Name" HeaderText="Restaurant" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                        <asp:BoundField DataField="OrderCount" HeaderText="Orders" />
                        <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <span style="color:#ba1010; font-weight:bold;"><%# Eval("AvgRating", "{0:F1}") %> / 5</span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# If(Convert.ToBoolean(Eval("IsActive")), "status-active", "status-disabled") %>'>
                                    <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Disabled") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
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
                        <asp:BoundField DataField="Name" HeaderText="Rider" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
                        <asp:BoundField DataField="Deliveries" HeaderText="Deliveries" />
                        <asp:BoundField DataField="Revenue" HeaderText="Earnings" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <span style="color:#ba1010; font-weight:bold;"><%# Eval("AvgRating", "{0:F1}") %> / 5</span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Available">
                            <ItemTemplate>
                                <span class='<%# "badge " & If(Convert.ToBoolean(Eval("Availability")), "badge-available", "badge-offline") %>'>
                                    <%# If(Convert.ToBoolean(Eval("Availability")), "Yes", "No") %>
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

            <!-- Feedback -->
            <div class="panel">
                <h2>Stakeholder Ratings &amp; Reviews</h2>
                <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False"
                    CssClass="admin-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="TargetName" HeaderText="Rated" />
                        <asp:BoundField DataField="TargetType" HeaderText="Role" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <span class='<%# "badge " & If(Convert.ToInt32(Eval("Rating")) >= 4, "badge-high", "badge-low") %>'>
                                    <%# Eval("Rating") %> / 5
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Comment" HeaderText="Comment" />
                        <asp:BoundField DataField="Reviewer" HeaderText="Reviewer" />
                        <asp:BoundField DataField="Region" HeaderText="City" />
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
