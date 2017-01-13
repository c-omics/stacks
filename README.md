# stacks

stacks license: GPLv3

## Useful Links

 * [package web-site](http://catchenlab.life.illinois.edu/stacks/)
 * [container github-site](https://github.com/c-omics/stacks)
 * [Docker Hub](https://hub.docker.com/u/comics/)

## Example Usage
See the [container github-site](https://github.com/c-omics/) for further usage documentation.

To start a container:
```
docker run -it comics/stacks bash
```

## Example
The example follows the stacks
tutorial on [building mini-contigs from paired-end sequences](http://catchenlab.life.illinois.edu/stacks/pe_tut.php).

```
docker run --name stacks \
            -it \
            -p 8080:80 
            -e MYSQL_HOST="some_host" -e MYSQL_USER="some_user" -e MYSQL_PWD="some_password" 
             comics/stacks bash 
```

Obtain the example [bash script](https://github.com/c-omics/stacks/raw/master/1.44/example_pe.sh) from the comics/stacks repository
and run:

```
curl -L https://github.com/c-omics/stacks/raw/master/1.44/example_pe.sh | bash
```

Once the mysql database has been populated, you may point your host's web browser to ```localhost:8080/stacks``` to
see the stacks web-interface.


