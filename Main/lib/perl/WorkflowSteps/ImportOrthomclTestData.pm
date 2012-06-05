package ApiCommonWorkflow::Main::WorkflowSteps::ImportOrthomclTestData;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  # three cases:
  # 1) no taxaDir supplied:  filter based on inputProteinFile
  # 2) taxaDir supplied, and no table called ApiDB.SimilarSequences${suffix}_1 exists:  filter based on taxa in taxaDir
  # 3) taxaDir supplied, and ApiDB.SimilarSequences${suffix}_1 exists:  use that table (drop ApiDB.SimilarSequences$suffix and use a synonym)

  my $taxaDir = $self->getParamValue('taxaDir');
  my $suffix = $self->getParamValue('suffix');
  my $inputProteinFile = $self->getParamValue('inputProteinFile');

  my $sql;
  my $cacheTableName = "ApiDB.SimilarSequences${suffix}_c"
  ($cacheTableExists) = $self->runSqlFetchOneRow($test, "sql to test cache table existence") if ($taxaDir);

  if ($undo) {
      if ($tableExists) {
	  $sql = "sql to remove synonym";
	  $self->runSqlFetchOneRow($test, "$sql");
      } else {
	  $self->runSqlFetchOneRow($test, "truncate table apidb.SimilarSequences$suffix");
      }
  } else {
      if (!$taxaDir) {
	  $self->filterOnProteinIds($suffix, $inputProteinFile);
      } else {
	  if ($tableExists) {
	      $self->createSynonym($suffix);
	  } else {
	      $self->filterOnTaxa($suffix, $taxaDir);
	  }
      }
  }
}

# Plan A Tier 1
# drop apidb.SimilarSequences$suffix table if it exists
# create synonym called "apidb.SimilarSequences$suffix" that points to cache table apidb.SimilarSequences$suffix_c
sub createSynonym {
    my ($self, $suffix) = @_;
    my ($simSeqExists) = $self->runSqlFetchOneRow($test, "sql here to test existance of sim seq table");

}

# Plan B Tier 1
sub filterOnTaxa {
    my ($self, $suffix, $taxaDir) = @_;

    chdir $taxaDir || die "Can't chdir to '$taxaDir'\n";
    my @taxonNames = map {/(\w+).fasta/; $1; } <*.fasta>;
    my $taxonList = join(', ', @taxonNames);

    $sql = <<"SQL";
          insert into apidb.SimilarSequences$suffix
                      (query_id, subject_id, query_taxon_id, subject_taxon_id,
                       evalue_mant, evalue_exp, percent_identity, percent_match)
          select query_id, subject_id, query_taxon_id, subject_taxon_id,
                 evalue_mant, evalue_exp, percent_identity, percent_match
          from apidb.SimilarSequences\@orth500n
          where query_taxon_id in ($taxonList)
            and subject_taxon_id in ($taxonList)
SQL

    $self->runSqlFetchOneRow($test, $sql);
}

# Plan A Tier 2 (representatives) and Plan B Tier 2 (residuals)
# parse fasta to get protein ids, and write ids to table
# use table to join for filtering
# write results to apidb.SimilarSequences$suffix
sub filterOnProteinIds {
    my ($self, $suffix, $proteinsFastaFile) = @_;
}


