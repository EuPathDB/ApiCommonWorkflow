 package ApiCommonWorkflow::Main::WorkflowSteps::CopyLongReadRnaBamToWebSvc;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use warnings;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use ApiCommonWorkflow::Main::Util::OrganismInfo;

sub run {
    my ($self, $test, $undo) = @_;

    my $copyFromDir = $self->getParamValue('copyFromDir');
    my $organismAbbrev = $self->getParamValue('organismAbbrev');
    my $relativeDir = $self->getParamValue('relativeDir');
    my $experimentResourceName = $self->getParamValue('experimentDatasetName');
    my $websiteFilesDir = $self->getWebsiteFilesDir($test);
    my $organismNameForFiles = $self->getOrganismInfo($test, $organismAbbrev)->getNameForFiles();
    my $workflowDataDir = $self->getWorkflowDataDir();
    my $configFile = $self->getParamValue('analysisConfig');

   # my $configFile = "/Users/saikouybah/Documents/PerlModules/analysisConfig.xml";
    open(my $samplesList, $configFile) or die "Could not open file '$configFile' $!";

    my %SampleHash;
    while (my $row = <$samplesList>) {
    	chomp $row;
    	if ($row =~"<value>" ){
    	    my $line = $row;
    	    $line  =~ s/ .*<value>//g;
    	    $line  =~ s/<\/value>//g;
    	    my @samples_list = split('\|', $line);
    	    my $sample_name = $samples_list[0] =~ s/ /_/gr;
    	    my $internal_name = $samples_list[1];

 	    $SampleHash{$internal_name} = $sample_name;

    }
}

    my $copyToDir = "$websiteFilesDir/$relativeDir/$organismNameForFiles/bam/$experimentResourceName/";
    my $cmd_mkdir = "mkdir -p $copyToDir";

    #my $cmd_copy = "cp $workflowDataDir/$copyFromDir/*bam* $copyToDir";
    
    $self->testInputFile('copyFromDir', "$workflowDataDir/$copyFromDir");

    if ($undo) {
        $self->runCmd(0,"rm -rf $copyToDir");
    }else{
        $self->runCmd($test, $cmd_mkdir);
	
	foreach my $key (keys %SampleHash){
	    my $name = $SampleHash{$key};
	    my $cmd_copy = "cp $workflowDataDir/$copyFromDir/$key.bam $copyToDir/$name.bam";
	    $self->runCmd($test, $cmd_copy);
           } 
	#
        #$self->runCmd($test, $cmd_copy);
    }
}

1;
