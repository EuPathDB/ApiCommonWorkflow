package ApiCommonWorkflow::Main::Util::OrganismInfo;

use strict;

sub new {
    my ($class, $workflowStep, $test, $organismAbbrev) = @_;

    my $self = {test => $test,
		organismAbbrev => $organismAbbrev,
		workflowStep => $workflowStep
	       };
    bless($self,$class);

    return $self if $test;

    my $sql = "select nameForFiles
             from apidb.organism
             where organismAbbrev = $organismAbbrev";

    my $stmt = $workflowStep->runSql($sql);
    my ($nameForFiles) = $stmt->fetchrow_array(); 

    $sql = "select tn.name, t.ncbi_tax_id, o.taxon_id
             from sres.taxonname tn, sres.taxon t, apidb.organism o
             where o.organismAbbrev = $organismAbbrev
             and t.taxon_id = o.taxon_id
             and tn.taxon_id = t.taxon_id
             and tn.name_class = 'scientific name'";

    my $stmt = $workflowStep->runSql($sql);
    my ($fullName, $ncbiTaxonId, $taxonId) = $stmt->fetchrow_array(); 

    $sql = "select ncbi_tax_id, taxon_id
   from
  (select taxon_id, ncbi_tax_id, rank 
   from sres.taxon
   connect by taxon_id = prior parent_id
   start with taxon_id = $taxonId) t
   where t.rank = 'species'";

    $stmt = $workflowStep->runSql($sql);
    my ($speciesNcbiTaxonId, $speciesTaxonId) = $stmt->fetchrow_array(); 

    $self->{fullName} = $fullName;
    $self->{nameForFiles} = $nameForFiles;
    $self->{ncbiTaxonId} = $ncbiTaxonId;
    $self->{taxonId} = $taxonId;
    $self->{speciesNcbiTaxonId} = $speciesNcbiTaxonId;
    $self->{speciesTaxonId} = $speciesTaxonId;

    return $self;
}

sub getFullName {
    my ($self) = @_;
    return "$self->{organismAbbrev}_FULL_NAME" if $self->{test};
    return $self->{fullName};
}

sub getNameForFiles {
    my ($self) = @_;
    return "$self->{organismAbbrev}_NAME_FOR_FILES" if $self->{test};
    return $self->{nameForFiles};
}

sub getNcbiTaxonId {
    my ($self) = @_;
    return "$self->{organismAbbrev}_NCBI_TAXON_ID" if $self->{test};
    return $self->{ncbiTaxonId};
}

sub getSpeciesNcbiTaxonId {
    my ($self) = @_;
    return "$self->{organismAbbrev}_SPECIES_NCBI_TAXON_ID" if $self->{test};
    return $self->{speciesNcbiTaxonId};
}

sub getTaxonId {
    my ($self) = @_;
    return "$self->{organismAbbrev}_TAXON_ID" if $self->{test};
    return $self->{taxonId};
}

sub getSpeciesNcbiTaxonId {
    my ($self) = @_;
    return "$self->{organismAbbrev}_SPECIES_TAXON_ID" if $self->{test};
    return $self->{speciesTaxonId};
}

sub getTaxonIdList {
  my ($self, $hierarchy) = @_;

  if ($hierarchy) {
    my $idList = $self->{workflowStep}->runCmd($self->{test}, "getSubTaxaList --taxon_id $self->{taxonId}");
    if ($self->{test}) {
      return "$self->{organismAbbrev}_TAXON_ID_LIST";
    } else {
      chomp($idList);
      return  $idList;
    }
  } else {
    return $self->getTaxonId();
  }
}


1;
