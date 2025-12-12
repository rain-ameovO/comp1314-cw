#!/bin/bash

db_name="crypto_db"
table_name="crypto_rate"

bnb_url="https://coinmarketcap.com/currencies/bnb/"
temp_file="bnb_price.html"
curl -s "$bnb_url" > "$temp_file"

if [ $? -ne 0 ]; then
        echo "Failed to fetch website. Please check if the network or the website is down."
        exit 1
    fi

price=$(grep -oP '<span class="sc-65e7f566-0 WXGwg base-text" data-test="text-cdp-price-display">\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)
low_price=$(grep -oP 'label">Low</div><span>\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)
high_price=$(grep -oP 'label">High</div><span>\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)

price=${price//,/}
low_price=${low_price//,/}
high_price=${high_price//,/}
current_time="`date "+%Y-%m-%d %H:%M:%S"`"

if [ -z "$price" ] || [ -z "$low_price" ] || [ -z "$high_price" ] ; then
        echo "Failed to get Binance Coin price."
	exit 1
    fi

/opt/lampp/bin/mysql -u root -D "$db_name" -e \
"INSERT INTO $table_name (api_id, price, price_time, low_price, high_price) VALUES ('binancecoin', '$price', NOW(), '$low_price', '$high_price');"

if [ $? -ne 0 ]; then
        echo "Failed to insert data into database."
        exit 1
    fi

echo "| $current_time | Binance Coin price: $ $price | 24H Low: $ $low_price | 24H High: $high_price |"

rm "$temp_file"
