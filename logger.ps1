
enum LogLevels {

    INFO
    WARN
    ERROR
    FATAL


}

class Logger {
    
    [string] $log_path = $env:USERPROFILE + '\Documents\'
    [string] $log_name = ""
    [string] $run_log
    [datetime] $start_time = (Get-Date)

    Logger() {
        $this.Start()
    }

    Logger([string]$log_name){
        $this.log_name = $log_name
        $this.Start()
    }

    Logger([string]$log_name, [string]$log_path){
        $this.log_name = $log_name
        $this.log_path = $log_path
        $this.Start()
    }

    [void]Start() {

        if (-not (Test-Path $this.log_path)) { New-Item -ItemType "directory" -Path $this.log_path}

        $this.run_log = ($this.log_path + $this.start_time.ToString("MMM_yyyy") + '_' + $this.log_name + '.log')

        $logging_text = @()
        $logging_text += '-'
        $logging_text += '******************************************************************************************'
        $logging_text += 'New Session Started @ ' + $this.start_time.ToString()
        $logging_text += 'Current User: ' + ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
        $logging_text += '-'

        $logging_text | Out-File -FilePath $this.run_log -Append -Encoding utf8
    }

    [void]Log([string]$message){

        (Get-Date).ToString() + "    -    " + $message | Out-File -FilePath $this.run_log -Append -Encoding utf8
    }

    [void]Log([array]$table){

        & { foreach ($entry in $table){

            (Get-Date).ToString() + '    -    ' + $entry

        }} | Out-File -FilePath $this.run_log -Append -Encoding utf8
    }

    [void]Finish(){

        $logging_text = @()

        $logging_text += '-'
        $logging_text += 'Session Completed @ ' + (Get-Date).ToString()
        $logging_text += 'Runtime Length: ' + (New-TimeSpan -Start $this.start_time -End (Get-Date)).ToString()
        $logging_text += '******************************************************************************************'
        $logging_text += '-'
       
        $logging_text | Out-File -FilePath $this.run_log -Append -Encoding utf8
    }
}

$log_tool = New-Object Logger
$log_tool.Log("This is a Test")
$log_tool.Finish()

