package ApiCommonWorkflow::Main::WorkflowSteps::FindOrthomclPairs;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;
use OrthoMCLEngine::Main::Base;


sub run {
  my ($self, $test, $undo) = @_;

  # note: orthomclPairs supports restart.  to enable that we'd need to change it to look for its
  # restart tag in its config file.   and maybe it would put out an error message suggesting that option.

  my $workflowDataDir = $self->getWorkflowDataDir();
  my $suffix = $self->getParamValue('suffix');


  my $configFile = "$workflowDataDir/orthomclPairs.config";
  my $logfile = "$workflowDataDir/orthomclPairs.log";

  my $suf = $suffix? "suffix=$suffix" : "";

  my $cmd = "orthomclPairs $configFile $logfile cleanup=no $suf";

  if ($undo) {
    $self->runCmd($test, "orthomclPairs $configFile $logfile cleanup=all suffix=$suffix");
  } else {
      if ($test) {
	  $self->runCmd(0,"echo test > $logfile");
      }

      $self->runCmd($test,$cmd);
  }
}
