Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class AdminDashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.Identity.IsAuthenticated OrElse (Session("Role") <> "Admin" And Session("Role") <> "PlatformManager") Then
            Response.Redirect("Default.aspx")
        End If

        If Not IsPostBack Then
            RefreshAllData()
        End If
    End Sub

    Private Sub RefreshAllData()
        LoadCustomerSegmentation()
        LoadRestaurantPerformance()
        LoadRiderActivity()
    End Sub

    Private Sub LoadCustomerSegmentation()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT c.FirstName + ' ' + c.LastName AS CustomerName, c.Region, " &
                                 "COUNT(o.OrderID) AS TotalOrders, " &
                                 "ISNULL(SUM(p.Amount), 0) AS TotalSpent, " &
                                 "CASE " &
                                 "  WHEN SUM(p.Amount) > 5000 OR COUNT(o.OrderID) > 10 THEN 'Premium' " &
                                 "  ELSE 'Regular' " &
                                 "END AS Segment " &
                                 "FROM Customer_QB c " &
                                 "LEFT JOIN Order_QB o ON c.CustomerID = o.CustomerID " &
                                 "LEFT JOIN Payment_QB p ON o.OrderID = p.OrderID AND p.Status = 'Paid' " &
                                 "GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Region"
            
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvCustomerSegments.DataSource = dt
                gvCustomerSegments.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadRestaurantPerformance()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            ' Query using LastRevenueReset to show revenue since reset
            Dim query As String = "SELECT r.RestaurantID, r.Name, r.Region, r.IsActive, " &
                                 "(SELECT COUNT(DISTINCT CustomerID) FROM Order_QB WHERE RestaurantID = r.RestaurantID) AS CustomerCount, " &
                                 "(SELECT COUNT(*) FROM Order_QB WHERE RestaurantID = r.RestaurantID AND OrderDate >= r.LastRevenueReset) AS OrderCount, " &
                                 "ISNULL((SELECT SUM(p.Amount) FROM Order_QB o JOIN Payment_QB p ON o.OrderID = p.OrderID " &
                                 "        WHERE o.RestaurantID = r.RestaurantID AND o.OrderDate >= r.LastRevenueReset AND p.Status = 'Paid'), 0) AS Revenue " &
                                 "FROM Restaurant_QB r"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvRestaurants.DataSource = dt
                gvRestaurants.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadRiderActivity()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT RiderID, Name, Region, Availability, IsActive, " &
                                 "(SELECT COUNT(*) FROM Order_QB WHERE RiderID = Rider_QB.RiderID AND Status = 'Confirmed' AND OrderDate >= Rider_QB.LastRevenueReset) AS Deliveries, " &
                                 "ISNULL((SELECT SUM(50) FROM Order_QB WHERE RiderID = Rider_QB.RiderID AND Status = 'Confirmed' AND OrderDate >= Rider_QB.LastRevenueReset), 0) AS Revenue " &
                                 "FROM Rider_QB"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvRiders.DataSource = dt
                gvRiders.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub btnAddRestaurant_Click(ByVal sender As Object, ByVal e As EventArgs)
        If txtNewRestName.Text = "" Or ddlNewRestRegion.SelectedValue = "" Then Return

        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim trans As SqlTransaction = conn.BeginTransaction()
            Try
                ' 1. Add to Restaurant_QB
                Dim q1 As String = "INSERT INTO Restaurant_QB (Name, Street, Region, IsActive) OUTPUT INSERTED.RestaurantID VALUES (@Name, @Street, @Region, 1)"
                Dim restId As Integer
                Using cmd As New SqlCommand(q1, conn, trans)
                    cmd.Parameters.AddWithValue("@Name", txtNewRestName.Text)
                    cmd.Parameters.AddWithValue("@Street", txtNewRestAddress.Text)
                    cmd.Parameters.AddWithValue("@Region", ddlNewRestRegion.SelectedValue)
                    restId = cmd.ExecuteScalar()
                End Using

                ' 2. Add to Users_QB
                Dim q2 As String = "INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID, Region) VALUES (@Email, 'Rest@123', 'RestaurantManager', @RefID, @Region)"
                Using cmd As New SqlCommand(q2, conn, trans)
                    cmd.Parameters.AddWithValue("@Email", txtNewRestEmail.Text)
                    cmd.Parameters.AddWithValue("@RefID", restId)
                    cmd.Parameters.AddWithValue("@Region", ddlNewRestRegion.SelectedValue)
                    cmd.ExecuteNonQuery()
                End Using

                trans.Commit()
                lblAdminMessage.Text = "Restaurant added successfully!"
                lblAdminMessage.Visible = True
                RefreshAllData()
            Catch ex As Exception
                trans.Rollback()
                lblAdminMessage.Text = "Error: " & ex.Message
                lblAdminMessage.Visible = True
            End Try
        End Using
    End Sub

    Protected Sub gvRestaurants_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "ToggleStatus" Then
            Dim restId As Integer = Convert.ToInt32(e.CommandArgument)
            ExecuteNonQuery("UPDATE Restaurant_QB SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE RestaurantID = " & restId)
            RefreshAllData()
        End If
    End Sub

    Protected Sub gvRiders_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "ToggleStatus" Then
            Dim riderId As Integer = Convert.ToInt32(e.CommandArgument)
            ExecuteNonQuery("UPDATE Rider_QB SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE RiderID = " & riderId)
            RefreshAllData()
        End If
    End Sub

    Protected Sub btnResetRestRevenue_Click(ByVal sender As Object, ByVal e As EventArgs)
        ExecuteNonQuery("UPDATE Restaurant_QB SET LastRevenueReset = GETDATE()")
        RefreshAllData()
    End Sub

    Protected Sub btnResetRiderRevenue_Click(ByVal sender As Object, ByVal e As EventArgs)
        ExecuteNonQuery("UPDATE Rider_QB SET LastRevenueReset = GETDATE()")
        RefreshAllData()
    End Sub

    Private Sub ExecuteNonQuery(ByVal query As String)
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Protected Function GetSegmentClass(ByVal segment As Object) As String
        Dim seg As String = If(segment IsNot Nothing, segment.ToString(), "")
        Select Case seg
            Case "Premium", "Top Performance", "Elite Rider"
                Return "segment-premium"
            Case Else
                Return "segment-regular"
        End Select
    End Function

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
