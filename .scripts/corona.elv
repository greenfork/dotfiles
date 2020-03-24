#!/bin/env elvish

filename=/home/grfork/.cache/corona.json
fn download-corona {
  curl -s 'https://corona-stats.online/RU?format=json' > $filename
}
if ?(test ! -r $filename) { download-corona }
@filename-stats=(splits ' ' (stat --format=%y $filename))

if (!=s $filename-stats[0] (date --iso-8601=date)) {
  download-corona
}

ru=(cat $filename | from-json)[0]
cbd=$ru[confirmedByDay]
todayCases=(- $cbd[(- (count $cbd) 1)] $cbd[(- (count $cbd) 2)])

echo $ru[confirmed]" Σ | "$todayCases' ▲ | '$ru[deaths]' ☠'
