#!/bin/bash

# ============================================
# Script para probar el instalador en Docker
# ============================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Testing Dotfiles Installer in Docker${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Verificar que Docker está instalado
if ! command -v docker >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker no está instalado${NC}"
    echo "Instala Docker desde: https://docs.docker.com/get-docker/"
    exit 1
fi

# Construir la imagen
echo -e "${BLUE}==> Construyendo imagen Docker...${NC}"
docker build -f Dockerfile.test -t dotfiles-test .
echo -e "${GREEN}✓ Imagen construida${NC}"
echo ""

# Ejecutar el contenedor con el script de instalación
echo -e "${BLUE}==> Iniciando contenedor de prueba...${NC}"
echo -e "${YELLOW}Este proceso puede tomar varios minutos (compilación de Neovim)${NC}"
echo ""

# Crear un script de prueba temporal que se ejecutará en el contenedor
cat > /tmp/test-install-in-container.sh << 'INNER_EOF'
#!/bin/bash
set -e

echo "==> Descargando e instalando dotfiles..."
curl -fsSL https://raw.githubusercontent.com/Awerito/dotfiles/claude/fix-installer-neovim-zsh-01FS8w5RkzdCQkajZ39Vs5p8/scripts/install.sh | bash

echo ""
echo "==> Verificando instalaciones..."

# Verificar Neovim
if command -v nvim >/dev/null 2>&1; then
    echo "✓ Neovim instalado correctamente"
    nvim --version | head -n 1

    # Verificar que está en /usr/local/bin (instalado desde source)
    if [ -f "/usr/local/bin/nvim" ]; then
        echo "✓ Neovim instalado desde source en /usr/local/bin/nvim"
    else
        echo "✗ ERROR: Neovim no está en /usr/local/bin"
        exit 1
    fi
else
    echo "✗ ERROR: Neovim no está instalado"
    exit 1
fi

# Verificar Zsh
if command -v zsh >/dev/null 2>&1; then
    echo "✓ Zsh instalado correctamente"
    zsh --version
else
    echo "✗ ERROR: Zsh no está instalado"
    exit 1
fi

# Verificar Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✓ Oh My Zsh instalado correctamente"
else
    echo "✗ ERROR: Oh My Zsh no está instalado"
    exit 1
fi

# Verificar que el shell se cambió correctamente sin interrumpir
if grep -q "testuser.*zsh" /etc/passwd; then
    echo "✓ Shell por defecto cambiado a Zsh correctamente"
else
    echo "⚠ Shell no se cambió (puede ser esperado en Docker)"
fi

# Verificar Node.js
if command -v node >/dev/null 2>&1; then
    echo "✓ Node.js instalado correctamente"
    node --version
else
    echo "⚠ Node.js no está instalado (puede requerir reinicio de shell)"
fi

echo ""
echo "==================================================="
echo "✓ TODAS LAS PRUEBAS PASARON EXITOSAMENTE"
echo "==================================================="
INNER_EOF

# Ejecutar el contenedor
docker run --rm -i dotfiles-test bash < /tmp/test-install-in-container.sh

# Limpiar
rm -f /tmp/test-install-in-container.sh

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✓ Pruebas completadas exitosamente!${NC}"
echo -e "${GREEN}================================================${NC}"
