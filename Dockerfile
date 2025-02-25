


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
    "python-lsp-server[all]" \
    pylsp-mypy \
    python-lsp-isort \
    python-lsp-black \
    pylsp-rope \
    python-lsp-ruff

    
COPY .config /root/build

RUN diff3 -m /root/.config/nvim/init.vim /root/build/.config/nvim/init.vim.bak /root/build/.config/nvim/init.vim > /root/.config/nvim/init.vim

