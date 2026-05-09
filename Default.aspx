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
        <!-- Navigation Bar -->
        <nav class="navbar">
            <div class="nav-container">
                <a href="Default.aspx" class="nav-logo">
                    <img src="assets/logo.png" alt="QuickByte Logo" style="height:40px;" /> QuickByte
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

        <div class="container">
            <!-- Hero Section -->
            <section class="hero">
                <img src="assets/logo.png" alt="QuickByte Logo" class="hero-logo" />
                <h1>Taste the speed</h1>
                <p class="subtitle">Food Delivery App - IAD Project</p>
                <div class="hero-buttons">
                    <% If Not User.Identity.IsAuthenticated Then %>
                        <a href="Register.aspx" class="btn-primary">Get Started</a>
                    <% End If %>
                    <a href="Search.aspx" class="btn-secondary">Browse Restaurants</a>
                </div>
            </section>

            <main>
                <!-- Main Features -->
                <section class="features-section">
                    <h2 class="section-title">Main Features</h2>
                    <div class="card-grid">
                        <div class="card">
                            <h3>Registration</h3>
                            <p>Register as Customer, Restaurant Manager, or Delivery Rider</p>
                            <a href="Register.aspx" class="btn">Create Account</a>
                        </div>
                        <div class="card">
                            <h3>Search Orders</h3>
                            <p>Search restaurants, and menu items</p>
                            <a href="Search.aspx" class="btn">Search</a>
                        </div>
                        <div class="card">
                            <h3>Order Management</h3>
                            <p>View and manage orders based on your role</p>
                            <a href="Orders.aspx" class="btn">View Orders</a>
                        </div>
                        <% If Session("Role") <> "Customer" Then %>
                        <div class="card">
                            <h3>Menu Management</h3>
                            <p>Manage restaurant menu items and pricing</p>
                            <a href="Menu.aspx" class="btn">Manage Menu</a>
                        </div>
                        <% End If %>

                        <% If User.Identity.IsAuthenticated AndAlso (Session("Role") = "Admin" Or Session("Role") = "PlatformManager") Then %>
                        <div class="card" style="border-top: 4px solid #ba1010; background: #fffcfc;">
                            <h3>Admin Dashboard</h3>
                            <p>Manage Regions, Stakeholders & Revenue Stats</p>
                            <a href="AdminDashboard.aspx" class="btn" style="background:#ba1010;">Manage Network</a>
                        </div>
                        <% End If %>
                    </div>
                </section>
            </main>
        </div>

        <footer>
            <p>&copy; 2026 QUICK byte - Taste the speed</p>
            <p>Internet application development</p>
            <p>Mansoob-e-Zahra</p>
        </footer>
    </form>
</body>
</html>
