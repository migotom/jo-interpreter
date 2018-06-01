use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME		=> 'Jo',
	VERSION_FROM	=> 'lib/Jo.pm',
	AUTHOR		=> 'Tomasz Kolaj <tomasz246@gmail.com>',
	EXE_FILES	=> [ 'jo' ],
	PREREQ_PM => {
		'Moo'			=> '2.000002',
		'Test::More' 		=> '1.0',
		'Test::Exception'	=> '0.43',
		'Test::Output' 		=> '1.03',
		'experimental' 		=> '0.013',
		'Data::Dumper'		=> '2.158',
	}
);
