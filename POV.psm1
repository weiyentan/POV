<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.3.131
	 Created on:   	12/26/2016 9:42 PM
	 Created by:   	Wei-Yen Tan
	 Organization: 	
	 Filename:     	POV.psm1
	-------------------------------------------------------------------------
	 Module Name: POV
	===========================================================================
#>

function Invoke-POVTest
{
	#	.EXTERNALHELP POV.psm1-Help.xml
	#		
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1)]
		[psobject]$Inputobject,
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 2)]
		[string]$Testpath,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 3)]
		[pscredential]$Credential,
		[Parameter(Position = 4)]
		[switch]$Passthru,	
		[Parameter(Position = 5)]
		[switch]$Quiet,
		[Parameter(ValueFromPipelineByPropertyName = $true,
				   Position = 6)]
		[string[]]$Exclude
	)
	
	begin { }
	
	Process
	{
		$copyobjectdetails = $inputobject | Get-Member | Where-Object { $_.membertype -eq "Noteproperty" }
		
		$hash = @{ }
		
		$copyobjectdetails | ForEach-Object {
			$name = $_.Name
			$definition = $_.Definition
			$definitionsplit = ($definition -split '=')[1]
			$hash.Add($name, $definitionsplit)
		}
		
		if ($exclude)
		{
			foreach ($item in $exclude)
			{
				$evaluateexclude = $hash.ContainsKey($item)
				if ($evaluateexclude -eq $true)
				{
					$hash.remove($item)
				}
				
			}
			
			
		}
		
		
		$finalhash = @{ 'Path' = $testpath; 'Parameters' = $hash }
		if ($credential)
		{
			$finalhash.parameters.add('credential', $credential)
		}
		
		$param = @{
			'script' = $finalhash
		}
		if ($passthru)
		{
			$param.Add('passthru', $true)
		}
		
		if ($quiet)
		{
			$param.Add('quiet', $true)
		}
		
		Invoke-Pester  @param
	}
	End { }
}

Export-ModuleMember -Function Invoke-POVTest