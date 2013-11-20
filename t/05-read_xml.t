# check that a TBX::Min object can be created from a TBX-Min XML file.

use strict;
use warnings;
use Test::More 0.88;
plan tests => 44;
use Test::NoWarnings;
use TBX::Min;
use FindBin qw($Bin);
use Path::Tiny;

my $basic_path = path($Bin, 'corpus', 'basic.tbx');
my $basic_txt = $basic_path->slurp;

note('reading XML file');
test_read("$basic_path");

note('reading XML string');
test_read(\$basic_txt);

test_empty_tbx();

sub test_read {
    my ($input) = @_;
    my $min = TBX::Min->new_from_xml($input);

    isa_ok($min, 'TBX::Min');
    test_header($min);
    test_body($min);
}

sub test_header {
    my ($min) = @_;
    is($min->id, 'TBX sample', 'correct id');
    is($min->creator, 'Klaus-Dirk Schmidt', 'correct creator');
    is($min->license, 'CC BY license can be freely copied and modified',
        'correct license');
    is($min->directionality, 'bidirectional', 'correct directionality');
    is($min->source_lang, 'de', 'correct source language');
    is($min->target_lang, 'en', 'correct target language');
}

sub test_body {
    my ($min) = @_;
    my $concepts = $min->concepts;
    is(scalar @$concepts, 3, 'found three concepts');

    my $concept = $concepts->[0];
    isa_ok($concept, 'TBX::Min::ConceptEntry');
    is($concept->id, 'C002', 'correct concept ID');
    is($concept->subject_field, 'biology',
        'correct concept subject field');
    my $languages = $concept->lang_groups;
    is(scalar @$languages, 2, 'found two languages');

    my $language = $languages->[1];
    isa_ok($language, 'TBX::Min::LangGroup');
    is($language->code, 'en', 'language is English');
    my $terms = $language->term_groups;
    is(scalar @$terms, 2, 'found two terms');

    my $term = $terms->[1];
    isa_ok($term, 'TBX::Min::TermGroup');
    is($term->term, 'hound', 'correct term text');
    is($term->part_of_speech, 'noun', 'correct part of speech');
    is($term->status, 'deprecated', 'correct status');
    is($term->customer, 'SAP', 'correct customer');
    is($term->note, 'however bloodhound is used rather than blooddog',
        'correct note');
}

# simple check that "concepts" sub returns empty array, not undef
sub test_empty_tbx {
    my $empty_tbx = '<TBX dialect="TBX-Min"/>';
    my $min = TBX::Min->new_from_xml(\$empty_tbx);
    is_deeply($min->concepts, [], 'concepts returns [] by default');
}
