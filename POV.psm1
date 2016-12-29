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
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1)]
		[psobject]$inputobject,
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 2)]
		[string]$testpath,
		[Parameter(Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 3)]
		[pscredential]$credential,
		[Parameter(Position = 4)]
		[switch]$passthru,
		[Parameter(Position = 5)]
		[switch]$quiet
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
		$path = $path
		$finalhash = @{ 'Path' = $testpath; 'Parameters' = $hash }
		if ($credential)
		{
			$finalhash.parameters.add('credential', $credential)
		}
		
		if ($passthru)
		{
			$finalhash.Add('passthru', $true)
		}
		
		if ($quiet)
		{
			$finalhash.Add('quiet', $true)
		}
		
		Invoke-Pester -Script $finalhash
	}
	End { }
}

Export-ModuleMember -Function Invoke-POVTest