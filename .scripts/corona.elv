#!/bin/env elvish

filename=/home/grfork/.cache/corona.json
fn download-corona {
  curl -s 'https://corona-stats.online/RU?format=json' > $filename
}
if ?(test ! -r $filename) { download-corona }
@filename-stats=(splits ' ' (stat --format=%y $filename))

if (!= (date +%H) $filename-stats[1][0:2]) {
  download-corona
}

try {
  # source 1
  ru=(cat $filename | from-json)[0]
  cbd=$ru[confirmedByDay]
  todayCases=(- $cbd[(- (count $cbd) 1)] $cbd[(- (count $cbd) 2)])

  echo $ru[confirmed]" Σ | "$todayCases' ▲ | '$ru[deaths]' ☠'
} except e {
  try {
    # source 2
    ru=(cat $filename | from-json)[data][0]

    echo $ru[active]" Σ | "$ru[todayCases]' ▲ | '$ru[deaths]' ☠'
  } except e {
    echo $e
  }
}
