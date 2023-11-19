FROM ubuntu

# Prepare apt-get
RUN apt-get update
RUN apt-get upgrade -y

# Install prerequisites
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y gettext
RUN apt-get install -y make
RUN apt-get install -y cmake
RUN apt-get install -y file

# Install Neovim
RUN git clone https://github.com/neovim/neovim tmp/neovim/
WORKDIR tmp/neovim/
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo 
WORKDIR build/
RUN cpack -G DEB 
RUN dpkg -i nvim-linux64.deb

# Uninstall unnecessary programs
RUN apt-get remove -y make
RUN apt-get remove -y cmake
RUN apt-get remove -y gettext
RUN apt-get remove -y file

# Install ripgrep for Telescope plugin
RUN apt-get install -y ripgrep
RUN apt-get install -y unzip

# Create user
RUN adduser xtm
RUN passwd -l root
USER xtm
WORKDIR /home/xtm/

# Add Kickstart.nvim to config
RUN git clone https://github.com/xtmgit/kickstart.nvim "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# Install plugins
RUN nvim --headless -c "sleep 15" -c qa
