# Instrucciones de Prueba del Instalador

## Prueba en Docker (Recomendado)

### Requisitos
- Docker instalado en tu sistema

### Método 1: Script automático (Más fácil)
```bash
./test-installer.sh
```

Este script:
1. Construye una imagen Docker con Ubuntu 22.04
2. Ejecuta el instalador completo
3. Verifica que:
   - Neovim se instaló desde source en `/usr/local/bin/nvim`
   - Zsh y Oh My Zsh se instalaron correctamente
   - El cambio de shell no interrumpió el script
   - Node.js se instaló correctamente

### Método 2: Prueba manual
```bash
# 1. Construir la imagen
docker build -f Dockerfile.test -t dotfiles-test .

# 2. Ejecutar el contenedor de forma interactiva
docker run -it dotfiles-test bash

# 3. Dentro del contenedor, ejecutar el instalador
curl -fsSL https://raw.githubusercontent.com/Awerito/dotfiles/claude/fix-installer-neovim-zsh-01FS8w5RkzdCQkajZ39Vs5p8/scripts/install.sh | bash

# 4. Verificar instalaciones
nvim --version
which nvim  # Debería ser /usr/local/bin/nvim
zsh --version
ls -la ~/.oh-my-zsh
node --version
```

## Verificaciones importantes

### ✅ Neovim desde source
```bash
# Verificar que está instalado en /usr/local/bin (no en /opt)
which nvim  # Debe retornar: /usr/local/bin/nvim

# Verificar versión (debería ser stable, 0.9.x o superior)
nvim --version
```

### ✅ Cambio de shell sin interrupciones
Durante la instalación, deberías ver:
- ✓ Zsh installed
- ✓ Oh My Zsh installed
- ✓ Default shell changed to Zsh (restart terminal to apply)

**NO debería**:
- Abrir una nueva sesión de zsh
- Interrumpir el script
- Pedir contraseña de forma interactiva

## Prueba rápida sin Docker

Si no tienes Docker, puedes probar en una VM de Ubuntu 22.04:

```bash
# Descargar y ejecutar el instalador
curl -fsSL https://raw.githubusercontent.com/Awerito/dotfiles/claude/fix-installer-neovim-zsh-01FS8w5RkzdCQkajZ39Vs5p8/scripts/install.sh | bash
```

## Limpieza después de las pruebas

```bash
# Eliminar la imagen Docker
docker rmi dotfiles-test

# Eliminar contenedores detenidos
docker container prune
```

## Tiempo estimado
- Construcción de imagen Docker: ~1-2 minutos
- Instalación completa: ~5-10 minutos (principalmente por compilación de Neovim)
