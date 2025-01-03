#!/bin/bash

function disk_alan_gosterOLD() {
    DISK_KULLANIMI=$(df -h --output=source,size,used,avail,pcent . | tail -n 1)
    DISK_KULLANIMI=$(df -h --output=source,size,used,avail,pcent .)
    DISK_KULLANIMI=$(df -h .)
    zenity --info --title="Disk Kullanımı" --text="Disk Kullanımı:\n$DISK_KULLANIMI"
}

function disk_alan_goster() {
	hedefler="./scripts/** ./csvFiles/*.csv main.sh"

    toplam_alan=$(du -ch $hedefler 2>/dev/null | grep total | awk '{print $1}')
    zenity --info \
        --title="Disk Kullanımı" \
        --text="Toplam Disk Kullanımı: $toplam_alan"
}

function yedekle() {
	if [ ! -d "yedekler" ]; then
		mkdir "yedekler"
	fi

	cp csvFiles/depo.csv "yedekler/depo_$(date +%Y%m%d%H%M%S).csv"
	cp csvFiles/kullanici.csv "yedekler/kullanici_$(date +%Y%m%d%H%M%S).csv"

	zenity --info --title="Yedekleme Başarılı" --text="Dosyalar başarıyla yedeklendi."
}

function hata_kayitlarini_goster() {
    if [ -s "csvFiles/log.csv" ]; then
        zenity --text-info --title="Hata Kayıtları" --filename="csvFiles/log.csv"
    else
        zenity --info --text="Hata kaydı bulunamadı."
    fi
}

function menu() {
    SECIM=$(zenity --list --title="Program Yönetimi"	\
        --column="İşlem"				\
		"Disk Kullanımını Göster"		\
		"Yedekle"						\
		"Hata Kayıtlarını Görüntüle"	\
		"Çıkış")

    case $SECIM in
        "Disk Kullanımını Göster") disk_alan_goster				;;
        "Yedekle") yedekle								;;
        "Hata Kayıtlarını Görüntüle") hata_kayitlarini_goster	;;
        "Çıkış") exit											;;
    esac
}

menu

