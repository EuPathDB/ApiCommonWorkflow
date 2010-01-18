package ApiCommonWorkflow::Main::WorkflowSteps::InsertAnalysisMethod;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $name = $self->getParamValue('name');
  my $version = $self->getParamValue('version');
  my $input = $self->getParamValue('input');
  my $output = $self->getParamValue('output');
  my $parameters = $self->getParamValue('parameters');
  my $description = $self->getParamValue('description');
  my $pubmedId = $self->getParamValue('pubmedId');
  my $citationString = $self->getParamValue('citation');
  my $url = $self->getParamValue('url');
  my $credits = $self->getParamValue('credits');


  my $args = "--name '$name' --version '$version' --input '$input' --output '$output' --parameters '$parameters' --description '$description' --pubmedId '$pubmedId' --citation '$citation' --url '$url' --credits '$credits' ";

  $self->runPlugin($test, $undo, "ApiCommonData::Load::Plugin::InsertAnalysisMethod",$args);

}

sub getParamsDeclaration {
    return (
	'name',
	'version',
	'input',
	'output',
	'parameters',
	'description',
	'pubmedId',
	'citationString',
	'url',
	'credits'
	);
}

sub getConfigDeclaration {
  return (
	 );
}


