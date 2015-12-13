#! /usr/bin/env perl
use 5.22.0;
use Data::Dumper;

my %vars = ();
my $var_regex = qr{^\$(.*): (.*);$};
my @source_lines;

# read in the source
while (<>) {
    chomp;
    if (my @match = /$var_regex/) {
        $vars{$match[0]} = $match[1];
    } else {
        push @source_lines, $_;
    }

}


# split into chunks
# add braces
my @chunks;
my @current_chunk;
for my $line (@source_lines) {
    if ($line =~ /^\w+(.*)$/) {
        push @chunks, \@current_chunk if scalar @current_chunk;
        @current_chunk = ("$line {");
    } elsif ($line eq '' && scalar @current_chunk) {
        push @current_chunk, "}";
        push @chunks, [@current_chunk];
        @current_chunk = ();
    } elsif ($line =~ /^\s+(.*)$/) {
        push @current_chunk, $line;
    }
}
if (scalar @current_chunk) {
    push @current_chunk, "}";
    push @chunks, [@current_chunk];
    @current_chunk = ();
}

say Dumper(\@chunks);



# do var substitution


# emit result


say '--------';

say Dumper(\%vars);

say '--------';

for (@source_lines) {
    say;
}

say '--------';
