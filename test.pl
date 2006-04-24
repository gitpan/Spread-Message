#!/usr/bin/perl -w

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

my $name   = "$$";

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 6 };
use Spread::Message;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my $mbox = Spread::Message->new(
		spread_name => '4803@localhost',
        name  => $name,
        group => ['polling-changes','polling-ctl'],
        debug => 0,
);
if(defined $mbox)
{
	ok(1);
}
else
{
	print "Can't open a Spread mailbox\n";
	ok(0);
}

print "=" x 10, "\n" x 2;
if($mbox->connect)
{
	ok(1);
	$mbox->rx(2); $mbox->rx(2);
}
else
{
	ok(0);
}
print "Joined :", join(",",$mbox->joined), " \n";
$mbox->leave('polling-changes');
print "Joined :", join(",",$mbox->joined), " \n";
$mbox->rx(2,"a test");
print "=" x 10, "\n" x 2;

if($mbox->new_msg)
{
	ok(1);
}
else
{
	ok(0);
}


if($mbox->join("testgrp"))
{
	ok(1);
	print "Joined :", join(",",$mbox->joined), " \n";
	$mbox->rx(2); $mbox->rx(2);
}
else
{
	ok(0);
}
print "=" x 10, "\n" x 2;

$mbox->disconnect;
$mbox->connect;
$mbox->rx(3); $mbox->rx(3);
print "=" x 10, "\n" x 2;

$mbox->send($mbox->me,"aaa" x 20);
$mbox->rx();
print "=" x 10, "\n" x 2;
ok(1);

# while(1)
# {
# 	$mbox->rx(60);
# }

exit;
sub heartbeat
{
        my $mbox = shift;
        my $loop = shift;
}

sub process_control
{
        my $mbox = shift;
        my $loop = shift;

}

sub process_data
{
        my $mbox = shift;
        my $loop = shift;

        return unless $mbox->new_msg;

        if($mbox->aimed_at_me)
        {
                return;
        }
}
