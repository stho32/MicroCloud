function Get-SQLSResult($query, $parameter = @{}) {
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection

    $sqlServer = $global:MICROCLOUD_SQLServer
    $dbName    = $global:MICROCLOUD_SQLDatabase
    $uid       = $global:MICROCLOUD_SQLUsername
    $password  = $global:MICROCLOUD_SQLPassword

    $SqlConnection.ConnectionString="Server=$sqlServer;Database=$dbName;User ID=$uid; Password=$password;"
    $sqlConnection.Open()

    try
    {
        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        $SqlCmd.CommandText = $query
        $SqlCmd.Connection = $SqlConnection

        foreach ($p in $parameter.GetEnumerator()) {
            $SqlCmd.Parameters.AddWithValue("@" + $p.Name, $p.Value) | Out-Null
        }

        $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
        $SqlAdapter.SelectCommand = $SqlCmd
        $DataSet = New-Object System.Data.DataSet
        $null = $SqlAdapter.Fill($DataSet)    

        $DataSet.Tables[0] | Select-Object * -ExcludeProperty RowError,RowState,Table,ItemArray,HasErrors
    }
    finally
    {
        $SqlConnection.Close()
    }
}
