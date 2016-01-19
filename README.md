---
title: もうひとつのBluetooth Low Energy IC でLEDを光らせる本
author: "@_K4ZUKI_"
date: C90/2016
documentclass: book
papersize: b5paper
comiket: "C90"
year: "2016"
publisher: "近所のコンビニ"
localfontdir:  ExternalLocation=/home/yamamoto/.local/share/fonts/
mainfont: RictyDiminished-Regular
sansfont: RictyDiminished-Regular
monofont: RictyDiminished-Regular
mainlang: Japanese
CJKoptions: BoldFont=RictyDiminished-Bold,ItalicFont=RictyDiminished-Oblique
CJKmainfont: RictyDiminished-Regular
CJKsansfont: RictyDiminished-Regular
CJKmonofont: RictyDiminished-Regular
geometry: top=30truemm,bottom=30truemm,left=20truemm,right=20truemm
keywords: keyword
...

<!--
localfontdir: ExternalLocation=/usr/local/texlive/2015basic/texmf-local/
`pinout.txt`{.include}
-->

# まえがき
このドキュメントは、Dialog社のBluetooth Low Energy IC `DA14580` を使った作品で、
*Lチカをするにはどうすればよいか* を解説する本です。  

Bluetooth(R) Low Energy ないしはBLEの機能を持ったIoTデバイスに採用されるICというとTI社とNordic社、
さらにはKoshian^[] に採用されたBroadcom社の名前が挙がりますが、
この本では、_筆者の個人的な理由_ からDialog Semiconductor社の
BLE ICであるDA1458xシリーズ^[DA14580/1/2/3 ただし582/3は2016年1月現在DigiKey.jpのリストに挙がっていない] の
`DA14580`に注目し、同ICを採用しFCC/IC/TELEC認証を取得した村田製作所の
アンテナ内蔵モジュール^[]
を試食しました。

この本は、DA14580と開発環境の簡単な解説、mbed^TM^にバイナリ書き込みアプリを実装する例の紹介、村田モジュールを載せた基板の設計、mbed風のドラッグ・アンド・ドロップ書き込みの実現、そして最後にLEDを光らせるオチで構成されています。
