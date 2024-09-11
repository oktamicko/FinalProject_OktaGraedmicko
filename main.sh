#!/bin/bash

# Initialize an array for student data
declare -A students

# ANSI color codes
GREEN="\033[32m"
CYAN="\033[36m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
RESET="\033[0m"

# Function to display welcome message with a frame and centered text
welcome_message() {
    # Set the message and frame details
    top_frame="********************************************"
    bottom_frame="********************************************"
    title="✨ Selamat Datang di Academic Record Tracker! ✨"
    subtitle="         🌟 Created by Okta Graedmicko 🌟        "
    
    # Print the welcome message with frame
    printf "${CYAN}${top_frame}${RESET}\n"
    printf "${CYAN}${title}${RESET}\n"
    printf "${CYAN}${subtitle}${RESET}\n"
    printf "${CYAN}${bottom_frame}${RESET}\n"
    echo
    printf "${MAGENTA}Selamat datang di *Academic Record Tracker*, solusi terbaik untuk memantau dan mengelola data akademik mahasiswa dengan mudah dan efisien.${RESET}\n"
    echo "Dengan aplikasi ini, Anda dapat:"
    echo "- Melihat data akademik mahasiswa secara rinci."
    echo "- Menganalisis kelulusan mahasiswa berdasarkan nilai."
    echo "- Menambahkan dan memperbarui informasi mahasiswa secara dinamis."
    echo
    echo "Mari bersama-sama menciptakan sistem akademik yang lebih transparan dan terstruktur!"
    echo
}

# Function to initialize student data
initialize_data() {
    students["Andi, Teknik Informatika, 78"]="Tidak Lulus"
    students["Lutfi, Sistem Informasi, 83"]="Lulus"
    students["Nadia, Teknik Elektro, 88"]="Lulus"
}

# Function to display student data in a table format with proper alignment and colored header
display_data() {
    printf "\n"
    printf "${GREEN}%-10s | %-20s | %-5s | %-10s${RESET}\n" "Nama" "Jurusan" "Nilai" "Status"
    printf "${YELLOW}------------------------------------------------------------${RESET}\n"
    for key in "${!students[@]}"; do
        name=$(echo $key | cut -d',' -f1)
        major=$(echo $key | cut -d',' -f2)
        grade=$(echo $key | cut -d',' -f3)
        status=${students[$key]}
        printf "%-10s | %-20s | %-5s | %-10s\n" "$name" "$major" "$grade" "$status"
    done
    printf "\n"
}

# Function to analyze student graduation based on the passing grade
analyze_graduation() {
    printf "\n"
    printf "${BLUE}🔍 Statistik Kelulusan 🔍${RESET}\n\n"
    passed=0
    failed=0
    for key in "${!students[@]}"; do
        status=${students[$key]}
        if [[ $status == "Lulus" ]]; then
            ((passed++))
        else
            ((failed++))
        fi
    done
    
    # Display the statistics in an aligned format
    printf "${GREEN}%-30s %-30s${RESET}\n" "Jumlah Mahasiswa Lulus" "Jumlah Mahasiswa Tidak Lulus"
    printf "${YELLOW}---------------------------------------------${RESET}\n"
    printf "${RED}%-30s %-30s${RESET}\n" "$passed" "$failed"
    printf "\n"
}

# Function to add a new student
add_student() {
    printf "\n"
    echo "Masukkan Nama Mahasiswa Baru:"
    read name
    echo "Masukkan Jurusan Mahasiswa Baru:"
    read major
    echo "Masukkan Nilai Mahasiswa Baru:"
    read grade

    # Determine pass or fail
    if [ "$grade" -ge 80 ]; then
        students["$name, $major, $grade"]="Lulus"
    else
        students["$name, $major, $grade"]="Tidak Lulus"
    fi
    analyze_graduation
    printf "${GREEN}Data Mahasiswa Setelah Ditambahkan:${RESET}\n\n"
    display_data
    printf "\n"
    
}

# Function to search and update student data
update_student() {
    printf "\n"
    echo "Masukkan Nama Mahasiswa yang Ingin Diupdate:"
    read search_name
    found=0  # Flag untuk mengetahui apakah data ditemukan atau tidak
    for key in "${!students[@]}"; do
        if [[ $key == *"$search_name"* ]]; then
            found=1  # Set flag menjadi 1 jika data ditemukan
            name=$(echo $key | cut -d',' -f1)
            major=$(echo $key | cut -d',' -f2)
            grade=$(echo $key | cut -d',' -f3)
            status=${students[$key]}
            
            # Tampilkan data mahasiswa dalam bentuk tabel
            printf "\n${BLUE}Data Ditemukan:${RESET}\n"
            printf "${GREEN}%-10s | %-20s | %-5s | %-10s${RESET}\n" "Nama" "Jurusan" "Nilai" "Status"
            printf "${YELLOW}------------------------------------------------------------${RESET}\n"
            printf "%-10s | %-20s | %-5s | %-10s\n" "$name" "$major" "$grade" "$status"
            printf "\n"

            echo "Apakah ingin mengupdate Jurusan Mahasiswa ini? (Y/N):"
            read update_response
            if [[ $update_response == "Y" || $update_response == "y" ]]; then
                echo "Masukkan Jurusan Baru:"
                read new_major
                
                # Hapus entri lama
                unset students["$key"]
                
                # Tambahkan entri baru dengan jurusan yang diupdate
                new_key="$name, $new_major, $grade"
                students["$new_key"]=$status
                echo "Jurusan telah diupdate."
                display_data
                return
            fi
        fi
    done
    
    # Jika mahasiswa tidak ditemukan, tampilkan pesan
    if [ $found -eq 0 ]; then
        echo "${RED}Mahasiswa tidak ditemukan.${RESET}"
    fi
    printf "\n"
}

main() {
    echo "Apakah ingin mengupdate data Mahasiswa? (Y/N): "
    read inputUser
    if [[ $inputUser == "Y" ]]; then
        update_student
    elif [[ $inputUser == "N" ]]; then
        echo "Apakah ingin menambahkan data Mahasiswa? (Y/N): "
        read inputUserAdd
        if [[ $inputUserAdd == "Y" ]]; then
            add_student
        elif [[ $inputUserAdd == "N" ]]; then
            return
        fi
    else
        echo "${RED}Command tidak valid${RESET}"
    fi
    main
}

# Display welcome message
welcome_message

# Call the initialization function to load data
initialize_data
printf "${GREEN}Data Mahasiswa Awal:${RESET}\n\n"
display_data
analyze_graduation
main
