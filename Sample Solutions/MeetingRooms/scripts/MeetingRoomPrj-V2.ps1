# Application (client) ID, tenant Name and secret
$ClientId = ""
$TenantName = ""
$ClientSecret = ""
$resource = "https://graph.microsoft.com/"



function Auth365() {
    $ReqTokenBody = @{
        Grant_Type    = "client_credentials"
        Scope         = "https://graph.microsoft.com/.default"
        client_Id     = $ClientID
        Client_Secret = $ClientSecret
    } 
    
    return Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody

    
}

function ReadCalendar($token) {
    #loop all users
    #Get all users
    $token = $TokenResponse
    $apiUrl = "https://graph.microsoft.com/v1.0/places/microsoft.graph.room?$select=id,displayName,emailAddress,address,building,floorNumber"
    $Places = $null
    $Data= Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $apiUrl -Method Get
    $Places = ($Data | Select-Object Value).Value 
  

    Write-output "Upn,Id,Start,End,IsOnlineMeeting,AttendeesCount,Subject,Location" | Out-File "C:\Users\fahadda\Desktop\Places_Events.csv" -Append
    Write-output "Upn,Id,DisplayName,Address_CountryOrRegion,Address_State,Address_City,Building,FloorNumber" | Out-File "C:\Users\fahadda\Desktop\Places.csv" -Append

    foreach ($p in $Places) {
        #All events for the user
        $upn = $p.emailAddress
        $id = $p.id
        $displayName = $p.displayName
        $countryOrRegion = $p.address.countryOrRegion
        $state = $p.address.state
        $city = $p.address.city
        $building = $p.building
        $floorNumber = $p.floorNumber
        # $api = "https://graph.microsoft.com/v1.0/users/$upn/events?filter=start/dateTime ge '2022-01-01T06:00:00.000' and start/dateTime lt '2022-04-01T17:00:00.000'"
        $api = "https://graph.microsoft.com/v1.0/users/$upn/events?top=500"
        
        # Write-Host $upn,$id,$countryOrRegion,$state,$city,$building,$floorNumber
        Write-output "$upn,$id,$displayName,$countryOrRegion,$state,$city,$building,$floorNumber" | Out-File "C:\Users\fahadda\Desktop\Places.csv" -Append
        $upn
        Write-Host $api #-Force Green
        $events = $null
        $events = Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $api -Method Get
        do {
                foreach ($r in $events.value) {
                    $id = $r.id
                    $subject = $r.subject
                    $start = [dateTime]$r.start.dateTime
                    $end = [dateTime]$r.end.dateTime
                    $isOnline = $r.isOnlineMeeting
                    $attendeesCount = $r.attendees.count
                    $organizer = $r.organizer.emailAddress.address #name
                    $HideAttendeesCount = $r.hideAttendees
                    # Write-Host "upn,Start,End,Id,AttendeesCount,Subject,Location" -Force Yellow
                    # Write-Host "$upn,$start,$end,$id,$attendeesCount,$subject,$Location" -Force Yellow
                    Write-output "$upn,$id,$start,$end,$isOnline,$attendeesCount,$subject,$Location" | Out-File "C:\Users\fahadda\Desktop\Places_Events.csv" -Append
                    # $id,$start,$end, $attendeesCount,$subject
                }
                if ($events.'@Odata.NextLink'){
                    $events = Invoke-RestMethod -Headers @{Authorization = "Bearer $($token.access_token)"} -Uri $events.'@Odata.NextLink' -Method Get
                }
            } while ($events.'@Odata.NextLink')
        

    }

    
}

function main() {
    $TokenResponse = Auth365
    $TokenResponse
    ReadCalendar $TokenResponse
    
}

main
