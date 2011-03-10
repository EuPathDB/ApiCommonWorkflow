package ApiCommonWorkflow::Main::WorkflowSteps::GenerateCountFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use File::Basename;


sub run {
  my ($self, $test, $undo) = @_;

  my $uniqueFile = $self->getParamValue('uniqueFile');

  my $nonUniqueFile = $self->getParamValue('nonUniqueFile');

  my $geneAnnotationFile =  $self->getParamValue('geneAnnotationFile');

  my $outputFile =  $self->getParamValue('outputFile');

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $cmd = "rum2quantifications.pl '$workflowDataDir/$geneAnnotationFile' '$workflowDataDir/$uniqueFile' '$workflowDataDir/$nonUniqueFile' '$workflowDataDir/$outputFile' -countsonly";
    
  if ($undo) {
      $self->runCmd(0, "rm -f $workflowDataDir/$outputFile");
  }else {
      if ($test){
	  $self->runCmd(0, "echo test> $workflowDataDir/$outputFile");
      }else{
	  $self->runCmd($test, $cmd);
      }
  }

}

sub getParamDeclaration {
  return (
	  'inputFile',
	  'outputFile',
	 );
}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	 );
}

