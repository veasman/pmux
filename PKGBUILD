# Maintainer: Charlton Moren <veasman@github>
pkgname=pmux
pkgver=0.2.0
pkgrel=1
pkgdesc="Project multiplexer for tmux — launches dev projects into structured sessions"
arch=('any')
url="https://github.com/veasman/pmux"
license=('MIT')
depends=('bash' 'tmux' 'fzf')
optdepends=(
    'jq: npm script detection in pmux-run'
    'curl: cht.sh lookups via pmux-cheat'
    'nvm: automatic Node version switching via .nvmrc'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/veasman/$pkgname/archive/refs/tags/v$pkgver.tar.gz")
b2sums=('SKIP')

build() {
    : # nothing to compile
}

package() {
    cd "$pkgname-$pkgver"
    make install DESTDIR="$pkgdir" PREFIX=/usr
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
