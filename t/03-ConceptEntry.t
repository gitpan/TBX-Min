# test the functionality of TBX::Min::Entry

use strict;
use warnings;
use Test::More;
plan tests => 11;
use Test::Deep;
use Test::NoWarnings;
use TBX::Min;
use FindBin qw($Bin);
use Path::Tiny;

my $args = {
    id => 'B001',
    subject_field => 'foo',
    lang_groups => [
        TBX::Min::LangGroup->new({code => 'en'}),
        TBX::Min::LangGroup->new({code => 'zh'}),
    ],
};

#test constructor without arguments
my $concept = TBX::Min::Entry->new;
isa_ok($concept, 'TBX::Min::Entry');

ok(!$concept->id, 'id not defined by default');
ok(!$concept->subject_field,
    'subject_field not defined by default');
is_deeply($concept->lang_groups, [],
    'lang_groups returns empty array by default');

#test constructor with arguments
$concept = TBX::Min::Entry->new($args);
is($concept->id, $args->{id}, 'correct id from constructor');
is($concept->subject_field, $args->{subject_field},
    'correct subject_field from constructor');
cmp_deeply($concept->lang_groups, $args->{lang_groups},
    'correct term groups from constructor');

#test setters
$concept = TBX::Min::Entry->new();

$concept->id($args->{id});
is($concept->id, $args->{id}, 'id correctly set');

$concept->subject_field($args->{subject_field});
is($concept->subject_field, $args->{subject_field},
    'subject_field correctly set');

$concept->add_lang_group($args->{lang_groups}->[0]);
cmp_deeply($concept->lang_groups->[0], $args->{lang_groups}->[0],
    'add_lang_group works correctly');
