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
    driver     => 'FastMmap', 
    root_dir   => './cacheroot',
    cache_size => '1m',
);


my $user  = $cache->get($userid);

if ( !$user ) {
    $user = get_user( $dbh, $userid );
    $cache->set( $userid, $user, 3600 ); # 600 seconds
}
say $user->{firstname};


sub get_user {
    say "Fetching user from database";
    my $dbh = shift;
    my $id  = shift;
    my $query = 'SELECT * 
        FROM user
        WHERE userid = ?';
    sleep 10;
    my $result = $dbh->selectrow_hashref(
        $query, undef, $id
    );
}
