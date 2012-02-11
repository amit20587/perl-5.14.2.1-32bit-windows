@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!/usr/bin/perl
#line 15
package Perl::PrereqScanner::App;
{
  $Perl::PrereqScanner::App::VERSION = '1.009';
}
# ABSTRACT: scan your working dir for likely prereqs

use strict;
use warnings;

use File::Spec::Functions qw{ catdir updir };
use FindBin qw{ $Bin };
use lib catdir( $Bin, updir, 'lib' );

use List::Util qw{ max };
use Perl::PrereqScanner;
use CPAN::Meta::Requirements ();

use Getopt::Long qw{ GetOptions };
my %options;
GetOptions(
  \%options,
  'combine!',
);
my $combined = $options{combine} && CPAN::Meta::Requirements->new;

foreach my $file ( @ARGV ) {
    my $prereqs = Perl::PrereqScanner->new->scan_file($file);
    if( $options{combine} ){
        $combined->add_requirements($prereqs);
    }
    else {
        print "* $file\n";
        print_prereqs($prereqs);
    }
}

if( $options{combine} ){
    print_prereqs($combined);
}

sub print_prereqs {
    my $prereqs = shift->as_string_hash;
    my $max = max map { length } keys %$prereqs;
    printf( "%-${max}s = %s\n", $_, $prereqs->{$_} )
        for sort keys %$prereqs;
}

exit;

__END__
=pod

=head1 NAME

Perl::PrereqScanner::App - scan your working dir for likely prereqs

=head1 VERSION

version 1.009

=head1 AUTHORS

=over 4

=item *

Jerome Quelin

=item *

Ricardo Signes <rjbs@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
:endofperl
