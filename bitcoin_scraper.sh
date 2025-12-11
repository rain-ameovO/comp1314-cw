#!/bin/bash

db_name="crypto_db"
table_name="crypto_rate"

bitcoin_url="https://coinmarketcap.com/currencies/bitcoin/"
temp_file="bitcoin_price.html"
curl -s "$bitcoin_url" > "$temp_file"

price=$(grep -oP 'Bitcoin</span><span class="sc-65e7f566-0 jMQNfO base-text">\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)
low_price=$(grep -oP 'label">Low</div><span>\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)
high_price=$(grep -oP 'label">High</div><span>\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)

price=${price//,/}
low_price=${low_price//,/}
high_price=${high_price//,/}
current_time="`date "+%Y-%m-%d %H:%M:%S"`"

/opt/lampp/bin/mysql -u root -D "$db_name" -e \
"INSERT INTO $table_name (api_id, price, price_time, low_price, high_price) VALUES ('bitcoin', '$price', NOW(), '$low_price', '$high_price');"

echo "| $current_time | Bitcoin price: $ $price | 24H Low: $ $low_price | 24H High: $high_price |"
