FROM jogit/sharelatex-base:texlive2026--full-29d5715dc2e2a7029a21164b4dbdf59d59e1ce53
RUN apt-get update \
    && apt-get install -y \
    libyaml-tiny-perl \
    libfile-homedir-perl \
    liblog-log4perl-perl \
    bat \
    ncdu \
    tree \
    fonts-noto-cjk

