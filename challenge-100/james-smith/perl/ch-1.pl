#!/usr/local/bin/perl

use strict;

use warnings;
use feature qw(say);
use Test::More;

is( fun_time( '05:15pm' ), '17:15' );
is( fun_time( '05:15 pm' ), '17:15' );
is( fun_time( '17:15' ), '05:15pm' );
is( fun_time( '05:15am' ), '05:15' );
is( fun_time( '05:15 am' ), '05:15' );
is( fun_time( '05:15' ), '05:15am' );
is( fun_time( '00:00' ), '12:00am' );
is( fun_time( '12:00' ), '12:00pm' );
is( fun_time( '24:00' ), '12:00pm' );
is( fun_time( '12:00 am' ), '00:00' );
is( fun_time( '12:00 pm' ), '12:00' );

is( fun_time_readable( '05:15pm' ), '17:15' );
is( fun_time_readable( '05:15 pm' ), '17:15' );
is( fun_time_readable( '17:15' ), '05:15pm' );
is( fun_time_readable( '05:15am' ), '05:15' );
is( fun_time_readable( '05:15 am' ), '05:15' );
is( fun_time_readable( '05:15' ), '05:15am' );
is( fun_time_readable( '00:00' ), '12:00am' );
is( fun_time_readable( '12:00' ), '12:00pm' );
is( fun_time_readable( '24:00' ), '12:00pm' );
is( fun_time_readable( '12:00 am' ), '00:00' );
is( fun_time_readable( '12:00 pm' ), '12:00' );

done_testing();

## 72 chars ############################################################
sub fun_time {
  $_[0]=~s{\A(\d+):(\d+)\s*([ap]m|)\Z}{sprintf'%02d:%02d%s',
    ($1%12||($3?0:12))+('pm'eq$3?12:0),$2,$3?'':$1>11?'pm':'am'}regx;
}

sub fun_time_readable {
  return $_[0] =~
    s{
      \A (\d+) : (\d+) \s* ( [ap]m | ) \Z
        ## Split into 3 parts. The first reaction to the
        ## am/pm bit is to use ([ap]m)? but this means
        ## that the 3rd capture variable $3 is sometimes
        ## undefined - better is to use ([ap]m|) which
        ## matches the same way but $3 is now an empty
        ## string not undefined when we have a 24 hour
        ## clock time
    }
    {
      sprintf '%02d:%02d%s',

        ( $1%12 || ($3?0:12) ) + ( 'pm' eq $3 ? 12 : 0 ),
          ## Get hour modulo 12..
          ## If were in 24 hour clock we need to convert
          ## 00:?? to 12:??
          ## If it is pm we then need to add 12...
        $2,
          ## The minutes is the easy bit just copy..
        $3 ? '' : $1>11 ? 'pm' : 'am'
          ## If we are converting from 12hr clock the third
          ## string is empty - if not and the time is <12
          ## we return am o/w return pm
    }regx;
}

