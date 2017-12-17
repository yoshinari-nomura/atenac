# * Dockerfile for atenac
#   https://github.com/yoshinari-nomura/atenac
#
# * How to build
#   $ docker build -t nom4476/atenac .
#
# * How to run
#   $ docker run -it --rm -v $PWD:/workdir nom4476/atenac
#   (Invoke bash in Docker container)
#   # atenac address-file.org > atena.tex
#   # platex atena.tex
#   # dvipdfmx atena.dvi
#
# * See also
#   https://github.com/Paperist/docker-alpine-texlive-ja/blob/master/Dockerfile
#   https://hub.docker.com/r/paperist/alpine-texlive-ja/
#
FROM paperist/alpine-texlive-ja

MAINTAINER nom@quickhack.net

RUN apk --no-cache add ruby
RUN wget -qO- https://raw.githubusercontent.com/yoshinari-nomura/atenac/master/atenac \
    > /usr/local/bin/atenac && chmod +x /usr/local/bin/atenac

CMD ["bash"]
