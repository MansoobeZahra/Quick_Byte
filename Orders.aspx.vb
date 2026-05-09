Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class Orders
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.Identity.IsAuthenticated Then
            Response.Redirect("Login.aspx")
        End If

        If Not IsPostBack Then
            LoadOrders()
        End If
    End Sub

    Private Sub LoadOrders()
        Dim role As String = If(Session("Role") IsNot Nothing, Session("Role").ToString(), "")
        Dim refId As Integer = If(Session("ReferenceID") IsNot Nothing, Convert.ToInt32(Session("ReferenceID")), 0)
        
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName, r.Name AS RestaurantName, o.Status, o.OrderDate FROM [Order] o INNER JOIN Customer c ON o.CustomerID = c.CustomerID INNER JOIN Restaurant r ON o.RestaurantID = r.RestaurantID"
            
            If role = "Customer" Then
                query &= " WHERE o.CustomerID = @RefID"
                lblTitle.Text = "My Orders"
            ElseIf role = "RestaurantManager" Then
                query &= " WHERE o.RestaurantID = @RefID"
                lblTitle.Text = "Restaurant Orders"
            ElseIf role = "Admin" Then
                lblTitle.Text = "All Orders (Admin)"
            End If
            
            query &= " ORDER BY o.OrderDate DESC"

            Using cmd As New SqlCommand(query, conn)
                If role <> "Admin" Then
                    cmd.Parameters.AddWithValue("@RefID", refId)
                End If
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvOrders.DataSource = dt
                gvOrders.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub gvOrders_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If e.CommandName = "ViewOrder" Then
            Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)
            ' In a real app, we might redirect to OrderDetails.aspx?id=orderId or display a panel.
            ' For this beginner level, let's redirect to Payment.aspx if status is Pending and user is Customer.
            Response.Redirect("Payment.aspx?OrderID=" & orderId)
        End If
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
