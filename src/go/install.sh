#!/bin/sh
# MIT License
#
# Copyright (c) 2024 Bart Venter <bartventer@outlook.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#-----------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/bartventer/arch-devcontainer-features/tree/main/src/go/README.md
# Maintainer: Bart Venter <https://github.com/bartventer>

set -e

GOLANGCI_LINT_VERSION=${GOLANGCILINTVERSION:-"latest"}
INSTALL_GO_RELEASER=${INSTALLGORELEASER:-"false"}
INSTALL_GOX=${INSTALLGOX:-"false"}
INSTALL_KO=${INSTALLKO:-"false"}
INSTALL_YAEGI=${INSTALLYAEGI:-"false"}
INSTALL_AIR=${INSTALLAIR:-"false"}
INSTALL_COBRA_CLI=${INSTALLCOBRACLI:-"false"}

UTIL_SCRIPT="/usr/local/bin/archlinux_util.sh"

# Check if the utility script exists
if [ ! -f "$UTIL_SCRIPT" ]; then
    echo "Cloning archlinux_util.sh from GitHub to $UTIL_SCRIPT"
    curl -o "$UTIL_SCRIPT" https://raw.githubusercontent.com/bartventer/arch-devcontainer-features/main/scripts/archlinux_util.sh
    chmod +x "$UTIL_SCRIPT"
fi

# Source the utility script
# shellcheck disable=SC1091
# shellcheck source=scripts/archlinux_util.sh
. "$UTIL_SCRIPT"

# Source /etc/os-release to get OS info
# shellcheck disable=SC1091
# shellcheck source=/etc/os-release
. /etc/os-release

# Run checks
check_root
check_system
check_pacman

# Install Go
# go-tools: https://gitlab.archlinux.org/archlinux/packaging/packages/go-tools/-/blob/main/PKGBUILD?ref_type=heads
PACKAGES="go go-tools delve which"
if [ "$INSTALL_GO_RELEASER" = "true" ]; then
    PACKAGES="$PACKAGES goreleaser"
fi
if [ "$INSTALL_GOX" = "true" ]; then
    PACKAGES="$PACKAGES gox"
fi
if [ "$INSTALL_KO" = "true" ]; then
    PACKAGES="$PACKAGES ko"
fi
if [ "$INSTALL_YAEGI" = "true" ]; then
    PACKAGES="$PACKAGES yaegi"
fi
# shellcheck disable=SC2086
check_and_install_packages $PACKAGES

GO_TOOLS="\
    golang.org/x/tools/gopls@latest \
    github.com/golangci/golangci-lint/cmd/golangci-lint@${GOLANGCI_LINT_VERSION} \
    honnef.co/go/tools/cmd/staticcheck@latest \
    github.com/mgechev/revive@latest \
    github.com/incu6us/goimports-reviser/v2@latest \
    github.com/segmentio/golines@latest \
    github.com/fatih/gomodifytags@latest \
    github.com/cweill/gotests/gotests@latest \
    github.com/josharian/impl@latest \
    golang.org/x/lint/golint@latest \
    github.com/haya14busa/goplay/cmd/goplay@latest"

# Add Air to the list of Go tools
if [ "$INSTALL_AIR" = "true" ]; then
    GO_TOOLS="${GO_TOOLS} github.com/cosmtrek/air@latest"
fi

# Add Cobra CLI to the list of Go tools
if [ "$INSTALL_COBRA_CLI" = "true" ]; then
    GO_TOOLS="${GO_TOOLS} github.com/spf13/cobra-cli@latest"
fi

echo_msg "Installing Go tools..."
echo "${GO_TOOLS}" | xargs -n 1 go install

echo "Done. Successfully installed Go and Go tools."