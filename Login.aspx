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
            <div class="login-wrapper" style="max-width: 400px; margin: 0 auto; text-align: center;">
                <img src="assets/logo.png" alt="QuickByte Logo" style="height: 60px; margin-bottom: 10px;" />
                <h1>QuickByte</h1>
                <p class="subtitle">Taste the speed</p>
                <br />
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                <div class="form-group" style="text-align: left;">
                    <label for="txtEmail">Email:</label>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter your email" required="required"></asp:TextBox>
                </div>

                <div class="form-group" style="text-align: left;">
                    <label for="txtPassword">Password:</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" required="required"></asp:TextBox>
                </div>

                <div class="remember-forgot" style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                    <label class="checkbox-label">
                        <asp:CheckBox ID="chkRememberMe" runat="server" />
                        Remember Me
                    </label>
                    <a href="#">Forgot Password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" Width="100%" OnClick="btnLogin_Click" />

                <div class="links" style="margin-top: 20px;">
                    <p>Don't have an account? <a href="Register.aspx">Register here</a></p>
                    <p><a href="Default.aspx">Back to Home</a></p>
                </div>

                <div style="margin-top: 20px; padding: 15px; background: #eee; border: 1px solid #333; font-size: 13px; text-align: left;">
                    <h3 style="color: #333; margin-bottom: 10px; font-size: 15px;">Test Credentials:</h3>
                    <p><strong>Admin:</strong> admin@quickbyte.com / Admin@123</p>
                    <p><strong>Customer:</strong> ali@example.com / Customer@123</p>
                    <p><strong>Restaurant:</strong> manager3001@quickbyte.com / Rest@123</p>
                    <p><strong>Rider:</strong> rider5001@quickbyte.com / Rider@123</p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
