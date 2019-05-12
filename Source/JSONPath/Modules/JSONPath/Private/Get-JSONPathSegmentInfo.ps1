function Get-JSONPathSegmentInfo
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [String]$Segment
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}

        # TODO: Make sure we capture the exact string. Somehow ^($SegmentBreakDownRegEx)$ isn't working
        $SegmentBreakDownRegEx = "(?<name>[a-zA-Z_][a-zA-Z0-9_]*)(\[(?<index>[0-9]+)\])?"
        Write-Debug "segmentBreakDownRegEx=$SegmentBreakDownRegEx"
    }

    process
    {
        if (Get-Variable -Name Matches -ErrorAction SilentlyContinue) {
            $Matches.Clear()
        }
        # Match the segment with a regex and extract the property name and index when array
        if ($Segment -notmatch $SegmentBreakDownRegEx) {
            throw "Invalid segment $Segment"
        }
        $SegmentPropertyName = $Matches.name
        $isIndexDeclared = $Matches.Contains("index")
        $index=$null
        if ($isIndexDeclared) {
            $index = [int]$Matches.index

            # TODO: Remove when regex is better
            if (-not ($Segment.StartsWith($SegmentPropertyName) -and $Segment.EndsWith("]"))) {
                throw "Invalid segment $Segment"
            }
        }
        else {
            # TODO: Remove when regex is better
            if ($Segment -ne $SegmentPropertyName) {
                throw "Invalid segment $Segment"
            }
        }       
        Write-Debug "[$Segment] segmentPropertyName=$SegmentPropertyName | isIndexDeclared=$isIndexDeclared | index=$index"

        $infoHash=@{
            Segment=$Segment
            PropertyName=$SegmentPropertyName
            IsIndexDeclared=$isIndexDeclared
            Index=$index
        }

        New-Object -TypeName psobject -Property $infoHash
    }

    end
    {

    }
}