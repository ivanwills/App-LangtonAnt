#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Warnings;

BEGIN {
    use_ok( 'App::LangtonAnt' );
}

diag( "Testing App::LangtonAnt $App::LangtonAnt::VERSION, Perl $], $^X" );
done_testing();
