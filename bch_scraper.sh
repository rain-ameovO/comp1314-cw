#!/bin/bash

db_name="crypto_db"
table_name="crypto_rate"

bch_url="https://coinmarketcap.com/currencies/bitcoin-cash/"
temp_file="bch_price.html"
curl -s "$bch_url" > "$temp_file" # Curl website and save to a temporary file

# Check if network and website is available
if [ $? -ne 0 ]; then
        echo "Failed to fetch website. Please check if the network or the website is down."
        exit 1
    fi

# Collect data
price=$(grep -oP '<span class="sc-65e7f566-0 WXGwg base-text" data-test="text-cdp-price-display">\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)
low_price=$(grep -oP 'label">Low</div><span>\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)
high_price=$(grep -oP 'label">High</div><span>\$\K[0-9,]+\.[0-9]+' "$temp_file" | head -n 1)

# Remove ',' from the data
price=${price//,/}
low_price=${low_price//,/}
high_price=${high_price//,/}
current_time="`date "+%Y-%m-%d %H:%M:%S"`"

# Check if all data is colected
if [ -z "$price" ] || [ -z "$low_price" ] || [ -z "$high_price" ] ; then
        echo "Failed to get Bitcoin-Cash price."
	exit 1
    fi

# Insert data into sql table
/opt/lampp/bin/mysql -u root -D "$db_name" -e \
"INSERT INTO $table_name (api_id, price, price_time, low_price, high_price) VALUES ('bitcoincash', '$price', NOW(), '$low_price', '$high_price');"

# Check if data is successfully inserted into the table
if [ $? -ne 0 ]; then
        echo "Failed to insert data into database."
        exit 1
    fi

echo "| $current_time | Bitcoin-Cash price: $ $price | 24H Low: $ $low_price | 24H High: $ $high_price |"

# Remove temporary file
rm -f "$temp_file"
