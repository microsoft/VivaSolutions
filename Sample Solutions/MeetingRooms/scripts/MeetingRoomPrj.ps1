# Application (client) ID, tenant Name and secret
$ClientId = "a41d1fce-f522-4531-9bbf-994bef0025b4"
$TenantName = "bd382938-3ba0-469f-8b45-fa06740d181f"
$ClientSecret = "eFS8Q~.1WIqVFUkieSGwtIuIiBHLl24yv3sz2de2"
$resource = "https://graph.microsoft.com/"



function Auth365() {
    $ReqTokenBody = @{
        Grant_Type    = "client_credentials"
        Scope         = "https://graph.microsoft.com/.default"
        client_Id     = $ClientID
        Client_Secret = $ClientSecret
    } 
    
    return Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody
    # $TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody
    # return $TokenResponse   
    
}

function ReadCalendar($token) {
    #loop all users
    #Get all users
    $token = $TokenResponse
    $apiUrl = "https://graph.microsoft.com/v1.0/users"
    $Users = $null
    $Data= Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $apiUrl -Method Get
    $Users = ($Data | Select-Object Value).Value 
  

    # $Users | Format-Table displayName, userPrincipalName, id
    Write-output "upn,Start,End,Id,AttendeesCount,Subject,Location" | Out-File "C:\Users\fahadda\Desktop\test-powershell.csv" -Append

    foreach ($u in $Users) {
        #All events for the user
        $upn = $u.userPrincipalName
        # $api = "https://graph.microsoft.com/v1.0/users/$upn/events?$top=10&$filter=start/dateTime=2017-04-21T10:00:00.0000000 & end/dateTime=2022-04-10T20:00.0000000"
        $api = "https://graph.microsoft.com/v1.0/users/$upn/events?$filter=start/dateTime ge '2018-07-09T06:00:00.000' and start/dateTime lt '2018-07-09T17:00:00.000'"
        # $api = "https://graph.microsoft.com/v1.0/users/$upn/events?$top=1"

        if ($upn -notlike "*rooma*") {
            continue
        
        }
        $upn
        $api
        Write-Host $api #-Force Green
        $events = $null
        $events = Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $api -Method Get
        do {
                foreach ($r in $events.value) {
                    # $upn=$r.userPrincipalName
                    $id = $r.id
                    $subject = $r.subject
                    $start = [dateTime]$r.start.dateTime
                    $end = [dateTime]$r.end.dateTime
                    $attendeesCount = $r.attendees.count
                    $Organizer = $r.organizer.emailAddress.address #name
                    $Location = $r.location.displayName
                    # "location": {
                    #     "displayName": "Assembly Hall",
                    #     "locationType": "default",
                    #     "uniqueId": "Assembly Hall",
                    #     "uniqueIdType": "private"
                    # },
                    # "locations": [
                    #     {
                    #         "displayName": "Assembly Hall",
                    #         "locationType": "default",
                    #         "uniqueIdType": "unknown"
                    #     }
                    $HideAttendeesCount = $r.hideAttendees
                    # Write-Host "upn,Start,End,Id,AttendeesCount,Subject,Location" -Force Yellow
                    # Write-Host "$upn,$start,$end,$id,$attendeesCount,$subject,$Location" -Force Yellow
                    Write-output "$upn,$start,$end,$id,$attendeesCount,$subject,$Location" | Out-File "C:\Users\fahadda\Desktop\test-powershell.csv" -Append
                    # $id,$start,$end, $attendeesCount,$subject
                }
                if ($events.'@Odata.NextLink'){
                    $events = Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $api -Method Get
                }
            } while ($events.'@Odata.NextLink')
        

    }

    
}

function main() {
    $TokenResponse = Auth365
    $TokenResponse
    ReadCalendar $TokenResponse
    
}


        # Write-Host $api -Force Green
        # $events = $null
        # $events = Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $api -Method Get
        # # do {
        #     foreach ($r in $events.value) {
        #         $id = $r.id
        #         $subject = $r.subject
        #         $start = [dateTime]$r.start.dateTime
        #         $end = [dateTime]$r.end.dateTime
        #         $attendeesCount = $r.attendees.count

        #         Write-Host "Event: Start=$start  End=$end  Id=#id" -Force Yellow
        #     }
        #     if ($events.'@Odata.NextLink'){
        #         $events = Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $api -Method Get
        #     }
        # } while ($events.'@Odata.NextLink')


# $apiUrl = "https://graph.microsoft.com/v1.0/me/calendar/events"
# $Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($TokenResponse.access_token)"} -Uri $apiUrl -Method Get
# $CalEvents = ($Data | Select-Object Value).Value 

# $CalEvents | Select-Object -Property subject, importance, showAs, @{Name = 'Location'; Expression = {$_.location.displayname}}, @{Name = 'Response'; Expression = {$_.responseStatus.response}}, @{Name = 'Start'; Expression = {$_.start.dateTime.Replace(":00.0000000","").Replace("T"," ") }}, @{Name = 'End'; Expression = {$_.End.dateTime.Replace(":00.0000000","").Replace("T"," ") }} | Format-Table 

