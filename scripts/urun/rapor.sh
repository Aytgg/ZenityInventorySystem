#!/bin/bash

RAPOR_TURU=$(zenity --list --title="Rapor Türü Seçin"	\
    --column="ID" --column="Rapor Türü"					\
    1 "Stoğu Azalan Ürünler"					\
    2 "En Yüksek Stok Miktarına Sahip Ürünler"	\
	3 "Toplam Ürün Değeri")

case $RAPOR_TURU in
    1)	ESIK=$(zenity --entry --title="Eşik Değeri" --text="Eşik stok miktarını girin:")
        awk -F"," -v esik=$ESIK '$4 < esik {print $0}' csvFiles/depo.csv | zenity --text-info --title="Stoğu Azalan Ürünler"
        ;;
    2)	ESIK=$(zenity --entry --title="Eşik Değeri" --text="Eşik stok miktarını girin:")
        awk -F"," -v esik=$ESIK '$4 > esik {print $0}' csvFiles/depo.csv | zenity --text-info --title="En Yüksek Stok Miktarına Sahip Ürünler"
        ;;
	3)	total=$(awk -F"," '{total_value += $4 * $5} END {print total_value}' csvFiles/depo.csv)
    	zenity --info --title="Toplam Değer" --text="Tüm ürünlerin toplam değeri: $total ₺"
    	;;
    *)	zenity --error --text="Geçersiz seçim."	
		;;
esac

