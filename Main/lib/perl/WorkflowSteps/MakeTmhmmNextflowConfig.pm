package ApiCommonWorkflow::Main::WorkflowSteps::MakeTmhmmNextflowConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $fastaSubsetSize = 500;

  my $proteinSequenceFile = $self->getParamValue("proteinSequenceFile");
  my $nextflowConfigFile = $self->getParamValue("nextflowConfigFile");
  my $resultsDirectory = $self->getParamValue("resultsDirectory");
  my $outputFileName = $self->getParamValue("outputFileName");

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $clusterServer = $self->getSharedConfig('clusterServer');

  # Expecting something like "/project/eupathdb/apptainerImages"
  my $apptainerImageDirectory = $self->getSharedConfig("${$clusterServer}.apptainerImageDirectory");

  # Expecting something like "/project/eupathdb/apptainerImages" + "/" + tmhmm/latest/tmhmm.sif
  my $sifImageFile = ${apptainerImageDirectory} . "/" . $self->getConfig("imageRelativePath");

  my $clusterWorkflowDataDir = $self->getClusterWorkflowDataDir();
  my $executor = $self->getClusterExecutor();

  my $clusterConfigFile = "\$baseDir/conf/${executor}.config";

  if ($undo) {
      $self->runCmd(0, "rm $workflowDataDir/$nextflowConfigFile");
  } else {
      my $nextflowConfig = "$workflowDataDir/$nextflowConfigFile";
      open(F, ">$nextflowConfig") || die "Can't open task prop file '$nextflowConfig' for writing";

      my $configString = <<NEXTFLOW;
params {
  inputFilePath = "$clusterWorkflowDataDir/$proteinSequenceFile"
  outputDir = "$clusterWorkflowDataDir/$resultsDirectory"
  outputFileName = "$outputFileName"
  fastaSubsetSize = $fastaSubsetSize
}


process {
    maxForks = 5

     withName: tmhmm {
        container = "${sifImageFile}"
        ext.args = "-short"
    }
}

includeConfig "$clusterConfigFile"

NEXTFLOW

      print F $configString;
      close(F);
  }
}






1;
