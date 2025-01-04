#!/bin/bash

if [[ -s csvFiles/depo.csv ]]; then
    cat csvFiles/depo.csv | column -t -s, | zenity --text-info --title="Ürün Listesi" --width=600 --height=400
else
    zenity --info --text="Envanterde kayıtlı ürün bulunmamaktadır."
fi

