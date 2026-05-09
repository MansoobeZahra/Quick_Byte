<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Search.aspx.vb" Inherits="Search" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search - QUICK byte</title>
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
                        <% If Session("Role") = "Customer" Then %>
                            <li><a href="Search.aspx">Search</a></li>
                            <li><a href="Orders.aspx">My Orders</a></li>
                        <% ElseIf Session("Role") = "RestaurantManager" Then %>
                            <li><a href="Menu.aspx">Manage Menu</a></li>
                            <li><a href="Orders.aspx">Orders</a></li>
                        <% ElseIf Session("Role") = "Rider" Then %>
                            <li><a href="RiderDashboard.aspx">Dashboard</a></li>
                        <% ElseIf Session("Role") = "Admin" Or Session("Role") = "PlatformManager" Then %>
                            <li><a href="Orders.aspx">All Orders</a></li>
                            <li><a href="AdminDashboard.aspx">Segmentation</a></li>
                        <% End If %>
                        <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                        <li class="user-welcome"><%= Session("Role") %>: <%= User.Identity.Name %></li>
                    <% Else %>
                        <li><a href="Register.aspx">Register</a></li>
                        <li><a href="Login.aspx">Login</a></li>
                    <% End If %>
                </ul>
            </div>
        </nav>

        <div class="container">
            <div class="page-header">
                <h1>Search Menu</h1>
                <p>Browse restaurants and food items by city</p>
            </div>

            <div class="panel">
                <h2>Find Food Near You</h2>
                <div class="form-row">
                    <div class="form-group">
                        <label>Select City</label>
                        <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlRegion_SelectedIndexChanged">
                            <asp:ListItem Value="Karachi">Karachi</asp:ListItem>
                            <asp:ListItem Value="Lahore">Lahore</asp:ListItem>
                            <asp:ListItem Value="Islamabad">Islamabad</asp:ListItem>
                            <asp:ListItem Value="Rawalpindi">Rawalpindi</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Search Item</label>
                        <div style="display:flex; gap:10px;">
                            <asp:TextBox ID="txtSearch" runat="server" placeholder="e.g. Pizza, Biryani" style="flex:1;"></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn" OnClick="btnSearch_Click" style="white-space:nowrap;" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="panel">
                <h2>Results</h2>
                <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Visible="false" style="display:block; margin-bottom:10px; font-weight:bold;"></asp:Label>
                <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False"
                    CssClass="results-table" GridLines="None"
                    DataKeyNames="ItemID,RestaurantID" OnRowCommand="gvResults_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="ItemName" HeaderText="Item" />
                        <asp:BoundField DataField="RestaurantName" HeaderText="Restaurant" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <span style="color:#ba1010; font-weight:bold;"><%# Eval("AvgRating", "{0:F1}") %> / 5</span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnOrder" runat="server" Text="Order Now" CommandName="Order"
                                    CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn-view" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No items found. Try a different city or search term.</div>
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