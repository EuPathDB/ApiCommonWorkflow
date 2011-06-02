package ApiCommonWorkflow::Main::WorkflowSteps::ExtractTopLevelFastaSeqs;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $genomeExtDbRlsSpec = $self->getParamValue('genomeExtDbRlsSpec');
#  my $genomeVirtualSeqsExtDbRlsSpec = $self->getParamValue('genomeVirtualSeqsExtDbRlsSpec');
  my $genomeVirtualSeqsExtDbRlsSpec = "FIX THIS see Redmine #4305";
  my $outputFile = $self->getParamValue('outputFile');

  my @extDbRlsSpecList = split(/,/, $genomeExtDbRlsSpec);

  my $dbRlsIds;

  foreach my $db (@extDbRlsSpecList){
        
     $dbRlsIds .= $self->getExtDbRlsId($test, $db).",";

  }

  $dbRlsIds =~ s/(,)$//g;

  my $virtualDbRlsIds;

  if ($genomeVirtualSeqsExtDbRlsSpec){
      
      my @virtualDbRlsSpecList = split(/,/, $genomeVirtualSeqsExtDbRlsSpec);

      foreach my $db (@virtualDbRlsSpecList){
        
	  $virtualDbRlsIds .= $self->getExtDbRlsId($test, $db).",";

      }

      $virtualDbRlsIds =~ s/(,)$//g;

  }

  my $sql1 = "select source_id, sequence 
             from Dots.VIRTUALSEQUENCE vs,  SRes.EXTERNALDATABASE e, SRes.EXTERNALDATABASERELEASE r  
             where e.external_database_id = r.external_database_id and vs.external_database_release_id = r.external_database_release_id and r.external_database_release_id in($virtualDbRlsIds)";

  my $sql2 = "select source_id, sequence 
              from Dots.EXTERNALNASEQUENCE es, SRes.EXTERNALDATABASE e, SRes.EXTERNALDATABASERELEASE r  
              where e.external_database_id = r.external_database_id and es.external_database_release_id = r.external_database_release_id 
                and r.external_database_release_id in '$dbRlsIds'";

 $sql2 .= " and es.na_sequence_id NOT IN (
                select sp.piece_na_sequence_id from dots.SEQUENCEPIECE sp, dots.VIRTUALSEQUENCE vs, Sres.EXTERNALDATABASE e, Sres.EXTERNALDATABASERELEASE r  
                where vs.na_sequence_id = sp.virtual_na_sequence_id AND vs.external_database_release_id = r.external_database_release_id AND r.external_database_id = e.external_database_id AND r.external_database_release_id in '$virtualDbRlsIds'
                )" if ($genomeVirtualSeqsExtDbRlsSpec);


  my $workflowDataDir = $self->getWorkflowDataDir();

    if ($undo) {
      $self->runCmd(0, "rm -f $workflowDataDir/$outputFile");
    } else {
	if ($test) {
	    $self->runCmd(0,"echo test > $workflowDataDir/$outputFile");
	}else{
	    $self->runCmd($test,"dumpSequencesFromTable.pl --outputFile $workflowDataDir/$outputFile --idSQL \"$sql1\" --verbose")  if ($genomeVirtualSeqsExtDbRlsSpec);
	    $self->runCmd($test,"dumpSequencesFromTable.pl --outputFile $workflowDataDir/$outputFile --idSQL \"$sql2\" --verbose");
	}
    }
  }

sub getParamsDeclaration {
  return (
	  'genomeExtDbRlsSpec',
#	  'genomeVirtualSeqsExtDbRlsSpec',
	  'outputFile',
	 );
}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	 );
}


