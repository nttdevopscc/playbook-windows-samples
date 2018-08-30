param(
    [parameter(Position=1,Mandatory=$true,ValueFromPipeline=$false)][string]$UserName,
    [parameter(Position=2,Mandatory=$true,ValueFromPipeline=$false)][string]$Password,
    [parameter(Position=3,Mandatory=$true,ValueFromPipeline=$false)][string]$Sender,
    [parameter(Position=4,Mandatory=$true,ValueFromPipeline=$false)][string]$Recipient,
    [parameter(Position=5,Mandatory=$true,ValueFromPipeline=$false)][string]$SmtpServer,
    [parameter(Position=6,Mandatory=$true,ValueFromPipeline=$false)][integer]$SmtpServerPort
)

function SendMail () {

    param($UserName, $Password, $Sender, $Recipient, $SmtpServer, $SmtpServerPort)
    $mail = New-Object System.Net.Mail.MailMessage($Sender, $Recipient)
    $mail.Subject = "‚ ‚¢‚¤‚¦‚¨"
    $mail.Body = @"
  * ‚ ‚¢‚¤‚¦‚¨ *
  Username: $Username
  Password: $Password
"@

    $mail.SubjectEncoding = [System.Text.Encoding]::GetEncoding("iso-2022-jp")
    $mail.BodyEncoding = [System.Text.Encoding]::GetEncoding("iso-2022-jp")
    $smtp = New-Object System.Net.Mail.SmtpClient($SmtpServer,$SmtpServerPort)
    $smtp.Send($mail)

}

SendMail $UserName $Password $Sender $Recipient $SmtpServer $SmtpServerPort 
