FROM rocker/r-ver:4.0.2
RUN apt-get update -qq && apt-get install -y \
      libssl-dev \
      libcurl4-gnutls-dev
MAINTAINER Gary Hutson, https://hutsons-hacks.info/
RUN R -e "install.packages('plumber', dependencies=TRUE)"
RUN R -e "install.packages('readr', dependencies=TRUE)"
RUN R -e "install.packages('yaml', dependencies=TRUE)"
RUN R -e "install.packages('caret', dependencies=TRUE)"
RUN R -e "install.packages('ipred', dependencies=TRUE)"
RUN R -e "install.packages('swagger', dependencies=TRUE)"
RUN R -e "install.packages('rapidoc', dependencies=TRUE)"
COPY / /
EXPOSE 80
ENTRYPOINT ["Rscript", "PlumbStranded.R"]