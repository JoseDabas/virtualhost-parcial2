#!/usr/bin/env bash
echo "Instalando estructura basica para clase virtualhost y proxy reverso"

# Habilitando la memoria de intercambio.
sudo dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Instando los software necesarios para probar el concepto.
sudo apt update && sudo apt -y install zip unzip nmap apache2 certbot tree

# Instalando la versión sdkman y java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Utilizando la versión de java 17 como base.
sdk install java 21.0.3-tem

# Subiendo el servicio de Apache.
sudo service apache2 start

# Clonando el repositorio.
git clone https://github.com/JoseDabas/virtualhost-parcial2.git

# Copiando los archivos de configuración en la ruta indicada.
sudo cp ~/virtualhost-parcial2/configuraciones/virtualhost.conf /etc/apache2/sites-available/
sudo cp ~/virtualhost-parcial2/configuraciones/seguro.conf /etc/apache2/sites-available/
sudo cp ~/virtualhost-parcial2/configuraciones/proxyreverso.conf /etc/apache2/sites-available/

# Creando las estructuras de los archivos.
sudo mkdir -p /var/www/html/app1 /var/www/html/app2

# Creando los archivos por defecto.
printf "<h1>Sitio Aplicacion #1</h1>" | sudo tee /var/www/html/app1/index.html
printf "<h1>Sitio Aplicacion #2</h1>" | sudo tee /var/www/html/app2/index.html

# Clonando el proyecto ORM y moviendo a la carpeta descargada.
cd ~/
git clone https://github.com/JoseDabas/Parcial2-ProgramacionWeb.git
cd Parcial2-ProgramacionWeb

# Ejecutando la creación de fatjar
chmod +x gradlew
./gradlew shadowjar

# Subiendo la aplicación puerto por defecto.
mkdir -p ~/Parcial2-ProgramacionWeb/build/libs/
java -jar ~/Parcial2-ProgramacionWeb/build/libs/app.jar > ~/Parcial2-ProgramacionWeb/build/libs/salida.txt 2> ~/Parcial2-ProgramacionWeb/build/libs/error.txt &
