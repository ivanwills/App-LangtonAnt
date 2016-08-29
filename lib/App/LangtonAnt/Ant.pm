package App::LangtonAnt::Ant;

# Created on: 2016-08-28 20:21:57
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moo;
use warnings;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use Types::Standard qw/Int ArrayRef InstanceOf/;
use Term::ANSIColor qw/colored/;
use Term::Screen;

our $VERSION = 0.001;

has [qw/row col/] => (
    is       => 'rw',
    isa      => Int,
    required => 1,
);
has moves => (
    is      => 'rw',
    isa     => Int,
    default => 0,
);
has dir => (
    is       => 'rw',
    required => 1,
    isa      => sub {
        my $dir = shift;
        die "Invalid direction! ($dir)"
            if $dir != 0 && $dir != 1 && $dir != 2 && $dir !=3;
    },
);
has screen => (
    is      => 'ro',
    default => sub { Term::Screen->new },
    lazy    => 1,
    handles => {
        at   => 'at',
        puts => 'puts',
    }
);

sub draw {
    my ($self) = @_;
    $self->at( $self->row, $self->col );
    $self->puts(
        colored(
            ['blue', 'on_green'],
            $self->dir == 0   ? '↑'
            : $self->dir == 1 ? '→'
            : $self->dir == 2 ? '↓'
            :                   '←'
        )
    );
}

sub move {
    my ($self, $on_color) = @_;
    my $reverse = $on_color eq 'white';
    $self->moves( $self->moves + 1 );

    my $dir = $reverse ? $self->dir - 1 : $self->dir + 1;
    $dir = $dir < 0 ? 3 : $dir > 3 ? 0 : $dir;

    if ( $dir == 0 ) {
        # move up
        $self->row( $self->row - 1 );
    }
    elsif ($dir == 1 ) {
        # right
        $self->col( $self->col + 1 );
    }
    elsif ($dir == 2 ) {
        # down
        $self->row( $self->row + 1 );
    }
    elsif ($dir == 3 ) {
        # left
        $self->col( $self->col - 1 );
    }
    $self->dir($dir);

    return $reverse ? 'black' : 'white';
}

sub teleport {
    my ($self, $height, $width) = @_;

    if ( $self->row < 0 ) {
        $self->row( $height - 1 );
    }
    elsif ( $self->col < 0 ) {
        $self->col( $width - 1 );
    }
    elsif ( $self->row >= $height ) {
        $self->row(0);
    }
    elsif ( $self->col >= $width ) {
        $self->col(0);
    }

    return $self;
}

1;

__END__

=head1 NAME

App::LangtonAnt::Ant - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to App::LangtonAnt::Ant version 0.0.1


=head1 SYNOPSIS

   use App::LangtonAnt::Ant;

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

Return: App::LangtonAnt::Ant -

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
