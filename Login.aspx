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
        <div class="container">
            <div class="stat-card">
                <h1>QuickByte Login</h1>
                
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                <p>Email:</p>
                <asp:TextBox ID="txtEmail" runat="server" required="required"></asp:TextBox>

                <p>Password:</p>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" required="required"></asp:TextBox>

                <div class="remember-forgot">
                    <asp:CheckBox ID="chkRememberMe" runat="server" Text="Remember Me" />
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" OnClick="btnLogin_Click" />

                <div class="links">
                    <p>Don't have an account? <a href="Register.aspx">Register here</a></p>
                    <a href="Default.aspx">Back to Home</a>
                </div>

                <div class="stat-card" style="margin-top: 20px;">
                    <h3>Test Credentials:</h3>
                    <p>Admin: admin@quickbyte.com / Admin@123</p>
                    <p>Customer: ali1@example.com / Customer@123</p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
