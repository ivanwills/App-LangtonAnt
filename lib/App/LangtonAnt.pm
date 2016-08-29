package App::LangtonAnt;

# Created on: 2016-08-28 19:46:49
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moo;
use warnings;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use Types::Standard qw/Int Num ArrayRef InstanceOf/;
use Term::ANSIColor qw/colored/;
use Term::Screen;
use Time::HiRes qw/sleep/;
use App::LangtonAnt::Ant;

our $VERSION = 0.001;

has height => (
    is      => 'rw',
    isa     => Int,
    lazy    => 1,
    default => sub { $_[0]->rows },
);
has width => (
    is      => 'rw',
    isa     => Int,
    lazy    => 1,
    default => sub { $_[0]->cols },
);
has flipped => (
    is      => 'ro',
    isa     => Int,
    default => 0,
);
has pause => (
    is      => 'ro',
    isa     => Num,
    default => 0.1,
);
has board => (
    is      => 'rw',
    isa     => ArrayRef[ArrayRef],
    lazy    => 1,
    builder => '_new_board',
);
has screen => (
    is      => 'ro',
    default => sub { Term::Screen->new },
    handles => {
        clear => 'clrscr',
        rows  => 'rows',
        cols  => 'cols',
        at    => 'at',
        puts  => 'puts',
    }
);
has ant => (
    is      => 'rw',
    isa     => InstanceOf['App::LangtonAnt::Ant'],
    lazy    => 1,
    builder => '_new_ant',
);

sub play {
    my ($self) = @_;
    my $ant = $self->ant;

    $self->clear;
    $ant->draw;
    my $last = time;

    while (1) {
        $self->at(0, 0);
        sleep $self->pause;
        my ($row, $col) = ( $ant->row, $ant->col );
        my $loc = $self->board->[$row][$col];
        $loc->{color} = $ant->move($loc->{color});

        $self->at($row, $col);
        $self->puts( colored( ['on_' . $loc->{color}], ' ' ) );
        $ant->teleport($self->height, $self->width)->draw;

        if ($last != time) {
            my $t = Term::Screen->new;

            # check if board size has changed
            if ($self->height != $t->rows || $self->width != $t->cols ) {
                $self->height($t->rows);
                $self->width($t->cols);
                $self->fix_board;
            }
            $last = time;
        }
    }
}

sub fix_board {
    my ($self) = @_;
    my $board = $self->board;

    if (@{$board} > $self->height) {
        @$board = @{$board}[0 .. $self->height - 1];
    }
    elsif (@{$board->[0]} > $self->width) {
        for my $row (@$board) {
            @$row = @{$row}[0 .. $self->width - 1];
        }
    }
    elsif (@{$board} < $self->height) {
        # extend board with extra rows
        for my $i ( @{$board} .. $self->height ) {
            for my $j (0 .. $self->width) {
                $board->[$i][$j] = {
                    color => 'black',
                };
            }
        }
    }
    elsif (@{$board->[0]} < $self->width) {
        my $cols = @{$board->[0]};

        # extend board with extra cols
        for my $i ( 0 .. $self->height ) {
            for my $j ($cols .. $self->width) {
                $board->[$i][$j] = {
                    color => 'black',
                };
            }
        }
    }
}

sub _new_board {
    my ($self) = @_;
    my @board;

    $self->clear;

    for my $i (0 .. $self->height) {
        for my $j (0 .. $self->width) {
            $board[$i][$j] = {
                color => 'black',
            };
        }
    }

    for ( 0 .. $self->flipped - 1) {
        my $row = int rand $self->height;
        my $col = int rand $self->width;
        $board[$row][$col]{color} = 'white';
        $self->at($row, $col);
        $self->puts( colored( ['on_white' ], ' ' ) );
    }

    return \@board;
}

sub _new_ant {
    my ($self) = @_;

    return App::LangtonAnt::Ant->new(
        row => int $self->height / 2,
        col => int $self->width / 2,
        dir => int 0,
    );
}

1;

__END__

=head1 NAME

App::LangtonAnt - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to App::LangtonAnt version 0.0.1


=head1 SYNOPSIS

   use App::LangtonAnt;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

A separate section listing the public components of the module's interface.

These normally consist of either subroutines that may be exported, or methods
that may be called on objects belonging to the classes that the module
provides.

Name the section accordingly.

In an object-oriented module, this section should begin with a sentence (of the
form "An object of this class represents ...") to give the reader a high-level
context to help them understand the methods that are subsequently described.


=head3 C<new ( $search, )>

Param: C<$search> - type (detail) - description

Return: App::LangtonAnt -

Description:

=cut


=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate (even
the ones that will "never happen"), with a full explanation of each problem,
one or more likely causes, and any suggested remedies.

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module, including
the names and locations of any configuration files, and the meaning of any
environment variables or properties that can be set. These descriptions must
also include details of any configuration language used.

=head1 DEPENDENCIES

A list of all of the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules
are part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for system
or program resources, or due to internal limitations of Perl (for example, many
modules that use source code filters are mutually incompatible).

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication of
whether they are likely to be fixed in an upcoming release.

Also, a list of restrictions on the features the module does provide: data types
that cannot be handled, performance issues and the circumstances in which they
may arise, practical limitations on the size of data sets, special cases that
are not (yet) handled, etc.

The initial template usually just has:

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2016 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
