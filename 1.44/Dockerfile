FROM comics/centos
MAINTAINER Ian Merrick <MerrickI@Cardiff.ac.uk>

##############################################################
# Dockerfile Version:   0.1
# Software:             stacks
# Software Version:     1.44
# Software Website:     http://catchenlab.life.illinois.edu/stacks/
# Description:          A software pipeline for building loci from short-read sequences.
##############################################################

ENV APP_NAME=stacks
ENV VERSION=1.44
ENV APPS=/software/applications
ENV DEST=$APPS/$APP_NAME/
ENV PATH=$APPS/$APP_NAME/$VERSION/bin:$PATH

RUN yum install -y \ 
      mariadb \
      zlib-devel ; \
    yum clean all ; \
    # sparsehash ####
    git clone https://github.com/sparsehash/sparsehash ; \
    cd sparsehash ; \
    git checkout tags/sparsehash-2.0.2 ; \
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
    cd ../ ; \
    rm -rf velvet ; \
    # stacks #########
    curl -L -o stacks-$VERSION.tar.gz http://catchenlab.life.illinois.edu/stacks/source/stacks-$VERSION.tar.gz ; \
    tar xzf stacks-$VERSION.tar.gz ; \
    cd stacks-$VERSION ; \
    ./configure --enable-sparsehash --prefix=$DEST/$VERSION ; \
    make ; \
    make install ; \
    cd ../ ; \
    rm -rf stacks-$VERSION.tar.gz stacks-$VERSION

CMD ["/bin/bash"]

