package ApiCommonWorkflow::Main::WorkflowSteps::CreateIsolateAssayGFF;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $inputFile = $self->getParamValue("inputFile");
  my $outputFile = $self->getParamValue("outputFile");
  my $isolateType = $self->getParamValue("isolateType");

  my $args = "--inputFile '$workflowDataDir/$inputFile' --outputFile '$workflowDataDir/$outputFile' --isolateType '$isolateType'";

  my $cmd = "convertIsolateAssay2GFF $args";

  if ($undo) {
    $self->runCmd(0, "rm $workflowDataDir/$outputFile");
  } else {
    if ($test) {
      $self->runCmd(0,"echo test > $workflowDataDir/$outputFile");
    }
    $self->runCmd($test, $cmd);
  }
}


1;