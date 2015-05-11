package ApiCommonWorkflow::Main::WorkflowSteps::MakeDerivedTables;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $organismAbbrev = $self->getParamValue('organismAbbrev');

  my $tables = $self->getParamValue('tables');

  my $gusHome = $self->getSharedConfig('gusHome');

  my $instance = $self->getGusInstanceName();

  my $tuningTablePrefix;

  my $taxonId;

  my $apidbTuningPassword = $self->getConfig('apidbTuningPassword');

  my $dblink = $self->getConfig('dblink');

  my $xmlConfigFileName="tmpConfigFile.xml";
  my $xmlConfigFileString=
"<?xml version='1.0'?>
<tuningProps>
  <password>$apidbTuningPassword</password>
  <schema>ApidbTuning</schema>
  <housekeepingSchema>apidb</housekeepingSchema>
  <dblink>$dblink</dblink>
  <logTable>apidb_r.TuningTableLog$dblink</logTable>
  <dbaEmail>eupath-admin\@pcbi.upenn.edu</dbaEmail>
  <fromEmail>tuningMgr\@pcbi.upenn.edu</fromEmail>
</tuningProps>
";
  my $stepDir = $self->getStepDir();
  open(F,">$stepDir/$xmlConfigFileName");
  print F $xmlConfigFileString;
  close F;

 my $cmd = "tuningManager -instance '$instance' -propFile $stepDir/$xmlConfigFileName -doUpdate -notifyEmail none -configFile ${gusHome}/lib/xml/tuningManager/tuningManager.xml  " ;
  
 if ($organismAbbrev){

	$tuningTablePrefix = $self->getTuningTablePrefix($organismAbbrev, $test);
    
    $taxonId = $self->getOrganismInfo($test, $organismAbbrev)->getTaxonId();

    $cmd .= "-filterValue $taxonId -prefix '$tuningTablePrefix'  " ;

  }

 $cmd .= "-tables $tables  " if ($tables);

  if ($undo) {
     $self->runCmd(0, "echo Doing nothing for \"undo\" Tuning Manager.\n");  
  } else {
      $self->runCmd($test, $cmd);
  }
}



