workflow Get-PSModulePath
{
    InlineScript
    {
        [System.Environment]::GetEnvironmentVariable("PSModulePath")
    }
}