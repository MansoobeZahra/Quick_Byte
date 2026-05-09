Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class AdminDashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.Identity.IsAuthenticated OrElse Session("Role") <> "Admin" Then
            Response.Redirect("Default.aspx")
        End If

        If Not IsPostBack Then
            LoadCustomerSegmentation()
            LoadRestaurantPerformance()
            LoadRiderActivity()
        End If
    End Sub

    Private Sub LoadCustomerSegmentation()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            ' Query to calculate stats and segment customers
            Dim query As String = "SELECT c.FirstName + ' ' + c.LastName AS CustomerName, " &
                                 "COUNT(o.OrderID) AS TotalOrders, " &
                                 "ISNULL(SUM(mi.Price * oi.Quantity), 0) AS TotalSpent, " &
                                 "AVG(CAST(item_counts.total_items AS FLOAT)) AS AvgItemsPerOrder, " &
                                 "CASE " &
                                 "  WHEN SUM(mi.Price * oi.Quantity) > 5000 OR COUNT(o.OrderID) > 10 THEN 'Premium' " &
                                 "  WHEN AVG(CAST(item_counts.total_items AS FLOAT)) > 5 THEN 'Bulk Buyer' " &
                                 "  ELSE 'Regular' " &
                                 "END AS Segment " &
                                 "FROM Customer_QB c " &
                                 "LEFT JOIN Order_QB o ON c.CustomerID = o.CustomerID " &
                                 "LEFT JOIN OrderItem_QB oi ON o.OrderID = oi.OrderID " &
                                 "LEFT JOIN MenuItem_QB mi ON oi.ItemID = mi.ItemID " &
                                 "LEFT JOIN (SELECT OrderID, SUM(Quantity) as total_items FROM OrderItem_QB GROUP BY OrderID) item_counts ON o.OrderID = item_counts.OrderID " &
                                 "GROUP BY c.CustomerID, c.FirstName, c.LastName"
            
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
            Dim query As String = "SELECT r.Name, COUNT(o.OrderID) AS OrderCount, ISNULL(SUM(mi.Price * oi.Quantity), 0) AS Revenue " &
                                 "FROM Restaurant_QB r " &
                                 "LEFT JOIN Order_QB o ON r.RestaurantID = o.RestaurantID " &
                                 "LEFT JOIN OrderItem_QB oi ON o.OrderID = oi.OrderID " &
                                 "LEFT JOIN MenuItem_QB mi ON oi.ItemID = mi.ItemID " &
                                 "GROUP BY r.RestaurantID, r.Name"
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
            Dim query As String = "SELECT Name, Availability, (SELECT COUNT(*) FROM Order_QB WHERE RiderID = Rider.RiderID AND Status = 'Delivered') AS Deliveries FROM Rider_QB"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvRiders.DataSource = dt
                gvRiders.DataBind()
            End Using
        End Using
    End Sub

    Protected Function GetSegmentClass(ByVal segment As Object) As String
        Select Case segment.ToString()
            Case "Premium"
                Return "segment-premium"
            Case "Bulk Buyer"
                Return "segment-bulk"
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
