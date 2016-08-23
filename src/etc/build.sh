#!/bin/bash
#
# Build script for <PACKAGE>
#
# This build script is meant to be executed from within the source directory
# created by extracting the tarball.
#
# It will create 6 log files in the $HOME directory:
#   configure.log: All messages output during configure
#   configure.err: Just the errors output during configure
#   make.log: All messages output during make
#   make.err: Just the errors output during make
#   install.log: All messages output during make install
#   install.err: Just the errors output during make install
#
# After running the script you should check the *.err files to see
# if any problems have occurred. If that is the case, use the corresponding
# *.log files to see the error messages in context.

# Options:
#   -d   download sources
#   -u   unpack sources and enter sources directory
#   -c   configure package
#   -m   compile the sources
#   -i   install the package
#   -b   equivalent to -cm
#   -a   equivalent to -cmi 
# 
# Options must be given as one argument, e.g. -du, not -d -u.

# Note: the ":;" before the "}" in *_commands() is a no-op that makes sure 
# that the function remains syntactically valid, even if you remove its
# contents (e.g. remove the "configure" line, because there's nothing to 
# configure for the package).

download_commands()
{ :
  : wget $url
}

unpack_commands()
{ :
  : tar xf src.tgz
  : cd srcdir/
}

configure_commands()
{ :
  ./configure --prefix=/usr
}

make_commands()
{ :
  make
}

install_commands()
{ :
  make install
}

# build.conf should redefine the above functions for each particular
# package
[ -f ~/build.conf ] &&
  . ~/build.conf

test_pipe()
{
  for i in "${PIPESTATUS[@]}" 
  do
    test $i != 0 && { echo FAILED! ; exit 1 ; }
  done
  echo successful!
  return 0
}

_args=${1:--a}
case $_args in
	-*d*)
		echo Downloading...
		download_commands
		test_pipe
	;;&
	-*u*)
		echo Unpacking...
		unpack_commands
		test_pipe
	;;&
	-*a*|-*c*|-*b*)
		echo -n Configuring...

		{ configure_commands 3>&1 1>&2 2>&3 | tee "$HOME/configure.err" ;} &>"$HOME/configure.log"
		test_pipe
		# NOTE: Simply using && instead of test_pipe would not work, because &&
		# only tests the exit status of the last command in the pipe, which is tee.

	;;&
	-*a*|-*m*|-*b*)
		echo -n Building...

		{ make_commands 3>&1 1>&2 2>&3 | tee "$HOME/make.err" ;} &>"$HOME/make.log"
		test_pipe
	;;&
	-*a*|-*i*)
		echo -n Installing...

		{ install_commands 3>&1 1>&2 2>&3 | tee "$HOME/install.err" ;} &>"$HOME/install.log"
		test_pipe
	;;
esac


