Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class RiderDashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.Identity.IsAuthenticated OrElse Session("Role") <> "Rider" Then
            Response.Redirect("Default.aspx")
        End If

        If Not IsPostBack Then
            LoadRiderInfo()
            LoadAssignedOrders()
            LoadDeliveryHistory()
        End If
    End Sub

    Private Sub LoadRiderInfo()
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT RiderID, Name, ContactNumber, Availability FROM Rider WHERE RiderID = @RefID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RefID", refId)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        litRiderInfo.Text = String.Format(
                            "<div class='info-card'>" &
                            "<div class='info-row'><span class='label'>Rider ID:</span><span class='value'>{0}</span></div>" &
                            "<div class='info-row'><span class='label'>Name:</span><span class='value'>{1}</span></div>" &
                            "<div class='info-row'><span class='label'>Contact:</span><span class='value'>{2}</span></div>" &
                            "</div>",
                            reader("RiderID"), reader("Name"), reader("ContactNumber"))
                        
                        chkAvailability.Checked = Convert.ToBoolean(reader("Availability"))
                        UpdateStatusText()
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub UpdateStatusText()
        If chkAvailability.Checked Then
            lblStatusText.Text = "Available"
            lblStatusText.CssClass = "status-available"
        Else
            lblStatusText.Text = "Unavailable"
            lblStatusText.CssClass = "status-unavailable"
        End If
    End Sub

    Protected Sub chkAvailability_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "UPDATE Rider SET Availability = @Available WHERE RiderID = @RefID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Available", chkAvailability.Checked)
                cmd.Parameters.AddWithValue("@RefID", refId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        UpdateStatusText()
    End Sub

    Private Sub LoadAssignedOrders()
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, c.FirstName + ' ' + c.LastName + '<br/><small>' + c.PhoneNumber + '</small>' AS CustomerInfo, " &
                                 "r.Name + '<br/><small>' + r.Street + '</small>' AS RestaurantInfo, " &
                                 "(SELECT SUM(mi.Price * oi.Quantity) FROM OrderItem oi JOIN MenuItem mi ON oi.ItemID = mi.ItemID WHERE oi.OrderID = o.OrderID) AS TotalAmount, " &
                                 "o.Status " &
                                 "FROM [Order] o INNER JOIN Customer c ON o.CustomerID = c.CustomerID INNER JOIN Restaurant r ON o.RestaurantID = r.RestaurantID " &
                                 "WHERE o.RiderID = @RefID AND o.Status IN ('Preparing', 'Picked Up')"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RefID", refId)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvAssignedOrders.DataSource = dt
                gvAssignedOrders.DataBind()

                ' Set dropdown values
                For Each row As GridViewRow In gvAssignedOrders.Rows
                    Dim status As String = dt.Rows(row.RowIndex)("Status").ToString()
                    Dim ddl As DropDownList = CType(row.FindControl("ddlStatus"), DropDownList)
                    If ddl IsNot Nothing Then
                        ddl.SelectedValue = status
                    End If
                Next
            End Using
        End Using
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)
        Dim orderId As Integer = Convert.ToInt32(gvAssignedOrders.DataKeys(row.RowIndex).Value)
        Dim ddl As DropDownList = CType(row.FindControl("ddlStatus"), DropDownList)
        Dim newStatus As String = ddl.SelectedValue

        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "UPDATE [Order] SET Status = @Status WHERE OrderID = @OrderID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Status", newStatus)
                cmd.Parameters.AddWithValue("@OrderID", orderId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadAssignedOrders()
        LoadDeliveryHistory()
    End Sub

    Private Sub LoadDeliveryHistory()
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, o.OrderDate, c.FirstName + ' ' + c.LastName AS CustomerName, " &
                                 "(SELECT SUM(mi.Price * oi.Quantity) FROM OrderItem oi JOIN MenuItem mi ON oi.ItemID = mi.ItemID WHERE oi.OrderID = o.OrderID) AS TotalAmount, " &
                                 "o.Status " &
                                 "FROM [Order] o INNER JOIN Customer c ON o.CustomerID = c.CustomerID " &
                                 "WHERE o.RiderID = @RefID AND o.Status IN ('Delivered', 'Cancelled') ORDER BY o.OrderDate DESC"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RefID", refId)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvDeliveryHistory.DataSource = dt
                gvDeliveryHistory.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
