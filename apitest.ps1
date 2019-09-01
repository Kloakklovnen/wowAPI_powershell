<#
.SYNOPSIS
  Get new token for Blizzard API, obviously work in progress

.DESCRIPTION
  This script was originally meant to be an Azure function, and will most likely be in the future. 
  For now it's just a debugging script to make sure the creation and refreshing of tokens is working and geting familiar with the API url and request.
  Also, while there are other scripts/apps doing the same, and being promoted on the Blizzard API forum. I found no Powershell script
  laying around for this purpose, being this easy to get up and running. Eyes of the beholder and shit, I know.

  REQUIRED STFF ::
    1. https://develop.battle.net/ create an account if you don't have it. If an existing account fails when logging in, due to no 2-factor authentication, 
        and the redirect doesn't work; do log in via the regular battlenet front page, and add the authenticator manually.
    2. Ignore the introduction here: https://develop.battle.net/documentation/guides/getting-started and go hit this URL https://develop.battle.net/access/clients/create
        and give your app an name, and a redirect URI. The redirect URI does not have to be valid. Click on the created client and feed the 
        Client ID and Client secret as parameters to this script, and hit the ground running.

.EXAMPLE
    apitest.ps1 -wowid asdasdasd13123sdfknq3io -secret asdasdsdfkl12980u123ilasdælæasdknl

.PARAMETER wowid
   The Client ID obtained from https://develop.battle.net/access/clients/ the client you created at https://develop.battle.net/access/clients/create

.PARAMETER secret
   The Client Secret obtained from https://develop.battle.net/access/clients/ the client you created at https://develop.battle.net/access/clients/create

.NOTES
   AUTHOR: Kloakklovnen, under Beerware license
#>


param (
    [Parameter(Mandatory=$true)][string]$wowid,
    [Parameter(Mandatory=$true)][string]$secret
 )


$GTokenURL = "https://eu.battle.net/oauth/token?grant_type=client_credentials&client_id=$wowid&client_secret=$secret"
$token = ""

$response = Invoke-RestMethod -Uri $GTokenURL -Method Get   

$timeleft = Get-Date
$timeleft = $timeleft.ToUniversalTime().AddSeconds($response.expires_in)
echo $timeleft 
  
echo $response > token.txt # Debøgs

echo $response.access_token 
echo $response.token_type
echo $response.expires_in

$token = $response.access_token

$testuri = "https://eu.api.blizzard.com/wow/character/Trollbane/akhe?locale=en_GB&access_token=$token" # ...
$Aresponse = Invoke-RestMethod -Uri $testuri -Method Get

echo $Aresponse

<#
if($timeleft -lt (Get-Date).AddHours(-1)){
    RefreshToken()
}

#>