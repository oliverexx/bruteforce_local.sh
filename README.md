Local Bruteforce Script
Descripción:```
Este script en Bash permite realizar un ataque de fuerza bruta local a un usuario específico del sistema, utilizando un diccionario de contraseñas como entrada. El script verifica las contraseñas contra un usuario objetivo utilizando su para intentar iniciar sesión. Si una contraseña válida es encontrada, la muestra en la salida.


Características:
```Permite especificar un usuario y un diccionario de contraseñas.
Compatible con el diccionario rockyou.txt o cualquier otro diccionario.
Funciona de manera eficiente en entornos Linux con acceso root.```

Uso:
```
./bruteforce_local.sh -u <usuario> -w <ruta_al_diccionario>
```

```
sudo ./bruteforce_local.sh -u bob -w /usr/share/wordlists/rockyou.txt
```
