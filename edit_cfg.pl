#!perl -p -i0

# We expect the following arguments:
#
# privlib	- which file to edit (the directory part - new privlib)

sub mydie {
  print STDERR <<EOF;
The following error was discovered while editing Config.pm
at $newconfig_long/Config.pm:
@_
Press ENTER to exit.
EOF
<>;
die "\n";
}

BEGIN {
  $SIG{__DIE__} = \&mydie;
  ($perllib_new) = @ARGV;
  $config_long = 'i:/perllib/lib/5.8.2/os2';	# Hardwired during creation
  $config_short = 'i:/perllib/lib';	# Hardwired during creation
  $privlibtail = '/5.8.2';	# Hardwired during creation
  $sitelibtail = '/5.8.2';	# Hardwired during creation
  $dirs{emx} = 'i:/emx';	# Hardwired during creation
  $dirs{bin} = 'i:/perllib/bin';	# Hardwired during creation
  $dirs{man1dir} = 'i:/perllib/man/man1';	# Hardwired during creation
  $dirs{man3dir} = 'i:/perllib/man/man3';	# Hardwired during creation
  $dirs{privlib} = 'i:/perllib/lib/5.8.2';	# Hardwired during creation
  $dirs{shell} = 'i:/BIN';	# Hardwired during creation
  $dirs{sitelib} = 'i:/perllib/lib/site_perl/5.8.2';	# Hardwired during creation
  $change_from{man1dir} = 'man1dir';	# Hardwired during creation
  $change_from{bin} = 'bin';	# Hardwired during creation
  $change_from{installsiteman1dir} = 'man1dir';	# Hardwired during creation
  $change_from{sitelib} = 'sitelib';	# Hardwired during creation
  $change_from{man3direxp} = 'man3dir';	# Hardwired during creation
  $change_from{emxpath} = 'emx';	# Hardwired during creation
  $change_from{timeincl} = 'emx';	# Hardwired during creation
  $change_from{libc} = 'emx';	# Hardwired during creation
  $change_from{sitescriptexp} = 'bin';	# Hardwired during creation
  $change_from{sh} = 'shell';	# Hardwired during creation
  $change_from{scriptdir} = 'bin';	# Hardwired during creation
  $change_from{perlpath} = 'bin';	# Hardwired during creation
  $change_from{sitelibexp} = 'sitelib';	# Hardwired during creation
  $change_from{libpth} = 'emx';	# Hardwired during creation
  $change_from{scriptdirexp} = 'bin';	# Hardwired during creation
  $change_from{man1direxp} = 'man1dir';	# Hardwired during creation
  $change_from{yacc} = 'emx';	# Hardwired during creation
  $change_from{installprivlib} = 'privlib';	# Hardwired during creation
  $change_from{usrinc} = 'emx';	# Hardwired during creation
  $change_from{binexp} = 'bin';	# Hardwired during creation
  $change_from{sitearchexp} = 'sitelib';	# Hardwired during creation
  $change_from{siteman1dir} = 'man1dir';	# Hardwired during creation
  $change_from{archlibexp} = 'privlib';	# Hardwired during creation
  $change_from{sitescript} = 'bin';	# Hardwired during creation
  $change_from{installsitelib} = 'sitelib';	# Hardwired during creation
  $change_from{archlib} = 'privlib';	# Hardwired during creation
  $change_from{aphostname} = 'emx';	# Hardwired during creation
  $change_from{privlib} = 'privlib';	# Hardwired during creation
  $change_from{installman3dir} = 'man3dir';	# Hardwired during creation
  $change_from{installsitearch} = 'sitelib';	# Hardwired during creation
  $change_from{privlibexp} = 'privlib';	# Hardwired during creation
  $change_from{libemx} = 'emx';	# Hardwired during creation
  $change_from{installsiteman3dir} = 'man3dir';	# Hardwired during creation
  $change_from{full_sed} = 'emx';	# Hardwired during creation
  $change_from{installarchlib} = 'privlib';	# Hardwired during creation
  $change_from{installman1dir} = 'man1dir';	# Hardwired during creation
  $change_from{siteman1direxp} = 'man1dir';	# Hardwired during creation
  $change_from{sitebinexp} = 'bin';	# Hardwired during creation
  $change_from{siteman3direxp} = 'man3dir';	# Hardwired during creation
  $change_from{sitearch} = 'sitelib';	# Hardwired during creation
  $change_from{man3dir} = 'man3dir';	# Hardwired during creation
  $change_from{siteman3dir} = 'man3dir';	# Hardwired during creation
  $change_from{sitebin} = 'bin';	# Hardwired during creation
  $change_from{installscript} = 'bin';	# Hardwired during creation
  $change_from{installsitebin} = 'bin';	# Hardwired during creation
  $change_from{installbin} = 'bin';	# Hardwired during creation
  $change_from{strings} = 'emx';	# Hardwired during creation
  $change_from{installsitescript} = 'bin';	# Hardwired during creation
  $change_from{startsh} = 'shell';	# Hardwired during creation
  $change_from{perl5} = 'bin';	# Hardwired during creation
  $config_dat = "$perllib_new/config.dat";
  open DAT, $config_dat or die "Cannot open $config_dat: $!";
  while (<DAT>) {
    $newdir{$1} = $2 if /^(\w+)\s+(.*)$/;
  }
  close DAT or die "Cannot close $config_dat: $!";
  for $key (keys %newdir) {
    $newdir{$key} =~ s,\\,/,g;
  }
  $newdir{privlib} .= $privlibtail if $privlibtail and $newdir{privlib};
  $newdir{sitelib} .= $sitelibtail if $sitelibtail and $newdir{sitelib};
  $config_rest = substr $config_long, length $config_short;
  $newconfig_long = $perllib_new . $config_rest;
  @ARGV = $newconfig_long . '/Config.pm';
  # Try to find emx location:
  if (exists $ENV{C_INCLUDE_PATH}) {
    for $dir (split ';', $ENV{C_INCLUDE_PATH}) {
      $dir =~ s,\\,/,g ;
      $dir =~ s,/[^/]+/?$,,;
      $emx = $dir, last if -f "$dir/bin/emxrev.cmd";	# Random check.
    }
  }
  unless (defined $emx) {
    for $dir (split ';', $ENV{PATH}) {
      next unless $dir =~ /^[a-z]:\\emx\\bin\\?$/i ;
      $dir =~ s,\\,/,g ;
      $dir =~ s,/[^/]+/?$,,;
      $emx = $dir, last if -f "$dir/bin/emxrev.cmd";	# Random check.
    }
  }
  $newdir{emx} = $emx if defined $emx;
}

# Called inside -p loop
$count++;
if (/^(\w+)='(.*)'$/ and exists $change_from{$1} 
    and exists $newdir{$change_from{$1}}) {
  # Need to substitute
  my ($key, $val, $from, $to) 
    = ($1, $2, $dirs{$change_from{$1}}, $newdir{$change_from{$1}});
  $val =~ s/\Q$from\E/$to/g;		# g for the sake of libs - which is not edited now
  $_ = "$key='$val'\n";
}

END {
  die "Empty file" unless $count;
  print <<EOF;
==========================================================================
Apparently your installation finished successfully.  To enable the changes
to config.sys you may need to reboot your computer.

After this please run the script testperl.cmd to check the
installation (script is installed if perl_utl.zip distribution is installed).

Press ENTER to finish (or wait 5 min).
EOF
  $SIG{ALRM} = sub { exit };
  alarm 300;
  <>;
}
