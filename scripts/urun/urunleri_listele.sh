#!/bin/bash

if [[ -s csvFiles/depo.csv ]]; then
	(
	echo "0"
	echo "# Ürünler yükleniyor..."
	sleep 1
	echo "50"
	echo "# Ürünler listeleniyor..."
	sleep 1
	echo "100"
	) | zenity --progress --title="Ürün Listesi" --percentage=0 --auto-close

    cat csvFiles/depo.csv | column -t -s, | zenity --text-info --title="Ürün Listesi" --width=600 --height=400
else
    zenity --info --text="Envanterde kayıtlı ürün bulunmamaktadır."
fi

