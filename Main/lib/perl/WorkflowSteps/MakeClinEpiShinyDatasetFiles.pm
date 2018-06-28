package ApiCommonWorkflow::Main::WorkflowSteps::MakeClinEpiShinyDatasetFiles;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

use Digest::SHA qw(sha1_hex); 

sub run {
  my ($self, $test, $undo) = @_;

  my $outputFileBaseName = $self->getParamValue('outputFileBaseName');

  my $datasetName = $self->getParamValue('datasetName');

  my $tblPrefix = "D" . substr(sha1_hex($datasetName), 0, 10);

  my $shinyHouseholdsSql = "select pa.name as source_id, ha.*
from apidbtuning.${tblPrefix}Households ha
   , apidbtuning.${tblPrefix}Participants pa
   , apidbtuning.${tblPrefix}PANIO io
where ha.PAN_ID = io.INPUT_PAN_ID
and io.OUTPUT_PAN_ID = pa.PAN_ID
";

  my $shinyParticipantsSql = "select pa.name as source_id, pa.*
from apidbtuning.${tblPrefix}Participants pa
";

  my $shinyObservationsSql = "select pa.name as source_id, ea.*
from apidbtuning.${tblPrefix}Observations ea
   , apidbtuning.${tblPrefix}Participants pa
   , apidbtuning.${tblPrefix}PANIO io
where pa.PAN_ID = io.INPUT_PAN_ID
and io.OUTPUT_PAN_ID = ea.PAN_ID
"; 

  my $participantsFile = "$datasetName/${outputFileBaseName}_participants.txt";
  my $householdsFile = "$datasetName/${outputFileBaseName}_households.txt";
  my $observationsFile = "$datasetName/${outputFileBaseName}_obsevations.txt";

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
      $self->runCmd(0, "rm -f $workflowDataDir/$participantsFile");
      $self->runCmd(0, "rm -f $workflowDataDir/$householdsFile");
      $self->runCmd(0, "rm -f $workflowDataDir/$observationsFile");
  } else {
      if ($test) {
	    $self->runCmd(0,"echo test > $workflowDataDir/$participantsFile");
	    $self->runCmd(0,"echo test > $workflowDataDir/$householdsFile");
	    $self->runCmd(0,"echo test > $workflowDataDir/$observationsFile");
      }
      $self->runCmd($test,"makeFileWithSql --outFile $workflowDataDir/$participantsFile --sql \"$shinyParticipantsSql\" --verbose --includeHeader --outDelimiter '\\t'");
      $self->runCmd($test,"makeFileWithSql --outFile $workflowDataDir/$householdsFile --sql \"$shinyHouseholdsSql\" --verbose --includeHeader --outDelimiter '\\t'");
      $self->runCmd($test,"makeFileWithSql --outFile $workflowDataDir/$observationsFile --sql \"$shinyObservationsSql\" --verbose --includeHeader --outDelimiter '\\t'");
  }
}

1;