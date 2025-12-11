#!/bin/bash

db_name="crypto_db"
table_name="crypto_rate"

bitcoin_url="https://www.coindesk.com/price/bitcoin"
temp_file="bitcoin_price.html"
curl -s "$bitcoin_url" > "$temp_file"

price=$(grep -oP '\$<!-- -->\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)
price=$(echo "$price" | tr -d ',')
current_time="`date "+%Y-%m-%d %H:%M:%S"`"

/opt/lampp/bin/mysql -u root -D "$db_name" -e \
"INSERT INTO $table_name (api_id, price, price_time) VALUES ('bitcoin', '$price', NOW());"

echo "| $current_time | Bitcoin price: Price=$price |"
