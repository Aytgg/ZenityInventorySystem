#!/bin/bash

# create CSV files if not exist
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


# Ana Menü
while true; do
    CHOICE=$(zenity --list --title="Envanter Yönetim Sistemi"	\
		--column="index" --column="İşlem" --hide-column=1		\
        1 "Giriş"				\
		2 "Ürün Ekle"			\
        3 "Ürünleri Listele"	\
        4 "Ürün Güncelle"		\
        5 "Ürün Sil"			\
        6 "Rapor"				\
        7 "Kullanıcı Yönetimi"	\
        8 "Program Yönetimi"	\
        9 "Çıkış")

    case $CHOICE in
		1) "Giriş Yap?"								;;
        2) ./scripts/urun/urun_ekle.sh				;;
        3) ./scripts/urun/urunleri_listele.sh		;;
        4) ./scripts/urun/urun_guncelle.sh			;;
        5) ./scripts/urun/urun_sil.sh				;;
        6) ./scripts/urun/rapor.sh					;;
        7) ./scripts/kullanici_yonetimi.sh			;;
        8) ./scripts/program_yonetimi.sh			;;
        9) exit										;;
        *) zenity --error --text="Geçersiz seçim!"	;;
    esac
done

