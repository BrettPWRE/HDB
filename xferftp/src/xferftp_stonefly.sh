#! /bin/sh
ncftpput -e sevier.ftperr -m -f account.dat sevier/ /zipdata/slc/xfer/sevier/*.xfr
ncftpput -e weber.ftperr -m -f account.dat weber/ /zipdata/slc/xfer/weber/*.xfr
ncftpput -e price.ftperr -m -f account.dat price/ /zipdata/slc/xfer/price/*.xfr
ncftpput -e paradox.ftperr -m -f account.dat paradox/ /zipdata/slc/xfer/paradox/*.xfr
ncftpput -e mancos.ftperr -m -f account.dat mancos/ /zipdata/slc/xfer/mancos/*.xfr
