package ApiCommonWorkflow::Main::WorkflowSteps::EdaNextflowConfig;
@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::RunNextflow);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::RunNextflow;

sub getStudyDirectory {}
sub getProject {}
sub getExtDbRlsSpec {}

sub getWebDisplayOntologySpec {}
sub getWebDisplayOntologyFile {}
sub getLoadWebDisplayOntologyFile {}

sub getInvestigationSubset {}
sub getIsaFormat {}
sub getInvestigationBaseName {}

sub getMegaStudyStableId {}
sub getOptionalMegaStudyYaml {}

sub getAssayResultsDirectory {}
sub getAssayResultsFileExtensionsJson {}
sub getSampleDetailsFile {}

sub getOptionalDateObfuscationFile {}
sub getOptionalValueMappingFile {}
sub getOptionalOntologyMappingOverrideBaseName {}
sub getOptionalEntityTypeFile {}
sub getOptionalOwlAttributesFile {}
sub getOptionalOrdinalsFile {}

sub getDownloadFileBaseName {}

sub getSchema {
    return "EDA"
}


sub nextflowConfigAsString {
    my ($self) = @_;

    my $studyDirectory = $self->getStudyDirectory() || "NA";
    my $project = $self->getProject() || "NA";
    my $extDbRlsSpec = $self->getExtDbRlsSpec() || "NA";
    my $webDisplayOntologySpec = $self->getWebDisplayOntologySpec() || "NA";
    my $webDisplayOntologyFile = $self->getWebDisplayOntologyFile() || "NA";
    my $loadWebDisplayOntologyFile = $self->getLoadWebDisplayOntologyFile() || "NA";
    my $investigationSubset = $self->getInvestigationSubset() || "NA";
    my $schema = $self->getSchema() || "NA";
    my $isaFormat = $self->getIsaFormat() || "NA";
    my $investigationBaseName = $self->getInvestigationBaseName() || "NA";
    my $megaStudyStableId = $self->getMegaStudyStableId() || "NA";
    my $optionalMegaStudyYaml = $self->getOptionalMegaStudyYaml() || "NA";
    my $assayResultsDirectory = $self->getAssayResultsDirectory() || "NA";
    my $assayResultsFileExtensionsJson = $self->getAssayResultsFileExtensionsJson() || "NA";
    my $sampleDetailsFile = $self->getSampleDetailsFile() || "NA";
    my $optionalDateObfuscationFile = $self->getOptionalDateObfuscationFile() || "NA";
    my $optionalValueMappingFile = $self->getOptionalValueMappingFile() || "NA";
    my $optionalOntologyMappingOverrideBaseName = $self->getOptionalOntologyMappingOverrideBaseName() || "NA";
    my $optionalEntityTypeFile = $self->getOptionalEntityTypeFile() || "NA";
    my $optionalOwlAttributesFile = $self->getOptionalOwlAttributesFile() || "NA";
    my $optionalOrdinalsFile = $self->getOptionalOrdinalsFile() || "NA";
    my $downloadFileBaseName = $self->getDownloadFileBaseName() || "NA";


    my $config = <<CONFIG;
params.studyDirectory = "$studyDirectory"
params.project = "$project"
params.extDbRlsSpec = "$extDbRlsSpec"

params.webDisplayOntologySpec = "$webDisplayOntologySpec"
params.webDisplayOntologyFile = "$webDisplayOntologyFile"
params.loadWebDisplayOntologyFile = $loadWebDisplayOntologyFile

params.investigationSubset = "$investigationSubset"

params.schema = "$schema"
params.isaFormat = "$isaFormat"
params.investigationBaseName = "$investigationBaseName"

params.megaStudyStableId = "$megaStudyStableId"
params.optionalMegaStudyYaml = "$optionalMegaStudyYaml"

params.assayResultsDirectory = "$assayResultsDirectory"
params.assayResultsFileExtensionsJson = "$assayResultsFileExtensionsJson"
params.sampleDetailsFile = "$sampleDetailsFile"

// optional files when isaFormat = simple
params.optionalDateObfuscationFile = "$optionalDateObfuscationFile"
params.optionalValueMappingFile = "$optionalValueMappingFile"
params.optionalOntologyMappingOverrideBaseName = "$optionalOntologyMappingOverrideBaseName"

// optional ontology files
params.optionalEntityTypeFile = "$optionalEntityTypeFile"
params.optionalOwlAttributesFile = "$optionalOwlAttributesFile"
params.optionalOrdinalsFile = "$optionalOrdinalsFile"

params.downloadFileBaseName = "$downloadFileBaseName"

trace.enabled = true
trace.fields = 'task_id,hash,process,tag,status,exit,submit,realtime,%cpu,rss'
CONFIG

    return $config;
}


1;