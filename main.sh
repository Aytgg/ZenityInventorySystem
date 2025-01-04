#!/bin/bash

if [ ! -d "./csvFiles" ]; then
    mkdir ./csvFiles
fi

if [[ ! -f "./csvFiles/depo.csv" ]]; then
    touch ./csvFiles/depo.csv
fi

if [[ ! -f "./csvFiles/kullanici.csv" ]]; then
    touch ./csvFiles/kullanici.csv
fi

if [[ ! -f "./csvFiles/log.csv" ]]; then
    touch ./csvFiles/log.csv
fi

function Login() {
    local logged_in=0

    while [ $logged_in -eq 0 ]; do
        GIRIS_BILGILERI=$(zenity --forms --title="Giriş Yap" --text="Lütfen adınızı, soyadınızı ve şifrenizi giriniz:" \
            --add-entry="Ad" --add-entry="Soyad" --add-password="Şifre" 2>/dev/null)

        if [[ -z "$GIRIS_BILGILERI" ]]; then
            zenity --error --text="Giriş iptal edildi. Program kapatılıyor."
            exit
        fi

        ADI=$(echo "$GIRIS_BILGILERI" | cut -d'|' -f1)
        SOYADI=$(echo "$GIRIS_BILGILERI" | cut -d'|' -f2)
        SIFRE=$(echo "$GIRIS_BILGILERI" | cut -d'|' -f3)
        MD5_PAROLA=$(echo -n "$SIFRE" | md5sum | awk '{print $1}')

        KULLANICI_BILGI=$(grep "^.*,${ADI},${SOYADI},.*,${MD5_PAROLA}" "./csvFiles/kullanici.csv")

        if [[ -n "$KULLANICI_BILGI" ]]; then
            zenity --info --text="Giriş başarılı. Hoş geldiniz, $ADI!"
            logged_in=1
            ROL=$(echo "$KULLANICI_BILGI" | cut -d',' -f4)

			while true; do
				if [[ "$ROL" == "admin" ]]; then
					CHOICE=$(zenity --list --title="Envanter Yönetim Sistemi" \
						--column="index" --column="İşlem" --hide-column=1 \
						1 "Ürün Ekle" \
						2 "Ürünleri Listele" \
						3 "Ürün Güncelle" \
						4 "Ürün Sil" \
						5 "Rapor" \
						6 "Kullanıcı Yönetimi" \
						7 "Program Yönetimi" \
						0 "Çıkış")
				elif [[ "$ROL" == "user" ]]; then
					CHOICE=$(zenity --list --title="Envanter Yönetim Sistemi" \
						--column="index" --column="İşlem" --hide-column=1 \
						2 "Ürünleri Listele" \
						5 "Rapor" \
						0 "Çıkış")
				fi

				case $CHOICE in
					1) ./scripts/urun/urun_ekle.sh			;;
					2) ./scripts/urun/urunleri_listele.sh	;;
					3) ./scripts/urun/urun_guncelle.sh		;;
					4) ./scripts/urun/urun_sil.sh			;;
					5) ./scripts/urun/rapor.sh				;;
					6) ./scripts/kullanici_yonetimi.sh		;;
					7) ./scripts/program_yonetimi.sh		;;
					*) exit
				esac
			done
        else
            zenity --error --text="Hatalı ad, soyad veya parola. Lütfen tekrar deneyiniz."
        	echo "$(date),Hatalı giriş denemesi." >> csvFiles/log.csv
        fi
    done
}

Login
