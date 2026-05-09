<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Payment.aspx.vb" Inherits="Payment" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - QUICK byte</title>
    <link rel="stylesheet" href="index.css">
    <script>
        function togglePaymentFields() {
            var method = document.getElementById('<%= ddlPaymentMethod.ClientID %>').value;
            document.getElementById('cardFields').style.display = (method === 'credit' || method === 'debit') ? 'block' : 'none';
            document.getElementById('walletFields').style.display = (method === 'easypaisa' || method === 'jazzcash') ? 'block' : 'none';
        }
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
                    <li><a href="Orders.aspx">My Orders</a></li>
                    <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                    <li class="user-welcome"><%= User.Identity.Name %></li>
                </ul>
            </div>
        </nav>

        <div class="container" style="max-width:700px;">
            <div class="page-header">
                <h1>Payment</h1>
                <p>Complete your order payment</p>
            </div>

            <div class="panel">
                <h2>Order Summary</h2>
                <asp:Literal ID="litOrderSummary" runat="server"></asp:Literal>
            </div>

            <div id="paymentFormSection" runat="server">
                <div class="panel">
                    <h2>Payment Details</h2>
                    <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                    <div class="form-group">
                        <label>Payment Method</label>
                        <asp:DropDownList ID="ddlPaymentMethod" runat="server" onchange="togglePaymentFields()">
                            <asp:ListItem Value="" Text="Select Method"></asp:ListItem>
                            <asp:ListItem Value="cash" Text="Cash on Delivery"></asp:ListItem>
                            <asp:ListItem Value="credit" Text="Credit Card"></asp:ListItem>
                            <asp:ListItem Value="debit" Text="Debit Card"></asp:ListItem>
                            <asp:ListItem Value="easypaisa" Text="Easypaisa"></asp:ListItem>
                            <asp:ListItem Value="jazzcash" Text="JazzCash"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div id="cardFields" style="display:none;">
                        <div class="form-group">
                            <label>Card Number</label>
                            <asp:TextBox ID="txtCardNumber" runat="server" placeholder="1234 5678 9012 3456" MaxLength="19"></asp:TextBox>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Expiry Date</label>
                                <asp:TextBox ID="txtExpiryDate" runat="server" placeholder="MM/YY" MaxLength="5"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>CVV</label>
                                <asp:TextBox ID="txtCVV" runat="server" placeholder="123" MaxLength="3"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div id="walletFields" style="display:none;">
                        <div class="form-group">
                            <label>Mobile Number</label>
                            <asp:TextBox ID="txtWalletNumber" runat="server" placeholder="03001234567"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Total Amount</label>
                        <asp:TextBox ID="txtAmount" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnPay" runat="server" Text="Process Payment" CssClass="btn" style="width:100%;" OnClick="btnPay_Click" />
                </div>
            </div>

            <div class="panel">
                <h2>Payment History</h2>
                <asp:GridView ID="gvPaymentHistory" runat="server" AutoGenerateColumns="False"
                    CssClass="history-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="PaymentID" HeaderText="ID" />
                        <asp:BoundField DataField="OrderID" HeaderText="Order" />
                        <asp:BoundField DataField="Method" HeaderText="Method" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="PaymentDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="no-results">No payment history found.</div>
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
