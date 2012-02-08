package ApiCommonWorkflow::Main::WorkflowSteps::ResourceRunPlugin;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
    my ($self, $test, $undo) = @_;

    my $dataSourceName = $self->getParamValue('resourceName');
    my $dataSourceXmlFile = $self->getParamValue('resourceXmlFileName');
    my $dataDirPath = $self->getParamValue('dataDir');
    my $dataSource = $self->getDataSource($dataSourceName, $dataSourceXmlFile, $dataDirPath);

    my $plugin =  $dataSource->getPlugin();
    my $pluginArgs =  $dataSource->getPluginArgs();
    $pluginArgs =~ s/DBRefNAFeature/DbRefNAFeature/;
    _formatForCLI($pluginArgs);

    if ($plugin =~ m/InsertSequenceFeatures/ && $undo){

      my $mapFile = $1 if ($pluginArgs =~ m/mapFile\s+(\S+)\s+/);

      my $algInvIds = $self->getAlgInvIds();
     
      if ($algInvIds) {
	  $self->runCmd($test,"ga GUS::Supported::Plugin::InsertSequenceFeaturesUndo --mapFile $mapFile --algInvocationId $algInvIds --workflowContext --commit");
      } else {
	$self->log("No algorithm invocation IDs found for this plugin step.  The plugin must have been manually undone.  Exiting");
      }
	
    }else{

	$self->runPlugin($test, $undo, $plugin, $pluginArgs);
    }
}

sub _formatForCLI {
    $_[0] =~ s/\\$//gm;
    $_[0] =~ s/[\n\r]+/ /gm;
}


sub getParamsDeclaration {
    return (
	'resourceName',
	'resourceXmlFileName',
        'dataDir'
           );
}

sub getConfigDeclaration {
    return (
           # [name, default, description]
           );
}



