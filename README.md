---
title: もうひとつのBluetooth Low Energy ICでLEDを光らせる本
author: "@_K4ZUKI_"
date: C90/2016
documentclass: book
papersize: b5paper
comiket: "C90"
year: "2016"
publisher: "近所のコンビニ"
localfontdir: ExternalLocation=/usr/local/texlive/2015basic/texmf-local/
mainfont: RictyDiminished-Regular
sansfont: RictyDiminished-Regular
monofont: RictyDiminished-Regular
mainlang: Japanese
CJKoptions: BoldFont=RictyDiminished-Bold,
  ItalicFont=RictyDiminished-Oblique,
  BoldItalicFont=RictyDiminished-BoldOblique
CJKmainfont: RictyDiminished-Regular
CJKsansfont: RictyDiminished-Regular
CJKmonofont: RictyDiminished-Regular
geometry: top=30truemm,bottom=30truemm,left=20truemm,right=20truemm
keywords: keyword
secPrefix: Chapter
linkcolor: black
urlcolor: black
citecolor: black
chapter: true
listings: true
codeBlockCaptions: true
listingTitle: 'List'
listingTemplate: '---**$$listingTitle$$ $$i$$$$titleDelim$$ $$t$$**---'
...

<!--
localfontdir: ExternalLocation=/home/yamamoto/.local/share/fonts/
`pinout.txt`{.include}
-->

# まえがき {.unnumbered}
このドキュメントは、Dialog社のBluetooth Low Energy IC `DA14580` を使った作品で、
*Lチカをするにはどうすればよいか* を解説する本です。  

Bluetooth(R) Low Energy ないしはBLEの機能を持ったIoTデバイスに採用されるICというと
TI社とNordic社、
さらにはKoshian^[www.m-pression.com/ja/solutions/boards/koshian]\
に採用されたBroadcom社の名前が挙がりますが、
この本では、_筆者の個人的な理由_ からDialog Semiconductor社の
BLE ICであるDA1458xシリーズ\
^[DA14580/1/2/3 ただし582は2016年4月現在DigiKey.jpのリストに挙がっていない] の
`DA14580`に注目し、同ICを採用しFCC/IC/TELEC認証を取得した村田製作所の
アンテナ内蔵モジュール[^0.3.4]
を試食しました。

この本は、DA14580と開発環境の簡単な解説、mbed^TM^LPC1768にバイナリ書き込みアプリ
を実装する例の紹介、
村田モジュールを載せた基板の設計、mbed風のドラッグ・アンド・ドロップ書き込みの
実現、そして最後にLEDを光らせるオチで構成されています。

`0.2_who_would_read_this.md`{.include}
`0.3_warnings.md`{.include}
`0.4_references.md`{.include}
`1.0_da14580more_detail.md`{.include}
`2.0_DevelopEnvironment.md`{.include}
`2.1_ArmCoreEnv.md`{.include}
`2.2_DialogSmartSnippets.md`{.include}
`2.3_use_mbed.md`{.include}
`3.1_MyBestIdea.md`{.include}
`4.1_i_made_it.md`{.include}
`8.1_Appendix.md`{.include}
`9.9_tail.md`{.include}
