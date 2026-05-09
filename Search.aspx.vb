Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class Search
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadAllItems()
        End If
    End Sub

    Private Sub LoadAllItems()
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT m.Name AS ItemName, r.Name AS RestaurantName, m.Price, m.Description FROM MenuItem m INNER JOIN Restaurant r ON m.RestaurantID = r.RestaurantID WHERE m.Available = 1"
            Using cmd As New SqlCommand(query, conn)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvResults.DataSource = dt
                gvResults.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim searchStr As String = txtSearch.Text.Trim()
        
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT m.Name AS ItemName, r.Name AS RestaurantName, m.Price, m.Description FROM MenuItem m INNER JOIN Restaurant r ON m.RestaurantID = r.RestaurantID WHERE m.Available = 1 AND (m.Name LIKE @Search OR r.Name LIKE @Search)"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Search", "%" & searchStr & "%")
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvResults.DataSource = dt
                gvResults.DataBind()
                
                If dt.Rows.Count = 0 Then
                    lblMessage.Text = "No items found for your search."
                    lblMessage.Visible = True
                Else
                    lblMessage.Visible = False
                End If
            End Using
        End Using
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
