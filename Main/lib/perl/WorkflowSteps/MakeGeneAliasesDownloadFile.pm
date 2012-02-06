package ApiCommonWorkflow::Main::WorkflowSteps::MakeGeneAliasesDownloadFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WebsiteFileMaker);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WebsiteFileMaker;


sub getDownloadFileCmd {
    my ($self, $downloadFileName, $test) = @_;

  my $genomeExtDbRlsSpec = $self->getParamValue('genomeExtDbRlsSpec');

  my $cmd = "getGeneAliases --genomeExtDbSpec '$genomeExtDbRlsSpec' --outfile $downloadFileName";

  return $cmd;   
}

