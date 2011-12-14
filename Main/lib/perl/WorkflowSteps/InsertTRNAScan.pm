package ApiCommonWorkflow::Main::WorkflowSteps::InsertTRNAScan;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  # get parameters
  my $inputFile = $self->getParamValue('inputFile');

  my $genomeExtDbRlsSpec = $self->getParamValue('genomeExtDbRlsSpec');

  my $tRNAExtDbRlsSpec = $self->getParamValue('tRNAExtDbRlsSpec');

  my $soVersion = $self->getExtDbVersion($test, 'SO_RSRC');

  my $workflowDataDir = $self->getWorkflowDataDir();

  my ($genomeExtDbName,$genomeExtDbVersion)=$self->getExtDbInfo($test,$genomeExtDbRlsSpec);

  my ($tRNAExtDbName,$tRNAExtDbVersion)=$self->getExtDbInfo($test,$tRNAExtDbRlsSpec);

  my $args = "--data_file $workflowDataDir/$inputFile --scanDbName '$tRNAExtDbName' --scanDbVer '$tRNAExtDbVersion' --genomeDbName '$genomeExtDbName' --genomeDbVer '$genomeExtDbVersion' --soVersion '$soVersion'";
    if ($test) {
      $self->testInputFile('inputFile', "$workflowDataDir/$inputFile");
    }

   $self->runPlugin($test, $undo, "ApiCommonData::Load::Plugin::LoadTRNAScan", $args);


}

sub getConfigDeclaration {
  return (
         # [name, default, description]
         # ['', '', ''],
         );
}

