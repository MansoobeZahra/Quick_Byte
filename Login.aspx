<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - QUICK byte</title>
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
                    <li><a href="Register.aspx">Register</a></li>
                    <li><a href="Search.aspx">Browse</a></li>
                </ul>
            </div>
        </nav>

        <div class="container" style="max-width: 500px;">
            <div class="page-header">
                <h1>Login</h1>
                <p>Sign in to your QuickByte account</p>
            </div>

            <div class="panel">
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                <div class="form-group">
                    <label>Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="your@email.com"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
                </div>

                <div class="remember-forgot">
                    <label class="checkbox-label">
                        <asp:CheckBox ID="chkRememberMe" runat="server" />
                        Remember Me
                    </label>
                    <a href="#">Forgot Password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" style="width:100%;" OnClick="btnLogin_Click" />

                <div class="links" style="text-align:center; margin-top:15px;">
                    <p>Don't have an account? <a href="Register.aspx">Register here</a></p>
                </div>
            </div>

            <div class="panel" style="font-size:13px;">
                <h2>Test Credentials</h2>
                <table style="width:100%; border-collapse:collapse; font-size:13px;">
                    <tr><td style="padding:5px 0; width:110px; color:#666;">Admin</td><td>admin@quickbyte.com | Admin@123</td></tr>
                    <tr><td style="padding:5px 0; color:#666;">Customer</td><td>ali@example.com | Customer@123</td></tr>
                    <tr><td style="padding:5px 0; color:#666;">Restaurant</td><td>pizzapalace@quickbyte.com | Rest@123</td></tr>
                    <tr><td style="padding:5px 0; color:#666;">Rider</td><td>ahmed@rider.com | Rider@123</td></tr>
                </table>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 QUICK byte | Taste the speed</p>
            <p>Internet Application Development &mdash; Mansoob-e-Zahra</p>
        </footer>
    </form>
</body>
</html>
