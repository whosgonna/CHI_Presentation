#!/usr/bin/env perl
use strict;
use warnings;
use v5.010; ## import `say`
use DBI;
use CHI;

my $userid = 1; #userid for "Ben Kaufman"

my $dbh = DBI->connect( 
    'dbi:SQLite:dbname=./data.sqlite3',
);

my $cache = CHI->new( 
    driver => 'Memory', 
    global => 0 
);
my $user  = $cache->compute(
    $userid,
    "1 minute", # Human friendly duration!
    sub { get_user( $dbh, $userid ) },   
);

say $user->{firstname};


sub get_user {
    say "Fetching user from database";
    my $dbh = shift;
    my $id  = shift;
    my $query = 'SELECT * 
        FROM user
        WHERE userid = ?';
    my $result = $dbh->selectrow_hashref(
        $query, undef, $id
    );
}
