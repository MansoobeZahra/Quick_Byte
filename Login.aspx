<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - QUICK byte</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="login-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>QuickByte</h1>
                <p class="subtitle">Taste the speed</p>
                
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                <div class="form-group">
                    <label for="txtEmail">Email:</label>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter your email" required="required"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password:</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" required="required"></asp:TextBox>
                </div>

                <div class="remember-forgot">
                    <label class="checkbox-label">
                        <asp:CheckBox ID="chkRememberMe" runat="server" />
                        Remember Me
                    </label>
                    <a href="#">Forgot Password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />

                <div class="links">
                    <p>Don't have an account? <a href="Register.aspx">Register here</a></p>
                    <p><a href="Default.aspx">Back to Home</a></p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
