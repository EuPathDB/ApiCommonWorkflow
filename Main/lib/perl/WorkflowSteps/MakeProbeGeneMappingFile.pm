package ApiCommonWorkflow::Main::WorkflowSteps::MakeProbeGeneMappingFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $outputFile = $self->getParamValue('outputFile');
  my $aefExtDbSpec = $self->getParamValue('aefExtDbSpec');
  my $geneExtDbSpec = $self->getParamValue('geneExtDbSpec');
  my $aefSense = ($self->getParamValue('isOneChannel') eq 'true') ? 'sense':'either';
  my $delimiter = ($self->getParamValue('isOneChannel') eq 'true') ? '\\t':',';
  my $workflowDataDir = $self->getWorkflowDataDir();

  my $cmd = "mapArrayElementsToGenes.pl --aefExtDbSpec '$aefExtDbSpec' --geneExtDbSpec  '$geneExtDbSpec' --aefSense '$aefSense' --outputFile $workflowDataDir/$outputFile --delimiter '$delimiter'";


  if ($undo) {
    $self->runCmd(0, "rm -f $workflowDataDir/$outputFile");
  } else {
      if ($test) {
      }else{
	  $self->runCmd($test,$cmd);
      }
  }
}

sub getParamDeclaration {
  return (
	  'outputFile',
	  'aefExtDbSpec',
	  'geneExtDbSpec',
	  'aefSense',
	 );
}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	 );
}

