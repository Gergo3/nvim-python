


FROM gergo111/nvim-base AS python-3

#add ~/.local/bin to path
ENV PATH="$HOME/.local/bin:${PATH}"

#install packages
RUN pacman -Syu --noconfirm --noprogressbar --needed\
    python \
    python-pip \
    python-pipx \
    python-setuptools \
    && pacman -Scc --noconfirm --noprogressbar --needed

RUN pipx ensurepath &&\
    source ~/.bashrc &&\
    pipx install \
    "python-lsp-server[all]" \
    debugpy \
    && pipx inject \
    python-lsp-server \
    pylsp-mypy \
    python-lsp-isort \
    python-lsp-black \
    pylsp-rope \
    python-lsp-ruff
#    ln -s /root/.local/share/pipx/venvs/python-lsp-server/bin/pylsp /usr/local/bin/pylsp
    
COPY .config /root/build/.config

#RUN $[ -e /root ] && echo a
#RUN $[ -e /root/.config ] && echo a
#RUN $[ -e /root/.config/nvim ] && echo a

#RUN cat /root/build/.config/nvim/init.vim

RUN diff3 -m /root/.config/nvim/init.vim /root/build/.config/nvim/init.vim.bak /root/build/.config/nvim/init.vim > /root/.config/nvim/init.vim.new \
    && cat /root/.config/nvim/init.vim.new > /root/.config/nvim/init.vim

RUN nvim +PlugInstall +qall

RUN nvim +TSUpdate +qall
