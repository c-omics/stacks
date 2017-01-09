#!/bin/bash

# docker run --name mariadb-for-stacks -e MYSQL_ROOT_PASSWORD=stacks -d mariadb:5.5
# docker run --name stacks  --link mariadb-for-stacks:mysql -it bigr.bios.cf.ac.uk:4567/comics/stacks:1.44 bash $PWD/example_pe.sh 

mkdir tutorial_pe
cd tutorial_pe
#mkdir assembled  paired  raw  stacks
#curl -L -o pe_samples.tar.gz http://catchenlab.life.illinois.edu/stacks/pe_tutorial/pe_samples.tar.gz 
#tar xzf pe_samples.tar.gz
#mv pe_samples samples
#rm -f pe_samples.tar.gz

mysql -pstacks -e "CREATE DATABASE pe_radtags"
mysql -pstacks pe_radtags < /usr/local/share/stacks/sql/stacks.sql

denovo_map.pl -m 3 -M 3 -T 15 -B pe_radtags -b 1 -t \
  -D "Tutorial Paired-end RAD-Tags" \
  -o ./stacks \
  -p ./samples/f0_male.1.fq \
  -p ./samples/f0_female.1.fq

# Collating and assembling paired-end reads
export_sql.pl -D pe_radtags -b 1 -a haplo -f haplotypes.tsv -o tsv -F snps_l=1
cut -f 1 haplotypes.tsv > whitelist.tsv
sort_read_pairs.pl -p ./stacks/ -s ./samples/ -o ./paired/ -w whitelist.tsv

exec_velvet.pl -s ./paired/ -o ./assembled/ -c -e /usr/local/bin -M 200

# Importing contigs into the database
load_sequences.pl -b 1 -D pe_radtags -f ./assembled/collated.fa -t pe_radtag
index_radtags.pl -D pe_radtags -c

# You can now view data in the web interface

