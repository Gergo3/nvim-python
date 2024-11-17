


FROM gergo111/nvim-base AS python-3

#install packages
RUN pacman -Syu --noconfirm --noprogressbar --needed\
    python \
    python-pip \
    python-pipx \
    python-setuptools \
    && pacman -Scc

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir \
    python-lsp-server \
    "python-lsp-server[all]"

    

