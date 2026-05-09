<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QUICK byte - Home</title>
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <a href="Default.aspx">QuickByte Home</a> |
            <% If User.Identity.IsAuthenticated Then %>
                <% If Session("Role") = "Customer" Then %>
                    <a href="Search.aspx">Search</a> | <a href="Orders.aspx">My Orders</a> |
                <% ElseIf Session("Role") = "RestaurantManager" Then %>
                    <a href="Menu.aspx">Manage Menu</a> | <a href="Orders.aspx">Restaurant Orders</a> |
                <% ElseIf Session("Role") = "Rider" Then %>
                    <a href="RiderDashboard.aspx">Rider Portal</a> |
                <% ElseIf Session("Role") = "Admin" Or Session("Role") = "PlatformManager" Then %>
                    <a href="Search.aspx">Search</a> | <a href="Orders.aspx">All Orders</a> | <a href="AdminDashboard.aspx">Admin Dashboard</a> |
                <% End If %>
                <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
                <span> Welcome, <%= User.Identity.Name %></span>
            <% Else %>
                <a href="Register.aspx">Register</a> | <a href="Login.aspx">Login</a> | <a href="Search.aspx">Search</a>
            <% End If %>
        </nav>

        <div class="container">
            <div class="stat-card">
                <h1>QUICK byte - Taste the speed</h1>
                <p>Food Delivery App Management System</p>
                <% If Not User.Identity.IsAuthenticated Then %>
                    <a href="Register.aspx" class="btn">Get Started</a>
                <% End If %>
                <a href="Search.aspx" class="btn">Browse Restaurants</a>
            </div>

            <div class="stat-card">
                <h2>System Features</h2>
                <ul>
                    <li><b>User Management:</b> Admin control over all stakeholders.</li>
                    <li><b>Role-Based Access:</b> Dashboards for Customers, Managers, and Riders.</li>
                    <li><b>Order Tracking:</b> Live status updates and delivery history.</li>
                    <li><b>Business Analytics:</b> Segmentation and revenue reporting.</li>
                </ul>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 QUICK byte - Mansoob-e-Zahra</p>
        </footer>
    </form>
</body>
</html>
