package ApiCommonWorkflow::Main::WorkflowSteps::InsertEpitopeMapping;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $inputFile = $self->getParamValue('inputFile');
  my $epiExtDbName = $self->getParamValue('iedbExtDbName');
  my $seqExtDbSpecs = $self->getParamValue('genomeExtDbRlsSpec');

  my $epiExtDbVersion = $self->getExtDbVersion($test,$epiExtDbName );

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $args =" --inputFile $workflowDataDir/$inputFile --extDbRelSpec '$epiExtDbName|$epiExtDbVersion' --seqExtDbRelSpec '$seqExtDbSpecs'";

    if ($test) {
      $self->testInputFile('inputFile', "$workflowDataDir/$inputFile");
    }

    $self->runPlugin ($test,$undo, "ApiCommonData::Load::Plugin::InsertEpitopeFeature","$args");


}


sub getParamsDeclaration {
  return ('inputFile',
	  'iedbExtDbRlsSpec',
	  'genomeExtDbRlsSpec'
	 );
}


sub getConfigDeclaration {
  return (
	  # [name, default, description]
 	 );
}



