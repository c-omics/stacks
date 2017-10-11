#!/bin/bash

# docker run --name mariadb-for-stacks -e MYSQL_ROOT_PASSWORD=stacks -d mariadb:5.5
# MYSQL_HOST=$(docker inspect  --format '{{ .NetworkSettings.IPAddress }}' mariadb-for-stacks)
# docker run --name stacks --link mariadb-for-stacks:mysql -it -v $PWD:$PWD -p 8080:80 -e MYSQL_HOST="$MYSQL_HOST" -e MYSQL_USER=root -e MYSQL_PWD=stacks comics/stacks:2.0Beta1 bash $PWD/example_pe.sh 

mkdir tutorial_pe
cd tutorial_pe
mkdir assembled  paired  raw  stacks samples
curl -L -o pe_samples.tar.gz http://catchenlab.life.illinois.edu/stacks/pe_tutorial/pe_samples.tar.gz 
cd samples
tar xzf ../pe_samples.tar.gz
cd ../

#cp -a /software/applications/stacks/2.0Beta1/share/stacks/sql/mysql.cnf.dist /root/.my.cnf
#sed -i "s/\(user=\).*/\1root/" /root/.my.cnf
#sed -i "s/\(password=\).*/\1stacks/" /root/.my.cnf
#sed -i "s/\(host=\).*/\1$MYSQL_HOST/" /root/.my.cnf

mysql -pstacks -e "CREATE DATABASE pe_radtags"
mysql -pstacks pe_radtags < /software/applications/stacks/2.0Beta1/share/stacks/sql/stacks.sql

denovo_map.pl -m 3 -M 3 -T 15 -B pe_radtags -b 1 -t \
  -D "Tutorial Paired-end RAD-Tags" \
  -o ./stacks \
  -p ./samples/f0_male.1.fq \
  -p ./samples/f0_female.1.fq
#ls stacks


# Collating and assembling paired-end reads
export_sql.pl -D pe_radtags -b 1 -a haplo -f haplotypes.tsv -o tsv -F snps_l=1
# ls
cut -f 1 haplotypes.tsv > whitelist.tsv
# ls
sort_read_pairs.pl -p ./stacks/ -s ./samples/ -o ./paired/ -w whitelist.tsv
# ls paired
exec_velvet.pl -s ./paired/ -o ./assembled/ -c -e /usr/local/bin -M 200

# Importing contigs into the database
load_sequences.pl -b 1 -D pe_radtags -f ./assembled/collated.fa -t pe_radtag
index_radtags.pl -D pe_radtags -c

# You can now view data in the web interface

