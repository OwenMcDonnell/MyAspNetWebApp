write-host $env:test_var
$apiUrl = 'https://ci.appveyor.com/api'
$token = $env:apiToken
$headers = @{
  "Authorization" = "Bearer $token"
  "Content-type" = "application/json"
}
$accountName = 'owenmcdonnell'
$projectSlug = 'myaspnetwebapp'

$downloadLocation = 'C:\projects'

# get project with last build details
#$project = Invoke-RestMethod -Method Get -Uri "$apiUrl/projects/$accountName/$projectSlug" -Headers $headers

# we assume here that build has a single job
# get this job id
#$jobId = $project.build.jobs[0].jobId
write-host $env:build_job_id
$jobId = $env:APPVEYOR_JOB_ID 
write-host $jobId

# get job artifacts (just to see what we've got)
$artifacts = Invoke-RestMethod -Method Get -Uri "$apiUrl/buildjobs/$jobId/artifacts" -Headers $headers

# here we just take the first artifact, but you could specify its file name
# $artifactFileName = 'MyWebApp.zip'
$artifactFileName = 'vars.json'

# artifact will be downloaded as
$localArtifactPath = "$downloadLocation\$artifactFileName"

# download artifact
# -OutFile - is local file name where artifact will be downloaded into
# the Headers in this call should only contain the bearer token, and no Content-type, otherwise it will fail!
Invoke-RestMethod -Method Get -Uri "$apiUrl/buildjobs/$jobId/artifacts/$artifactFileName" `
-OutFile $localArtifactPath -Headers @{ "Authorization" = "Bearer $token" }




$vars = Get-Content ./vars.json | ConvertFrom-Json
$env:var1 = $vars.var1
$env:var2 = $vars.var2
