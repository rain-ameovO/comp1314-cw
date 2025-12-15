# comp1314-cw
- While collecting the data, make sure that the mysql is opened
- Use crontab -e to collect the data hourly. The code for crontab:
- 0 * * * * /bin/bash /home/xx/bitcoin_scraper.sh >> /home/xx/crypto_log.txt
- 1 * * * * /bin/bash /home/xx/ethereum_scraper.sh >> /home/xx/crypto_log.txt
- 2 * * * * /bin/bash /home/xx/bnb_scraper.sh >> /home/xx/crypto_log.txt
- 3 * * * * /bin/bash /home/xx/solana_scraper.sh >> /home/xx/crypto_log.txt
- 4 * * * * /bin/bash /home/xx/bch_scraper.sh >> /home/xx/crypto_log.txt
