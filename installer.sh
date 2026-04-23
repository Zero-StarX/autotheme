#!/bin/bash

# ==============================================
#  PTERODACTYL THEME & ADDON INSTALLER
#  Owner: Zero-StarX
# ==============================================

# Definisi warna
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[0;36m'
C_MAGENTA='\033[0;35m'

# Bersihkan layar
clear

# --- HEADER SIMPLE ---
echo -e "${C_CYAN}==============================================${C_RESET}"
echo -e "  ${C_GREEN}Pterodactyl Auto Installer${C_RESET}"
echo -e "  ${C_YELLOW}Owner : Zero-StarX${C_RESET}"
echo -e "${C_CYAN}==============================================${C_RESET}"
echo -e "  WA    : 6285179836603"
echo -e "  YT    : YASSxOFC"
echo ""

# --- FUNGSI ---
animate_text() {
    local text=$1
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep 0.02
    done
    echo ""
}

# --- MENU ---
echo -e "${C_BLUE}>> MENU UTAMA${C_RESET}"
echo -e "[1]  ${C_GREEN}Install Theme Elysium + Autosuspend${C_RESET}     ${C_CYAN}(FILE)${C_RESET}"
echo -e "[2]  ${C_GREEN}Install Theme Stellar + Autosuspend${C_RESET}      ${C_CYAN}(FILE)${C_RESET}"
echo -e "[3]  ${C_GREEN}Install Theme NightCore${C_RESET}                  ${C_CYAN}(FILE)${C_RESET}"
echo -e "[4]  ${C_GREEN}Install Theme Nebula${C_RESET}                     ${C_CYAN}(PLUGIN)${C_RESET}"
echo "------------------------------------------------"
echo -e "[5]  ${C_YELLOW}Install Google Analytics${C_RESET}"
echo -e "[6]  ${C_YELLOW}Install Cookies Consent${C_RESET}"
echo -e "[7]  ${C_YELLOW}Change Background Image${C_RESET}"
echo -e "[8]  ${C_YELLOW}Remove Background Image${C_RESET}"
echo -e "[9]  ${C_RED}Remove Theme / Addon${C_RESET}"
echo "------------------------------------------------"
echo -e "[10] ${C_MAGENTA}Rollback Pterodactyl (Safe)${C_RESET}"
echo -e "[11] ${C_MAGENTA}Install Blueprint Framework${C_RESET}"
echo -e "[12] Disable Text Animation"
echo -e "[13] Exit Installer"
echo ""

read -p "Select Option [1-13]: " OPTION

case "$OPTION" in

# --- ROLBACK ---
10)
    if [ ! -d "/var/www/pterodactyl_backup" ]; then
        echo -e "${C_RED}Backup tidak ditemukan! Hubungi developer.${C_RESET}"
        exit 1
    fi
    echo -e "${C_BLUE}Memproses Rollback...${C_RESET}"
    cd /var/www/ && rm -r pterodactyl
    mv pterodactyl_backup pterodactyl
    cd /var/www/pterodactyl
    rm -r pterodactyl_backup 2>/dev/null
    cp -rL /var/www/pterodactyl /var/www/pterodactyl_backup
    sudo chown -R www-data:www-data /var/www/pterodactyl
    sudo chmod -R 755 /var/www/pterodactyl
    composer install --no-dev --optimize-autoloader
    php artisan cache:clear && php artisan config:cache && php artisan view:clear
    sudo systemctl restart nginx
    echo -e "${C_GREEN}Rollback selesai.${C_RESET}"
    ;;

# --- INSTALL ELYSIUM + AUTOSUSPEND ---
1)
    echo -e "${C_BLUE}>> Install Theme Elysium + Autosuspend${C_RESET}"
    # Setup Node
    sudo mkdir -p /etc/apt/keyrings
    if [ ! -f "/etc/apt/keyrings/nodesource.gpg" ]; then
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    fi
    if ! grep -q "nodesource" /etc/apt/sources.list.d/nodesource.list 2>/dev/null; then
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    fi
    sudo apt update && sudo apt install -y nodejs npm
    npm i -g yarn

    # Download & Extract Theme
    cd /var/www
    git clone https://github.com/Zero-StarX/autotheme temp_installer
    mv temp_installer/ElysiumTheme.zip .
    unzip -o ElysiumTheme.zip -d /var/www/
    rm -rf temp_installer ElysiumTheme.zip

    # Build Theme
    cd /var/www/pterodactyl
    yarn
    export NODE_OPTIONS=--openssl-legacy-provider
    if ! yarn build:production; then
        export NODE_OPTIONS=--openssl-legacy-provider
        yarn && yarn build:production && npx update-browserslist-db@latest
    fi
    php artisan migrate && php artisan view:clear

    # Install Autosuspend
    cd /var/www
    git clone https://github.com/Zero-StarX/autotheme temp_suspend
    mv temp_suspend/autosuspens.zip .
    unzip -o autosuspens.zip -d /var/www/
    cd /var/www/pterodactyl && bash installer.bash
    rm -rf /var/www/temp_suspend /var/www/autosuspens.zip
    echo -e "${C_GREEN}Elysium + Autosuspend terinstall.${C_RESET}"
    ;;

# --- INSTALL STELLAR + AUTOSUSPEND ---
2)
    echo -e "${C_BLUE}>> Install Theme Stellar + Autosuspend${C_RESET}"
    # Setup Node
    sudo mkdir -p /etc/apt/keyrings
    if [ ! -f "/etc/apt/keyrings/nodesource.gpg" ]; then
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    fi
    if ! grep -q "nodesource" /etc/apt/sources.list.d/nodesource.list 2>/dev/null; then
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    fi
    sudo apt update && sudo apt install -y nodejs npm
    npm i -g yarn

    # Download & Extract Theme
    cd /var/www
    git clone https://github.com/Zero-StarX/autotheme temp_installer
    mv temp_installer/stellarrimake.zip .
    unzip -o stellarrimake.zip -d /var/www/
    rm -rf temp_installer stellarrimake.zip

    # Build Theme
    cd /var/www/pterodactyl
    yarn
    export NODE_OPTIONS=--openssl-legacy-provider
    if ! yarn build:production; then
        export NODE_OPTIONS=--openssl-legacy-provider
        yarn && yarn add react-feather && npx update-browserslist-db@latest && yarn build:production
    fi
    php artisan migrate && php artisan view:clear

    # Install Autosuspend
    cd /var/www
    git clone https://github.com/Zero-StarX/autotheme temp_suspend
    mv temp_suspend/autosuspens.zip .
    unzip -o autosuspens.zip -d /var/www/
    cd /var/www/pterodactyl && bash installer.bash
    rm -rf /var/www/temp_suspend /var/www/autosuspens.zip
    echo -e "${C_GREEN}Stellar + Autosuspend terinstall.${C_RESET}"
    ;;

# --- INSTALL NIGHTCORE ---
3)
    echo -e "${C_BLUE}>> Install Theme NightCore${C_RESET}"
    apt install sudo -y > /dev/null 2>&1
    cd /var/www/
    tar -cvf Pterodactyl_Nightcore_Themebackup.tar.gz pterodactyl > /dev/null 2>&1
    cd /var/www/pterodactyl
    rm -rf Pterodactyl_Nightcore_Theme
    git clone https://github.com/NoPro200/Pterodactyl_Nightcore_Theme.git > /dev/null 2>&1
    cd Pterodactyl_Nightcore_Theme
    rm /var/www/pterodactyl/resources/scripts/Pterodactyl_Nightcore_Theme.css 2>/dev/null
    rm /var/www/pterodactyl/resources/scripts/index.tsx 2>/dev/null
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv Pterodactyl_Nightcore_Theme.css /var/www/pterodactyl/resources/scripts/Pterodactyl_Nightcore_Theme.css
    
    cd /var/www/pterodactyl
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1
    apt update -y > /dev/null 2>&1
    apt install nodejs npm -y > /dev/null 2>&1
    
    if [ "$(node -v)" != "v16.20.2" ]; then
        sudo npm install -g n > /dev/null 2>&1
        sudo n 16 > /dev/null 2>&1
    fi
    npm i -g yarn > /dev/null 2>&1
    yarn > /dev/null 2>&1
    yarn build:production > /dev/null 2>&1
    sudo php artisan optimize:clear > /dev/null 2>&1
    echo -e "${C_GREEN}NightCore terinstall.${C_RESET}"
    ;;

# --- INSTALL NEBULA (BLUEPRINT) ---
4)
    echo -e "${C_BLUE}>> Install Theme Nebula${C_RESET}"
    if [ ! -f "/var/www/pterodactyl/blueprint.sh" ]; then
        echo -e "${C_YELLOW}Blueprint belum terinstall. Install dulu opsi 11.${C_RESET}"
        exit 1
    fi
    cd /var/www
    git clone https://github.com/Zero-StarX/LeXcZUbot temp_nebula
    cd temp_nebula && mv * /var/www/
    cd /var/www
    unzip -o nebulaptero.zip
    cd /var/www/pterodactyl
    blueprint -install nebula
    rm -rf /var/www/temp_nebula /var/www/nebulaptero.zip
    echo -e "${C_GREEN}Nebula terinstall.${C_RESET}"
    ;;

# --- GOOGLE ANALYTICS ---
5)
    cd /var/www
    git clone https://github.com/Zero-StarX/autotheme temp_ga
    mv temp_ga/googleanalitic.zip .
    unzip -o googleanalitic.zip -d /var/www/
    rm -rf temp_ga googleanalitic.zip
    
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg || true
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt update && sudo apt install -y nodejs npm
    npm i -g yarn
    cd /var/www/pterodactyl
    yarn && yarn build:production
    php artisan migrate && php artisan view:clear
    echo -e "${C_GREEN}Google Analytics terinstall.${C_RESET}"
    ;;

# --- COOKIES (BLUEPRINT) ---
6)
    if [ ! -f "/var/www/pterodactyl/blueprint.sh" ]; then
        echo -e "${C_YELLOW}Blueprint belum terinstall. Install dulu opsi 11.${C_RESET}"
        exit 1
    fi
    cd /var/www
    git clone https://github.com/Zero-StarX/autotheme temp_cookie
    mv temp_cookie/cookies.zip /var/www/pterodactyl
    cd /var/www/pterodactyl
    unzip -o cookies.zip
    blueprint -install cookies
    rm -rf /var/www/temp_cookie cookies.zip cookies.blueprint
    echo -e "${C_GREEN}Cookies Consent terinstall.${C_RESET}"
    ;;

# --- CHANGE BACKGROUND ---
7)
    DEFAULT_URL="https://telegra.ph/file/35d23db684fd1d88556ee.jpg"
    read -p "Masukkan URL gambar (Enter untuk default): " USER_URL
    URL="${USER_URL:-$DEFAULT_URL}"
    cd /var/www/pterodactyl/resources/views/templates || exit
    
    if grep -q 'background-image' wrapper.blade.php; then
        read -p "Background lama terdeteksi. Hapus dulu? (y/n): " CONFIRM
        if [ "$CONFIRM" != "y" ]; then exit; fi
    fi
    
    {
        echo '<!DOCTYPE html><html lang="en"><head>'
        echo '<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">'
        echo '<title>Pterodactyl</title>'
        echo '<style>'
        echo "body { background-image: url('$URL'); background-size: cover; background-repeat: no-repeat; background-attachment: fixed; margin: 0; padding: 0; }"
        echo '</style></head><body>'
        cat wrapper.blade.php
    } > /tmp/new_wrapper.blade.php
    mv /tmp/new_wrapper.blade.php wrapper.blade.php
    echo -e "${C_GREEN}Background updated.${C_RESET}"
    ;;

# --- REMOVE BACKGROUND ---
8)
    file_path="/var/www/pterodactyl/resources/views/templates/wrapper.blade.php"
    cat << 'EOF' > "$file_path"
<!DOCTYPE html><html><head><title>{{ config('app.name', 'Pterodactyl') }}</title>
@section('meta')<meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"><meta name="csrf-token" content="{{ csrf_token() }}"><meta name="robots" content="noindex"><link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon.png"><link rel="icon" type="image/png" href="/favicons/favicon-32x32.png" sizes="32x32"><link rel="icon" type="image/png" href="/favicons/favicon-16x16.png" sizes="16x16"><link rel="manifest" href="/favicons/manifest.json"><link rel="mask-icon" href="/favicons/safari-pinned-tab.svg" color="#bc6e3c"><link rel="shortcut icon" href="/favicons/favicon.ico"><meta name="msapplication-config" content="/favicons/browserconfig.xml"><meta name="theme-color" content="#0e4688">@show
@section('user-data')@if(!is_null(Auth::user()))<script>window.PterodactylUser = {!! json_encode(Auth::user()->toVueObject()) !!};</script>@endif @if(!empty($siteConfiguration))<script>window.SiteConfiguration = {!! json_encode($siteConfiguration) !!};</script>@endif @show
<style>@import url('//fonts.googleapis.com/css?family=Rubik:300,400,500&display=swap');@import url('//fonts.googleapis.com/css?family=IBM+Plex+Mono|IBM+Plex+Sans:500&display=swap');</style>@yield('assets')@include('layouts.scripts')
<script async src="https://www.googletagmanager.com/gtag/js?id={{ config('app.google_analytics', 'Pterodactyl') }}"></script><script>window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', '{{ config('app.google_analytics', 'Pterodactyl') }}');</script></head>
<body class="{{ $css['body'] ?? 'bg-neutral-50' }}">@section('content')@yield('above-container')@yield('container')@yield('below-container')@show @section('scripts'){!! $asset->js('main.js') !!}@show</body></html>
EOF
    echo -e "${C_GREEN}Background dihapus.${C_RESET}"
    ;;

# --- REMOVE ALL THEMES/ADDONS ---
9)
    echo -e "${C_YELLOW}>> Menghapus semua tema/addon...${C_RESET}"
    cd /var/www/pterodactyl
    php artisan down
    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
    chmod -R 755 storage/* bootstrap/cache
    composer install --no-dev --optimize-autoloader
    php artisan view:clear && php artisan config:clear
    php artisan migrate --seed --force
    chown -R www-data:www-data /var/www/pterodactyl/*
    php artisan up
    echo -e "${C_GREEN}Panel kembali ke original.${C_RESET}"
    ;;

# --- INSTALL BLUEPRINT ---
11)
    echo -e "${C_BLUE}>> Install Blueprint Framework${C_RESET}"
    sudo apt-get install -y ca-certificates curl gnupg zip unzip git
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt update && sudo apt install -y nodejs
    npm i -g yarn
    cd /var/www/pterodactyl
    yarn && yarn add cross-env
    
    wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
    unzip -o release.zip
    FOLDER="/var/www/pterodactyl"
    sed -i -E -e "s|WEBUSER=\"www-data\" #;|WEBUSER=\"www-data\" #;|g" -e "s|USERSHELL=\"/bin/bash\" #;|USERSHELL=\"/bin/bash\" #;|g" -e "s|OWNERSHIP=\"www-data:www-data\" #;|OWNERSHIP=\"www-data:www-data\" #;|g" "$FOLDER/blueprint.sh"
    chmod +x blueprint.sh && bash blueprint.sh
    rm release.zip
    echo -e "${C_GREEN}Blueprint installed.${C_RESET}"
    ;;

# --- DISABLE ANIMATION ---
12)
    DISABLE_ANIMATIONS=1
    echo -e "${C_YELLOW}Animasi dimatikan.${C_RESET}"
    ;;

# --- EXIT ---
13)
    echo -e "${C_CYAN}Terima kasih telah menggunakan installer ini.${C_RESET}"
    exit 0
    ;;

*)
    echo -e "${C_RED}Pilihan tidak valid.${C_RESET}"
    ;;
esac

# --- FOOTER ---
echo ""
echo -e "${C_CYAN}==============================================${C_RESET}"
echo -e "  ${C_GREEN}Proses Selesai!        Owner: Zero-StarX${C_RESET}"
echo -e "${C_CYAN}==============================================${C_RESET}"
