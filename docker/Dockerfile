FROM continuumio/miniconda3

RUN apt-get update \
    && apt-get --yes install wget jq git \
    && rm -rf /var/lib/apt/lists/*

# Default environment
RUN conda install --quiet --yes \
      -c conda-forge \
      "r-bayesplot" \
      "r-cowplot" \
      "r-data.table" \
      "r-dplyr" \
      "r-EnvStats" \
      "r-gdata" \
      "r-gdata"\
      "r-ggplot2" \
      "r-ggpubr" \
      "r-gridExtra" \
      "r-lubridate" \
      "r-matrixStats" \
      "r-readr" \
      "r-rstan" \
      "r-scales" \
      "r-tidyr" \
      "r-jsonlite" \
    && conda clean --all -f -y


# This will be mounted by the pachyderm
# pipeline.
ENTRYPOINT ["/pfs/git/main.sh"]
