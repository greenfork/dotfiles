#!/bin/env elvish

filename=/home/grfork/.cache/currency_rates.json
fn download-currency-rates {
  curl -s 'http://www.floatrates.com/daily/rub.json' > $filename
}
if ?(test ! -r $filename) { download-currency-rates }
@filename-stats=(splits ' ' (stat --format=%y $filename))

if (!= (date +%H) $filename-stats[1][0:2]) {
  download-currency-rates
}

rates=(cat $filename | from-json)
fn get-rate [cur]{
  put (to-string $rates[$cur][inverseRate])[0:5]
}

echo (get-rate usd)'$ | '(get-rate eur)'€'
