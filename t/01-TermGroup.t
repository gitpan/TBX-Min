#test the functionality of TBX::Min::TermGroup

use strict;
use warnings;
use Test::More;
plan tests => 29;
use Test::NoWarnings;
use Test::Exception;
use TBX::Min;
use FindBin qw($Bin);
use Path::Tiny;

my $args = {
    term => 'foo1',
    part_of_speech => 'noun',
    note => 'foo3',
    customer => 'foo4',
    status => 'preferred',
};


#test constructor without arguments
my $term_grp = TBX::Min::TermGroup->new();
isa_ok($term_grp, 'TBX::Min::TermGroup');

ok(!$term_grp->term, 'term not defined by default');
ok(!$term_grp->part_of_speech, 'part_of_speech not defined by default');
ok(!$term_grp->note, 'note not defined by default');
ok(!$term_grp->customer, 'customer not defined by default');
ok(!$term_grp->status, 'status not defined by default');

#test constructor with arguments
$term_grp = TBX::Min::TermGroup->new($args);
is($term_grp->term, $args->{term}, 'correct term from constructor');
is($term_grp->part_of_speech, $args->{part_of_speech},
    'correct part_of_speech from constructor');
is($term_grp->note, $args->{note}, 'correct note from constructor');
is($term_grp->customer, $args->{customer}, 'correct customer from constructor');
is($term_grp->status, $args->{status}, 'correct status from constructor');

#test setters
$term_grp = TBX::Min::TermGroup->new();

$term_grp->term($args->{term});
is($term_grp->term, $args->{term}, 'term correctly set');

$term_grp->part_of_speech($args->{part_of_speech});
is($term_grp->part_of_speech, $args->{part_of_speech}, 'part_of_speech correctly set');

$term_grp->note($args->{note});
is($term_grp->note, $args->{note}, 'note correctly set');

$term_grp->customer($args->{customer});
is($term_grp->customer, $args->{customer}, 'customer correctly set');

$term_grp->status($args->{status});
is($term_grp->status, $args->{status}, 'status correctly set');

# check validity of part_of_speech picklist values
for my $pos(qw(noun properNoun verb adjective adverb other)) {
    subtest "$pos is a legal part_of_speech value" => sub {
        plan tests => 2;
        lives_ok {
            $term_grp = TBX::Min::TermGroup->new(part_of_speech => $pos);
        } 'constructor';
        lives_ok {
            $term_grp = TBX::Min::TermGroup->new();
            $term_grp->part_of_speech($pos);
        } 'accessor';
    };
}

subtest 'foo is not a legal part_of_speech value' => sub {
    plan tests => 2;
    my $error = qr/illegal part of speech 'foo'/i;
    throws_ok {
        $term_grp = TBX::Min::TermGroup->new(part_of_speech => 'foo');
    } $error, 'constructor';
    throws_ok {
        $term_grp = TBX::Min::TermGroup->new();
        $term_grp->part_of_speech('foo');
    } $error, 'accessor';
};

# check validity of status picklist values
for my $status(qw(admitted preferred notRecommended obsolete)) {
    subtest "$status is a legal status value" => sub {
        plan tests => 2;
        lives_ok {
            $term_grp = TBX::Min::TermGroup->new(status => $status);
        } 'constructor';
        lives_ok {
            $term_grp = TBX::Min::TermGroup->new();
            $term_grp->status($status);
        } 'accessor';
    };
}

subtest 'foo is not a legal status value' => sub {
    plan tests => 2;
    my $error = qr/illegal status 'foo'/i;
    throws_ok {
        $term_grp = TBX::Min::TermGroup->new(status => 'foo');
    } $error, 'constructor';
    throws_ok {
        $term_grp = TBX::Min::TermGroup->new();
        $term_grp->status('foo');
    } $error, 'accessor';
};
