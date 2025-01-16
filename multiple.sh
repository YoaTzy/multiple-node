#!/bin/bash

# Fungsi untuk meminta input dari pengguna
echo "Masukkan nilai bandwidth download (dalam MB):"
read -r BANDWIDTH_DOWNLOAD_MB
echo "Masukkan nilai bandwidth upload (dalam MB):"
read -r BANDWIDTH_UPLOAD_MB
echo "Masukkan PIN (6 digit):"
read -r PIN
echo "Masukkan storage yang akan digunakan (dalam MB):"
read -r STORAGE_MB
echo "Masukkan identifier (string unik):"
read -r IDENTIFIER

# Konversi nilai input dari MB ke KB
BANDWIDTH_DOWNLOAD=$((BANDWIDTH_DOWNLOAD_MB * 1024))
BANDWIDTH_UPLOAD=$((BANDWIDTH_UPLOAD_MB * 1024))
STORAGE=$((STORAGE_MB * 1024))

# Variabel untuk konfigurasi lainnya
URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
TAR_FILE="multipleforlinux.tar"
DIR_NAME="multipleforlinux"
LOG_FILE="output.log"

# Unduh file tar
wget "$URL" -O "$TAR_FILE"

# Ekstrak file tar
tar -xvf "$TAR_FILE"

# Pindah ke direktori hasil ekstraksi
cd "$DIR_NAME" || exit

# Berikan izin eksekusi untuk file yang diperlukan
chmod +x ./multiple-cli
chmod +x ./multiple-node

# Tambahkan direktori ke PATH sementara
export PATH=$PATH:"$(pwd)"

# Pastikan semua file dalam direktori memiliki izin yang diperlukan
chmod -R 777 .

# Jalankan multiple-node di background dan arahkan output ke file log
nohup ./multiple-node > "$LOG_FILE" 2>&1 &

# Jalankan multiple-cli dengan parameter yang dimasukkan pengguna
./multiple-cli bind --bandwidth-download "$BANDWIDTH_DOWNLOAD" --bandwidth-upload "$BANDWIDTH_UPLOAD" --identifier "$IDENTIFIER" --pin "$PIN" --storage "$STORAGE"

# Informasi sukses
echo "Script selesai dijalankan. Node berjalan di latar belakang."
echo "Log output disimpan di: $DIR_NAME/$LOG_FILE"
