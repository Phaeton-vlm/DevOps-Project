#!/bin/bash

currency_table=$( curl https://myfin.by/currency/minsk | grep -n '<div class="c-best-rates">' | grep -Eo '<tbody>.*</tbody>' )

function show_cur {
	array=$(echo "${currency_table}" | awk -F "<tr>" '{ print $('$1') }' | sed -E "s/<sup> [0-9]*? <\/sup>//" | grep -Eo [0-9]*?\\.?[0-9]*? )
	echo -n "Покупка: "
       	echo ${array} | awk '{print $1}'
	echo -n "Продажа: "
        echo ${array} | awk '{print $2}'
	echo -n "НБ РБ: "
	echo ${array} | awk '{print $3}'
}

PS3="Select the currency: "

select opt in usd eur rub pln uah quit; do

	case $opt in
		usd)
			echo "Доллар (USD):"
			show_cur 2
		;;
		eur)
			echo "Евро (EUR):"
			show_cur 3
		;;
		rub)
			echo "Российский рубль (RUB):"
			show_cur 4
		;;
		pln)
			echo "Польский злотый (PLN):"
			show_cur 5
		;;
		uah)
			echo "Гривна (UAH):"
			show_cur 6
		;;
		quit)
			break
		;;
		*)
			echo "Invalid currency $REPLY"
		;;	
		esac
done

