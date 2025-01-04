#!/bin/bash

URUN_ADI=$(zenity --entry --title="Ürün Güncelle" --text="Güncellemek istediğiniz ürünün adını girin:")
if grep -q ",$URUN_ADI," "csvFiles/depo.csv"; then
	YENI_BILGILER=$(zenity --forms --title="Ürün Güncelle: $URUN_ADI"	\
        --text="Yeni bilgileri giriniz:"	\
		--add-entry="Yeni Stok Miktarı"		\
        --add-entry="Yeni Birim Fiyatı")

    IFS="|" read -r YENI_STOK YENI_FIYAT <<< "$YENI_BILGILER"

	if [[ -z "$YENI_STOK" || -z "$YENI_FIYAT" ]]; then
		zenity --error --text="Lütfen tüm alanları doldurup yeniden deneyin."
		exit 1
	fi

    if ! [[ $YENI_STOK =~ ^[0-9]+$ ]]; then
        zenity --error --text="Stok miktarı negatif olamaz."
        echo "$(date),$URUN_ADI,Stok miktarı hatalı giriş" >> csvFiles/log.csv
        exit 1
    fi

    if ! [[ $YENI_FIYAT =~ ^[0-9]+([\.,][0-9]{1,2})?$ ]]; then
        zenity --error --text="Birim fiyat negatif ve ondalık kısım iki basamaktan fazla olamaz."
        echo "$(date),$URUN_ADI,Birim fiyat hatalı giriş" >> csvFiles/log.csv
        exit 1
    fi

    if grep -q ",$URUN_ADI," "csvFiles/depo.csv"; then
		sed -i "" "/^[^,]*,$URUN_ADI,[^,]*,/ s/,[^,]*,[^,]*$/,$YENI_STOK,$YENI_FIYAT/" "csvFiles/depo.csv"
	else
        zenity --error --text="Güncelleme sırasında bir hata oluştu."
        echo "$(date),$URUN_ADI,Güncelleme başarısız (Dosya yazma hatası)" >> csvFiles/log.csv
	fi

    zenity --info --text="Ürün başarıyla güncellendi."
else
    zenity --error --text="Ürün bulunamadı."
	echo "$(date),$URUN_ADI,Güncelleme başarısız (Ürün bulunamadı)" >> csvFiles/log.csv
fi

