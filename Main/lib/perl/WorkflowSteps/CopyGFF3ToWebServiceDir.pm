package ApiCommonWorkflow::Main::WorkflowSteps::CopyGFF3ToWebServiceDir;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use ApiCommonWorkflow::Main::Util::OrganismInfo;

sub run {
  my ($self, $test, $undo) = @_;

  # get parameters
  my $gff3File = $self->getParamValue('gff3File');
  my $organismAbbrev = $self->getParamValue('organismAbbrev');
  my $relativeDir = $self->getParamValue('relativeDir');

  my $experimentDatasetName = $self->getParamValue('experimentDatasetName');

  my $websiteFilesDir = $self->getWebsiteFilesDir($test);
  my $gusConfigFile = $self->getParamValue('gusConfigFile');
  $gusConfigFile = $self->getWorkflowDataDir() . "/$gusConfigFile";

  my $organismNameForFiles =
      $self->getOrganismInfo($test, $organismAbbrev, $gusConfigFile)->getNameForFiles();

  my $copyToDir = "$websiteFilesDir/$relativeDir/$organismNameForFiles/gff/$experimentDatasetName";

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $cmd_mkdir = "mkdir -p $copyToDir";

  my $cmd_copy = "cp $workflowDataDir/$gff3File $copyToDir"; 



  $self->testInputFile('gff3File', "$workflowDataDir/$gff3File");

  if ($undo) {
    $self->runCmd(0, "rm -fr $copyToDir");
  } else {
    $self->runCmd($test, $cmd_mkdir);
    $self->runCmd($test, $cmd_copy);
    $self->runCmd($test, "cp $workflowDataDir/$gff3File.tbi $copyToDir") unless($self->getParamValue('copyGFFOnly') =~ /true/i);
  }

}

1;


