package ApiCommonWorkflow::Main::WorkflowSteps::MakeDerivedTopLevelTables;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $organismAbbrev = $self->getParamValue('organismAbbrev');

  #my $tables = "GeneAttributes,SequenceAttributes,FeatureLocation";

  my $tables = "SequencePieceClosure,FeatureLocation,GeneId,GeneAttributes,GenomicSequence,SequenceAttributes,TaxonSpecies";

  my $gusHome = $self->getSharedConfig('gusHome');
  my $instance = $self->getSharedConfig('instance');

  my $tuningTablePrefix = $self->getTuningTablePrefix($organismAbbrev, $test);

  my $apidbTuningPassword = $self->getConfig('apidbTuningPassword');
  my $xmlConfigFileName="tmpConfigFile.xml";
  my $xmlConfigFileString=
"<?xml version='1.0'?>
<property>
<password>$apidbTuningPassword</password>
<schema>ApiDBTuning</schema>
</property>
";
  my $stepDir = $self->getStepDir();
  open(F,">$stepDir/$xmlConfigFileName");
  print F $xmlConfigFileString;
  close F;
  my $cmd;

      $cmd = "tuningManager -prefix '$tuningTablePrefix' -instance '$instance' -propFile $stepDir/$xmlConfigFileName -doUpdate -notifyEmail none -tables $tables -configFile ${gusHome}/lib/xml/tuningManager.xml -filterValue 821459";


  if ($undo){
     $self->runCmd(0, "echo Doing nothing for \"undo\" Tuning Manager.\n");  
  }else{
      if ($test) {
      }else {
	  $self->runCmd($test, $cmd);
      }
  }


}

sub getParamsDeclaration {
  return ('organismAbbrev',
	 );
}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	 );
}


