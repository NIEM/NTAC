# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([NIEM Metamodel],[0],[https://github.com/NIEM/NIEM-Metamodel/issues],[niem-metamodel],[https://github.com/NIEM/NIEM-Metamodel])

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_MKDIR_P
AC_PROG_SED

dnl check_prog( $command-name )
dnl   e.g., check_prog(bash) will set @bash@
AC_DEFUN([check_prog],[AC_PATH_PROG($1,$1)
  test "x$[]$1" = "x" && AC_MSG_ERROR([$1 not found])])dnl

dnl check_prog_options( $command-short-name, $command-name-options ... )
dnl   e.g., check_prog_options(cat, gcat cat) will set @cat@
AC_DEFUN([check_prog_options],[AC_PATH_PROGS($1,$2)
  test "x$[]$1" = "x" && AC_MSG_ERROR([$1 not found])])dnl

# only put critical programs required to build 'all' here.

check_prog(bash)
check_prog(dot)
check_prog(m4)
check_prog(xmllint)
check_prog_options(xs_validate,xs-validate)
check_prog_options(schematron_compile,schematron-compile)
check_prog_options(schematron_execute,schematron-execute)

AC_PATH_PROG(saxon,saxon)
test "x$saxon" = "x" && AC_MSG_ERROR([saxon not found])

#AC_PATH_PROG([xmllint],[xmllint],[xmllint])

AC_CONFIG_FILES([Makefile], [chmod 444 Makefile])
AC_CONFIG_FILES([docs-src/Makefile], [chmod 444 docs-src/Makefile])
AC_CONFIG_FILES([metamodel-core/Makefile], [chmod 444 metamodel-core/Makefile])
AC_SUBST([config_files],$ac_config_files)
AC_OUTPUT
