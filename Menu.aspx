<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Menu.aspx.vb" Inherits="MenuPage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Management - QUICK byte</title>
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
                    <li><a href="Menu.aspx">Manage Menu</a></li>
                    <li><a href="Orders.aspx">Orders</a></li>
                    <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                    <li class="user-welcome"><%= User.Identity.Name %></li>
                </ul>
            </div>
        </nav>

        <div class="container">
            <div class="page-header">
                <h1>Menu Management</h1>
                <p>Add, update, and manage your restaurant's menu items</p>
            </div>

            <div class="panel">
                <h2>Add New Item</h2>
                <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Visible="false" Font-Bold="true"></asp:Label>
                <div class="form-row">
                    <div class="form-group">
                        <label>Item Name</label>
                        <asp:TextBox ID="txtItemName" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Price (Rs.)</label>
                        <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" step="0.01"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label class="checkbox-label">
                        <asp:CheckBox ID="chkAvailable" runat="server" Checked="true" />
                        Available for Order
                    </label>
                </div>
                <asp:Button ID="btnAdd" runat="server" Text="Add Item" CssClass="btn" OnClick="btnAdd_Click" />
            </div>

            <div class="panel">
                <h2>Current Menu</h2>
                <asp:GridView ID="gvMenuItems" runat="server" AutoGenerateColumns="False"
                    CssClass="menu-table" GridLines="None" DataKeyNames="ItemID"
                    OnRowCommand="gvMenuItems_RowCommand" OnRowDeleting="gvMenuItems_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Item Name" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# If(Convert.ToBoolean(Eval("Available")), "status-active", "status-disabled") %>'>
                                    <%# If(Convert.ToBoolean(Eval("Available")), "Active", "Hidden") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnToggle" runat="server"
                                    Text='<%# If(Convert.ToBoolean(Eval("Available")), "Hide", "Show") %>'
                                    CommandName="ToggleAvailable" CommandArgument='<%# Eval("ItemID") %>'
                                    CssClass="btn-view" />
                                <asp:Button ID="btnDelete" runat="server" Text="Delete"
                                    CommandName="Delete" CssClass="btn-reset" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No menu items yet. Add your first item above.</div>
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
