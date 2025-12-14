#!/bin/bash

db_name="crypto_db"
data_file="bnb.txt"
graph_file="bnb_price.png"

# Get data from sql and insert into a text file
# Set time format to prevent plotting time over date instead of price over time
/opt/lampp/bin/mysql -u root -D "$db_name" -e \
"SELECT DATE_FORMAT(price_time,'%Y-%m-%d_%H:%i:%s'), price FROM crypto_rate WHERE api_id='binancecoin' ORDER BY price_time;" \
--batch --skip-column-names > "$data_file"

# Check if there is any data 
if [ ! -s "$data_file" ]; then
    echo "There is no price data for Binance Coin"
    exit 1
fi

# Graph plotting
gnuplot << EOF
set terminal png size 1000,600
set output "$graph_file"

set title "Binance Coin Price Over Time"
set xlabel "Time"
set ylabel "Binance Coin Price (USD)"

set xdata time
set timefmt "%Y-%m-%d_%H:%M:%S"
set format x "%m-%d\n%H:%M"
set grid

plot "$data_file" using 1:2 with lines linewidth 2 title "Binance Coin Price"
EOF

echo "Binance Coin Price graph has created"
