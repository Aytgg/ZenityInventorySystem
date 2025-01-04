#!/bin/bash

RAPOR_TURU=$(zenity --list --title="Rapor Türü Seçin"	\
    --column="ID" --column="Rapor Türü"					\
    1 "Stoğu Azalan Ürünler"	\
    2 "En Yüksek Stok Miktarına Sahip Ürünler")

case $RAPOR_TURU in
    1)	ESIK=$(zenity --entry --title="Eşik Değeri" --text="Eşik stok miktarını girin:")
        awk -F"," -v esik=$ESIK '$4 < esik {print $0}' csvFiles/depo.csv | zenity --text-info --title="Stoğu Azalan Ürünler"
        ;;
    2)	ESIK=$(zenity --entry --title="Eşik Değeri" --text="Eşik stok miktarını girin:")
        awk -F"," -v esik=$ESIK '$4 > esik {print $0}' csvFiles/depo.csv | zenity --text-info --title="En Yüksek Stok Miktarına Sahip Ürünler"
        ;;
    *)	zenity --error --text="Geçersiz seçim."	
		;;
esac

