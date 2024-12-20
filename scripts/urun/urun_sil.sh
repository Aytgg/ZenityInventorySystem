#!/bin/bash

URUN_ADI=$(zenity --entry --title="Ürün Sil" --text="Silmek istediğiniz ürünün adını girin:")

zenity --question --text="Bu ürünü silmek istediğinizden emin misiniz?"
if [[ $? -eq 0 ]]; then
    if grep -q ",$URUN_ADI," csvFiles/depo.csv; then
        sed -i "/,$URUN_ADI,/d" csvFiles/depo.csv
        zenity --info --text="Ürün başarıyla silindi."
    else
        zenity --error --text="Ürün bulunamadı."
        echo "$(date),$URUN_ADI,Silme başarısız" >> csvFiles/log.csv
    fi
else
    zenity --info --text="Silme işlemi iptal edildi."
fi

