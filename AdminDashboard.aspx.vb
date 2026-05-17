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
        LoadFeedback()
        LoadPlatformManagers()
        LoadUserLogins()
        LoadRecentOrders()
        LoadRecentPayments()
        LoadCustomerAuditLog()
    End Sub

    Private Sub LoadFeedback()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT f.FeedbackID, f.OrderID, f.Rating, f.Comment, f.TargetType, f.CreatedAt, " &
                                 "CASE WHEN f.TargetType = 'Rider' THEN (SELECT Name FROM Rider_QB WHERE RiderID = f.TargetID) " &
                                 "     ELSE (SELECT Name FROM Restaurant_QB WHERE RestaurantID = f.TargetID) END AS TargetName, " &
                                 "CASE WHEN f.ReviewerRole = 'Customer' THEN (SELECT FirstName + ' ' + LastName FROM Customer_QB WHERE CustomerID = f.ReviewerID) " &
                                 "     ELSE (SELECT Name FROM Restaurant_QB WHERE RestaurantID = f.ReviewerID) END AS Reviewer, " &
                                 "o.Region " &
                                 "FROM Feedback_QB f JOIN Order_QB o ON f.OrderID = o.OrderID " &
                                 "ORDER BY f.CreatedAt DESC"
            
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvFeedback.DataSource = dt
                gvFeedback.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadCustomerSegmentation()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT c.CustomerID, c.FirstName + ' ' + c.LastName AS CustomerName, c.Email, c.PhoneNumber, c.Region, c.CreatedAt, " &
                                 "COUNT(o.OrderID) AS TotalOrders, " &
                                 "ISNULL(SUM(p.Amount), 0) AS TotalSpent, " &
                                 "CASE " &
                                 "  WHEN SUM(p.Amount) > 5000 OR COUNT(o.OrderID) > 10 THEN 'Premium' " &
                                 "  ELSE 'Regular' " &
                                 "END AS Segment " &
                                 "FROM Customer_QB c " &
                                 "LEFT JOIN Order_QB o ON c.CustomerID = o.CustomerID " &
                                 "LEFT JOIN Payment_QB p ON o.OrderID = p.OrderID AND p.Status = 'Paid' " &
                                 "GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email, c.PhoneNumber, c.Region, c.CreatedAt"
            
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
            Dim query As String = "SELECT r.RestaurantID, r.Name, r.Street, r.ContactNumber, r.Region, r.Segment, r.IsActive, r.LastRevenueReset, " &
                                 "(SELECT COUNT(DISTINCT CustomerID) FROM Order_QB WHERE RestaurantID = r.RestaurantID) AS CustomerCount, " &
                                 "(SELECT COUNT(*) FROM Order_QB WHERE RestaurantID = r.RestaurantID AND OrderDate >= r.LastRevenueReset) AS OrderCount, " &
                                 "ISNULL((SELECT SUM(p.Amount) FROM Order_QB o JOIN Payment_QB p ON o.OrderID = p.OrderID " &
                                 "        WHERE o.RestaurantID = r.RestaurantID AND o.OrderDate >= r.LastRevenueReset AND p.Status = 'Paid'), 0) AS Revenue, " &
                                 "ISNULL((SELECT AVG(CAST(Rating AS DECIMAL(3,2))) FROM Feedback_QB WHERE TargetID = r.RestaurantID AND TargetType = 'Restaurant'), 0) AS AvgRating " &
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
            Dim query As String = "SELECT RiderID, Name, ContactNumber, Region, Availability, IsActive, Segment, LastRevenueReset, " &
                                 "(SELECT COUNT(*) FROM Order_QB WHERE RiderID = Rider_QB.RiderID AND Status = 'Confirmed' AND OrderDate >= Rider_QB.LastRevenueReset) AS Deliveries, " &
                                 "ISNULL((SELECT SUM(50) FROM Order_QB WHERE RiderID = Rider_QB.RiderID AND Status = 'Confirmed' AND OrderDate >= Rider_QB.LastRevenueReset), 0) AS Revenue, " &
                                 "ISNULL((SELECT AVG(CAST(Rating AS DECIMAL(3,2))) FROM Feedback_QB WHERE TargetID = Rider_QB.RiderID AND TargetType = 'Rider'), 0) AS AvgRating " &
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

    Private Sub LoadPlatformManagers()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT ManagerID, FullName, Department, Segment FROM PlatformManager_QB"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvPlatformManagers.DataSource = dt
                gvPlatformManagers.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadUserLogins()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT UserID, Email, Role, ReferenceID, Region FROM Users_QB"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvUserLogins.DataSource = dt
                gvUserLogins.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadRecentOrders()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName, r.Name AS RestaurantName, " &
                                  "ISNULL(ri.Name, 'Unassigned') AS RiderName, o.OrderDate, o.Status, o.Region " &
                                  "FROM Order_QB o " &
                                  "JOIN Customer_QB c ON o.CustomerID = c.CustomerID " &
                                  "JOIN Restaurant_QB r ON o.RestaurantID = r.RestaurantID " &
                                  "LEFT JOIN Rider_QB ri ON o.RiderID = ri.RiderID " &
                                  "ORDER BY o.OrderDate DESC"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvRecentOrders.DataSource = dt
                gvRecentOrders.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadRecentPayments()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT PaymentID, OrderID, Method, Amount, PaymentDate, Status FROM Payment_QB ORDER BY PaymentDate DESC"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvRecentPayments.DataSource = dt
                gvRecentPayments.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadCustomerAuditLog()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT LogID, CustomerID, Email, DeletedAt FROM CustomerAuditLog_QB ORDER BY DeletedAt DESC"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvCustomerAuditLog.DataSource = dt
                gvCustomerAuditLog.DataBind()
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
                Dim q1 As String = "INSERT INTO Restaurant_QB (Name, Street, Region, ContactNumber, IsActive) OUTPUT INSERTED.RestaurantID VALUES (@Name, @Street, @Region, @ContactNumber, 1)"
                Dim restId As Integer
                Using cmd As New SqlCommand(q1, conn, trans)
                    cmd.Parameters.AddWithValue("@Name", txtNewRestName.Text)
                    cmd.Parameters.AddWithValue("@Street", txtNewRestAddress.Text)
                    cmd.Parameters.AddWithValue("@Region", ddlNewRestRegion.SelectedValue)
                    cmd.Parameters.AddWithValue("@ContactNumber", txtNewRestPhone.Text)
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
        Dim restId As Integer = Convert.ToInt32(e.CommandArgument)
        If e.CommandName = "ToggleStatus" Then
            ExecuteNonQuery("UPDATE Restaurant_QB SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE RestaurantID = @ID", restId)
        ElseIf e.CommandName = "ResetRevenue" Then
            ExecuteNonQuery("UPDATE Restaurant_QB SET LastRevenueReset = GETDATE() WHERE RestaurantID = @ID", restId)
        End If
        RefreshAllData()
    End Sub

    Protected Sub gvRiders_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        Dim riderId As Integer = Convert.ToInt32(e.CommandArgument)
        If e.CommandName = "ToggleStatus" Then
            ExecuteNonQuery("UPDATE Rider_QB SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE RiderID = @ID", riderId)
        ElseIf e.CommandName = "ResetRevenue" Then
            ExecuteNonQuery("UPDATE Rider_QB SET LastRevenueReset = GETDATE() WHERE RiderID = @ID", riderId)
        End If
        RefreshAllData()
    End Sub

    Protected Sub gvCustomerSegments_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "DeleteCustomer" Then
            Dim customerId As Integer = Convert.ToInt32(e.CommandArgument)
            DeleteCustomerAndDependencies(customerId)
            RefreshAllData()
        End If
    End Sub

    Private Sub DeleteCustomerAndDependencies(ByVal customerId As Integer)
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim trans As SqlTransaction = conn.BeginTransaction()
            Try
                ' Get customer email to delete from Users_QB
                Dim email As String = ""
                Using cmd As New SqlCommand("SELECT Email FROM Customer_QB WHERE CustomerID = @ID", conn, trans)
                    cmd.Parameters.AddWithValue("@ID", customerId)
                    Dim res = cmd.ExecuteScalar()
                    If res IsNot Nothing Then email = res.ToString()
                End Using

                ' 1. Delete feedback left by this customer
                Using cmd As New SqlCommand("DELETE FROM Feedback_QB WHERE ReviewerID = @ID AND ReviewerRole = 'Customer'", conn, trans)
                    cmd.Parameters.AddWithValue("@ID", customerId)
                    cmd.ExecuteNonQuery()
                End Using

                ' 2. Delete feedback left for orders belonging to this customer
                Using cmd As New SqlCommand("DELETE FROM Feedback_QB WHERE OrderID IN (SELECT OrderID FROM Order_QB WHERE CustomerID = @ID)", conn, trans)
                    cmd.Parameters.AddWithValue("@ID", customerId)
                    cmd.ExecuteNonQuery()
                End Using

                ' 3. Delete payments of customer's orders
                Using cmd As New SqlCommand("DELETE FROM Payment_QB WHERE OrderID IN (SELECT OrderID FROM Order_QB WHERE CustomerID = @ID)", conn, trans)
                    cmd.Parameters.AddWithValue("@ID", customerId)
                    cmd.ExecuteNonQuery()
                End Using

                ' 4. Delete order items of customer's orders
                Using cmd As New SqlCommand("DELETE FROM OrderItem_QB WHERE OrderID IN (SELECT OrderID FROM Order_QB WHERE CustomerID = @ID)", conn, trans)
                    cmd.Parameters.AddWithValue("@ID", customerId)
                    cmd.ExecuteNonQuery()
                End Using

                ' 5. Delete customer's orders
                Using cmd As New SqlCommand("DELETE FROM Order_QB WHERE CustomerID = @ID", conn, trans)
                    cmd.Parameters.AddWithValue("@ID", customerId)
                    cmd.ExecuteNonQuery()
                End Using

                ' 6. Delete from Customer_QB (this will invoke trg_LogCustomerDeletion trigger!)
                Using cmd As New SqlCommand("DELETE FROM Customer_QB WHERE CustomerID = @ID", conn, trans)
                    cmd.Parameters.AddWithValue("@ID", customerId)
                    cmd.ExecuteNonQuery()
                End Using

                ' 7. Delete login credentials from Users_QB
                If email <> "" Then
                    Using cmd As New SqlCommand("DELETE FROM Users_QB WHERE Email = @Email", conn, trans)
                        cmd.Parameters.AddWithValue("@Email", email)
                        cmd.ExecuteNonQuery()
                    End Using
                End If

                trans.Commit()
                lblAdminMessage.Text = "Customer and associated records deleted! Deletion logged in Audit Trail."
                lblAdminMessage.ForeColor = Drawing.Color.Red
                lblAdminMessage.Visible = True
            Catch ex As Exception
                trans.Rollback()
                lblAdminMessage.Text = "Error deleting customer: " & ex.Message
                lblAdminMessage.ForeColor = Drawing.Color.Red
                lblAdminMessage.Visible = True
            End Try
        End Using
    End Sub

    Private Sub ExecuteNonQuery(ByVal query As String, ByVal id As Integer)
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ID", id)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Protected Function GetSegmentClass(ByVal segment As Object) As String
        Dim seg As String = If(segment IsNot Nothing, segment.ToString(), "")
        Select Case seg
            Case "Premium", "Top Performance", "Elite Rider", "SuperAdmin"
                Return "segment-premium"
            Case Else
                Return "segment-regular"
        End Select
    End Function

    Protected Function GetRatingClass(ByVal rating As Object) As String
        If rating Is Nothing Then Return "badge badge-low"
        Dim r As Integer = Convert.ToInt32(rating)
        If r >= 4 Then Return "badge badge-high"
        Return "badge badge-low"
    End Function

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
