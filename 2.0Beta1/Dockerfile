FROM comics/samtools:1.3.1
MAINTAINER Ian Merrick <MerrickI@Cardiff.ac.uk>

##############################################################
# Dockerfile Version:   0.1
# Software:             stacks
# Software Version:     2.0Beta1
# Software Website:     http://catchenlab.life.illinois.edu/stacks/
# Description:          A software pipeline for building loci from short-read sequences.
##############################################################

ENV APP_NAME=stacks
ENV VERSION=2.0Beta1
ENV APPS=/software/applications
ENV DEST=$APPS/$APP_NAME/
ENV PATH=$APPS/$APP_NAME/$VERSION/bin:$PATH

RUN yum install -y \
      autoconf \
      automake \
      gcc \
      gmp-devel \
      httpd \
      libmpc-devel \
      mariadb \
      mod_php \
      mpfr-devel \
      perl-DBD-MySQL \
      perl-DBI \
      perl-File-Which \
      perl-Spreadsheet-WriteExcel \
      php-mysqlnd \
      zlib-devel ; \
    # a more up-to-dae-gcc
    yum install -y centos-release-scl-rh ; \
    yum install -y devtoolset-7-gcc* ; \
    source /opt/rh/devtoolset-7/enable ; \
    yum clean all ; \
    rm -rf /var/cache/yum ; \
    # sparsehash ####
    git clone https://github.com/sparsehash/sparsehash ; \
    cd sparsehash ; \
    git checkout tags/sparsehash-2.0.2 ; \
    mkdir -p  /usr/share/licenses/sparsehash-2.0.2 ; \
    cp COPYING /usr/share/licenses/sparsehash-2.0.2 ; \
    ./configure ; \
    make ; \
    make install ; \
    cd ../ ; \
    rm -rf sparsehash ; \
    # velvet #########
    git clone https://github.com/dzerbino/velvet ; \
    cd velvet ; \
    make cleanobj zlib obj velveth velvetg ; \
    mv velvet* /usr/local/bin/ ; \
    mkdir -p  /usr/share/licenses/velvet ; \
    cp LICENSE.txt /usr/share/licenses/velvet/ ; \
    cd ../ ; \
    rm -rf velvet ; \
    # stacks #########
    curl -L -o stacks-$VERSION.tar.gz http://catchenlab.life.illinois.edu/stacks/source/stacks-$VERSION.tar.gz ; \
    tar xzf stacks-$VERSION.tar.gz ; \
    cd stacks-$VERSION ; \
    ./configure --prefix=$DEST/$VERSION ; \
    make ; \
    make install ; \
    mkdir -p  /usr/share/licenses/stacks-$VERSION ; \
    cp LICENSE /usr/share/licenses/stacks-$VERSION/ ; \
    cp $DEST/$VERSION/share/stacks/php/constants.php.dist $DEST/$VERSION/share/stacks/php/constants.php ; \
    cp $DEST/$VERSION/share/stacks/sql/mysql.cnf.dist /root/.my.cnf ; \
    sed -i "s/\(^user=\).*/\1root/" /root/.my.cnf ; \
    sed -i "s/\(^\$db_user\).*/\1 = \"root\";/" $DEST/$VERSION/share/stacks/php/constants.php ; \
    sed -i "s/\(password=\).*/\1stacks/" /root/.my.cnf ; \
    sed -i "s/\(^\$db_pass\).*/\1 = \"stacks\";/" $DEST/$VERSION/share/stacks/php/constants.php ; \
    chown -R apache:apache $DEST/$VERSION/share/stacks/php ; \
    cd ../ ; \
    rm -rf stacks-$VERSION.tar.gz stacks-$VERSION

COPY stacks.conf /etc/httpd/conf.d/stacks.conf
COPY stacks_entrypoint.sh /usr/local/bin/stacks_entrypoint.sh
ENTRYPOINT ["/usr/local/bin/stacks_entrypoint.sh"]


