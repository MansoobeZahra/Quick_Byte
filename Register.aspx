<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Register.aspx.vb" Inherits="Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - QUICK byte</title>
    <link rel="stylesheet" href="index.css">
    <script type="text/javascript">
        function toggleFields() {
            var userType = document.getElementById('<%= ddlUserType.ClientID %>').value;
            var nameFields = document.getElementById('nameFields');
            var riderFields = document.getElementById('riderFields');
            nameFields.style.display = (userType === 'Customer' || userType === 'Rider') ? 'block' : 'none';
            riderFields.style.display = (userType === 'Rider') ? 'block' : 'none';
        }
        window.onload = function () { toggleFields(); };
    </script>
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
                    <li><a href="Login.aspx">Login</a></li>
                    <li><a href="Search.aspx">Browse</a></li>
                </ul>
            </div>
        </nav>

        <div class="container" style="max-width: 600px;">
            <div class="page-header">
                <img src="assets/logo.png" alt="QuickByte Logo" class="hero-logo" />
                <h1>Create Account</h1>
                <p>Register as a Customer or Delivery Rider</p>
            </div>

            <div class="panel">
                <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Visible="false" Font-Bold="true"></asp:Label>

                <div class="form-row">
                    <div class="form-group">
                        <label>Register As</label>
                        <asp:DropDownList ID="ddlUserType" runat="server" onchange="toggleFields()">
                            <asp:ListItem Value="" Text="Select Role"></asp:ListItem>
                            <asp:ListItem Value="Customer" Text="Customer"></asp:ListItem>
                            <asp:ListItem Value="Rider" Text="Delivery Rider"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>City / Region</label>
                        <asp:DropDownList ID="ddlRegion" runat="server">
                            <asp:ListItem Value="" Text="Select Region"></asp:ListItem>
                            <asp:ListItem Value="Karachi" Text="Karachi"></asp:ListItem>
                            <asp:ListItem Value="Lahore" Text="Lahore"></asp:ListItem>
                            <asp:ListItem Value="Islamabad" Text="Islamabad"></asp:ListItem>
                            <asp:ListItem Value="Rawalpindi" Text="Rawalpindi"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div id="nameFields">
                    <div class="form-row">
                        <div class="form-group">
                            <label>First Name</label>
                            <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Last Name</label>
                            <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" placeholder="03001234567"></asp:TextBox>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                    </div>
                </div>

                <div id="riderFields" style="display:none;">
                    <div class="form-group">
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkAvailability" runat="server" Checked="true" />
                            Available for Delivery
                        </label>
                    </div>
                </div>

                <div class="btn-container">
                    <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn" OnClick="btnRegister_Click" />
                    <button type="reset" class="btn-secondary">Clear Form</button>
                </div>

                <div class="links" style="margin-top:15px;">
                    Already have an account? <a href="Login.aspx">Login here</a>
                </div>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 QUICK byte | Taste the speed</p>
            <p>Internet Application Development &mdash; Mansoob-e-Zahra</p>
        </footer>
    </form>
</body>
</html>
