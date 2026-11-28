#!/usr/bin/env bash
# Android : CLI, adb/fastboot du SDK, Java, Gradle, scrcpy.

# Android : une source par outil. Le CLI android par mise ; adb et fastboot
# sont ceux du SDK (~/Android/Sdk, celui d'Android Studio et du CLI), aucun
# paquet pacman. scrcpy par mise, sur l'adb du SDK via ADB : sinon il prend
# l'adb de son archive, d'une autre version que le serveur.
sudo pacman -Rns --noconfirm scrcpy android-tools 2>/dev/null || true
mkdir -p ~/.local/bin
ln -sfn ~/Android/Sdk/platform-tools/adb ~/.local/bin/adb
ln -sfn ~/Android/Sdk/platform-tools/fastboot ~/.local/bin/fastboot
mise use -g android-cli@latest
# Java et Gradle des builds Android : mise (JAVA_HOME posé par mise), plus le
# JBR d'Android Studio ni un Gradle téléchargé à la main. 21 : la version que
# toutes les versions de Gradle et d'AGP en usage acceptent.
mise use -g java@temurin-21 gradle@latest
mise use -g "github:Genymobile/scrcpy[filter_bins=scrcpy]@latest"
mise set -g 'ADB={{env.HOME}}/Android/Sdk/platform-tools/adb'
