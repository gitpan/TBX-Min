#test the basic functionality of TBX::Min

use strict;
use warnings;
use Test::More;
plan tests => 33;
use Test::NoWarnings;
use Test::Exception;
use Test::Deep;
use TBX::Min;
use FindBin qw($Bin);
use Path::Tiny;

my $args = {
    id => 'foo1',
    description => 'foo8',
    date_created => '2013-11-12T00:00:00',
    creator => 'foo2',
    license => 'foo3',
    directionality => 'bidirectional',
    source_lang => 'foo6',
    target_lang => 'foo7',
    entries => [
        TBX::Min::Entry->new({id => 'foo'}),
        TBX::Min::Entry->new({id => 'bar'}),
    ],
};

#test constructor without arguments
my $min = TBX::Min->new();
isa_ok($min, 'TBX::Min');

ok(!$min->id, 'id not defined by default');
ok(!$min->description, 'description not defined by default');
ok(!$min->date_created, 'date_created not defined by default');
ok(!$min->creator, 'creator not defined by default');
ok(!$min->license, 'license not defined by default');
ok(!$min->directionality, 'directionality not defined by default');
ok(!$min->source_lang, 'source_lang not defined by default');
ok(!$min->target_lang, 'target_lang not defined by default');
cmp_deeply($min->entries, [], 'entries returns empty array by default');

#test constructor with arguments
$min = TBX::Min->new($args);
is($min->id, $args->{id}, 'correct id from constructor');
is($min->description, $args->{description},
    'correct description from constructor');
is($min->date_created, $args->{date_created},
    'correct date_created from constructor');
is($min->creator, $args->{creator}, 'correct creator from constructor');
is($min->license, $args->{license}, 'correct license from constructor');
is($min->directionality, $args->{directionality},
    'correct directionality from constructor');
is($min->source_lang, $args->{source_lang},
    'correct source_lang from constructor');
is($min->target_lang, $args->{target_lang},
    'correct target_lang from constructor');
cmp_deeply($min->entries, $args->{entries}, 'correct entries from constructor');

#test setters
$min = TBX::Min->new();

$min->id($args->{id});
is($min->id, $args->{id}, 'id correctly set');

$min->description($args->{description});
is($min->description, $args->{description}, 'description correctly set');

$min->date_created($args->{date_created});
is($min->date_created, $args->{date_created}, 'date_created correctly set');

$min->creator($args->{creator});
is($min->creator, $args->{creator}, 'creator correctly set');

$min->license($args->{license});
is($min->license, $args->{license}, 'license correctly set');

$min->directionality($args->{directionality});
is($min->directionality, $args->{directionality}, 'directionality correctly set');

$min->source_lang($args->{source_lang});
is($min->source_lang, $args->{source_lang}, 'source_lang correctly set');

$min->target_lang($args->{target_lang});
is($min->target_lang, $args->{target_lang}, 'target_lang correctly set');

$min->add_entry($args->{entries}->[0]);
cmp_deeply($min->entries->[0], $args->{entries}->[0],
    'add_entries works correctly');

# check errors
throws_ok {TBX::Min->new({date_created => 'stuff'})}
    qr/date is not in ISO8601 format/,
    'exception thrown for bad date';

#check validation of directionality value
for my $dir (qw(monodirectional bidirectional)){
    subtest "$dir is a valid directionality value" => sub {
        plan tests => 2;
        lives_ok {
            TBX::Min->new({directionality => $dir});
        } 'constructor';
        lives_ok {
            $min = TBX::Min->new();
            $min->directionality($dir);
        } 'accessor';
    };
}

subtest 'foo is not a legal directionality value' => sub {
    plan tests => 2;
    my $error = qr/illegal directionality 'foo'/i;
    throws_ok {
        $min = TBX::Min->new({directionality => 'foo'});
    } $error, 'constructor';
    throws_ok {
        $min = TBX::Min->new();
        $min->directionality('foo');
    } $error, 'accessor';
};
