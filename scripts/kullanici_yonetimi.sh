#!/bin/bash

function kullanici_ekle() {
    YENI_KULLANICI=$(zenity --forms --title="Yeni Kullanıcı Ekle"	\
        --text="Kullanıcı bilgilerini giriniz:"	\
        --add-entry="Ad"						\
        --add-entry="Soyad"						\
        --add-entry="Rol (admin/user)"			\
        --add-password="Parola")
    
    IFS="|" read -r AD SOYAD ROL PAROLA <<< "$YENI_KULLANICI"

    if [[ -z $AD || -z $SOYAD || -z $ROL || -z $PAROLA ]]; then
        zenity --error --text="Tüm alanları doldurun!"
        echo "$(date),Kullanıcı ekleme başarısız (Eksik bilgi)" >> "csvFiles/log.csv"
        return
    fi

    if [[ $ROL != "admin" && $ROL != "user" ]]; then
        zenity --error --text="Rol yalnızca 'admin' veya 'user' olabilir!"
        echo "$(date),Kullanıcı ekleme başarısız (Geçersiz rol)" >> "csvFiles/log.csv"
        return
    fi

	YENI_ID=$(( $(tail -n 1 "csvFiles/kullanici.csv" | cut -d',' -f1) + 1 ))

    MD5_PAROLA=$(echo -n "$PAROLA" | md5sum | awk '{print $1}')

    echo "$YENI_ID,$AD,$SOYAD,$ROL,$MD5_PAROLA" >> "csvFiles/kullanici.csv"

    zenity --info --text="Kullanıcı başarıyla eklendi."
}

function kullanici_listele() {
    if [[ -s "csvFiles/kullanici.csv" ]]; then
		(
		echo "0"
		echo "# Kullanıcılar yükleniyor..."
		sleep 1
		echo "50"
		echo "# Kullanıcılar listeleniyor..."
		sleep 1
		echo "100"
		) | zenity --progress --title="Kullanıcı Listesi" --percentage=0 --auto-close

    	cat csvFiles/kullanici.csv | column -t -s, | zenity --text-info --title="Kullanıcı Listesi"
        # zenity --text-info --title="Kullanıcı Listesi" --filename="csvFiles/kullanici.csv"
    else
        zenity --info --text="Hiç kayıtlı kullanıcı bulunamadı."
    fi
}

function kullanici_guncelle() {
    KULLANICI_ID=$(zenity --entry --title="Kullanıcı Güncelle" \
        --text="Güncellemek istediğiniz kullanıcının ID'sini girin:")

    if grep -q "^$KULLANICI_ID," "csvFiles/kullanici.csv"; then
        YENI_BILGILER=$(zenity --forms --title="Kullanıcı Güncelle" \
            --text="Yeni bilgileri giriniz:"	\
            --add-entry="Yeni Ad"				\
            --add-entry="Yeni Soyad"			\
            --add-entry="Yeni Rol (admin/user)"	\
            --add-password="Yeni Parola")

        IFS="|" read -r YENI_ADI YENI_SOYADI YENI_ROL YENI_PAROLA <<< "$YENI_BILGILER"

        if [[ -z $YENI_ADI || -z $YENI_SOYADI || -z $YENI_ROL || -z $YENI_PAROLA ]]; then
            zenity --error --text="Tüm alanları doldurun!"
            echo "$(date),Kullanıcı güncelleme başarısız (Eksik bilgi)" >> "csvFiles/log.csv"
            return
        fi

        if [[ $YENI_ROL != "admin" && $YENI_ROL != "user" ]]; then
            zenity --error --text="Rol yalnızca 'admin' veya 'user' olabilir!"
            echo "$(date),Kullanıcı güncelleme başarısız (Geçersiz rol)" >> "csvFiles/log.csv"
            return
        fi

        YENI_MD5_PAROLA=$(echo -n "$YENI_PAROLA" | md5sum | awk '{print $1}')

        sed -i "" "/^$KULLANICI_ID,/ s/[^,]*,[^,]*,[^,]*,[^,]*$/$YENI_ADI,$YENI_SOYADI,$YENI_ROL,$YENI_MD5_PAROLA/" "csvFiles/kullanici.csv"

        zenity --info --text="Kullanıcı başarıyla güncellendi."
    else
        zenity --error --text="Kullanıcı bulunamadı."
        echo "$(date),Kullanıcı güncelleme başarısız (ID bulunamadı)" >> "csvFiles/log.csv"
    fi
}

function kullanici_sil() {
    KULLANICI_ID=$(zenity --entry --title="Kullanıcı Sil" \
        --text="Silmek istediğiniz kullanıcının ID'sini girin:")

    if grep -q "^$KULLANICI_ID," "csvFiles/kullanici.csv"; then
        zenity --question --text="Bu kullanıcıyı silmek istediğinizden emin misiniz?"
        if [[ $? -eq 0 ]]; then
            sed -i "/^$KULLANICI_ID,/d" "csvFiles/kullanici.csv"
            zenity --info --text="Kullanıcı başarıyla silindi."
        fi
    else
        zenity --error --text="Kullanıcı bulunamadı."
        echo "$(date),Kullanıcı silme başarısız (ID bulunamadı)" >> "csvFiles/log.csv"
    fi
}

function menu() {
    SECIM=$(zenity --list --title="Kullanıcı Yönetimi"	\
        --column="İşlem"		\
		"Kullanıcı Ekle"		\
		"Kullanıcıları Listele"	\
		"Kullanıcı Güncelle"	\
		"Kullanıcı Sil"			\
		"Çıkış")

    case $SECIM in
        "Kullanıcı Ekle") kullanici_ekle			;;
        "Kullanıcıları Listele") kullanici_listele	;;
        "Kullanıcı Güncelle") kullanici_guncelle	;;
        "Kullanıcı Sil") kullanici_sil				;;
        "Çıkış") exit								;;
    esac
}

menu

