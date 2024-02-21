package ApiCommonWorkflow::Main::WorkflowSteps::LoadNcbiTaxonId;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $organismFullName = $self->getParamValue('organismFullName');
  my $ncbiTaxonId = $self->getParamValue('ncbiTaxonId');
  my $speciesNcbiTaxonId = $self->getParamValue('speciesNcbiTaxonId');
  my $rank = $self->getParamValue('rank');

  my $parentNcbiTaxId;
  if($speciesNcbiTaxonId) {
    $parentNcbiTaxId = "--parentNcbiTaxId $speciesNcbiTaxonId";
  }

  my $args = "--ncbiTaxId $ncbiTaxonId --rank '${rank}' $parentNcbiTaxId --name '$organismFullName' --mode insert";

  $self->runPlugin($test, $undo, "GUS::Supported::Plugin::InsertTaxonAndTaxonName", $args);

}


1;
