#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Warnings;

my $module = 'App::LangtonAnt::Ant';
use_ok( $module );

move();

done_testing();

sub move {
    my $ant = $module->new(
        row => 1,
        col => 1,
        dir => 0,
    );
    ok $ant, 'Create a new ant';

    is 'black', $ant->move('white'), 'Move off a white square give black';
    is $ant->row, 1, 'The move should have up by one';
    is $ant->col, 0, 'The column should not have changed';
    is $ant->dir, 3, 'The ant should now face left';

    # 4 move on white should get us back to where we started
    $ant->move('white');
    $ant->move('white');
    $ant->move('white');
    is $ant->row, 1, 'The move should have up by one';
    is $ant->col, 1, 'The column should not have changed';
    is $ant->dir, 0, 'The ant should now face left';
}
