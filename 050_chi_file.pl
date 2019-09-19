#!/usr/bin/env perl
use strict;
use warnings;
use v5.010; ## import `say`
use DBI;
use CHI;
use Data::Printer;

my $userid = 1; #userid for "Ben Kaufman"

my $dbh = DBI->connect( 
    'dbi:SQLite:dbname=./data.sqlite3',
);

my $cache = CHI->new( 
    driver         => 'File',
    root_dir       => './filecacheroot',
    depth          => 3,
    max_key_length => 64,
);

my $user  = $cache->compute(
    $userid,
    "10 sec", 
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
