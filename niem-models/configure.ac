# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([NIEM Metamodel],[0],[https://github.com/NIEM/NIEM-Metamodel/issues],[niem-metamodel],[https://github.com/NIEM/NIEM-Metamodel])

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_MKDIR_P
AC_PROG_SED

default_doc_name=`basename $PWD`
default_docs_dir="\${top_srcdir}/../docs/${default_doc_name}"
if test "x$docs_dir" = "x"
then docs_dir=$default_docs_dir
     echo "Variable docs_dir not set. Using default (docs_dir=$docs_dir)"
fi
AC_SUBST([docs_dir],[$docs_dir])

# AC_PATH_PROG(var,prog)
# test "x$var" = "x" && AC_MSG_ERROR([var not found])

# AC_PATH_PROG(same,same)
# test "x$same" = "x" && AC_MSG_ERROR([same not found])

# AC_PATH_PROGS(var,prog1 prog2 prog3)
# test "xvar" = "x" && AC_MSG_ERROR([var not found])

# only put critical programs required to build 'all' here.

AC_PATH_PROG(bash,bash)
test "x$bash" = "x" && AC_MSG_ERROR([bash not found])

AC_PATH_PROG(dot,dot)
test "x$dot" = "x" && AC_MSG_ERROR([dot not found])

AC_PATH_PROG(m4,m4)
test "x$m4" = "x" && AC_MSG_ERROR([m4 not found])

AC_PATH_PROG(realpath,realpath)
test "x$realpath" = "x" && AC_MSG_ERROR([realpath not found])

AC_PATH_PROG(saxon,saxon)
test "x$saxon" = "x" && AC_MSG_ERROR([saxon not found])

AC_PATH_PROG(schematron_compile,schematron-compile)
test "x$schematron_compile" = "x" && AC_MSG_ERROR([schematron_compile not found])

AC_PATH_PROG(schematron_execute,schematron-execute)
test "x$schematron_execute" = "x" && AC_MSG_ERROR([schematron_execute not found])

AC_PATH_PROG(xmllint,xmllint)
test "x$xmllint" = "x" && AC_MSG_ERROR([xmllint not found])

AC_PATH_PROG(xs_validate,xs-validate)
test "x$xs_validate" = "x" && AC_MSG_ERROR([xs_validate not found])

AC_CONFIG_FILES([Makefile], [chmod 444 Makefile])
AC_CONFIG_FILES([docs-source/Makefile], [chmod 444 docs-source/Makefile])
AC_SUBST([config_files],$ac_config_files)
AC_OUTPUT
