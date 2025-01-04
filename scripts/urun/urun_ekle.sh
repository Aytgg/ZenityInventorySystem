#!/bin/bash

URUN_BILGILERI=$(zenity --forms --title="Ürün Ekle" --text="Ürün bilgilerini giriniz:"	\
    --add-entry="Ürün Adı"		\
    --add-entry="Kategori"		\
    --add-entry="Stok Miktarı"	\
    --add-entry="Birim Fiyatı")

IFS="|" read -r URUN_ADI KATEGORI STOK FIYAT <<< "$URUN_BILGILERI"

if [[ -z "$URUN_ADI" || -z "$STOK" || -z "$FIYAT" || -z "$KATEGORI" ]]; then
    zenity --error --text="Lütfen tüm alanları doldurup yeniden deneyin."
    exit 1
fi

if ! [[ $STOK =~ ^[0-9]+$ && $FIYAT =~ ^[0-9]+(\[.,][0-9]{1,2})?$ ]]; then
    zenity --error --text="Stok ve fiyat negatif olamaz."
    exit 1
fi

URUN_NO=$(($(tail -n 1 csvFiles/depo.csv | cut -d',' -f1)+1))

if grep -q ",$URUN_ADI," csvFiles/depo.csv; then
    zenity --error --text="Bu ürün zaten mevcut, lütfen farklı bir ürün adı giriniz."
    echo "$(date),$URUN_ADI,Ürün zaten mevcut" >> csvFiles/log.csv
    exit 1
else
    echo "$URUN_NO,$URUN_ADI,$KATEGORI,$STOK,$FIYAT" >> csvFiles/depo.csv
    zenity --info --text="Ürün başarıyla eklendi."
fi

